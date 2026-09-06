'' entry/screen.bi -- fb_GfxScreen, the first public entry point.
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
'' THE SIGNATURE IS TIKO'S, NOT A GUESS. src/mir/rtl.bi:
''
''     RTL( RTL_GFX_SCREEN, "fb_GfxScreen", "l", "lllll" )
''
'' and src/mir/lowergfx.bas pushes five arguments with the SECOND defaulting to
'' 8, which fixes the order as ( mode, depth, num_pages, flags, refresh ).
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

'' THE FRAMEBUFFER IS 32BPP WHATEVER THE MODE SAYS, and that is a deliberate
'' first step rather than an approximation of one.
''
'' ModeTable's `depth` is BITS per pixel and every legacy mode is 8 or fewer;
'' Surface.bpp is BYTES. Presenting an 8-bit surface needs the palette pushed
'' into the BITMAPINFO, and driver/gdi.bi's GdiDescribe writes a bare
'' BITMAPINFOHEADER with biBitCount = bpp * 8 and BI_RGB -- correct for 32bpp
'' and silently wrong for 8, where the colour table it does not write is
'' required. The raster layer agrees: pixel, line, box, circle and paint are all
'' documented 32bpp. So 32bpp is what BOTH ends already implement, and paletted
'' modes wait for core/palette.bi to be wired into GdiDescribe.
''
'' WHAT THIS MEANS FOR A CALLER TODAY: the geometry of SCREEN 1..21 is honoured
'' exactly -- 320x200 is 320x200 -- and the pixel format is not.
type ScreenState
    surf     as Surface
    wnd      as GfxWindow
    pixels   as any ptr
    mode     as long
    isOpen   as long
end type

dim shared as ScreenState TheScreen

'' Tear down whatever is open. Safe to call when nothing is.
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
    SurfaceInit( TheScreen.surf, 0, 0, 0, 0, 0 )
    TheScreen.mode = 0
    TheScreen.isOpen = 0
end sub

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
''   depth       the framebuffer is 32bpp -- see the note above
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
        TkoGfx.ScreenTeardown( )
        return 0
    end if

    if TkoGfx.ModeSupported( mode ) = 0 then
        return FB_RTERROR_ILLEGALFUNCTIONCALL
    end if

    '' A second SCREEN replaces the first, as it does in fbc.
    TkoGfx.ScreenTeardown( )

    dim as long w = TkoGfx.ModeTable(mode).w
    dim as long h = TkoGfx.ModeTable(mode).h
    dim as integer pitch = w * 4

    '' CALLOCATE, not ALLOCATE: a fresh screen is black, and the window thread
    '' may present before anything has drawn.
    dim as any ptr px = callocate( pitch * h )
    if px = 0 then return FB_RTERROR_ILLEGALFUNCTIONCALL

    TkoGfx.SurfaceInit( TkoGfx.TheScreen.surf, px, w, h, pitch, 4 )
    TkoGfx.TheScreen.pixels = px
    TkoGfx.TheScreen.mode = mode

    if TkoGfx.WindowOpen( TkoGfx.TheScreen.wnd, TkoGfx.TheScreen.surf, _
                          w, h, "tiko" ) <> 0 then
        deallocate( px )
        TkoGfx.TheScreen.pixels = 0
        return FB_RTERROR_ILLEGALFUNCTIONCALL
    end if

    TkoGfx.TheScreen.isOpen = 1
    return 0
end function

end extern
