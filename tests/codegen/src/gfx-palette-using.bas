'' PALETTE USING and PALETTE GET USING against gfxlib2:
''   - how many entries each touches, per SCREENRES depth and per legacy SCREEN mode
''   - PALETTE USING skips a negative entry
''   - a UDT operand is its pointer 'operator cast', and the cast's pointee picks 32 or 64 bits
#include once "fbgfx.bi"
open cons for output as #1

dim as integer depths(0 to 4) = { 4, 8, 16, 24, 32 }
for d as integer = 0 to 4
    screenres 16, 16, depths(d), , fb.GFX_NULL
    dim as long p(0 to 299)
    for i as integer = 0 to 299 : p(i) = 7 : next
    palette get using p
    dim as integer n7 = 0
    for i as integer = 0 to 299 : if p(i) = 7 then n7 += 1
    next
    print #1, depths(d); " "; hex( p(0) ); " "; hex( p(1) ); " "; hex( p(15) ); " "; hex( p(255) ); " untouched"; n7
next

dim as integer modes(0 to 7) = { 1, 2, 7, 8, 9, 11, 12, 13 }
for m as integer = 0 to 7
    screen modes(m), , , fb.GFX_NULL
    dim as long p(0 to 299)
    for i as integer = 0 to 299 : p(i) = 7 : next
    palette get using p
    dim as integer n7 = 0
    for i as integer = 0 to 299 : if p(i) = 7 then n7 += 1
    next
    print #1, modes(m); " "; hex( p(1) ); " "; hex( p(3) ); " "; hex( p(15) ); " untouched"; n7
next

screenres 16, 16, 8, , fb.GFX_NULL
dim as long q(0 to 255)
palette get using q
q(1) = -1 : q(2) = &h010203
palette using q
dim as long v1, v2
palette get 1, v1
palette get 2, v2
print #1, hex( v1 ); " "; hex( v2 )

type PAL_long
    pal as long ptr
    declare constructor
    declare destructor
    declare operator cast() as long ptr
end type
constructor PAL_long
    pal = new long[256]
end constructor
destructor PAL_long
    delete[] pal
end destructor
operator PAL_long.cast() as long ptr
    operator = pal
end operator

type PAL_li
    pal as longint ptr
    declare operator cast() as longint ptr
end type
operator PAL_li.cast() as longint ptr
    operator = pal
end operator

screenres 16, 16, 8, , fb.GFX_NULL
dim pu as PAL_long
palette get using pu
dim qu as PAL_li
qu.pal = new longint[256]
for i as integer = 0 to 255 : qu.pal[i] = -1 : next
palette get using qu
print #1, hex( pu.pal[1] ), hex( qu.pal[15] ), hex( qu.pal[16] )
dim as double dd(0 to 255)
palette get using dd
dim as longint ptr dl = cptr( longint ptr, @dd(0) )
print #1, hex( dl[9] )
print #1, "done"
