'' format-parity.bas -- FORMAT$, the mask language. Two symbols, one fbc member
'' (str_format.o).
''
'' NEEDS-GEN-LLVM
''
'' THE ONE MEMBER IN THIS STRETCH THAT CAN BE TESTED PROPERLY. Everything else
'' left in the port needs a console, a serial port or a spooler and is proved by
'' address; fb_hStrFormat takes a double and a string and returns a string. So
'' this file is a CROSS PRODUCT rather than a sample: every mask below is run
'' against every value below, several thousand cases, and each one is compared
'' byte for byte against the C runtime's answer.
''
'' THE MASKS ARE CHOSEN TO HIT THE DECISIONS, not to look representative:
''
''   THE COMMA'S TWO MEANINGS. "#,###" is a thousands separator and "###," is a
''   divide-by-1000, and the difference is only what FOLLOWS the comma -- so
''   both forms appear, along with "#,###," and "###,," which combine and stack
''   them. This is the single most intricate rule in the mask language and the
''   one a rewrite is most likely to get subtly wrong.
''
''   '#' VERSUS '0' AT EVERY POSITION. They differ only in whether a digit is
''   padded when the number has run out, so the pairs "####"/"0000",
''   "#.##"/"0.00" and the mixed "#0.0#" are all present.
''
''   THE ROUNDING BOUNDARY. 2.55 to one decimal is 2.5 under VBDOS rules and 2.6
''   under VB6's, and fbc chose VBDOS. The value list carries 2.55, 2.45, 0.5,
''   1.5, 2.5, -2.55 and -0.5 specifically to sit on that edge -- these are the
''   cases where a "cleaner" rounding implementation diverges and everything
''   else still agrees.
''
''   THE EXPONENT. "#.##E+##" and "#.##E-##" differ in whether a positive
''   exponent shows its sign; "0.0E+0" is narrower than the exponent needs and
''   forces the reprocess-the-same-mask-character path; and the huge and tiny
''   values below cross the point where 10^n would overflow a double and fbc
''   splits it into 5^n * 2^n.
''
''   THE SIGN'S POSITION. "+###", "###+", "-###" and "###-" all place it
''   differently, and a leading sign in the mask suppresses the automatic one.
''
''   THE TYPE INFERENCE. "hh:mm:ss" is a date mask, "##:##" is a NUMBER mask
''   whose colon is literal, and the first character that implies a type decides
''   for the whole string -- so both appear.
''
''   THE ESCAPES. A backslash escapes one character and a double quote opens a
''   literal run; "\#\#" and "0"" units""" prove neither is treated as a digit.
''
'' THE DATE MASKS ARE RUN ON FIXED SERIALS, never on NOW(). A test that formats
'' the current time compares two runs taken microseconds apart and will
'' eventually disagree on the second -- and will do so once a month, at 3am, in
'' someone else's session. The serials below are constants.
''
'' WHAT THIS DOES **NOT** COVER, stated plainly:
''
''   'ttttt' AND 'ddddd' recurse through the LOCALE's date and time format, so
''   what they produce depends on the machine's regional settings. They are
''   exercised -- both sides read the same locale in the same process, so the
''   comparison is valid -- but the OUTPUT is not a property of the runtime, and
''   this file cannot serve as a golden file on another machine.
''
''   The month and weekday NAMES have the same dependency, for the same reason.
''
''   A mask that pushes the measuring pass to under-allocate would corrupt the
''   heap rather than print the wrong thing, and no comparison of stdout can see
''   that. The 200-iteration loop at the end is a stability check, not a proof.

#include once "fbc-int/string.bi"

extern "rtlib"
	declare function pStrFormat alias "fb_StrFormat" _
		( byval value as double, byval mask as any ptr ) as any ptr
	declare function pHStrFormat alias "fb_hStrFormat" _
		( byval value as double, byval mask as zstring ptr, byval mask_length as uinteger ) as any ptr
end extern

print "-- resolution"
print "  count="; iif( cast( any ptr, @pStrFormat ) <> 0, 1, 0 ) + _
                  iif( cast( any ptr, @pHStrFormat ) <> 0, 1, 0 ); _
      " distinct="; iif( cast( any ptr, @pStrFormat ) <> cast( any ptr, @pHStrFormat ), 1, 0 )

