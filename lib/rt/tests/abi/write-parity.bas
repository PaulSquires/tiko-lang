'' write-parity.bas -- the WRITE # statement: fifteen entry points.
''
'' NEEDS-GEN-LLVM
''
'' The file is read back BYTE BY BYTE and printed as escapes, because the whole
'' point of this family is the separator: CR, LF and the comma are the output,
'' and printing the text normally would hide exactly the bytes under test.
''
'' WHAT HAS A PLAUSIBLE WRONG ANSWER:
''   - the three-way separator choice, with BIN_NEWLINE taking priority over
''     NEWLINE and a COMMA (not nothing) as the fallback
''   - a bare WRITE #, which uses FB_NEWLINE even on a binary handle
''   - empty and non-empty strings, which produce the same bytes by different
''     numbers of writes
''   - negative and extreme numerics in every width, where the format modifier
''     is what decides the digits

sub dumpfile( byval nm as string )
	dim as long f = freefile
	open nm for binary access read as #f
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
		case 10 : o += "<LF>"
		case 9  : o += "<TAB>"
		case else
			if( c < 32 orelse c > 126 ) then
				o += "<" & c & ">"
			else
				o += chr(c)
			end if
		end select
	next
	print "  ["; o; "]"
end sub

dim shared as string fn_
fn_ = environ("TEMP") & "\tkort-write-test.tmp"

print "-- numerics, every width, OUTPUT mode"
dim as long f = any
f = freefile : open fn_ for output as #f
write #f, 0, 1, -1, 32767, -32768, 2147483647, -2147483648
write #f, 255, 128, -128
write #f, 9223372036854775807ll, -9223372036854775807ll - 1
write #f, 18446744073709551615ull
write #f, cbyte(-1), cubyte(255), cshort(-32768), cushort(65535)
close #f
dumpfile( fn_ )

print "-- floats"
f = freefile : open fn_ for output as #f
write #f, 0.0!, 1.5!, -1.5!, 1e20!, -1e-20!
write #f, 0.0, 1.5, -1.5, 1e20, -1e-20, 3.141592653589793
close #f
dumpfile( fn_ )

print "-- booleans"
f = freefile : open fn_ for output as #f
write #f, true, false, true
close #f
dumpfile( fn_ )

print "-- strings: empty, short, embedded quote and comma"
dim as string e_ = "", s1 = "abc", s2 = "a,b", s3 = !"q\"q"
f = freefile : open fn_ for output as #f
write #f, e_, s1, e_
write #f, s2, s3
write #f, "lit", ""
close #f
dumpfile( fn_ )

print "-- fixed-length strings"
dim as zstring * 8 z1 = "abc"
dim as zstring * 8 z2 = ""
f = freefile : open fn_ for output as #f
write #f, z1, z2, z1
close #f
dumpfile( fn_ )

print "-- wide strings"
dim as wstring * 16 w1 = wstr("abc")
dim as wstring * 16 w2 = wstr("")
f = freefile : open fn_ for output as #f
write #f, w1, w2, w1
close #f
dumpfile( fn_ )

print "-- a bare WRITE #, which does NOT use the binary newline"
f = freefile : open fn_ for output as #f
write #f,
write #f, 1
write #f,
close #f
dumpfile( fn_ )

print "-- the same values on a BINARY handle: separators must switch to CRLF"
f = freefile : open fn_ for binary access write as #f
write #f, 1, "ab", 2.5, true
write #f,
close #f
dumpfile( fn_ )

print "-- mixed record, many values, to catch a wrong mid-record separator"
f = freefile : open fn_ for output as #f
dim as long i = any
for i = -3 to 3
	write #f, i, i * 1.5, "s" & i, cbool(i > 0)
next
close #f
dumpfile( fn_ )

kill fn_
print "done"
