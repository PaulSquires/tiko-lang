'' zone.bas -- timezone offsets and locale formatting: ten entry points over
'' one fbc member, split by platform.
''
'' THE OFFSET IS ASKED FOR AT AN INSTANT, NEVER "RIGHT NOW". Converting a July
'' timestamp with January's offset is the single most common timezone bug, and
'' an API that only offered the current offset would make it the path of least
'' resistance. Every function here that can take a time, does.
''
'' WINDOWS USES THE *DYNAMIC* ZONE INFORMATION, resolved at run time.
'' GetTimeZoneInformation applies TODAY'S DST rule to every year, which
'' silently misdates anything from before a rule change;
'' GetTimeZoneInformationForYear knows the historical rules. It is Windows 7
'' and MinGW only declares it above a raised _WIN32_WINNT, so it is looked up
'' through GetProcAddress rather than imported -- the same approach the clock
'' backend takes for the Windows 8 precise-time API. When it is absent the
'' static fallback still answers correctly for the CURRENT year.
''
'' UNIX GETS HISTORICAL CORRECTNESS FOR FREE, because localtime_r reads TZ and
'' /etc/localtime, which is where glibc consults the system tz database. This
'' library ships no copy of the tzdb on either platform.
''
'' THE TWO PLATFORMS NUMBER WEEKDAYS DIFFERENTLY AND BOTH ARE HANDLED HERE:
'' Windows LOCALE_SDAYNAME1 is MONDAY, which happens to match this library's
'' ISO 1..7 exactly; Unix DAY_1 and tm_wday are SUNDAY-first, so the Unix half
'' converts with `dow mod 7`. The Windows coincidence is worth naming, because
'' it looks like an omission.
''
'' LOCALE OUTPUT CANNOT BE ASSERTED BY EXACT STRING. It is whatever the
'' machine says, which is an honest limitation and exactly why the pattern
'' formatter in chrono/pattern.bas uses invariant English instead.

#include once "inc/descriptors.bi"
#include once "inc/chrono.bi"

const DT_ZONE_STYLE_SHORT = 0
const DT_ZONE_STYLE_LONG  = 1
const DT_ZONE_STYLE_FULL  = 2

const FB_DT_TICKS_TO_UNIX_EPOCH = 621355968000000000ll
const FB_DT_TICKS_TO_FILETIME   = 504911232000000000ll

extern "rtlib"
	declare function tkrt_DtIsValidTicks alias "fb_DtIsValidTicks" ( byval t as longint ) as long
	declare sub tkrt_DtToCivil alias "fb_DtToCivil" _
		( byval t as longint, byval y as long ptr, byval mo as long ptr, byval d as long ptr, _
		  byval h as long ptr, byval mi as long ptr, byval s as long ptr, byval sub_ as longint ptr )
	declare function tkrt_DtFromCivil alias "fb_DtFromCivil" _
		( byval y as long, byval mo as long, byval d as long, byval h as long, _
		  byval mi as long, byval s as long, byval sub_ as longint, byval o as longint ptr ) as long
	declare function tkrt_DtDayOfWeek alias "fb_DtDayOfWeek" ( byval days as long ) as long
	declare function tkrt_DtDayOfYear alias "fb_DtDayOfYear" ( byval y as long, byval mo as long, byval d as long ) as long
end extern

#if defined( __FB_WIN32__ ) or defined( __FB_WIN64__ )

'' ---------------------------------------------------------- Windows backend

type SYSTEMTIME_
	as ushort wYear, wMonth, wDayOfWeek, wDay, wHour, wMinute, wSecond, wMilliseconds
end type

type FILETIME_
	as ulong dwLowDateTime, dwHighDateTime
end type

type TIME_ZONE_INFORMATION_
	as long         Bias
	as wstring * 32 StandardName
	as SYSTEMTIME_  StandardDate
	as long         StandardBias
	as wstring * 32 DaylightName
	as SYSTEMTIME_  DaylightDate
	as long         DaylightBias
end type

