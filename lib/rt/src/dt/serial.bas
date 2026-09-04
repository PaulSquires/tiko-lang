'' serial.bas -- the calendar core: leap years, normalisation, the serial
'' encode/decode pair, and the week arithmetic built on them.
'' Twenty-one entry points over six fbc members.
''
'' Everything here is pure integer and double arithmetic. There is no
'' allocation, no descriptor and no OS call, so the only way to be wrong is to
'' get a rule wrong -- and there are five that do not look like rules:
''
''   THE EPOCH IS 1899-12-30. The encoder seeds its accumulator with 2 for
''   1900-01-01 and the decoder subtracts the same 2 before walking. Change
''   either and every date shifts by two days while still round-tripping
''   perfectly, so unit tests would stay green and only a differential notices.
''
''   hSign HAS NO ZERO. fb.h defines it as `x < 0 ? -1 : 1`, so sign(0) is 1.
''   fb_hGetWeekOfYear adds that sign to the week quotient, which is how a date
''   inside the first week comes out as week 1 rather than week 0.
''
''   EVERY double -> int CONVERSION HERE TRUNCATES, because C casts truncate.
''   FreeBASIC's implicit narrowing ROUNDS instead, so each one is written
''   through fix() explicitly. An implicit conversion would be off by one for
''   half the inputs and right for the other half -- the worst failure shape.
''
''   THE DECODER'S EPSILON IS PART OF THE CONTRACT. fb_hTimeDecodeSerial nudges
''   by 1e-9 before splitting, or 0.5 decodes as 11:59:59 on a double one ULP
''   short. It is not defensive; the answers depend on it.
''
''   THE QB HACK APPLIES ONLY TO A NEGATIVE FRACTION WITH A ZERO INTEGER PART.
''   -0.25 reflects to +0.25 (06:00:00); -1.25 wraps to +0.75 (18:00:00). Two
''   negative inputs, two rules, chosen by whether the truncated part is zero.

#include once "inc/descriptors.bi"
#include once "inc/dt.bi"
#include once "crt/string.bi"
#include once "crt/math.bi"

extern "c"   '' NON-FBCALL: fb_datetime.h declares these plain; win32 must not decorate.
declare function tkrt_TimeLeap alias "fb_hTimeLeap" ( byval year as long ) as long
declare function tkrt_TimeDaysInMonth alias "fb_hTimeDaysInMonth" _
	( byval month as long, byval year as long ) as long
declare sub tkrt_NormalizeDate alias "fb_hNormalizeDate" _
	( byval pDay as long ptr, byval pMonth as long ptr, byval pYear as long ptr )
declare sub tkrt_GetBeginOfWeek alias "fb_hGetBeginOfWeek" _
	( byval pYear as long ptr, byval pMonth as long ptr, byval pDay as long ptr, _
	  byval first_day_of_week as long )
declare function tkrt_GetFirstWeekOfYear alias "fb_hGetFirstWeekOfYear" _
	( byval year as long, byval first_day_of_year as long, _
	  byval first_day_of_week as long ) as double
end extern

'' FBCALL: the ones fbc's codegen emits calls to.
extern "rtlib"
declare function tkrt_DateSerial alias "fb_DateSerial" _
	( byval year as long, byval month as long, byval day_ as long ) as long
declare sub tkrt_DateDecodeSerial alias "fb_hDateDecodeSerial" _
	( byval serial as double, byval pYear as long ptr, _
	  byval pMonth as long ptr, byval pDay as long ptr )
declare function tkrt_FIXDouble alias "fb_FIXDouble" ( byval x as double ) as double
declare sub tkrt_TimeDecodeSerial alias "fb_hTimeDecodeSerial" _
	( byval serial as double, byval pHour as long ptr, _
	  byval pMinute as long ptr, byval pSecond as long ptr, _
	  byval use_qb_hack as long )
declare function tkrt_Weekday alias "fb_Weekday" _
	( byval serial as double, byval first_day_of_week as long ) as long
end extern

'' ------------------------------------------------------- leap and lengths

extern "c"   '' NON-FBCALL: helpers, not entry points.