'' fb_hStrFormat returns a TEMP descriptor. Handing it straight to FreeBASIC's
'' own string assignment is what deletes it; holding the pointer would leak one
'' per call and 3000 calls would show up as a very slow test rather than a
'' failing one.
dim shared as string s

'' ---------------------------------------------------------------- no mask
''
'' A NULL OR EMPTY MASK IS A DIFFERENT FUNCTION -- eleven digits of VBDOS
'' precision rather than the mask's own count.
print "-- no mask at all (fb_hBuildDouble, 11 digits)"
'' EVERY VALUE HERE HAS AN INTEGER PART BELOW 2^64, AND THAT IS LOAD-BEARING.
'' fb_hGetNumberParts casts the fixed part to `unsigned long long`, which is
'' UNDEFINED IN C once the double exceeds 2^64 -- and clang and fbc resolve it
'' differently: clang's sequence yields 0 (so FORMAT$ returns an empty string)
'' and FreeBASIC's saturates to ULLONG_MAX (so it returns 18446744073709551615).
''
'' That divergence is real and it is documented in src/str/format.bas, but it is
'' NOT something a differential can usefully assert: it compares two compilers'
'' undefined behaviour, and a different clang build would move it. Only the
'' NO-MASK path is exposed, because every masked path scales the value below
'' 2^64 before the cast -- which is why 1e20 and 1e30 are still in `vals` below.
dim shared as double bare( 0 to 17 ) = { _
	0.0, 1.0, -1.0, 0.5, -0.5, 123.456, -123.456, _
	1e-5, 1e-10, 1e-15, 1e15, 1e18, 1e-300, 5e18, _
	0.1, 2.0 / 3.0, 1.0 / 3.0, 1234567890.12345 }
for i as integer = 0 to 17
	s = *cast( string ptr, pHStrFormat( bare(i), 0, 0 ) )
	print "  [" & i & "] NULL   -> {" & s & "}"
	s = *cast( string ptr, pHStrFormat( bare(i), @"", 0 ) )
	print "  [" & i & "] len 0  -> {" & s & "}"
next

'' ------------------------------------------------------- the numeric cross

'' Chosen for the rounding edge and the exponent extremes -- see the header.
''
'' 1e300 IS DELIBERATELY ABSENT AND MUST STAY ABSENT. It CRASHES fbc's own
'' runtime, and tiko-rt's with it. A value too large for a 64-bit integer takes
'' fb_hProcessMask's "handle too big numbers" path, which appends ExpValue
'' literal '0' bytes after the digits already in FixPart -- and FixPart is
'' `char FixPart[128]` on the stack. For 1e300 that is 301 bytes into 128: a
'' stack smash in FORMAT$, reachable from any FreeBASIC program that formats a
'' large double with a non-exponent mask.
''
'' It is NOT fixed here. Reproducing fbc is the contract, and a bounds check
'' would change what FORMAT$ returns for every value between 1e109 and 1e308 --
'' a rewrite dividend inside the parity measurement. 1e30 exercises the same
'' branch (11 appended zeroes) and stays inside the buffer.
''
'' THE CEILING IS ROUGHLY 1e108: FB_MAXFIXLEN digits plus (ExpValue - 19)
'' zeroes must fit in 128 bytes.
dim shared as double vals( 0 to 29 ) = { _
	0.0, 1.0, -1.0, 0.5, -0.5, 1.5, 2.5, 2.45, 2.55, -2.55, _
	9.995, 99.995, 0.999, 0.0001, 123.0, -123.0, 1234.5678, -1234.5678, _
	999999.999, 1000000.0, 12345678901234.5, 1e19, 1e20, 1e-19, _
	3.14159265358979, -3.14159265358979, 1e-300, 1e30, 0.05, -0.05 }

dim shared as string masks( 0 to 38 )
masks(0) = "####"
masks(1) = "0000"
masks(2) = "#"
masks(3) = "0"
masks(4) = "#.##"
masks(5) = "0.00"
masks(6) = "#0.0#"
masks(7) = ".##"
masks(8) = "0."
masks(9) = "#."
masks(10) = "#,###"
masks(11) = "#,###.##"
masks(12) = "###,"
masks(13) = "###,,"
masks(14) = "#,###,"
masks(15) = "#,###.##,"
masks(16) = "+###"
masks(17) = "###+"
masks(18) = "-###"
masks(19) = "###-"
masks(20) = "+#.##"
masks(21) = "-#.##"
masks(22) = "##%"
masks(23) = "#.##%"
masks(24) = "%###"
masks(25) = "#.##E+##"
masks(26) = "#.##E-##"
masks(27) = "0.0E+0"
masks(28) = "#E+#"
masks(29) = "0.000E+00"
masks(30) = "##.##E+###"
masks(31) = "$#,###.00"
masks(32) = "(#,###.00)"
masks(33) = "* #,##0.00"
masks(34) = "\#\#"
masks(35) = "0"" units"""
masks(36) = """x""0""y"""
masks(37) = "##:##"
masks(38) = "# # #"

