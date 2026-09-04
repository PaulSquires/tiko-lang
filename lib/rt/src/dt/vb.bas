'' vb.bas -- DATEADD, DATEPART and DATEDIFF: the VB-compatible layer over the
'' calendar core in dt/serial.bas. Three entry points, and every one of them is
'' a pile of special cases rather than arithmetic.
''
'' ALL THREE CLEAR THE ERROR FIRST and set ILLEGALFUNCTIONCALL only for an
'' unrecognised interval string. A bad interval therefore returns 0 (or the
'' unmodified serial) AND sets ERR -- callers that only check the value see a
'' plausible answer, so the error is the real signal.
''
'' THE INTERVAL STRING IS NOT FREED by any of the three. fbc's codegen owns
'' the temp; deleting it here would be a double free that only shows up under
'' an allocation-count differential, never in the output.
''
'' DATEADD SATURATES THE DAY for year, quarter and month intervals, and only
'' for those. Jan 31 plus one month is Feb 28, not Mar 3 -- the day is clamped
'' to the target month's length instead of carrying. Day and time intervals do
'' NOT clamp: they are left out of range deliberately and normalised by
'' fb_DateSerial on the way out, which is what makes "+400 days" work.
''
'' DATEPART RETRIES WEEK-OF-YEAR AGAINST THE PREVIOUS YEAR when the first
'' answer comes out negative. Early January under the four-day rule belongs to
'' the last week of the year before, and asking about it with its own year
'' produces a negative week that has to be re-asked, not clamped.
''
'' DATEDIFF COUNTS BOUNDARIES CROSSED, NOT ELAPSED TIME. Two dates a minute
'' apart across midnight are one day apart. The week arms decrement each
'' week number before subtracting -- but only when positive -- so that
'' week 1 to week 1 is 0 while week 0 to week 1 is not.

#include once "inc/descriptors.bi"
#include once "inc/dt.bi"
#include once "inc/rterror.bi"
#include once "crt/math.bi"

extern "c"   '' NON-FBCALL: helpers, declared plain in fb_datetime.h.
declare function tkrt_TimeDaysInMonth alias "fb_hTimeDaysInMonth" _
	( byval month as long, byval year as long ) as long
declare function tkrt_TimeGetIntervalType alias "fb_hTimeGetIntervalType" _
	( byval interval as FBSTRING ptr ) as long
declare function tkrt_GetDayOfYearEx alias "fb_hGetDayOfYearEx" _
	( byval year as long, byval month as long, byval day_ as long ) as long
declare function tkrt_GetWeekOfYear alias "fb_hGetWeekOfYear" _
	( byval ref_year as long, byval serial as double, _
	  byval first_day_of_year as long, byval first_day_of_week as long ) as long
end extern

extern "rtlib"
declare function tkrt_ErrorSetNum alias "fb_ErrorSetNum" ( byval errnum as long ) as long
declare function tkrt_FIXDouble alias "fb_FIXDouble" ( byval x as double ) as double
declare function tkrt_DateSerial alias "fb_DateSerial" _
	( byval year as long, byval month as long, byval day_ as long ) as long
declare function tkrt_TimeSerial alias "fb_TimeSerial" _
	( byval hour as long, byval minute as long, byval second as long ) as double
declare sub tkrt_DateDecodeSerial alias "fb_hDateDecodeSerial" _
	( byval serial as double, byval pYear as long ptr, _
	  byval pMonth as long ptr, byval pDay as long ptr )
declare sub tkrt_TimeDecodeSerial alias "fb_hTimeDecodeSerial" _
	( byval serial as double, byval pHour as long ptr, _
	  byval pMinute as long ptr, byval pSecond as long ptr, _
	  byval use_qb_hack as long )
declare function tkrt_Weekday alias "fb_Weekday" _
	( byval serial as double, byval first_day_of_week as long ) as long
end extern

extern "rtlib"

