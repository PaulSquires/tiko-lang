'' console.bi -- the per-platform console context, and the helpers that stay
'' fbc's.
''
'' THE TWO PLATFORMS DO NOT SHARE A CONTEXT, A LAYOUT, OR EVEN A CONCEPT. This is
'' the single biggest asymmetry in the runtime and the reason the console layer is
'' split member by member rather than behind one abstraction:
''
''   win32   __fb_con holds console HANDLES, a page table and a SMALL_RECT
''           WINDOW. The OS keeps the cursor, the colours and the character
''           cells; the runtime asks for them.
''   POSIX   __fb_con holds `termios` state, the terminal's TYPE, a SHADOW COPY
''           of the screen as character and attribute buffers, the cursor
''           position, the current colours, a table of termcap escape sequences
''           and a set of function pointers into whichever keyboard and mouse
''           driver was chosen. The runtime keeps all of it, because a terminal
''           will not tell you.
''
'' THE OBJECT ITSELF STAYS fbc's. It is defined in win32/io_window.o and in
'' unix/hinit.o -- neither of which tiko-rt owns -- and it is read by two dozen
'' members that tiko-rt also does not own, from the print buffer to the graphics
'' library. So the layouts below MIRROR fbc's rather than replacing it, and a
'' wrong offset here is a silent write into an unrelated field.
''
'' EVERY OFFSET IS MEASURED.
''
''   win64  a C probe compiled with clang --target=x86_64-w64-windows-gnu
''          against fbc's own headers: sizeof 80, and the field table below.
''   win32  the same layout with pointers halved, CONFIRMED BY DISASSEMBLY of
''          fbc's own win32 objects --
''              io_locate.o   movl $0x0, 0x2c   + IMAGE_REL_I386_DIR32 ___fb_con
''                            -> scrollWasOff at 44
''              io_getsize.o  movzwl 0x20 / 0x22 / 0x24 / 0x26
''                            -> window.Left/Top/Right/Bottom at 32/34/36/38
''   linux  a C probe compiled by gcc under WSL against fbc's headers:
''          sizeof 408, SEQ_MAX 17, and the field table below.

#pragma once

#include once "inc/descriptors.bi"

const FB_SCRN_DEFAULT_WIDTH  = 80
const FB_SCRN_DEFAULT_HEIGHT = 25

const FB_COLOR_FG_DEFAULT = &h1
const FB_COLOR_BG_DEFAULT = &h2

