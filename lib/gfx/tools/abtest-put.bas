'' abtest-put.bas -- A/B the PUT blend modes against gfxlib2.
''
'' ORIGINAL WORK (the harness). Part of libtkogfx: LGPL-2.1-or-later with the
'' static-linking exception.
''
'' Both sides operate on the SAME destination image, one after the other, so the
'' comparison is of the blend itself rather than of two independently drawn
'' scenes. The destination is pre-filled with a gradient and the source carries
'' varied alpha, because several modes are identity-like on flat input:
''
''   - ALPHA over a uniform destination hides an (a) vs (a+1) error
''   - ADD saturates only where the sum exceeds 255, so the source must be bright
''     enough in some pixels and not others
''   - TRANS only differs where the source is exactly magenta, so the source
''     contains magenta pixels deliberately
''   - AND / OR / XOR are only distinguishable on operands that are neither all
''     ones nor all zeros
''
'' A flat source and destination would make most of these modes agree with each
'' other, and the suite would pass whichever one was implemented.
''
'' BLEND IS NOT TESTED HERE, AND CANNOT BE. It is a real gfxlib2 putter with a
'' real mode number (9), but `PUT ..., BLEND` is a SYNTAX ERROR -- fbc does not
'' expose it as a PUT mode keyword. Measured: PSET/PRESET/AND/OR/XOR/TRANS/
'' ALPHA/ADD/CUSTOM all parse, BLEND does not. It is reachable only from inside
'' the library (DRAW STRING passes a blender), so PutBlend32 is implemented and
'' marked UNVERIFIED rather than left out or pretended tested.

#include once "../raster/put.ti"
#include once "../core/image.ti"
#include once "abtest.bi"
#include once "crt/string.bi"
#ifdef ABTEST_HAS_GFXLIB2
#include once "fbgfx.bi"
#endif

using TkoGfx
#ifdef ABTEST_HAS_GFXLIB2
using FB
#endif

const IW = 24
const IH = 16

'' Source: varied alpha, some magenta, some bright, some dark.
sub FillSrc( byval p as any ptr, byval pitch as integer )
    for y as integer = 0 to IH - 1
        dim as ulong ptr row = cptr( ulong ptr, cptr( ubyte ptr, p ) + y * pitch )
        for x as integer = 0 to IW - 1
            dim as ulong a = (x * 11 + y * 7) and &hFF
            dim as ulong r = (x * 23) and &hFF
            dim as ulong g = (y * 17) and &hFF
            dim as ulong b = (x * 5 + y * 13) and &hFF
            if ((x + y) mod 7) = 0 then
                row[x] = &hFF00FF          '' exactly the transparent colour
            else
                row[x] = (a shl 24) or (r shl 16) or (g shl 8) or b
            end if
        next
    next
end sub

'' Destination: a gradient, so no mode is identity on it.
sub FillDst( byval p as any ptr, byval pitch as integer )
    for y as integer = 0 to IH - 1
        dim as ulong ptr row = cptr( ulong ptr, cptr( ubyte ptr, p ) + y * pitch )
        for x as integer = 0 to IW - 1
            row[x] = &hFF000000 or (cuint( x * 9 ) shl 16) or (cuint( y * 13 ) shl 8) or cuint( x + y )
        next
    next
end sub

'' The CUSTOM blender. gfxlib2 calls this from inside its own PUT, so this is
'' user code being invoked by the library -- the calling convention has to be
'' right or the stack corrupts on win32 only.
function MyBlender cdecl ( byval sc as ulong, byval dc as ulong, byval param as any ptr ) as ulong
    dim as ulong k = 0
    if param <> 0 then k = *cptr( ulong ptr, param )
    '' asymmetric and order-dependent, so a swapped src/dst shows up
    return ((sc and &hFEFEFEFE) shr 1) + ((dc and &hFCFCFCFC) shr 2) + k
end function

#ifdef ABTEST_HAS_GFXLIB2
screenres 64, 48, 32, 1, GFX_NULL
#endif

