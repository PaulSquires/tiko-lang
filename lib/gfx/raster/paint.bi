'' paint.bi -- PAINT for 32bpp, solid fill.
''
'' Derived from: gfx_paint.c (fb_GfxPaint, add_span).
'' LGPL-2.1-or-later with the static-linking exception.
''
'' A SPAN FLOOD FILL, NOT A PIXEL RECURSION. Each step extends left and right
'' from a seed until it meets the border colour, records that run, then queues
'' the rows above and below for the same treatment.
''
'' FOUR THINGS THAT ARE EASY TO GET WRONG
''
'' 1. THE FLOOD TESTS AGAINST THE BORDER COLOUR ONLY -- never against the fill
''    colour, and never against "already visited". gfxlib2 collects every span
''    FIRST and fills them all at the END, so painting cannot influence its own
''    spread. Filling as you go changes the result whenever the fill colour and
''    the border colour differ from what was already there, which is most of the
''    time. This is the single biggest structural difference from a naive
''    implementation.
''
'' 2. TERMINATION COMES FROM DEDUP, AND ONLY DEDUP. A span is skipped when a
''    span with the same x1 and x2 already exists in that row. Removing the check
''    fails 12 of the 14 A/B scenes -- the queue grows without bound and the fill
''    is truncated when it hits its cap.
''
''    Note that "exact match" and "any overlap" are the SAME TEST here, and the
''    comment that once claimed otherwise was wrong. add_span always extends to
''    the maximal run bounded by the border, so two spans in one row are either
''    identical or disjoint; a partial overlap cannot arise. Swapping the
''    condition for an overlap test changes nothing, which is measured, not
''    assumed.
''
'' 3. THE SEED SCAN ADVANCES PAST THE SPAN. add_span sets the caller's x to
''    x2 + 1, so the row-scanning loop skips the run it just consumed instead of
''    re-testing every pixel of it. Without that the work is quadratic and the
''    dedup list grows enormous, though the output is still correct.
''
'' 4. A SEED ON THE BORDER PAINTS NOTHING, and a seed outside the clip box
''    paints nothing. Both are early returns, not empty flood fills.
''
'' Fill ORDER does not matter for a solid colour -- every span gets the same
'' value -- so the per-row list order gfxlib2 keeps is not reproduced here. It
'' will matter for pattern mode, which is not done yet.

#pragma once

#include once "pixel.bi"
#include once "pixelfmt.bi"   '' PutPixel8 / PutPixel16
#include once "../core/dirty.bi"

namespace TkoGfx

type PaintSpan
    y  as long
    x1 as long
    x2 as long
    rownext as long      '' index of the next span in this row, or -1
end type

'' Extend from x across row y, bounded by the clip box and the border colour.
'' Advances x past the run. Returns the new span's index, or -1 if an identical
'' span is already recorded for this row.
''
'' ONE BODY, THREE INSTANCES. Only the STORE depends on the pixel width, so the
'' body below is a #macro instantiated for ubyte, ushort and ulong -- the shape
'' raster/pixelfmt.bi already uses. Calling a depth-dispatching PSetAny per
'' pixel would have been shorter and would put a `select case` inside the inner
'' loop of every fill this library does; RFC-0001 section 7 is explicit that
'' these loops are where the only available vectorisation lives.
''
'' The 32bpp instance generates textually what was here before the template, so
'' the abtests gate it unchanged.
#macro TKO_DEFINE_PAINT( suffix, elem )

