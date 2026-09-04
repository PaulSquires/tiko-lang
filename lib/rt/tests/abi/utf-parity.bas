'' utf-parity.bas -- the byte<->UTF conversions: six entry points.
''
'' NEEDS-GEN-LLVM
''
'' WHAT HAS A PLAUSIBLE WRONG ANSWER HERE:
''   - a high surrogate must consume its PAIR and emit ONE '?'; skipping only
''     the high half yields two, and every later count shifts
''   - a bare continuation byte (0x80-0xBF) has trailing count 0, so it decodes
''     as a one-byte sequence rather than being rejected
''   - the returned `chars` excludes the terminator, and is the SAME whether the
''     conversion stopped on the NUL or just before it
''   - `bytes` is a BYTE count while `chars` is a CHARACTER count
''   - an unknown encoding returns NULL and leaves `bytes` untouched
''   - 0x80-0xFF must widen UNSIGNED: a signed read gives 0xFF80, not 0x0080
#include once "fbc-int/string.bi"

extern "c"
	declare sub pC2U8 alias "fb_hCharToUTF8" ( byval src as ubyte ptr, byval chars as integer, byval dst as ubyte ptr, byval total as integer ptr )
	declare function pC2U alias "fb_CharToUTF" ( byval encod as long, byval src as ubyte ptr, byval chars as integer, byval dst as ubyte ptr, byval bytes_ as integer ptr ) as ubyte ptr
	declare function pU82C alias "fb_hUTF8ToChar" ( byval src as ubyte ptr, byval dst as ubyte ptr, byval chars as integer ptr ) as ubyte ptr
	declare function pU162C alias "fb_hUTF16ToChar" ( byval src as ushort ptr, byval dst as ubyte ptr, byval chars as integer ptr ) as ubyte ptr
	declare function pU322C alias "fb_hUTF32ToChar" ( byval src as ulong ptr, byval dst as ubyte ptr, byval chars as integer ptr ) as ubyte ptr
	declare function pU2C alias "fb_UTFToChar" ( byval encod as long, byval src as any ptr, byval dst as ubyte ptr, byval chars as integer ptr ) as ubyte ptr
end extern

declare sub cfree alias "free" ( byval p as any ptr )

sub hex8( byval p as ubyte ptr, byval n as integer )
	dim as integer i = any
	dim as string o = ""
	for i = 0 to n - 1
		o += hex( p[i], 2 ) & " "
	next
	print "    ["; o; "]"
end sub

sub bytes8( byval p as ubyte ptr, byval n as integer )
	dim as integer i = any
	dim as string o = ""
	for i = 0 to n - 1
		dim as long c = p[i]
		if( c >= 32 andalso c <= 126 ) then o += chr(c) else o += "<" & c & ">"
	next
	print "    ["; o; "]"
end sub

dim as integer i = any, n = any, nb = any
dim as ubyte buf(0 to 2047)
dim as ubyte srcb(0 to 511)
dim as ushort s16(0 to 63)
dim as ulong  s32(0 to 63)

print "-- fb_hCharToUTF8 over every byte value, including the NUL"
for i = 0 to 255
	srcb(i) = i
next
pC2U8( @srcb(0), 256, @buf(0), @nb )
print "  bytes="; nb
hex8( @buf(0), 40 )
hex8( @buf(240), 40 )

print "-- fb_CharToUTF, fill mode, all four encodings incl. ASCII"
dim as ubyte ptr r = any
for i = 0 to 3
	nb = -1
	r = pC2U( i, @srcb(0), 8, @buf(0), @nb )
	print "  encod"; i; " ret<>0="; iif(r <> 0, 1, 0); " bytes="; nb
	if( r <> 0 ) then hex8( @buf(0), 32 )
next

print "-- fb_CharToUTF, alloc mode; and the chars=0 case"
for i = 1 to 3
	nb = -1
	r = pC2U( i, @srcb(128), 4, 0, @nb )
	print "  encod"; i; " alloc bytes="; nb
	if( r <> 0 ) then hex8( r, nb ) : cfree( r )
	nb = -1
	r = pC2U( i, @srcb(0), 0, 0, @nb )
	print "  encod"; i; " chars=0 ret<>0="; iif(r <> 0, 1, 0); " bytes="; nb
