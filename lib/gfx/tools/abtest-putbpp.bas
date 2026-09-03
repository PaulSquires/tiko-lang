'' abtest-putbpp.bas -- the PUT blend modes at 8 and 16 bpp.
''
'' ORIGINAL WORK (the harness). Part of libtkogfx: LGPL-2.1-or-later with the
'' static-linking exception.
''
'' abtest-put.bas covers 32bpp. This covers the low depths, where gfxlib2's
'' dispatch tables do something the mode names do not suggest:
''
''   ALPHA at 8bpp  -> PSET   (a plain copy)
''   ALPHA at 16bpp -> PSET
''   ADD   at 8bpp  -> OR     (a bitwise OR)
''
'' Those three are the reason this file exists. Implementing a narrow "alpha"
'' or "add" at low depth would be the reasonable thing to do and would disagree
'' with gfxlib2 on every pixel.
''
'' TRANS also changes meaning: the transparent value is palette index 0 at 8bpp
'' and 565 magenta at 16bpp, not 888 magenta.
''
'' Each image is cleared explicitly after creation and the screen is touched
'' between depths -- see the two gfxlib2 defects noted in abtest-bpp.bas.

#include once "../raster/put.bi"
#include once "../core/image.bi"
#include once "fbgfx.bi"
#include once "crt/string.bi"

using TkoGfx
using FB

const IW = 20
const IH = 12

function Digest8( byval p as any ptr, byval pitch as integer ) as ulongint
    dim as ulongint acc = 14695981039346656037ull
    for y as integer = 0 to IH - 1
        dim as ubyte ptr row = cptr( ubyte ptr, p ) + y * pitch
        for x as integer = 0 to IW - 1
            acc = (acc xor row[x]) * 1099511628211ull
        next
    next
    return acc
end function

function Digest16( byval p as any ptr, byval pitch as integer ) as ulongint
    dim as ulongint acc = 14695981039346656037ull
    for y as integer = 0 to IH - 1
        dim as ushort ptr row = cptr( ushort ptr, cptr( ubyte ptr, p ) + y * pitch )
        for x as integer = 0 to IW - 1
            acc = (acc xor row[x]) * 1099511628211ull
        next
    next
    return acc
end function

'' Sources include the depth's own transparent value, plus values that saturate.
sub FillSrc8( byval p as any ptr, byval pitch as integer )
    for y as integer = 0 to IH - 1
        dim as ubyte ptr row = cptr( ubyte ptr, p ) + y * pitch
        for x as integer = 0 to IW - 1
            if ((x + y) mod 5) = 0 then
                row[x] = 0                      '' transparent at 8bpp
            else
                row[x] = cast( ubyte, (x * 13 + y * 29) and &hFF )
            end if
        next
    next
end sub

sub FillSrc16( byval p as any ptr, byval pitch as integer )
    for y as integer = 0 to IH - 1
        dim as ushort ptr row = cptr( ushort ptr, cptr( ubyte ptr, p ) + y * pitch )
        for x as integer = 0 to IW - 1
            if ((x + y) mod 5) = 0 then
                row[x] = &hF81F                 '' transparent at 16bpp
            else
                row[x] = cast( ushort, (x * 1237 + y * 907) and &hFFFF )
            end if
        next
    next
end sub

sub FillDst8( byval p as any ptr, byval pitch as integer )
    for y as integer = 0 to IH - 1
        dim as ubyte ptr row = cptr( ubyte ptr, p ) + y * pitch
        for x as integer = 0 to IW - 1
            row[x] = cast( ubyte, (x * 7 + y * 3) and &hFF )
        next
    next
end sub

sub FillDst16( byval p as any ptr, byval pitch as integer )
    for y as integer = 0 to IH - 1
        dim as ushort ptr row = cptr( ushort ptr, cptr( ubyte ptr, p ) + y * pitch )
        for x as integer = 0 to IW - 1
            row[x] = cast( ushort, (x * 811 + y * 3049) and &hFFFF )
        next
    next
end sub

dim as string report
dim as long failures = 0
dim as long ran = 0