function tkort_TimeLeap alias "fb_hTimeLeap" ( byval year as long ) as long
	if( (year mod 400) = 0 ) then return 1
	if( (year mod 100) = 0 ) then return 0
	'' `year and 3`, not `mod 4`: for a negative year C's mod gives a
	'' negative remainder and never matches 0, but the bitwise test still
	'' identifies multiples of four. Keep the AND.
	if( (year and 3) = 0 ) then return 1
	return 0
end function

function tkort_TimeDaysInMonth alias "fb_hTimeDaysInMonth" _
	( byval month as long, byval year as long ) as long
	static as long days(0 to 11) = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }
	if( month = 2 ) then return days(month - 1) + tkrt_TimeLeap( year )
	return days(month - 1)
end function

'' Carries an out-of-range day or month into the neighbouring month or year.
'' The two directions are NOT symmetric: going forward the month length is
'' known before the loop, going backward the month must be stepped first,
'' because which length applies depends on where you land.
sub tkort_NormalizeDate alias "fb_hNormalizeDate" _
	( byval pDay as long ptr, byval pMonth as long ptr, byval pYear as long ptr )

	dim as long day_ = *pDay, month = *pMonth, year = *pYear
	dim as long sub_months = any, sub_years = any, sub_days = any, dom = any

	if( month < 1 ) then
		sub_months = -month + 1
		sub_years = (sub_months + 11) \ 12
		year -= sub_years
		month = sub_years * 12 - sub_months + 1
	else
		month -= 1
		year += month \ 12
		month mod= 12
		month += 1
	end if

	if( day_ < 1 ) then
		sub_days = -day_ + 1
		while( sub_days > 0 )
			month -= 1
			if( month = 0 ) then
				month = 12
				year -= 1
			end if
			dom = tkrt_TimeDaysInMonth( month, year )
			if( sub_days > dom ) then
				sub_days -= dom
			else
				day_ = dom - sub_days + 1
				sub_days = 0
			end if
		wend
	else
		dom = tkrt_TimeDaysInMonth( month, year )
		while( day_ > dom )
			day_ -= dom
			month += 1
			if( month = 13 ) then
				month = 1
				year += 1
			end if
			dom = tkrt_TimeDaysInMonth( month, year )
		wend
	end if

	*pDay = day_ : *pMonth = month : *pYear = year
end sub

'' The interval spelling used by DATEADD / DATEPART / DATEDIFF. Compared with
'' strcmp against the descriptor's data pointer directly -- no FB_STRSETUP, so
'' a fixed-length or zstring argument is not accepted here, and the temp is
'' NOT freed. Both match fbc; the callers own the string.
function tkort_TimeGetIntervalType alias "fb_hTimeGetIntervalType" _
	( byval interval as FBSTRING ptr ) as long

	if( interval = 0 ) then return FB_TIME_INTERVAL_INVALID
	if( interval->data = 0 ) then return FB_TIME_INTERVAL_INVALID

	dim as zstring ptr s = interval->data
	if( strcmp( s, @"yyyy" ) = 0 ) then return FB_TIME_INTERVAL_YEAR
	if( strcmp( s, @"q"    ) = 0 ) then return FB_TIME_INTERVAL_QUARTER
	if( strcmp( s, @"m"    ) = 0 ) then return FB_TIME_INTERVAL_MONTH
	if( strcmp( s, @"y"    ) = 0 ) then return FB_TIME_INTERVAL_DAY_OF_YEAR
	if( strcmp( s, @"d"    ) = 0 ) then return FB_TIME_INTERVAL_DAY
	if( strcmp( s, @"w"    ) = 0 ) then return FB_TIME_INTERVAL_WEEKDAY
	if( strcmp( s, @"ww"   ) = 0 ) then return FB_TIME_INTERVAL_WEEK_OF_YEAR
	if( strcmp( s, @"h"    ) = 0 ) then return FB_TIME_INTERVAL_HOUR
	if( strcmp( s, @"n"    ) = 0 ) then return FB_TIME_INTERVAL_MINUTE
	if( strcmp( s, @"s"    ) = 0 ) then return FB_TIME_INTERVAL_SECOND
	return FB_TIME_INTERVAL_INVALID
