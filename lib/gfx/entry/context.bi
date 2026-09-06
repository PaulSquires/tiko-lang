'' entry/context.bi -- the drawing context every entry point resolves first.
''
'' ORIGINAL WORK. Part of libtkogfx: LGPL-2.1-or-later with the static-linking
'' exception.
''
'' Every drawing entry point takes a TARGET as its first argument -- NULL for
'' the screen, an image header otherwise -- and then needs four things the
'' argument does not carry: the surface to write, the viewport that maps logical
'' coordinates onto it, the foreground/background pair a defaulted colour comes
'' from, and the last point a STEP is relative to. gfxlib2 keeps that quartet in
'' an FB_GFXCTX and looks it up per target. So does this.
''
'' WHY THE LOOKUP IS KEYED ON MORE THAN THE POINTER.
''
'' gfxlib2's fb_hPrepareTarget begins
''
''     if (target != context->last_target) { ...rebind everything... }
''
'' and IMAGEDESTROY never clears last_target. Destroy an image, create one of a
'' DIFFERENT DEPTH that the allocator places at the same address, and drawing to
'' it skips the rebind: it keeps the previous image's pixel width, pitch and
'' dimensions. Measured in tools/abtest-bpp.bas -- after an 8bpp pass, PSET of
'' &hABCDEF into a 16bpp image wrote the single byte &hEF instead of the RGB565
'' value &hAE7D, 350 of 960 pixels wrong.
''
'' So a cached context is only reused when the geometry AGREES with the header
'' as it reads TODAY. A recycled address whose image differs in any of width,
'' height, bpp or pitch misses the cache and is rebuilt. That costs four
'' comparisons and removes the whole defect class.
''
'' WHY THERE IS A CACHE AT ALL, rather than rebuilding every call: DRAW's scale
'' and angle, COLOR's pair and the last point all PERSIST between statements on
'' the same target. tools/abtest-draw.bas pins that directly -- "S8" in one call
'' sets the scale "R10" uses in the next.

#pragma once

namespace TkoGfx

'' ---------------------------------------------------------- coordinate flags
''
'' Two conventions, measured and recorded in docs/language/graphics-abi.md.
'' They must not be conflated: both are the last integer argument and they mean
'' different things.
''
''   A, two-point (LINE, GET, PUT)     bit 0 second point relative
''                                     bit 1 first point relative
''                                     bit 31 colour defaulted
''   B, one-point (PSET, CIRCLE,       bit 0 STEP
''      PAINT, DRAW STRING)            bit 30 border defaulted (PAINT)
''                                     bit 31 colour defaulted
''                                     base 4 -- bit 2 is set on every call of
''                                     this family and its meaning is NOT known
const COORD_A_P2_REL   = 1
const COORD_A_P1_REL   = 2
const COORD_B_STEP     = 1
const COORD_BORDER_DEF = 1 shl 30
const COORD_COLOR_DEF  = 1 shl 31

'' VIEW is its own convention: bit 0 is SCREEN, bit 30 the border colour
'' defaulted, bit 31 the fill colour defaulted, base 0.
const VIEW_SCREEN      = 1

'' The full-screen sentinel a bare VIEW passes for all four coordinates.
const VIEW_FULLSCREEN  = -32768

'' POINT(n) -- the one-argument form -- is the same entry point with the axis
'' selector in x and this sentinel in y.
const POINT_AXIS_SENTINEL as single = -8388607.0f

'' ------------------------------------------------------------ the screen
''
'' THE FRAMEBUFFER IS 32BPP WHATEVER THE MODE SAYS. ModeTable's `depth` is BITS
'' per pixel and every legacy mode is 8 or fewer; Surface.bpp is BYTES.
'' Presenting an 8-bit surface needs the palette pushed into the BITMAPINFO, and
'' driver/gdi.bi's GdiDescribe writes a bare BITMAPINFOHEADER -- correct for
'' 32bpp and silently wrong for 8. Paletted modes wait for core/palette.bi to be
'' wired into GdiDescribe.
''
'' The screen's SURFACE lives in ScreenCtx below, not here: it is the drawing
'' context's business, and keeping two copies of it is how they drift apart.
type ScreenState
    wnd      as GfxWindow
    pixels   as any ptr
    dirty    as any ptr        '' one byte per row; see ScreenOpen
    mode     as long
    isOpen   as long
