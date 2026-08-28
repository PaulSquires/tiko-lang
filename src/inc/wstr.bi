#ifndef __TKORT_WSTR_BI__
#define __TKORT_WSTR_BI__

'' wstr.bi -- the wide-character primitives, as macros.
''
'' fb_unicode.h declares these as `static __inline__`, and 21 of the 38 inline
'' helpers in the whole runtime live there. RFC-0004 section 3.3 names this the
'' single most likely place for FreeBASIC to lose, because fbc has no inliner and
'' every one of them would otherwise become a real call inside a per-character
'' loop.
''
'' So they are #macro here, which is the mitigation that RFC-0003 section 5.2
'' specifies and the only one fully under our control.
''
'' PROVENANCE NOTE. These are written from the DECLARATIONS -- name, signature
'' and the contract the name states -- not by transcribing the inline bodies out
'' of the header. A one-line `static __inline__` body is closer to implementation
'' than to interface, and PROVENANCE.md's permission covers "interfaces, layouts,
'' macro contracts". The differentials are what check the result, which is the
'' project's method everywhere else.

#include once "inc/descriptors.bi"

'' A wide character is 2 bytes on Windows and 4 on Linux -- never assume, and
'' never reinterpret a buffer as UTF-16 (RFC-0003 section 5.5).
#define TKORT_WCHAR_SIZE (sizeof(wstring) )

'' Characters between two pointers into the same buffer.
#define FB_WSTR_CALCDIFF( ini, end ) _
	( cast( integer, cast( ubyte ptr, end ) - cast( ubyte ptr, ini ) ) \ TKORT_WCHAR_SIZE )

'' Allocate room for `chars` characters plus the terminator.
''
'' Plain malloc, because the caller frees the result through fb_WstrDelete, which
'' is still fbc's C and frees with free(). Anything cleverer here is a heap bug.
#define FB_WSTR_ALLOCTEMP( chars ) _
	cptr( wstring ptr, allocate( ((chars) + 1) * TKORT_WCHAR_SIZE ) )

#define FB_WSTR_DEL( s )    deallocate( s )
#define FB_WSTR_LEN( s )    cast( integer, wcslen( s ) )

'' Copy `chars` characters and terminate.
#macro FB_WSTR_COPY( dst, src, chars )
	memcpy( dst, src, (chars) * TKORT_WCHAR_SIZE )
	(dst)[ chars ] = 0
#endmacro

#endif '' __TKORT_WSTR_BI__
