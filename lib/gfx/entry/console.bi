'' entry/console.bi -- the console hooks, so PRINT lands on a graphics screen.
''
'' ORIGINAL WORK. Part of libtkogfx: LGPL-2.1-or-later with the static-linking
'' exception.
''
'' The runtime routes PRINT, LOCATE, CLS, COLOR, POS, CSRLIN, WIDTH and
'' SCREEN(r,c) through __fb_ctx.hooks when they are set. Opening a graphics
'' screen installs this table; SCREEN 0 clears it.
''
'' PARTIAL INSTALLATION IS SAFE, AND THAT IS WHY THIS FILE IS NOT ALL 28 HOOKS.
'' tiko-rt's inc/ctx.bi says it plainly -- "when a slot is NULL the console
'' implementation runs instead" -- and lib/rt/src/io/hookprint.bas is the
'' pattern: read the slot, call it if set, otherwise call the console. So a
'' table with eleven slots filled and seventeen null leaves the rest behaving
'' exactly as they did before this file existed. Filling a slot badly is a
'' regression; leaving it null is not.
''
'' WHAT IS INSTALLED, and each is here because the internals it needs are
'' already compared against gfxlib2:
''
''     printbuff   raster/text.bi   gated by tools/abtest-print.bas
''     cls         raster/cls.bi    gated by tools/abtest-cls.bas
''     locate, getx, gety, getxy, getsize, readxy, width
''                 core/cells.bi    gated by tools/abtest-cells.bas
''     color       raster/color.bi  gated by tools/abtest-color.bas
''     pagecopy, pageset
''                 core/cells.bi    the one-page answers, see below
''
'' WHAT IS DELIBERATELY LEFT NULL: inkey, getkey, keyhit, readstr, lineinput,
'' multikey, getmouse, setmouse, in, out, sleep, isredir, viewupdate,
'' posteventproc. Their internals exist and are gated, but routing INPUT and
'' LINE INPUT through a graphics screen needs a text cursor and an editing loop
'' that does not exist yet, and installing the input half without the editing
'' half would take INPUT from working to broken.
''
'' THE CALLBACKS ARE CDECL. core/hooks.bi says why at length: the runtime's hook
'' typedefs carry no FBCALL even though the entry points that consult them do.

#pragma once

namespace TkoGfx

'' PRINT's mask, from lib/rt/src/inc/print.bi rather than guessed.
const FB_PRINT_NEWLINE = &h00000001
const FB_PRINT_PAD     = &h00000002

type ConsoleState
    cp        as CellPlane
    cols      as long
    rows      as long
    fidx      as long          '' font index for the open mode
    fh        as long          '' font height in pixels
    row       as long          '' 0-based cursor
    col       as long
    fg        as ulong
    bg        as ulong
    viewtop   as long          '' VIEW PRINT region, 0-based inclusive
    viewbot   as long
    live      as long
end type

dim shared as ConsoleState TheCon

'' Repaint one cell from the plane. Every write goes through here so the glyph
'' and the cell can never disagree -- SCREEN(r,c) reads the plane, the window
'' shows the glyph, and a program that compares them is entitled to agreement.
private sub ConDrawCell( byval c as long, byval r as long )
    if (c < 0) orelse (r < 0) orelse (c >= TheCon.cols) orelse (r >= TheCon.rows) then exit sub
    dim as CharCell ptr cell = CellAt( TheCon.cp, 0, c, r )
    if cell = 0 then exit sub
    DrawGlyph( ScreenCtx.surf, c * FONT_WIDTH, r * TheCon.fh, _
               cell->ch, TheCon.fidx, cell->fg, cell->bg )
end sub

