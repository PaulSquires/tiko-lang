'' clock-parity.bas -- DATE$, TIME$, NOW, DATEVALUE, TIMEVALUE, ISDATE, the two
'' name lookups, SLEEP and the two setters. Twelve entry points across ten fbc
'' members.
''
'' NEEDS-GEN-LLVM
''
'' NOTHING HERE PRINTS THE CURRENT TIME, and that is the whole difficulty: the
'' two runtimes are two processes started a fraction of a second apart, so DATE$,
'' TIME$ and NOW differ between them whenever the clock ticks in the gap. What is
'' compared instead is their SHAPE -- length, separator positions, which
'' characters are digits -- and their internal CONSISTENCY, which is what
'' actually tests the formatting.
''
'' NOTHING HERE SETS THE CLOCK. fb_SetDate and fb_SetTime change the SYSTEM
'' clock; only their REJECTION paths are driven, and EVERY STRING BELOW WAS
'' HAND-TRACED THROUGH THE PARSER to confirm it fails before the syscall. Two
'' obvious-looking cases had to be REMOVED after tracing:
''
''   "12::00"  the empty minutes field parses as 0, and the whole string then
''             SUCCEEDS -- it would have set the clock to 12:00:00
''   "003"     the accumulator gives 3, which is a valid hour
''
'' fb_SetTime's ACCUMULATOR BUG IS NOT OBSERVABLE FROM HERE, and that is worth
'' stating rather than leaving as a silent gap. `h = h * i + digit` with i
'' starting at zero differs from `h * 10 + digit` only for three-digit fields,
'' and every three-digit field on which the two DISAGREE about the value is one
'' where both ACCEPT -- so seeing the difference requires letting the syscall
'' run. Its rejection behaviour is identical and is what is tested.
''
'' SLEEP IS CALLED WITH ZERO AND ONE only, and never with -1, which waits for a
'' keystroke that will not come.

#include once "fbc-int/string.bi"
'' The VB-compatible datetime functions -- YEAR, NOW, DATESERIAL, DATEVALUE,
'' ISDATE, TIMEVALUE, MONTHNAME, WEEKDAYNAME -- are declared in vbcompat.bi, not
'' in the core language, and reaching them through the language forms is what
'' makes this test exercise the same call sequence fbc's codegen emits.
#include once "vbcompat.bi"

'' The setters take a descriptor and return the code, so they are declared
'' rather than reached through a statement.
extern "rtlib"
	declare function pSetDate  alias "fb_SetDate" ( byval s as any ptr ) as long
	declare function pSetTime  alias "fb_SetTime" ( byval s as any ptr ) as long
	declare function pSleepEx  alias "fb_SleepEx" ( byval ms as long, byval kind as long ) as long
end extern

extern "c"
	declare sub pConSleep alias "fb_ConsoleSleep" ( byval ms as long )
end extern

'' The other nine are reached through the LANGUAGE forms below, which is what
'' fbc's own codegen emits -- so their addresses are taken here only to prove
'' they exist and link with the archive's convention.
extern "rtlib"
	declare function aDate     alias "fb_Date" ( ) as any ptr
	declare function aTime     alias "fb_Time" ( ) as any ptr
	declare function aNow      alias "fb_Now" ( ) as double
	declare function aDateVal  alias "fb_DateValue" ( byval s as any ptr ) as long
	declare function aTimeVal  alias "fb_TimeValue" ( byval s as any ptr ) as double
	declare function aIsDate   alias "fb_IsDate" ( byval s as any ptr ) as long
	declare function aMonthNm  alias "fb_MonthName" ( byval m as long, byval a as long ) as any ptr
	declare function aWeekNm   alias "fb_WeekdayName" _
		( byval w as long, byval a as long, byval f as long ) as any ptr
end extern

