'' conattr.bas -- LOCATE, COLOR, CLS, the VIEW PRINT window and console
'' scrolling. Twelve symbols on Windows and eight on POSIX, across six fbc
'' members.
''
'' ONLY THREE OF THESE ARE FBCALL, AND THE win32 ARCHIVE IS WHAT SAYS SO:
''
''     _fb_ConsoleLocateRaw@12   _fb_ConsoleView@8
''
'' -- plus nothing else. `_fb_ConsoleLocate`, `_fb_ConsoleColor`,
'' `_fb_ConsoleClear`, `_fb_ConsoleScroll`, `_fb_ConsoleViewEx` and the rest all
'' appear UNDECORATED and are plain cdecl. Note how little pattern there is:
'' `fb_ConsoleLocateRaw` is FBCALL and `fb_ConsoleLocateRawEx`, one line away in
'' the same file, is not. Only the archive settles it.
''
'' THE COLOUR STATE LIVES IN A DIFFERENT PLACE ON EACH PLATFORM, and that is the
'' asymmetry that shapes this file. Windows hands the attribute to the console
'' and asks for it back, so the runtime keeps only the two FB colour INDICES in
'' file-scope statics -- it cannot recover an index from an attribute, because
'' the mapping is not onto. POSIX keeps both indices in __fb_con and emits a
'' termcap sequence, and it has to know whether the terminal can do sixteen
'' background colours: a real console and a non-xterm get the 8+8 sequences,
'' xterm gets the extended ones.
''
'' CLS IS THREE DIFFERENT OPERATIONS SELECTED BY ONE ARGUMENT:
''
''   mode 1                     do nothing -- it is the graphics-viewport clear,
''                              and there is no graphics viewport here
''   mode 2, or &hFFFF0000      clear the VIEW PRINT region only
''   anything else              clear the whole window
''
'' &hFFFF0000 is gfxlib's DEFAULT_COLOR arriving where a mode was expected, and
'' it is accepted as a synonym for 2 rather than falling into the default case.
'' Reproduced, because a program that passes it is relying on it.
''
'' THE VIEW PRINT VALIDATION REJECTS BY ZEROING BOTH ROWS, not by returning an
'' error: an out-of-range VIEW PRINT leaves the window untouched and returns 0,
'' which is how a caller distinguishes it from a successful call that always
'' returns a non-zero packed pair.

#include once "inc/descriptors.bi"
#include once "inc/console.bi"
#include once "crt/string.bi"

'' Owned by tiko-rt already, in io/viewhlp.bas.
extern "c"   '' NON-FBCALL: undecorated in fbc's win32 archive.
	declare sub tkrt_ConsoleGetView alias "fb_ConsoleGetView" ( byval top_ as long ptr, byval bot as long ptr )
	declare function tkrt_ConsoleGetTopRow alias "fb_ConsoleGetTopRow" ( ) as long
	declare function tkrt_ConsoleGetBotRow alias "fb_ConsoleGetBotRow" ( ) as long
	declare sub tkrt_ConsoleSetTopBotRows alias "fb_ConsoleSetTopBotRows" ( byval t as long, byval b as long )
end extern


'' Owned by tiko-rt already, in io/conquery.bas. Declared with the SAME
'' convention each one actually has -- the four FBCALL ones and the rest cdecl.
extern "c"   '' NON-FBCALL: undecorated in fbc's win32 archive.
	declare function tkrt_ConsoleGetX alias "fb_ConsoleGetX" ( ) as long
	declare function tkrt_ConsoleGetY alias "fb_ConsoleGetY" ( ) as long
	declare function tkrt_ConsoleGetMaxRow alias "fb_ConsoleGetMaxRow" ( ) as long
#if defined( __FB_WIN32__ ) or defined( __FB_WIN64__ )
	declare function tkrt_ConsoleGetRawXEx alias "fb_ConsoleGetRawXEx" ( byval h as any ptr ) as long
	declare function tkrt_ConsoleGetRawYEx alias "fb_ConsoleGetRawYEx" ( byval h as any ptr ) as long
#endif
end extern