'' The dynamic form is the static one plus a key name and a disable flag.
type DYNAMIC_TIME_ZONE_INFORMATION_
	as TIME_ZONE_INFORMATION_ tzi
	as wstring * 128          TimeZoneKeyName
	as byte                   DynamicDaylightTimeDisabled
end type

const TIME_ZONE_ID_INVALID = &hFFFFFFFFul
const CP_UTF8 = 65001
const DATE_SHORTDATE = &h00000001
const DATE_LONGDATE  = &h00000002
const TIME_NOSECONDS = &h00000002
const LOCALE_SDAYNAME1         = &h0000002a
const LOCALE_SABBREVDAYNAME1   = &h00000031
const LOCALE_SMONTHNAME1       = &h00000038
const LOCALE_SABBREVMONTHNAME1 = &h00000044

type FB_TZFORYEARPROC as function stdcall _
	( byval y as ushort, byval dtzi as DYNAMIC_TIME_ZONE_INFORMATION_ ptr, _
	  byval tzi as TIME_ZONE_INFORMATION_ ptr ) as long

'' Prefixed w_ for the same reason as chrono/clock.bas: several of the bare
'' names are already declared by headers reached through the includes.
extern "c"   '' NON-FBCALL: kernel32 imports, not rtlib entry points.
	declare function w_GetModuleHandleA stdcall alias "GetModuleHandleA" ( byval n as zstring ptr ) as any ptr
	declare function w_GetProcAddress stdcall alias "GetProcAddress" ( byval m as any ptr, byval n as zstring ptr ) as any ptr
	declare function w_GetTimeZoneInformation stdcall alias "GetTimeZoneInformation" ( byval tzi as TIME_ZONE_INFORMATION_ ptr ) as ulong
	declare function w_GetDynamicTimeZoneInformation stdcall alias "GetDynamicTimeZoneInformation" ( byval dtzi as DYNAMIC_TIME_ZONE_INFORMATION_ ptr ) as ulong
	declare function w_SystemTimeToTzSpecificLocalTime stdcall alias "SystemTimeToTzSpecificLocalTime" _
		( byval tzi as TIME_ZONE_INFORMATION_ ptr, byval utc as SYSTEMTIME_ ptr, byval lcl as SYSTEMTIME_ ptr ) as long
	declare function w_FileTimeToSystemTime stdcall alias "FileTimeToSystemTime" ( byval ft as FILETIME_ ptr, byval st as SYSTEMTIME_ ptr ) as long
	declare function w_WideCharToMultiByte stdcall alias "WideCharToMultiByte" _
		( byval cp as ulong, byval flags as ulong, byval wstr_ as wstring ptr, byval cch as long, _
		  byval dst as zstring ptr, byval cb as long, byval dflt as zstring ptr, byval used as long ptr ) as long
	declare function w_GetDateFormatEx stdcall alias "GetDateFormatEx" _
		( byval loc as wstring ptr, byval flags as ulong, byval st as SYSTEMTIME_ ptr, _
		  byval fmt as wstring ptr, byval dst as wstring ptr, byval cch as long, byval cal as wstring ptr ) as long
	declare function w_GetTimeFormatEx stdcall alias "GetTimeFormatEx" _
		( byval loc as wstring ptr, byval flags as ulong, byval st as SYSTEMTIME_ ptr, _
		  byval fmt as wstring ptr, byval dst as wstring ptr, byval cch as long ) as long
	declare function w_GetLocaleInfoEx stdcall alias "GetLocaleInfoEx" _
		( byval loc as wstring ptr, byval lctype as ulong, byval dst as wstring ptr, byval cch as long ) as long
end extern

'' UTF-16 -> UTF-8 at the boundary; everything above this layer is UTF-8.
private function hW2U( byval w as wstring ptr, byval buf as zstring ptr, byval buflen as long ) as long
	dim as long n = any
	if( w = 0 ) then return 0
	if( buf = 0 ) then return 0
	if( buflen < 2 ) then return 0
	n = w_WideCharToMultiByte( CP_UTF8, 0, w, -1, buf, buflen - 1, 0, 0 )
	if( n <= 0 ) then
		buf[0] = 0
		return 0
	end if
	'' n INCLUDES the terminating NUL, so the length is one less and the
	'' terminator is rewritten in case the conversion filled the buffer.
	buf[n - 1] = 0
	return n - 1
