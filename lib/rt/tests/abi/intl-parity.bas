'' intl-parity.bas -- the locale layer's portable half, plus __fb_errmsg. Six
'' symbols across six fbc members.
''
'' NEEDS-GEN-LLVM
''
'' EVERY CALL IS MADE BOTH WAYS: with disallow_localized FALSE, which lets the
'' platform driver answer, and with it TRUE, which forces the built-in English.
'' The English answers are absolute and compare exactly; the localized ones
'' compare only because both runtimes run in the same locale, so what is asserted
'' about them is their RELATIONSHIP to the English ones -- whether the driver
'' answered at all, and whether it answered consistently.
''
'' THE TEMP DESCRIPTORS ARE DELETED. fb_IntlGetMonthName hands back a temp, and a
'' test that only read `->data` would leak one per call -- which allocation-count
'' parity, running in the same harness, would then report as a difference in a
'' completely unrelated file.
''
'' __fb_errmsg IS CHECKED FOR ITS ADDRESS, NOT ITS CONTENTS. An earlier version
'' of this check read 1024 zero bytes and passed while tiko-rt defined NO symbol
'' at all -- it was reading fbc's buffer, because tiko-rt's archive still carried
'' an undefined reference and the linker resolved it from fbc's error_message.o.
'' What distinguishes the two now is that the symbol is DEFINED, which
'' symbols.sh checks and this file cannot; so the check here is only that the
'' address is stable and the buffer is writable to its full length.

#include once "fbc-int/string.bi"

extern "c"
	declare function pIntlGet alias "fb_IntlGet" _
		( byval idx as long, byval dis as long ) as zstring ptr
	declare function pDateFmt alias "fb_IntlGetDateFormat" _
		( byval b as zstring ptr, byval l as uinteger, byval dis as long ) as long
	declare function pTimeFmt alias "fb_IntlGetTimeFormat" _
		( byval b as zstring ptr, byval l as uinteger, byval dis as long ) as long
	declare function pMonth   alias "fb_IntlGetMonthName" _
		( byval m as long, byval s as long, byval dis as long ) as any ptr
	declare function pWeekday alias "fb_IntlGetWeekdayName" _
		( byval w as long, byval s as long, byval dis as long ) as any ptr
	declare function pDelTemp alias "fb_hStrDelTemp" ( byval s as any ptr ) as long
	extern __fb_errmsg alias "__fb_errmsg" as ubyte
end extern

dim shared as any ptr addrs( 0 to 5 )
addrs(0) = cast( any ptr, @pIntlGet )
addrs(1) = cast( any ptr, @pDateFmt )
addrs(2) = cast( any ptr, @pTimeFmt )
addrs(3) = cast( any ptr, @pMonth )
addrs(4) = cast( any ptr, @pWeekday )
addrs(5) = @__fb_errmsg

dim as long n = 0, distinct = 1
for i as integer = 0 to 5
	if( addrs(i) <> 0 ) then n += 1
	for j as integer = 0 to i - 1
		if( addrs(i) = addrs(j) ) then distinct = 0
	next
next
print "-- every locale entry point resolves"
print "  count="; n; " distinct="; distinct

'' ------------------------------------------------------------ __fb_errmsg

'' The address must be stable across reads, and the whole 1024 bytes writable --
'' which is what a short definition would fail.
dim as ubyte ptr em = @__fb_errmsg
print "-- __fb_errmsg"
print "  address is stable="; ( em = @__fb_errmsg )
for i as integer = 0 to 1023
	em[i] = cast( ubyte, (i and &hFF) )
next
dim as long roundtrip = 1
for i as integer = 0 to 1023
	if( em[i] <> cast( ubyte, (i and &hFF) ) ) then roundtrip = 0
next
print "  1024 bytes round-trip="; roundtrip
for i as integer = 0 to 1023
	em[i] = 0
next

'' ------------------------------------------------------------------ dividers

'' THE FOUR INDICES AND ONE PAST THEM. An index outside the set is NULL, which is
'' the only well-formed call in this file that can be.
print "-- fb_IntlGet"
sub showDiv( byval idx as long, byref label as string )
	dim as zstring ptr a = pIntlGet( idx, 0 )
	dim as zstring ptr b = pIntlGet( idx, -1 )
	print "  "; label; " localized="; iif( a = 0, "<null>", "[" + *a + "]" ); _
	      " english="; iif( b = 0, "<null>", "[" + *b + "]" )