extern "rtlib"
	declare sub tkrt_ConsoleGetXY alias "fb_ConsoleGetXY" ( byval c as long ptr, byval r as long ptr )
	declare sub tkrt_ConsoleGetSize alias "fb_ConsoleGetSize" ( byval c as long ptr, byval r as long ptr )
	declare sub tkrt_ViewUpdate alias "fb_ViewUpdate" ( )
	declare sub tkrt_GetSize alias "fb_GetSize" ( byval cols as long ptr, byval rows as long ptr )
	declare function tkrt_Locate alias "fb_Locate" _
		( byval row as long, byval col as long, byval cursor as long, _
		  byval page as long, byval isperm as long ) as long
end extern

#if defined( __FB_WIN32__ ) or defined( __FB_WIN64__ )

'' ---------------------------------------------------------- Windows backend

extern "c"   '' NON-FBCALL: kernel32 imports, not rtlib entry points.
	declare function w_FillConsoleOutputAttribute stdcall alias "FillConsoleOutputAttribute" _
		( byval h as any ptr, byval attr as ushort, byval n as ulong, byval c as ulong, byval got as ulong ptr ) as long
	declare function w_FillConsoleOutputCharacterA stdcall alias "FillConsoleOutputCharacterA" _
		( byval h as any ptr, byval ch as ubyte, byval n as ulong, byval c as ulong, byval got as ulong ptr ) as long
	declare function w_ScrollConsoleScreenBufferA stdcall alias "ScrollConsoleScreenBufferA" _
		( byval h as any ptr, byval scroll_ as any ptr, byval clip as any ptr, _
		  byval dest as ulong, byval fill as any ptr ) as long
end extern

'' FOREGROUND_BLUE is 1, _GREEN 2, _RED 4 and _INTENSITY 8 -- which is exactly
'' FreeBASIC's own colour index, so this table IS THE IDENTITY. It is written out
'' rather than dropped because that coincidence is a property of the two
'' numberings and not a guarantee: the POSIX half of this file needs a real
'' permutation for the same operation, and a reader who deleted this would have
'' to rediscover why one platform needs one and the other does not.
dim shared as ushort tkort_colorlut( 0 to 15 ) = { _
	0, 1, 2, 3, 4, 5, 6, 7, _
	8, 9, 10, 11, 12, 13, 14, 15 }

'' The last colours SET, not the last colours the console reports. An attribute
'' cannot be turned back into an index -- the mapping is many-to-one once the
'' console has been touched by anything else -- so COLOR's return value comes
'' from here.
dim shared as ulong tkort_last_bc = 0        '' FB_COLOR_BLACK
dim shared as ulong tkort_last_fc = 7        '' FB_COLOR_WHITE

extern "c"   '' NON-FBCALL: undecorated in fbc's win32 archive.

function tkort_ConsoleGetColorAttEx alias "fb_ConsoleGetColorAttEx" ( byval h as any ptr ) as ulong
	dim as ubyte info( 0 to CSBI_SIZE_ - 1 ) = any
	'' 7 is white-on-black, the attribute a console starts with, and the only
	'' sensible answer when the handle is not a console at all.
	if( w_GetConsoleScreenBufferInfo( h, @info(0) ) = 0 ) then return 7
	return *cptr( ushort ptr, @info(CSBI_ATTRIBUTES_) )
end function

function tkort_ConsoleGetColorAtt alias "fb_ConsoleGetColorAtt" ( ) as ulong
	return tkort_ConsoleGetColorAttEx( TKORT_OUT_HANDLE() )
end function

function tkort_ConsoleColor alias "fb_ConsoleColor" _
	( byval fc as ulong, byval bc as ulong, byval flags as long ) as ulong

	'' The PREVIOUS pair, packed fg | (bg << 16), captured before anything
	'' changes -- COLOR returns what it replaced.
	dim as ulong cur = tkort_last_fc or (tkort_last_bc shl 16)

	if( (flags and FB_COLOR_FG_DEFAULT) = 0 ) then
		tkort_last_fc = fc and &hF
		fc = tkort_colorlut(tkort_last_fc)
	else
		fc = tkort_last_fc
	end if

	if( (flags and FB_COLOR_BG_DEFAULT) = 0 ) then
		tkort_last_bc = bc and &hF
		bc = tkort_colorlut(tkort_last_bc)
	else
		bc = tkort_last_bc
	end if

	w_SetConsoleTextAttribute( TKORT_OUT_HANDLE(), cast( ushort, fc + (bc shl 4) ) )

	return cur
