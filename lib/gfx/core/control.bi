'' control.bi -- SCREENCONTROL getters and SCREENINFO.
''
'' Derived from: gfx_control.c (fb_GfxControl_i), gfx_screeninfo.c.
'' LGPL-2.1-or-later with the static-linking exception.
''
'' SCREENCONTROL is a ~60-selector switch returning up to four values through
'' BYREF out-parameters. The content is almost entirely a MAPPING -- selector
'' number to state field -- which is exactly the kind of thing that is easy to
'' get subtly wrong and impossible to notice from one wrong selector.
''
'' TWO SENTINEL CONVENTIONS LIVE IN THE SAME STATEMENT, and they are not the
'' same as SCREENINFO's:
''
''   SCREENCONTROL  an omitted BYREF argument is a NULL pointer, and the C
''                  substitutes a local temporary -- so an omitted argument is
''                  written and discarded, never skipped
''   GET_WINDOW_POS passes 0x80000000 to the driver as "query, do not set",
''                  which is a magic coordinate rather than a separate call
''
'' NOT EVERY SELECTOR IS A PURE FUNCTION OF STATE. GET_WINDOW_POS,
'' GET_WINDOW_HANDLE and GET_DESKTOP_SIZE go out to the driver or the OS. Those
'' are left to the presenter and are not implemented here -- see the README.
''
'' GET_VIEWPORT RETURNS AN INCLUSIVE BOX: x1, y1, x1 + w - 1, y1 + h - 1. The
'' viewport is stored as origin-plus-extent and reported as corners, so a
'' straight field copy is wrong by one on the second pair.

#pragma once

#include once "viewport.bi"
#include once "mode.bi"

namespace TkoGfx

const GET_WINDOW_POS       = 0
const GET_WINDOW_TITLE     = 1
const GET_WINDOW_HANDLE    = 2
const GET_DESKTOP_SIZE     = 3
const GET_SCREEN_SIZE      = 4
const GET_SCREEN_DEPTH     = 5
const GET_SCREEN_BPP       = 6
const GET_SCREEN_PITCH     = 7
const GET_SCREEN_REFRESH   = 8
const GET_DRIVER_NAME      = 9
const GET_TRANSPARENT_COLOR = 10
const GET_VIEWPORT         = 11
const GET_PEN_POS          = 12
const GET_COLOR            = 13
const GET_ALPHA_PRIMITIVES = 14
const GET_HIGH_PRIORITY    = 16
const GET_SCANLINE_SIZE    = 17
const GET_X86_MMX_ENABLED  = 18

'' Flags on the graphics state that some selectors report.
const GFXSTATE_ALPHA_PRIMITIVES = 1
const GFXSTATE_HIGH_PRIORITY    = 2
const GFXSTATE_X86_MMX_ENABLED  = 4

'' What SCREENCONTROL can answer without going to the driver or the OS.
type GfxScreenState
    w             as long
    h             as long
    depth         as long
    bpp           as long
    pitch         as long
    refresh_rate  as long
    scanline_size as long
    flags         as long
end type

'' Populate from a legacy SCREEN mode. SCREENRES fills this directly instead.
private function ScreenStateFromMode( _
        byref st as GfxScreenState, byval mode as long, byval pitch as long ) as long
    if ModeSupported( mode ) = 0 then return 0
    dim as ModeInfo m = ModeTable(mode)
    st.w             = m.w
    st.h             = m.h
    st.depth         = m.depth
    st.bpp           = (m.depth + 7) \ 8
    st.pitch         = pitch
    st.refresh_rate  = 0
    st.scanline_size = m.scanline_size

    '' X86_MMX_ENABLED IS TARGET-DEPENDENT, not a mode property.
    ''
    '' gfxlib2 sets it from a runtime CPUID check, but its MMX code only EXISTS
    '' on 32-bit: obj/win32 has eleven *_mmx.o files, obj/win64 has none, and the
    '' whole family is behind `#ifdef HOST_X86` which is 32-bit only. So on x64
    '' the flag is structurally always false, and on x86 it is true on any CPU
    '' made since 1997.
    ''
    '' Hardcoding 0 passed on win64 and failed all twelve modes on win32. Only
    '' running the suite on both targets caught it.
    st.flags = 0
    #ifndef __FB_64BIT__
        st.flags or= GFXSTATE_X86_MMX_ENABLED
    #endif
    return 1
end function

'' The state-only part of SCREENCONTROL. Returns 1 if the selector was handled,
'' 0 if it needs a driver (window position, handles, desktop size).
''
'' All four results are written even when a selector uses fewer -- gfxlib2
'' substitutes a temporary for an omitted argument rather than skipping it, so
'' every path assigns all four.
private function ScreenControlGet( _
        byref st as GfxScreenState, byref vp as Viewport, _
        byval fg as ulong, byval bg as ulong, _
        byval last_x as single, byval last_y as single, _
        byval what as long, _
        byref r1 as integer, byref r2 as integer, _
        byref r3 as integer, byref r4 as integer ) as long

    r1 = 0 : r2 = 0 : r3 = 0 : r4 = 0

    select case what
    case GET_SCREEN_SIZE
        r1 = st.w : r2 = st.h
    case GET_SCREEN_DEPTH
        r1 = st.depth
    case GET_SCREEN_BPP
        r1 = st.bpp
    case GET_SCREEN_PITCH
        r1 = st.pitch
    case GET_SCREEN_REFRESH
        r1 = st.refresh_rate
    case GET_TRANSPARENT_COLOR
        '' Only reported above 8bpp -- at 8bpp the transparent value is an index
        '' and this selector stays 0.
        if st.bpp > 1 then r1 = &hFF00FF
    case GET_VIEWPORT
        '' INCLUSIVE corners, not origin-plus-extent. See the header.
        r1 = vp.view_x
        r2 = vp.view_y
        r3 = vp.view_x + vp.view_w - 1
        r4 = vp.view_y + vp.view_h - 1
    case GET_PEN_POS
        r1 = cast( integer, last_x )
        r2 = cast( integer, last_y )
    case GET_COLOR
        r1 = cast( integer, fg )
        r2 = cast( integer, bg )
    case GET_ALPHA_PRIMITIVES
        r1 = iif( (st.flags and GFXSTATE_ALPHA_PRIMITIVES) <> 0, -1, 0 )
    case GET_HIGH_PRIORITY
        r1 = iif( (st.flags and GFXSTATE_HIGH_PRIORITY) <> 0, -1, 0 )
    case GET_SCANLINE_SIZE
        r1 = st.scanline_size
    case GET_X86_MMX_ENABLED
        r1 = iif( (st.flags and GFXSTATE_X86_MMX_ENABLED) <> 0, -1, 0 )
    case else
        return 0
    end select

    return 1
end function

end namespace
