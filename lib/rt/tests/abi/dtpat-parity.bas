'' dtpat-parity.bas -- custom pattern formatting and strict parsing.
''
'' NEEDS-GEN-LLVM
''
'' WHAT HAS A PLAUSIBLE WRONG ANSWER:
''   - "d"/"dd" are the DAY OF MONTH, "ddd"/"dddd" the WEEKDAY NAME
''   - a ONE-character pattern is a NAMED format, so "d" is the short date
''   - "Y" is the ISO WEEK-YEAR and disagrees with "yyyy" at a year boundary
''   - "F" trims trailing zeros AND takes a preceding '.' with it
''   - "h" maps midnight to 12, not 0
''   - "R" and "u" convert to UTC FIRST, and are format-only on parse
''   - an unrecognised letter is a pattern ERROR, not a literal
''   - a variable-width numeric beside another numeric is rejected outright
''   - a named weekday is cross-checked against the date
#include once "fbc-int/string.bi"

extern "rtlib"
	declare function pFmt alias "fb_DtPatFormat" ( byval t as longint, byval o as long, byval p as ubyte ptr, byval pl as long, byval b as ubyte ptr, byval bl as long ) as long
	declare function pParse alias "fb_DtPatParse" ( byval s as ubyte ptr, byval sl as long, byval p as ubyte ptr, byval pl as long, byval t as longint ptr, byval o as long ptr ) as long
	declare function pFromC alias "fb_DtFromCivil" ( byval y as long, byval m as long, byval d as long, byval h as long, byval mi as long, byval s as long, byval sub_ as longint, byval o as longint ptr ) as long
end extern

dim shared as ubyte buf(0 to 255)

function shown( byval n as long ) as string
	if( n < 0 ) then return "ERR"
	dim as string o = ""
	dim as long i = any
	for i = 0 to n - 1
		o += chr( buf(i) )
	next
	return "'" & o & "'"
end function

dim as longint t = any, t2 = any
dim as long rc = any, off = any, i = any, k = any

dim shared as string pats(0 to 39)
sub init_pats( )
	pats( 0) = "yyyy-MM-dd"        : pats( 1) = "yy-M-d"
	pats( 2) = "y"                 : pats( 3) = "yyyyy"
	pats( 4) = "MMM"               : pats( 5) = "MMMM"
	pats( 6) = "ddd"               : pats( 7) = "dddd"
	pats( 8) = "ddd, dd MMM yyyy"  : pats( 9) = "D"
	pats(10) = "DDD"               : pats(11) = "Q"
	pats(12) = "w"                 : pats(13) = "ww"
	pats(14) = "Y-ww"              : pats(15) = "g"
	pats(16) = "HH:mm:ss"          : pats(17) = "H:m:s"
	pats(18) = "hh:mm tt"          : pats(19) = "h t"
	pats(20) = "HH:mm:ss.fff"      : pats(21) = "HH:mm:ss.FFF"
	pats(22) = "HH:mm:ss.fffffff"  : pats(23) = "HH:mm:ss.FFFFFFF"
	pats(24) = "z"                 : pats(25) = "zz"
	pats(26) = "zzz"               : pats(27) = "K"
	pats(28) = "'lit'yyyy"         : pats(29) = "\yyyy"
	pats(30) = "yyyy'It''s'MM"     : pats(31) = "q"
	pats(32) = "o"                 : pats(33) = "O"
	pats(34) = "s"                 : pats(35) = "d"
	pats(36) = "T"                 : pats(37) = "u"
	pats(38) = "R"                 : pats(39) = "dM"
end sub
init_pats( )

print "-- format: every pattern over several instants and offsets"
dim shared as long ys(0 to 5), ms(0 to 5), ds(0 to 5), hs(0 to 5), mis(0 to 5), ss(0 to 5)
dim shared as longint subs_(0 to 5)
ys(0)=2021 : ms(0)= 6 : ds(0)=15 : hs(0)=13 : mis(0)=45 : ss(0)=30 : subs_(0)=1234567ll
ys(1)=2021 : ms(1)= 1 : ds(1)= 1 : hs(1)= 0 : mis(1)= 0 : ss(1)= 0 : subs_(1)=0
ys(2)=2020 : ms(2)=12 : ds(2)=31 : hs(2)=23 : mis(2)=59 : ss(2)=59 : subs_(2)=9999999ll
ys(3)=2024 : ms(3)= 2 : ds(3)=29 : hs(3)=12 : mis(3)= 0 : ss(3)= 0 : subs_(3)=5000000ll
ys(4)=   1 : ms(4)= 1 : ds(4)= 1 : hs(4)= 0 : mis(4)= 0 : ss(4)= 0 : subs_(4)=0
ys(5)=9999 : ms(5)=12 : ds(5)=31 : hs(5)=23 : mis(5)=59 : ss(5)=59 : subs_(5)=9999999ll

dim shared as long offs(0 to 3)
offs(0) = 0 : offs(1) = 330 : offs(2) = -480 : offs(3) = 32767

