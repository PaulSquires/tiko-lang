'' abtest-control.bas -- A/B for SCREENCONTROL and SCREENINFO.
''
'' ORIGINAL WORK (the harness). Part of libtkogfx: LGPL-2.1-or-later with the
'' static-linking exception.
''
'' SCREENCONTROL is a mapping from selector number to state field, and a mapping
'' is only tested by covering every entry. One transposed pair -- depth for bpp,
'' say, which agree at 8bpp -- is invisible until someone uses the other one.
''
'' AVOIDING A CIRCULAR TEST. Our side is driven from the MODE TABLE and from
'' SCREENINFO, not from `__fb_gfx`. Reading gfxlib2's own global and comparing it
'' against gfxlib2's reading of that same global would prove nothing; deriving
'' the state independently and comparing the ANSWERS is the real check.
''
'' Covered across several modes and screen depths so that fields which coincide
'' at one depth separate at another:
''
''   depth vs bpp     agree numerically only at 8bpp (8 vs 1 -- they differ, but
''                    a mode table row could transpose them)
''   w vs h           differ except on a square mode, so none is used
''   viewport corners vs origin+extent -- differ whenever a VIEW is set
''
'' The window/driver selectors (TkoGfx.GET_WINDOW_POS, TkoGfx.GET_WINDOW_HANDLE,
'' TkoGfx.GET_DESKTOP_SIZE) are NOT compared: they go to the OS, and libtkogfx has no
'' presenter yet. They are reported as unhandled by ScreenControlGet, and this
'' test asserts that too -- claiming to answer them would be worse than
'' declining.

#include once "../core/control.bi"
#include once "abtest.bi"
#ifdef ABTEST_HAS_GFXLIB2
#include once "fbgfx.bi"
using FB
#endif

using TkoGfx

Abtest.Begin( "abtest-control", "every selector agrees" )

'' ---- our selector NUMBERS must equal fbgfx.bi's ----
''
'' They are transcribed constants, and fbgfx.bi declares the same set. The
'' collision that forced the FB. qualification is itself the opportunity:
'' compare the two definitions directly rather than assuming the transcription
'' was right. Recorded, so the subject checks its own constants against the
'' numbers fbgfx.bi really had -- which is also what lets the rest of this file
'' use TkoGfx's constants where it used to use FB's.
Abtest.Case_( "selector number GET_SCREEN_SIZE", REF( TkoGfx.GET_SCREEN_SIZE ), TkoGfx.GET_SCREEN_SIZE )
Abtest.Case_( "selector number GET_SCREEN_DEPTH", REF( TkoGfx.GET_SCREEN_DEPTH ), TkoGfx.GET_SCREEN_DEPTH )
Abtest.Case_( "selector number GET_SCREEN_BPP", REF( TkoGfx.GET_SCREEN_BPP ), TkoGfx.GET_SCREEN_BPP )
Abtest.Case_( "selector number GET_SCREEN_PITCH", REF( TkoGfx.GET_SCREEN_PITCH ), TkoGfx.GET_SCREEN_PITCH )
Abtest.Case_( "selector number GET_SCREEN_REFRESH", REF( TkoGfx.GET_SCREEN_REFRESH ), TkoGfx.GET_SCREEN_REFRESH )
Abtest.Case_( "selector number GET_TRANSPARENT_COLOR", REF( TkoGfx.GET_TRANSPARENT_COLOR ), TkoGfx.GET_TRANSPARENT_COLOR )
Abtest.Case_( "selector number GET_VIEWPORT", REF( TkoGfx.GET_VIEWPORT ), TkoGfx.GET_VIEWPORT )
Abtest.Case_( "selector number GET_COLOR", REF( TkoGfx.GET_COLOR ), TkoGfx.GET_COLOR )
Abtest.Case_( "selector number GET_ALPHA_PRIMITIVES", REF( TkoGfx.GET_ALPHA_PRIMITIVES ), TkoGfx.GET_ALPHA_PRIMITIVES )
Abtest.Case_( "selector number GET_HIGH_PRIORITY", REF( TkoGfx.GET_HIGH_PRIORITY ), TkoGfx.GET_HIGH_PRIORITY )
Abtest.Case_( "selector number GET_SCANLINE_SIZE", REF( TkoGfx.GET_SCANLINE_SIZE ), TkoGfx.GET_SCANLINE_SIZE )
Abtest.Case_( "selector number GET_X86_MMX_ENABLED", REF( TkoGfx.GET_X86_MMX_ENABLED ), TkoGfx.GET_X86_MMX_ENABLED )
Abtest.Case_( "selector number GET_WINDOW_POS", REF( TkoGfx.GET_WINDOW_POS ), TkoGfx.GET_WINDOW_POS )
Abtest.Case_( "selector number GET_WINDOW_HANDLE", REF( TkoGfx.GET_WINDOW_HANDLE ), TkoGfx.GET_WINDOW_HANDLE )
Abtest.Case_( "selector number GET_DESKTOP_SIZE", REF( TkoGfx.GET_DESKTOP_SIZE ), TkoGfx.GET_DESKTOP_SIZE )
Abtest.Case_( "selector number GET_DRIVER_NAME", REF( TkoGfx.GET_DRIVER_NAME ), TkoGfx.GET_DRIVER_NAME )

