'' utf_conv.bas -- the benchmark RFC-0004 section 6 said could stop the project.
''
'' Section 3.3 named UTF-8<->UTF-16 conversion as the single most likely place
'' for FreeBASIC to lose, and section 6 committed in advance: "If the unicode
'' group is still out of budget AFTER those [#macro, pointer-width indices],
'' that is the finding that should stop the project, not one to work around."
''
'' This is the cleanest comparison in the whole harness. fbc's ustr_utf.o has NO
'' undefined symbols -- no libc, no allocator, nothing from the rest of the
'' runtime -- so there is no allocation policy underneath to confound the
'' result the way str_concat's did. What is measured is code generation and
'' nothing else.
''
'' The mixes are separated because they exercise different work: ASCII is the
'' one-byte fast path, BMP is the three-byte path, and supplementary characters
'' are the surrogate-pair path. Ill-formed input gets its own case because the
'' maximal-subpart rule is branch-heavy in a way valid input never is, and a
'' decoder can be fast on clean text and slow on dirty text.

extern "c"   '' NON-FBCALL
    declare function u8to16  alias "fb_hUtf8ToUtf16"  ( byval s as ubyte ptr, byval nb as integer, byval d as ushort ptr, byval du as integer ) as integer
    declare function u16to8  alias "fb_hUtf16ToUtf8"  ( byval s as ushort ptr, byval nu as integer, byval d as ubyte ptr, byval db as integer ) as integer
    declare function u32to16 alias "fb_hUtf32ToUtf16" ( byval s as ulong ptr,  byval nu as integer, byval d as ushort ptr, byval du as integer ) as integer
    declare function u16to32 alias "fb_hUtf16ToUtf32" ( byval s as ushort ptr, byval nu as integer, byval d as ulong ptr,  byval du as integer ) as integer
    declare function cpat    alias "fb_hUStrCodepointAt" ( byval s as ushort ptr, byval ln as integer, byval i as integer, byval used as integer ptr ) as ulong
end extern

const N     = 20000
const CHARS = 512

dim shared as ubyte  src8(0 to 4 * CHARS + 8)
dim shared as ushort src16(0 to 2 * CHARS + 8)
dim shared as ulong  src32(0 to CHARS + 8)
dim shared as ubyte  dst8(0 to 4 * CHARS + 8)
dim shared as ushort dst16(0 to 2 * CHARS + 8)
dim shared as ulong  dst32(0 to 2 * CHARS + 8)

dim as double t0
dim as integer guard = 0
dim as integer n8 = 0, n16 = 0, n32 = 0

'' ---------------------------------------------------------------- ASCII
n8 = 0
for i as integer = 0 to CHARS - 1
    src8(n8) = 32 + (i mod 90) : n8 += 1
next
t0 = timer
for i as integer = 1 to N
    guard += u8to16( @src8(0), n8, @dst16(0), 2 * CHARS )
next
print "u8to16_ascii "; timer - t0

'' ------------------------------------------------------ BMP, three bytes
n8 = 0
for i as integer = 0 to CHARS - 1
    src8(n8) = &hE2 : src8(n8+1) = &h82 : src8(n8+2) = &hAC : n8 += 3
next
t0 = timer
for i as integer = 1 to N
    guard += u8to16( @src8(0), n8, @dst16(0), 2 * CHARS )
next
print "u8to16_bmp "; timer - t0

'' --------------------------------------- supplementary, surrogate pairs
n8 = 0
for i as integer = 0 to CHARS - 1
    src8(n8) = &hF0 : src8(n8+1) = &h9F : src8(n8+2) = &h98 : src8(n8+3) = &h80 : n8 += 4
next
t0 = timer
for i as integer = 1 to N
    guard += u8to16( @src8(0), n8, @dst16(0), 2 * CHARS )
next
print "u8to16_supp "; timer - t0

'' ------------------------------ ill-formed: the maximal-subpart branches
n8 = 0
for i as integer = 0 to CHARS - 1
    src8(n8) = &hF0 : src8(n8+1) = &h82 : src8(n8+2) = &h82 : src8(n8+3) = &hAC : n8 += 4
next
t0 = timer
for i as integer = 1 to N
    guard += u8to16( @src8(0), n8, @dst16(0), 2 * CHARS )
next
print "u8to16_illformed "; timer - t0

'' --------------------------------------------------- measure-only pass
n8 = 0
for i as integer = 0 to CHARS - 1
    src8(n8) = 32 + (i mod 90) : n8 += 1
next
t0 = timer
for i as integer = 1 to N
    guard += u8to16( @src8(0), n8, 0, 0 )
next
print "u8to16_measure "; timer - t0

'' ------------------------------------------------------ UTF-16 -> UTF-8
n16 = 0
for i as integer = 0 to CHARS - 1
    src16(n16) = 32 + (i mod 90) : n16 += 1
next
t0 = timer
for i as integer = 1 to N
    guard += u16to8( @src16(0), n16, @dst8(0), 4 * CHARS )
next
print "u16to8_ascii "; timer - t0

n16 = 0
for i as integer = 0 to CHARS - 1
    src16(n16) = &h20AC : n16 += 1
next
t0 = timer
for i as integer = 1 to N
    guard += u16to8( @src16(0), n16, @dst8(0), 4 * CHARS )
next
print "u16to8_bmp "; timer - t0

n16 = 0
for i as integer = 0 to CHARS \ 2 - 1
    src16(n16) = &hD83D : src16(n16+1) = &hDE00 : n16 += 2
next
t0 = timer
for i as integer = 1 to N
    guard += u16to8( @src16(0), n16, @dst8(0), 4 * CHARS )
next
print "u16to8_supp "; timer - t0

'' ------------------------------------------------------ UTF-32 <-> UTF-16
n32 = 0
for i as integer = 0 to CHARS - 1
    src32(n32) = &h20AC : n32 += 1
next
t0 = timer
for i as integer = 1 to N
    guard += u32to16( @src32(0), n32, @dst16(0), 2 * CHARS )
next
print "u32to16 "; timer - t0

n16 = 0
for i as integer = 0 to CHARS \ 2 - 1
    src16(n16) = &hD83D : src16(n16+1) = &hDE00 : n16 += 2
next
t0 = timer
for i as integer = 1 to N
    guard += u16to32( @src16(0), n16, @dst32(0), 2 * CHARS )
next
print "u16to32 "; timer - t0

'' ---------------------------------------------------- codepoint walking
dim as integer used = 0
t0 = timer
for i as integer = 1 to N
    dim as integer k = 0
    do while( k < n16 )
        guard += cast( integer, cpat( @src16(0), n16, k, @used ) and 1 )
        k += used
    loop
next
print "codepoint_walk "; timer - t0

if guard < 0 then print "impossible"