next

print "-- fb_hUTF8ToChar, fill mode: ASCII, 2/3/4-byte, bare continuations"
dim as ubyte u8(0 to 63)
sub setu8( u() as ubyte, b0 as long, b1 as long, b2 as long, b3 as long, b4 as long, b5 as long )
	u(0)=b0 : u(1)=b1 : u(2)=b2 : u(3)=b3 : u(4)=b4 : u(5)=b5 : u(6)=0 : u(7)=0
end sub

'' 'A', U+00E9 (C3 A9), U+20AC (E2 82 AC), U+1F600 (F0 9F 98 80), then NUL
setu8( u8(), &h41, &hC3, &hA9, &hE2, &h82, &hAC )
u8(6) = &hF0 : u8(7) = &h9F : u8(8) = &h98 : u8(9) = &h80 : u8(10) = 0
n = 16
r = pU82C( @u8(0), @buf(0), @n )
print "  fill n="; n
bytes8( @buf(0), 8 )

'' bare continuation bytes, which the table maps to a one-byte sequence
setu8( u8(), &h80, &hBF, &h41, &h00, 0, 0 )
n = 8
r = pU82C( @u8(0), @buf(0), @n )
print "  bare-continuation n="; n
hex8( @buf(0), 6 )

print "-- fb_hUTF8ToChar, alloc mode: the count must exclude the terminator"
setu8( u8(), &h41, &h42, &h43, &h00, 0, 0 )
n = -1
r = pU82C( @u8(0), 0, @n )
print "  alloc n="; n; " ret<>0="; iif(r <> 0, 1, 0)
if( r <> 0 ) then bytes8( r, 4 ) : cfree( r )

'' Long enough to force several realloc rounds of 8.
for i = 0 to 29
	u8(i) = 65 + (i mod 26)
next
u8(30) = 0
n = -1
r = pU82C( @u8(0), 0, @n )
print "  alloc-30 n="; n
if( r <> 0 ) then bytes8( r, 31 ) : cfree( r )

print "-- fill mode stopping exactly ON the NUL vs one before it"
setu8( u8(), &h41, &h42, &h00, 0, 0, 0 )
for i = 1 to 4
	n = i
	r = pU82C( @u8(0), @buf(0), @n )
	print "  max"; i; " -> n="; n; : bytes8( @buf(0), 3 )
next

print "-- fb_hUTF16ToChar: surrogate pair, unpaired low, >255"
s16(0) = &h41 : s16(1) = &hD83D : s16(2) = &hDE00 : s16(3) = &h42
s16(4) = &hDE00 : s16(5) = &h20AC : s16(6) = &h43 : s16(7) = 0
n = 16
r = pU162C( @s16(0), @buf(0), @n )
print "  fill n="; n
bytes8( @buf(0), 8 )
n = -1
r = pU162C( @s16(0), 0, @n )
print "  alloc n="; n
if( r <> 0 ) then bytes8( r, 8 ) : cfree( r )

print "-- fb_hUTF32ToChar: >255 and a NUL"
s32(0) = &h41 : s32(1) = &h1F600 : s32(2) = &hE9 : s32(3) = &h100
s32(4) = &h42 : s32(5) = 0
n = 16
r = pU322C( @s32(0), @buf(0), @n )
print "  fill n="; n
hex8( @buf(0), 8 )
n = -1
r = pU322C( @s32(0), 0, @n )
print "  alloc n="; n
if( r <> 0 ) then hex8( r, 7 ) : cfree( r )

print "-- fb_UTFToChar dispatch, including the ASCII/unknown arms"
for i = 0 to 4
	n = 8
	r = pU2C( i, @s32(0), @buf(0), @n )
	print "  encod"; i; " ret<>0="; iif(r <> 0, 1, 0); " n="; n
next

print "-- round trip: bytes -> UTF-8 -> bytes, every value"
pC2U8( @srcb(1), 255, @buf(0), @nb )
n = 255
r = pU82C( @buf(0), @srcb(256), @n )
print "  utf8 bytes="; nb; " back n="; n
dim as long bad = 0
for i = 0 to 254
	if( srcb(256 + i) <> srcb(1 + i) ) then bad += 1
next
print "  mismatches="; bad
print "done"