function tkort_DateAdd alias "fb_DateAdd" _
	( byval interval as FBSTRING ptr, byval interval_value_arg as double, _
	  byval serial as double ) as double

	dim as long year = any, month = any, day_ = any
	dim as long hour = any, minute = any, second = any
	dim as long carry_value = any, test_value = any
	dim as long interval_value = clng( fix( tkrt_FIXDouble( interval_value_arg ) ) )
	dim as long interval_type = tkrt_TimeGetIntervalType( interval )

	tkrt_ErrorSetNum( FB_RTERROR_OK )

	'' use_qb_hack = 0 here, unlike HOUR/MINUTE/SECOND: DATEADD works on a
	'' real serial, so a negative fraction must wrap, never reflect.
	tkrt_TimeDecodeSerial( serial, @hour, @minute, @second, 0 )
	tkrt_DateDecodeSerial( serial, @year, @month, @day_ )

	select case interval_type
	case FB_TIME_INTERVAL_YEAR
		year += interval_value
	case FB_TIME_INTERVAL_QUARTER
		month += interval_value * 3
	case FB_TIME_INTERVAL_MONTH
		month += interval_value
	case FB_TIME_INTERVAL_DAY_OF_YEAR, FB_TIME_INTERVAL_DAY, FB_TIME_INTERVAL_WEEKDAY
		day_ += interval_value
	case FB_TIME_INTERVAL_WEEK_OF_YEAR
		day_ += interval_value * 7
	case FB_TIME_INTERVAL_HOUR
		hour += interval_value
	case FB_TIME_INTERVAL_MINUTE
		minute += interval_value
	case FB_TIME_INTERVAL_SECOND
		second += interval_value
	case else
		tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end select

	'' Only the month-shaped intervals normalise here. The rest are left out
	'' of range on purpose and carried by fb_DateSerial below.
	select case interval_type
	case FB_TIME_INTERVAL_YEAR, FB_TIME_INTERVAL_QUARTER, FB_TIME_INTERVAL_MONTH
		'' Two divisions, not one: for month < 1 the -12 biases the
		'' truncating division so that month 0 borrows a year instead of
		'' staying put, which plain (month-1)/12 would do.
		if( month < 1 ) then
			carry_value = (month - 12) \ 12
		else
			carry_value = (month - 1) \ 12
		end if
		year += carry_value
		month -= carry_value * 12
		'' Saturate rather than wrap -- see the header comment.
		test_value = tkrt_TimeDaysInMonth( month, year )
		if( day_ > test_value ) then day_ = test_value
	end select

	return tkrt_DateSerial( year, month, day_ ) + tkrt_TimeSerial( hour, minute, second )
end function

function tkort_DatePart alias "fb_DatePart" _
	( byval interval as FBSTRING ptr, byval serial as double, _
	  byval first_day_of_week as long, byval first_day_of_year as long ) as long

	dim as long result = 0
	dim as long year = any, month = any, day_ = any
	dim as long hour = any, minute = any, second = any
	dim as long interval_type = tkrt_TimeGetIntervalType( interval )

	tkrt_ErrorSetNum( FB_RTERROR_OK )

	select case interval_type
	case FB_TIME_INTERVAL_YEAR
		tkrt_DateDecodeSerial( serial, @year, 0, 0 )
		result = year
	case FB_TIME_INTERVAL_QUARTER
		tkrt_DateDecodeSerial( serial, 0, @month, 0 )
		result = ((month - 1) \ 3) + 1
	case FB_TIME_INTERVAL_MONTH
		tkrt_DateDecodeSerial( serial, 0, @month, 0 )
		result = month
	case FB_TIME_INTERVAL_DAY_OF_YEAR
		tkrt_DateDecodeSerial( serial, @year, @month, @day_ )
		result = tkrt_GetDayOfYearEx( year, month, day_ )
	case FB_TIME_INTERVAL_DAY
		tkrt_DateDecodeSerial( serial, 0, 0, @day_ )
		result = day_
	case FB_TIME_INTERVAL_WEEKDAY
		result = tkrt_Weekday( serial, first_day_of_week )
	case FB_TIME_INTERVAL_WEEK_OF_YEAR
		tkrt_DateDecodeSerial( serial, @year, 0, 0 )
		result = tkrt_GetWeekOfYear( year, serial, first_day_of_year, first_day_of_week )
		'' Early January can belong to the previous year's last week; the
		'' first answer then comes out negative and is RE-ASKED, not clamped.
		if( result < 0 ) then
			result = tkrt_GetWeekOfYear( year - 1, serial, first_day_of_year, first_day_of_week )
		end if
	case FB_TIME_INTERVAL_HOUR
		tkrt_TimeDecodeSerial( serial, @hour, 0, 0, 0 )
		result = hour
	case FB_TIME_INTERVAL_MINUTE
		tkrt_TimeDecodeSerial( serial, 0, @minute, 0, 0 )
		result = minute
	case FB_TIME_INTERVAL_SECOND
		tkrt_TimeDecodeSerial( serial, 0, 0, @second, 0 )
		result = second
	case else
		tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end select

	return result
