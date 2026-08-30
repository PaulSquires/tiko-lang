'' dtserial-parity.bas -- the calendar core: 21 entry points.
''
'' NEEDS-GEN-LLVM
''
'' WHAT THIS IS ACTUALLY LOOKING FOR. A date implementation that round-trips
'' perfectly can still be uniformly wrong: shift the epoch by two days and
'' DateSerial/DecodeSerial still agree with each other for every input. So the
'' grid below prints ABSOLUTE serials, not just round trips, and it walks far
'' enough either side of 1900 to catch a century/400-year leap rule that only
'' fires at 1700, 1800, 1900, 2000, 2100.
''
'' The awkward cases, each of which has a way to be plausibly wrong:
''   - serial 0, 1, 2 (the epoch itself, and the two days fbc offsets by)
''   - negative serials -- before 1899-12-30, where the decoder's first loop
''     runs and the encoder's subtracting branch runs
''   - out-of-range day/month fed to DateSerial, which normalises rather than
''     rejecting: month 0, month 13, month -11, day 0, day 32, day -1
''   - Feb 29 in 1900 (NOT a leap year), 2000 (IS one), 2100 (is not)
''   - the QB hack: -0.25 reflects, -1.25 wraps
''   - week 53-of-the-previous-year under the four-day rule
#include once "fbc-int/string.bi"

extern "c"
	declare function pLeap alias "fb_hTimeLeap" ( byval y as long ) as long
	declare function pDim alias "fb_hTimeDaysInMonth" ( byval m as long, byval y as long ) as long
	declare sub pNorm alias "fb_hNormalizeDate" ( byval d as long ptr, byval m as long ptr, byval y as long ptr )
	declare function pIntv alias "fb_hTimeGetIntervalType" ( byval s as FBC.FBSTRING ptr ) as long
	declare function pDoyEx alias "fb_hGetDayOfYearEx" ( byval y as long, byval m as long, byval d as long ) as long
	declare function pDoy alias "fb_hGetDayOfYear" ( byval s as double ) as long
	declare sub pBow alias "fb_hGetBeginOfWeek" ( byval y as long ptr, byval m as long ptr, byval d as long ptr, byval fdw as long )
	declare function pFwoy alias "fb_hGetFirstWeekOfYear" ( byval y as long, byval fdy as long, byval fdw as long ) as double
	declare function pWoy alias "fb_hGetWeekOfYear" ( byval ry as long, byval s as double, byval fdy as long, byval fdw as long ) as long
	declare function pWsoy alias "fb_hGetWeeksOfYear" ( byval ry as long, byval fdy as long, byval fdw as long ) as long
end extern

extern "rtlib"
	declare function pDateSerial alias "fb_DateSerial" ( byval y as long, byval m as long, byval d as long ) as long
	declare function pTimeSerial alias "fb_TimeSerial" ( byval h as long, byval m as long, byval s as long ) as double
	declare sub pDecD alias "fb_hDateDecodeSerial" ( byval s as double, byval y as long ptr, byval m as long ptr, byval d as long ptr )
	declare sub pDecT alias "fb_hTimeDecodeSerial" ( byval s as double, byval h as long ptr, byval m as long ptr, byval sec as long ptr, byval qb as long )
	declare function pYear alias "fb_Year" ( byval s as double ) as long
	declare function pMonth alias "fb_Month" ( byval s as double ) as long
	declare function pDay alias "fb_Day" ( byval s as double ) as long
	declare function pWeekday alias "fb_Weekday" ( byval s as double, byval fdw as long ) as long
	declare function pHour alias "fb_Hour" ( byval s as double ) as long
	declare function pMinute alias "fb_Minute" ( byval s as double ) as long
	declare function pSecond alias "fb_Second" ( byval s as double ) as long
end extern

dim as long y = any, m = any, d = any, h = any, mi = any, se = any
dim as double s = any

print "-- leap / days-in-month, across the century and 400-year rules"
for y = 1600 to 2400 step 100
	print y; " leap="; pLeap(y); " feb="; pDim(2, y); " days="; 365 + pLeap(y)
next
for y = 1896 to 1904
	print y; " leap="; pLeap(y); " feb="; pDim(2, y)
next
for m = 1 to 12
	print "dim"; m; "="; pDim(m, 2000); "/"; pDim(m, 2001)
next

print "-- the epoch itself, and either side of it"
for d = -8 to 8
	pDecD( d, @y, @m, @se )
	print "serial"; d; " -> "; y; "-"; m; "-"; se; _
	      " back="; pDateSerial(y, m, se); " dow="; pWeekday(d, 1)
next

print "-- normalisation: out-of-range day and month are carried, not rejected"
dim as long nd(0 to 8) = { 1, 0, -1, 32, 60, 366, -366, 15, 1 }
dim as long nm(0 to 8) = { 1, 0, -11, 13, 25, 1, 1, -1, 12 }
for d = 0 to 8
	y = 2000 : m = nm(d) : se = nd(d)
	pNorm( @se, @m, @y )
	print "norm("; nd(d); ","; nm(d); ",2000) -> "; y; "-"; m; "-"; se; _
	      " serial="; pDateSerial(2000, nm(d), nd(d))
