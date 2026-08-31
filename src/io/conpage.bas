'' conpage.bas -- console PAGES, WIDTH and the printer's column. Five symbols on
'' Windows and four on POSIX, across four fbc members.
''
'' PAGES EXIST ON WINDOWS AND NOT ON POSIX, and the POSIX side says so rather
'' than emulating them. A console page is a second SCREEN BUFFER that the OS can
'' swap in whole; a terminal has one screen and no way to make another, so
'' SCREEN , pg, pg returns -1 there and PCOPY raises "illegal function call".
'' Emulating pages over the shadow buffers was not attempted by fbc and is not
'' attempted here: it would make PCOPY silently succeed while producing nothing a
'' user could see.
''
'' THE PAGE TABLE IS FOUR SLOTS, ALLOCATED LAZILY, and every entry point that
'' touches a page has to create the buffer first -- which is why the same
'' four-line "if the slot is NULL, make one" appears three times below rather
'' than being hoisted: two of those three return DIFFERENT error values when the
'' creation fails (-1 from PageSet, ILLEGAL FUNCTION CALL from PageCopy), and a
'' shared helper would have to be told which.
''
'' A NEW BUFFER IS SIZED FROM stdout's, not from the default. A page that came
'' out 80x25 while the console was 120x40 would make PCOPY copy a window's worth
'' and leave the rest of the destination untouched.
''
'' THE CURSOR IS HIDDEN ON EVERY PAGE THAT IS NOT VISIBLE. Without it the caret
'' blinks on a buffer nobody is looking at, and on some Windows versions it
'' blinks THROUGH to the visible one.
''
'' WIDTH IS TWO OPERATIONS: with no positive argument it QUERIES, packing
'' cols | (rows << 16); with one it RESIZES. The Windows resize is a dance --
'' the window must be shrunk before the buffer if the buffer is shrinking, and
'' grown after it if it is growing, or one of the two calls fails because the
'' window would not fit the buffer. POSIX just asks the terminal and then clears,
'' because a terminal that honours the request repaints anyway.

#include once "inc/descriptors.bi"
#include once "inc/console.bi"
#include once "inc/iolock.bi"
#include once "inc/rterror.bi"
#include once "crt/stdlib.bi"
#include once "crt/string.bi"

extern "rtlib"
	declare function tkrt_ErrorSetNum alias "fb_ErrorSetNum" ( byval errnum as long ) as long
end extern

#if defined( __FB_WIN32__ ) or defined( __FB_WIN64__ )

'' ---------------------------------------------------------- Windows backend

const FB_CONSOLE_MAXPAGES = 4

'' MEASURED with the rest of the context (see inc/console.bi):
''   pgHandleTb  16 / 8      active  48 / 24      visible  52 / 28
''   setByUser   64 / 40
#if defined( __FB_64BIT__ )
	const TKORT_CON_PGTB      = 16
	const TKORT_CON_ACTIVE    = 48
	const TKORT_CON_VISIBLE   = 52
	const TKORT_CON_SETBYUSER = 64
	const TKORT_CON_OUTHANDLE = 8
#else
	const TKORT_CON_PGTB      = 8
	const TKORT_CON_ACTIVE    = 24
	const TKORT_CON_VISIBLE   = 28
	const TKORT_CON_SETBYUSER = 40
	const TKORT_CON_OUTHANDLE = 4
#endif

#define TKORT_CON_PAGE( i )  (*cptr( any ptr ptr, @__fb_con + TKORT_CON_PGTB + (i) * sizeof( any ptr ) ))
#define TKORT_CON_ACTIVEPG() (*cptr( long ptr, @__fb_con + TKORT_CON_ACTIVE ))
#define TKORT_CON_VISIBLEPG() (*cptr( long ptr, @__fb_con + TKORT_CON_VISIBLE ))
#define TKORT_CON_SETBYUSERF() (*cptr( long ptr, @__fb_con + TKORT_CON_SETBYUSER ))
#define TKORT_CON_OUT()      (*cptr( any ptr ptr, @__fb_con + TKORT_CON_OUTHANDLE ))