end function

function tkort_DateDiff alias "fb_DateDiff" _
	( byval interval as FBSTRING ptr, byval serial1 as double, byval serial2 as double, _
	  byval first_day_of_week as long, byval first_day_of_year as long ) as longint

	dim as long year1 = any, month1 = any, year2 = any, month2 = any
	dim as long hour = any, minute = any, second = any, week = any
	dim as longint result = 0
	dim as double serial = any, serial_tmp = any
	dim as long add_value = any
	dim as long interval_type = tkrt_TimeGetIntervalType( interval )

	tkrt_ErrorSetNum( FB_RTERROR_OK )

	select case interval_type
	case FB_TIME_INTERVAL_YEAR
		tkrt_DateDecodeSerial( serial1, @year1, 0, 0 )
		tkrt_DateDecodeSerial( serial2, @year2, 0, 0 )
		result = year2 - year1

	case FB_TIME_INTERVAL_QUARTER, FB_TIME_INTERVAL_MONTH
		tkrt_DateDecodeSerial( serial1, @year1, @month1, 0 )
		tkrt_DateDecodeSerial( serial2, @year2, @month2, 0 )
		result = (month2 - month1) + (year2 - year1) * 12
		'' Quarters are months divided by three, truncating toward zero --
		'' so five months apart is one quarter, in either direction.
		if( interval_type = FB_TIME_INTERVAL_QUARTER ) then result = result \ 3

	case FB_TIME_INTERVAL_DAY_OF_YEAR, FB_TIME_INTERVAL_DAY
		'' floor on each side separately: it counts midnights crossed, so
		'' 23:59 to 00:01 is one day. Subtracting first would give zero.
		result = clngint( fix( floor( serial2 ) - floor( serial1 ) ) )

	case FB_TIME_INTERVAL_WEEKDAY, FB_TIME_INTERVAL_WEEK_OF_YEAR
		'' Both week numbers are taken against serial1's year, so the
		'' difference stays meaningful across a year boundary.
		tkrt_DateDecodeSerial( serial1, @year1, 0, 0 )
		week = tkrt_GetWeekOfYear( year1, serial1, first_day_of_year, first_day_of_week )
		result = tkrt_GetWeekOfYear( year1, serial2, first_day_of_year, first_day_of_week )
		'' Decrement each side only when positive. Week numbers skip zero
		'' (see hSign in dt/serial.bas), so this closes the gap that would
		'' otherwise make a difference spanning the origin one too large.
		if( week > 0 ) then week -= 1
		if( result > 0 ) then result -= 1
		result -= week
		if( interval_type = FB_TIME_INTERVAL_WEEKDAY ) then
			'' Order the pair, then correct by one if the weekday runs
			'' backwards across the span. The sign of the correction is
			'' decided by which way the arguments came in, NOT by the
			'' comparison -- swapping the values does not swap the answer.
			if( serial1 > serial2 ) then
				serial_tmp = serial1 : serial1 = serial2 : serial2 = serial_tmp
				add_value = 1
			else
				add_value = -1
			end if
			if( tkrt_Weekday( serial1, first_day_of_week ) > _
			    tkrt_Weekday( serial2, first_day_of_week ) ) then
				result += add_value
			end if
		end if

	case FB_TIME_INTERVAL_HOUR
		serial = serial2 - serial1
		tkrt_TimeDecodeSerial( serial, @hour, 0, 0, 0 )
		result = clngint( fix( hour + floor( serial ) * 24.0 ) )

	case FB_TIME_INTERVAL_MINUTE
		serial = serial2 - serial1
		tkrt_TimeDecodeSerial( serial, @hour, @minute, 0, 0 )
		result = clngint( fix( minute + (hour + floor( serial ) * 24.0) * 60.0 ) )

	case FB_TIME_INTERVAL_SECOND
		serial = serial2 - serial1
		tkrt_TimeDecodeSerial( serial, @hour, @minute, @second, 0 )
		result = clngint( fix( second + (minute + (hour + floor( serial ) * 24.0) * 60.0) * 60.0 ) )

	case else
		tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end select

	return result
end function

end extern