end type

dim shared as ScreenState TheScreen

type GfxContext
    surf     as Surface
    vp       as Viewport
    draw     as DrawState

    target   as any ptr        '' NULL for the screen
    inuse    as long

    '' what the header said when this context was built -- see the file header
    c_w      as long
    c_h      as long
    c_bpp    as long
    c_pitch  as long
end type

'' One for the screen, plus a small ring for image targets. Eight is not a
'' measured number: it is enough that the ordinary "draw into two or three
'' images in a loop" shape never evicts, and small enough that a miss costs a
'' linear scan of nothing.
const GFXCTX_IMAGES = 8

dim shared as GfxContext ScreenCtx
dim shared as GfxContext ImageCtx(0 to GFXCTX_IMAGES - 1)
dim shared as long ImageCtxNext

'' Build a context over an image, from the header as it reads NOW.
private sub ContextBindImage( byref c as GfxContext, byval img as TkoAbi.PUT_HEADER ptr )
    dim as long w, h, bpp, pitch, size
    dim as any ptr px
    if TkoImageQuery( img, w, h, bpp, pitch, px, size ) <> 0 then
        c.inuse = 0
        exit sub
    end if

    SurfaceInit( c.surf, px, w, h, pitch, bpp )
    ViewportInit( c.vp, w, h )
    '' An image target's colour pair starts from the image's own depth, not the
    '' screen's: COLOR's legacy rules are depth-selected (raster/color.bi).
    DrawStateInit( c.draw, bpp * 8 )

    c.target  = img
    c.inuse   = 1
    c.c_w     = w
    c.c_h     = h
    c.c_bpp   = bpp
    c.c_pitch = pitch
end sub

'' Resolve the first argument of every drawing entry point.
''
'' Returns NULL when there is nothing to draw on -- no screen open and no image
'' given, or an image whose header does not read. Every caller must check: an
'' entry point on a closed screen is a no-op in fbc, not a fault.
private function ContextFor( byval target as any ptr ) as GfxContext ptr
    if target = 0 then
        if TheScreen.isOpen = 0 then return 0
        return @ScreenCtx
    end if

    dim as TkoAbi.PUT_HEADER ptr img = cptr( TkoAbi.PUT_HEADER ptr, target )

    '' Read the header FIRST, then look for a cache entry that still agrees with
    '' it. The other order is the aliasing defect in the file header.
    dim as long w, h, bpp, pitch, size
    dim as any ptr px
    if TkoImageQuery( img, w, h, bpp, pitch, px, size ) <> 0 then return 0

    for i as integer = 0 to GFXCTX_IMAGES - 1
        if ImageCtx(i).inuse andalso (ImageCtx(i).target = target) then
            if (ImageCtx(i).c_w = w) andalso (ImageCtx(i).c_h = h) andalso _
               (ImageCtx(i).c_bpp = bpp) andalso (ImageCtx(i).c_pitch = pitch) then
                '' The pixels can still move under a header that reads the same
                '' -- the allocator is free to hand back the same geometry at a
                '' new address -- so the surface is re-pointed even on a hit.
                ImageCtx(i).surf.pixels = px
                return @ImageCtx(i)
            end if
            '' Same address, different image. Rebuild in place rather than
            '' leaving a second entry for the same pointer.
            ContextBindImage( ImageCtx(i), img )
            return iif( ImageCtx(i).inuse, @ImageCtx(i), cast( GfxContext ptr, 0 ) )
        end if
    next

    dim as long slot = ImageCtxNext
    ImageCtxNext = (ImageCtxNext + 1) mod GFXCTX_IMAGES
    ContextBindImage( ImageCtx(slot), img )
    if ImageCtx(slot).inuse = 0 then return 0
    return @ImageCtx(slot)