end function

dim shared as FB_TZFORYEARPROC hTzForYear = 0
dim shared as long hTzForYearChecked = 0

private function hGetTzForYearProc( ) as FB_TZFORYEARPROC
	dim as any ptr k32 = any
	if( hTzForYearChecked = 0 ) then
		k32 = w_GetModuleHandleA( @"kernel32.dll" )
		if( k32 <> 0 ) then
			hTzForYear = cast( FB_TZFORYEARPROC, _
				w_GetProcAddress( k32, @"GetTimeZoneInformationForYear" ) )
		end if
		hTzForYearChecked = 1
	end if
	return hTzForYear
end function

'' Historical rules when available, today's rules when not -- see the header.
private function hTziForYear( byval utc as SYSTEMTIME_ ptr, byval tzi as TIME_ZONE_INFORMATION_ ptr ) as long
	dim as DYNAMIC_TIME_ZONE_INFORMATION_ dtzi = any
	dim as FB_TZFORYEARPROC forYear = hGetTzForYearProc( )

	if( forYear <> 0 ) then
		if( w_GetDynamicTimeZoneInformation( @dtzi ) <> TIME_ZONE_ID_INVALID ) then
			if( forYear( utc->wYear, @dtzi, tzi ) <> 0 ) then return 0
		end if
	end if
	if( w_GetTimeZoneInformation( tzi ) <> TIME_ZONE_ID_INVALID ) then return 0
	return 1
end function

private function hTicksToSystemTime( byval ticks as longint, byval st as SYSTEMTIME_ ptr ) as long
	dim as FILETIME_ ft = any
	dim as ulongint u = any
	if( tkrt_DtIsValidTicks( ticks ) = 0 ) then return 1
	u = cast( ulongint, ticks - FB_DT_TICKS_TO_FILETIME )
	ft.dwLowDateTime = cast( ulong, u and &hFFFFFFFFull )
	ft.dwHighDateTime = cast( ulong, u shr 32 )
	if( w_FileTimeToSystemTime( @ft, st ) <> 0 ) then return 0
	return 1
end function

extern "rtlib"

'' The offset is DERIVED by converting the same instant twice and differencing
'' the two civil renderings, rather than read out of the Bias fields -- which
'' is what makes it correct across a DST boundary.
function tkort_DtZoneOffsetAt alias "fb_DtZoneOffsetAt" ( byval utcTicks as longint ) as long
	dim as SYSTEMTIME_ utc = any, lcl = any
	dim as TIME_ZONE_INFORMATION_ tzi = any
	dim as longint lt = any, ut = any

	if( hTicksToSystemTime( utcTicks, @utc ) ) then return 0
	if( hTziForYear( @utc, @tzi ) ) then return 0
	if( w_SystemTimeToTzSpecificLocalTime( @tzi, @utc, @lcl ) = 0 ) then return 0

	if( tkrt_DtFromCivil( lcl.wYear, lcl.wMonth, lcl.wDay, lcl.wHour, lcl.wMinute, lcl.wSecond, 0, @lt ) ) then return 0
	if( tkrt_DtFromCivil( utc.wYear, utc.wMonth, utc.wDay, utc.wHour, utc.wMinute, utc.wSecond, 0, @ut ) ) then return 0

	return cast( long, (lt - ut) \ FB_DT_TICKS_PER_MINUTE )
end function

'' In DST when the offset at that instant differs from the standard one. A zone
'' with no daylight bias is never in DST, tested first so the comparison is not
'' made for zones that do not observe it.
function tkort_DtZoneIsDst alias "fb_DtZoneIsDst" ( byval utcTicks as longint ) as long
	dim as SYSTEMTIME_ utc = any
	dim as TIME_ZONE_INFORMATION_ tzi = any

	if( hTicksToSystemTime( utcTicks, @utc ) ) then return 0
	if( hTziForYear( @utc, @tzi ) ) then return 0
	if( tzi.DaylightBias = 0 ) then return 0
	if( tkort_DtZoneOffsetAt( utcTicks ) <> (-tzi.Bias - tzi.StandardBias) ) then return 1
	return 0