end function

'' Raw: CONSOLE coordinates, 0-based, no VIEW PRINT translation.
'' A NEGATIVE row or column means "leave it alone", and a negative cursor means
'' "leave the cursor visibility alone" -- three independent optional arguments in
'' one call, which is why none of them can use 0 as the sentinel.
sub tkort_ConsoleLocateRawEx alias "fb_ConsoleLocateRawEx" _
	( byval h as any ptr, byval row as long, byval col as long, byval cursor as long )

	'' Zeroed for the same reason as fb_ConsoleLocate -- see there.
	dim as ubyte info( 0 to CCI_SIZE_ - 1 )

	if( col < 0 ) then col = tkrt_ConsoleGetRawXEx( h )
	if( row < 0 ) then row = tkrt_ConsoleGetRawYEx( h )

	if( cursor >= 0 ) then
		'' READ FROM THE PROCESS'S OWN OUTPUT HANDLE, not from `h`. That is what
		'' fbc does -- the size field comes from the standard console and only
		'' the visibility is applied to `h` -- and it matters when `h` is a
		'' second page buffer with a different cursor size.
		w_GetConsoleCursorInfo( TKORT_OUT_HANDLE(), @info(0) )
		*cptr( long ptr, @info(CCI_VISIBLE_) ) = iif( cursor <> 0, 1, 0 )
		w_SetConsoleCursorInfo( h, @info(0) )
	end if

	TKORT_CON_SCROLLOFF() = 0

	w_SetConsoleCursorPosition( h, TKORT_COORD( col, row ) )
end sub

end extern

extern "rtlib"

sub tkort_ConsoleLocateRaw alias "fb_ConsoleLocateRaw" _
	( byval row as long, byval col as long, byval cursor as long )
	tkort_ConsoleLocateRawEx( TKORT_OUT_HANDLE(), row, col, cursor )
end sub

end extern

extern "c"   '' NON-FBCALL: undecorated in fbc's win32 archive.

'' PROGRAM coordinates, 1-based, translated through the VIEW PRINT window.
'' The return value packs the PREVIOUS position and cursor visibility:
''     col | (row << 8) | (visible ? 0x10000 : 0)
function tkort_ConsoleLocate alias "fb_ConsoleLocate" _
	( byval row as long, byval col as long, byval cursor as long ) as long

	'' ZEROED, like the query buffers in io/conquery.bas: on a REDIRECTED handle
	'' GetConsoleCursorInfo FAILS and leaves the buffer untouched, and fbc then
	'' reads an uninitialised local -- its "cursor visible" bit is whatever was on
	'' its stack. Zeroing makes tiko-rt's answer DEFINED. It cannot make it EQUAL
	'' to fbc's, because fbc's is not a value, so conattr-parity asserts the bit
	'' is in range rather than asserting which way it fell.
	dim as ubyte info( 0 to CCI_SIZE_ - 1 )
	dim as long ret_val = any
	dim as long c = any, r = any

	if( col < 1 ) then col = tkrt_ConsoleGetX( )
	if( row < 1 ) then row = tkrt_ConsoleGetY( )

	w_GetConsoleCursorInfo( TKORT_OUT_HANDLE(), @info(0) )
	ret_val = (col and &hFF) or ((row and &hFF) shl 8) or _
	          iif( *cptr( long ptr, @info(CCI_VISIBLE_) ) <> 0, &h10000, 0 )

	c = col : r = row
	tkrt_hConvertToConsole( @c, @r, 0, 0 )

	tkort_ConsoleLocateRawEx( TKORT_OUT_HANDLE(), r, c, cursor )

	return ret_val
end function

