'' hookcon.bas -- the console hooks: fifteen entry points over fifteen fbc
'' members.
''
'' All the same shape as src/io/hookprint.bas -- try the hook, fall back to the
'' console -- so what is worth reading is the TWO that do more than dispatch,
'' because each keeps a piece of state PRINT's padding depends on.
''
''   CLS    zeroes the screen handle's line_length. Without it the next PRINT ,
''          pads from wherever the cursor used to be, on a now-blank screen.
''
''   WIDTH  sets the screen handle's width AND resets VIEW PRINT -- but only when
''          a positive dimension was actually given. It also RETURNS TWO
''          DIFFERENT THINGS: the current value when asked for neither, and 0
''          when setting.
''
'' fb_DevScrnInit_NoOpen runs BEFORE the lock in the ones that touch the handle:
'' it has to exist before its fields do, and creating it takes the lock itself.

#include once "inc/descriptors.bi"
#include once "inc/ctx.bi"
#include once "inc/file.bi"

#ifdef ENABLE_MT
	extern "rtlib"
		declare sub fb_Lock alias "fb_Lock" ( )
		declare sub fb_Unlock alias "fb_Unlock" ( )
	end extern
	#define IOLOCK()   fb_Lock()
	#define IOUNLOCK() fb_Unlock()
#else
	#define IOLOCK()
	#define IOUNLOCK()
#endif

type FB_CLSPROC        as sub cdecl ( byval mode as long )
type FB_COLORPROC      as function cdecl ( byval fc as ulong, byval bc as ulong, byval flags as long ) as ulong
type FB_WIDTHPROC      as function cdecl ( byval cols as long, byval rows as long ) as long
type FB_GETXPROC       as function cdecl ( ) as long
type FB_GETYPROC       as function cdecl ( ) as long
type FB_GETXYPROC      as sub cdecl ( byval col as long ptr, byval row as long ptr )
type FB_GETSIZEPROC    as sub cdecl ( byval cols as long ptr, byval rows as long ptr )
type FB_MULTIKEYPROC   as function cdecl ( byval scancode as long ) as long
type FB_SETMOUSEPROC   as function cdecl ( byval x as long, byval y as long, byval cursor as long, byval clip as long ) as long
type FB_VIEWUPDATEPROC as sub cdecl ( )
type FB_READXYPROC     as function cdecl ( byval col as long, byval row as long, byval colorflag as long ) as ulong
type FB_SLEEPPROC      as sub cdecl ( byval msecs as long )
type FB_ISREDIRPROC    as function cdecl ( byval is_input as long ) as long
type FB_PAGECOPYPROC   as function cdecl ( byval src as long, byval dst as long ) as long
type FB_PAGESETPROC    as function cdecl ( byval active as long, byval visible as long ) as long

extern "rtlib"
	declare sub tkrt_ConsoleClear alias "fb_ConsoleClear" ( byval mode as long )
	declare function tkrt_ConsoleColor alias "fb_ConsoleColor" ( byval fc as ulong, byval bc as ulong, byval flags as long ) as ulong
	declare function tkrt_ConsoleWidth alias "fb_ConsoleWidth" ( byval cols as long, byval rows as long ) as long
	declare function tkrt_ConsoleGetX alias "fb_ConsoleGetX" ( ) as long
	declare function tkrt_ConsoleGetY alias "fb_ConsoleGetY" ( ) as long
	declare sub tkrt_ConsoleGetXY alias "fb_ConsoleGetXY" ( byval col as long ptr, byval row as long ptr )
	declare sub tkrt_ConsoleGetSize alias "fb_ConsoleGetSize" ( byval cols as long ptr, byval rows as long ptr )
	declare function tkrt_ConsoleMultikey alias "fb_ConsoleMultikey" ( byval scancode as long ) as long
	declare function tkrt_ConsoleSetMouse alias "fb_ConsoleSetMouse" ( byval x as long, byval y as long, byval cursor as long, byval clip as long ) as long
	declare sub tkrt_ConsoleViewUpdate alias "fb_ConsoleViewUpdate" ( )
	declare function tkrt_ConsoleReadXY alias "fb_ConsoleReadXY" ( byval col as long, byval row as long, byval colorflag as long ) as ulong
	declare sub tkrt_ConsoleSleep alias "fb_ConsoleSleep" ( byval msecs as long )
	declare function tkrt_ConsoleIsRedirected alias "fb_ConsoleIsRedirected" ( byval is_input as long ) as long
	declare function tkrt_ConsolePageCopy alias "fb_ConsolePageCopy" ( byval src as long, byval dst as long ) as long
	declare function tkrt_ConsolePageSet alias "fb_ConsolePageSet" ( byval active as long, byval visible as long ) as long
	declare sub tkrt_ConsoleView alias "fb_ConsoleView" ( byval top as long, byval bot as long )