#if defined( __FB_WIN32__ ) or defined( __FB_WIN64__ )

	'' MEASURED (see the file header).
	''
	''            win64   win32
	''   inHandle      0       0
	''   outHandle     8       4
	''   pgHandleTb   16       8      4 entries
	''   active       48      24
	''   visible      52      28
	''   window       56      32      SMALL_RECT: 4 SHORTs, 8 bytes
	''   setByUser    64      40
	''   scrollWasOff 68      44
	''   mouseHook    72      48
	''   sizeof       80      52
	#if defined( __FB_64BIT__ )
		const TKORT_CON_WINDOW       = 56
		const TKORT_CON_SCROLLWASOFF = 68
	#else
		const TKORT_CON_WINDOW       = 32
		const TKORT_CON_SCROLLWASOFF = 44
	#endif

	'' SMALL_RECT is Left, Top, Right, Bottom as SHORT, in that order.
	const TKORT_RECT_LEFT   = 0
	const TKORT_RECT_TOP    = 2
	const TKORT_RECT_RIGHT  = 4
	const TKORT_RECT_BOTTOM = 6

	extern "c"   '' NON-FBCALL: fbc's own console object, declared plain.
		extern __fb_con alias "__fb_con" as ubyte
	end extern

	#define TKORT_CON_WINDOW_LEFT()   (*cptr( short ptr, @__fb_con + TKORT_CON_WINDOW + TKORT_RECT_LEFT ))
	#define TKORT_CON_WINDOW_TOP()    (*cptr( short ptr, @__fb_con + TKORT_CON_WINDOW + TKORT_RECT_TOP ))
	#define TKORT_CON_WINDOW_RIGHT()  (*cptr( short ptr, @__fb_con + TKORT_CON_WINDOW + TKORT_RECT_RIGHT ))
	#define TKORT_CON_WINDOW_BOTTOM() (*cptr( short ptr, @__fb_con + TKORT_CON_WINDOW + TKORT_RECT_BOTTOM ))
	#define TKORT_CON_SCROLLOFF()     (*cptr( long ptr, @__fb_con + TKORT_CON_SCROLLWASOFF ))

	'' An EMPTY rect means the window has not been read yet, which is also how a
	'' redirected handle looks -- fb_InitConsoleWindow fills it and leaves it
	'' empty for a pipe or a file.
	#define TKORT_CON_WINDOW_EMPTY() _
		((TKORT_CON_WINDOW_LEFT() = TKORT_CON_WINDOW_RIGHT()) orelse _
		 (TKORT_CON_WINDOW_TOP() = TKORT_CON_WINDOW_BOTTOM()))

	'' CONSOLE_SCREEN_BUFFER_INFO: dwSize (2 SHORTs), dwCursorPosition (2),
	'' wAttributes (WORD), srWindow (4 SHORTs), dwMaximumWindowSize (2).
	'' 22 bytes, no padding -- every member is 2-byte aligned.
	const CSBI_SIZE_        = 22
	const CSBI_DWSIZE_X_    = 0
	const CSBI_DWSIZE_Y_    = 2
	const CSBI_CURSOR_X_    = 4
	const CSBI_CURSOR_Y_    = 6
	const CSBI_ATTRIBUTES_  = 8

	'' CONSOLE_CURSOR_INFO: dwSize (DWORD), bVisible (BOOL). 8 bytes.
	const CCI_SIZE_    = 8
	const CCI_VISIBLE_ = 4

	'' COORD is two SHORTs and is passed BY VALUE, which on win64 means packed
	'' into one 32-bit register slot -- so it is declared as a LONG and built by
	'' hand rather than as a UDT, whose by-value ABI FreeBASIC would not
	'' necessarily match.
	#define TKORT_COORD( x, y ) _
		((cast( ulong, cast( ushort, y ) ) shl 16) or cast( ulong, cast( ushort, x ) ))

	extern "c"   '' NON-FBCALL: kernel32 imports, not rtlib entry points.
		declare function w_GetConsoleScreenBufferInfo stdcall alias "GetConsoleScreenBufferInfo" _
			( byval h as any ptr, byval info as any ptr ) as long
		declare function w_SetConsoleCursorPosition stdcall alias "SetConsoleCursorPosition" _
			( byval h as any ptr, byval c as ulong ) as long
		declare function w_GetConsoleCursorInfo stdcall alias "GetConsoleCursorInfo" _
			( byval h as any ptr, byval info as any ptr ) as long
		declare function w_SetConsoleCursorInfo stdcall alias "SetConsoleCursorInfo" _
			( byval h as any ptr, byval info as any ptr ) as long
		declare function w_SetConsoleTextAttribute stdcall alias "SetConsoleTextAttribute" _
			( byval h as any ptr, byval attr as ushort ) as long
		declare function w_GetLargestConsoleWindowSize stdcall alias "GetLargestConsoleWindowSize" _
			( byval h as any ptr ) as ulong
		declare function w_GetConsoleMode stdcall alias "GetConsoleMode" _
			( byval h as any ptr, byval mode_ as ulong ptr ) as long
		declare function w_ReadConsoleOutputAttribute stdcall alias "ReadConsoleOutputAttribute" _
			( byval h as any ptr, byval buf as ushort ptr, byval n as ulong, byval c as ulong, byval got as ulong ptr ) as long
		declare function w_ReadConsoleOutputCharacterA stdcall alias "ReadConsoleOutputCharacterA" _
			( byval h as any ptr, byval buf as zstring ptr, byval n as ulong, byval c as ulong, byval got as ulong ptr ) as long
	end extern

	'' fbc's own, and they stay fbc's: the handle cache is in io_gethnd.o and the
	'' VIEW PRINT window arithmetic in io_window.o.
	extern "c"   '' NON-FBCALL: internal, declared plain in fb_private_console.h.
		declare function tkrt_hConsoleGetHandle alias "fb_hConsoleGetHandle" ( byval is_input as long ) as any ptr
		declare sub tkrt_InitConsoleWindow alias "fb_InitConsoleWindow" ( )
		declare sub tkrt_hConsoleGetWindow alias "fb_hConsoleGetWindow" _
			( byval l as long ptr, byval t as long ptr, byval c as long ptr, byval r as long ptr )
	end extern

	extern "rtlib"
		declare sub tkrt_hUpdateConsoleWindow alias "fb_hUpdateConsoleWindow" ( )
		declare sub tkrt_hConvertToConsole alias "fb_hConvertToConsole" _
			( byval l as long ptr, byval t as long ptr, byval r as long ptr, byval b as long ptr )
		declare sub tkrt_hConvertFromConsole alias "fb_hConvertFromConsole" _
			( byval l as long ptr, byval t as long ptr, byval r as long ptr, byval b as long ptr )
	end extern

	#define TKORT_IN_HANDLE()  tkrt_hConsoleGetHandle( 1 )
	#define TKORT_OUT_HANDLE() tkrt_hConsoleGetHandle( 0 )