'' Fills a rectangle with spaces in the CURRENT attribute, one row at a time --
'' FillConsoleOutput* takes a start coordinate and a run length, not a rect, so a
'' rectangle is one call pair per row.
sub tkort_ConsoleClearViewRawEx alias "fb_ConsoleClearViewRawEx" _
	( byval h as any ptr, byval x1 as long, byval y1 as long, byval x2 as long, byval y2 as long )

	dim as ushort attr = cast( ushort, tkort_ConsoleGetColorAttEx( h ) )
	dim as long width_ = x2 - x1 + 1, lines_ = y2 - y1 + 1
	dim as ulong written = any

	if( (width_ = 0) orelse (lines_ = 0) ) then exit sub

	while( lines_ > 0 )
		lines_ -= 1
		'' The ATTRIBUTE first and then the character, matching fbc: a console
		'' that is being watched sees the colour change before the blanking.
		w_FillConsoleOutputAttribute( h, attr, width_, TKORT_COORD( x1, y1 + lines_ ), @written )
		w_FillConsoleOutputCharacterA( h, 32, width_, TKORT_COORD( x1, y1 + lines_ ), @written )
	wend

	'' -1 for the cursor: the visibility is NOT touched by a clear.
	tkort_ConsoleLocateRawEx( h, y1, x1, -1 )
end sub

sub tkort_ConsoleClear alias "fb_ConsoleClear" ( byval mode_ as long )
	dim as long view_left = any, view_top = any, view_right = any, view_bottom = any
	dim as long win_left = any, win_top = any, win_right = any, win_bottom = any

	'' Lazily filled, so it must be asked for before being tested.
	tkrt_InitConsoleWindow( )

	'' mode 1 is the GRAPHICS viewport clear and there is no graphics viewport
	'' here; an empty window means output is redirected and there is nothing to
	'' clear. Both are silent no-ops rather than errors.
	if( TKORT_CON_WINDOW_EMPTY() orelse (mode_ = 1) ) then exit sub

	win_top    = TKORT_CON_WINDOW_TOP()
	win_left   = TKORT_CON_WINDOW_LEFT()
	win_right  = TKORT_CON_WINDOW_RIGHT()
	win_bottom = TKORT_CON_WINDOW_BOTTOM()

	'' &hFFFF0000 is gfxlib's DEFAULT_COLOR arriving where a mode was expected.
	if( (mode_ = 2) orelse (mode_ = cast( long, &hFFFF0000ul )) ) then
		tkrt_ConsoleGetView( @view_top, @view_bottom )
		tkrt_hConvertToConsole( 0, @view_top, 0, @view_bottom )
		view_left = win_left
		view_right = win_right
	else
		view_top    = win_top
		view_left   = win_left
		view_right  = win_right
		view_bottom = win_bottom
	end if

	tkort_ConsoleClearViewRawEx( TKORT_OUT_HANDLE(), view_left, view_top, view_right, view_bottom )
end sub

'' Scrolling more rows than the region holds is a CLEAR, not a scroll of an
'' empty region -- ScrollConsoleScreenBuffer with a source rectangle entirely
'' outside the destination would leave the fill attribute unapplied.
private sub hConsoleScrollRawEx( byval h as any ptr, byval x1 as long, byval y1 as long, _
                                 byval x2 as long, byval y2 as long, byval nrows as long )
	dim as long height_ = y2 - y1 + 1
	dim as short srec( 0 to 3 ) = any
	dim as ubyte cinf( 0 to 3 ) = any

	if( nrows <= 0 ) then exit sub

	if( nrows >= height_ ) then
		tkort_ConsoleClearViewRawEx( h, x1, y1, x2, y2 )
		exit sub
	end if

	'' SMALL_RECT is Left, Top, Right, Bottom -- NOT the order the fields are
	'' assigned in fbc's source, which sets Left, Right, Top, Bottom.
	srec(0) = cast( short, x1 )
	srec(1) = cast( short, y1 + nrows )
	srec(2) = cast( short, x2 )
	srec(3) = cast( short, y2 )

	'' CHAR_INFO is a one-character union followed by a WORD of attributes.
	cinf(0) = 32
	cinf(1) = 0
	*cptr( ushort ptr, @cinf(2) ) = cast( ushort, tkort_ConsoleGetColorAttEx( h ) )

	w_ScrollConsoleScreenBufferA( h, @srec(0), 0, TKORT_COORD( x1, y1 ), @cinf(0) )
end sub

'' On Windows the VIEW PRINT region is not a terminal scroll region -- there is
'' no such thing -- so updating it means re-reading the console window rect that
'' every coordinate translation is done against.
sub tkort_ConsoleViewUpdate alias "fb_ConsoleViewUpdate" ( )
	tkrt_hUpdateConsoleWindow( )
