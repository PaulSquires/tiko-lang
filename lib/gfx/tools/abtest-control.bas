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
'' The window/driver selectors (FB.GET_WINDOW_POS, FB.GET_WINDOW_HANDLE,
'' FB.GET_DESKTOP_SIZE) are NOT compared: they go to the OS, and libtkogfx has no
'' presenter yet. They are reported as unhandled by ScreenControlGet, and this
'' test asserts that too -- claiming to answer them would be worse than
'' declining.

#include once "../core/control.bi"
#include once "fbgfx.bi"

using TkoGfx
using FB

dim as string report
dim as long failures = 0
dim as long ran = 0

'' ---- our selector NUMBERS must equal fbgfx.bi's ----
''
'' They are transcribed constants, and fbgfx.bi declares the same set. The
'' collision that forced the FB. qualification below is itself the opportunity:
'' compare the two definitions directly rather than assuming the transcription
'' was right.
scope
    ran += 1
    if FB.GET_SCREEN_SIZE <> TkoGfx.GET_SCREEN_SIZE then
        report += "  SELECTOR NUMBER MISMATCH GET_SCREEN_SIZE: fbgfx.bi=" + str(FB.GET_SCREEN_SIZE) + " tko=" + str(TkoGfx.GET_SCREEN_SIZE) + chr(10)
        failures += 1
    end if
    ran += 1
    if FB.GET_SCREEN_DEPTH <> TkoGfx.GET_SCREEN_DEPTH then
        report += "  SELECTOR NUMBER MISMATCH GET_SCREEN_DEPTH: fbgfx.bi=" + str(FB.GET_SCREEN_DEPTH) + " tko=" + str(TkoGfx.GET_SCREEN_DEPTH) + chr(10)
        failures += 1
    end if
    ran += 1
    if FB.GET_SCREEN_BPP <> TkoGfx.GET_SCREEN_BPP then
        report += "  SELECTOR NUMBER MISMATCH GET_SCREEN_BPP: fbgfx.bi=" + str(FB.GET_SCREEN_BPP) + " tko=" + str(TkoGfx.GET_SCREEN_BPP) + chr(10)
        failures += 1
    end if
    ran += 1
    if FB.GET_SCREEN_PITCH <> TkoGfx.GET_SCREEN_PITCH then
        report += "  SELECTOR NUMBER MISMATCH GET_SCREEN_PITCH: fbgfx.bi=" + str(FB.GET_SCREEN_PITCH) + " tko=" + str(TkoGfx.GET_SCREEN_PITCH) + chr(10)
        failures += 1
    end if
    ran += 1
    if FB.GET_SCREEN_REFRESH <> TkoGfx.GET_SCREEN_REFRESH then
        report += "  SELECTOR NUMBER MISMATCH GET_SCREEN_REFRESH: fbgfx.bi=" + str(FB.GET_SCREEN_REFRESH) + " tko=" + str(TkoGfx.GET_SCREEN_REFRESH) + chr(10)
        failures += 1
    end if
    ran += 1
    if FB.GET_TRANSPARENT_COLOR <> TkoGfx.GET_TRANSPARENT_COLOR then
        report += "  SELECTOR NUMBER MISMATCH GET_TRANSPARENT_COLOR: fbgfx.bi=" + str(FB.GET_TRANSPARENT_COLOR) + " tko=" + str(TkoGfx.GET_TRANSPARENT_COLOR) + chr(10)
        failures += 1
    end if
    ran += 1
    if FB.GET_VIEWPORT <> TkoGfx.GET_VIEWPORT then
        report += "  SELECTOR NUMBER MISMATCH GET_VIEWPORT: fbgfx.bi=" + str(FB.GET_VIEWPORT) + " tko=" + str(TkoGfx.GET_VIEWPORT) + chr(10)
        failures += 1
    end if
    ran += 1
    if FB.GET_COLOR <> TkoGfx.GET_COLOR then
        report += "  SELECTOR NUMBER MISMATCH GET_COLOR: fbgfx.bi=" + str(FB.GET_COLOR) + " tko=" + str(TkoGfx.GET_COLOR) + chr(10)
        failures += 1
    end if
    ran += 1
    if FB.GET_ALPHA_PRIMITIVES <> TkoGfx.GET_ALPHA_PRIMITIVES then
        report += "  SELECTOR NUMBER MISMATCH GET_ALPHA_PRIMITIVES: fbgfx.bi=" + str(FB.GET_ALPHA_PRIMITIVES) + " tko=" + str(TkoGfx.GET_ALPHA_PRIMITIVES) + chr(10)
        failures += 1
    end if
    ran += 1
    if FB.GET_HIGH_PRIORITY <> TkoGfx.GET_HIGH_PRIORITY then
        report += "  SELECTOR NUMBER MISMATCH GET_HIGH_PRIORITY: fbgfx.bi=" + str(FB.GET_HIGH_PRIORITY) + " tko=" + str(TkoGfx.GET_HIGH_PRIORITY) + chr(10)
        failures += 1
    end if
    ran += 1
    if FB.GET_SCANLINE_SIZE <> TkoGfx.GET_SCANLINE_SIZE then
        report += "  SELECTOR NUMBER MISMATCH GET_SCANLINE_SIZE: fbgfx.bi=" + str(FB.GET_SCANLINE_SIZE) + " tko=" + str(TkoGfx.GET_SCANLINE_SIZE) + chr(10)
        failures += 1
    end if
    ran += 1
    if FB.GET_X86_MMX_ENABLED <> TkoGfx.GET_X86_MMX_ENABLED then
        report += "  SELECTOR NUMBER MISMATCH GET_X86_MMX_ENABLED: fbgfx.bi=" + str(FB.GET_X86_MMX_ENABLED) + " tko=" + str(TkoGfx.GET_X86_MMX_ENABLED) + chr(10)
        failures += 1
    end if
    ran += 1
    if FB.GET_WINDOW_POS <> TkoGfx.GET_WINDOW_POS then
        report += "  SELECTOR NUMBER MISMATCH GET_WINDOW_POS: fbgfx.bi=" + str(FB.GET_WINDOW_POS) + " tko=" + str(TkoGfx.GET_WINDOW_POS) + chr(10)
        failures += 1
    end if
    ran += 1
    if FB.GET_WINDOW_HANDLE <> TkoGfx.GET_WINDOW_HANDLE then
        report += "  SELECTOR NUMBER MISMATCH GET_WINDOW_HANDLE: fbgfx.bi=" + str(FB.GET_WINDOW_HANDLE) + " tko=" + str(TkoGfx.GET_WINDOW_HANDLE) + chr(10)
        failures += 1
    end if
    ran += 1
    if FB.GET_DESKTOP_SIZE <> TkoGfx.GET_DESKTOP_SIZE then
        report += "  SELECTOR NUMBER MISMATCH GET_DESKTOP_SIZE: fbgfx.bi=" + str(FB.GET_DESKTOP_SIZE) + " tko=" + str(TkoGfx.GET_DESKTOP_SIZE) + chr(10)
        failures += 1
    end if
    ran += 1
    if FB.GET_DRIVER_NAME <> TkoGfx.GET_DRIVER_NAME then
        report += "  SELECTOR NUMBER MISMATCH GET_DRIVER_NAME: fbgfx.bi=" + str(FB.GET_DRIVER_NAME) + " tko=" + str(TkoGfx.GET_DRIVER_NAME) + chr(10)
        failures += 1
    end if
