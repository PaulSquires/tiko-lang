'' chronoiso-parity.bas -- ISO 8601 emission and strict parsing: eight entry
'' points.
''
'' NEEDS-GEN-LLVM
''
'' THE RULES THAT PRODUCE A PLAUSIBLE WRONG STRING RATHER THAN A FAILURE:
''   - a timestamp fraction is absent or EXACTLY SEVEN digits; a duration's IS
''     trimmed. The two are opposite on purpose.
''   - 'M' is months before T (rejected) and minutes after it (accepted)
''   - 24:00 is legal ISO 8601 and is REJECTED here
''   - a fraction of more than 7 digits is TRUNCATED, not rejected
''   - a fraction of fewer than 7 is scaled UP: ".5" is half a second
''   - an absent offset is success, not failure
''   - a short buffer writes NOTHING; an out-of-range value writes a terminator
#include once "fbc-int/string.bi"

extern "rtlib"
	declare function pFmtDate alias "fb_DtIsoFormatDate" ( byval d as long, byval b as ubyte ptr, byval n as long ) as long
	declare function pFmtTime alias "fb_DtIsoFormatTime" ( byval t as longint, byval b as ubyte ptr, byval n as long ) as long
	declare function pFmt alias "fb_DtIsoFormat" ( byval t as longint, byval o as long, byval b as ubyte ptr, byval n as long ) as long
	declare function pFmtDur alias "fb_DtIsoFormatDuration" ( byval t as longint, byval b as ubyte ptr, byval n as long ) as long
	declare function pParse alias "fb_DtIsoParse" ( byval s as ubyte ptr, byval l as long, byval t as longint ptr, byval o as long ptr ) as long
	declare function pParseDate alias "fb_DtIsoParseDate" ( byval s as ubyte ptr, byval l as long, byval d as long ptr ) as long
	declare function pParseTime alias "fb_DtIsoParseTime" ( byval s as ubyte ptr, byval l as long, byval t as longint ptr ) as long
	declare function pParseDur alias "fb_DtIsoParseDuration" ( byval s as ubyte ptr, byval l as long, byval t as longint ptr ) as long
	declare function pFromCivil alias "fb_DtDaysFromCivil" ( byval y as long, byval m as long, byval d as long ) as long
	declare function pFromC alias "fb_DtFromCivil" ( byval y as long, byval m as long, byval d as long, byval h as long, byval mi as long, byval s as long, byval sub_ as longint, byval o as longint ptr ) as long
end extern

dim shared as ubyte buf(0 to 127)

function shown( byval n as long ) as string
	dim as string o = ""
	dim as long i = any
	for i = 0 to 47
		if( buf(i) = 0 ) then exit for
		o += chr( buf(i) )
	next
	return "n=" & n & " [" & o & "]"
end function

sub clr( )
	dim as long i = any
	for i = 0 to 127
		buf(i) = 254
	next
end sub

dim as long i = any, d = any, rc = any, off = any
dim as longint t = any, tod = any

print "-- format date: range ends, out of range, short buffer"
dim as long dys(0 to 7) = { 0, 1, 719162, 730179, 3652058, -1, 3652059, 1000000 }
for i = 0 to 7
	clr( ) : print "  d="; dys(i); " "; shown( pFmtDate( dys(i), @buf(0), 11 ) ); " b0="; buf(0)
next
clr( ) : print "  short "; shown( pFmtDate( 0, @buf(0), 10 ) ); " b0="; buf(0)
print "  null="; pFmtDate( 0, 0, 11 )

print "-- format time: the fraction is absent or seven digits"
dim as longint tds(0 to 8) = { 0, 1, 9999999, 10000000, 36000000000ll, _
	863999999999ll, 864000000000ll, -1, 45296123456789ll mod 864000000000ll }
for i = 0 to 8
	clr( ) : print "  t="; tds(i); " "; shown( pFmtTime( tds(i), @buf(0), 17 ) )
next
clr( ) : print "  short "; shown( pFmtTime( 0, @buf(0), 16 ) ); " b0="; buf(0)

print "-- format timestamp with every offset shape"
pFromC( 2021, 6, 15, 13, 45, 30, 1234567ll, @t )
dim as long offs(0 to 6) = { 0, 60, -60, 330, -720, 32767, 1080 }
for i = 0 to 6
	clr( ) : print "  off="; offs(i); " "; shown( pFmt( t, offs(i), @buf(0), 34 ) )