end sub

sub tkort_ConsoleScroll alias "fb_ConsoleScroll" ( byval nrows as long )
	dim as long left_ = 1, right_ = any, toprow = any, botrow = any

	if( nrows <= 0 ) then exit sub

	tkrt_ConsoleGetSize( @right_, 0 )
	tkrt_ConsoleGetView( @toprow, @botrow )
	tkrt_hConvertToConsole( @left_, @toprow, @right_, @botrow )

	hConsoleScrollRawEx( TKORT_OUT_HANDLE(), left_, toprow, right_, botrow, nrows )
end sub

end extern

#else

'' ------------------------------------------------------------ POSIX backend

'' FreeBASIC's colour index is the CGA order; the terminal's is not. This is the
'' permutation, and it is why a naive pass-through gives blue where red belongs.
dim shared as ubyte tkort_termmap( 0 to 7 ) = { 0, 4, 2, 6, 1, 5, 3, 7 }

extern "c"   '' NON-FBCALL: undecorated in fbc's win32 archive, so plain here.

function tkort_ConsoleColor alias "fb_ConsoleColor" _
	( byval fc as ulong, byval bc as ulong, byval flags as long ) as ulong

	dim as ulong old_fg = TKORT_CON_U( TKORT_CON_FGCOLOR )
	dim as ulong old_bg = TKORT_CON_U( TKORT_CON_BGCOLOR )
	dim as long force = 0
	dim as ulong nfg = any, nbg = any

	if( TKORT_CON_L( TKORT_CON_INITED ) = 0 ) then return old_fg or (old_bg shl 16)

	if( (flags and FB_COLOR_FG_DEFAULT) = 0 ) then TKORT_CON_U( TKORT_CON_FGCOLOR ) = fc and &hF
	if( (flags and FB_COLOR_BG_DEFAULT) = 0 ) then TKORT_CON_U( TKORT_CON_BGCOLOR ) = bc and &hF

	nfg = TKORT_CON_U( TKORT_CON_FGCOLOR )
	nbg = TKORT_CON_U( TKORT_CON_BGCOLOR )

	if( (TKORT_CON_L( TKORT_CON_INITED ) = INIT_CONSOLE_) orelse _
	    (TKORT_CON_L( TKORT_CON_TERMTYPE ) <> TERM_XTERM_) ) then
		'' A real console and any terminal but xterm have 16 foreground and only
		'' 8 background colours, reached through a BRIGHT attribute rather than a
		'' colour of its own.
		if( nfg <> old_fg ) then
			if( ((nfg xor old_fg) and &h8) <> 0 ) then
				'' The bright bit changed, and it is not per-colour: turning it
				'' off resets EVERY attribute, so both colours have to be sent
				'' again afterwards.
				tkrt_hTermOut( SEQ_RESET_COLOR_, 0, 0 )
				if( (nfg and &h8) <> 0 ) then tkrt_hTermOut( SEQ_BRIGHT_COLOR_, 0, 0 )
				force = 1
			end if
			tkrt_hTermOut( SEQ_FG_COLOR_, 0, tkort_termmap(nfg and &h7) )
		end if
		if( (nbg <> old_bg) orelse (force <> 0) ) then
			tkrt_hTermOut( SEQ_BG_COLOR_, 0, tkort_termmap(nbg and &h7) )
		end if
	else
		'' A generic xterm has 16 and 16, through the extended SGR codes:
		'' 30-37 and 90-97 for foreground, 40-47 and 100-107 for background.
		if( nfg <> old_fg ) then
			tkrt_hTermOut( SEQ_SET_COLOR_EX_, tkort_termmap(nfg and &h7) + iif( (nfg and &h8) <> 0, 90, 30 ), 0 )
		end if
		if( nbg <> old_bg ) then
			tkrt_hTermOut( SEQ_SET_COLOR_EX_, tkort_termmap(nbg and &h7) + iif( (nbg and &h8) <> 0, 100, 40 ), 0 )
		end if
	end if

	return old_fg or (old_bg shl 16)
end function