const GENERIC_READ_  = &h80000000ul
const GENERIC_WRITE_ = &h40000000ul
const CONSOLE_TEXTMODE_BUFFER_ = 1

extern "c"   '' NON-FBCALL: kernel32 imports, not rtlib entry points.
	declare function w_CreateConsoleScreenBuffer stdcall alias "CreateConsoleScreenBuffer" _
		( byval acc as ulong, byval share as ulong, byval sa as any ptr, _
		  byval flags as ulong, byval reserved as any ptr ) as any ptr
	declare function w_SetConsoleScreenBufferSize stdcall alias "SetConsoleScreenBufferSize" _
		( byval h as any ptr, byval size_ as ulong ) as long
	declare function w_SetConsoleActiveScreenBuffer stdcall alias "SetConsoleActiveScreenBuffer" _
		( byval h as any ptr ) as long
	declare function w_SetConsoleWindowInfo stdcall alias "SetConsoleWindowInfo" _
		( byval h as any ptr, byval absolute as long, byval rect as any ptr ) as long
	declare function w_ReadConsoleOutputA stdcall alias "ReadConsoleOutputA" _
		( byval h as any ptr, byval buf as any ptr, byval size_ as ulong, byval pos as ulong, byval region as any ptr ) as long
	declare function w_WriteConsoleOutputA stdcall alias "WriteConsoleOutputA" _
		( byval h as any ptr, byval buf as any ptr, byval size_ as ulong, byval pos as ulong, byval region as any ptr ) as long
end extern

'' The srWindow field of CONSOLE_SCREEN_BUFFER_INFO, which Read/WriteConsoleOutput
'' take as an in-out region.
const CSBI_SRWINDOW_ = 10

extern "c"   '' NON-FBCALL: undecorated in fbc's win32 archive.

'' A new page, sized from stdout's buffer -- see the file header.
function tkort_hConsoleCreateBuffer alias "fb_hConsoleCreateBuffer" ( ) as any ptr
	dim as any ptr hnd = any
	dim as ubyte csbi( 0 to CSBI_SIZE_ - 1 ) = any

	hnd = w_CreateConsoleScreenBuffer( GENERIC_READ_ or GENERIC_WRITE_, 0, 0, _
	                                   CONSOLE_TEXTMODE_BUFFER_, 0 )
	if( hnd = 0 ) then return 0

	if( w_GetConsoleScreenBufferInfo( TKORT_CON_OUT(), @csbi(0) ) <> 0 ) then
		w_SetConsoleScreenBufferSize( hnd, _
			TKORT_COORD( *cptr( short ptr, @csbi(CSBI_DWSIZE_X_) ), _
			             *cptr( short ptr, @csbi(CSBI_DWSIZE_Y_) ) ) )
	end if

	return hnd
end function

'' The cursor SIZE comes from stdout and only the VISIBILITY is applied, which is
'' why this reads one handle and writes another.
private sub hHideCursor( byval pg1 as long, byval pg2 as long )
	dim as ubyte cci( 0 to CCI_SIZE_ - 1 )

	w_GetConsoleCursorInfo( TKORT_CON_OUT(), @cci(0) )
	*cptr( long ptr, @cci(CCI_VISIBLE_) ) = 0

	w_SetConsoleCursorInfo( TKORT_CON_PAGE( pg1 ), @cci(0) )
	if( pg2 >= 0 ) then w_SetConsoleCursorInfo( TKORT_CON_PAGE( pg2 ), @cci(0) )
end sub