next

print "-- Feb 29 in a leap year, a century, and a 400-year"
for y = 1900 to 2100 step 100
	print y; " feb29 serial="; pDateSerial(y, 2, 29); " -> "; _
	      pYear(pDateSerial(y,2,29)); "-"; pMonth(pDateSerial(y,2,29)); "-"; pDay(pDateSerial(y,2,29))
next

print "-- absolute serials for known dates"
print "1899-12-30="; pDateSerial(1899,12,30); " 1900-01-01="; pDateSerial(1900,1,1);
print " 1970-01-01="; pDateSerial(1970,1,1); " 2000-01-01="; pDateSerial(2000,1,1)
print "1800-01-01="; pDateSerial(1800,1,1); " 2100-12-31="; pDateSerial(2100,12,31)

print "-- Year/Month/Day/Weekday over a dense span, every first-day-of-week"
for d = 36520 to 36560
	print d; ":"; pYear(d); pMonth(d); pDay(d); pDoy(d); " dow";
	for m = 0 to 7
		print pWeekday(d, m);
	next
	print
next

print "-- day-of-year, including the leap-year discontinuity"
for m = 1 to 12
	print "doy 2000-"; m; "-01="; pDoyEx(2000, m, 1); " 2001="; pDoyEx(2001, m, 1)
next

print "-- TimeSerial and the h:m:s split, incl. the QB hack on negatives"
dim as double ts(0 to 15) = { 0.0, 0.5, 0.25, 0.75, 0.999988425925926, _
	1.0/86400.0, 1.0/1440.0, 0.041666666666666664, _
	-0.25, -0.75, -1.25, -1.75, -0.0, 43831.5, 43831.25, 0.9999999 }
for d = 0 to 15
	s = ts(d)
	pDecT( s, @h, @mi, @se, 1 )
	print using "qb  ##.########## -> ##:##:##"; s; h; mi; se;
	pDecT( s, @h, @mi, @se, 0 )
	print using "   noqb ##:##:##"; h; mi; se;
	print "  H/M/S="; pHour(s); pMinute(s); pSecond(s)
next
for h = 0 to 23 step 7
	for mi = 0 to 59 step 17
		for se = 0 to 59 step 23
			s = pTimeSerial(h, mi, se)
			print h; ":"; mi; ":"; se; " ser="; s; " back="; pHour(s); pMinute(s); pSecond(s)
		next
	next
next
print "TimeSerial out of range:"; pTimeSerial(25, 61, 61); pTimeSerial(-1, -1, -1); pTimeSerial(0,0,86400)

print "-- interval spellings; anything unrecognised is 0"
dim as string iv(0 to 13) = { "yyyy", "q", "m", "y", "d", "w", "ww", "h", "n", "s", _
                              "YYYY", "", "x", "mm" }
for d = 0 to 13
	print "'"; iv(d); "'="; pIntv( cast( FBC.FBSTRING ptr, @iv(d) ) )
next
print "null="; pIntv( 0 )

print "-- begin-of-week for every first-day rule"
for d = 0 to 6
	for m = 0 to 7
		y = 2021 : se = 1 : h = 1
		pBow( @y, @h, @se, m )
		print "2021-01-0"; d + 1; " fdw"; m; " -> "; y; "-"; h; "-"; se;
		y = 2021 : h = 1 : se = 1 + d
		pBow( @y, @h, @se, m )
		print "   +"; d; " -> "; y; "-"; h; "-"; se
	next
next

print "-- week numbering across a year boundary, all rules"
'' 2021-01-01 is a Friday: under the four-day rule it belongs to week 53 of
'' 2020, and asking about it with ref_year 2021 must NOT silently clamp to 1.
for y = 2019 to 2022
	for m = 0 to 3
		for h = 0 to 7
			print y; " fdy"; m; " fdw"; h; " first="; pFwoy(y, m, h); _
			      " weeks="; pWsoy(y, m, h)
		next
	next
next
for d = -4 to 4
	s = pDateSerial(2021, 1, 1) + d
	for m = 0 to 3
		print "serial"; s; " fdy"; m; " woy(2021)="; pWoy(2021, s, m, 1); _
		      " woy(2020)="; pWoy(2020, s, m, 1)
	next
next
for d = -4 to 4
	s = pDateSerial(2000, 1, 1) + d
	for h = 0 to 7
		print "y2k"; d; " fdw"; h; " ="; pWoy(2000, s, 2, h)
	next
next

print "-- the round trip, densely, over three centuries"
dim as longint acc = 0
for d = -80000 to 80000 step 37
	pDecD( d, @y, @m, @se )
	if( pDateSerial(y, m, se) <> d ) then
		print "ROUNDTRIP BROKEN at"; d; " -> "; y; "-"; m; "-"; se
	end if
	acc += y * 10000 + m * 100 + se
	acc += pWeekday(d, 1) * 7 + pDoy(d)
next
print "checksum="; acc
print "done"