'' The attribute is SYNTHESISED from the two indices, because a terminal has no
'' attribute to read back. Note the shift is 4, not the 16 fb_ConsoleColor packs
'' its return value with -- this is a colour BYTE, that is a pair of indices.
function tkort_ConsoleGetColorAtt alias "fb_ConsoleGetColorAtt" ( ) as ulong
	if( TKORT_CON_L( TKORT_CON_INITED ) = 0 ) then return &h7
	return TKORT_CON_U( TKORT_CON_FGCOLOR ) or (TKORT_CON_U( TKORT_CON_BGCOLOR ) shl 4)
end function

function tkort_ConsoleLocate alias "fb_ConsoleLocate" _
	( byval row as long, byval col as long, byval cursor as long ) as long

	dim as long x = any, y = any
	static as long visible = &h10000

	if( TKORT_CON_L( TKORT_CON_INITED ) = 0 ) then return 0

	if( (row <= 0) orelse (col <= 0) ) then tkrt_ConsoleGetXY( @x, @y )

	tkrt_BgLock( )

	if( col > 0 ) then x = col
	if( row > 0 ) then y = row

	tkrt_hRecheckConsoleSize( 1 )

	'' CLAMPED, not rejected: LOCATE past the edge lands on the edge.
	if( x <= TKORT_CON_L( TKORT_CON_W ) ) then
		TKORT_CON_L( TKORT_CON_CURX ) = x
	else
		TKORT_CON_L( TKORT_CON_CURX ) = TKORT_CON_L( TKORT_CON_W )
	end if

	if( y <= TKORT_CON_L( TKORT_CON_H ) ) then
		TKORT_CON_L( TKORT_CON_CURY ) = y
	else
		TKORT_CON_L( TKORT_CON_CURY ) = TKORT_CON_L( TKORT_CON_H )
	end if

	tkrt_hTermOut( SEQ_LOCATE_, x - 1, y - 1 )

	if( cursor = 0 ) then
		tkrt_hTermOut( SEQ_HIDE_CURSOR_, 0, 0 )
		visible = 0
	elseif( cursor = 1 ) then
		tkrt_hTermOut( SEQ_SHOW_CURSOR_, 0, 0 )
		visible = &h10000
	end if

	tkrt_BgUnlock( )

	'' The UNCLAMPED x and y, deliberately: the return value reports what was
	'' asked for, and the clamp only affects where the cursor went.
	return (x and &hFF) or ((y and &hFF) shl 8) or visible
end function

sub tkort_ConsoleClear alias "fb_ConsoleClear" ( byval mode_ as long )
	dim as long start_ = any, end_ = any, i = any, w = any, h = any
	dim as ubyte ptr cbuf = any, abuf = any
	dim as ubyte attr = any

	if( (TKORT_CON_L( TKORT_CON_INITED ) = 0) orelse (mode_ = 1) ) then exit sub

	tkrt_BgLock( )
	tkrt_hRecheckConsoleSize( 1 )
	tkrt_BgUnlock( )

	tkrt_ConsoleGetView( @start_, @end_ )
	if( (mode_ <> 2) andalso (mode_ <> cast( long, &hFFFF0000ul )) ) then
		start_ = 1
		end_ = tkrt_ConsoleGetMaxRow( )
	end if

	w = TKORT_CON_L( TKORT_CON_W )
	h = TKORT_CON_L( TKORT_CON_H )

	if( start_ > h ) then start_ = h
	if( end_ > h ) then end_ = h

	cbuf = TKORT_CON_P( TKORT_CON_CHARBUF )
	abuf = TKORT_CON_P( TKORT_CON_ATTRBUF )
	attr = cast( ubyte, TKORT_CON_U( TKORT_CON_FGCOLOR ) or (TKORT_CON_U( TKORT_CON_BGCOLOR ) shl 4) )

	'' THE SHADOW BUFFERS ARE UPDATED AS WELL AS THE TERMINAL. A terminal cannot
	'' be read back, so SCREEN( ) answers from these -- clearing the screen
	'' without clearing them would leave SCREEN( ) reporting the old characters
	'' for the rest of the program's life.
	for i = start_ to end_
		if( cbuf <> 0 ) then memset( cbuf + ((i - 1) * w), 32, w )
		if( abuf <> 0 ) then memset( abuf + ((i - 1) * w), attr, w )
		tkrt_hTermOut( SEQ_LOCATE_, 0, i - 1 )
		tkrt_hTermOut( SEQ_CLEOL_, 0, 0 )
	next

	tkrt_hTermOut( SEQ_LOCATE_, 0, start_ - 1 )
	TKORT_CON_L( TKORT_CON_CURY ) = start_
	TKORT_CON_L( TKORT_CON_CURX ) = 1
