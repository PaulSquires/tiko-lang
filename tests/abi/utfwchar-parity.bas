'' utfwchar-parity.bas -- fb_UTFToWChar and fb_WCharToUTF, the two directions
'' between UTF-8/16/32 and the platform's WCHAR. Two entry points, two fbc
'' members.
''
'' NEEDS-GEN-LLVM
''
'' HALF OF WHAT THIS FILE COVERS DOES NOT EXIST ON ANY ONE TARGET. The
'' implementation branches on `sizeof( wchar_t )` -- two bytes on Windows, four
'' on Linux -- so win64/win32 run the UTF-16 bodies and Linux runs the UTF-32
'' ones, and a case that passes here proves nothing about the other platform's
'' code. That is why every case below is run on all three and why the expected
'' OUTPUT differs by platform: a three-code-point string is 3 wchars on Linux and
'' 4 on Windows if one of them is above the BMP.
''
'' SO THE OUTPUT IS PRINTED IN WCHARS AND IN BYTES, both, for every case. Reading
'' only one of the two hides exactly the surrogate-pair arithmetic this file
'' exists to check.
''
'' THE ROUND TRIP IS THE STRONGEST CHECK AND IT IS NOT SUFFICIENT. UTF-8 in,
'' wchars out, UTF-8 back gives the original for every well-formed input on both
'' widths -- and it would also succeed if BOTH directions were wrong in
'' compensating ways. The intermediate wchar count is therefore printed too,
'' which a round trip alone does not expose.
''
'' TWO ALLOCATING CALLS ARE MADE AND BOTH RESULTS ARE FREED. fb_UTFToWChar with
'' dst = NULL mallocs; fb_WCharToUTF with dst = NULL mallocs. A test that read
'' the buffer and dropped it would leak one block per case, which
'' allocation-count parity would then report against an unrelated file.
''
'' AND THE SUPPLIED-BUFFER MODE IS DRIVEN AT ITS BOUNDARY, deliberately: exactly
'' enough, one short, and far too short. The one-short case is where fbc
'' truncates a surrogate pair and leaves an UNPAIRED HIGH SURROGATE in the
'' caller's buffer, and where no terminator is appended -- both of which are
'' contract, not accident.
''
'' WHAT IS **NOT** TESTED HERE: fb_WCharToUTF's UTF-16 output path with a
'' CALLER-SUPPLIED buffer and an above-BMP code point. That path reallocs a
'' pointer malloc never returned -- undefined behaviour in fbc, reproduced
'' faithfully in tiko-rt -- so calling it would crash both sides, and an
'' identical crash is not evidence of identical arithmetic. It is named here
'' rather than left as a silent hole.

#include once "fbc-int/string.bi"

const ENCOD_ASCII = 0
const ENCOD_UTF8  = 1
const ENCOD_UTF16 = 2
const ENCOD_UTF32 = 3

extern "c"
	declare function pToW alias "fb_UTFToWChar" _
		( byval e as long, byval src as any ptr, byval dst as any ptr, _
		  byval chars as integer ptr ) as any ptr
	declare function pFromW alias "fb_WCharToUTF" _
		( byval e as long, byval src as any ptr, byval chars as integer, _
		  byval dst as any ptr, byval bytes as integer ptr ) as any ptr
	declare sub crt_free alias "free" ( byval p as any ptr )
end extern

print "-- both resolve"
print "  distinct="; ( cast( any ptr, @pToW ) <> cast( any ptr, @pFromW ) )

'' THE WIDTH IS PRINTED FIRST, because every number below depends on it and a
'' reader comparing two platforms' output needs to know which branch ran.
dim shared as integer WSZ = len( wstring )
print "  sizeof wchar="; WSZ

'' Renders a wchar buffer as its code units, in hex, so a surrogate pair is
'' visible AS a pair rather than as a character.
sub showW( byval p as any ptr, byval n as integer )
	print " [";
	for i as integer = 0 to n - 1
		if( WSZ = 2 ) then
			print hex( *cptr( ushort ptr, cptr( ubyte ptr, p ) + i * 2 ), 4 );
		else
			print hex( *cptr( ulong ptr, cptr( ubyte ptr, p ) + i * 4 ), 4 );
		end if
		if( i < n - 1 ) then print " ";
	next
	print "]";