end extern

extern "c"   '' NON-FBCALL: the lazy screen-handle creator.
	declare sub tkrt_DevScrnInitNoOpen alias "fb_DevScrnInit_NoOpen" ( )
end extern

extern "rtlib"

sub tkort_Cls alias "fb_Cls" ( byval mode as long )
	tkrt_DevScrnInitNoOpen( )
	IOLOCK()
	dim as FB_CLSPROC p = TKORT_HOOKPTR( FB_CLSPROC, TKORT_HK_CLS )
	if( p <> 0 ) then
		p( mode )
	else
		tkrt_ConsoleClear( mode )
	end if
	'' Zeroed here, or the next PRINT , pads from a stale column.
	TKORT_FILETB()->line_length = 0
	IOUNLOCK()
end sub

function tkort_Color alias "fb_Color" _
	( byval fc as ulong, byval bc as ulong, byval flags as long ) as ulong
	IOLOCK()
	dim as ulong cur = any
	dim as FB_COLORPROC p = TKORT_HOOKPTR( FB_COLORPROC, TKORT_HK_COLOR )
	if( p <> 0 ) then cur = p( fc, bc, flags ) else cur = tkrt_ConsoleColor( fc, bc, flags )
	IOUNLOCK()
	return cur
end function

function tkort_Width alias "fb_Width" ( byval cols as long, byval rows as long ) as long
	tkrt_DevScrnInitNoOpen( )
	IOLOCK()
	dim as long cur = any
	dim as FB_WIDTHPROC p = TKORT_HOOKPTR( FB_WIDTHPROC, TKORT_HK_WIDTH )
	if( p <> 0 ) then cur = p( cols, rows ) else cur = tkrt_ConsoleWidth( cols, rows )
	if( cols > 0 ) then TKORT_FILETB()->width = cols
	'' VIEW PRINT is reset only when something was actually set.
	if( (cols > 0) orelse (rows > 0) ) then tkrt_ConsoleView( 0, 0 )
	IOUNLOCK()
	'' The current value when querying, 0 when setting.
	if( (cols < 1) andalso (rows < 1) ) then return cur
	return 0
end function

function tkort_GetX alias "fb_GetX" ( ) as long
	IOLOCK()
	dim as long res = any
	dim as FB_GETXPROC p = TKORT_HOOKPTR( FB_GETXPROC, TKORT_HK_GETX )
	if( p <> 0 ) then res = p( ) else res = tkrt_ConsoleGetX( )
	IOUNLOCK()
	return res
end function

function tkort_GetY alias "fb_GetY" ( ) as long
	IOLOCK()
	dim as long res = any
	dim as FB_GETYPROC p = TKORT_HOOKPTR( FB_GETYPROC, TKORT_HK_GETY )
	if( p <> 0 ) then res = p( ) else res = tkrt_ConsoleGetY( )
	IOUNLOCK()
	return res
end function

sub tkort_GetXY alias "fb_GetXY" ( byval col as long ptr, byval row as long ptr )
	IOLOCK()
	dim as FB_GETXYPROC p = TKORT_HOOKPTR( FB_GETXYPROC, TKORT_HK_GETXY )
	if( p <> 0 ) then p( col, row ) else tkrt_ConsoleGetXY( col, row )
	IOUNLOCK()
end sub