end sub

'' One termcap sequence, and no shadow-buffer update: the terminal's own scroll
'' moves the lines and the next recheck picks the result up. That asymmetry with
'' the Windows side is the terminal doing the work.
sub tkort_ConsoleScroll alias "fb_ConsoleScroll" ( byval nrows as long )
	tkrt_hTermOut( SEQ_SCROLL_, 0, nrows )
end sub

sub tkort_ConsoleViewUpdate alias "fb_ConsoleViewUpdate" ( )
	if( TKORT_CON_L( TKORT_CON_INITED ) = 0 ) then exit sub
	TKORT_CON_L( TKORT_CON_SCROLLREGION ) = 1
	tkrt_hTermOut( SEQ_SCROLL_REGION_, tkrt_ConsoleGetBotRow( ), tkrt_ConsoleGetTopRow( ) )
end sub

end extern

#endif

'' ------------------------------------------------------------- VIEW PRINT
''
'' PORTABLE: fbc keeps io_view.c in the root, and the platform difference is
'' entirely inside fb_ConsoleViewUpdate above.
''
'' THE THREE MEANINGS OF AN ARGUMENT are what this function is. For each of
'' toprow and botrow:
''
''   > 0    use it, and UPDATE the window
''   = 0    use the extreme (row 1 / the last row), and UPDATE
''   < 0    keep what is already there, and do NOT update on this account
''
'' so VIEW PRINT with neither argument is a query and returns the current pair
'' without touching anything.
''
'' THE RETURN IS A PACKED PAIR, toprow + (botrow << 16), and a REJECTED range
'' returns 0 -- both rows are zeroed rather than an error being raised, which is
'' how a caller tells "out of range" from a successful call, since a successful
'' one always has a non-zero top row.

extern "c"   '' NON-FBCALL: undecorated in fbc's win32 archive.

function tkort_ConsoleViewEx alias "fb_ConsoleViewEx" _
	( byval toprow as long, byval botrow as long, byval set_cursor as long ) as long

	dim as long do_update = 0
	dim as long maxrow = any, minrow = 1

	tkrt_GetSize( 0, @maxrow )
	if( maxrow = 0 ) then maxrow = FB_SCRN_DEFAULT_HEIGHT

	if( toprow > 0 ) then
		do_update = 1
	elseif( toprow = 0 ) then
		do_update = 1
		toprow = minrow
	else
		'' +1 because the stored rows are 0-based and the API is 1-based.
		toprow = tkrt_ConsoleGetTopRow( ) + 1
	end if

	if( botrow > 0 ) then
		do_update = 1
	elseif( botrow = 0 ) then
		do_update = 1
		botrow = maxrow
	else
		botrow = tkrt_ConsoleGetBotRow( ) + 1
	end if

	if( (toprow > botrow) orelse (toprow < 1) orelse (botrow < 1) orelse _
	    (toprow > maxrow) orelse (botrow > maxrow) ) then
		do_update = 0
		botrow = 0
		toprow = 0
	end if

	if( do_update <> 0 ) then
		tkrt_ConsoleSetTopBotRows( toprow - 1, botrow - 1 )
		tkrt_ViewUpdate( )
		if( set_cursor <> 0 ) then
			'' Through fb_Locate, not fb_ConsoleLocate: the hook has to see it,
			'' because a graphics program overrides where the cursor goes.
			tkrt_Locate( toprow, 1, -1, 0, 0 )
		end if
	end if

	return toprow + (botrow shl 16)
end function

end extern

extern "rtlib"

function tkort_ConsoleView alias "fb_ConsoleView" ( byval toprow as long, byval botrow as long ) as long
	return tkort_ConsoleViewEx( toprow, botrow, 1 )
end function

end extern
