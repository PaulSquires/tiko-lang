'' fb/tuibuffer.bi -- the cell buffer, the frame, and the diff
''
''     dim as TuiScreen scr
''     scr.Resize( 80, 24 )
''     dim as TuiFrame ptr f = scr.BeginFrame( )
''     f->DrawText( 2, 1, "hello", st )
''     term.Write( scr.Render( depth ) )
''     term.Flush( )
''
'' RFC-0003 -- C:\dev\docs\tui\RFC-0003-buffer-and-renderer.md.
''
'' Depends on tuicore.bi only. Does NO I/O itself: Render( ) returns the byte
'' string, and tuiterm.bi writes it.
''
'' ---------------------------------------------------------------------------
'' DRAWING NEVER FAILS
''
'' There is no Result anywhere in this file. Writing outside the clip rectangle
'' is DROPPED SILENTLY; a widget handed a zero-width area draws nothing and that
'' is correct behaviour, not an error to report. A Result on the single hottest,
'' most-repeated call in the library would be ignored at every call site, and an
'' ignored Result is worse than an honest sub. rationale.md section 5.

#pragma once

#include once "fb/tuicore.bi"
#include once "fb/tuiwidth.bi"
#include once "fb/array.bi"

namespace FB

'' ============================================================== width
''
'' The phase-1 placeholder that lived here -- a handful of hand-written
'' double-width ranges -- is gone. TuiCharWidth, TuiDecodeAt and TuiStringWidth
'' now come from fb/tuiwidth.bi, over the full East-Asian-Width table generated
'' from the UCD. RFC-0005.

'' ============================================================== the cell

'' ustring * 4 HOLDS THREE CODE UNITS, NOT FOUR -- it is NUL-terminated, so
'' capacity is N-1. Measured: ustring * 3 holds 2, ustring * 4 holds 3. Three
'' units is a surrogate pair plus one combining mark, which is the documented
'' limit of what one cell represents.
''
'' The alternative was a var-len ustring field: it works, but sizeof rises to 40
'' AND every cell costs a heap allocation -- 153,600 bytes and 1,920 allocations
'' for an 80x24 double buffer. Rejected on that measurement. The shipped shape
'' measures sizeof( TuiCell ) = 22.
''
'' width = 0 marks a CONTINUATION CELL: the right half of a wide glyph. Its text
'' is empty and the renderer skips it, because the terminal already advanced two
'' columns when it drew the left half.
type TuiCell
	as ustring * 4 text
	as TuiStyle st
	as ubyte width

	declare sub SetChar( byval cp as ulong )
	declare function Equals( byval o as TuiCell ) as boolean
end type

private sub TuiCell.SetChar( byval cp as ulong )
	if( cp < &h10000 ) then
		text = " "
		text[0] = cast( ushort, cp )
	else
		'' Direct code-unit assignment -- see TuiDecodeAt above.
		text = "  "
		dim as ulong v = cp - &h10000
		text[0] = cast( ushort, &hD800 + ( v shr 10 ) )
		text[1] = cast( ushort, &hDC00 + ( v and &h3FF ) )
	end if
	width = cast( ubyte, TuiCharWidth( cp ) )
end sub

private function TuiCell.Equals( byval o as TuiCell ) as boolean
	if( width <> o.width ) then return FALSE
	if( st.Equals( o.st ) = FALSE ) then return FALSE
	return ( text = o.text )
end function

private function TuiCellBlank( byval st as TuiStyle ) as TuiCell
	dim as TuiCell c
	c.text = " "
	c.st = st
	c.width = 1
	return c
end function

'' The alias is REQUIRED -- a generic does not instantiate directly in a TYPE
'' field. docs/logging hit the same rule with LogFieldArray.
type TuiCellArray as Array( of TuiCell )

'' ============================================================== the buffer

'' Row-major, index y * cols + x. A flat Array and not an array of rows, because
'' the diff walks it linearly and because Array's deep copy on assignment is
'' then one operation -- which is what makes the front/back swap correct.
type TuiBuffer
	as TuiCellArray cells
	as long cols, rows

	declare sub Resize( byval c as long, byval r as long )
	declare sub Clear( byval st as TuiStyle )
	declare function InBounds( byval x as long, byval y as long ) as boolean
	declare function At( byval x as long, byval y as long ) as TuiCell ptr
	declare function Count( ) as long
end type