print "-- the numeric cross product: 39 masks x 30 values"
for m as integer = 0 to 38
	print "  mask {" & masks(m) & "}"
	for v as integer = 0 to 29
		s = *cast( string ptr, pHStrFormat( vals(v), strptr( masks(m) ), len( masks(m) ) ) )
		print "    [" & v & "] {" & s & "}"
	next
next

'' -------------------------------------------------------- the rounding edge
''
'' ISOLATED AND LABELLED, because if anything in this file is going to differ it
'' is these, and a difference buried in the cross product above is far harder to
'' read than one here.
print "-- the VBDOS rounding boundary (2.55 -> 2.5, NOT 2.6)"
dim shared as double edge( 0 to 15 ) = { _
	2.55, 2.45, 2.65, 2.75, 1.05, 1.15, 1.25, 1.35, _
	-2.55, -2.45, 0.005, 0.015, 0.025, 0.045, 0.055, 0.065 }
for i as integer = 0 to 15
	s = *cast( string ptr, pHStrFormat( edge(i), @"#.#", 3 ) )
	print "  " & edge(i) & " as #.#   -> {" & s & "}"
	s = *cast( string ptr, pHStrFormat( edge(i), @"#.##", 4 ) )
	print "  " & edge(i) & " as #.##  -> {" & s & "}"
	s = *cast( string ptr, pHStrFormat( edge(i), @"#", 1 ) )
	print "  " & edge(i) & " as #     -> {" & s & "}"
next

'' ------------------------------------------------------------ the date masks
''
'' FIXED SERIALS, never NOW() -- see the file header.
print "-- date/time masks on fixed serials"
dim shared as double serials( 0 to 5 ) = { _
	0.0, 1.0, 36526.0, 36526.5, 45000.7431, 25569.0 }

dim shared as string dmasks( 0 to 21 )
dmasks(0) = "d"
dmasks(1) = "dd"
dmasks(2) = "ddd"
dmasks(3) = "dddd"
dmasks(4) = "M"
dmasks(5) = "MM"
dmasks(6) = "MMM"
dmasks(7) = "MMMM"
dmasks(8) = "y"
dmasks(9) = "yy"
dmasks(10) = "yyy"
dmasks(11) = "yyyy"
dmasks(12) = "h"
dmasks(13) = "hh"
dmasks(14) = "H"
dmasks(15) = "HH"
dmasks(16) = "n"
dmasks(17) = "nn"
dmasks(18) = "s"
dmasks(19) = "ss"
dmasks(20) = "hh:mm:ss"
dmasks(21) = "yyyy/MM/dd"

for m as integer = 0 to 21
	print "  mask {" & dmasks(m) & "}"
	for v as integer = 0 to 5
		s = *cast( string ptr, pHStrFormat( serials(v), strptr( dmasks(m) ), len( dmasks(m) ) ) )
		print "    [" & v & "] {" & s & "}"
	next
next

'' 'm' IS MINUTES ONLY DIRECTLY AFTER AN HOUR. These four masks are the whole
'' rule, and they differ from each other only in what precedes the 'm'.
print "-- 'm' is minutes after an hour, months anywhere else"
dim shared as string mm( 0 to 7 )
mm(0) = "m"
mm(1) = "mm"
mm(2) = "mmm"
mm(3) = "hm"
mm(4) = "hmm"
mm(5) = "h:m"
mm(6) = "hh:mm"
mm(7) = "MM/dd hh:mm"
for i as integer = 0 to 7
	s = *cast( string ptr, pHStrFormat( 45000.7431, strptr( mm(i) ), len( mm(i) ) ) )
	print "  {" & mm(i) & "} -> {" & s & "}"
next