'' Scroll the VIEW PRINT region up one row, plane and pixels together.
''
'' The pixels are moved rather than redrawn from the plane: a redraw would be
'' correct too and is O(cells) instead of O(bytes), but it would also repaint
'' any pixel a program drew INTO the text area with LINE or PSET, which gfxlib2
'' does not do -- its scroll is a memmove of the framebuffer.
private sub ConScroll( )
    dim as long top = TheCon.viewtop
    dim as long bot = TheCon.viewbot
    if bot <= top then exit sub

    '' cells
    for r as integer = top to bot - 1
        for c as integer = 0 to TheCon.cols - 1
            dim as CharCell ptr dst = CellAt( TheCon.cp, 0, c, r )
            dim as CharCell ptr src = CellAt( TheCon.cp, 0, c, r + 1 )
            if (dst <> 0) andalso (src <> 0) then *dst = *src
        next
    next
    for c as integer = 0 to TheCon.cols - 1
        dim as CharCell ptr dst = CellAt( TheCon.cp, 0, c, bot )
        if dst <> 0 then
            dst->ch = 32
            dst->fg = TheCon.fg
            dst->bg = TheCon.bg
        end if
    next

    '' pixels
    dim as long y0 = top * TheCon.fh
    dim as long y1 = (bot + 1) * TheCon.fh - 1
    dim as long rowbytes = ScreenCtx.surf.w * ScreenCtx.surf.bpp
    for y as integer = y0 to y1 - TheCon.fh
        memcpy( SurfaceRowAddr( ScreenCtx.surf, y ), _
                SurfaceRowAddr( ScreenCtx.surf, y + TheCon.fh ), rowbytes )
    next
    for y as integer = y1 - TheCon.fh + 1 to y1
        memset( SurfaceRowAddr( ScreenCtx.surf, y ), 0, rowbytes )
    next
    DirtyMarkSpan( ScreenCtx.surf, y0, y1 )

    '' the blanked row has to be painted in the CURRENT background, which is not
    '' necessarily 0 -- memset above only clears to black.
    for c as integer = 0 to TheCon.cols - 1
        ConDrawCell( c, bot )
    next
end sub

private sub ConNewline( )
    TheCon.col = 0
    TheCon.row += 1
    if TheCon.row > TheCon.viewbot then
        TheCon.row = TheCon.viewbot
        ConScroll( )
    end if
end sub

'' One character, with the control codes PRINT interprets before the glyph
'' renderer ever sees them. tools/abtest-print.bas excludes 0..31 for exactly
'' this reason: they never reach a glyph.
private sub ConPutChar( byval ch as long )
    select case ch
    case 7          '' bell -- audible only, and this library makes no sound
        exit sub
    case 8          '' backspace
        if TheCon.col > 0 then TheCon.col -= 1
        exit sub
    case 9          '' tab -- to the next eight-column stop
        dim as long n = 8 - (TheCon.col mod 8)
        for i as integer = 1 to n
            ConPutChar( 32 )
        next
        exit sub
    case 10         '' line feed
        ConNewline( )
        exit sub
    case 13         '' carriage return
        TheCon.col = 0
        exit sub
    end select

    if TheCon.col >= TheCon.cols then ConNewline( )

    dim as CharCell ptr cell = CellAt( TheCon.cp, 0, TheCon.col, TheCon.row )
    if cell <> 0 then
        cell->ch = ch and &hFF
        cell->fg = TheCon.fg
        cell->bg = TheCon.bg
    end if
    ConDrawCell( TheCon.col, TheCon.row )
    TheCon.col += 1
end sub

end namespace

'' ---------------------------------------------------------------- the hooks
''
'' extern "c" for the same reason the entry points are: these are called through
'' function pointers the runtime holds, with no name mangling involved, and
'' saying so is clearer than relying on a convention that no longer varies.
extern "c"

sub TkoConPrintBuff cdecl ( byval buffer as const any ptr, _
        byval length as uinteger, byval mask as long )
    if TkoGfx.TheCon.live = 0 then exit sub

    '' SIGNED, and the lint is right to insist. `length` is uinteger, so an empty
    '' buffer makes `length - 1` wrap to the largest uinteger and the loop walks
    '' off the end of memory. PRINT with an empty string is an ordinary thing to
    '' write -- `print ""` and `print ;` both reach here with length 0.
    dim as ubyte ptr p = cptr( ubyte ptr, buffer )
    dim as integer n = cast( integer, length )
    if (p <> 0) andalso (n > 0) then
        for i as integer = 0 to n - 1
            TkoGfx.ConPutChar( p[i] )
        next
    end if

    '' PAD is what `PRINT x,` asks for: advance to the next 14-column zone.
    if (mask and TkoGfx.FB_PRINT_PAD) <> 0 then
        dim as long n = 14 - (TkoGfx.TheCon.col mod 14)
        for i as integer = 1 to n
            TkoGfx.ConPutChar( 32 )
        next
    end if

    if (mask and TkoGfx.FB_PRINT_NEWLINE) <> 0 then TkoGfx.ConNewline( )