dim shared as any ptr addrs( 0 to 11 )
addrs(0)  = cast( any ptr, @aDate )
addrs(1)  = cast( any ptr, @aTime )
addrs(2)  = cast( any ptr, @aNow )
addrs(3)  = cast( any ptr, @aDateVal )
addrs(4)  = cast( any ptr, @aTimeVal )
addrs(5)  = cast( any ptr, @aIsDate )
addrs(6)  = cast( any ptr, @aMonthNm )
addrs(7)  = cast( any ptr, @aWeekNm )
addrs(8)  = cast( any ptr, @pSleepEx )
addrs(9)  = cast( any ptr, @pSetDate )
addrs(10) = cast( any ptr, @pSetTime )
addrs(11) = cast( any ptr, @pConSleep )

dim as long n = 0, distinct = 1
for i as integer = 0 to 11
	if( addrs(i) <> 0 ) then n += 1
	for j as integer = 0 to i - 1
		if( addrs(i) = addrs(j) ) then distinct = 0
	next
next
print "-- every clock entry point resolves"
print "  count="; n; " distinct="; distinct

'' Replaces every digit with '9', so a timestamp becomes a SHAPE. The separator
'' positions and the total length survive; the value does not.
function shape( byref s as string ) as string
	dim as string out_ = s
	for i as integer = 1 to len( out_ )
		dim as long c = asc( out_, i )
		if( (c >= 48) andalso (c <= 57) ) then mid( out_, i, 1 ) = "9"
	next
	return out_
end function

'' ------------------------------------------------------------ DATE$ / TIME$

'' mm-dd-yyyy and hh:mm:ss. The shape IS the contract -- a wrong separator or a
'' missing zero-pad shows here and nowhere else, because the digits differ
'' between the two processes anyway.
print "-- DATE$ and TIME$ shapes"
dim as string d = date
dim as string t = time
print "  DATE$ len="; len( d ); " shape=["; shape( d ); "]"
print "  TIME$ len="; len( t ); " shape=["; shape( t ); "]"

'' AND THEY MUST AGREE WITH THE PART FUNCTIONS. The clock can tick between two
'' calls, so only the YEAR is asserted -- it cannot change in the gap.
dim as long dy = val( mid( d, 7, 4 ) )
print "  year from DATE$ matches YEAR(NOW)="; ( dy = year( now ) )

dim as double nw = now
print "  NOW is positive="; ( nw > 0 )
print "  int(NOW) equals DATESERIAL of DATE$'s parts="; _
      ( int( nw ) = dateserial( dy, val( left( d, 2 ) ), val( mid( d, 4, 2 ) ) ) )

'' ------------------------------------------------------- DATEVALUE / ISDATE

'' Serials are absolute numbers, so unlike the clock these compare exactly.
print "-- DATEVALUE"

'' THE FORMATS THAT PARSE ARE NOT THE FORMAT DATE$ EMITS, and the first version
'' of this section learned that the hard way: all twelve of its cases were
'' hyphenated mm-dd-yyyy, all twelve returned 0, and the section measured only
'' the failure path while looking like a round trip. fb_hDateParse accepts ISO
'' order and month NAMES in either position -- but "08-31-2026", which is
'' exactly what DATE$ produces, is error 1.
''
'' ERR IS READ INTO A LOCAL FIRST. Inside one PRINT list the read can happen
'' before the call that sets it, which is how the earlier version printed
'' err=0 beside a failing parse.
dim as zstring ptr dcases(0 to 13) = { _
	@"2000-01-01", @"1999-12-31", @"2000-02-29", @"2001-02-29", _
	@"Jan 1, 2000", @"1 Jan 2000", @"December 31, 1999", _
	@"08-31-2026", @"1-1-2000", @"1/1/2000", _
	@"", @"not a date", @"2000-13-01", @"2000-01-32" }
for i as integer = 0 to 13
	dim as string c = *dcases(i)
	dim as long v = datevalue( c )
	dim as long e = err
	print "  ["; c; "] -> "; v; " err="; e
next