'' RESIZE DISCARDS CONTENTS. A resize is followed by a full repaint anyway, so
'' preserving cells would be work whose result is immediately overwritten.
private sub TuiBuffer.Resize( byval c as long, byval r as long )
	cols = iif( c > 0, c, 0 )
	rows = iif( r > 0, r, 0 )
	dim as long n = cols * rows

	cells.Clear( )
	if( n <= 0 ) then exit sub
	cells.Reserve( n )
	dim as TuiCell blank = TuiCellBlank( TuiStyleDefault( ) )
	for i as long = 0 to n - 1
		cells.Push( blank )
	next
end sub

private sub TuiBuffer.Clear( byval st as TuiStyle )
	dim as TuiCell blank = TuiCellBlank( st )
	dim as long n = cols * rows
	for i as long = 0 to n - 1
		cells[i] = blank
	next
end sub

private function TuiBuffer.InBounds( byval x as long, byval y as long ) as boolean
	if( x < 0 ) then return FALSE
	if( y < 0 ) then return FALSE
	if( x >= cols ) then return FALSE
	if( y >= rows ) then return FALSE
	return TRUE
end function

'' Returns a POINTER, not a byref. `@buf.At( x, y )` on a byref-returning
'' function does not yield the cell's address -- it yields the PROCEDURE's
'' address, silently, with no diagnostic. Measured during phase 1; the same
'' wart forced tuiterm.bi's TuiSaved( ) to return a pointer.
private function TuiBuffer.At( byval x as long, byval y as long ) as TuiCell ptr
	if( InBounds( x, y ) = FALSE ) then return 0
	return @cells[ y * cols + x ]
end function

private function TuiBuffer.Count( ) as long
	return cols * rows
end function

'' ============================================================== the frame

const TUI_MAX_LAYERS = 8

type TuiFrame
	declare sub Attach( byval b as TuiBuffer ptr )

	declare function Area( ) as TuiRect
	declare function Clip( ) as TuiRect

	declare sub SetCell( byval x as long, byval y as long, _
	                     byref ch as ustring, byval st as TuiStyle )
	declare function DrawText( byval x as long, byval y as long, _
	                           byref s as ustring, byval st as TuiStyle ) as long
	declare sub FillRect( byval r as TuiRect, byref ch as ustring, byval st as TuiStyle )
	declare sub BlendStyle( byval r as TuiRect, byval over as TuiStyle )

	declare function PushClip( byval r as TuiRect ) as TuiRect
	declare sub PopClip( byval saved as TuiRect )

	declare sub PushLayer( byval r as TuiRect )
	declare sub PopLayer( )

	declare sub SetCursor( byval x as long, byval y as long )
	declare sub HideCursor( )
	declare function CursorVisible( ) as boolean
	declare function CursorPos( ) as TuiPos

	private:
		as TuiBuffer ptr m_buf
		as TuiRect m_clip
		as long m_layers
		as TuiRect m_layerRect( 0 to TUI_MAX_LAYERS-1 )
		as boolean m_cursorOn
		as TuiPos m_cursor

		declare sub hBlankAt( byval x as long, byval y as long, byval st as TuiStyle )
end type

private sub TuiFrame.Attach( byval b as TuiBuffer ptr )
	m_buf = b
	m_clip = TuiRectOf( 0, 0, b->cols, b->rows )
	m_layers = 0
	m_cursorOn = FALSE
	m_cursor = type( 0, 0 )
end sub

private function TuiFrame.Area( ) as TuiRect
	if( m_buf = 0 ) then return TuiRectOf( 0, 0, 0, 0 )
	return TuiRectOf( 0, 0, m_buf->cols, m_buf->rows )
end function

private function TuiFrame.Clip( ) as TuiRect
	return m_clip
end function

'' PushClip INTERSECTS with the current clip rather than replacing it, so a
'' child can never widen its parent's clip. That property is what makes it safe
'' to hand a TuiFrame to arbitrary widget code.
private function TuiFrame.PushClip( byval r as TuiRect ) as TuiRect
	dim as TuiRect saved = m_clip
	m_clip = m_clip.Intersect( r )
	return saved
end function

private sub TuiFrame.PopClip( byval saved as TuiRect )
	m_clip = saved
end sub

