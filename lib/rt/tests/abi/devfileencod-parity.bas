'' devfileencod-parity.bas -- the ENCODING file device. Ten entry points across
'' eight fbc members.
''
'' NEEDS-GEN-LLVM
''
'' EVERY FACT HERE IS A BYTE COUNT OR A CODE POINT, never a rendered string. A
'' wstring PRINTed to a narrow console loses exactly the information this device
'' exists to preserve -- the earlier devfile-parity printed
'' `w i d e   l i n e` for a perfectly correct wstring -- so the wide results
'' below are reported as per-character hex.
''
'' FB_WCHAR IS TWO BYTES ON WINDOWS AND FOUR ON LINUX, and this file is where
'' that matters most: the same UTF-8 source yields a surrogate PAIR on Windows
'' and one unit on Linux. The differential compares tiko-rt against fbc ON THE
'' SAME TARGET, so it catches a width mistake as a difference against fbc rather
'' than as a difference between platforms -- which is the only comparison that
'' can be made from one process.

#include once "fbc-int/string.bi"

extern "rtlib"
	declare function pFileOpenEncod alias "fb_FileOpenEncod" _
		( byval s as any ptr, byval m as ulong, byval a as ulong, byval k as ulong, _
		  byval n as long, byval r as long, byval e as zstring ptr ) as long
end extern

extern "c"
	declare function pOpenEncod  alias "fb_DevFileOpenEncod" _
		( byval h as any ptr, byval f as zstring ptr, byval l as uinteger ) as long
	declare function pReadEncod  alias "fb_DevFileReadEncod" _
		( byval h as any ptr, byval d as any ptr, byval m as uinteger ptr ) as long
	declare function pReadEncodW alias "fb_DevFileReadEncodWstr" _
		( byval h as any ptr, byval d as wstring ptr, byval m as uinteger ptr ) as long
	declare function pRdLine     alias "fb_DevFileReadLineEncod" _
		( byval h as any ptr, byval d as any ptr ) as long
	declare function pRdLineW    alias "fb_DevFileReadLineEncodWstr" _
		( byval h as any ptr, byval d as wstring ptr, byval m as integer ) as long
	declare function pWrite      alias "fb_DevFileWriteEncod" _
		( byval h as any ptr, byval b as any ptr, byval c as uinteger ) as long
	declare function pWriteW     alias "fb_DevFileWriteEncodWstr" _
		( byval h as any ptr, byval b as wstring ptr, byval c as uinteger ) as long
	declare function pToChar     alias "fb_hFileRead_UTFToChar" _
		( byval fp as any ptr, byval e as long, byval d as any ptr, byval m as integer ) as integer
	declare function pToWchar    alias "fb_hFileRead_UTFToWchar" _
		( byval fp as any ptr, byval e as long, byval d as wstring ptr, byval m as integer ) as integer
end extern

dim shared as any ptr addrs( 0 to 8 )
addrs(0) = cast( any ptr, @pOpenEncod )
addrs(1) = cast( any ptr, @pReadEncod )
addrs(2) = cast( any ptr, @pReadEncodW )
addrs(3) = cast( any ptr, @pRdLine )
addrs(4) = cast( any ptr, @pRdLineW )
addrs(5) = cast( any ptr, @pWrite )
addrs(6) = cast( any ptr, @pWriteW )
addrs(7) = cast( any ptr, @pToChar )
addrs(8) = cast( any ptr, @pToWchar )

dim as long n = 0, distinct = 1
for i as integer = 0 to 8
	if( addrs(i) <> 0 ) then n += 1
	for j as integer = 0 to i - 1
		if( addrs(i) = addrs(j) ) then distinct = 0
	next
next
print "-- every ENCODING entry point resolves"
print "  count="; n; " distinct="; distinct
print "  sizeof(wstring)="; sizeof( wstring )

const fname = "tkort-encod-parity.tmp"
dim shared as string nm
nm = fname

