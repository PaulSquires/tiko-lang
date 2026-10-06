'' VIEW's fill and border colours against gfxlib2: the border one pixel outside the view
'' and drawn even where the old view would clip it, the fill clearing the new view, both
'' converted for the depth; a view partly off the screen; one wholly off it (nothing
'' drawn); and the graphics cursor the fill recentres, read by a following STEP line.
#include once "fbgfx.bi"

const W = 64, H = 48

dim shared as integer bytespp

'' POINT and the raw bytes: at 4 bpp POINT masks what it reads, the bytes do not.
function Hash( ) as ulong
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
dim as integer depths(0 to 3) = { 4, 8, 16, 32 }
for di as integer = 0 to 3
    screenres W, H, depths(di), , fb.GFX_NULL
    bytespp = iif( depths(di) <= 8, 1, depths(di) \ 8 )
    view (20, 20)-(30, 30)                              '' an old view the border must ignore
    view (10, 8)-(50, 40), 3, 12
    print #1, depths(di); " both "; hex( Hash( ) )
    line -step(5, 3), 14                                '' from the recentred cursor
    print #1, depths(di); " step "; hex( Hash( ) )
    view : cls
    view (10, 8)-(50, 40), , &h00FF8040
    print #1, depths(di); " border "; hex( Hash( ) )
    view : cls
    view screen (5, 5)-(20, 15), &h123456
    pset (6, 6), 15
    print #1, depths(di); " fill "; hex( Hash( ) )
    view : cls
    view (-10, -5)-(40, 70), 2, 9                       '' partly off the screen
    print #1, depths(di); " partial "; hex( Hash( ) )
    view : cls
    view (100, 100)-(120, 120), 2, 9                    '' wholly off: nothing at all
    print #1, depths(di); " off "; hex( Hash( ) )
    view : cls
    view (0, 0)-(W - 1, H - 1), 1, 4                    '' border entirely outside the screen
    print #1, depths(di); " edge "; hex( Hash( ) )
    view : cls
next