end function

end extern

'' ------------------------------------------------------------ encode

extern "rtlib"

'' Days since 1899-12-30. The 2 is the epoch offset, not a fudge: with
'' cur_year/cur_month/cur_day seeded at 1900-01-01, result must already be 2
'' before anything is added.
function tkort_DateSerial alias "fb_DateSerial" _
	( byval year as long, byval month as long, byval day_ as long ) as long

	dim as long result = 2
	dim as long cur_year = FB_DT_BASE_YEAR, cur_month = 1, cur_day = 1

	tkrt_NormalizeDate( @day_, @month, @year )

	if( cur_year < year ) then
		while( cur_year <> year )
			result += TKORT_DAYSINYEAR( cur_year )
			cur_year += 1
		wend
	else
		while( cur_year <> year )
			cur_year -= 1
			result -= TKORT_DAYSINYEAR( cur_year )
		wend
	end if

	while( cur_month <> month )
		result += tkrt_TimeDaysInMonth( cur_month, year )
		cur_month += 1
	wend

	return result + day_ - cur_day
end function

function tkort_TimeSerial alias "fb_TimeSerial" _
	( byval hour as long, byval minute as long, byval second as long ) as double
	'' Three separate divisions, summed -- NOT (h*3600+m*60+s)/86400. The
	'' two disagree in the last ULP, and DATEDIFF compares these values.
	dim as double dblHour   = 1.0 * cdbl( hour ) / 24.0
	dim as double dblMinute = 1.0 * minute / (24.0 * 60.0)
	dim as double dblSecond = 1.0 * second / (24.0 * 60.0 * 60.0)
	return dblHour + dblMinute + dblSecond
end function

'' ------------------------------------------------------------ decode

'' Walks year by year, then month by month, from 1900. Any of the three
'' outputs may be NULL, and the month loop is SKIPPED ENTIRELY when both month
'' and day are unwanted -- so fb_Year is cheaper, and, more importantly, still
'' correct with serial left holding the day-of-year remainder.
sub tkort_DateDecodeSerial alias "fb_hDateDecodeSerial" _
	( byval serial as double, byval pYear as long ptr, _
	  byval pMonth as long ptr, byval pDay as long ptr )

	dim as long tmp_days = any
	dim as long cur_year = FB_DT_BASE_YEAR, cur_month = 1, cur_day = 1

	serial = floor( serial )
	serial -= 2

	while( serial < 0 )
		cur_year -= 1
		serial += TKORT_DAYSINYEAR( cur_year )
	wend

	tmp_days = TKORT_DAYSINYEAR( cur_year )
	while( serial >= tmp_days )
		serial -= tmp_days
		cur_year += 1
		tmp_days = TKORT_DAYSINYEAR( cur_year )
	wend

	if( (pMonth <> 0) orelse (pDay <> 0) ) then
		tmp_days = tkrt_TimeDaysInMonth( cur_month, cur_year )
		while( serial >= tmp_days )
			serial -= tmp_days
			cur_month += 1
			tmp_days = tkrt_TimeDaysInMonth( cur_month, cur_year )
		wend
	end if

	cur_day += clng( fix( serial ) )

	if( pYear  <> 0 ) then *pYear  = cur_year
	if( pMonth <> 0 ) then *pMonth = cur_month
	if( pDay   <> 0 ) then *pDay   = cur_day
end sub

function tkort_Year alias "fb_Year" ( byval serial as double ) as long
	dim as long year = any
	tkrt_DateDecodeSerial( serial, @year, 0, 0 )
	return year
end function

function tkort_Month alias "fb_Month" ( byval serial as double ) as long
	dim as long month = any
	tkrt_DateDecodeSerial( serial, 0, @month, 0 )
	return month
end function

function tkort_Day alias "fb_Day" ( byval serial as double ) as long
	dim as long day_ = any
	tkrt_DateDecodeSerial( serial, 0, 0, @day_ )
	return day_
end function