end sub

sub TkoConCls cdecl ( byval mode as long )
    if TkoGfx.TheCon.live = 0 then exit sub

    '' Mode 2 is the TEXT VIEW; 0 and 1 clear the graphics viewport, which
    '' raster/cls.bi already does and tools/abtest-cls.bas already gates. Only
    '' the text case belongs here.
    if mode <> 2 then
        dim as single cx, cy
        TkoGfx.ClsAny( TkoGfx.ScreenCtx.surf, TkoGfx.ScreenCtx.vp, mode, _
                       TkoGfx.TheCon.bg, cx, cy )
    end if

    for r as integer = TkoGfx.TheCon.viewtop to TkoGfx.TheCon.viewbot
        for c as integer = 0 to TkoGfx.TheCon.cols - 1
            dim as TkoGfx.CharCell ptr cell = TkoGfx.CellAt( TkoGfx.TheCon.cp, 0, c, r )
            if cell <> 0 then
                cell->ch = 32
                cell->fg = TkoGfx.TheCon.fg
                cell->bg = TkoGfx.TheCon.bg
            end if
        next
    next
    '' CLEARING THE TEXT MEANS ERASING THE GLYPHS, not just the cells. Measured:
    '' gfxlib2's CLS 2 leaves the screen blank, so the cells it blanked are
    '' repainted in their background rather than left showing the old character.
    '' Clearing the plane alone passed every pixel case that did not use CLS 2
    '' and failed exactly that one.
    for r as integer = TkoGfx.TheCon.viewtop to TkoGfx.TheCon.viewbot
        for c as integer = 0 to TkoGfx.TheCon.cols - 1
            TkoGfx.ConDrawCell( c, r )
        next
    next

    TkoGfx.TheCon.row = TkoGfx.TheCon.viewtop
    TkoGfx.TheCon.col = 0
end sub

'' LOCATE row, col, cursor -- 1-based, and 0 means "leave this one alone".
'' Returns the PREVIOUS position packed as (row shl 8) or col, which is the
'' form fbc's own console hook returns.
function TkoConLocate cdecl ( byval row as long, byval col as long, _
        byval cursor as long ) as long
    if TkoGfx.TheCon.live = 0 then return 0
    dim as long prev = ((TkoGfx.TheCon.row + 1) shl 8) or (TkoGfx.TheCon.col + 1)

    if row > 0 then
        dim as long r = row - 1
        if r < TkoGfx.TheCon.viewtop then r = TkoGfx.TheCon.viewtop
        if r > TkoGfx.TheCon.viewbot then r = TkoGfx.TheCon.viewbot
        TkoGfx.TheCon.row = r
    end if
    if col > 0 then
        dim as long c = col - 1
        if c < 0 then c = 0
        if c >= TkoGfx.TheCon.cols then c = TkoGfx.TheCon.cols - 1
        TkoGfx.TheCon.col = c
    end if
    scope : dim as long ignored = cursor : end scope
    return prev
end function

function TkoConGetX cdecl ( ) as long
    if TkoGfx.TheCon.live = 0 then return 1
    return TkoGfx.TheCon.col + 1
end function

function TkoConGetY cdecl ( ) as long
    if TkoGfx.TheCon.live = 0 then return 1
    return TkoGfx.TheCon.row + 1
end function

sub TkoConGetXY cdecl ( byval col as long ptr, byval row as long ptr )
    if col <> 0 then *col = TkoConGetX( )
    if row <> 0 then *row = TkoConGetY( )
end sub

sub TkoConGetSize cdecl ( byval cols as long ptr, byval rows as long ptr )
    if cols <> 0 then *cols = TkoGfx.TheCon.cols
    if rows <> 0 then *rows = TkoGfx.TheCon.rows
end sub

'' SCREEN( row, col [, colorflag] ) -- 1-based, straight out of the cell plane.
'' core/cells.bi does the depth-dependent attribute packing and
'' tools/abtest-cells.bas compares it against gfxlib2.
function TkoConReadXY cdecl ( byval col as long, byval row as long, _
        byval colorflag as long ) as ulong
    if TkoGfx.TheCon.live = 0 then return 0
    return cast( ulong, TkoGfx.CellReadXY( TkoGfx.TheCon.cp, 0, _
                        TkoGfx.ScreenCtx.surf.bpp * 8, col, row, colorflag ) )