print "-- ISDATE sets no error"
'' A question, not an operation: a string that does not parse is FALSE and ERR
'' is left exactly as it was. The deliberate error before it is what proves
'' that -- without it the check would pass on a zero ERR that was never
'' anything else.
dim as string bad_ = "2000-13-45"
datevalue( bad_ )
dim as long before = err
dim as string q = "also not a date"
dim as long isd = isdate( q )
dim as long after_ = err
print "  err before="; before; " ISDATE="; isd; " err after="; after_
dim as string okdate = "2010-06-15"
print "  ISDATE(""2010-06-15"")="; isdate( okdate )
print "  ISDATE(""08-31-2026"")="; isdate( "08-31-2026" )

'' ------------------------------------------------------------- TIMEVALUE

print "-- TIMEVALUE"
dim as zstring ptr tcases(0 to 8) = { _
	@"0:0:0", @"00:00:00", @"12:00:00", @"23:59:59", @"24:00:00", _
	@"1:2:3", @"12:60:00", @"", @"12" }
for i as integer = 0 to 8
	dim as string c = *tcases(i)
	dim as double v = timevalue( c )
	dim as long e = err
	print "  ["; c; "] -> "; v; " err="; e
next

'' ------------------------------------------------------------- the names

print "-- MONTHNAME"
for m as integer = 0 to 13
	dim as string full_ = monthname( m )
	dim as string abbr = monthname( m, -1 )
	print "  "; m; ": full="; len( full_ ); " abbr="; len( abbr ); " err="; err
next

print "-- WEEKDAYNAME"
for w as integer = 0 to 8
	dim as string nm = weekdayname( w, -1, 1 )
	print "  weekday"; w; " len="; len( nm ); " err="; err
next

'' THE ROTATION IS THE POINT, and it is asserted by comparing names to EACH
'' OTHER rather than to literals -- which is what makes it survive a locale that
'' is not English.
print "-- the first-day-of-week rotation"
print "  rotation by one matches="; ( weekdayname( 2, -1, 1 ) = weekdayname( 1, -1, 2 ) )
'' 0 means "ask the system", which fbc has never implemented, so it must be 1.
print "  first_day 0 equals 1="; ( weekdayname( 3, -1, 0 ) = weekdayname( 3, -1, 1 ) )
'' And the wrap: weekday 7 with first_day 7 comes back round to 6 with 1.
print "  the wrap matches="; ( weekdayname( 7, -1, 7 ) = weekdayname( 6, -1, 1 ) )

'' ------------------------------------------------------------------ SLEEP

print "-- SLEEP"
print "  SleepEx(0, 0) -> "; pSleepEx( 0, 0 )
print "  SleepEx(1, 1) -> "; pSleepEx( 1, 1 )
print "  SleepEx(0, 2) -> "; pSleepEx( 0, 2 )
print "  SleepEx(0, -1) -> "; pSleepEx( 0, -1 )
pConSleep( 0 )
print "  ConsoleSleep(0) returned, err="; err
'' A NEGATIVE msecs THAT IS NOT -1 falls past the wait-for-key branch and past
'' the `>= 0` guard, so it sleeps for nothing and returns at once.
pConSleep( -2 )
print "  ConsoleSleep(-2) returned, err="; err

'' --------------------------------------------------------- the setters

'' ONLY THE REJECTIONS, every one hand-traced. See the file header.
print "-- SETDATE, rejection paths only"
dim as zstring ptr dbad(0 to 8) = { _
	@"", @"x", @"1", @"13-1-2000", @"0-1-2000", @"1-0-2000", _
	@"1-32-2000", @"1/2-2000", @"1-2" }
for i as integer = 0 to 8
	dim as string c = *dbad(i)
	print "  ["; c; "] -> "; pSetDate( @c )
next

print "-- SETTIME, rejection paths only"
dim as zstring ptr tbad(0 to 8) = { _
	@"", @"x", @"24:00:00", @"12:60:00", @"12:00:60", @"123:00", _
	@"999", @"12:00:00x", @"1:2:3:4" }
for i as integer = 0 to 8
	dim as string c = *tbad(i)
	print "  ["; c; "] -> "; pSetTime( @c )
next

print "done"
