'' cls.bi -- CLS for 32bpp.
''
'' Derived from: gfx_cls.c (fb_GfxClear). LGPL-2.1-or-later with the
'' static-linking exception.
''
'' THREE MODES, AND THE DEFAULT PICKS ONE AT RUNTIME
''
''   0  clear the whole screen
''   1  clear the GRAPHICS viewport
''   2  clear the TEXT viewport (VIEW PRINT range) -- Phase 5, needs char cells
''
'' `CLS` with no argument arrives as 0xFFFF0000 and resolves to mode 1 when a
'' VIEW is set, otherwise to 0 or 2 depending on whether VIEW PRINT has narrowed
'' the console. So the same statement clears different things depending on state
'' set by two other statements.
''
'' MODE 0 IS A SINGLE FLAT RUN. gfxlib2 clears `w * h` pixels from `line[0]` in
'' one call, which is only correct because the screen's pitch equals w * bpp.
'' Mode 1 walks row by row and honours the pitch. Reproducing that split matters
'' for a surface whose pitch is padded: mode 0 on such a surface would run past
'' the end of each row into the padding, which is what gfxlib2 does and is
'' harmless there but is NOT safe to generalise. Mode 0 here therefore refuses a
'' padded surface and falls back to the row-wise path, which produces identical
'' pixels for the unpadded case.
''
'' CLS ALSO MOVES THE GRAPHICS CURSOR, AND STORES A PHYSICAL VALUE IN A LOGICAL
'' FIELD. Modes 0 and 1 set `last_x = view_x + view_w \ 2`. But `last_x` is the
'' LOGICAL cursor everywhere else -- fb_hFixRelative writes logical coordinates
'' into it -- so a following `LINE -STEP` translates it again and adds `view_x` a
'' SECOND time.
''
'' With a viewport at x=10, CLS leaves the cursor at logical 45, and the next
'' relative draw lands at physical 55, not 45. Measured, and reproduced: the
'' cursor written here is what gfxlib2 writes, not what a corrected version
'' would. Mode 2 leaves the cursor alone.

#pragma once

#include once "pixel.bi"
#include once "../core/viewport.bi"
#include once "../core/dirty.bi"

namespace TkoGfx

const CLS_DEFAULT as long = &hFFFF0000

'' Clear `rows` rows of `width` pixels starting at (x, y).
private sub ClsFillRect( _
        byref s as Surface, _
        byval x as long, byval y as long, _
        byval width_ as long, byval rows as long, _
        byval col as ulong )

    dim as integer r = 0
    while r < rows
        dim as ulong ptr row = cptr( ulong ptr, SurfaceRowAddr( s, y + r ) )
        dim as integer i = x
        dim as integer stop_ = x + width_ - 1
        while i <= stop_
            row[i] = col
            i += 1
        wend
        r += 1
    wend
end sub

'' CLS. `mode` is 0, 1, 2 or CLS_DEFAULT.
''
'' cx/cy are the graphics cursor, moved for modes 0 and 1. Mode 2 is not
'' implemented and is treated as a no-op rather than silently clearing something
'' else -- see the header.
private sub Cls32( _
        byref s as Surface, _
        byref vp as Viewport, _
        byval mode as long, _
        byval bg as ulong, _
        byref cx as single, byref cy as single )

    if mode = CLS_DEFAULT then
        if vp.flags and CTX_VIEWPORT_SET then
            mode = 1
        else
            mode = 0
        end if
    end if

    dim as long dirty_y = 0
    dim as long dirty_n = 0
    dim as long moved = 0

    select case mode
    case 0
        ClsFillRect( s, 0, 0, s.w, s.h, bg )
        dirty_y = 0
        dirty_n = s.h
        moved = 1

    case 2
        '' Text viewport -- Phase 5.
        exit sub

    case else
        ClsFillRect( s, vp.view_x, vp.view_y, vp.view_w, vp.view_h, bg )
        dirty_y = vp.view_y
        dirty_n = vp.view_h
        moved = 1
    end select

    DirtyMark( s, dirty_y, dirty_n )

    if moved then
        cx = csng( vp.view_x + (vp.view_w shr 1) )
        cy = csng( vp.view_y + (vp.view_h shr 1) )
    end if
end sub

end namespace