next
pFromC( 2021, 6, 15, 0, 0, 0, 0, @t )
clr( ) : print "  no-frac "; shown( pFmt( t, 0, @buf(0), 34 ) )
clr( ) : print "  invalid "; shown( pFmt( -1, 0, @buf(0), 34 ) ); " b0="; buf(0)
clr( ) : print "  short "; shown( pFmt( t, 0, @buf(0), 33 ) ); " b0="; buf(0)

print "-- format duration: trimming, zero, negative, every component"
dim as longint durs(0 to 12) = { 0, 1, 10000000ll, 5000000ll, 600000000ll, _
	36000000000ll, 864000000000ll, -864000000000ll, _
	864000000000ll * 400ll + 36000000000ll * 5 + 600000000ll * 30 + 10000000ll * 7 + 500000ll, _
	-1, 90000000ll, 599999999ll, 864000000000ll * 3 }
for i = 0 to 12
	clr( ) : print "  t="; durs(i); " "; shown( pFmtDur( durs(i), @buf(0), 40 ) )
next
clr( ) : print "  sentinel "; shown( pFmtDur( -9223372036854775807ll - 1ll, @buf(0), 40 ) ); " b0="; buf(0)
clr( ) : print "  short "; shown( pFmtDur( 0, @buf(0), 39 ) ); " b0="; buf(0)

dim shared as string cs(0 to 63)
sub init_cs( )
	cs( 0) = "2021-06-15"          : cs( 1) = "20210615"
	cs( 2) = "2021-166"            : cs( 3) = "2021166"
	cs( 4) = "2021-W24-2"          : cs( 5) = "2021W242"
	cs( 6) = "2021-w24-2"          : cs( 7) = "0001-01-01"
	cs( 8) = "9999-12-31"          : cs( 9) = "0000-01-01"
	cs(10) = "10000-01-01"         : cs(11) = "2021-02-29"
	cs(12) = "2020-02-29"          : cs(13) = "2021-00-01"
	cs(14) = "2021-13-01"          : cs(15) = "2021-366"
	cs(16) = "2020-366"            : cs(17) = "2020-367"
	cs(18) = "2021-W53-1"          : cs(19) = "2020-W53-1"
	cs(20) = "2021-W00-1"          : cs(21) = "2021-W24-0"
	cs(22) = "2021-W24-8"          : cs(23) = "2021-6-15"
	cs(24) = "2021-06-15T13:45:30" : cs(25) = "2021-06-15 13:45:30"
	cs(26) = "2021-06-15t13:45:30" : cs(27) = "2021-06-15T134530"
	cs(28) = "2021-06-15T13:45"    : cs(29) = "2021-06-15T13"
	cs(30) = "2021-06-15T13:45:30Z": cs(31) = "2021-06-15T13:45:30z"
	cs(32) = "2021-06-15T13:45:30+05:30" : cs(33) = "2021-06-15T13:45:30-0800"
	cs(34) = "2021-06-15T13:45:30+18:00" : cs(35) = "2021-06-15T13:45:30+18:01"
	cs(36) = "2021-06-15T13:45:30-18:00" : cs(37) = "2021-06-15T13:45:30+05:60"
	cs(38) = "2021-06-15T13:45:30.5"     : cs(39) = "2021-06-15T13:45:30,5"
	cs(40) = "2021-06-15T13:45:30.1234567"  : cs(41) = "2021-06-15T13:45:30.123456789"
	cs(42) = "2021-06-15T13:45:30."      : cs(43) = "2021-06-15T24:00:00"
	cs(44) = "2021-06-15T23:60:00"       : cs(45) = "2021-06-15T23:59:60"
	cs(46) = "  2021-06-15  "            : cs(47) = "2021-06-15X"
	cs(48) = "2021-06-15T13:45:30 junk"  : cs(49) = ""
	cs(50) = "2021"                      : cs(51) = "2021-06"
	cs(52) = "13:45:30"                  : cs(53) = "134530"
	cs(54) = "13:45"                     : cs(55) = "13"
	cs(56) = "12:00Z"                    : cs(57) = "00:00:00.0000001"
	cs(58) = "2021-06-15T13:45:30+5:30"  : cs(59) = "9999-12-31T23:59:59.9999999"
	cs(60) = "0001-01-01T00:00:00"       : cs(61) = "2021-06-15  13:45:30"
	cs(62) = "2021-W24-2T13:45:30"       : cs(63) = "2021-166T13:45:30"
