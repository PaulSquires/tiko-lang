'' A written colour is converted for the target's depth (gfxlib2's fb_hFixColor) by every
'' drawing statement: 8 bpp truncates to an index, 16 bpp packs RGB888 into RGB565, 32 bpp
'' is unchanged. One hash of the framebuffer per primitive and depth, read through POINT
'' and through SCREENPTR.
#include once "fbgfx.bi"

const W = 48, H = 32

function Hash( byval bytespp as integer ) as ulong
    dim as ulong hv = 2166136261
    for y as integer = 0 to H - 1
        for x as integer = 0 to W - 1
            hv = (hv xor cast( ulong, point( x, y ) )) * 16777619
        next
    next
    dim as ubyte ptr p = screenptr
    for i as integer = 0 to W * H * bytespp - 1
        hv = (hv xor p[i]) * 16777619
    next
    return hv
end function

open cons for output as #1
dim as integer depths(0 to 2) = { 8, 16, 32 }
dim as ulong cols(0 to 3) = { 9, &h00FF8040, &h123456, &hFFFFFFFF }
for di as integer = 0 to 2
    screenres W, H, depths(di), , fb.GFX_NULL
    dim as integer bpp = depths(di) \ 8
    for ci as integer = 0 to 3
        dim as ulong k = cols(ci)
        cls : pset (3, 3), k : preset (4, 4), k
        print #1, depths(di); ci; " pset "; hex( Hash( bpp ) )
        cls : line (0, 0)-(W - 1, H - 1), k : line (2, 2)-(20, 10), k, b : line (5, 12)-(15, 20), k, bf
        print #1, depths(di); ci; " line "; hex( Hash( bpp ) )
        cls : circle (24, 16), 10, k : circle (10, 10), 5, k, , , , f
        print #1, depths(di); ci; " circle "; hex( Hash( bpp ) )
        cls : line (1, 1)-(30, 20), k, b : paint (10, 10), k, k
        print #1, depths(di); ci; " paint "; hex( Hash( bpp ) )
        cls : draw string (1, 1), "Hi", k
        print #1, depths(di); ci; " drawstring "; hex( Hash( bpp ) )
        cls : draw "BM5,5 C" & str( k ) & " R10 D10 L10 U10"
        print #1, depths(di); ci; " draw "; hex( Hash( bpp ) )
    next
next

'' PAINT with no border stops at the FILL colour, not the foreground (gfx_paint.c)

for di as integer = 0 to 2
    screenres 40, 30, depths(di), , fb.GFX_NULL
    color 14
    line (2, 2)-(30, 20), 12, b       '' a box in 12, foreground 14
    paint (10, 10), 12                '' no border: gfxlib2 takes the FILL colour
    dim as integer n = 0
    for y as integer = 0 to 29 : for x as integer = 0 to 39
        if point( x, y ) = point( 10, 10 ) then n += 1
    next : next
    line (2, 22)-(30, 28), 14, b
    paint (10, 25), 9
    dim as integer m = 0
    for y as integer = 0 to 29 : for x as integer = 0 to 39
        if point( x, y ) = point( 10, 25 ) then m += 1
    next : next
    print #1, depths(di); n; m
next