Abtest.Begin( "abtest-put", "every mode is pixel-identical" )

dim as ulong blendparam = &h00010203

dim as string modename(...) = { "PSET", "PRESET", "AND", "OR", "XOR", "TRANS", "ALPHA", "ADD", "CUSTOM" }

for m as integer = 0 to ubound( modename )
    for alpha as integer = 0 to 2
        dim as long al = iif( alpha = 0, 255, iif( alpha = 1, 128, 32 ) )

        dim as string tag = modename(m) + iif( m = 7, " alpha=" + str(al), "" )
        dim as ulongint want, got

#ifdef ABTEST_HAS_GFXLIB2
        '' ---- A: gfxlib2 ----
        dim as any ptr srcimg = imagecreate( IW, IH, 0, 32 )
        dim as any ptr dstimg = imagecreate( IW, IH, 0, 32 )
        dim as integer sw_, sh_, sb_, sp_, dw_, dh_, db_, dp_
        dim as any ptr sdat, ddat
        imageinfo( srcimg, sw_, sh_, sb_, sp_, sdat )
        imageinfo( dstimg, dw_, dh_, db_, dp_, ddat )
        FillSrc( sdat, sp_ )
        FillDst( ddat, dp_ )

        select case m
        case 0 : put dstimg, (0,0), srcimg, PSET
        case 1 : put dstimg, (0,0), srcimg, PRESET
        case 2 : put dstimg, (0,0), srcimg, AND
        case 3 : put dstimg, (0,0), srcimg, OR
        case 4 : put dstimg, (0,0), srcimg, XOR
        case 5 : put dstimg, (0,0), srcimg, TRANS
        case 6 : put dstimg, (0,0), srcimg, ALPHA
        case 7 : put dstimg, (0,0), srcimg, ADD, al
        case else : put dstimg, (0,0), srcimg, CUSTOM, @MyBlender, @blendparam
        end select
        want = Abtest.Digest( ddat, IW, IH, dp_ )
        imagedestroy( srcimg ) : imagedestroy( dstimg )
#endif

        '' ---- B: libtkogfx, same source and destination content ----
        dim as TkoAbi.PUT_HEADER ptr ms = TkoImageNew( IW, IH, 4 )
        dim as TkoAbi.PUT_HEADER ptr md = TkoImageNew( IW, IH, 4 )
        FillSrc( TkoImagePixels( ms ), ms->pitch )
        FillDst( TkoImagePixels( md ), md->pitch )
        dim as any ptr sp2 = TkoImagePixels( ms )
        dim as any ptr dp2 = TkoImagePixels( md )

        select case m
        case 0 : PutPSet32( sp2, dp2, IW, IH, ms->pitch, md->pitch )
        case 1 : PutPReset32( sp2, dp2, IW, IH, ms->pitch, md->pitch )
        case 2 : PutAnd32( sp2, dp2, IW, IH, ms->pitch, md->pitch )
        case 3 : PutOr32( sp2, dp2, IW, IH, ms->pitch, md->pitch )
        case 4 : PutXor32( sp2, dp2, IW, IH, ms->pitch, md->pitch )
        case 5 : PutTrans32( sp2, dp2, IW, IH, ms->pitch, md->pitch )
        case 6 : PutAlpha32( sp2, dp2, IW, IH, ms->pitch, md->pitch )
        case 7 : PutAdd32( sp2, dp2, IW, IH, ms->pitch, md->pitch, al )
        case else : PutCustom32( sp2, dp2, IW, IH, ms->pitch, md->pitch, @MyBlender, @blendparam )
        end select
        got = Abtest.Digest( dp2, IW, IH, md->pitch )

        Abtest.Case_( tag, want, got )

        TkoImageFree( ms ) : TkoImageFree( md )

        '' only ADD varies with alpha; the rest run once
        if m <> 7 then exit for
    next
next

#ifdef ABTEST_HAS_GFXLIB2
screen 0
#endif

Abtest.Finish_( )
