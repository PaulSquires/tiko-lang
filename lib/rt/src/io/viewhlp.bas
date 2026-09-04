'' viewhlp.bas -- the VIEW PRINT row window: four entry points over one fbc
'' member.
''
'' TWO FILE-SCOPE STATICS, LAZILY INITIALISED TO -1. Neither is read before it
'' has been resolved, and -1 is the "not yet asked" marker rather than a row.
'' The laziness is load-bearing: fb_ConsoleGetBotRow calls fb_GetSize, which
'' initialises the console, so resolving it eagerly at startup would open a
'' console for a program that never prints.
''
'' THE TWO GETTERS RETURN 0-BASED ROWS AND fb_ConsoleGetView RETURNS 1-BASED.
'' That is not an inconsistency to tidy up: the internal callers index a row
'' array, while VIEW PRINT is a BASIC statement whose rows start at 1. Making
'' them agree would shift the window by one at exactly one of the two layers.
''
'' A ZERO HEIGHT FALLS BACK TO 24, not to -1 or 0. fb_GetSize reports 0 rows
'' when there is no console at all -- a redirected or detached process -- and
'' a bottom row of -1 there would make every VIEW PRINT range empty.

#include once "inc/descriptors.bi"

const FB_SCRN_DEFAULT_HEIGHT = 25

extern "rtlib"
	declare sub tkrt_GetSize alias "fb_GetSize" ( byval cols as long ptr, byval rows as long ptr )
end extern

'' -1 means "not resolved yet"; see the header.
dim shared as long view_toprow = -1
dim shared as long view_botrow = -1

'' NON-FBCALL: fb.h declares all four of these plain.
extern "c"   '' NON-FBCALL: console helpers, no FBCALL marker in fb.h.

function tkort_ConsoleGetTopRow alias "fb_ConsoleGetTopRow" ( ) as long
	if( view_toprow = -1 ) then view_toprow = 0
	return view_toprow
end function

function tkort_ConsoleGetBotRow alias "fb_ConsoleGetBotRow" ( ) as long
	if( view_botrow = -1 ) then
		'' Asked for the ROW COUNT and converted to a 0-based last row.
		tkrt_GetSize( 0, @view_botrow )
		if( view_botrow <> 0 ) then
			view_botrow -= 1
		else
			view_botrow = FB_SCRN_DEFAULT_HEIGHT - 1
		end if
	end if
	return view_botrow
end function

'' Sets both directly, WITHOUT the lazy resolution above -- a caller that
'' establishes the window has already decided both rows.
sub tkort_ConsoleSetTopBotRows alias "fb_ConsoleSetTopBotRows" _
	( byval top_ as long, byval bot as long )
	view_toprow = top_
	view_botrow = bot
end sub

'' 1-BASED, unlike the two getters it calls. See the header.
sub tkort_ConsoleGetView alias "fb_ConsoleGetView" _
	( byval toprow as long ptr, byval botrow as long ptr )
	*toprow = tkort_ConsoleGetTopRow( ) + 1
	*botrow = tkort_ConsoleGetBotRow( ) + 1
end sub

end extern
