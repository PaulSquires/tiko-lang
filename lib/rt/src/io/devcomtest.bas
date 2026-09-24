'' devcomtest.bas -- the COM device-string test. Two entry points, one fbc
'' member.
''
'' PURE, LIKE dev_lpt's PARSER AND UNLIKE THE REST OF THE COM FAMILY. It takes a
'' string and answers yes or no plus a port number; it opens nothing, so it is
'' the one part of the serial layer a differential can drive completely.
''
'' THE "NOT COM" CASE IS THE SURPRISE AND IT IS NOT A TYPO. A filename that does
'' NOT begin with "COM" is accepted whenever it contains a COLON ANYWHERE:
''
''     if( strncasecmp( filename, "COM", 3 ) != 0 )
''         return strchr( filename, ':' ) != NULL;
''
'' So "SCRN:" tests TRUE here, and so does "C:\file". The COM device is not the
'' only one consulted -- fbc asks each device in turn and the first to claim the
'' string wins -- but this one claims a great deal more than COM ports, and any
'' caller reading it as "is this a COM port" is wrong.
''
'' "SER:" IS TESTED FIRST AND SEPARATELY, and it reports port 1 -- there is no
'' number in the string to read, so 1 is a constant. It is also the ONLY prefix
'' checked before the length test, so "SER:" is accepted where a four-character
'' minimum would otherwise be the first hurdle.
''
'' AND "COM:" WITH NO NUMBER IS VALID, giving port ZERO. fbc's source carries the
'' rejection commented out with the reason -- `removed to allow for open com
'' "COM:"` -- so a zero port is a real answer and not a failure code. A caller
'' that tests `port <> 0` rejects a string this function accepted.
''
'' THE PORT NUMBER HAS NO UPPER BOUND AND NO OVERFLOW CHECK. "COM99999999999:"
'' accumulates until it wraps, silently. fbc's, reproduced.
''
'' pPort IS ZEROED ON ENTRY, before anything can fail -- so a caller that ignores
'' the return value reads 0 rather than stale memory. That is the one defensive
'' thing this function does.

#include once "inc/descriptors.bi"
#include once "inc/file.bi"
#include once "inc/sysbind.bi"

extern "c"   '' NON-FBCALL: libc's case-insensitive compare, spelled
             '' `strncasecmp` on POSIX and `_strnicmp` in MSVCRT -- but MinGW
             '' provides the POSIX name on Windows too, which is why one
             '' declaration serves all three targets.
	'' _strnicmp / _stricmp ON THE MICROSOFT ABI. The UCRT has no strncasecmp or
	'' strcasecmp -- they are POSIX names, and MSVC spells the pair with a leading
	'' underscore and an i. Same signature and same meaning, a different name, and
	'' the same shape as the fseeko/ftello rename. TKORT_MSVC comes from build.sh;
	'' see src/sys/sys.bi for why fbc cannot tell us itself.
	#ifdef TKORT_MSVC
	declare function crt_strncasecmp alias "_strnicmp" _
		( byval a as zstring ptr, byval b as zstring ptr, byval n as uinteger ) as long
	#else
	declare function crt_strncasecmp alias "strncasecmp" _
		( byval a as zstring ptr, byval b as zstring ptr, byval n as uinteger ) as long
	#endif
end extern

extern "c"   '' NON-FBCALL: fb_serial.h declares both plainly, and the win32
             '' archive confirms no `@N` on either.

'' RETURNS FB_TRUE/FB_FALSE -- which are C's 1 and 0 here, NOT FreeBASIC's -1 and
'' 0. fb.h defines both spellings a few lines apart and this file uses the C one;
'' a caller comparing against -1 never matches.
function tkort_DevComTestProtocolEx alias "fb_DevComTestProtocolEx" _
	( byval handle as any ptr, byval filename as zstring ptr, _
	  byval filename_len as uinteger, byval pPort as uinteger ptr ) as long

	dim as ubyte ch = any
	dim as uinteger i = any, port = any

	'' ZEROED BEFORE ANYTHING CAN FAIL -- see the file header.
	if( pPort <> 0 ) then *pPort = 0

	'' AND A NULL FILENAME IS REJECTED BEFORE THE FIRST COMPARE, because the two
	'' CRTs disagree about what a NULL argument to a case-insensitive compare is:
	''
	''   MinGW    strncasecmp( NULL, "SER:", 4 )   returns, non-zero
	''   UCRT     _strnicmp(   NULL, "SER:", 4 )   INVALID PARAMETER HANDLER,
	''                                             process terminated
	''
	'' An empty FreeBASIC string has a NULL `data`, so `fb_DevComTestProtocolEx(
	'' 0, strptr( s ), 0, @port )` on `s = ""` reaches here with NULL every time
	'' -- and hostinfo-parity's subject died at exactly that line while the
	'' reference printed ` [] ->  0`. Measured with `_strnicmp` declared by hand
	'' on x86_64-pc-windows-msvc: the print before it appears and the one after
	'' it does not.
	''
	'' The guard is not a behaviour change: NULL cannot match "SER:" and a NULL
	'' filename always carries length 0, so the `filename_len < 4` test two lines
	'' down was already going to return 0 on the platform that survives.
	if( filename = 0 ) then return 0

	'' "SER:" FIRST, and before the length test.
	if( crt_strncasecmp( filename, @"SER:", 4 ) = 0 ) then
		if( pPort <> 0 ) then *pPort = 1
		return 1
	end if

	if( filename_len < 4 ) then return 0

	'' AND HERE IS THE WIDE NET: anything without a "COM" prefix is claimed if it
	'' has a colon anywhere at all. See the file header.
	if( crt_strncasecmp( filename, @"COM", 3 ) <> 0 ) then
		return iif( strchr( filename, 58 ) <> 0, 1, 0 )     '' ':'
	end if

	'' THE DIGITS AFTER "COM", WITH NO BOUND AND NO OVERFLOW CHECK.
	port = 0
	i = 3
	ch = filename[i]
	while( (ch >= 48) andalso (ch <= 57) )                 '' '0'..'9'
		port = port * 10 + (ch - 48)
		i += 1
		ch = filename[i]
	wend

	'' THE ZERO-PORT REJECTION IS DELIBERATELY ABSENT so that "COM:" opens --
	'' fbc removed it and said why. Port 0 is a valid answer.

	if( ch <> 58 ) then return 0                            '' ':'

	if( pPort <> 0 ) then *pPort = port

	return 1
end function

'' The yes/no form: the same test with the port discarded.
function tkort_DevComTestProtocol alias "fb_DevComTestProtocol" _
	( byval handle as any ptr, byval filename as zstring ptr, _
	  byval filename_len as uinteger ) as long

	return tkort_DevComTestProtocolEx( handle, filename, filename_len, 0 )
end function

end extern
