'' Styled LINE and LINE B against gfxlib2: every direction, clipped and not, in
'' 8, 16 and 32 bpp. Prints one hash per case.
#include once "fbgfx.bi"

const W = 96, H = 64

function Hash( ) as ulong
    dim as ulong hv = 2166136261
    for y as integer = 0 to H - 1
        for x as integer = 0 to W - 1
            hv = (hv xor cast( ulong, point( x, y ) )) * 16777619
        next
    next
    return hv
end function

dim as ushort styles(0 to 3) = { &b1000000011110000, &hAAAA, &h0F0F, &b1100100010000001 }
dim as integer depths(0 to 2) = { 8, 16, 32 }

open cons for output as #1
for di as integer = 0 to 2
    screenres W, H, depths(di), , fb.GFX_NULL
    for si as integer = 0 to 3
        dim as ushort st = styles(si)
        for clipped as integer = 0 to 1
            cls
            if clipped then view (10, 7)-(W - 13, H - 9) else view
            '' a fan of lines through the middle, both ways round
            for a as integer = -40 to 40 step 7
                line (W \ 2, H \ 2)-(W \ 2 + a * 2, -5 + (a and 7)), 9 + (a and 3), , st
                line (W \ 2 + a, H + 4)-(W \ 2, H \ 2), 3, , st
                line (-6, H \ 2 + a \ 3)-(W + 6, H \ 2 - a \ 2), 12, , st
            next
            '' horizontal and vertical, both directions
            line (W - 2, 3)-(-4, 3), 14, , st
            line (2, H - 2)-(W + 9, H - 2), 13, , st
            line (5, H + 3)-(5, -3), 11, , st
            line (W - 4, -9)-(W - 4, H + 9), 10, , st
            '' boxes, partly outside the view
            line (-5, -5)-(W \ 2, H \ 2), 6, b, st
            line (W - 1 + 7, H - 1 + 3)-(20, 15), 5, b, st
            line (30, 20)-(60, 40), 4, b, st
            print #1, depths(di); si; clipped; " "; hex( Hash( ) )
        next
    next
next