for k = 0 to 5
	pFromC( ys(k), ms(k), ds(k), hs(k), mis(k), ss(k), subs_(k), @t )
	for i = 0 to 39
		dim as string pt = pats(i)
		print "k"; k; " '"; pt; "'";
		dim as long j = any
		for j = 0 to 3
			print " "; shown( pFmt( t, offs(j), strptr(pt), len(pt), @buf(0), 256 ) );
		next
		print
	next
next

print "-- format guards: null buffer, tiny buffer, bad ticks, empty pattern"
pFromC( 2021, 6, 15, 0, 0, 0, 0, @t )
print "  null="; pFmt( t, 0, strptr(pats(0)), 10, 0, 256 )
print "  tiny="; pFmt( t, 0, strptr(pats(0)), 10, @buf(0), 7 )
print "  badticks="; pFmt( -1, 0, strptr(pats(0)), 10, @buf(0), 256 )
print "  emptypat="; shown( pFmt( t, 0, strptr(pats(0)), 0, @buf(0), 256 ) )
print "  nullpat="; pFmt( t, 0, 0, 10, @buf(0), 256 )

print "-- parse: round trip each formatted value back through its own pattern"
dim as long bad = 0, roundtripped = 0
for k = 0 to 5
	pFromC( ys(k), ms(k), ds(k), hs(k), mis(k), ss(k), subs_(k), @t )
	for i = 0 to 39
		dim as string pt = pats(i)
		dim as long n = pFmt( t, 0, strptr(pt), len(pt), @buf(0), 256 )
		if( n > 0 ) then
			t2 = 12345ll : off = 999
			rc = pParse( @buf(0), n, strptr(pt), len(pt), @t2, @off )
			print "k"; k; " '"; pt; "' -> "; shown(n); " parse rc="; rc; " t="; t2; " off="; off
			if( rc = 0 ) then
				roundtripped += 1
				if( t2 <> t ) then bad += 1
			end if
		end if
	next
next
print "  round-tripped="; roundtripped; " mismatched="; bad

print "-- parse: the cases that must FAIL, and with which code"
dim shared as string bs(0 to 17), bp(0 to 17)
bs( 0) = "2021-06-15"  : bp( 0) = "yyyy-MM-dd"
bs( 1) = "2021-06-15x" : bp( 1) = "yyyy-MM-dd"
bs( 2) = "2021-06"     : bp( 2) = "yyyy-MM-dd"
bs( 3) = "21-06-15"    : bp( 3) = "yy-MM-dd"
bs( 4) = "123"         : bp( 4) = "dM"
bs( 5) = "2021-13-01"  : bp( 5) = "yyyy-MM-dd"
bs( 6) = "2021-02-30"  : bp( 6) = "yyyy-MM-dd"
bs( 7) = "Monday 2025-03-04" : bp( 7) = "dddd yyyy-MM-dd"
bs( 8) = "Tuesday 2025-03-04": bp( 8) = "dddd yyyy-MM-dd"
bs( 9) = "2021-166"    : bp( 9) = "yyyy-DDD"
bs(10) = "2021-166-07-01" : bp(10) = "yyyy-DDD-MM-dd"
bs(11) = "2021-166-06-15" : bp(11) = "yyyy-DDD-MM-dd"
bs(12) = "12:00:00"    : bp(12) = "HH:mm:ss"
bs(13) = "12:00 AM"    : bp(13) = "hh:mm tt"
bs(14) = "12:00 PM"    : bp(14) = "hh:mm tt"
bs(15) = "12:00"       : bp(15) = "hh:mm"
bs(16) = "2021"        : bp(16) = "Q"
bs(17) = "2021"        : bp(17) = "R"
for i = 0 to 17
	t2 = 12345ll : off = 999
	rc = pParse( strptr(bs(i)), len(bs(i)), strptr(bp(i)), len(bp(i)), @t2, @off )
	print "  '"; bs(i); "' by '"; bp(i); "' rc="; rc; " t="; t2; " off="; off
next

print "-- parse: the optional dot before an F run"
dim shared as string fs_(0 to 3)
fs_(0) = "12:00:00.500" : fs_(1) = "12:00:00" : fs_(2) = "12:00:00." : fs_(3) = "12:00:00.5"
for i = 0 to 3
	t2 = 12345ll
	rc = pParse( strptr(fs_(i)), len(fs_(i)), strptr(pats(21)), len(pats(21)), @t2, 0 )
	print "  '"; fs_(i); "' rc="; rc; " t="; t2
next

print "-- parse guards"
print "  nulls="; pParse( 0, 5, strptr(pats(0)), 10, @t2, @off );
print " nullpat="; pParse( strptr(bs(0)), 10, 0, 10, @t2, @off );
print " patlen0="; pParse( strptr(bs(0)), 10, strptr(pats(0)), 0, @t2, @off );
print " nullout="; pParse( strptr(bs(0)), 10, strptr(pats(0)), 10, 0, 0 )
print "done"