function tkort_ConsolePageSet alias "fb_ConsolePageSet" _
	( byval active as long, byval visible as long ) as long

	dim as long res = any
	dim as any ptr hnd = any

	'' Forces the lazy handle init, so the page table's slot 0 is stdout.
	tkrt_hConsoleGetHandle( 0 )

	res = TKORT_CON_ACTIVEPG() or (TKORT_CON_VISIBLEPG() shl 8)

	if( active >= 0 ) then
		if( TKORT_CON_PAGE( active ) = 0 ) then
			hnd = tkort_hConsoleCreateBuffer( )
			if( hnd = 0 ) then return -1
			TKORT_CON_PAGE( active ) = hnd
		end if

		'' writing to a page nobody is looking at: hide its cursor
		if( active <> TKORT_CON_VISIBLEPG() ) then hHideCursor( active, -1 )

		TKORT_CON_ACTIVEPG() = active
	end if

	if( visible >= 0 ) then
		if( TKORT_CON_PAGE( visible ) = 0 ) then
			hnd = tkort_hConsoleCreateBuffer( )
			if( hnd = 0 ) then return -1
			TKORT_CON_PAGE( visible ) = hnd
		end if

		if( TKORT_CON_VISIBLEPG() <> visible ) then
			w_SetConsoleActiveScreenBuffer( TKORT_CON_PAGE( visible ) )

			if( visible <> TKORT_CON_ACTIVEPG() ) then
				hHideCursor( TKORT_CON_ACTIVEPG(), visible )
			end if

			TKORT_CON_VISIBLEPG() = visible
		end if
	end if

	return res
end function

function tkort_ConsolePageCopy alias "fb_ConsolePageCopy" ( byval src as long, byval dst as long ) as long
	dim as any ptr hnd = any, buff = any
	dim as ubyte csbi( 0 to CSBI_SIZE_ - 1 ) = any
	dim as long w = any, h = any

	tkrt_hConsoleGetHandle( 0 )

	'' negative means "the current one", and the two defaults are DIFFERENT: the
	'' source defaults to the ACTIVE page and the destination to the VISIBLE one,
	'' which is what makes PCOPY with no arguments mean "show what I just drew".
	if( src < 0 ) then src = TKORT_CON_ACTIVEPG()

	if( TKORT_CON_PAGE( src ) = 0 ) then
		hnd = tkort_hConsoleCreateBuffer( )
		if( hnd = 0 ) then return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
		TKORT_CON_PAGE( src ) = hnd
	end if

	if( dst < 0 ) then dst = TKORT_CON_VISIBLEPG()

	if( src = dst ) then return tkrt_ErrorSetNum( FB_RTERROR_OK )

	if( TKORT_CON_PAGE( dst ) = 0 ) then
		hnd = tkort_hConsoleCreateBuffer( )
		if( hnd = 0 ) then return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
		TKORT_CON_PAGE( dst ) = hnd
	end if

	'' OUT OF MEMORY WHEN THE BUFFER INFO CANNOT BE READ, and that odd-looking
	'' choice is the one that MATCHES.
	''
	'' fbc does not check this call at all. On a redirected handle it fails and
	'' leaves the CONSOLE_SCREEN_BUFFER_INFO uninitialised, so fbc multiplies two
	'' stack values together and mallocs that many bytes -- which fails, and the
	'' function returns OUT_OF_MEMORY. Measured: fbc returns 4 here on every run.
	''
	'' Reproducing "read uninitialised memory" is not possible deterministically,
	'' and returning ILLEGAL FUNCTION CALL -- which is what a check would
	'' naturally give -- is a DIFFERENT answer to the one every caller sees today.
	'' So the check exists, and its result is the value fbc arrives at by
	'' accident.
	if( w_GetConsoleScreenBufferInfo( TKORT_CON_PAGE( src ), @csbi(0) ) = 0 ) then
		return tkrt_ErrorSetNum( FB_RTERROR_OUTOFMEM )
	end if

	w = *cptr( short ptr, @csbi(CSBI_DWSIZE_X_) )
	h = *cptr( short ptr, @csbi(CSBI_DWSIZE_Y_) )

	buff = malloc( w * h * 4 )
	if( buff = 0 ) then return tkrt_ErrorSetNum( FB_RTERROR_OUTOFMEM )

	'' The REGION is in-out: Read fills it with what it actually read, so the
	'' Write must be given the DESTINATION's own region rather than reusing it.
	w_ReadConsoleOutputA( TKORT_CON_PAGE( src ), buff, TKORT_COORD( w, h ), _
	                      TKORT_COORD( 0, 0 ), @csbi(CSBI_SRWINDOW_) )

	w_GetConsoleScreenBufferInfo( TKORT_CON_PAGE( dst ), @csbi(0) )
	w_WriteConsoleOutputA( TKORT_CON_PAGE( dst ), buff, _
	                       TKORT_COORD( *cptr( short ptr, @csbi(CSBI_DWSIZE_X_) ), _
	                                    *cptr( short ptr, @csbi(CSBI_DWSIZE_Y_) ) ), _
	                       TKORT_COORD( 0, 0 ), @csbi(CSBI_SRWINDOW_) )
	free( buff )

	return tkrt_ErrorSetNum( FB_RTERROR_OK )