end function

function tkort_DtZoneSupportsDst alias "fb_DtZoneSupportsDst" ( ) as long
	dim as TIME_ZONE_INFORMATION_ tzi = any
	if( w_GetTimeZoneInformation( @tzi ) = TIME_ZONE_ID_INVALID ) then return 0
	if( tzi.DaylightBias <> 0 ) then return 1
	return 0
end function

function tkort_DtZoneStandardName alias "fb_DtZoneStandardName" ( byval buf as zstring ptr, byval buflen as long ) as long
	dim as TIME_ZONE_INFORMATION_ tzi = any
	if( buf = 0 ) then return 0
	if( buflen < 2 ) then return 0
	buf[0] = 0
	if( w_GetTimeZoneInformation( @tzi ) = TIME_ZONE_ID_INVALID ) then return 0
	return hW2U( @tzi.StandardName, buf, buflen )
end function

function tkort_DtZoneDaylightName alias "fb_DtZoneDaylightName" ( byval buf as zstring ptr, byval buflen as long ) as long
	dim as TIME_ZONE_INFORMATION_ tzi = any
	if( buf = 0 ) then return 0
	if( buflen < 2 ) then return 0
	buf[0] = 0
	if( w_GetTimeZoneInformation( @tzi ) = TIME_ZONE_ID_INVALID ) then return 0
	return hW2U( @tzi.DaylightName, buf, buflen )
end function

'' ------------------------------------------------- Windows locale formatting

'' LOCALE_NAME_USER_DEFAULT is a NULL pointer, not a string.
private function hFillSystemTime( byval ticks as longint, byval st as SYSTEMTIME_ ptr, _
                                  byval want_dow as long ) as long
	dim as long y = any, mo = any, d = any, h = any, mi = any, s = any
	dim as longint sub_ = any

	tkrt_DtToCivil( ticks, @y, @mo, @d, @h, @mi, @s, @sub_ )
	st->wYear = y : st->wMonth = mo : st->wDay = d
	st->wHour = h : st->wMinute = mi : st->wSecond = s
	st->wMilliseconds = 0
	if( want_dow ) then
		'' SYSTEMTIME wants SUNDAY = 0; this library's day-of-week is ISO
		'' 1..7 with Monday = 1, so `mod 7` maps Sunday's 7 to 0 and leaves
		'' the rest alone.
		st->wDayOfWeek = tkrt_DtDayOfWeek( cast( long, ticks \ FB_DT_TICKS_PER_DAY ) ) mod 7
	else
		st->wDayOfWeek = 0
	end if
	return 0
end function

function tkort_DtLocaleDateString alias "fb_DtLocaleDateString" _
	( byval ticks as longint, byval style as long, byval buf as zstring ptr, byval buflen as long ) as long
	dim as SYSTEMTIME_ st = any
	dim as wstring * 256 wbuf
	dim as ulong flags = any

	if( buf = 0 ) then return 0
	if( buflen < 2 ) then return 0
	buf[0] = 0
	if( tkrt_DtIsValidTicks( ticks ) = 0 ) then return 0

	hFillSystemTime( ticks, @st, 1 )
	flags = iif( style = DT_ZONE_STYLE_SHORT, DATE_SHORTDATE, DATE_LONGDATE )
	if( w_GetDateFormatEx( 0, flags, @st, 0, @wbuf, 256, 0 ) <= 0 ) then return 0
	return hW2U( @wbuf, buf, buflen )
end function

function tkort_DtLocaleTimeString alias "fb_DtLocaleTimeString" _
	( byval ticks as longint, byval style as long, byval buf as zstring ptr, byval buflen as long ) as long
	dim as SYSTEMTIME_ st = any
	dim as wstring * 256 wbuf
	dim as ulong flags = any

	if( buf = 0 ) then return 0
	if( buflen < 2 ) then return 0
	buf[0] = 0
	if( tkrt_DtIsValidTicks( ticks ) = 0 ) then return 0

	'' No weekday here: the time formatter does not read it.
	hFillSystemTime( ticks, @st, 0 )
	flags = iif( style = DT_ZONE_STYLE_SHORT, TIME_NOSECONDS, 0 )
	if( w_GetTimeFormatEx( 0, flags, @st, 0, @wbuf, 256 ) <= 0 ) then return 0
	return hW2U( @wbuf, buf, buflen )