'' 1 = Sunday .. 7 = Saturday, then rotated so first_day_of_week becomes 1.
function tkort_Weekday alias "fb_Weekday" _
	( byval serial as double, byval first_day_of_week as long ) as long

	dim as long dow = (clng( fix( floor( serial ) - 1 ) ) mod 7) + 1

	if( first_day_of_week = FB_WEEK_DAY_SYSTEM ) then
		'' fbc has the same FIXME: the system's first day is never queried.
		first_day_of_week = FB_WEEK_DAY_DEFAULT
	end if

	dow -= first_day_of_week - 1
	if( dow < 1 ) then
		dow += 7
	elseif( dow > 7 ) then
		dow -= 7
	end if
	return dow
end function

end extern

'' ------------------------------------------------------- time of day

extern "rtlib"

'' Splits a serial's fractional part into h:m:s. use_qb_hack selects between
'' two different treatments of a negative fraction; see the header comment.
sub tkort_TimeDecodeSerial alias "fb_hTimeDecodeSerial" _
	( byval serial as double, byval pHour as long ptr, _
	  byval pMinute as long ptr, byval pSecond as long ptr, _
	  byval use_qb_hack as long )

	dim as long hour = any, minute = any, second = any
	dim as double dblFixValue = tkrt_FIXDouble( serial )

	serial -= dblFixValue
	if( TKORT_HSIGN( serial ) = -1 ) then
		if( use_qb_hack <> 0 ) then
			'' Both 0.0 and -0.0 -- an FPU may produce either, and `=`
			'' says they are equal, but the sign bit differs. Written as
			'' two comparisons to match fbc exactly.
			if( (dblFixValue = 0.0) orelse (dblFixValue = -0.0) ) then
				serial = -serial       '' QB reflects
			else
				serial += 1.0          '' everything else wraps
			end if
		else
			serial += 1.0
		end if
	end if

	'' Not defensive: 0.5 is one ULP short of noon without it.
	serial += 0.000000001

	serial *= 24.0
	hour = clng( fix( serial ) )
	serial -= hour
	serial *= 60.0
	minute = clng( fix( serial ) )
	serial -= minute
	serial *= 60.0
	second = clng( fix( serial ) )

	if( pHour   <> 0 ) then *pHour   = hour
	if( pMinute <> 0 ) then *pMinute = minute
	if( pSecond <> 0 ) then *pSecond = second
end sub

function tkort_Hour alias "fb_Hour" ( byval serial as double ) as long
	dim as long hour = any
	tkrt_TimeDecodeSerial( serial, @hour, 0, 0, 1 )
	return hour
end function

function tkort_Minute alias "fb_Minute" ( byval serial as double ) as long
	dim as long minute = any
	tkrt_TimeDecodeSerial( serial, 0, @minute, 0, 1 )
	return minute
end function

function tkort_Second alias "fb_Second" ( byval serial as double ) as long
	dim as long second = any
	tkrt_TimeDecodeSerial( serial, 0, 0, @second, 1 )
	return second
end function

end extern

'' --------------------------------------------------------- day of year

extern "c"   '' NON-FBCALL: fb_hGetDayOfYear* are helpers.

function tkort_GetDayOfYearEx alias "fb_hGetDayOfYearEx" _
	( byval year as long, byval month as long, byval day_ as long ) as long
	dim as long result = 0, cur_month = 1
	while( cur_month <> month )
		result += tkrt_TimeDaysInMonth( cur_month, year )
		cur_month += 1
	wend
	return result + day_
end function

function tkort_GetDayOfYear alias "fb_hGetDayOfYear" ( byval serial as double ) as long
	dim as long year = any, month = any, day_ = any
	tkrt_DateDecodeSerial( serial, @year, @month, @day_ )
	return tkort_GetDayOfYearEx( year, month, day_ )
end function

end extern

'' ------------------------------------------------------------- weeks

'' All four take a *reference year* separate from the serial being asked
'' about. That is deliberate: DATEPART("ww") on 2021-01-01 with a four-day
'' rule reports week 53 OF 2020, and the only way to express that is to ask
'' about a serial while anchoring the week numbering to another year.