end function

'' WIDTH cols, rows -- query with no positive argument, resize with one.
function tkort_ConsoleWidth alias "fb_ConsoleWidth" ( byval cols as long, byval rows as long ) as long
	dim as ulong max_ = any
	dim as long maxx = any, maxy = any
	dim as long cur = any, do_change = 0, do_resize = 0
	dim as long ncols = any, nrows = any
	dim as long sx = any, sy = any
	dim as short rect( 0 to 3 ) = any, rectres( 0 to 3 ) = any
	dim as long i = any

	tkrt_InitConsoleWindow( )

	'' redirected: there is no window to size, and 0 says so
	if( TKORT_CON_WINDOW_EMPTY() ) then return 0

	max_ = w_GetLargestConsoleWindowSize( TKORT_OUT_HANDLE() )
	maxx = cast( short, max_ and &hFFFF )
	maxy = cast( short, (max_ shr 16) and &hFFFF )

	tkrt_hConsoleGetWindow( 0, 0, @ncols, @nrows )

	if( cols > 0 ) then
		sx = cols
		do_change = 1
	else
		sx = ncols
	end if

	if( rows > 0 ) then
		sy = rows
		do_change = 1
	else
		sy = nrows
	end if

	cur = sx or (sy shl 16)

	if( do_change = 0 ) then return cur

	rect(0) = 0                                  '' Left
	rect(1) = 0                                  '' Top
	rect(2) = cast( short, sx - 1 )              '' Right
	if( rect(2) > maxx ) then rect(2) = cast( short, maxx )
	rect(3) = cast( short, sy - 1 )              '' Bottom
	if( rect(3) > maxy ) then rect(3) = cast( short, maxy )

	'' SHRINK THE WINDOW BEFORE THE BUFFER. A window larger than the buffer it
	'' looks at is rejected, so when either dimension is getting smaller the
	'' window has to be brought inside the OLD buffer first, and only the
	'' dimension that is NOT shrinking is clamped to the old size.
	if( rect(3) < (nrows - 1) ) then
		do_resize = 1
		memcpy( @rectres(0), @rect(0), 4 * sizeof( short ) )
		if( rectres(2) >= ncols ) then rectres(2) = cast( short, ncols - 1 )
	elseif( rect(2) < (ncols - 1) ) then
		do_resize = 1
		memcpy( @rectres(0), @rect(0), 4 * sizeof( short ) )
		if( rectres(3) >= nrows ) then rectres(3) = cast( short, nrows - 1 )
	end if

	if( do_resize <> 0 ) then
		for i = 0 to FB_CONSOLE_MAXPAGES - 1
			if( TKORT_CON_PAGE( i ) <> 0 ) then
				w_SetConsoleWindowInfo( TKORT_CON_PAGE( i ), 1, @rectres(0) )
			end if
		next
	end if

	'' EVERY PAGE is resized, not just the visible one: a page left at the old
	'' size would make the next PCOPY copy a mismatched rectangle.
	for i = 0 to FB_CONSOLE_MAXPAGES - 1
		if( TKORT_CON_PAGE( i ) <> 0 ) then
			w_SetConsoleScreenBufferSize( TKORT_CON_PAGE( i ), TKORT_COORD( sx, sy ) )
			w_SetConsoleWindowInfo( TKORT_CON_PAGE( i ), 1, @rect(0) )
		end if
	next

	'' setByUser is cleared around the update so the window rect is re-read from
	'' the OS rather than left at what the user asked for -- the OS may have
	'' clamped it, and every coordinate translation afterwards uses this rect.
	TKORT_CON_SETBYUSERF() = 0
	tkrt_hUpdateConsoleWindow( )
	TKORT_CON_SETBYUSERF() = 1

	return cur