'' Layers exist for popups and modals: content underneath must be intact when
'' the overlay is dismissed. The composited result IS the frame, and the whole
'' frame is diffed as one image regardless of how many layers built it.
''
'' Nesting is bounded at TUI_MAX_LAYERS. A further PushLayer is a NO-OP that
'' draws into the current layer, because a runaway layer stack is a bug and
'' silently growing memory in a render loop is a worse outcome than a visibly
'' wrong popup.
private sub TuiFrame.PushLayer( byval r as TuiRect )
	if( m_layers >= TUI_MAX_LAYERS ) then exit sub
	m_layerRect( m_layers ) = m_clip
	m_layers += 1
	m_clip = m_clip.Intersect( r )
end sub

private sub TuiFrame.PopLayer( )
	if( m_layers <= 0 ) then exit sub
	m_layers -= 1
	m_clip = m_layerRect( m_layers )
end sub

'' Blanks a cell without disturbing anything else. Used to repair the other half
'' of a wide glyph that is being partially overwritten.
private sub TuiFrame.hBlankAt( byval x as long, byval y as long, byval st as TuiStyle )
	dim as TuiCell ptr c = m_buf->At( x, y )
	if( c = 0 ) then exit sub
	c->text = " "
	c->st = st
	c->width = 1
end sub

private sub TuiFrame.SetCell( byval x as long, byval y as long, _
                              byref ch as ustring, byval st as TuiStyle )
	if( m_buf = 0 ) then exit sub
	if( m_clip.Contains( x, y ) = FALSE ) then exit sub

	dim as long adv = 0
	dim as ulong cp = TuiDecodeAt( ch, 0, adv )
	dim as long w = TuiCharWidth( cp )

	'' A two-column glyph whose second column falls outside the clip is NOT
	'' drawn at all -- half a glyph is not a glyph. A space goes in instead.
	if( ( w = 2 ) andalso ( m_clip.Contains( x + 1, y ) = FALSE ) ) then
		hBlankAt( x, y, st )
		exit sub
	end if

	'' Overwriting either half of an existing wide glyph must repair the other
	'' half, or the terminal is told to draw a stale partner.
	dim as TuiCell ptr cur = m_buf->At( x, y )
	if( cur = 0 ) then exit sub
	if( cur->width = 2 ) then hBlankAt( x + 1, y, cur->st )
	if( cur->width = 0 ) then hBlankAt( x - 1, y, cur->st )

	cur->SetChar( cp )
	cur->st = st

	if( w = 2 ) then
		dim as TuiCell ptr nxt = m_buf->At( x + 1, y )
		if( nxt <> 0 ) then
			'' repair anything the continuation cell is itself clobbering
			if( nxt->width = 2 ) then hBlankAt( x + 2, y, nxt->st )
			nxt->text = ""
			nxt->st = st
			nxt->width = 0
		end if
	end if
end sub

'' Returns the number of COLUMNS written -- needed for cursor placement and for
'' laying the next run. It is not an error code, and callers routinely ignore it.
private function TuiFrame.DrawText( byval x as long, byval y as long, _
                                    byref s as ustring, byval st as TuiStyle ) as long
	if( m_buf = 0 ) then return 0

	dim as long cx = x, i = 0, adv = 0, written = 0
	while( i < len( s ) )
		dim as ulong cp = TuiDecodeAt( s, i, adv )
		dim as long w = TuiCharWidth( cp )
		if( w = 0 ) then
			i += adv
			continue while
		end if
		if( cx >= m_clip.Right( ) ) then exit while

		dim as ustring one
		if( adv = 2 ) then
			one = "  "
			one[0] = s[i]
			one[1] = s[i+1]
		else
			one = " "
			one[0] = s[i]
		end if

		'' Count only what was ACTUALLY written. A run starting left of the
		'' clip advances cx without writing, and reporting those columns
		'' would make the caller lay the next run in the wrong place.
		if( m_clip.Contains( cx, y ) ) then written += w
		SetCell( cx, y, one, st )
		cx += w
		i += adv
	wend
	return written
end function

private sub TuiFrame.FillRect( byval r as TuiRect, byref ch as ustring, byval st as TuiStyle )
	if( m_buf = 0 ) then exit sub
	dim as TuiRect a = r.Intersect( m_clip )
	if( a.IsEmpty( ) ) then exit sub

	for yy as long = a.y to a.Bottom( ) - 1
		for xx as long = a.x to a.Right( ) - 1
			SetCell( xx, yy, ch, st )
		next
	next
end sub