end function

'' Drop every cached context for an image. Called when one is destroyed, so a
'' later image at the same address cannot find a stale entry even if its
'' geometry happens to match.
private sub ContextForget( byval target as any ptr )
    if target = 0 then exit sub
    for i as integer = 0 to GFXCTX_IMAGES - 1
        if ImageCtx(i).target = target then
            ImageCtx(i).inuse = 0
            ImageCtx(i).target = 0
        end if
    next
end sub

'' An FBSTRING's length carries the TEMP BIT in its sign bit -- an fbc
'' temporary descriptor has a negative len. Masking it off is not optional: a
'' bare read gives a huge or negative length for exactly the descriptors these
'' two entry points are most often handed, because `DRAW "R10"` is a temporary.
private function StrFromDescriptor( byval p as any ptr ) as string
    dim as TkoAbi.FBSTRING ptr s = cptr( TkoAbi.FBSTRING ptr, p )
    if s = 0 then return ""
    if s->dat = 0 then return ""
    dim as integer n = s->len
    if n < 0 then n and= not (cast( integer, 1 ) shl (sizeof( integer ) * 8 - 1))
    if n <= 0 then return ""
    dim as string out_ = space( n )
    memcpy( strptr( out_ ), s->dat, n )
    return out_
end function

'' ------------------------------------------------------------- the palette
''
'' HERE RATHER THAN IN entry/palette.bi, AND THE REASON IS ORDERING. The entry
'' layer is included in dependency order and screen.bi comes before palette.bi,
'' but SCREEN is what has to prime the table and the presentation LUT -- a
'' program that never calls PALETTE still has to see the mode's default colours.
'' Keeping the state below the entry points that use it is what lets both reach
'' it.
''
'' One palette, because PALETTE has no target argument: it is the screen's table
'' and images do not have their own.
dim shared as GfxPalette ThePalette
dim shared as long ThePaletteReady
dim shared as long ThePaletteMode = -1

'' 256 packed 0x00BBGGRR values, handed to the window so it can expand a
'' paletted surface for GDI. driver/ does not know what a palette is; it takes
'' this array and indexes it.
dim shared as ulong PaletteLut(0 to 255)

private sub PaletteLutRebuild( )
    for i as integer = 0 to 255
        dim as long r, g, b
        PaletteGetRgb( ThePalette, i, r, g, b )
        '' 0x00BBGGRR -- the order a 32bpp DIB wants, which is B in the low
        '' byte. PaletteGetRgb answers r, g, b, so this is not a copy.
        PaletteLut(i) = cast( ulong, b ) or (cast( ulong, g ) shl 8) or _
                        (cast( ulong, r ) shl 16)
    next
end sub

'' Load the defaults for the mode that is open, once. Keyed on the MODE rather
'' than reset by SCREEN, which also catches a mode change arriving by a route
'' this file does not know about.
private function PaletteCurrent( ) as GfxPalette ptr
    if TheScreen.isOpen = 0 then return 0
    if TheScreen.mode <> ThePaletteMode then
        ThePaletteReady = 0
        ThePaletteMode = TheScreen.mode
    end if
    if ThePaletteReady = 0 then
        if PaletteLoadDefaults( ThePalette, TheScreen.mode ) = 0 then
            '' SCREENRES and the truecolour modes have no default table.
            PaletteInit( ThePalette, 256 )
        end if
        ThePaletteReady = 1
        PaletteLutRebuild( )
    end if
    return @ThePalette
end function

'' Reload the mode's defaults, discarding whatever PALETTE has set. This is what
'' a bare `PALETTE` means.
private sub PaletteForget( )
    ThePaletteReady = 0
end sub

