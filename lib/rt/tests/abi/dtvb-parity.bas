'' dtvb-parity.bas -- DATEADD, DATEPART, DATEDIFF.
''
'' NEEDS-GEN-LLVM
''
'' THE CASES THAT PRODUCE A PLAUSIBLE WRONG ANSWER RATHER THAN A FAILURE:
''
''   Jan 31 + 1 month. Saturation gives Feb 28/29; carrying gives Mar 2/3.
''   Both are dates, both round-trip, and only one is right.
''
''   Adding a NEGATIVE month count across a year boundary. The carry uses two
''   different divisions depending on sign; using one for both is wrong by
''   exactly one year for month <= 0.
''
''   DATEPART("ww") in early January under the four-day and full-week rules,
''   where the honest answer is a week of the PREVIOUS year and the first
''   computation comes out negative.
''
''   DATEDIFF("w") with the arguments swapped. The correction's sign is fixed
''   by argument order, so diff(a,b) is NOT always -diff(b,a). Both directions
''   are asked below for every pair.
''
''   DATEDIFF("d") across midnight one minute apart -- one day, not zero.
''
''   An unrecognised interval sets ERR and still returns a number.
#include once "fbc-int/string.bi"

extern "rtlib"
	declare function pAdd alias "fb_DateAdd" ( byval iv as FBC.FBSTRING ptr, byval n as double, byval s as double ) as double
	declare function pPart alias "fb_DatePart" ( byval iv as FBC.FBSTRING ptr, byval s as double, byval fdw as long, byval fdy as long ) as long
	declare function pDiff alias "fb_DateDiff" ( byval iv as FBC.FBSTRING ptr, byval s1 as double, byval s2 as double, byval fdw as long, byval fdy as long ) as longint
	declare function pSerial alias "fb_DateSerial" ( byval y as long, byval m as long, byval d as long ) as long
	declare function pTSerial alias "fb_TimeSerial" ( byval h as long, byval m as long, byval s as long ) as double
	declare function pYear alias "fb_Year" ( byval s as double ) as long
	declare function pMonth alias "fb_Month" ( byval s as double ) as long
	declare function pDay alias "fb_Day" ( byval s as double ) as long
	declare function pErrGet alias "fb_ErrorGetNum" ( ) as long
	declare function pErrSet alias "fb_ErrorSetNum" ( byval n as long ) as long
end extern

'' Assigned, not initialised: var-len strings cannot carry an initialiser.
dim shared as string ivs(0 to 12)
sub init_ivs( )
	ivs(0) = "yyyy" : ivs(1) = "q"  : ivs(2) = "m"  : ivs(3) = "y"
	ivs(4) = "d"    : ivs(5) = "w"  : ivs(6) = "ww" : ivs(7) = "h"
	ivs(8) = "n"    : ivs(9) = "s"  : ivs(10) = "zz": ivs(11) = ""
	ivs(12) = "MM"
end sub
init_ivs( )

function IV( byval i as long ) as FBC.FBSTRING ptr
	return cast( FBC.FBSTRING ptr, @ivs(i) )
end function

sub show( byval s as double )
	print pYear(s); "-"; pMonth(s); "-"; pDay(s);
end sub

dim as long i = any, k = any, n = any
dim as double s = any, r = any

print "-- DATEADD: month-end saturation, every interval, both signs"
dim as long sy(0 to 5) = { 2000, 2000, 1999, 2000, 2001, 2000 }
dim as long sm(0 to 5) = {    1,    3,   12,    2,    2,    5 }
dim as long sd(0 to 5) = {   31,   31,   31,   29,   28,   31 }
for k = 0 to 5
	s = pSerial( sy(k), sm(k), sd(k) ) + pTSerial( 13, 45, 30 )
	print "base "; : show(s) : print
	for i = 0 to 12
		for n = -25 to 25 step 5
			r = pAdd( IV(i), n, s )
			print "  +"; n; " '"; ivs(i); "' -> "; : show(r)
			print " err="; pErrGet(); " raw="; r
		next
	next
next

print "-- DATEADD with a fractional count: FIX truncates toward zero"
for k = 0 to 6
	s = pSerial( 2000, 1, 31 )
	print "n="; (k - 3) + 0.7; " -> "; : show( pAdd( IV(2), (k - 3) + 0.7, s ) ) : print
	print "n="; (k - 3) - 0.7; " -> "; : show( pAdd( IV(2), (k - 3) - 0.7, s ) ) : print