end sub
init_cs( )

print "-- parse: timestamp, date-only and time-only, over 64 inputs"
for i = 0 to 63
	dim as string s = cs(i)
	t = 12345ll : off = 999 : d = 12345 : tod = 12345ll
	rc = pParse( iif(len(s) > 0, strptr(s), 0), len(s), @t, @off )
	print "'"; s; "' P rc="; rc; " t="; t; " off="; off;
	rc = pParseDate( iif(len(s) > 0, strptr(s), 0), len(s), @d )
	print " | D rc="; rc; " d="; d;
	rc = pParseTime( iif(len(s) > 0, strptr(s), 0), len(s), @tod )
	print " | T rc="; rc; " tod="; tod
next
print "null: P="; pParse( 0, 5, @t, @off ); " D="; pParseDate( 0, 5, @d ); " T="; pParseTime( 0, 5, @tod )
print "len0: P="; pParse( strptr(cs(0)), 0, @t, @off )
print "nullout: P="; pParse( strptr(cs(0)), 10, 0, 0 )

dim shared as string ds(0 to 39)
sub init_ds( )
	ds( 0) = "PT0S"      : ds( 1) = "P1D"      : ds( 2) = "PT1H"
	ds( 3) = "PT1M"      : ds( 4) = "PT1S"     : ds( 5) = "P1M"
	ds( 6) = "P1Y"       : ds( 7) = "P1W"      : ds( 8) = "P2W"
	ds( 9) = "PT1.5S"    : ds(10) = "PT1,5S"   : ds(11) = "P1.5D"
	ds(12) = "PT1.5H"    : ds(13) = "PT1.5M"   : ds(14) = "P"
	ds(15) = "-P1D"      : ds(16) = "+P1D"     : ds(17) = "P1DT1H"
	ds(18) = "P400DT5H30M7.05S" : ds(19) = "p1d"
	ds(20) = "PT"        : ds(21) = "P1D2D"    : ds(22) = "PT1H1H"
	ds(23) = "1D"        : ds(24) = "PD"       : ds(25) = "PT.5S"
	ds(26) = "PT0.1234567S" : ds(27) = "PT0.123456789S"
	ds(28) = "P1000000000000D" : ds(29) = "P10000000000000D"
	ds(30) = "P0D"       : ds(31) = "PT0H"     : ds(32) = "-PT0S"
	ds(33) = "P1DT"      : ds(34) = "  P1D  "  : ds(35) = "P1D "
	ds(36) = "PT60S"     : ds(37) = "PT90M"    : ds(38) = "P0000000000001D"
	ds(39) = "PT1S1"
end sub
init_ds( )

print "-- parse duration, then round trip it back through the formatter"
for i = 0 to 39
	dim as string s = ds(i)
	t = 12345ll
	rc = pParseDur( iif(len(s) > 0, strptr(s), 0), len(s), @t )
	print "'"; s; "' rc="; rc; " t="; t;
	if( rc = 0 ) then
		clr( )
		print " -> "; shown( pFmtDur( t, @buf(0), 40 ) )
	else
		print
	end if
next
print "null="; pParseDur( 0, 5, @t ); " len0="; pParseDur( strptr(ds(0)), 0, @t )
print "nullout="; pParseDur( strptr(ds(1)), 3, 0 )

print "-- emit/parse round trip over a strided range of instants"
dim as longint acc = 0
dim as long bad = 0
for i = 0 to 400
	t = 173000000000000ll + cast( longint, i ) * 7919191919ll
	clr( )
	rc = pFmt( t, 0, @buf(0), 34 )
	if( rc > 0 ) then
		dim as longint back = any
		if( pParse( @buf(0), rc, @back, @off ) <> 0 ) then
			bad += 1
		elseif( back <> t ) then
			bad += 1
		end if
		acc += rc
	end if
next
print "  roundtrip failures="; bad; " checksum="; acc
print "done"
