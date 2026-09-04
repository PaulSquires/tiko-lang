'' printusg-parity.bas -- PRINT USING: ten entry points, exercised through the
'' language rather than the entry points, because the format cursor is state
'' that only the compiler's call sequence drives correctly.
''
'' NEEDS-GEN-LLVM
''
'' The output goes to a FILE and is dumped byte by byte: PRINT USING is all
'' about padding, and trailing spaces are invisible in a terminal.
''
'' WHAT HAS A PLAUSIBLE WRONG ANSWER:
''   - "**", "$$", "**$" and "+" fields, where a single '*' or '$' is literal
''     text and only the doubled form starts a field
''   - a positive number blanking its first digit so it lines up with a
''     negative one, and an implicit '-' stealing a digit position
''   - '%' where the value does not fit, rather than a silently wrong number
''   - commas every third digit, counted over positions that include commas
''   - "^^^^" scientific form, and carets that are literal when too few
''   - "&" choosing the field from the VALUE, differently for SINGLE and DOUBLE
''   - INF/NAN text truncated into a field, padded from "$000"
''   - the format restarting when it runs out, so one field formats a list
''   - "_" escaping the next character

dim shared as string fn_
fn_ = environ("TEMP") & "\tkort-usg-test.tmp"

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

print "-- integer fields: width, overflow, sign, commas, padding"
dim shared as string ifmt(0 to 15)
ifmt( 0) = "#"        : ifmt( 1) = "###"      : ifmt( 2) = "#####"
ifmt( 3) = "+###"     : ifmt( 4) = "###+"     : ifmt( 5) = "###-"
ifmt( 6) = "**###"    : ifmt( 7) = "$$###"    : ifmt( 8) = "**$###"
ifmt( 9) = "#,###,###": ifmt(10) = "##.##"    : ifmt(11) = ".###"
ifmt(12) = "#.#"      : ifmt(13) = "########################"
ifmt(14) = "&"        : ifmt(15) = "#^^^^"
dim shared as longint ivals(0 to 11)
ivals(0) = 0 : ivals(1) = 1 : ivals(2) = -1 : ivals(3) = 9
ivals(4) = 10 : ivals(5) = 99 : ivals(6) = 100 : ivals(7) = -100
ivals(8) = 123456789 : ivals(9) = -123456789
ivals(10) = 9223372036854775807ll : ivals(11) = -9223372036854775807ll - 1ll

f = freefile : open fn_ for output as #f
for i = 0 to 15
	for k = 0 to 11
		print #f, using ifmt(i); ivals(k)
	next
next
close #f
dumpfile( )

print "-- the same formats over DOUBLE"
dim shared as double dvals(0 to 13)
dvals( 0) = 0.0    : dvals( 1) = 1.0     : dvals( 2) = -1.0
dvals( 3) = 0.5    : dvals( 4) = -0.5    : dvals( 5) = 3.14159265358979
dvals( 6) = 1e20   : dvals( 7) = -1e-20  : dvals( 8) = 99.995
dvals( 9) = 0.0001 : dvals(10) = 123456.789 : dvals(11) = 1e300
dvals(12) = 2.5    : dvals(13) = 3.5
f = freefile : open fn_ for output as #f
for i = 0 to 15
	for k = 0 to 13
		print #f, using ifmt(i); dvals(k)
	next
next
close #f
dumpfile( )

print "-- SINGLE, where '&' caps at 7 digits"
dim shared as single svals(0 to 7)
svals(0) = 0.0! : svals(1) = 1.0! : svals(2) = -1.5! : svals(3) = 3.14159265!
svals(4) = 1e20! : svals(5) = 1e-20! : svals(6) = 16777216.0! : svals(7) = 0.1!
f = freefile : open fn_ for output as #f
for i = 0 to 15
	for k = 0 to 7
		print #f, using ifmt(i); svals(k)
	next
next
close #f
dumpfile( )

print "-- INF, IND and NaN into fields of every width"
dim as double zero_ = 0.0, one_ = 1.0
dim shared as double bad_(0 to 2)
bad_(0) = one_ / zero_
bad_(1) = -one_ / zero_
bad_(2) = zero_ / zero_
f = freefile : open fn_ for output as #f
for i = 0 to 15
	for k = 0 to 2
		print #f, using ifmt(i); bad_(k)
	next
next
close #f
dumpfile( )

print "-- exponent fields, and carets too few to be one"
dim shared as string efmt(0 to 7)
efmt(0) = "#^^"     : efmt(1) = "#^^^"    : efmt(2) = "#^^^^"   : efmt(3) = "#^^^^^"
efmt(4) = "##.##^^^^" : efmt(5) = "+#.#^^^^" : efmt(6) = "#.#^^^^-" : efmt(7) = "#^^^^^^"
f = freefile : open fn_ for output as #f
for i = 0 to 7
	for k = 0 to 13
		print #f, using efmt(i); dvals(k)
	next
next
close #f
dumpfile( )

print "-- string fields: !, &, and \ \ of several widths"
dim shared as string svs(0 to 5)
svs(0) = "" : svs(1) = "a" : svs(2) = "ab" : svs(3) = "abcde"
svs(4) = "abcdefghij" : svs(5) = "x y"
dim shared as string sfmt(0 to 5)
sfmt(0) = "!" : sfmt(1) = "&" : sfmt(2) = "\\" : sfmt(3) = "\ \"
sfmt(4) = "\   \" : sfmt(5) = "[\    \]"
f = freefile : open fn_ for output as #f
for i = 0 to 5
	for k = 0 to 5
		print #f, using sfmt(i); svs(k)
	next
next
close #f
dumpfile( )

print "-- literal text, escapes, and the format restarting mid-list"
f = freefile : open fn_ for output as #f
print #f, using "a#b#c#"; 1; 2; 3
print #f, using "###"; 1; 2; 3; 4
print #f, using "x=### y=###"; 7; 8
print #f, using "_#_&_!##"; 5
print #f, using "100% of ###"; 42
print #f, using "$#.##"; 1.5
print #f, using "$$#.##"; 1.5
print #f, using "*#"; 3
print #f, using "**#"; 3
print #f, using "&"; "str"
print #f, using "###"; true; false
print #f, using "&"; true; false
close #f
dumpfile( )

print "-- wide and ustring fields"
dim as wstring * 32 w1 = wstr("wide")
dim as ustring us1 = "ustr"
f = freefile : open fn_ for output as #f
for i = 0 to 5
	print #f, using sfmt(i); w1
next
for i = 0 to 5
	print #f, using sfmt(i); us1
next
close #f
dumpfile( )

kill fn_
print "done"