#else

	'' MEASURED by a gcc probe under WSL against fbc's headers: sizeof 408.
	''
	''   inited                   0    fg_color             152
	''   term_type                4    bg_color             156
	''   h_in                     8    cur_x                160
	''   f_in                    16    cur_y                164
	''   old_term_out            24    w                    168
	''   old_term_in             84    h                    172
	''   old_in_flags           144    char_buffer          176
	''   saved_old_term_out     148    attr_buffer          184
	''   saved_old_term_in      149    has_perm             192  (linux/x86)
	''   saved_old_in_flags     150    scroll_region_changed 196
	''                                 seq                  200  (17 pointers)
	''                                 keyboard_getch       336 ... gfx_exit 400
	const TKORT_CON_INITED    = 0
	const TKORT_CON_TERMTYPE  = 4
	const TKORT_CON_FGCOLOR   = 152
	const TKORT_CON_BGCOLOR   = 156
	const TKORT_CON_CURX      = 160
	const TKORT_CON_CURY      = 164
	const TKORT_CON_W         = 168
	const TKORT_CON_H         = 172
	const TKORT_CON_CHARBUF   = 176
	const TKORT_CON_ATTRBUF   = 184
	'' 192 is has_perm on linux/x86, which nothing here touches.

	const INIT_CONSOLE_ = 1
	const TERM_XTERM_   = 1

	const TKORT_CON_SCROLLREGION = 196

	const SEQ_LOCATE_       = 0
	const SEQ_SCROLL_REGION_ = 2
	const SEQ_CLEOL_        = 4
	const SEQ_SCROLL_       = 11
	const SEQ_FG_COLOR_     = 7
	const SEQ_BG_COLOR_     = 8
	const SEQ_RESET_COLOR_  = 9
	const SEQ_BRIGHT_COLOR_ = 10
	const SEQ_SHOW_CURSOR_  = 12
	const SEQ_HIDE_CURSOR_  = 13
	const SEQ_SET_COLOR_EX_ = 107

	extern "c"   '' NON-FBCALL: fbc's own console object, declared plain.
		extern __fb_con alias "__fb_con" as ubyte
	end extern

	#define TKORT_CON_L( off ) (*cptr( long ptr, @__fb_con + (off) ))
	#define TKORT_CON_U( off ) (*cptr( ulong ptr, @__fb_con + (off) ))
	#define TKORT_CON_P( off ) (*cptr( ubyte ptr ptr, @__fb_con + (off) ))

	'' fbc's own, all in unix/hinit.o, and they stay fbc's.
	extern "c"   '' NON-FBCALL: internal, declared plain in fb_private_console.h.
		declare sub tkrt_BgLock alias "fb_BgLock" ( )
		declare sub tkrt_BgUnlock alias "fb_BgUnlock" ( )
		declare sub tkrt_hRecheckConsoleSize alias "fb_hRecheckConsoleSize" ( byval requery as long )
		declare sub tkrt_hRecheckCursorPos alias "fb_hRecheckCursorPos" ( )
		declare function tkrt_hTermOut alias "fb_hTermOut" _
			( byval code_ as long, byval p1 as long, byval p2 as long ) as long
		declare function c_isatty alias "isatty" ( byval fd as long ) as long
	end extern

#endif