'' Tear down whatever screen is open. Safe to call when nothing is.
''
'' ORDER MATTERS: the window thread presents FROM the surface, so it has to be
'' stopped before the pixels under it are freed. WindowClose joins that thread.
private sub ScreenTeardown( )
    if TheScreen.isOpen = 0 then exit sub
    WindowClose( TheScreen.wnd )
    if TheScreen.pixels <> 0 then
        deallocate( TheScreen.pixels )
        TheScreen.pixels = 0
    end if
    if TheScreen.dirty <> 0 then
        deallocate( TheScreen.dirty )
        TheScreen.dirty = 0
    end if
    SurfaceInit( ScreenCtx.surf, 0, 0, 0, 0, 0 )
    ViewportInit( ScreenCtx.vp, 0, 0 )
    ScreenCtx.inuse = 0
    TheScreen.mode = 0
    TheScreen.isOpen = 0
end sub

'' ------------------------------------------------------------- colour choice
''
'' A defaulted colour is not a separate argument: the caller passes 0 and sets
'' bit 31 of the flags. So "was a colour written" is a flags question, and the
'' answer when it was not is the context's current foreground.
private function ResolveColor( byref c as GfxContext, _
        byval colour as ulong, byval flags as long ) as ulong
    if (flags and COORD_COLOR_DEF) <> 0 then return c.draw.fg_color
    return colour
end function

'' ------------------------------------------------------- coordinate decoding
''
'' Convention B: one point, optionally STEP-relative to the last one. The
'' translated PHYSICAL point comes back, and the LOGICAL point is left in the
'' context as the new last point -- which is what a following STEP is relative
'' to, and what CLS's cursor rule in raster/cls.bi already assumes.
private sub CoordB( byref c as GfxContext, _
        byval fx as single, byval fy as single, byval flags as long, _
        byref px as long, byref py as long )

    if (flags and COORD_B_STEP) <> 0 then
        fx += c.draw.last_x
        fy += c.draw.last_y
    end if
    c.draw.last_x = fx
    c.draw.last_y = fy
    TranslateCoord( c.vp, fx, fy, px, py )
end sub

'' PUT is convention A with ONE point, and its STEP is therefore BIT 1, not
'' bit 0. Measured -- `put step(5,5), img, PSET` emits coordflags 2, while
'' `pset step(1,1)` emits 5, which is convention B's base 4 plus bit 0. Reading
'' PUT with CoordB sees no STEP at all and draws at the raw offset, which is
'' what it did until tools/gate-entry.sh compared the two.
private sub CoordPut( byref c as GfxContext, _
        byval fx as single, byval fy as single, byval flags as long, _
        byref px as long, byref py as long )

    if (flags and COORD_A_P1_REL) <> 0 then
        fx += c.draw.last_x
        fy += c.draw.last_y
    end if
    c.draw.last_x = fx
    c.draw.last_y = fy
    TranslateCoord( c.vp, fx, fy, px, py )
end sub

'' Convention A: two points, each independently relative. The FIRST point's
'' relativity is bit 1 and the SECOND's is bit 0 -- the reverse of the reading
'' order, which is why they are named rather than indexed here.
''
'' `line -(20,20)` is x1 = y1 = 0 with the first-point bit set: relative to the
'' last point by (0,0), i.e. start where we are.
private sub CoordA( byref c as GfxContext, _
        byval fx1 as single, byval fy1 as single, _
        byval fx2 as single, byval fy2 as single, byval flags as long, _
        byref px1 as long, byref py1 as long, _
        byref px2 as long, byref py2 as long )

    if (flags and COORD_A_P1_REL) <> 0 then
        fx1 += c.draw.last_x
        fy1 += c.draw.last_y
    end if
    '' The second point is relative to the FIRST, not to the old last point --
    '' the first has already become current by the time it is read.
    if (flags and COORD_A_P2_REL) <> 0 then
        fx2 += fx1
        fy2 += fy1
    end if

    TranslateCoord( c.vp, fx1, fy1, px1, py1 )
    TranslateCoord( c.vp, fx2, fy2, px2, py2 )

    c.draw.last_x = fx2
    c.draw.last_y = fy2
end sub

end namespace
