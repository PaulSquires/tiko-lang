'' abtest-convert.bas -- A/B the row converters against IMAGECONVERTROW.
''
'' ORIGINAL WORK (the harness). Part of libtkogfx: LGPL-2.1-or-later with the
'' static-linking exception.
''
'' The 24-entry blitter table is internal and only observable through a window.
'' IMAGECONVERTROW exposes the SAME converters as a public statement, so that is
'' what these are checked against -- the conversion logic is verified even though
'' the blitter that dispatches it is not.
''
'' The `isrgb` flag is the case worth the effort: 32->32 with isrgb swaps red and
'' blue, and without it copies. Both are "32 to 32", and choosing wrong leaves an
'' image that looks right in greys and inverted in colour.
''
'' The 8-bit converters read the DEVICE PALETTE, so the screen's palette is set
'' to a known non-trivial state first -- a palette that is the identity, or grey,
'' would hide a channel-order error in exactly the way the default one might.

#include once "../raster/convert.bi"
#include once "abtest.bi"
#ifdef ABTEST_HAS_GFXLIB2
#include once "fbgfx.bi"
#endif
#include once "crt/string.bi"

using TkoGfx
#ifdef ABTEST_HAS_GFXLIB2
using FB
#endif

const WID = 37          '' deliberately not a multiple of anything

#ifdef ABTEST_HAS_GFXLIB2
screenres 320, 200, 8, 1, GFX_NULL
#endif

Abtest.Begin( "abtest-convert", "every converter matches" )

'' A palette where every channel differs per index, so an r/b swap cannot hide.
dim as GfxPalette pal
PaletteInit( pal, 256 )
for i as integer = 0 to 255
    dim as long r = (i * 7) and &hFF
    dim as long g = (i * 13) and &hFF
    dim as long b = (i * 29) and &hFF
#ifdef ABTEST_HAS_GFXLIB2
    palette i, r, g, b
#endif
    PaletteSetRgb( pal, i, r, g, b )
next

dim as ubyte ptr src8 = allocate( WID )
dim as ubyte ptr src24 = allocate( WID * 3 )
dim as ulong ptr src32 = allocate( WID * 4 )
for i as integer = 0 to WID - 1
    src8[i] = (i * 11) and &hFF
    src24[i*3] = (i * 3) and &hFF
    src24[i*3+1] = (i * 5) and &hFF
    src24[i*3+2] = (i * 17) and &hFF
    src32[i] = cast( ulong, (i * 2654435761u) )
next

dim as any ptr wantbuf = allocate( WID * 4 + 16 )
dim as any ptr gotbuf = allocate( WID * 4 + 16 )

'' The whole converted row goes into one digest. wantbuf is only filled in the
'' roles that have a reference; the &hCC prefill stays put otherwise and is
'' never compared, because Case_ ignores the A side in the subject role.
#macro CHECK( label, srcp, srcbpp, dstbpp, isrgb, mineexpr )
    scope
        memset( wantbuf, &hCC, WID * 4 + 16 )
        memset( gotbuf, &hCC, WID * 4 + 16 )
#ifdef ABTEST_HAS_GFXLIB2
        imageconvertrow( srcp, srcbpp, wantbuf, dstbpp, WID, isrgb )
#endif
        mineexpr
        dim as long nbytes = WID * (dstbpp \ 8)
        dim as long firstbad = -1
        for k as integer = 0 to nbytes - 1
            if cptr( ubyte ptr, wantbuf )[k] <> cptr( ubyte ptr, gotbuf )[k] then
                firstbad = k
                exit for
            end if
        next
        Abtest.Case_( label, Abtest.Digest( wantbuf, nbytes ), _
                      Abtest.Digest( gotbuf, nbytes ), _
                      iif( firstbad >= 0, "first differing byte " + str(firstbad), "" ) )
    end scope
#endmacro

CHECK( "8->16", src8, 8, 16, 1, Convert8to16( src8, cptr( ushort ptr, gotbuf ), WID, pal ) )
CHECK( "8->32", src8, 8, 32, 1, Convert8to32( src8, cptr( ulong ptr, gotbuf ), WID, pal ) )

CHECK( "32->16 rgb", cptr( ubyte ptr, src32 ), 32, 16, 1, Convert32to16( src32, cptr( ushort ptr, gotbuf ), WID ) )
CHECK( "32->32 rgb", cptr( ubyte ptr, src32 ), 32, 32, 1, Convert32to32( src32, cptr( ulong ptr, gotbuf ), WID ) )
CHECK( "32->16 bgr", cptr( ubyte ptr, src32 ), 32, 16, 0, Convert32bgrto16( src32, cptr( ushort ptr, gotbuf ), WID ) )
CHECK( "32->32 bgr", cptr( ubyte ptr, src32 ), 32, 32, 0, Convert32bgrto32( src32, cptr( ulong ptr, gotbuf ), WID ) )

CHECK( "24->16 bgr", src24, 24, 16, 0, Convert24bgrto16( src24, cptr( ushort ptr, gotbuf ), WID ) )
CHECK( "24->32 bgr", src24, 24, 32, 0, Convert24bgrto32( src24, cptr( ulong ptr, gotbuf ), WID ) )

'' isrgb really does select a different converter: 32->32 with and without it
'' must produce DIFFERENT output for a source with unequal r and b.
'' Both halves are gfxlib2, so there is nothing here for the subject to run --
'' it is a check that the CORPUS discriminates, not that we agree.
scope
    dim as long differed = 0
#ifdef ABTEST_HAS_GFXLIB2
    memset( wantbuf, 0, WID * 4 )
    memset( gotbuf, 0, WID * 4 )
    imageconvertrow( cptr( ubyte ptr, src32 ), 32, wantbuf, 32, WID, 1 )
    imageconvertrow( cptr( ubyte ptr, src32 ), 32, gotbuf, 32, WID, 0 )
    differed = iif( memcmp( wantbuf, gotbuf, WID * 4 ) <> 0, 1, 0 )
#endif
    Abtest.Interop_( "isrgb changes 32->32 (the source is not symmetric)", 1, differed )
end scope

deallocate( src8 ) : deallocate( src24 ) : deallocate( src32 )
deallocate( wantbuf ) : deallocate( gotbuf )
#ifdef ABTEST_HAS_GFXLIB2
screen 0
#endif

Abtest.Finish_( )
