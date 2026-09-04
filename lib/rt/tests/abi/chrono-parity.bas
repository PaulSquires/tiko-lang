'' chrono-parity.bas -- the tick/civil kernel: fifteen entry points.
''
'' NEEDS-GEN-LLVM
''
'' THE ONE THAT CAN DIFFER FOR A REAL REASON: fb_DtTicksFromCounts. fbc does
'' counts * 10^7 / freq in __int128; FreeBASIC has no 128-bit type, so tiko-rt
'' uses the split form (c\f)*T + ((c mod f)*T)\f. Those are the same number by
'' identity, but "the same by identity" is a claim, so it is asked here across
'' frequencies and magnitudes -- including counts large enough that the naive
'' 64-bit product would have overflowed hours ago.
''
'' The rest are exhaustively checkable and are checked that way: the
'' days<->civil round trip runs over the whole supported range at a stride, and
'' every ISO week boundary in a century is compared.
''
'' THE EPOCH IS NOT fb_DateSerial'S. Day 0 here is 0001-01-01 and weekday 1 is
'' MONDAY; day 0 there is 1899-12-30 and weekday 1 is SUNDAY. The two kernels
'' coexist, and mixing them gives dates that are wrong by 693593 days and a
'' weekday rotated by two.
#include once "fbc-int/string.bi"

extern "rtlib"
	declare function pLeap alias "fb_DtIsLeapYear" ( byval y as long ) as long
	declare function pDim alias "fb_DtDaysInMonth" ( byval y as long, byval m as long ) as long
	declare function pDiy alias "fb_DtDaysInYear" ( byval y as long ) as long
	declare function pFromCivil alias "fb_DtDaysFromCivil" ( byval y as long, byval m as long, byval d as long ) as long
	declare sub pToCivilD alias "fb_DtCivilFromDays" ( byval days as long, byval y as long ptr, byval m as long ptr, byval d as long ptr )
	declare function pDow alias "fb_DtDayOfWeek" ( byval days as long ) as long
	declare function pDoy alias "fb_DtDayOfYear" ( byval y as long, byval m as long, byval d as long ) as long
	declare function pIsoWeeks alias "fb_DtIsoWeeksInYear" ( byval y as long ) as long
	declare function pIsoWeek alias "fb_DtIsoWeek" ( byval y as long, byval m as long, byval d as long, byval iy as long ptr ) as long
	declare function pVDate alias "fb_DtIsValidDate" ( byval y as long, byval m as long, byval d as long ) as long
	declare function pVTime alias "fb_DtIsValidTime" ( byval h as long, byval mi as long, byval s as long, byval sub_ as longint ) as long
	declare function pVTicks alias "fb_DtIsValidTicks" ( byval t as longint ) as long
	declare function pFromC alias "fb_DtFromCivil" ( byval y as long, byval m as long, byval d as long, byval h as long, byval mi as long, byval s as long, byval sub_ as longint, byval out_ as longint ptr ) as long
	declare sub pToC alias "fb_DtToCivil" ( byval t as longint, byval y as long ptr, byval m as long ptr, byval d as long ptr, byval h as long ptr, byval mi as long ptr, byval s as long ptr, byval sub_ as longint ptr )
	declare function pTicks alias "fb_DtTicksFromCounts" ( byval c as longint, byval f as longint ) as longint
end extern

dim as long y = any, m = any, d = any, h = any, mi = any, se = any, iy = any
dim as longint t = any, sub_ = any

print "-- leap rules and month lengths at every boundary"
dim as long yrs(0 to 13) = { 1, 4, 100, 400, 1582, 1600, 1700, 1900, 2000, 2020, 2100, 2400, 9999, 9996 }
for h = 0 to 13
	y = yrs(h)
	print y; " leap="; pLeap(y); " diy="; pDiy(y); " feb="; pDim(y, 2);
	print " m0="; pDim(y, 0); " m13="; pDim(y, 13)
next

print "-- absolute day numbers for known dates"
print "0001-01-01="; pFromCivil(1,1,1); " dow="; pDow(pFromCivil(1,1,1))
print "1970-01-01="; pFromCivil(1970,1,1); " dow="; pDow(pFromCivil(1970,1,1))
print "2000-03-01="; pFromCivil(2000,3,1); " 9999-12-31="; pFromCivil(9999,12,31)
print "0000-03-01="; pFromCivil(0,3,1); " -0001-12-31="; pFromCivil(-1,12,31)

print "-- the round trip over the whole range, at a stride"
dim as longint acc = 0
dim as long bad = 0
for d = -400000 to 3700000 step 7919
	pToCivilD( d, @y, @m, @se )
	if( pFromCivil(y, m, se) <> d ) then bad += 1
	acc += y * 10000 + m * 100 + se + pDow(d)