end sub

'' Renders raw bytes in hex.
sub showB( byval p as any ptr, byval n as integer )
	print " [";
	for i as integer = 0 to n - 1
		print hex( *cptr( ubyte ptr, cptr( ubyte ptr, p ) + i ), 2 );
		if( i < n - 1 ) then print " ";
	next
	print "]";
end sub

'' ------------------------------------------------------ UTF-8 in, allocating

'' dst = NULL, so `chars` is ignored on entry and set on return, and the buffer
'' is ours to free.
sub fromUTF8( byref label as string, byval s as zstring ptr )
	dim as integer n = 0
	dim as any ptr w = pToW( ENCOD_UTF8, s, 0, @n )
	print "  "; label; " -> wchars="; n;
	if( w <> 0 ) then
		showW( w, n )
		crt_free( w )
	else
		print " <null>";
	end if
	print
end sub

print "-- fb_UTFToWChar, UTF-8, allocating"
fromUTF8( "empty       ", @"" )
fromUTF8( "ascii       ", @"Hello" )
fromUTF8( "one byte    ", @"A" )

'' TWO-BYTE: U+00E9 e-acute = C3 A9.
dim shared as zstring * 8 u2 = any
u2[0] = &hC3 : u2[1] = &hA9 : u2[2] = 0
fromUTF8( "2-byte U+E9 ", @u2 )

'' THREE-BYTE: U+20AC euro = E2 82 AC.
dim shared as zstring * 8 u3 = any
u3[0] = &hE2 : u3[1] = &h82 : u3[2] = &hAC : u3[3] = 0
fromUTF8( "3-byte U+20AC", @u3 )

'' FOUR-BYTE, ABOVE THE BMP: U+1F600 = F0 9F 98 80. THIS IS THE CASE THAT
'' DIFFERS BY PLATFORM -- one wchar on Linux, a surrogate PAIR (two) on Windows.
dim shared as zstring * 8 u4 = any
u4[0] = &hF0 : u4[1] = &h9F : u4[2] = &h98 : u4[3] = &h80 : u4[4] = 0
fromUTF8( "4-byte U+1F600", @u4 )

'' A MIXTURE, so the count is not a multiple of anything.
dim shared as zstring * 16 umix = any
umix[0] = asc("A") : umix[1] = &hC3 : umix[2] = &hA9 : umix[3] = &hF0
umix[4] = &h9F : umix[5] = &h98 : umix[6] = &h80 : umix[7] = asc("Z") : umix[8] = 0
fromUTF8( "mixed       ", @umix )

'' EIGHT AND NINE CHARACTERS, which straddle the eight-unit growth block -- the
'' realloc path is only entered on the ninth.
fromUTF8( "8 ascii     ", @"12345678" )
fromUTF8( "9 ascii     ", @"123456789" )
fromUTF8( "17 ascii    ", @"12345678901234567" )

'' ------------------------------------------------- UTF-8 in, supplied buffer

'' `chars` IS THE MAXIMUM ON ENTRY, and the boundary is the point -- see the
'' file header on the one-short case.
sub fromUTF8Buf( byref label as string, byval s as zstring ptr, byval cap as integer )
	dim as integer n = cap
	dim as ushort buf16(0 to 31)
	dim as ulong  buf32(0 to 31)
	dim as any ptr b = iif( WSZ = 2, cast( any ptr, @buf16(0) ), cast( any ptr, @buf32(0) ) )
	'' PRE-FILLED WITH A SENTINEL so an untouched slot is distinguishable from a
	'' written zero -- which is how "no terminator was appended" becomes visible.
	for i as integer = 0 to 31
		buf16(i) = &hEEEE : buf32(i) = &hEEEEEEEE
	next
	dim as any ptr w = pToW( ENCOD_UTF8, s, b, @n )
	print "  "; label; " cap="; cap; " -> wchars="; n;
	if( w <> 0 ) then showW( w, cap ) else print " <null>";
	print