next

print "-- DATEPART over a year boundary, all rules"
for k = -6 to 6
	s = pSerial( 2021, 1, 1 ) + k
	for i = 0 to 12
		print "'"; ivs(i); "'"; k; ":";
		for n = 0 to 3
			print pPart( IV(i), s, 1, n );
		next
		print " fdw:";
		for n = 0 to 7
			print pPart( IV(i), s, n, 2 );
		next
		print " err="; pErrGet()
	next
next

print "-- DATEDIFF both directions, for every interval"
dim as double pa(0 to 7) = { 0, 0, 0, 0, 0, 0, 0, 0 }
dim as double pb(0 to 7) = { 0, 0, 0, 0, 0, 0, 0, 0 }
pa(0) = pSerial(2000,1,1)              : pb(0) = pSerial(2000,1,1) + 0.9999
pa(1) = pSerial(2000,1,1) + 0.99930555 : pb(1) = pSerial(2000,1,2) + 0.00069444
pa(2) = pSerial(1999,12,31)            : pb(2) = pSerial(2000,1,1)
pa(3) = pSerial(2020,12,28)            : pb(3) = pSerial(2021,1,4)
pa(4) = pSerial(2000,1,31)             : pb(4) = pSerial(2000,3,1)
pa(5) = pSerial(1900,1,1)              : pb(5) = pSerial(2100,12,31)
pa(6) = pSerial(2000,6,15) + 0.5       : pb(6) = pSerial(2000,6,15) + 0.5
pa(7) = pSerial(2001,3,1)              : pb(7) = pSerial(2000,3,1)

for k = 0 to 7
	for i = 0 to 12
		print "pair"; k; " '"; ivs(i); "' fwd="; pDiff( IV(i), pa(k), pb(k), 1, 1 );
		print " rev="; pDiff( IV(i), pb(k), pa(k), 1, 1 );
		print " err="; pErrGet()
	next
next

print "-- DATEDIFF week/weekday across every first-day pair"
for n = 0 to 7
	for i = 0 to 3
		print "fdw"; n; " fdy"; i; _
		      " w="; pDiff( IV(5), pa(3), pb(3), n, i ); _
		      " rev="; pDiff( IV(5), pb(3), pa(3), n, i ); _
		      " ww="; pDiff( IV(6), pa(3), pb(3), n, i ); _
		      " rev="; pDiff( IV(6), pb(3), pa(3), n, i )
	next
next

print "-- the error is set, and the value is still returned"
'' PRINT CLEARS THE ERROR NUMBER -- a successful I/O statement resets ERR, so
'' every value below is captured first and printed only at the end. Printing
'' inline reads 0 every time and makes the error path look dead.
dim as long e1 = any, e2 = any, e3 = any, e4 = any, e5 = any
dim as double v1 = any, v4 = any
dim as long v2 = any
dim as longint v3 = any
dim as long v5 = any
pErrSet( 0 ) : v1 = pAdd( IV(10), 3, 40000.0 )            : e1 = pErrGet()
pErrSet( 0 ) : v2 = pPart( IV(10), 40000.0, 1, 1 )        : e2 = pErrGet()
pErrSet( 0 ) : v3 = pDiff( IV(10), 40000.0, 40100.0, 1, 1 ) : e3 = pErrGet()
pErrSet( 0 ) : v4 = pAdd( 0, 3, 40000.0 )                 : e4 = pErrGet()
pErrSet( 9 ) : v5 = pPart( IV(2), 40000.0, 1, 1 )         : e5 = pErrGet()
print "add zz ="; v1; " err="; e1
print "part zz="; v2; " err="; e2
print "diff zz="; v3; " err="; e3
print "add null="; v4; " err="; e4
print "a good call clears a preset 9:"; v5; " err="; e5

print "-- a dense sweep, checksummed"
dim as longint acc = 0
for k = -3000 to 3000 step 91
	s = pSerial(2000,1,1) + k + 0.375
	for i = 0 to 9
		acc += clngint( pAdd( IV(i), k mod 17, s ) * 1000.0 )
		acc += pPart( IV(i), s, (k and 7), (k and 3) )
		acc += pDiff( IV(i), s, s + k, 1, 2 )
	next
next
print "checksum="; acc
print "done"