sub tkort_GetSize alias "fb_GetSize" ( byval cols as long ptr, byval rows as long ptr )
	IOLOCK()
	dim as FB_GETSIZEPROC p = TKORT_HOOKPTR( FB_GETSIZEPROC, TKORT_HK_GETSIZE )
	if( p <> 0 ) then p( cols, rows ) else tkrt_ConsoleGetSize( cols, rows )
	IOUNLOCK()
end sub

function tkort_Multikey alias "fb_Multikey" ( byval scancode as long ) as long
	IOLOCK()
	dim as long res = any
	dim as FB_MULTIKEYPROC p = TKORT_HOOKPTR( FB_MULTIKEYPROC, TKORT_HK_MULTIKEY )
	if( p <> 0 ) then res = p( scancode ) else res = tkrt_ConsoleMultikey( scancode )
	IOUNLOCK()
	return res
end function

function tkort_SetMouse alias "fb_SetMouse" _
	( byval x as long, byval y as long, byval cursor as long, byval clip as long ) as long
	IOLOCK()
	dim as long res = any
	dim as FB_SETMOUSEPROC p = TKORT_HOOKPTR( FB_SETMOUSEPROC, TKORT_HK_SETMOUSE )
	if( p <> 0 ) then res = p( x, y, cursor, clip ) else res = tkrt_ConsoleSetMouse( x, y, cursor, clip )
	IOUNLOCK()
	return res
end function

sub tkort_ViewUpdate alias "fb_ViewUpdate" ( )
	IOLOCK()
	dim as FB_VIEWUPDATEPROC p = TKORT_HOOKPTR( FB_VIEWUPDATEPROC, TKORT_HK_VIEWUPDATE )
	if( p <> 0 ) then p( ) else tkrt_ConsoleViewUpdate( )
	IOUNLOCK()
end sub

function tkort_ReadXY alias "fb_ReadXY" _
	( byval col as long, byval row as long, byval colorflag as long ) as ulong
	IOLOCK()
	dim as ulong res = any
	dim as FB_READXYPROC p = TKORT_HOOKPTR( FB_READXYPROC, TKORT_HK_READXY )
	if( p <> 0 ) then res = p( col, row, colorflag ) else res = tkrt_ConsoleReadXY( col, row, colorflag )
	IOUNLOCK()
	return res
end function

sub tkort_Sleep alias "fb_Sleep" ( byval msecs as long )
	IOLOCK()
	dim as FB_SLEEPPROC p = TKORT_HOOKPTR( FB_SLEEPPROC, TKORT_HK_SLEEP )
	if( p <> 0 ) then p( msecs ) else tkrt_ConsoleSleep( msecs )
	IOUNLOCK()
end sub

function tkort_IsRedirected alias "fb_IsRedirected" ( byval is_input as long ) as long
	IOLOCK()
	dim as long res = any
	dim as FB_ISREDIRPROC p = TKORT_HOOKPTR( FB_ISREDIRPROC, TKORT_HK_ISREDIR )
	if( p <> 0 ) then res = p( is_input ) else res = tkrt_ConsoleIsRedirected( is_input )
	IOUNLOCK()
	return res
end function

function tkort_PageCopy alias "fb_PageCopy" ( byval src as long, byval dst as long ) as long
	tkrt_DevScrnInitNoOpen( )
	IOLOCK()
	dim as long res = any
	dim as FB_PAGECOPYPROC p = TKORT_HOOKPTR( FB_PAGECOPYPROC, TKORT_HK_PAGECOPY )
	if( p <> 0 ) then res = p( src, dst ) else res = tkrt_ConsolePageCopy( src, dst )
	IOUNLOCK()
	return res
end function

function tkort_PageSet alias "fb_PageSet" ( byval active as long, byval visible as long ) as long
	tkrt_DevScrnInitNoOpen( )
	IOLOCK()
	dim as long res = any
	dim as FB_PAGESETPROC p = TKORT_HOOKPTR( FB_PAGESETPROC, TKORT_HK_PAGESET )
	if( p <> 0 ) then res = p( active, visible ) else res = tkrt_ConsolePageSet( active, visible )
	IOUNLOCK()
	return res
end function

end extern