end function

'' The twelve month names are CONSECUTIVE LCTYPE values, so the index is added
'' to the first one rather than looked up.
function tkort_DtLocaleMonthName alias "fb_DtLocaleMonthName" _
	( byval mo as long, byval abbreviated as long, byval buf as zstring ptr, byval buflen as long ) as long
	dim as wstring * 128 wbuf
	dim as ulong t = any

	if( buf = 0 ) then return 0
	if( buflen < 2 ) then return 0
	buf[0] = 0
	if( (mo < 1) orelse (mo > 12) ) then return 0

	t = iif( abbreviated <> 0, LOCALE_SABBREVMONTHNAME1, LOCALE_SMONTHNAME1 ) + (mo - 1)
	if( w_GetLocaleInfoEx( 0, t, @wbuf, 128 ) <= 0 ) then return 0
	return hW2U( @wbuf, buf, buflen )
end function

'' WINDOWS NUMBERS THESE MONDAY-FIRST -- LOCALE_SDAYNAME1 is Monday -- which
'' happens to match this library's ISO 1..7 exactly, so no conversion is
'' needed here and one IS needed in the Unix half.
function tkort_DtLocaleWeekdayName alias "fb_DtLocaleWeekdayName" _
	( byval dow as long, byval abbreviated as long, byval buf as zstring ptr, byval buflen as long ) as long
	dim as wstring * 128 wbuf
	dim as ulong t = any

	if( buf = 0 ) then return 0
	if( buflen < 2 ) then return 0
	buf[0] = 0
	if( (dow < 1) orelse (dow > 7) ) then return 0

	t = iif( abbreviated <> 0, LOCALE_SABBREVDAYNAME1, LOCALE_SDAYNAME1 ) + (dow - 1)
	if( w_GetLocaleInfoEx( 0, t, @wbuf, 128 ) <= 0 ) then return 0
	return hW2U( @wbuf, buf, buflen )
end function

function tkort_DtLocaleIsSupported alias "fb_DtLocaleIsSupported" ( ) as long
	return 1
end function

end extern

#else

'' ------------------------------------------------------------- Unix backend

type tm_
	as long tm_sec, tm_min, tm_hour, tm_mday, tm_mon, tm_year
	as long tm_wday, tm_yday, tm_isdst
	as clong       tm_gmtoff
	as zstring ptr tm_zone
end type

type TZNAME_T
	as zstring ptr v( 0 to 1 )
end type

extern "c"   '' NON-FBCALL: libc, not rtlib entry points.
	declare function u_localtime_r alias "localtime_r" ( byval t as clong ptr, byval result as tm_ ptr ) as tm_ ptr
	declare function u_time alias "time" ( byval t as clong ptr ) as clong
	declare sub u_tzset alias "tzset" ( )
	declare function u_strftime alias "strftime" _
		( byval s as zstring ptr, byval maxs as uinteger, byval fmt as zstring ptr, byval tmv as tm_ ptr ) as uinteger
	'' tzname is DATA, not a function: two char pointers set by tzset.
	'' Wrapped in a one-member TYPE because an EXTERN declaration cannot
	'' carry array bounds -- the same restriction that made utf/core.bas wrap
	'' its tables. A struct of just the array has the array's layout.
	extern u_tzname alias "tzname" as TZNAME_T
end extern

private function hTicksToTimeT( byval utcTicks as longint ) as clong
	return cast( clong, (utcTicks - FB_DT_TICKS_TO_UNIX_EPOCH) \ FB_DT_TICKS_PER_SECOND )
end function