end function

'' WIDTH cols, rows -- a QUERY here, never a resize.
''
'' gfxlib2 answers WIDTH on a graphics screen with the geometry the MODE has;
'' changing it would mean reopening the screen at a different character size,
'' which SCREEN is for. The packed return is (rows shl 16) or cols.
function TkoConWidth cdecl ( byval cols as long, byval rows as long ) as long
    if TkoGfx.TheCon.live = 0 then return 0
    scope : dim as long ignored = cols + rows : end scope
    return (TkoGfx.TheCon.rows shl 16) or TkoGfx.TheCon.cols
end function

function TkoConColor cdecl ( byval fc as ulong, byval bc as ulong, _
        byval flags as long ) as ulong
    if TkoGfx.TheCon.live = 0 then return 0

    '' raster/color.bi owns the legacy rules and their depth dependence, and
    '' tools/abtest-color.bas compares them against gfxlib2. This only mirrors
    '' the result into the text attributes so the next PRINT uses it.
    dim as ulong prev = TkoGfx.Color32( TkoGfx.ScreenCtx.draw, _
                            TkoGfx.ScreenCtx.surf.bpp * 8, fc, bc, flags )
    TkoGfx.TheCon.fg = TkoGfx.ScreenCtx.draw.fg_color
    TkoGfx.TheCon.bg = TkoGfx.ScreenCtx.draw.bg_color
    return prev
end function

'' ONE PAGE, so both of these answer for one page rather than refusing.
'' core/cells.bi's CellPageSetResult is the packing gfxlib2 returns, and
'' tools/abtest-cells.bas asserts it -- SCREENSET is a statement and discards
'' the value, so it is not comparable any other way.
function TkoConPageCopy cdecl ( byval src as long, byval dst as long ) as long
    if TkoGfx.TheCon.live = 0 then return 0
    if (src = dst) then return 0
    return 0
end function

function TkoConPageSet cdecl ( byval active as long, byval visible as long ) as long
    if TkoGfx.TheCon.live = 0 then return 0
    return TkoGfx.CellPageSetResult( iif( active < 0, 0, active ), _
                                     iif( visible < 0, 0, visible ) )
end function

end extern

namespace TkoGfx

declare sub ConsoleShutdownIfLive( )

'' Build the console for the mode that is open and install the table. Called by
'' SCREEN; the matching teardown is ConsoleShutdown.
private sub ConsoleStart( byval mode as long )
    ConsoleShutdownIfLive( )

    dim as long fidx = FontIndexForMode( mode )
    if fidx < 0 then fidx = 0
    TheCon.fidx = fidx
    TheCon.fh   = FontHeight(fidx)
    TheCon.cols = ScreenCtx.surf.w \ FONT_WIDTH
    TheCon.rows = ScreenCtx.surf.h \ TheCon.fh
    if (TheCon.cols <= 0) orelse (TheCon.rows <= 0) then exit sub

    TheCon.fg = ScreenCtx.draw.fg_color
    TheCon.bg = ScreenCtx.draw.bg_color
    TheCon.row = 0
    TheCon.col = 0
    TheCon.viewtop = 0
    TheCon.viewbot = TheCon.rows - 1

    if CellsReset( TheCon.cp, TheCon.cols, TheCon.rows, 1, 0, _
                   TheCon.fg, TheCon.bg ) = 0 then exit sub

    dim as TkoAbi.FB_HOOKSTB tb
    tb.clsproc        = @TkoConCls
    tb.colorproc      = @TkoConColor
    tb.locateproc     = @TkoConLocate
    tb.widthproc      = @TkoConWidth
    tb.getxproc       = @TkoConGetX
    tb.getyproc       = @TkoConGetY
    tb.getxyproc      = @TkoConGetXY
    tb.getsizeproc    = @TkoConGetSize
    tb.printbuffproc  = @TkoConPrintBuff
    tb.readxyproc     = @TkoConReadXY
    tb.pagecopyproc   = @TkoConPageCopy
    tb.pagesetproc    = @TkoConPageSet

    HooksInstall( @tb )
    TheCon.live = 1
end sub

private sub ConsoleShutdownIfLive( )
    if TheCon.live = 0 then exit sub
    HooksClear( )
    CellsFree( TheCon.cp )
    TheCon.live = 0
end sub

end namespace