end sub

print "-- fb_UTFToWChar, UTF-8, supplied buffer"
fromUTF8Buf( "ascii exact ", @"Hi", 3 )      '' 2 + terminator
fromUTF8Buf( "ascii tight ", @"Hi", 2 )      '' no room for the terminator
fromUTF8Buf( "ascii short ", @"Hello", 3 )
fromUTF8Buf( "empty       ", @"", 4 )
'' THE SURROGATE-PAIR BOUNDARY: on Windows cap=1 truncates the pair and leaves an
'' unpaired high surrogate; on Linux the code point fits in one wchar and does
'' not.
fromUTF8Buf( "U+1F600 cap1", @u4, 1 )
fromUTF8Buf( "U+1F600 cap2", @u4, 2 )
fromUTF8Buf( "U+1F600 cap3", @u4, 3 )

'' -------------------------------------------------------- UTF-16 and UTF-32 in

print "-- fb_UTFToWChar, UTF-16 source"
dim shared as ushort s16(0 to 7)
s16(0) = asc("A") : s16(1) = &h00E9 : s16(2) = &hD83D : s16(3) = &hDE00
s16(4) = asc("Z") : s16(5) = 0
dim as integer n16 = 0
dim as any ptr w16 = pToW( ENCOD_UTF16, @s16(0), 0, @n16 )
print "  A e-acute U+1F600 Z -> wchars="; n16;
if( w16 <> 0 ) then showW( w16, n16 ) : crt_free( w16 )
print

print "-- fb_UTFToWChar, UTF-32 source"
dim shared as ulong s32(0 to 7)
s32(0) = asc("A") : s32(1) = &h000000E9 : s32(2) = &h0001F600
s32(3) = asc("Z") : s32(4) = 0
dim as integer n32 = 0
dim as any ptr w32 = pToW( ENCOD_UTF32, @s32(0), 0, @n32 )
print "  A e-acute U+1F600 Z -> wchars="; n32;
if( w32 <> 0 ) then showW( w32, n32 ) : crt_free( w32 )
print

'' AN UNKNOWN ENCODING IS NULL. ASCII lands here too -- a narrow file never
'' reaches this entry point at all.
dim as integer nbad = 0
print "  encod=ASCII -> "; ( pToW( ENCOD_ASCII, @"x", 0, @nbad ) = 0 ); " (null expected)"
print "  encod=99    -> "; ( pToW( 99, @"x", 0, @nbad ) = 0 ); " (null expected)"

'' ------------------------------------------------------------- the other way

'' `chars` COUNTS WCHARS GOING IN, so a surrogate pair is passed as TWO on
'' Windows and one code point is one wchar on Linux -- which is why the input is
'' built from the platform's own width rather than from a fixed table.
sub toUTF( byref label as string, byval e as long, byval src as any ptr, byval nch as integer )
	dim as integer b = 0
	dim as any ptr r = pFromW( e, src, nch, 0, @b )
	print "  "; label; " chars="; nch; " -> bytes="; b;
	if( r <> 0 ) then
		showB( r, b )
		crt_free( r )
	else
		print " <null>";
	end if
	print
end sub

'' The same five code points, in the platform's wchar width.
dim shared as ushort w16buf(0 to 15)
dim shared as ulong  w32buf(0 to 15)
dim shared as integer nw
if( WSZ = 2 ) then
	w16buf(0) = asc("A") : w16buf(1) = &h00E9 : w16buf(2) = &h20AC
	w16buf(3) = &hD83D : w16buf(4) = &hDE00 : w16buf(5) = asc("Z")
	nw = 6
else
	w32buf(0) = asc("A") : w32buf(1) = &h000000E9 : w32buf(2) = &h000020AC
	w32buf(3) = &h0001F600 : w32buf(4) = asc("Z")
	nw = 5
end if
'' ASSIGNED, NOT INITIALISED: a shared initialiser must be a CONSTANT, and
'' iif() over an address is not one (error 11).
dim shared as any ptr wsrc
if( WSZ = 2 ) then
	wsrc = cast( any ptr, @w16buf(0) )