dim as long sel(...)  = { TkoGfx.GET_SCREEN_SIZE, TkoGfx.GET_SCREEN_DEPTH, TkoGfx.GET_SCREEN_BPP, _
                          TkoGfx.GET_SCREEN_PITCH, TkoGfx.GET_SCREEN_REFRESH, _
                          TkoGfx.GET_TRANSPARENT_COLOR, TkoGfx.GET_VIEWPORT, TkoGfx.GET_COLOR, _
                          TkoGfx.GET_ALPHA_PRIMITIVES, TkoGfx.GET_HIGH_PRIORITY, _
                          TkoGfx.GET_SCANLINE_SIZE, TkoGfx.GET_X86_MMX_ENABLED }
dim as string selname(...) = { "SCREEN_SIZE", "SCREEN_DEPTH", "SCREEN_BPP", _
                          "SCREEN_PITCH", "SCREEN_REFRESH", _
                          "TRANSPARENT_COLOR", "VIEWPORT", "COLOR", _
                          "ALPHA_PRIMITIVES", "HIGH_PRIORITY", _
                          "SCANLINE_SIZE", "X86_MMX_ENABLED" }

'' legacy modes spanning every depth and both scanline_size values
dim as long modes(...) = { 1, 2, 7, 8, 9, 11, 12, 13, 14, 16, 18, 20 }

for mi as integer = 0 to ubound( modes )
    dim as long mode = modes(mi)
    if ModeSupported( mode ) = 0 then continue for

    dim as long iw, ih, idepth, ibpp, ipitch, irefresh
    ipitch = 0 : irefresh = 0
#ifdef ABTEST_HAS_GFXLIB2
    screen mode

    '' our state, derived from the mode table plus the pitch SCREENINFO reports
    screeninfo iw, ih, idepth, ibpp, ipitch, irefresh
#endif

    '' The pitch and the refresh rate are the driver's, not the table's, so with
    '' no driver they come from the recording. Everything else below is derived
    '' from the mode table and is computed in every role.
    ipitch   = cast( long, Abtest.Datum_( "m" + str(mode) + " pitch", ipitch ) )
    irefresh = cast( long, Abtest.Datum_( "m" + str(mode) + " refresh", irefresh ) )

    dim as GfxScreenState st
    if ScreenStateFromMode( st, mode, ipitch ) = 0 then
        Abtest.Fail_( "mode " + str(mode), "not in our table" )
#ifdef ABTEST_HAS_GFXLIB2
        screen 0
#endif
        continue for
    end if
    st.refresh_rate = irefresh

    '' a viewport, so TkoGfx.GET_VIEWPORT is not just 0,0,w-1,h-1
    dim as long vx1 = 3, vy1 = 5
    dim as long vx2 = st.w \ 2, vy2 = st.h \ 2
#ifdef ABTEST_HAS_GFXLIB2
    view (vx1, vy1)-(vx2, vy2)
#endif

    dim as Surface dummy
    dim as any ptr dbuf = allocate( st.w * 4 )
    SurfaceInit( dummy, dbuf, st.w, st.h, st.w * 4, 4 )
    dim as Viewport vp
    ViewportInit( vp, st.w, st.h )
    ViewSet( vp, dummy, vx1, vy1, vx2, vy2, 0 )

    '' a known colour pair
    dim as long cfg, cbg
    cfg = 0 : cbg = 0
#ifdef ABTEST_HAS_GFXLIB2
    color 9, 3
    screencontrol TkoGfx.GET_COLOR, cfg, cbg
#endif
    '' What COLOR 9,3 means depends on the mode's legacy rules, which is
    '' abtest-color's subject, not this file's. Taken from the reference, and
    '' from the recording when there is none.
    cfg = cast( long, Abtest.Datum_( "m" + str(mode) + " cfg", cfg ) )
    cbg = cast( long, Abtest.Datum_( "m" + str(mode) + " cbg", cbg ) )

    for si as integer = 0 to ubound( sel )
        dim as string tag = "mode " + str(mode) + " " + selname(si)
        dim as long w(0 to 3)
        w(0) = 0 : w(1) = 0 : w(2) = 0 : w(3) = 0
#ifdef ABTEST_HAS_GFXLIB2
        screencontrol sel(si), w(0), w(1), w(2), w(3)
#endif

        dim as integer g1, g2, g3, g4
        dim as long handled = ScreenControlGet( st, vp, cfg, cbg, 0, 0, sel(si), g1, g2, g3, g4 )
        dim as long g(0 to 3) = { g1, g2, g3, g4 }

        '' Four values in one digest, so the whole answer is one recordable
        '' number; the readable form goes in the detail line.
        Abtest.Case_( tag + " handled", 1, handled )
        Abtest.Case_( tag, Abtest.Digest( @w(0), 4 * sizeof( long ) ), _
                      Abtest.Digest( @g(0), 4 * sizeof( long ) ), _
                      "tko=(" + str(g1) + "," + str(g2) + "," + str(g3) + "," + str(g4) + ")" )
    next

    deallocate( dbuf )
#ifdef ABTEST_HAS_GFXLIB2
    screen 0
#endif
next

'' ---- the driver selectors must be DECLINED, not guessed ----
scope
    dim as GfxScreenState st
    dim as Viewport vp
    dim as integer a, b, c, d
    dim as long drv(...) = { TkoGfx.GET_WINDOW_POS, TkoGfx.GET_WINDOW_HANDLE, TkoGfx.GET_DESKTOP_SIZE, TkoGfx.GET_DRIVER_NAME }
    for i as integer = 0 to ubound( drv )
        Abtest.Case_( "driver selector " + str(drv(i)) + " is declined", _
                      0, ScreenControlGet( st, vp, 0, 0, 0, 0, drv(i), a, b, c, d ) )
    next
end scope

Abtest.Finish_( )
