'' ustrio-parity.bas -- PRINT, WRITE, INPUT # and LINE INPUT # for USTRINGs.
'' Four entry points across two fbc members.
''
'' NEEDS-GEN-LLVM
''
'' THE FILE BYTES ARE THE OBSERVABLE, not the rendered text. Every failure this
'' file exists to catch is a MOJIBAKE failure -- UTF-8 bytes widened one at a
'' time, or UTF-8 read back as if each byte were a character -- and mojibake
'' printed to a captured stdout is just as identical on both sides as correct
'' text would be. So each round trip is dumped as hex.
''
'' THE REAL-CONSOLE BRANCH IS UNREACHABLE HERE, and that is worth stating rather
'' than leaving as a silent gap: the differential captures stdout, so
'' fb_InitConsoleWindow leaves the rect empty and hIsRealConsole is FALSE for
'' every line below. What IS exercised is the other half of the same test --
'' hIsEncodedFile -- which routes to the identical wide path. The console half is
'' covered only by gate.sh, which runs with a real console.

#include once "fbc-int/string.bi"

extern "rtlib"
	declare sub      pPrintUStr alias "fb_PrintUStr" _
		( byval fnum as long, byval s as any ptr, byval mask as long )
	declare sub      pWriteUStr alias "fb_WriteUStr" _
		( byval fnum as long, byval s as any ptr, byval mask as long )
	declare function pLineInUStr alias "fb_FileLineInputUStr" _
		( byval fnum as long, byval d as any ptr ) as long
	declare function pInputUStr alias "fb_InputUStr" ( byval d as any ptr ) as long
end extern

dim shared as any ptr addrs( 0 to 3 )
addrs(0) = cast( any ptr, @pPrintUStr )
addrs(1) = cast( any ptr, @pWriteUStr )
addrs(2) = cast( any ptr, @pLineInUStr )
addrs(3) = cast( any ptr, @pInputUStr )

dim as long n = 0, distinct = 1
for i as integer = 0 to 3
	if( addrs(i) <> 0 ) then n += 1
	for j as integer = 0 to i - 1
		if( addrs(i) = addrs(j) ) then distinct = 0
	next
next
print "-- every ustring I/O entry point resolves"
print "  count="; n; " distinct="; distinct

const fname = "tkort-ustrio-parity.tmp"

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
	print "  "; label; " ("; sz; "): "; out_
end sub

'' A ustring as code units, which is the only representation that survives a
'' narrow console.
sub dumpUStr( byref u as ustring, byref label as string )
	dim as string out_ = ""
	for i as integer = 1 to len( u )
		out_ += hex( asc( u, i ), 4 ) + " "
	next
	print "  "; label; " ("; len( u ); " units): "; out_
end sub

'' U+0068 U+00E9 U+0069 -- "h", e-acute, "i". Chosen because e-acute is TWO
'' UTF-8 bytes and ONE UTF-16 unit, so a double encode and a double decode both
'' show up in the length before they show up in the characters.
'' BUILT FROM UTF-8 BYTES, because there is no `uchr`. Assigning a STRING to a
'' USTRING goes through fb_UStrAssignFromA, which DECODES UTF-8 -- so the three
'' characters arrive as three code units from four bytes, and the assignment is
'' itself the first check that the decode works.
dim shared as ustring sample
sample = "h" + chr( &hC3 ) + chr( &hA9 ) + "i"
dumpUStr( sample, "the sample" )

'' ------------------------------------------------------------- plain files

'' A PLAIN FILE IS UTF-8 BY CONSTRUCTION, so the bytes must be 68 C3 A9 69 --
'' four bytes for three characters.
print "-- PRINT # to a plain file is UTF-8"
kill fname
open fname for output as #1
pPrintUStr( 1, @sample, 0 )
close #1
dumpBytes( fname, "plain PRINT" )

print "-- and it reads back unchanged"
dim as ustring back
open fname for input as #1
pLineInUStr( 1, @back )
close #1
dumpUStr( back, "plain LINE INPUT" )

'' ------------------------------------------------------------ encoded files

