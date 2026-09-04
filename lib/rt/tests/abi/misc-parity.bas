'' misc-parity.bas -- the I18N flag, ENVIRON, the ustring array destructors and
'' the DATE/TIME string parsers. Ten entry points across four fbc members.
''
'' NEEDS-GEN-LLVM
''
'' THE PARSER BLOCK IS THE SUBSTANCE. It accepts a date, a time, or both in
'' EITHER order, with an optional comma between them, and whatever is left must
'' be nothing but whitespace -- so a trailing token makes the whole parse fail
'' rather than being ignored. Every one of those is a place a reimplementation
'' can differ while still looking right on the obvious inputs, so the table below
'' includes the near-misses: a lone date where a time was demanded, a time
'' followed by junk, an empty string.
''
'' THE ARRAY DESTRUCTORS ARE CHECKED THROUGH ALLOCATION COUNTS, not through the
'' contents of the freed array. Reading a destructed element is undefined on both
'' runtimes and would compare two different kinds of garbage; what is observable
'' is that ERASE on a dynamic ustring array leaves it empty and can be redimmed
'' and refilled, and that doing it twice does not fault.
''
'' WHAT HAS A PLAUSIBLE WRONG ANSWER:
''   - I18N starts TRUE, not FALSE
''   - ENVIRON of a variable that does not exist is "" and not an error
''   - SETENVIRON takes "NAME=VALUE" as one string and is visible to ENVIRON
''     afterwards
''   - a date alone parses when only a date was wanted, and fails when a time
''     was also demanded
''   - "01-02-2003 04:05:06" and "04:05:06 01-02-2003" both parse

extern "rtlib"
	declare sub      pI18nSet alias "fb_I18nSet" ( byval v as long )
	declare function pI18nGet alias "fb_I18nGet" ( ) as long

	declare function pDateTimeParse alias "fb_DateTimeParse" _
		( byval s as any ptr, byval d as long ptr, byval mo as long ptr, byval y as long ptr, _
		  byval h as long ptr, byval mi as long ptr, byval sec as long ptr, _
		  byval wd as long, byval wt as long ) as long
	declare function pDateParse alias "fb_DateParse" _
		( byval s as any ptr, byval d as long ptr, byval mo as long ptr, byval y as long ptr ) as long
	declare function pTimeParse alias "fb_TimeParse" _
		( byval s as any ptr, byval h as long ptr, byval mi as long ptr, byval sec as long ptr ) as long
end extern

'' fb_DateParse takes an FBSTRING DESCRIPTOR, not a raw pointer.
''
'' The helper is DSTR and its parameter is `txt`, not `D`/`s`: FreeBASIC is
'' CASE-INSENSITIVE, so a parameter `s` inside a function `S` is a duplicated
'' definition, and so is a local `d` anywhere in a file that has a function `D`.
dim shared as string sbuf
function DSTR( byref txt as string ) as any ptr
	sbuf = txt
	return @sbuf
end function


print "-- I18N starts on"
print "  initial="; pI18nGet( )
pI18nSet( 0 )
print "  after set 0="; pI18nGet( )
pI18nSet( 1 )
print "  after set 1="; pI18nGet( )
pI18nSet( 7 )
print "  after set 7="; pI18nGet( )
pI18nSet( 1 )

print "-- ENVIRON"
print "  missing='"; environ( "TKORT_NO_SUCH_VAR_12345" ); "'"
print "  set rc="; setenviron( "TKORT_PROBE=hello" )
print "  now='"; environ( "TKORT_PROBE" ); "'"
print "  overwrite rc="; setenviron( "TKORT_PROBE=again" )
print "  now='"; environ( "TKORT_PROBE" ); "'"
print "  empty name='"; environ( "" ); "'"
print "  PATH nonempty="; iif( len( environ( "PATH" ) ) > 0, 1, 0 )

print "-- DateParse"
sub showDate( byref t as string )
	dim as long d = -1, mo = -1, y = -1
	dim as long r = pDateParse( DSTR(t), @d, @mo, @y )
	print "  '"; t; "' -> "; r; " d="; d; " mo="; mo; " y="; y
end sub
showDate( "01-02-2003" )
showDate( "1/2/2003" )
showDate( "2003-02-01" )
showDate( "29-02-2004" )
showDate( "31-02-2003" )
showDate( "not a date" )
showDate( "" )
showDate( "01-02-2003 " )
showDate( "01-02-2003 junk" )

print "-- TimeParse"
sub showTime( byref t as string )
	dim as long h = -1, mi = -1, sec = -1
	dim as long r = pTimeParse( DSTR(t), @h, @mi, @sec )
	print "  '"; t; "' -> "; r; " h="; h; " mi="; mi; " s="; sec
end sub
showTime( "04:05:06" )
showTime( "4:05" )
showTime( "16:05:06" )
showTime( "4:05:06 pm" )
showTime( "25:00:00" )
showTime( "nope" )
showTime( "" )

print "-- DateTimeParse takes either order, and an optional comma"
sub showBoth( byref t as string, byval wd as long, byval wt as long )
	dim as long d = -1, mo = -1, y = -1, h = -1, mi = -1, sec = -1
	dim as long r = pDateTimeParse( DSTR(t), @d, @mo, @y, @h, @mi, @sec, wd, wt )
	print "  '"; t; "' wd="; wd; " wt="; wt; " -> "; r; _
	      " "; d; "/"; mo; "/"; y; " "; h; ":"; mi; ":"; sec
end sub
showBoth( "01-02-2003 04:05:06", 1, 1 )
showBoth( "01-02-2003, 04:05:06", 1, 1 )
showBoth( "04:05:06 01-02-2003", 1, 1 )
showBoth( "04:05:06, 01-02-2003", 1, 1 )
showBoth( "01-02-2003", 1, 0 )
showBoth( "01-02-2003", 1, 1 )
showBoth( "04:05:06", 0, 1 )
showBoth( "04:05:06", 1, 1 )
showBoth( "01-02-2003 04:05:06 junk", 1, 1 )
showBoth( "", 1, 1 )
showBoth( "   ", 1, 1 )

print "-- ustring arrays survive ERASE and refill"
redim as ustring u( 0 to 4 )
for i as integer = 0 to 4
	u(i) = "element-" & i & "-" & string( i * 7, "x" )
next
print "  filled last='"; str( u(4) ); "' len="; len( u(4) )
erase u
print "  erased"
redim u( 0 to 2 )
for i as integer = 0 to 2
	u(i) = "again-" & i
next
print "  refilled='"; str( u(0) ); "' '"; str( u(2) ); "'"
erase u
erase u
print "  double erase survived"

'' A FIXED-LENGTH array must NOT be freed by ERASE -- only cleared.
dim as ustring f( 0 to 2 )
for i as integer = 0 to 2
	f(i) = "fixed-" & i
next
erase f
print "  fixed erase survived, len(0)="; len( f(0) )
f(0) = "reused"
print "  reusable='"; str( f(0) ); "'"

print "done"
