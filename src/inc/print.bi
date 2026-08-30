#ifndef __TKORT_PRINT_BI__
#define __TKORT_PRINT_BI__

'' print.bi -- the PRINT masks, the newline and padding constants, and the
'' handle-dereference rule.
''
'' THE NEWLINE IS PER-PLATFORM AND THE TAB WIDTH IS NOT.
''
''     FB_NEWLINE          "\r\n" on Windows, "\n" on Linux
''     FB_BINARY_NEWLINE   CRLF on BOTH -- so PRINT to a BINARY file emits CRLF
''                         on Linux, where PRINT to the console emits LF
''     FB_TAB_WIDTH        14 EVERYWHERE
''
'' The 14 matters more than it looks: fbc defines FB_NATIVE_TAB only when the tab
'' width is 8, so with 14 the comma-padding in PRINT never emits a real tab
'' character. It space-fills to the next multiple of 14 instead, and a port that
'' emitted "\t" would be wrong on every target while looking more natural.

#include once "inc/descriptors.bi"
#include once "inc/file.bi"

'' The high-level bits, set by the PRINT statement itself.
const FB_PRINT_NEWLINE      = &h00000001
const FB_PRINT_PAD          = &h00000002
const FB_PRINT_BIN_NEWLINE  = &h00000004
const FB_PRINT_APPEND_SPACE = &h00000010
const FB_PRINT_HLMASK       = &h00000003

const FB_TAB_WIDTH = 14

#if defined( __FB_WIN32__ ) or defined( __FB_WIN64__ )
	#define TKORT_NEWLINE     !"\r\n"
	#define TKORT_NEWLINE_LEN 2
#else
	#define TKORT_NEWLINE     !"\n"
	#define TKORT_NEWLINE_LEN 1
#endif

'' THE BINARY NEWLINE IS CRLF ON BOTH PLATFORMS, and that is not a slip in fbc's
'' headers -- unix/fb_unix.h defines FB_NEWLINE as LF and FB_BINARY_NEWLINE as
'' CRLF two lines apart. PRINT to a file opened FOR BINARY therefore emits CRLF
'' on Linux, where PRINT to the console emits LF. Deriving one from the other is
'' the obvious simplification and it is wrong on one target.
#define TKORT_BIN_NEWLINE     !"\r\n"
#define TKORT_BIN_NEWLINE_LEN 2

'' Follow a redirection chain to the handle that actually writes.
''
'' OPEN "SCRN:" builds a handle whose redirection_to points at another, so every
'' entry point that inspects a handle's STATE -- line_length and width, which is
'' all of the padding logic -- has to deref first. Writing goes to the original
'' handle; only the geometry comes from the target.
private function tkort_HandleDeref( byval h as FB_FILE ptr ) as FB_FILE ptr
	if( h = 0 ) then return 0
	'' The chain is walked under the lock in fbc. Nothing here mutates it, and
	'' the callers below already hold the lock where it matters.
	while( h->redirection_to <> 0 )
		h = h->redirection_to
	wend
	return h
end function

#endif '' __TKORT_PRINT_BI__