'' Patches the style of every cell in r, leaving the text alone. This is what
'' "dim the background behind a modal" is.
private sub TuiFrame.BlendStyle( byval r as TuiRect, byval over as TuiStyle )
	if( m_buf = 0 ) then exit sub
	dim as TuiRect a = r.Intersect( m_clip )
	if( a.IsEmpty( ) ) then exit sub

	for yy as long = a.y to a.Bottom( ) - 1
		for xx as long = a.x to a.Right( ) - 1
			dim as TuiCell ptr c = m_buf->At( xx, yy )
			if( c <> 0 ) then c->st = c->st.Patch( over )
		next
	next
end sub

'' The rendered cursor position is a property of the FRAME, set by whichever
'' widget has focus, because only that widget knows where its cursor is. A frame
'' where nobody called SetCursor leaves the cursor hidden.
private sub TuiFrame.SetCursor( byval x as long, byval y as long )
	m_cursorOn = TRUE
	m_cursor.x = x
	m_cursor.y = y
end sub

private sub TuiFrame.HideCursor( )
	m_cursorOn = FALSE
end sub

private function TuiFrame.CursorVisible( ) as boolean
	return m_cursorOn
end function

private function TuiFrame.CursorPos( ) as TuiPos
	return m_cursor
end function

'' ============================================================== the screen

'' Owns the front buffer (what the terminal is believed to show) and the back
'' buffer (what was just rendered), and turns the difference into bytes.
type TuiScreen
	declare constructor( )

	declare sub Resize( byval ncols as long, byval nrows as long )
	declare function BeginFrame( ) as TuiFrame ptr
	declare function Render( byval depth as TuiColorDepth ) as string
	declare sub Invalidate( )

	declare function Cols( ) as long
	declare function Rows( ) as long
	declare function Back( ) as TuiBuffer ptr
	declare function Front( ) as TuiBuffer ptr

	private:
		as TuiBuffer m_front, m_back
		as TuiFrame m_frame
		as boolean m_invalid

		'' THE TERMINAL'S SGR STATE, CARRIED ACROSS FRAMES.
		''
		'' Render emits only the DIFFERENCE from the style the terminal is
		'' already in. That state does not end at a frame boundary: a frame
		'' whose last emitted run was a reversed table row leaves the terminal
		'' reversed, and the next frame's first run inherits it.
		''
		'' Tracking it only within a frame was a real bug: moving a list
		'' selection down redrew the DESELECTED row with no SGR at all --
		'' because its style equalled the renderer's assumed default -- so the
		'' row kept the highlight it had just lost.
		as TuiStyle m_curStyle
		as boolean m_styleKnown
end type

private constructor TuiScreen( )
	m_invalid = TRUE
	m_styleKnown = FALSE
end constructor

'' The parameters are ncols/nrows, not cols/rows: FreeBASIC identifiers are
'' case-insensitive, so a parameter named `cols` collides with the member
'' Cols( ) and fails with `error 4: Duplicated definition`.
private sub TuiScreen.Resize( byval ncols as long, byval nrows as long )
	m_front.Resize( ncols, nrows )
	m_back.Resize( ncols, nrows )
	m_invalid = TRUE
end sub

private function TuiScreen.Cols( ) as long : return m_back.cols : end function
private function TuiScreen.Rows( ) as long : return m_back.rows : end function
private function TuiScreen.Back( ) as TuiBuffer ptr : return @m_back : end function
private function TuiScreen.Front( ) as TuiBuffer ptr : return @m_front : end function

'' Clears the back buffer and hands out a frame pointed at it. Widgets draw into
'' the frame; Render( ) then diffs back against front.
private function TuiScreen.BeginFrame( ) as TuiFrame ptr
	m_back.Clear( TuiStyleDefault( ) )
	m_frame.Attach( @m_back )
	return @m_frame
end function

'' Forces the next Render to emit everything. Required after a resize, after
'' Enter, and after any external write to the terminal.
'' Also forgets the terminal's SGR state: an invalidated frame emits its own
'' reset, and anything that invalidated us may have written to the terminal.
private sub TuiScreen.Invalidate( )
	m_invalid = TRUE
	m_styleKnown = FALSE
end sub