end sub
showDiv( 0, "DateDivider  " )
showDiv( 1, "TimeDivider  " )
showDiv( 2, "DecimalPoint " )
showDiv( 3, "Thousands    " )
showDiv( 4, "out of range " )
showDiv( -1, "negative     " )

'' ------------------------------------------------------------- the formats

'' THE BOUNDARY IS THE POINT: eleven bytes for "MM/dd/yyyy" and nine for
'' "HH:mm:ss", and one byte short is REFUSED rather than truncated.
print "-- fb_IntlGetDateFormat, English"
dim as zstring * 64 fbuf = any

sub tryDate( byval l as uinteger )
	dim as zstring * 64 b = any
	for i as integer = 0 to 63
		b[i] = 42                       '' '*', so a partial write shows
	next
	b[63] = 0
	dim as long r = pDateFmt( @b, l, -1 )
	print "  len="; l; " -> "; r; " ["; b; "]"
end sub

tryDate( 64 )
tryDate( 11 )
tryDate( 10 )
tryDate( 0 )

print "-- fb_IntlGetTimeFormat, English"
sub tryTime( byval l as uinteger )
	dim as zstring * 64 b = any
	for i as integer = 0 to 63
		b[i] = 42
	next
	b[63] = 0
	dim as long r = pTimeFmt( @b, l, -1 )
	print "  len="; l; " -> "; r; " ["; b; "]"
end sub

tryTime( 64 )
tryTime( 9 )
tryTime( 8 )
tryTime( 0 )

'' AND WITH THE DRIVER ALLOWED. Whatever the machine's locale is, both runtimes
'' see the same one -- so the answer compares, and its SHAPE is what is printed.
print "-- both formats, driver allowed"
fbuf = string( 63, "*" )
dim as long dr = pDateFmt( @fbuf, 64, 0 )
print "  date -> "; dr; " ["; fbuf; "]"
fbuf = string( 63, "*" )
dim as long tr = pTimeFmt( @fbuf, 64, 0 )
print "  time -> "; tr; " ["; fbuf; "]"

'' ------------------------------------------------------------- the names

'' THE RANGE CHECK COMES BEFORE THE DRIVER, so 0 and 13 are NULL whatever the
'' locale says -- and the temp descriptors are deleted, per the file header.
print "-- fb_IntlGetMonthName"
sub showMonth( byval m as long )
	dim as any ptr le = pMonth( m, 0, -1 )
	dim as any ptr se = pMonth( m, -1, -1 )
	dim as any ptr ll = pMonth( m, 0, 0 )
	dim as string a = "<null>", b = "<null>", c = "<null>"
	if( le <> 0 ) then a = *(*cptr( zstring ptr ptr, le )) : pDelTemp( le )
	if( se <> 0 ) then b = *(*cptr( zstring ptr ptr, se )) : pDelTemp( se )
	if( ll <> 0 ) then c = *(*cptr( zstring ptr ptr, ll )) : pDelTemp( ll )
	print "  "; m; ": english=["; a; "] short=["; b; "] localized=["; c; "]"
end sub

for m as integer = 0 to 13
	showMonth( m )
next

print "-- fb_IntlGetWeekdayName"
sub showWeekday( byval w as long )
	dim as any ptr le = pWeekday( w, 0, -1 )
	dim as any ptr se = pWeekday( w, -1, -1 )
	dim as any ptr ll = pWeekday( w, 0, 0 )
	dim as string a = "<null>", b = "<null>", c = "<null>"
	if( le <> 0 ) then a = *(*cptr( zstring ptr ptr, le )) : pDelTemp( le )
	if( se <> 0 ) then b = *(*cptr( zstring ptr ptr, se )) : pDelTemp( se )
	if( ll <> 0 ) then c = *(*cptr( zstring ptr ptr, ll )) : pDelTemp( ll )
	print "  "; w; ": english=["; a; "] short=["; b; "] localized=["; c; "]"
end sub

for w as integer = 0 to 8
	showWeekday( w )
next

'' THE WEEKDAY TABLE IS SUNDAY-FIRST, always -- fb_WeekdayName's rotation is
'' applied by the caller before it reaches here, so index 1 is Sunday and never
'' Monday.
dim as any ptr d1 = pWeekday( 1, 0, -1 )
print "  weekday 1 is Sunday="; ( *(*cptr( zstring ptr ptr, d1 )) = "Sunday" )
pDelTemp( d1 )

print "done"
