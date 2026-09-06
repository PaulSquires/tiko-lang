'' entry/screen.bi -- the SCREEN family.
''
'' ORIGINAL WORK. Part of libtkogfx: LGPL-2.1-or-later with the static-linking
'' exception.
''
'' THE ENTRY LAYER IS THE ONLY PUBLIC SURFACE, and until this file existed the
'' archive held no code at all: every routine in abi/, core/, driver/ and
'' raster/ is `private`, so with nothing referencing them clang discarded all
'' 108 and libtkogfx.a came out at 902 bytes. That is RFC-0001's structure, and
'' it means an entry point does not merely expose a routine -- it is what pulls
'' the routine into the library at all.
''
'' THE SIGNATURES ARE TIKO'S, NOT GUESSES. src/mir/rtl.bi names each one and
'' docs/language/graphics-abi.md records the argument order and every default,
'' read out of the C that `fbc -r -gen gcc` generates. Where a default is a
'' sentinel rather than a flag -- SCREENRES's pages, the QB forms' depth -- the
'' sentinel is named here rather than written as a literal.
''
'' extern "c", NOT "rtlib". FBCALL is cdecl on x86-64 and win32 is gone (D14),
'' so the two spell the same thing here -- but "c" says why the name is
'' undecorated instead of leaving it to a convention that no longer varies.

#pragma once

'' THE RUNTIME'S NUMBER, NOT BASIC'S. tiko-rt's inc/rterror.bi says it plainly:
'' ILLEGALFUNCTIONCALL is 1 in the runtime's own table and 5 in the BASIC error
'' numbering a program sees, and guessing which one an entry point returns gets
'' it wrong. Entry points return the RUNTIME's.
'' Defined here because libtkogfx does not include the runtime's headers -- it
'' shares the runtime's CONTEXT (abi/rtlctx.bi) and nothing else.
const FB_RTERROR_ILLEGALFUNCTIONCALL = 1

namespace TkoGfx

'' Open a framebuffer of this geometry and show it. Shared by SCREEN and
'' SCREENRES, which differ only in where the geometry comes from.
''
'' `mode` is recorded for SCREENINFO and the palette rules; SCREENRES passes 0,
'' which is what fbc reports for a resolution-set screen.
private function ScreenOpen( byval mode as long, byval w as long, byval h as long, _
        byval depth as long ) as long
    if (w <= 0) orelse (h <= 0) then return FB_RTERROR_ILLEGALFUNCTIONCALL

    '' BYTES from BITS. ModeTable's depth is bits per pixel and Surface.bpp is
    '' bytes; conflating them is a four-times buffer overrun rather than a wrong
    '' colour, which is why the conversion is a select rather than a shift.
    dim as long bpp
    select case depth
    case 1, 2, 4, 8 : bpp = 1
    case 15, 16     : bpp = 2
    case 24, 32     : bpp = 4
    case else       : return FB_RTERROR_ILLEGALFUNCTIONCALL
    end select

    '' A second SCREEN replaces the first, as it does in fbc.
    ConsoleShutdownIfLive( )
    ScreenTeardown( )

    '' The pitch is the width in bytes, unpadded. gfxlib2 pads its FRAMEBUFFER
    '' to the driver's stride and reports that through SCREENINFO; nothing here
    '' reads the framebuffer through SCREENINFO yet, and the presenter is told
    '' the pitch explicitly.
    dim as integer pitch = w * bpp

    '' CALLOCATE, not ALLOCATE: a fresh screen is black, and the window thread
    '' may present before anything has drawn.
    dim as any ptr px = callocate( pitch * h )
    if px = 0 then return FB_RTERROR_ILLEGALFUNCTIONCALL

    '' THE DIRTY ARRAY, WITHOUT WHICH NOTHING IS EVER PRESENTED.
    ''
    '' DirtyMark returns immediately when Surface.dirty is NULL, and
    '' GdiPresentDirty presents only rows that are marked. A screen surface with
    '' no array therefore draws correctly into memory and shows NOTHING: the
    '' window displays whatever its first WM_PAINT put there, which is the black
    '' frame from before the program drew anything.
    ''
    '' This was true at EVERY depth, not just 8bpp, from the day fb_GfxScreen was
    '' written. Nothing caught it because nothing looked at the window:
    '' tools/smoke.sh reads the framebuffer back through POINT, gate-entry
    '' digests through POINT, and tools/probe-window.bas allocates a dirty array
    '' of its own because it calls WindowOpen directly rather than through
    '' SCREEN. It took reading pixels off the presented window to see it.
    dim as any ptr dirtybuf = callocate( h )
    if dirtybuf = 0 then
        deallocate( px )
        return FB_RTERROR_ILLEGALFUNCTIONCALL
    end if

    SurfaceInit( ScreenCtx.surf, px, w, h, pitch, bpp )
    ScreenCtx.surf.dirty = dirtybuf
    TheScreen.dirty = dirtybuf
    ViewportInit( ScreenCtx.vp, w, h )
    DrawStateInit( ScreenCtx.draw, bpp * 8 )
    ScreenCtx.target = 0
    ScreenCtx.inuse = 1

    TheScreen.pixels = px
    TheScreen.mode = mode

    '' WindowOpen RETURNS 1 ON SUCCESS AND 0 ON FAILURE -- driver/window.bi says
    '' so in a comment above it. Testing it the other way round treats every
    '' successful open as a failure, frees the framebuffer and leaves isOpen at
    '' 0, so SCREEN reports error 1 and every later call finds no context and
    '' answers -1. That is exactly what it did until the first fbc-compiled
    '' program was run against this library.
    '' Prime the palette and the presentation LUT BEFORE the window opens: the
    '' pump thread may present the first frame before the caller's next
    '' statement, and an 8bpp surface with a null LUT presents nothing.
    TheScreen.isOpen = 1
    if bpp = 1 then
        PaletteCurrent( )
        TheScreen.wnd.lut = @PaletteLut(0)
    end if
    TheScreen.isOpen = 0

    if WindowOpen( TheScreen.wnd, ScreenCtx.surf, w, h, "tiko" ) = 0 then
        deallocate( px )
        TheScreen.pixels = 0
        ScreenCtx.inuse = 0
        return FB_RTERROR_ILLEGALFUNCTIONCALL
    end if

    '' WindowOpen resets the struct, so the LUT is re-pointed after it rather
    '' than before -- setting it once above would leave the pump reading null.
    if bpp = 1 then TheScreen.wnd.lut = @PaletteLut(0)

    TheScreen.isOpen = 1

    '' THE CONSOLE HOOKS GO IN LAST, once the surface, the palette and the window
    '' all exist -- ConsoleStart draws into the surface and reads the colour pair
    '' out of ScreenCtx.draw, so neither may still be half-built.
    ''
    '' From here PRINT lands on the graphics screen instead of stdout, which is
    '' what fbc does and what every abtest already assumes: they buffer their
    '' reports and print after SCREEN 0 precisely because gfxlib2 hooks the
    '' console. Anything that printed mid-run was relying on us NOT doing this.
    ConsoleStart( mode )

    return 0