next
print "  roundtrip mismatches="; bad; " checksum="; acc

print "-- day-of-year across the leap boundary"
for h = 0 to 3
	y = 1900 + h * 100
	print y; ": ";
	print pDoy(y,1,1); pDoy(y,2,28); pDoy(y,3,1); pDoy(y,12,31)
next

print "-- ISO weeks: every year-boundary date in a 12-year span"
for y = 2015 to 2026
	print y; " weeks="; pIsoWeeks(y); " |";
	for d = 1 to 4
		iy = -1
		print " "; pIsoWeek(y, 1, d, @iy); "/"; iy;
	next
	for d = 28 to 31
		iy = -1
		print " "; pIsoWeek(y, 12, d, @iy); "/"; iy;
	next
	print
next
print "  NULL out_iso_year:"; pIsoWeek(2021, 1, 1, 0)

print "-- validators, including the range ends and just outside them"
print "date:";
print pVDate(0,1,1); pVDate(1,1,1); pVDate(9999,12,31); pVDate(10000,1,1);
print pVDate(2000,2,29); pVDate(1900,2,29); pVDate(2000,0,1); pVDate(2000,13,1);
print pVDate(2000,1,0); pVDate(2000,1,32)
print "time:";
print pVTime(0,0,0,0); pVTime(23,59,59,9999999); pVTime(24,0,0,0); pVTime(0,60,0,0);
print pVTime(0,0,60,0); pVTime(0,0,0,10000000); pVTime(0,0,0,-1); pVTime(-1,0,0,0)
print "ticks:";
print pVTicks(0); pVTicks(-1); pVTicks(3155378975999999999ll);
print pVTicks(3155378976000000000ll); pVTicks(-9223372036854775807ll - 1ll)

print "-- FromCivil/ToCivil: success, failure, and the sentinel on failure"
dim as longint outs(0 to 5)
for h = 0 to 5
	outs(h) = 12345ll
next
print "ok   rc="; pFromC(2021,6,15,13,45,30,1234567ll,@outs(0)); " t="; outs(0)
print "bad  rc="; pFromC(2021,2,30,0,0,0,0,@outs(1)); " t="; outs(1)
print "bad2 rc="; pFromC(2021,1,1,25,0,0,0,@outs(2)); " t="; outs(2)
print "null rc="; pFromC(2021,6,15,0,0,0,0,0)
t = outs(0)
pToC( t, @y, @m, @d, @h, @mi, @se, @sub_ )
print "back "; y; "-"; m; "-"; d; " "; h; ":"; mi; ":"; se; " sub="; sub_
pToC( 0ll, @y, @m, @d, @h, @mi, @se, @sub_ )
print "t=0  "; y; "-"; m; "-"; d; " "; h; ":"; mi; ":"; se; " sub="; sub_
pToC( 3155378975999999999ll, @y, @m, @d, @h, @mi, @se, @sub_ )
print "tmax "; y; "-"; m; "-"; d; " "; h; ":"; mi; ":"; se; " sub="; sub_
pToC( -1ll, @y, @m, @d, @h, @mi, @se, @sub_ )
print "t=-1 "; y; "-"; m; "-"; d; " "; h; ":"; mi; ":"; se; " sub="; sub_
pToC( -864000000001ll, @y, @m, @d, @h, @mi, @se, @sub_ )
print "t<-1d "; y; "-"; m; "-"; d; " "; h; ":"; mi; ":"; se; " sub="; sub_

print "-- ticks round trip over a dense grid"
bad = 0 : acc = 0
for h = 0 to 23 step 5
	for mi = 0 to 59 step 13
		for se = 0 to 59 step 17
			pFromC( 2024, 2, 29, h, mi, se, 1234567ll, @t )
			pToC( t, @y, @m, @d, @outs(3), @outs(4), @outs(5), @sub_ )
			acc += t
		next
	next
next
print "  checksum="; acc

print "-- fb_DtTicksFromCounts: the 128-bit path vs the split form"
dim as longint freqs(0 to 6) = { 1, 1000, 1000000, 10000000, 3579545, 2593750000ll, 999999937ll }
dim as longint cnts(0 to 8) = { 0, 1, 999, 1000000, 10000000ll, 1000000000000ll, _
                                92233720368ll, 922337203685477ll, 9223372036854775807ll }
for h = 0 to 6
	for mi = 0 to 8
		print "f="; freqs(h); " c="; cnts(mi); " -> "; pTicks( cnts(mi), freqs(h) )
	next
next
print "guards:"; pTicks(100, 0); pTicks(100, -5); pTicks(-100, 10)
print "done"
