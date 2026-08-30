'' spctab-parity.bas -- SPC, TAB and WIDTH # against a FILE handle.
''
'' NEEDS-GEN-LLVM
''
'' THE FILE PATH ONLY. On a screen these ask the console for the cursor and
'' LOCATE; that is not reproducible in a differential, and it is covered by
'' fbc's own suite through the gate. Against a file there is no cursor, so TAB
'' emits a newline plus padding and SPC emits spaces -- which is exactly the
'' branch a test can pin down.
''
'' WHAT HAS A PLAUSIBLE WRONG ANSWER:
''   - TAB to a column BEHIND the current one wraps to the next line
''   - TAB to a column ahead pads on the current line
''   - the newline TAB emits is the BINARY one on a binary handle, which is
''     CRLF on Linux too
''   - SPC(0) does nothing at all, and must not even initialise the screen
''   - WIDTH # returns the current width for -1 and an error code otherwise

dim shared as string fn_
fn_ = environ("TEMP") & "\tkort-spc-test.tmp"

sub dumpfile( )
	dim as long f = freefile
	open fn_ for binary access read as #f
	dim as longint n = lof(f)
	dim as string s = space(n)
	if( n > 0 ) then get #f, , s
	close #f
	dim as long i = any
	dim as string o = ""
	for i = 1 to len(s)
		dim as long c = asc(mid(s, i, 1))
		select case c
		case 13 : o += "<CR>"
		case 10 : o += "<LF>" & !"\n  "
		case 32 : o += "."
		case else : o += chr(c)
		end select
	next
	print "  ["; o; "]"
end sub

dim as long f = any, i = any, k = any

print "-- TAB over a text file: ahead, behind, zero, negative, past the width"
f = freefile : open fn_ for output as #f
for i = 0 to 9
	print #f, "ab"; tab(i * 5); "X"
next
print #f, "start"; tab(3); "back"; tab(20); "fwd"
print #f, tab(0); "z"
print #f, tab(-5); "n"
close #f
dumpfile( )

print "-- SPC over a text file, including 0"
f = freefile : open fn_ for output as #f
for i = 0 to 6
	print #f, "a"; spc(i); "b"
next
print #f, "x"; spc(0); "y"
close #f
dumpfile( )

print "-- the same over a BINARY handle: the newline must be CRLF"
f = freefile : open fn_ for binary access write as #f
print #f, "ab"; tab(1); "X"
print #f, "cd"; spc(3); "Y"
close #f
dumpfile( )

print "-- WIDTH #: query, set, requery, and a closed handle"
f = freefile : open fn_ for output as #f
print "  default="; width( #f )
print "  set80="; width( #f, 80 )
print "  after="; width( #f )
print "  set20="; width( #f, 20 )
print "  after="; width( #f )
print #f, "0123456789012345678901234567890"
close #f
dumpfile( )
print "  closed="; width( #f )

kill fn_
print "done"