else
	wsrc = cast( any ptr, @w32buf(0) )
end if

print "-- fb_WCharToUTF, allocating"
toUTF( "to UTF-8    ", ENCOD_UTF8,  wsrc, nw )
toUTF( "to UTF-16   ", ENCOD_UTF16, wsrc, nw )
toUTF( "to UTF-32   ", ENCOD_UTF32, wsrc, nw )

'' ZERO CHARACTERS: nothing is allocated at all, so the return is whatever dst
'' was -- NULL -- and `bytes` is still written. That asymmetry is the contract.
dim as integer bz = 999
dim as any ptr rz = pFromW( ENCOD_UTF8, wsrc, 0, 0, @bz )
print "  zero chars, UTF-8 -> ptr null="; ( rz = 0 ); " bytes="; bz
bz = 999
rz = pFromW( ENCOD_UTF16, wsrc, 0, 0, @bz )
print "  zero chars, UTF-16 -> ptr null="; ( rz = 0 ); " bytes="; bz

'' AN UNKNOWN ENCODING LEAVES `bytes` UNTOUCHED, unlike the three real ones,
'' which all write it before they can fail.
bz = 12345
rz = pFromW( ENCOD_ASCII, wsrc, nw, 0, @bz )
print "  encod=ASCII -> null="; ( rz = 0 ); " bytes untouched="; ( bz = 12345 )

'' ASCII ONLY, so the UTF-8 result is one byte per character and the worst-case
'' allocation of chars*4 is visibly four times what was needed.
dim shared as ushort a16(0 to 7)
dim shared as ulong  a32(0 to 7)
for i as integer = 0 to 4
	a16(i) = asc("a") + i : a32(i) = asc("a") + i
next
toUTF( "ascii UTF-8 ", ENCOD_UTF8, iif( WSZ = 2, cast( any ptr, @a16(0) ), cast( any ptr, @a32(0) ) ), 5 )

'' AN EMBEDDED NUL IS CONVERTED, NOT A TERMINATOR -- the length is known, so
'' this direction does not stop on it. That is the difference from fb_UTFToWChar
'' and it is the case a naive implementation gets wrong.
a16(2) = 0 : a32(2) = 0
toUTF( "embedded NUL", ENCOD_UTF8, iif( WSZ = 2, cast( any ptr, @a16(0) ), cast( any ptr, @a32(0) ) ), 5 )

'' -------------------------------------------------------------- round trip

'' UTF-8 -> wchars -> UTF-8. Strong, and not sufficient on its own -- the
'' intermediate count is printed because two compensating errors would survive
'' the round trip alone. See the file header.
print "-- round trip, UTF-8 -> wchar -> UTF-8"
sub roundTrip( byref label as string, byval s as zstring ptr )
	dim as integer n = 0
	dim as any ptr w = pToW( ENCOD_UTF8, s, 0, @n )
	if( w = 0 ) then
		print "  "; label; " -> <null>"
		exit sub
	end if
	dim as integer b = 0
	dim as any ptr r = pFromW( ENCOD_UTF8, w, n, 0, @b )
	print "  "; label; " wchars="; n; " bytes="; b;
	if( r <> 0 ) then
		showB( r, b )
		crt_free( r )
	end if
	print
	crt_free( w )
end sub

roundTrip( "ascii       ", @"Hello" )
roundTrip( "2-byte      ", @u2 )
roundTrip( "3-byte      ", @u3 )
roundTrip( "4-byte      ", @u4 )
roundTrip( "mixed       ", @umix )

'' ------------------------------------------------------- bulk, at benchmark size

'' THE SIZE THE BENCHMARK USES, AND FOR THE SAME REASON THE BENCHMARK EXISTS.
'' Every fill-mode case above uses a capacity of 1 to 4 characters, so a bug that
'' only appears once a conversion runs for hundreds of characters -- an early
'' exit, a miscounted terminator, a growth step never taken -- would pass all of
'' them.
''
'' Gate 4 reported these two entry points at 0.28x-0.53x against C, which is too
'' fast to be codegen. The first thing to rule out is that tiko-rt is simply
'' doing LESS WORK, and this is the check that rules it out: same input, same
'' capacity, and the full output compared unit by unit through a checksum rather
'' than by eye.
print "-- bulk conversion at 512 characters"

