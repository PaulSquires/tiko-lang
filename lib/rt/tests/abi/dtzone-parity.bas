'' dtzone-parity.bas -- timezone offsets and locale formatting: ten entry
'' points, the second platform-split file.
''
'' NEEDS-GEN-LLVM
''
'' LOCALE OUTPUT CANNOT BE ASSERTED BY EXACT STRING -- it is whatever the
'' machine's locale says, and both sides of a differential run on the same
'' machine, so the comparison IS meaningful even though the value is not
'' predictable. That is the whole reason this test compares the two runtimes
'' rather than checking against literals: fbc's answer is the specification.
''
'' The zone answers are likewise machine-dependent, but they have STRUCTURE
'' that must hold anywhere, and the structural checks are printed alongside the
'' raw values so a mismatch says which kind it is.
''
'' WHAT HAS A PLAUSIBLE WRONG ANSWER:
''   - the offset must be asked AT AN INSTANT: January and July differ wherever
''     DST is observed, and a port that reads "the current offset" gives the
''     same answer for both
''   - IsDst must agree with the offset actually changing
''   - weekday names: Windows LOCALE_SDAYNAME1 is Monday and Unix DAY_1 is
''     Sunday, so one backend converts and the other must not
''   - month and weekday indices are 1-based and out-of-range must give ""

extern "rtlib"
	declare function pOffsetAt alias "fb_DtZoneOffsetAt" ( byval t as longint ) as long
	declare function pIsDst alias "fb_DtZoneIsDst" ( byval t as longint ) as long
	declare function pSupportsDst alias "fb_DtZoneSupportsDst" ( ) as long
	declare function pStdName alias "fb_DtZoneStandardName" ( byval b as zstring ptr, byval n as long ) as long
	declare function pDstName alias "fb_DtZoneDaylightName" ( byval b as zstring ptr, byval n as long ) as long
	declare function pDateStr alias "fb_DtLocaleDateString" ( byval t as longint, byval s as long, byval b as zstring ptr, byval n as long ) as long
	declare function pTimeStr alias "fb_DtLocaleTimeString" ( byval t as longint, byval s as long, byval b as zstring ptr, byval n as long ) as long
	declare function pMonName alias "fb_DtLocaleMonthName" ( byval m as long, byval a as long, byval b as zstring ptr, byval n as long ) as long
	declare function pDayName alias "fb_DtLocaleWeekdayName" ( byval d as long, byval a as long, byval b as zstring ptr, byval n as long ) as long
	declare function pLocSup alias "fb_DtLocaleIsSupported" ( ) as long
	declare function pFromCivil alias "fb_DtFromCivil" ( byval y as long, byval m as long, byval d as long, byval h as long, byval mi as long, byval s as long, byval sub_ as longint, byval o as longint ptr ) as long
end extern

dim shared as zstring * 256 buf
dim as long i = any, k = any, n = any
dim as longint jan = any, jul = any, t = any

pFromCivil( 2024, 1, 15, 12, 0, 0, 0, @jan )
pFromCivil( 2024, 7, 15, 12, 0, 0, 0, @jul )

print "-- the offset is asked AT AN INSTANT"
print "  january="; pOffsetAt( jan )
print "  july   ="; pOffsetAt( jul )
print "  differ  ="; iif( pOffsetAt( jan ) <> pOffsetAt( jul ), 1, 0 )
print "  supportsdst="; pSupportsDst( )
print "  consistent="; iif( (pOffsetAt( jan ) <> pOffsetAt( jul )) = (pSupportsDst( ) <> 0), 1, 0 )
print "  isdst jan="; pIsDst( jan ); " jul="; pIsDst( jul )
print "  in range="; iif( (pOffsetAt(jan) >= -1080) andalso (pOffsetAt(jan) <= 1080), 1, 0 )

print "-- historical rules: the same calendar day across several decades"
for i = 0 to 6
	dim as long y = 1970 + i * 10
	pFromCivil( y, 7, 15, 12, 0, 0, 0, @t )
	print "  july "; y; " offset="; pOffsetAt( t ); " isdst="; pIsDst( t )
next

print "-- zone names"
buf = string(255, " ")
n = pStdName( @buf, 256 )
print "  standard n="; n; " '"; buf; "'"
buf = string(255, " ")
n = pDstName( @buf, 256 )
print "  daylight n="; n; " '"; buf; "'"
print "  null buf="; pStdName( 0, 256 ); " tiny="; pStdName( @buf, 1 )

print "-- locale month and weekday names, both styles"
for i = 1 to 12
	buf = string(255, " ")
	n = pMonName( i, 0, @buf, 256 )
	print "  month"; i; " n="; n; " '"; buf; "'";
	buf = string(255, " ")
	n = pMonName( i, 1, @buf, 256 )
	print "  abbr n="; n; " '"; buf; "'"
next
for i = 1 to 7
	buf = string(255, " ")
	n = pDayName( i, 0, @buf, 256 )
	print "  day"; i; " n="; n; " '"; buf; "'";
	buf = string(255, " ")
	n = pDayName( i, 1, @buf, 256 )
	print "  abbr n="; n; " '"; buf; "'"
next
print "  month 0="; pMonName( 0, 0, @buf, 256 ); " month 13="; pMonName( 13, 0, @buf, 256 )
print "  day 0="; pDayName( 0, 0, @buf, 256 ); " day 8="; pDayName( 8, 0, @buf, 256 )
print "  null buf="; pMonName( 1, 0, 0, 256 ); " tiny="; pMonName( 1, 0, @buf, 1 )

print "-- locale date and time strings, both styles"
for k = 0 to 1
	buf = string(255, " ")
	n = pDateStr( jan, k, @buf, 256 )
	print "  date style"; k; " n="; n; " '"; buf; "'"
	buf = string(255, " ")
	n = pTimeStr( jan, k, @buf, 256 )
	print "  time style"; k; " n="; n; " '"; buf; "'"
next
print "  bad ticks date="; pDateStr( -1, 0, @buf, 256 ); " time="; pTimeStr( -1, 0, @buf, 256 )
print "  null buf="; pDateStr( jan, 0, 0, 256 ); " tiny="; pDateStr( jan, 0, @buf, 1 )
print "  supported="; pLocSup( )
print "done"
