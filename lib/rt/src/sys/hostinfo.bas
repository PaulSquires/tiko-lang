'' hostinfo.bas -- the small per-target system singletons: the executable's path
'' and name, the current directory, free memory, and SLEEP. Five symbols across
'' five fbc members, each one entry point and each one system call.
''
'' NOT ONE OF THESE IS PORTABLE, and the Windows and Linux bodies share no logic
'' at all. They are grouped because each is too small to be a file, not because
'' they have anything in common.
''
'' fb_hGetExePath AND fb_hGetExeName RETURN A POINTER INTO dst, NOT dst. Both
'' fill the caller's buffer with the full path and then return a pointer to the
'' interesting part of it -- the name returns a pointer to the basename, the path
'' returns the pointer to the separator it just overwrote with a NUL. So the
'' caller reads the DIRECTORY from dst and the NAME from the return value, and
'' the two overlap in one buffer.
''
'' AND THE RETURN IS NULL ON FAILURE, but dst may still have been written. On
'' Linux both fail together when /proc is absent; on Windows GetModuleFileName
'' cannot fail for the current process, so the NULL return there means only
'' "there was no backslash in the path".
''
'' THE DRIVE-LETTER SPECIAL CASE IN fb_hGetExePath IS WINDOWS-ONLY AND IS NOT
'' COSMETIC. An executable in `C:\prog.exe` leaves `C:` after the separator is
'' cut, and `C:` as a directory means "the current directory ON drive C" -- a
'' RELATIVE path. The `C:\` it is rewritten to is absolute. Getting this wrong
'' produces a program that works from one directory and not another.
''
'' fb_hGetExePath KEEPS THE ROOT SLASH ON LINUX. An executable in `/prog` would
'' otherwise leave the empty string; the check `p = dst` writes the NUL one byte
'' later so the answer is "/" and not "".
''
'' fb_GetMemAvail IGNORES ITS mode ARGUMENT on both targets. FRE(x) in QB took a
'' mode; here every value gives free physical memory.
''
'' fb_Delay ON POSIX IS A select() WITH NO DESCRIPTORS, which is the portable way
'' to sleep with sub-second resolution without pulling in nanosleep's EINTR
'' contract. It is NOT restarted on a signal -- a delay interrupted by one
'' returns early, on both platforms and in fbc too.

#include once "inc/descriptors.bi"
#include once "crt/string.bi"

#ifdef __FB_WIN32__

	extern "c"   '' NON-FBCALL: kernel32 imports, `stdcall` per declaration --
	             '' the house idiom, as in inc/console.bi.
		declare function w_GetModuleFileNameA stdcall alias "GetModuleFileNameA" _
			( byval hm as any ptr, byval buf as zstring ptr, byval sz as ulong ) as ulong
		declare function w_GetModuleHandleA stdcall alias "GetModuleHandleA" _
			( byval name_ as zstring ptr ) as any ptr
		declare function w_GetCurrentDirectoryA stdcall alias "GetCurrentDirectoryA" _
			( byval sz as ulong, byval buf as zstring ptr ) as ulong
		declare sub w_Sleep stdcall alias "Sleep" ( byval ms as ulong )
		declare sub w_GlobalMemoryStatus stdcall alias "GlobalMemoryStatus" ( byval p as any ptr )
	end extern

	'' MEMORYSTATUS, and the FIRST field must be filled in by the CALLER --
	'' GlobalMemoryStatus uses dwLength to tell the struct version apart, and a
	'' zero there gets nothing back. It is 32 bytes on both win32 and win64
	'' because every field is a DWORD or a SIZE_T... except that SIZE_T is 8
	'' bytes on win64, so it is NOT. Bound as a raw buffer with the offset
	'' measured rather than assumed.
	type MEMSTATUS_
		#if defined( __FB_64BIT__ )
			as ulong  dwLength
			as ulong  dwMemoryLoad
			as ulongint dwTotalPhys
			as ulongint dwAvailPhys
			as ulongint dwTotalPageFile
			as ulongint dwAvailPageFile
			as ulongint dwTotalVirtual
			as ulongint dwAvailVirtual
		#else
			as ulong dwLength
			as ulong dwMemoryLoad
			as ulong dwTotalPhys
			as ulong dwAvailPhys
			as ulong dwTotalPageFile
			as ulong dwAvailPageFile
			as ulong dwTotalVirtual
			as ulong dwAvailVirtual
		#endif
	end type

#else

	'' timeval, and its shape is the whole reason fb_Delay is written this way:
	'' two pointer-width fields on x86-64 Linux.
	type TIMEVAL_
		as longint tv_sec
		as longint tv_usec
	end type

	#assert sizeof( TIMEVAL_ ) = 16

	extern "c"   '' NON-FBCALL: libc.
		declare function u_getcwd alias "getcwd" ( byval buf as zstring ptr, byval sz as uinteger ) as zstring ptr
		declare function u_readlink alias "readlink" _
			( byval path as zstring ptr, byval buf as zstring ptr, byval sz as uinteger ) as integer
		declare function u_select alias "select" _
			( byval n as long, byval r as any ptr, byval w as any ptr, _
			  byval e as any ptr, byval tv as TIMEVAL_ ptr ) as long
		declare function u_get_avphys_pages alias "get_avphys_pages" ( ) as integer
		declare function u_sysconf alias "sysconf" ( byval name_ as long ) as integer
		declare function u_getpid alias "getpid" ( ) as long
		declare function u_snprintf alias "snprintf" _
			( byval buf as zstring ptr, byval sz as uinteger, byval fmt as zstring ptr, ... ) as long
	end extern

	'' _SC_PAGE_SIZE, MEASURED under WSL against glibc -- the name is a macro and
	'' the number is not the same on every libc.
	const SC_PAGE_SIZE_ = 30

#endif

extern "c"   '' NON-FBCALL for the two helpers; fb_system.h declares
             '' fb_hGetExePath, fb_hGetExeName and fb_hGetCurrentDir plainly.

'' maxlen INCLUDES THE TERMINATOR and must be at least 1. Nothing checks that.
function tkort_hGetExePath alias "fb_hGetExePath" _
	( byval dst as zstring ptr, byval maxlen as integer ) as zstring ptr

	#ifdef __FB_WIN32__
		w_GetModuleFileNameA( w_GetModuleHandleA( 0 ), dst, cast( ulong, maxlen ) )

		dim as zstring ptr p = strrchr( dst, 92 )      '' '\'
		if( p <> 0 ) then
			p[0] = 0
		else
			dst[0] = 0
		end if

		'' THE DRIVE-LETTER CASE -- see the file header on why `C:` is a
		'' relative path and `C:\` is not.
		if( (maxlen > 3) andalso (dst[2] = 0) andalso (dst[1] = 58) ) then   '' ':'
			dim as long c = dst[0] and (not 32)         '' upper-case it
			if( (c >= 65) andalso (c <= 90) ) then      '' 'A'..'Z'
				dst[2] = 92
				dst[3] = 0
			end if
		end if

		return p
	#else
		'' NO stat() FIRST. fbc stats /proc/self/exe and then readlinks it; the
		'' stat adds nothing a failing readlink would not report, and dropping a
		'' syscall changes no observable answer. The readlink's own failure is
		'' the test.
		dim as integer l = u_readlink( @"/proc/self/exe", dst, maxlen - 1 )
		if( l < 0 ) then return 0

		dst[l] = 0
		dim as zstring ptr p = strrchr( dst, 47 )     '' '/'
		if( p = dst ) then
			'' THE ROOT SLASH IS KEPT -- "/" and not "".
			p[1] = 0
		elseif( p <> 0 ) then
			p[0] = 0
		else
			dst[0] = 0
		end if

		return p
	#endif
end function

function tkort_hGetExeName alias "fb_hGetExeName" _
	( byval dst as zstring ptr, byval maxlen as integer ) as zstring ptr

	#ifdef __FB_WIN32__
		w_GetModuleFileNameA( w_GetModuleHandleA( 0 ), dst, cast( ulong, maxlen ) )

		dim as zstring ptr p = strrchr( dst, 92 )
		if( p <> 0 ) then
			'' ONE PAST THE SEPARATOR, and the separator is LEFT IN PLACE --
			'' unlike fb_hGetExePath, which overwrites it. So dst still holds
			'' the whole path here.
			p += 1
		else
			p = dst
		end if

		return p
	#else
		'' BY PID, not "self". fbc spells the link `/proc/<pid>/exe` here and
		'' `/proc/self/exe` in fb_hGetExePath -- the same file by two names, and
		'' the difference is reproduced because a container or a ptrace sandbox
		'' can make exactly one of the two fail.
		dim as zstring * 1024 linkname = any
		u_snprintf( @linkname, 1024, @"/proc/%d/exe", u_getpid( ) )

		dim as integer l = u_readlink( @linkname, dst, maxlen - 1 )
		if( l < 0 ) then return 0

		dst[l] = 0
		dim as zstring ptr p = strrchr( dst, 47 )
		if( p <> 0 ) then
			p += 1
		else
			p = dst
		end if

		return p
	#endif
end function

'' RETURNS A LENGTH, not a pointer, and ZERO ON FAILURE on both targets -- so a
'' caller cannot tell an error from an empty answer, and an empty answer is
'' impossible, which is what makes zero unambiguous in practice.
function tkort_hGetCurrentDir alias "fb_hGetCurrentDir" _
	( byval dst as zstring ptr, byval maxlen as integer ) as integer

	#ifdef __FB_WIN32__
		'' GetCurrentDirectory TAKES THE SIZE FIRST and returns the length
		'' WITHOUT the terminator -- or the length WITH it if the buffer was too
		'' small, which is the one case where the return exceeds maxlen. Not
		'' distinguished here, because fbc does not distinguish it either.
		return cast( integer, w_GetCurrentDirectoryA( cast( ulong, maxlen ), dst ) )
	#else
		if( u_getcwd( dst, cast( uinteger, maxlen ) ) <> 0 ) then
			return strlen( dst )
		end if
		return 0
	#endif
end function

end extern

extern "rtlib"   '' FBCALL: fb_GetMemAvail and fb_Delay are both decorated in
                 '' fb_system.h and fb_hook.h, and the win32 archive confirms
                 '' the `@N` suffix on both.

'' mode IS IGNORED. QB's FRE took one; here every value gives free physical
'' memory, and a caller passing -1 gets the same answer as one passing 0.
function tkort_GetMemAvail alias "fb_GetMemAvail" ( byval mode_ as long ) as uinteger

	#ifdef __FB_WIN32__
		dim as MEMSTATUS_ ms = any
		'' dwLength IS THE VERSION TAG and must be set before the call.
		ms.dwLength = sizeof( MEMSTATUS_ )
		w_GlobalMemoryStatus( @ms )
		return cast( uinteger, ms.dwAvailPhys )
	#else
		'' PAGES TIMES PAGE SIZE. get_avphys_pages is glibc's, not POSIX's --
		'' which is why this body is under linux/ in fbc and not unix/.
		return cast( uinteger, u_get_avphys_pages( ) * u_sysconf( SC_PAGE_SIZE_ ) )
	#endif
end function

'' NOT RESTARTED ON A SIGNAL on either platform -- an interrupted delay returns
'' early. See the file header.
sub tkort_Delay alias "fb_Delay" ( byval msecs as long )

	#ifdef __FB_WIN32__
		w_Sleep( cast( ulong, msecs ) )
	#else
		'' select() WITH NO DESCRIPTORS is the sleep. n = 0 and three NULL sets
		'' means "wait for the timeout and nothing else".
		dim as TIMEVAL_ tv = any
		tv.tv_sec = msecs \ 1000
		tv.tv_usec = (msecs mod 1000) * 1000
		u_select( 0, 0, 0, 0, @tv )
	#endif
end sub

end extern