'' AM/PM AND A/P TAKE THEIR CASE FROM THE MASK, and a lone 't' emits only the
'' first letter because LenAdd is the run length rather than the word length.
print "-- AM/PM, A/P and the 't' forms"
dim shared as string ap( 0 to 9 )
ap(0) = "AM/PM"
ap(1) = "am/pm"
ap(2) = "Am/Pm"
ap(3) = "A/P"
ap(4) = "a/p"
ap(5) = "t"
ap(6) = "tt"
ap(7) = "h AM/PM"
ap(8) = "h a/p"
ap(9) = "hh:mm AM/PM"
for i as integer = 0 to 9
	s = *cast( string ptr, pHStrFormat( 36526.5, strptr( ap(i) ), len( ap(i) ) ) )
	print "  {" & ap(i) & "} at noon     -> {" & s & "}"
	s = *cast( string ptr, pHStrFormat( 36526.1, strptr( ap(i) ), len( ap(i) ) ) )
	print "  {" & ap(i) & "} in the a.m. -> {" & s & "}"
next

'' -------------------------------------------------------- the error paths
''
'' 'E' NOT FOLLOWED BY A SIGN is the one hard syntax error in the language, and
'' a second '%' or a second exponent are the other two. All three return the
'' NULL descriptor -- an empty string -- rather than raising.
print "-- the three syntax errors return an empty string"
dim shared as string bad( 0 to 6 )
bad(0) = "#.##E"
bad(1) = "#.##E#"
bad(2) = "#.##Ex"
bad(3) = "##%%"
bad(4) = "#E+#E+#"
bad(5) = "#.##E+"
bad(6) = "E+#"
for i as integer = 0 to 6
	s = *cast( string ptr, pHStrFormat( 123.456, strptr( bad(i) ), len( bad(i) ) ) )
	print "  {" & bad(i) & "} -> {" & s & "} len=" & len( s )
next

'' A MASK OF ONLY LITERALS, and a mask that is one unterminated quote -- the
'' string flag is never cleared, so the rest of the mask vanishes.
print "-- literal-only and unterminated masks"
dim shared as string lit( 0 to 5 )
lit(0) = "hello"
lit(1) = "---"
lit(2) = """abc"
lit(3) = "\"
lit(4) = "\\"
lit(5) = """"
for i as integer = 0 to 5
	s = *cast( string ptr, pHStrFormat( 42.0, strptr( lit(i) ), len( lit(i) ) ) )
	print "  {" & lit(i) & "} -> {" & s & "} len=" & len( s )
next

'' -------------------------------------------------------------- fb_StrFormat
''
'' THE OWNING WRAPPER: it deletes the mask if the mask is a temp. That delete is
'' NOT exercised here and cannot be from a test that declares the entry point
'' itself -- a temp descriptor is something fbc's CODEGEN produces at a call
'' site it recognises, and a hand-written `declare` passing @variable hands over
'' a normal string every time. Taking the address of an expression is rejected
'' outright (error 24), which is the compiler saying the same thing.
''
'' So what runs below is the non-temp path: the mask is read, the result is
'' correct, and fb_hStrDelTemp sees a descriptor without the temp bit and does
'' nothing. The temp path is reached by every `FORMAT$(x, a & b)` in fbc's own
'' suite, which is where it is actually covered.
print "-- fb_StrFormat with a non-temp mask (the temp path is fbc's suite)"
dim shared as string m2
for i as integer = 0 to 4
	m2 = "#" + string( i, "#" ) + ".0"
	s = *cast( string ptr, pStrFormat( 1234.5678, cast( any ptr, @m2 ) ) )
	print "  {" & m2 & "} -> {" & s & "}"
next

'' THE MASK MUST SURVIVE THE CALL, since it was not a temp. A wrapper that
'' deleted unconditionally would leave m2 empty here rather than crashing.
print "  mask after the call: {" & m2 & "} len=" & len( m2 )

'' ---------------------------------------------------------------- stability
''
'' NOT A LEAK CHECK. It proves the answer does not drift over enough iterations
'' that a corrupted heap would surface, which is the most a stdout comparison
'' can do here. See the file header.
print "-- 200 repeats, answer must not drift"
dim as long stable = 1
dim as string want = *cast( string ptr, pHStrFormat( 1234.5678, @"#,###.##", 8 ) )
for i as integer = 1 to 200
	s = *cast( string ptr, pHStrFormat( 1234.5678, @"#,###.##", 8 ) )
	if( s <> want ) then stable = 0
next
print "  {" & want & "} stable=" & stable

print "done"