extern "c"   '' NON-FBCALL: the week helpers are internal to DATEPART/DATEDIFF.

'' Rewinds a date to the first day of its week, in place.
sub tkort_GetBeginOfWeek alias "fb_hGetBeginOfWeek" _
	( byval pYear as long ptr, byval pMonth as long ptr, byval pDay as long ptr, _
	  byval first_day_of_week as long )

	dim as double serial = tkrt_DateSerial( *pYear, *pMonth, *pDay )
	dim as long weekday = tkrt_Weekday( serial, first_day_of_week )
	serial -= weekday - 1
	tkrt_DateDecodeSerial( serial, pYear, pMonth, pDay )
end sub

'' The serial on which week 1 of `year` begins, under the chosen rule.
'' Note this can land in DECEMBER OF THE PREVIOUS YEAR -- that is the whole
'' point of the FOUR_DAYS and FULL_WEEK rules, and callers must not clamp it.
function tkort_GetFirstWeekOfYear alias "fb_hGetFirstWeekOfYear" _
	( byval year as long, byval first_day_of_year as long, _
	  byval first_day_of_week as long ) as double

	dim as long first_week_year = any, first_week_month = any, first_week_day = any
	dim as double serial_week_begin = any, serial_year_begin = any
	dim as long remaining_weekdays = any

	if( first_day_of_year = FB_WEEK_FIRST_SYSTEM ) then
		'' fbc has the same FIXME here; the system is never queried.
		first_day_of_year = FB_WEEK_FIRST_DEFAULT
	end if

	serial_year_begin = tkrt_DateSerial( year, 1, 1 )

	first_week_day = 1 : first_week_month = 1 : first_week_year = year
	tkrt_GetBeginOfWeek( @first_week_year, @first_week_month, @first_week_day, _
	                     first_day_of_week )

	serial_week_begin = tkrt_DateSerial( first_week_year, first_week_month, first_week_day )
	remaining_weekdays = clng( fix( (serial_week_begin + 7.0) - serial_year_begin ) )

	select case first_day_of_year
	case FB_WEEK_FIRST_JAN_1
		'' Week 1 always starts in the week containing Jan 1. Nothing to do.
	case FB_WEEK_FIRST_FOUR_DAYS
		if( remaining_weekdays < 4 ) then serial_week_begin += 7.0
	case FB_WEEK_FIRST_FULL_WEEK
		if( remaining_weekdays < 7 ) then serial_week_begin += 7.0
	end select

	return serial_week_begin
end function

function tkort_GetWeekOfYear alias "fb_hGetWeekOfYear" _
	( byval ref_year as long, byval serial as double, _
	  byval first_day_of_year as long, byval first_day_of_week as long ) as long

	dim as long sign_ = any, year = any, week = any
	dim as double serial_first_week = any

	'' Decoded but unused -- fbc computes it and then ignores it. Kept so
	'' the call sequence matches; it costs one decode and hides nothing.
	tkrt_DateDecodeSerial( serial, @year, 0, 0 )

	serial_first_week = tkrt_GetFirstWeekOfYear( ref_year, first_day_of_year, first_day_of_week )

	serial = floor( serial - serial_first_week )
	'' Sign first, THEN divide: adding it after the division would round a
	'' negative offset the wrong way. And sign(0) is 1, so a date in week 1
	'' comes out 1.
	sign_ = TKORT_HSIGN( serial )
	serial /= 7.0
	week = clng( fix( serial + sign_ ) )

	return week
end function

function tkort_GetWeeksOfYear alias "fb_hGetWeeksOfYear" _
	( byval ref_year as long, byval first_day_of_year as long, _
	  byval first_day_of_week as long ) as long
	dim as double serial_start = tkrt_GetFirstWeekOfYear( ref_year, first_day_of_year, first_day_of_week )
	dim as double serial_end   = tkrt_GetFirstWeekOfYear( ref_year + 1, first_day_of_year, first_day_of_week )
	return clng( fix( (serial_end - serial_start) / 7.0 ) )
end function

end extern