end function

end namespace

extern "c"

'' SCREEN mode [, depth [, num_pages [, flags [, refresh ]]]]
''
'' Returns 0 on success and FB_RTERROR_ILLEGALFUNCTIONCALL (1) for a mode this
'' library cannot open, which is what a BASIC program sees as "illegal function
'' call". SCREEN 0 closes and is never an error.
''
'' NOT YET HONOURED, and each is a silent no-op rather than a refusal because a
'' refusal would break programs that pass the ordinary defaults:
''
''   depth       the framebuffer is 32bpp -- see entry/context.bi
''   num_pages   one page; PCOPY and SCREENSET have no entry points yet
''   flags       no GL, no fullscreen, no alpha-request handling
''   refresh     the GDI presenter does not drive a refresh rate
''
'' THE CONSOLE HOOKS ARE NOT INSTALLED, deliberately. core/hooks.bi can install
'' them in one call, and doing so would route PRINT, LOCATE, CLS, INKEY and the
'' rest through raster/text.bi -- which is written but has no entry points and
'' has never been exercised. Installing them now would take PRINT from working
'' to silently broken on a graphics screen. They go in with the text entry
'' points, gated by tools/abtest-print.bas.
function TkoGfxScreen alias "fb_GfxScreen" ( _
        byval mode as long, _
        byval depth as long, _
        byval num_pages as long, _
        byval flags as long, _
        byval refresh as long ) as long

    '' Unused today, and named rather than dropped so the signature stays the
    '' one tiko emits.
    scope
        dim as long ignored = depth + num_pages + flags + refresh
    end scope

    if mode = 0 then
        TkoGfx.ConsoleShutdownIfLive( )
        TkoGfx.ScreenTeardown( )
        return 0
    end if

    if TkoGfx.ModeSupported( mode ) = 0 then
        return FB_RTERROR_ILLEGALFUNCTIONCALL
    end if

    return TkoGfx.ScreenOpen( mode, TkoGfx.ModeTable(mode).w, TkoGfx.ModeTable(mode).h, _
                              TkoGfx.ModeTable(mode).depth )
end function

'' SCREENRES w, h [, depth [, num_pages [, flags [, refresh ]]]]
''
'' The mode is recorded as 0: there is no legacy mode number for an arbitrary
'' resolution, and that is what SCREENINFO reports for one.
function TkoGfxScreenRes alias "fb_GfxScreenRes" ( _
        byval w as long, _
        byval h as long, _
        byval depth as long, _
        byval num_pages as long, _
        byval flags as long, _
        byval refresh as long ) as long

    scope
        dim as long ignored = num_pages + flags + refresh
    end scope

    if (w <= 0) orelse (h <= 0) then return FB_RTERROR_ILLEGALFUNCTIONCALL
    return TkoGfx.ScreenOpen( 0, w, h, iif( depth > 0, depth, 8 ) )
end function

'' SCREEN's QB form -- `SCREEN mode, colorswitch, activepage, visiblepage`
'' reduced by fbc to three arguments.
''
'' THE TWO PAGE ARGUMENTS ARE NOT HONOURED, and saying so is the whole of the
'' difference from fbc: one page exists, so an active or visible page other than
'' 0 is accepted and ignored rather than refused. A refusal would break the
'' common `screen 13, , 0, 0`.
function TkoGfxScreenQB alias "fb_GfxScreenQB" ( _
        byval mode as long, _
        byval active_page as long, _
        byval visible_page as long ) as long

    scope
        dim as long ignored = active_page + visible_page
    end scope

    if mode = 0 then
        TkoGfx.ConsoleShutdownIfLive( )
        TkoGfx.ScreenTeardown( )
        return 0
    end if
    if TkoGfx.ModeSupported( mode ) = 0 then
        return FB_RTERROR_ILLEGALFUNCTIONCALL
    end if
    return TkoGfx.ScreenOpen( mode, TkoGfx.ModeTable(mode).w, TkoGfx.ModeTable(mode).h, _
                              TkoGfx.ModeTable(mode).depth )
end function

end extern