'' AN ENCODED FILE MUST NOT BE PRE-ENCODED. The failure this catches wrote
'' FF FE 68 00 C3 00 A9 00 69 00 -- the UTF-8 bytes widened one at a time, ten
'' bytes for three characters instead of eight.
print "-- PRINT # to encoded files"
dim as zstring ptr encs(0 to 2) = { @"utf8", @"utf16", @"utf32" }
for e as integer = 0 to 2
	kill fname
	open fname for output encoding *encs(e) as #1
	pPrintUStr( 1, @sample, 0 )
	close #1
	dumpBytes( fname, *encs(e) + " PRINT" )
next

'' AND MUST NOT BE DECODED TWICE ON THE WAY BACK. The failure this catches gave
'' h, U+FFFD, i -- the character replaced, not merely re-encoded.
print "-- LINE INPUT # from encoded files"
for e as integer = 0 to 2
	kill fname
	open fname for output encoding *encs(e) as #1
	pPrintUStr( 1, @sample, 0 )
	close #1

	back = ""
	open fname for input encoding *encs(e) as #1
	dim as long r = pLineInUStr( 1, @back )
	close #1
	print "  "; *encs(e); " -> err="; r;
	dumpUStr( back, "" )
next

'' ------------------------------------------------------------------ WRITE

'' WRITE # quotes and comma-separates; the ENCODING decision is the same one.
print "-- WRITE # to a plain and an encoded file"
kill fname
open fname for output as #1
pWriteUStr( 1, @sample, 0 )
close #1
dumpBytes( fname, "plain WRITE" )

kill fname
open fname for output encoding "utf16" as #1
pWriteUStr( 1, @sample, 0 )
close #1
dumpBytes( fname, "utf16 WRITE" )

'' ------------------------------------------------------------------ INPUT #

'' fb_InputUStr reads from the TLS context that fb_FileInput fills in, so it is
'' driven through a real INPUT # rather than called bare.
print "-- INPUT # into ustrings"
kill fname
open fname for output as #1
print #1, "alpha,beta,gamma"
close #1

dim as ustring i1, i2, i3
open fname for input as #1
input #1, i1, i2, i3
print "  plain: ["; i1; "]"; len( i1 ); " ["; i2; "]"; len( i2 ); " ["; i3; "]"; len( i3 )
close #1

kill fname
open fname for output encoding "utf16" as #1
print #1, "alpha,beta,gamma"
close #1
open fname for input encoding "utf16" as #1
input #1, i1, i2, i3
print "  utf16: ["; i1; "]"; len( i1 ); " ["; i2; "]"; len( i2 ); " ["; i3; "]"; len( i3 )
close #1

'' ------------------------------------------------------------ line handling

'' THE ENCODED LINE READER GROWS ITS OWN BUFFER, doubling from 256 characters --
'' so a line past 256 and a line past 512 both exercise a realloc, and a
'' truncating implementation would come back short with no error.
print "-- long lines through the encoded reader"
kill fname
open fname for output encoding "utf16" as #1
print #1, string( 300, "A" )
print #1, string( 900, "B" )
print #1, "short"
close #1

open fname for input encoding "utf16" as #1
for i as integer = 1 to 3
	back = ""
	dim as long r = pLineInUStr( 1, @back )
	print "  line"; i; " err="; r; " len="; len( back )
next
close #1

'' CR, LF AND CRLF each end exactly one line, and a lone CR must PUSH BACK the
'' character after it rather than swallow it.
print "-- line terminators through the encoded reader"
kill fname
open fname for output encoding "utf8" as #1
print #1, "one" + chr( 13 ) + "two" + chr( 10 ) + "three" + chr( 13 ) + chr( 10 ) + "four";
close #1
open fname for input encoding "utf8" as #1
for i as integer = 1 to 4
	back = ""
	dim as long r = pLineInUStr( 1, @back )
	print "  line"; i; " err="; r; " len="; len( back ); " ["; back; "]"
next
close #1

'' ------------------------------------------------------------------ errors

print "-- a closed channel"
print "  LINE INPUT # on #9 -> "; pLineInUStr( 9, @back )

kill fname
print "done"