end scope

dim as long sel(...)  = { FB.GET_SCREEN_SIZE, FB.GET_SCREEN_DEPTH, FB.GET_SCREEN_BPP, _
                          FB.GET_SCREEN_PITCH, FB.GET_SCREEN_REFRESH, _
                          FB.GET_TRANSPARENT_COLOR, FB.GET_VIEWPORT, FB.GET_COLOR, _
                          FB.GET_ALPHA_PRIMITIVES, FB.GET_HIGH_PRIORITY, _
                          FB.GET_SCANLINE_SIZE, FB.GET_X86_MMX_ENABLED }
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

    screen mode

    '' our state, derived from the mode table plus the pitch SCREENINFO reports
    dim as long iw, ih, idepth, ibpp, ipitch, irefresh
    screeninfo iw, ih, idepth, ibpp, ipitch, irefresh

    dim as GfxScreenState st
    if ScreenStateFromMode( st, mode, ipitch ) = 0 then
        report += "  mode " + str(mode) + " not in our table" + chr(10)
        failures += 1
        screen 0
        continue for
    end if
    st.refresh_rate = irefresh

    '' a viewport, so FB.GET_VIEWPORT is not just 0,0,w-1,h-1
    dim as long vx1 = 3, vy1 = 5
    dim as long vx2 = st.w \ 2, vy2 = st.h \ 2
    view (vx1, vy1)-(vx2, vy2)

    dim as Surface dummy
    dim as any ptr dbuf = allocate( st.w * 4 )
    SurfaceInit( dummy, dbuf, st.w, st.h, st.w * 4, 4 )
    dim as Viewport vp
    ViewportInit( vp, st.w, st.h )
    ViewSet( vp, dummy, vx1, vy1, vx2, vy2, 0 )

    '' a known colour pair
    color 9, 3
    dim as long cfg, cbg
    screencontrol FB.GET_COLOR, cfg, cbg

    for si as integer = 0 to ubound( sel )
        dim as long w1, w2, w3, w4
        w1 = 0 : w2 = 0 : w3 = 0 : w4 = 0
        screencontrol sel(si), w1, w2, w3, w4

        dim as integer g1, g2, g3, g4
        dim as long handled = ScreenControlGet( st, vp, cfg, cbg, 0, 0, sel(si), g1, g2, g3, g4 )

        ran += 1
        if handled = 0 then
            report += "  mode " + str(mode) + " selector " + selname(si) + " NOT HANDLED" + chr(10)
            failures += 1
        elseif (w1 <> g1) orelse (w2 <> g2) orelse (w3 <> g3) orelse (w4 <> g4) then
            report += "  MISMATCH mode " + str(mode) + " " + selname(si) + _
                      ": gfxlib2=(" + str(w1) + "," + str(w2) + "," + str(w3) + "," + str(w4) + ")" + _
                      " tko=(" + str(g1) + "," + str(g2) + "," + str(g3) + "," + str(g4) + ")" + chr(10)
            failures += 1
        end if
    next

    deallocate( dbuf )
    screen 0
next

'' ---- the driver selectors must be DECLINED, not guessed ----
scope
    dim as GfxScreenState st
    dim as Viewport vp
    dim as integer a, b, c, d
    dim as long drv(...) = { FB.GET_WINDOW_POS, FB.GET_WINDOW_HANDLE, FB.GET_DESKTOP_SIZE, FB.GET_DRIVER_NAME }
    for i as integer = 0 to ubound( drv )
        ran += 1
        if ScreenControlGet( st, vp, 0, 0, 0, 0, drv(i), a, b, c, d ) <> 0 then
            report += "  selector " + str(drv(i)) + " claims to be handled but needs a driver" + chr(10)
            failures += 1
        end if
    next
end scope

print "abtest-control -- "; ran; " SCREENCONTROL checks across "; ubound(modes) + 1; " modes"
if failures = 0 then
    print "abtest-control: PASS -- every selector agrees"
    end 0
else
    print report;
    print "abtest-control: FAIL -- "; failures; " of"; ran; " differ"
    end 1
end if