private function hCopyStr( byval s as zstring ptr, byval buf as zstring ptr, byval buflen as long ) as long
	dim as long n = 0
	if( buf = 0 ) then return 0
	if( buflen < 2 ) then return 0
	if( s = 0 ) then
		buf[0] = 0
		return 0
	end if
	while( (s[n] <> 0) andalso (n < buflen - 1) )
		buf[n] = s[n]
		n += 1
	wend
	buf[n] = 0
	return n
end function

extern "rtlib"

'' tm_gmtoff read directly: glibc has it, so the portable fallback of
'' differencing mktime over the local and UTC renderings is not needed.
function tkort_DtZoneOffsetAt alias "fb_DtZoneOffsetAt" ( byval utcTicks as longint ) as long
	dim as clong t = any
	dim as tm_ tmv = any

	if( tkrt_DtIsValidTicks( utcTicks ) = 0 ) then return 0
	t = hTicksToTimeT( utcTicks )
	'' localtime_r, NEVER localtime -- this has to be thread-safe.
	if( u_localtime_r( @t, @tmv ) = 0 ) then return 0
	return cast( long, tmv.tm_gmtoff \ 60 )
end function

'' tm_isdst is TRI-STATE: positive means DST, zero means not, negative means
'' unknown. Only a positive value counts as DST.
function tkort_DtZoneIsDst alias "fb_DtZoneIsDst" ( byval utcTicks as longint ) as long
	dim as clong t = any
	dim as tm_ tmv = any

	if( tkrt_DtIsValidTicks( utcTicks ) = 0 ) then return 0
	t = hTicksToTimeT( utcTicks )
	if( u_localtime_r( @t, @tmv ) = 0 ) then return 0
	if( tmv.tm_isdst > 0 ) then return 1
	return 0
end function

'' MIDWINTER AGAINST MIDSUMMER of the current year. Cheaper and more portable
'' than reading the tzdb, and it does not care which hemisphere we are in --
'' the two offsets differ either way if the zone observes DST at all.
function tkort_DtZoneSupportsDst alias "fb_DtZoneSupportsDst" ( ) as long
	dim as clong now_ = any
	dim as tm_ tmv = any
	dim as long janOff = any, julOff = any, year_ = any
	dim as longint jan = any, jul = any

	now_ = u_time( 0 )
	if( u_localtime_r( @now_, @tmv ) = 0 ) then return 0
	year_ = tmv.tm_year + 1900
	if( (year_ < FB_DT_MIN_YEAR) orelse (year_ > FB_DT_MAX_YEAR) ) then return 0

	if( tkrt_DtFromCivil( year_, 1, 15, 12, 0, 0, 0, @jan ) ) then return 0
	if( tkrt_DtFromCivil( year_, 7, 15, 12, 0, 0, 0, @jul ) ) then return 0

	janOff = tkort_DtZoneOffsetAt( jan )
	julOff = tkort_DtZoneOffsetAt( jul )
	if( janOff <> julOff ) then return 1
	return 0
end function

function tkort_DtZoneStandardName alias "fb_DtZoneStandardName" ( byval buf as zstring ptr, byval buflen as long ) as long
	u_tzset( )
	return hCopyStr( u_tzname.v(0), buf, buflen )
end function

function tkort_DtZoneDaylightName alias "fb_DtZoneDaylightName" ( byval buf as zstring ptr, byval buflen as long ) as long
	u_tzset( )
	return hCopyStr( u_tzname.v(1), buf, buflen )
end function

private sub hFillTm( byval ticks as longint, byval tmv as tm_ ptr )
	dim as long y = any, mo = any, d = any, h = any, mi = any, s = any
	dim as longint sub_ = any
	dim as long days = cast( long, ticks \ FB_DT_TICKS_PER_DAY )

	tkrt_DtToCivil( ticks, @y, @mo, @d, @h, @mi, @s, @sub_ )
	tmv->tm_sec = s : tmv->tm_min = mi : tmv->tm_hour = h
	tmv->tm_mday = d
	'' tm_mon is 0-BASED and tm_year is YEARS SINCE 1900.
	tmv->tm_mon = mo - 1
	tmv->tm_year = y - 1900
	'' tm_wday is SUNDAY = 0, so the ISO 1..7 value folds with `mod 7`.
	tmv->tm_wday = tkrt_DtDayOfWeek( days ) mod 7
	tmv->tm_yday = tkrt_DtDayOfYear( y, mo, d ) - 1
	'' -1, not 0: "unknown", so strftime does not assert a DST state.
	tmv->tm_isdst = -1
	tmv->tm_gmtoff = 0
	tmv->tm_zone = 0