dim as string modename(...) = { "PSET", "TRANS", "ALPHA", "ADD" }

for di as integer = 0 to 1
    dim as long depth = iif( di = 0, 8, 16 )
    dim as long bpp = iif( di = 0, 1, 2 )

    screenres 64, 48, depth, 1, GFX_NULL

    for m as integer = 0 to ubound( modename )
        dim as long al = 128

        '' reset gfxlib2's last_target so a recycled block cannot alias
        pset ( 0, 0 ), 0

        dim as any ptr si = imagecreate( IW, IH, 0, depth )
        dim as any ptr dii = imagecreate( IW, IH, 0, depth )
        dim as integer a1, a2, a3, sp_, b1, b2, b3, dp_
        dim as any ptr sdat, ddat
        imageinfo( si, a1, a2, a3, sp_, sdat )
        imageinfo( dii, b1, b2, b3, dp_, ddat )
        line si, (0,0)-(IW-1,IH-1), 0, BF
        line dii, (0,0)-(IW-1,IH-1), 0, BF

        if depth = 8 then
            FillSrc8( sdat, sp_ ) : FillDst8( ddat, dp_ )
        else
            FillSrc16( sdat, sp_ ) : FillDst16( ddat, dp_ )
        end if

        select case m
        case 0 : put dii, (0,0), si, PSET
        case 1 : put dii, (0,0), si, TRANS
        case 2 : put dii, (0,0), si, ALPHA
        case else : put dii, (0,0), si, ADD, al
        end select
        dim as ulongint want = iif( depth = 8, Digest8( ddat, sp_ ), Digest16( ddat, dp_ ) )

        '' ---- libtkogfx ----
        dim as TkoAbi.PUT_HEADER ptr ms = TkoImageNew( IW, IH, bpp )
        dim as TkoAbi.PUT_HEADER ptr md = TkoImageNew( IW, IH, bpp )
        dim as any ptr s2 = TkoImagePixels( ms )
        dim as any ptr d2 = TkoImagePixels( md )
        if depth = 8 then
            FillSrc8( s2, ms->pitch ) : FillDst8( d2, md->pitch )
        else
            FillSrc16( s2, ms->pitch ) : FillDst16( d2, md->pitch )
        end if

        if depth = 8 then
            select case m
            case 0 : PutPSet8( s2, d2, IW, IH, ms->pitch, md->pitch )
            case 1 : PutTrans8( s2, d2, IW, IH, ms->pitch, md->pitch )
            case 2 : PutPSet8( s2, d2, IW, IH, ms->pitch, md->pitch )    '' ALPHA -> PSET
            case else : PutOr32( s2, d2, (IW * 1) \ 4, IH, ms->pitch, md->pitch )  '' ADD -> OR, bytewise
            end select
        else
            select case m
            case 0 : PutPSet16( s2, d2, IW, IH, ms->pitch, md->pitch )
            case 1 : PutTrans16( s2, d2, IW, IH, ms->pitch, md->pitch )
            case 2 : PutPSet16( s2, d2, IW, IH, ms->pitch, md->pitch )   '' ALPHA -> PSET
            case else : PutAdd16( s2, d2, IW, IH, ms->pitch, md->pitch, al )
            end select
        end if
        dim as ulongint got = iif( depth = 8, Digest8( d2, ms->pitch ), Digest16( d2, md->pitch ) )

        ran += 1
        if want <> got then
            report += "  MISMATCH " + str(depth) + "bpp " + modename(m) + chr(10)
            failures += 1
        end if

        TkoImageFree( ms ) : TkoImageFree( md )
        imagedestroy( si ) : imagedestroy( dii )
    next
    screen 0
next

print "abtest-putbpp -- "; ran; " PUT cases at 8 and 16 bpp against gfxlib2"
if failures = 0 then
    print "abtest-putbpp: PASS -- every mode is pixel-identical"
    end 0
else
    print report;
    print "abtest-putbpp: FAIL -- "; failures; " of"; ran; " differ"
    end 1
end if