private function PaintAddSpan##suffix( _
        byref s as Surface, _
        byval spans as PaintSpan ptr, _
        byref nspans as long, _
        byval cap as long, _
        byval rowhead as long ptr, _
        byref x as long, _
        byval y as long, _
        byval border as ulong ) as long

    dim as long x1 = x
    dim as long x2 = x

    while (x1 > s.clip_x1) andalso (GetPixel##suffix( s, x1 - 1, y ) <> border)
        x1 -= 1
    wend
    while (x2 < s.clip_x2) andalso (GetPixel##suffix( s, x2 + 1, y ) <> border)
        x2 += 1
    wend

    x = x2 + 1

    '' Exact-match dedup, walking this row's list. See note 2.
    dim as long i = rowhead[y - s.clip_y1]
    while i >= 0
        if (spans[i].x1 = x1) andalso (spans[i].x2 = x2) then return -1
        i = spans[i].rownext
    wend

    if nspans >= cap then return -1

    spans[nspans].y  = y
    spans[nspans].x1 = x1
    spans[nspans].x2 = x2
    spans[nspans].rownext = rowhead[y - s.clip_y1]
    rowhead[y - s.clip_y1] = nspans
    nspans += 1
    return nspans - 1
end function

'' One span of a PATTERN fill.
''
'' The pattern is an 8x8 tile. gfxlib2 keeps it as a flat 256-byte buffer and
'' picks the row with `(y and 7) shl 3`, so the tile is addressed by SCREEN
'' coordinates -- it is anchored to the surface origin, not to the shape being
'' filled. Two identical shapes at different y values get different-looking
'' fills, and that is correct.
''
'' The span is written in THREE parts, and the boundaries are the fiddly bit:
''
''   1. a leading partial run up to the next multiple of 8
''   2. whole 8-pixel tiles
''   3. a trailing partial run
''
'' with a special case when x1 and x2 fall inside the SAME 8-block, where there
'' is only part 1 and its length is the whole span. gfxlib2 also increments x2
'' before the middle loop, making it exclusive there and inclusive everywhere
'' else -- reproduced rather than normalised, because the loop bound
'' `(x2 and not 7) shr 3` depends on it.
private sub PaintPatternSpan##suffix( _
        byref s as Surface, _
        byval y as long, byval x1 as long, byval x2 as long, _
        byval pattern as elem ptr )

    dim as elem ptr src = pattern + ((y and 7) shl 3)
    dim as elem ptr row = cptr( elem ptr, SurfaceRowAddr( s, y ) )
    dim as long dst = x1

    dim as long same_block = iif( (x1 and (not 7)) = (x2 and (not 7)), 1, 0 )

    if (x1 and 7) <> 0 then
        dim as long n
        if same_block then
            n = x2 - x1 + 1
        else
            n = 8 - (x1 and 7)
        end if
        for k as integer = 0 to n - 1
            row[dst + k] = src[(x1 and 7) + k]
        next
        dst += n
    end if

    dim as long xend = x2 + 1
    dim as long first = (x1 + 7) shr 3
    dim as long last = (xend and (not 7)) shr 3
    dim as long blk = first
    while blk < last
        for k as integer = 0 to 7
            row[dst + k] = src[k]
        next
        dst += 8
        blk += 1
    wend

    if ((xend and 7) <> 0) andalso (same_block = 0) then
        for k as integer = 0 to (xend and 7) - 1
            row[dst + k] = src[k]
        next
    end if
end sub

'' PAINT with a solid colour, flooding until it meets `border`.
private sub Paint##suffix( _
        byref s as Surface, _
        byval x as long, byval y as long, _
        byval col as ulong, byval border as ulong, _
        byval pattern as elem ptr = 0 )

    if SurfaceClipEmpty( s ) then exit sub
    if (x < s.clip_x1) orelse (x > s.clip_x2) then exit sub
    if (y < s.clip_y1) orelse (y > s.clip_y2) then exit sub
    if GetPixel##suffix( s, x, y ) = border then exit sub

    dim as long clip_h = s.clip_y2 - s.clip_y1 + 1
    dim as long clip_w = s.clip_x2 - s.clip_x1 + 1

    '' Worst case is one span per run per row. A row cannot hold more than
    '' (w+1)/2 disjoint runs, since each needs a border pixel between it and the
    '' next; the cap is generous rather than tight, and a full cap degrades to a
    '' partial fill rather than a crash.
    dim as long cap = clip_h * ((clip_w + 1) \ 2 + 1) + 8

    dim as PaintSpan ptr spans = allocate( cap * sizeof( PaintSpan ) )
    dim as long ptr rowhead = allocate( clip_h * sizeof( long ) )
    if (spans = 0) orelse (rowhead = 0) then
        if spans <> 0 then deallocate( spans )
        if rowhead <> 0 then deallocate( rowhead )
        exit sub
    end if

    for i as integer = 0 to clip_h - 1
        rowhead[i] = -1
    next

    dim as long nspans = 0
    dim as long seed = PaintAddSpan##suffix( s, spans, nspans, cap, rowhead, x, y, border )
    if seed < 0 then
        deallocate( spans ) : deallocate( rowhead )
        exit sub
    end if

    '' The work queue is just the span array read in order: every span appended
    '' is visited exactly once, which is what gfxlib2's head/tail list achieves.
    dim as long cur = 0
    while cur < nspans
        dim as long sy = spans[cur].y
        dim as long sx1 = spans[cur].x1
        dim as long sx2 = spans[cur].x2

        if sy - 1 >= s.clip_y1 then
            dim as long sx = sx1
            while sx <= sx2
                if GetPixel##suffix( s, sx, sy - 1 ) <> border then
                    PaintAddSpan##suffix( s, spans, nspans, cap, rowhead, sx, sy - 1, border )
                else
                    sx += 1
                end if
            wend
        end if

        if sy + 1 <= s.clip_y2 then
            dim as long sx = sx1
            while sx <= sx2
                if GetPixel##suffix( s, sx, sy + 1 ) <> border then
                    PaintAddSpan##suffix( s, spans, nspans, cap, rowhead, sx, sy + 1, border )
                else
                    sx += 1
                end if
            wend
        end if

        cur += 1
    wend

    '' Fill last, so the flood above could not see its own output.
    dim as long top = s.clip_y2
    dim as long bottom = s.clip_y1
    for i as integer = 0 to nspans - 1
        if pattern = 0 then
            dim as elem ptr row = cptr( elem ptr, SurfaceRowAddr( s, spans[i].y ) )
            dim as integer px = spans[i].x1
            while px <= spans[i].x2
                row[px] = cast( elem, col )
                px += 1
            wend
        else
            PaintPatternSpan##suffix( s, spans[i].y, spans[i].x1, spans[i].x2, pattern )
        end if
        if spans[i].y < top then top = spans[i].y
        if spans[i].y > bottom then bottom = spans[i].y
    next

    if nspans > 0 then DirtyMark( s, top, bottom - top + 1 )

    deallocate( spans )
    deallocate( rowhead )
end sub

#endmacro

TKO_DEFINE_PAINT( 8, ubyte )
TKO_DEFINE_PAINT( 16, ushort )
TKO_DEFINE_PAINT( 32, ulong )

'' Flood-fill at whatever depth the surface is. The pattern tile is 8x8 of the
'' SURFACE element type, so its pointer is passed untyped and cast per instance.
private sub PaintAny( _
        byref s as Surface, _
        byval x as long, byval y as long, _
        byval col as ulong, byval border as ulong, _
        byval pattern as any ptr = 0 )
    select case s.bpp
    case 1 : Paint8( s, x, y, col, border, cptr( ubyte ptr, pattern ) )
    case 2 : Paint16( s, x, y, col, border, cptr( ushort ptr, pattern ) )
    case else : Paint32( s, x, y, col, border, cptr( ulong ptr, pattern ) )
    end select
end sub

end namespace