end sub

'' strftime with "%x"/"%X" rather than nl_langinfo: the langinfo path needs
'' another header for the same locale-driven answer. The LONG style is spelled
'' out because no locale item corresponds to it.
function tkort_DtLocaleDateString alias "fb_DtLocaleDateString" _
	( byval ticks as longint, byval style as long, byval buf as zstring ptr, byval buflen as long ) as long
	dim as tm_ tmv = any
	if( buf = 0 ) then return 0
	if( buflen < 2 ) then return 0
	buf[0] = 0
	if( tkrt_DtIsValidTicks( ticks ) = 0 ) then return 0
	hFillTm( ticks, @tmv )
	if( style = DT_ZONE_STYLE_SHORT ) then
		return cast( long, u_strftime( buf, buflen, @"%x", @tmv ) )
	end if
	return cast( long, u_strftime( buf, buflen, @"%A %d %B %Y", @tmv ) )
end function

function tkort_DtLocaleTimeString alias "fb_DtLocaleTimeString" _
	( byval ticks as longint, byval style as long, byval buf as zstring ptr, byval buflen as long ) as long
	dim as tm_ tmv = any
	if( buf = 0 ) then return 0
	if( buflen < 2 ) then return 0
	buf[0] = 0
	if( tkrt_DtIsValidTicks( ticks ) = 0 ) then return 0
	hFillTm( ticks, @tmv )
	'' SHORT drops the seconds with an explicit format, because no locale
	'' item means "without seconds".
	if( style = DT_ZONE_STYLE_SHORT ) then
		return cast( long, u_strftime( buf, buflen, @"%H:%M", @tmv ) )
	end if
	return cast( long, u_strftime( buf, buflen, @"%X", @tmv ) )
end function

function tkort_DtLocaleMonthName alias "fb_DtLocaleMonthName" _
	( byval mo as long, byval abbreviated as long, byval buf as zstring ptr, byval buflen as long ) as long
	dim as tm_ tmv = any
	if( buf = 0 ) then return 0
	if( buflen < 2 ) then return 0
	buf[0] = 0
	if( (mo < 1) orelse (mo > 12) ) then return 0
	hFillTm( FB_DT_TICKS_PER_DAY, @tmv )
	tmv.tm_mon = mo - 1
	tmv.tm_mday = 1
	if( abbreviated <> 0 ) then
		return cast( long, u_strftime( buf, buflen, @"%b", @tmv ) )
	end if
	return cast( long, u_strftime( buf, buflen, @"%B", @tmv ) )
end function

'' THE CONVERSION WINDOWS DOES NOT NEED: this library is ISO 1 = Monday and
'' tm_wday is Sunday = 0, so `dow mod 7` maps 7 to 0 and leaves 1..6 alone.
function tkort_DtLocaleWeekdayName alias "fb_DtLocaleWeekdayName" _
	( byval dow as long, byval abbreviated as long, byval buf as zstring ptr, byval buflen as long ) as long
	dim as tm_ tmv = any
	if( buf = 0 ) then return 0
	if( buflen < 2 ) then return 0
	buf[0] = 0
	if( (dow < 1) orelse (dow > 7) ) then return 0
	hFillTm( FB_DT_TICKS_PER_DAY, @tmv )
	tmv.tm_wday = dow mod 7
	if( abbreviated <> 0 ) then
		return cast( long, u_strftime( buf, buflen, @"%a", @tmv ) )
	end if
	return cast( long, u_strftime( buf, buflen, @"%A", @tmv ) )
end function

function tkort_DtLocaleIsSupported alias "fb_DtLocaleIsSupported" ( ) as long
	return 1
end function

end extern

#endif