end function

end extern

#else

'' ------------------------------------------------------------ POSIX backend

'' Owned by tiko-rt already, in io/conattr.bas.
extern "c"   '' NON-FBCALL: undecorated in fbc's win32 archive.
	declare sub tkrt_ConsoleClear alias "fb_ConsoleClear" ( byval mode_ as long )
end extern

extern "c"   '' NON-FBCALL: undecorated in fbc's win32 archive, so plain here.

'' NO PAGES ON A TERMINAL -- see the file header. -1 is "cannot", not an error
'' code, so SCREEN , pg, pg is usable as a capability test.
function tkort_ConsolePageSet alias "fb_ConsolePageSet" _
	( byval active as long, byval visible as long ) as long
	scope : dim as long ua = active : dim as long uv = visible : end scope
	return -1
end function

function tkort_ConsolePageCopy alias "fb_ConsolePageCopy" ( byval src as long, byval dst as long ) as long
	scope : dim as long us = src : dim as long ud = dst : end scope
	return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
end function

function tkort_ConsoleWidth alias "fb_ConsoleWidth" ( byval cols as long, byval rows as long ) as long
	dim as long cur = any

	'' 80x25 before the console is up, which is the same pair the Windows side
	'' falls back to -- and NOT the 80x24 fb_ConsoleGetSize uses. The two
	'' defaults differ in fbc and both are reproduced as they stand.
	if( TKORT_CON_L( TKORT_CON_INITED ) = 0 ) then return 80 or (25 shl 16)

	tkrt_BgLock( )
	tkrt_hRecheckConsoleSize( 1 )
	tkrt_BgUnlock( )

	cur = TKORT_CON_L( TKORT_CON_W ) or (TKORT_CON_L( TKORT_CON_H ) shl 16)

	if( (cols > 0) orelse (rows > 0) ) then
		tkrt_BgLock( )

		if( cols <= 0 ) then cols = TKORT_CON_L( TKORT_CON_W )
		if( rows <= 0 ) then rows = TKORT_CON_L( TKORT_CON_H )
		tkrt_hTermOut( SEQ_WINDOW_SIZE_, rows, cols )

		tkrt_BgUnlock( )

		'' CLEARED AFTER A RESIZE. The shadow buffers are indexed by the OLD
		'' width, so leaving them would make SCREEN( ) read across rows.
		tkrt_ConsoleClear( 0 )
	end if

	return cur
end function

end extern

#endif

'' ------------------------------------------------------------ the printer
''
'' PORTABLE, and one line of work: LPOS asks the printer device for the column it
'' is at. The device name is built from the caller's INDEX -- LPOS(0) is "LPT1:"
'' -- because the statement takes a printer number and the device layer takes a
'' name.
''
'' Under the I/O lock, because fb_DevPrinterGetOffset walks the open-device list.

extern "c"   '' NON-FBCALL: fbc's own printer device, in io_printer.o.
	declare function tkrt_DevPrinterGetOffset alias "fb_DevPrinterGetOffset" ( byval dev as zstring ptr ) as long
	declare function tkrt_sprintf2 alias "sprintf" _
		( byval buf as zstring ptr, byval fmt as zstring ptr, ... ) as long
end extern

extern "rtlib"

function tkort_LPos alias "fb_LPos" ( byval printer_index as long ) as long
	dim as zstring * 32 buffer = any
	dim as long cur = any

	TKORT_IOLOCK()

	tkrt_sprintf2( @buffer, @"LPT%d:", printer_index + 1 )
	cur = tkrt_DevPrinterGetOffset( @buffer )

	TKORT_IOUNLOCK()

	return cur
end function

end extern