'' The cost of a cursor move, used to decide whether re-emitting a short run of
'' MATCHING cells is cheaper than jumping over them. ESC [ r ; c H is 6 bytes at
'' one-digit coordinates and up to 10 at three-digit ones; 7 is the honest
'' middle and it is computed from the actual coordinates below rather than
'' guessed.
private function TuiMoveCost( byval x as long, byval y as long ) as long
	return 4 + len( str( y + 1 ) ) + len( str( x + 1 ) )
end function

private function TuiScreen.Render( byval depth as TuiColorDepth ) as string
	dim as string out
	dim as long nc = m_back.cols, nr = m_back.rows
	if( ( nc <= 0 ) orelse ( nr <= 0 ) ) then return ""

	'' The style the terminal is currently in. Carried ACROSS runs and across
	'' rows, not reset per cell -- this is where most of the byte reduction
	'' comes from, more than from the cell comparison itself.
	'' Resume from whatever state the LAST frame left the terminal in.
	dim as TuiStyle curStyle = m_curStyle
	dim as boolean styleKnown = m_styleKnown
	dim as long curX = -1, curY = -1

	if( m_invalid ) then
		out &= chr( 27 ) & "[2J"
		out &= chr( 27 ) & "[0m"
		curStyle = TuiStyleDefault( )
		styleKnown = TRUE
		curX = -1 : curY = -1
	end if

	for y as long = 0 to nr - 1
		dim as long x = 0
		while( x < nc )
			dim as long idx = y * nc + x

			'' A continuation cell is never emitted on its own: the terminal
			'' advanced two columns when it drew the left half.
			if( m_back.cells[idx].width = 0 ) then
				x += 1
				continue while
			end if

			dim as boolean differs = m_invalid orelse _
			                         ( m_back.cells[idx].Equals( m_front.cells[idx] ) = FALSE )
			if( differs = FALSE ) then
				x += 1
				continue while
			end if

			'' Extend the run. Keep going while cells differ, and jump a gap of
			'' MATCHING cells when re-emitting them is cheaper than a move.
			dim as long runStart = x
			dim as long runEnd = x        '' exclusive
			dim as long probe = x
			while( probe < nc )
				dim as long pidx = y * nc + probe
				dim as boolean pdiff = m_invalid orelse _
				                       ( m_back.cells[pidx].Equals( m_front.cells[pidx] ) = FALSE )
				if( pdiff ) then
					probe += iif( m_back.cells[pidx].width = 2, 2, 1 )
					runEnd = probe
					continue while
				end if

				'' count the matching gap
				dim as long gap = 0
				dim as long q = probe
				while( q < nc )
					dim as long qidx = y * nc + q
					dim as boolean qdiff = m_invalid orelse _
					                       ( m_back.cells[qidx].Equals( m_front.cells[qidx] ) = FALSE )
					if( qdiff ) then exit while
					gap += 1
					q += 1
				wend
				if( q >= nc ) then exit while
				if( gap >= TuiMoveCost( q, y ) ) then exit while
				probe = q
			wend

			if( curX <> runStart orelse curY <> y ) then
				out &= chr( 27 ) & "[" & str( y + 1 ) & ";" & str( runStart + 1 ) & "H"
				curX = runStart : curY = y
			end if

			dim as long cx = runStart
			while( cx < runEnd )
				dim as long cidx = y * nc + cx
				if( m_back.cells[cidx].width = 0 ) then
					cx += 1
					continue while
				end if

				if( ( styleKnown = FALSE ) orelse _
				    ( curStyle.Equals( m_back.cells[cidx].st ) = FALSE ) ) then
					out &= TuiSgr( curStyle, m_back.cells[cidx].st, depth )
					curStyle = m_back.cells[cidx].st
					styleKnown = TRUE
				end if

				dim as ustring t = m_back.cells[cidx].text
				dim as string u8 = t
				out &= u8

				dim as long w = iif( m_back.cells[cidx].width = 2, 2, 1 )
				cx += w
				curX += w
			wend

			x = runEnd
		wend
	next

	'' The final cursor move, after the diff.
	if( m_frame.CursorVisible( ) ) then
		dim as TuiPos p = m_frame.CursorPos( )
		out &= chr( 27 ) & "[" & str( p.y + 1 ) & ";" & str( p.x + 1 ) & "H"
		out &= chr( 27 ) & "[?25h"
	elseif( len( out ) > 0 ) then
		out &= chr( 27 ) & "[?25l"
	end if

	'' Carry the SGR state into the next frame, so its first run emits only
	'' what actually differs -- and, crucially, DOES emit when the terminal is
	'' still in a style this frame left behind.
	m_curStyle = curStyle
	m_styleKnown = styleKnown

	'' Swap. Array's deep copy on assignment is what makes this correct.
	m_front = m_back
	m_invalid = FALSE
	return out
end function

end namespace