const BULK = 512

dim shared as ubyte  bsrc( 0 to 4 * BULK + 8 )
dim shared as ushort bw16( 0 to 2 * BULK + 8 )
dim shared as ulong  bw32( 0 to 2 * BULK + 8 )
dim shared as any ptr bdst
if( WSZ = 2 ) then bdst = cast( any ptr, @bw16(0) ) else bdst = cast( any ptr, @bw32(0) )

'' A checksum over the produced units, order-sensitive, so a shifted or
'' truncated result cannot collide with a correct one.
function wsum( byval p as any ptr, byval n as integer ) as ulongint
	dim as ulongint h = 1469598103934665603ull
	for i as integer = 0 to n - 1
		dim as ulongint v = any
		if( WSZ = 2 ) then
			v = *cptr( ushort ptr, cptr( ubyte ptr, p ) + i * 2 )
		else
			v = *cptr( ulong ptr, cptr( ubyte ptr, p ) + i * 4 )
		end if
		h = (h xor v) * 1099511628211ull
	next
	return h
end function

sub bulkToW( byref label as string, byval nb as integer )
	dim as integer cap = 2 * BULK
	dim as any ptr w = pToW( ENCOD_UTF8, @bsrc(0), bdst, @cap )
	print "  "; label; " -> wchars="; cap; " ok="; ( w <> 0 ); _
	      " checksum="; hex( wsum( bdst, cap ), 16 )
end sub

'' ASCII: 512 bytes in, 512 wchars out on both widths.
dim as integer nb = 0
for i as integer = 0 to BULK - 1
	bsrc(nb) = 32 + (i mod 90) : nb += 1
next
bsrc(nb) = 0
bulkToW( "ascii  ", nb )

'' BMP: 1536 bytes in, 512 wchars out on both widths.
nb = 0
for i as integer = 0 to BULK - 1
	bsrc(nb) = &hE2 : bsrc(nb+1) = &h82 : bsrc(nb+2) = &hAC : nb += 3
next
bsrc(nb) = 0
bulkToW( "bmp    ", nb )

'' SUPPLEMENTARY: 2048 bytes in, and the count DIFFERS BY WIDTH -- 1024 wchars
'' on Windows (surrogate pairs), 512 on Linux. That difference is the contract.
nb = 0
for i as integer = 0 to BULK - 1
	bsrc(nb) = &hF0 : bsrc(nb+1) = &h9F : bsrc(nb+2) = &h98 : bsrc(nb+3) = &h80 : nb += 4
next
bsrc(nb) = 0
bulkToW( "supp   ", nb )

'' AND THE REVERSE DIRECTION at the same size, with the byte output summed the
'' same way.
print "-- bulk fb_WCharToUTF at 512 characters"
dim shared as ubyte bout( 0 to 4 * BULK + 8 )

function bsum( byval p as any ptr, byval n as integer ) as ulongint
	dim as ulongint h = 1469598103934665603ull
	for i as integer = 0 to n - 1
		h = (h xor cptr( ubyte ptr, p )[i]) * 1099511628211ull
	next
	return h
end function

sub bulkFromW( byref label as string, byval nw as integer )
	dim as integer nbytes = 4 * BULK
	dim as any ptr r = pFromW( ENCOD_UTF8, bdst, nw, @bout(0), @nbytes )
	print "  "; label; " -> bytes="; nbytes; " ok="; ( r <> 0 ); _
	      " checksum="; hex( bsum( @bout(0), nbytes ), 16 )
end sub

for i as integer = 0 to BULK - 1
	bw16(i) = 32 + (i mod 90)
	bw32(i) = 32 + (i mod 90)
next
bulkFromW( "ascii  ", BULK )

for i as integer = 0 to BULK - 1
	bw16(i) = &h20AC
	bw32(i) = &h20AC
next
bulkFromW( "bmp    ", BULK )

print "done"