'' Dumps a file as hex bytes, which is the only representation that shows a BOM.
sub dumpBytes( byref path as string, byref label as string )
	dim as long f = freefile
	if( open( path for binary access read as #f ) <> 0 ) then
		print "  "; label; ": <cannot open>"
		exit sub
	end if
	dim as longint sz = lof( f )
	dim as string out_ = ""
	if( sz > 0 ) then
		dim as string buf = space( sz )
		get #f, , buf
		for i as integer = 0 to sz - 1
			out_ += hex( asc( mid( buf, i + 1, 1 ) ), 2 ) + " "
		next
	end if
	close #f
	print "  "; label; " ("; sz; " bytes): "; out_
end sub

'' A wstring as code units, which is what makes the Windows/Linux width visible
'' without depending on the console.
sub dumpWstr( byval w as wstring ptr, byref label as string )
	dim as string out_ = ""
	dim as integer i = 0
	'' ASC, NOT w[i]: indexing a wstring ptr yields a wstring EXPRESSION, which
	'' HEX rejects. asc( *w, n ) is the code unit as a number, and it is
	'' one-based.
	while( asc( *w, i + 1 ) <> 0 )
		out_ += hex( asc( *w, i + 1 ), 4 ) + " "
		i += 1
		if( i > 32 ) then exit while
	wend
	print "  "; label; " ("; i; " units): "; out_
end sub

'' ------------------------------------------------------------------ the marks

'' THE BOM IS THE PROTOCOL. Three encodings, three marks, and the byte dump is
'' what proves each one was written -- a file with the right text and no mark
'' reads back correctly in the same process and fails in the next one.
print "-- the byte order marks"
dim as zstring ptr encs(0 to 2) = { @"utf8", @"utf16", @"utf32" }
for e as integer = 0 to 2
	kill fname
	open fname for output encoding *encs(e) as #1
	print #1, "AB";
	close #1
	dumpBytes( fname, "encoding " + *encs(e) )
next

'' ------------------------------------------------------------------ round trip

'' EVERY ENCODING MUST READ BACK WHAT IT WROTE, and the interesting characters
'' are the ones that need more than one code unit somewhere: U+00E9 (two UTF-8
'' bytes), U+20AC (three), U+1D11E (four, and a SURROGATE PAIR in UTF-16).
print "-- round trip through each encoding"
dim as wstring * 16 src
src = wchr( &h41 ) + wchr( &hE9 ) + wchr( &h20AC )
#if sizeof( wstring ) = 2
	'' U+1D11E as the pair the source must already be, because a two-byte
	'' wstring cannot hold it as one unit.
	src += wchr( &hD834 ) + wchr( &hDD1E )
#else
	src += wchr( &h1D11E )
#endif

for e as integer = 0 to 2
	kill fname
	open fname for output encoding *encs(e) as #1
	print #1, src;
	close #1
	dumpBytes( fname, "wrote " + *encs(e) )

	dim as wstring * 32 back
	open fname for input encoding *encs(e) as #1
	line input #1, back
	close #1
	dumpWstr( @back, "read back " + *encs(e) )
next

'' ------------------------------------------------------------------ narrow

'' A NARROW READ SUBSTITUTES '?' (63) FOR ANYTHING ABOVE 255, and a UTF-16
'' surrogate PAIR collapses to ONE '?', not two -- because the high surrogate
'' consumes its partner before substituting.
print "-- narrow reads substitute '?'"
for e as integer = 0 to 2
	kill fname
	open fname for output encoding *encs(e) as #1
	print #1, src;
	close #1

	dim as string narrow_
	open fname for input encoding *encs(e) as #1
	line input #1, narrow_
	close #1

	dim as string codes = ""
	for i as integer = 1 to len( narrow_ )
		codes += str( asc( mid( narrow_, i, 1 ) ) ) + " "
	next
	print "  "; *encs(e); " -> len="; len( narrow_ ); " codes: "; codes
next

'' ------------------------------------------------------------------ line ends

'' CR ALONE, LF ALONE AND CRLF must each end exactly one line, and a CR NOT
'' followed by LF must PUSH THE NEXT CHARACTER BACK rather than swallow it. That
'' is the put-back path, and it is the one place LINE INPUT on an encoded file
'' differs from LINE INPUT on a byte file.
print "-- line terminators, and the CR put-back"
dim as ubyte ends_(0 to 2) = { 13, 10, 0 }
for k as integer = 0 to 2
	kill fname
	'' Written as raw bytes so the terminator is exactly what is intended --
	'' PRINT # would supply the platform's own.
	open fname for output encoding "utf8" as #1
	if( ends_(k) = 0 ) then
		print #1, "one" + chr( 13 ) + chr( 10 ) + "two";
	else
		print #1, "one" + chr( ends_(k) ) + "two";
	end if
	close #1

	dim as string l1 = "?", l2 = "?"
	dim as long e1 = 0, e2 = 0
	open fname for input encoding "utf8" as #1
	line input #1, l1
	e1 = err
	line input #1, l2
	e2 = err
	close #1
	print "  terminator "; ends_(k); ": ["; l1; "] err="; e1; "  ["; l2; "] err="; e2
next

'' ------------------------------------------------------------------ errors

'' AN ASCII FILE OPENED WITH ENCODING IS ERROR 3, because the BOM check fails --
'' not a file of garbage. This is the check whose absence would be invisible in
'' every round-trip test above, since a file this program wrote always has the
'' right mark.
print "-- a missing or wrong BOM"
kill fname
open fname for output as #1        '' plain, no mark
print #1, "no mark here";
close #1
print "  ascii file opened as utf8  -> "; open( fname for input encoding "utf8" as #1 )
print "  ascii file opened as utf16 -> "; open( fname for input encoding "utf16" as #1 )
print "  ascii file opened as utf32 -> "; open( fname for input encoding "utf32" as #1 )

'' AND THE WRONG ENCODING ON A FILE THAT DOES HAVE A MARK is the same error --
'' a UTF-8 mark is not a UTF-16 mark.
kill fname
open fname for output encoding "utf8" as #1
print #1, "utf8 content";
close #1
print "  utf8 file opened as utf16  -> "; open( fname for input encoding "utf16" as #1 )
print "  utf8 file opened as utf8   -> "; open( fname for input encoding "utf8" as #1 )
close #1

'' BINARY AND RANDOM ARE REJECTED OUTRIGHT -- error 1, from the device open, not
'' from the parser: an encoded file is text and PUT# would write raw bytes into
'' it.
'' BINARY AND RANDOM ARE REJECTED BY THE DEVICE, and the check has to go
'' through fb_FileOpenEncod directly: `OPEN ... FOR BINARY ENCODING ...` is a
'' PARSE error, so FreeBASIC source cannot reach the branch at all. The mode
'' numbers are fb_file.h's -- 0 BINARY, 1 RANDOM.
print "  utf8 file, mode BINARY via fb_FileOpenEncod -> "; _
      pFileOpenEncod( @nm, 0, 0, 3, 1, 0, @"utf8" )
print "  utf8 file, mode RANDOM via fb_FileOpenEncod -> "; _
      pFileOpenEncod( @nm, 1, 0, 3, 1, 0, @"utf8" )

'' ------------------------------------------------------------------ append

'' APPEND OPENS FOR READING FIRST TO CHECK THE MARK, then reopens for append.
'' Appending must NOT add a second mark, and appending to a MISSING file must
'' add one -- the two halves of the same branch.
print "-- append"
kill fname
open fname for append encoding "utf8" as #1
print #1, "A";
close #1
dumpBytes( fname, "append to a missing file" )

open fname for append encoding "utf8" as #1
print #1, "B";
close #1
dumpBytes( fname, "append to an existing one" )

kill fname
print "done"
