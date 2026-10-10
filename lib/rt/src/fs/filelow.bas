'' filelow.bas -- the low-level file helpers: path conversion, system flush,
'' truncate, byte-range locking, standard-stream recovery, and the INKEY string
'' builder. Seven symbols across six fbc members.
''
'' EVERY ONE OF THESE IS THE PLATFORM SEAM. The portable layer above them --
'' io/devfile.bas, io/file.bas -- calls them for the four things stdio cannot
'' do, and each has a Windows body and a POSIX one that share no code at all.
''
'' PATH CONVERSION IS ONE-WAY PER PLATFORM. Windows turns '/' into '\\' and POSIX
'' turns '\\' into '/', so a path is normalised TOWARDS the host rather than away
'' from a canonical form. `C:\dir/file` works on both; `dir\file` becomes
'' `dir/file` on Linux and is then a filename with no backslash in it, which is
'' NOT the same file as one genuinely called `dir\file`. That is fbc's rule and
'' programs depend on it.
''
'' THE POSIX LOCK IS ALWAYS A WRITE LOCK, AND THAT IS AN fbc BUG REPRODUCED.
'' The C reads
''
''     if( fcntl( fd, F_GETFL ) & O_RDONLY )  lck.l_type = F_RDLCK;
''     else                                   lck.l_type = F_WRLCK;
''
'' and O_RDONLY IS ZERO. The test can never be true, so a read-only handle takes
'' a write lock -- which fails with EBADF on a descriptor opened O_RDONLY. Fixing
'' it here would make tiko-rt succeed where fbc reports error 3.
''
'' AND THE TWO PLATFORMS LOCK DIFFERENT THINGS. POSIX fcntl locks are ADVISORY
'' and per-process; Windows LockFile is MANDATORY and enforced by the kernel. The
'' same program is genuinely more locked on Windows, and nothing in the runtime
'' hides that.
''
'' F_SETLKW BLOCKS. The POSIX side waits for a conflicting lock to clear rather
'' than failing, so `LOCK #1, 1 TO 8` on a file another process holds hangs until
'' it lets go. Windows' LockFile returns immediately with a failure. Also fbc's,
'' also not hidden.
''
'' RESETTING THE STANDARD STREAMS REOPENS THE TERMINAL BY NAME -- "/dev/tty" on
'' POSIX, "CONIN$"/"CONOUT$" on Windows -- which is what makes it work after the
'' program's own stdout was redirected. The Windows side must also drop and
'' re-read the console HANDLE CACHE, because the old handle refers to the
'' redirected file.
''
'' fb_hMakeInkeyStr BUILDS A ONE- OR TWO-BYTE STRING, and the two-byte form is
'' LOW BYTE FIRST: an extended key 0x4800 becomes CHR(0, 72). Every INKEY caller
'' tests LEN() to tell the two apart, so the order and the length are both the
'' contract.

#include once "inc/descriptors.bi"
#include once "inc/rterror.bi"
#include once "inc/sysbind.bi"

extern "rtlib"
	declare function tkrt_ErrorSetNum alias "fb_ErrorSetNum" ( byval e as long ) as long
end extern

'' fb_CHR IS NOT FBCALL, AND THE ARCHIVE IS WHAT SAYS SO: win32 spells it
'' `_fb_CHR` with NO `@N`, so it is cdecl there like everywhere else. fb.h
'' decorates it FBCALL, but a VARIADIC stdcall is impossible -- the callee cannot
'' know how much to pop -- so gcc silently demotes it, and the decoration in the
'' header is a lie the linker corrects. Declaring it EXTERN "rtlib" here is
'' rejected outright ("vararg parameters are only allowed in CDECL procedures"),
'' which is fbc-modern refusing to emit the same lie.
extern "c"   '' NON-FBCALL: variadic, hence cdecl on every target.
	declare function tkrt_CHR alias "fb_CHR" ( byval argc as long, ... ) as FBSTRING ptr
end extern

extern "c"   '' NON-FBCALL: libc and the Win32 API.
	declare function crt_fileno alias "fileno" ( byval f as FILE ptr ) as long
'' _fseeki64 / _ftelli64 ON THE MICROSOFT ABI. There is no fseeko in the UCRT:
'' the 64-bit seek pair is spelled with a leading underscore and an i64 suffix
'' there. Same signature and same meaning, a different name. TKORT_MSVC comes
'' from build.sh -- see src/sys/sys.bi for why fbc cannot tell us itself.
#ifdef TKORT_MSVC
	declare function crt_ftello alias "_ftelli64" ( byval f as FILE ptr ) as longint
#else
	declare function crt_ftello alias "ftello" ( byval f as FILE ptr ) as longint
#endif
	declare function crt_freopen alias "freopen" _
		( byval path as zstring ptr, byval mode_ as zstring ptr, byval f as FILE ptr ) as FILE ptr
end extern

#ifdef __FB_WIN32__

	extern "c"   '' NON-FBCALL: the MSVCRT handle bridge, spelled without the
	             '' leading underscore in fbc's source and WITH one in the
	             '' import library.
		declare function crt_get_osfhandle alias "_get_osfhandle" ( byval fd as long ) as any ptr
	end extern

	extern "c"   '' NON-FBCALL: kernel32 imports, not rtlib entry points. The
	             '' convention is per-declaration `stdcall`, which fbc-modern
	             '' ignores on win64 and honours on win32 -- the house idiom, and
	             '' the same one inc/console.bi uses. EXTERN "Windows" would say
	             '' the same thing and the lint refuses it, because it is one
	             '' keyword away from EXTERN "rtlib" and means something else.
		declare function FlushFileBuffers_ stdcall alias "FlushFileBuffers" ( byval h as any ptr ) as long
		declare function SetEndOfFile_ stdcall alias "SetEndOfFile" ( byval h as any ptr ) as long
		declare function LockFile_ stdcall alias "LockFile" _
			( byval h as any ptr, byval offlo as ulong, byval offhi as ulong, _
			  byval lenlo as ulong, byval lenhi as ulong ) as long
		declare function UnlockFile_ stdcall alias "UnlockFile" _
			( byval h as any ptr, byval offlo as ulong, byval offhi as ulong, _
			  byval lenlo as ulong, byval lenhi as ulong ) as long
	end extern

	extern "c"   '' NON-FBCALL: fbc's own console handle cache.
		declare sub tkrt_hConsoleResetHandles alias "fb_hConsoleResetHandles" ( )
		declare function tkrt_hConsoleGetHandle alias "fb_hConsoleGetHandle" ( byval is_input as long ) as any ptr
	end extern

#else

	'' struct flock, MEASURED under WSL against glibc: sizeof 32, l_type 0,
	'' l_whence 2, l_start 8, l_len 16, l_pid 24. Bound as fields rather than a
	'' raw buffer because every one of the first four is written.
	type FLOCK_
		as short l_type
		as short l_whence
		as long  pad0_
		as longint l_start
		as longint l_len
		as long  l_pid
		as long  pad1_
	end type

	#assert sizeof( FLOCK_ ) = 32
	#assert offsetof( FLOCK_, l_start ) = 8
	#assert offsetof( FLOCK_, l_len ) = 16

	'' Measured with the same probe.
	const F_GETFL_  = 3
	const F_SETLKW_ = 7
	const F_RDLCK_  = 0
	const F_WRLCK_  = 1
	const F_UNLCK_  = 2
	const O_RDONLY_ = 0
	const SEEK_SET_ = 0

	extern "c"   '' NON-FBCALL: libc.
		declare function u_fsync alias "fsync" ( byval fd as long ) as long
		declare function u_ftruncate alias "ftruncate" ( byval fd as long, byval length_ as longint ) as long
		'' fcntl IS VARIADIC -- 'int fcntl( int fd, int cmd, ... )' -- and is declared so,
		'' once. Two fixed declarations under one alias, two arguments and three, were
		'' the same symbol twice: tiko keys a declaration by its link name and refused the
		'' three-argument call (TKO0993, 'calls fcntl with 3 arguments, which declares 2')
		'' when tiko first built this runtime on Linux (2026-10-10). And on x86-64 SysV a
		'' variadic callee expects %al set, which only a variadic call site does.
		declare function u_fcntl alias "fcntl" ( byval fd as long, byval cmd as long, ... ) as long
	end extern

#endif

'' ------------------------------------------------------- the path converter

extern "c"   '' NON-FBCALL: fb_file.h declares fb_hConvertPath plainly.

'' IN PLACE, ONE BYTE AT A TIME, and only in the host's direction -- see the
'' file header on why that is not symmetric.
sub tkort_hConvertPath alias "fb_hConvertPath" ( byval path as zstring ptr )

	dim as ubyte ptr p = cast( ubyte ptr, path )
	dim as integer length_ = strlen( path )

	for i as integer = 0 to length_ - 1
		#ifdef __FB_WIN32__
			if( p[i] = 47 ) then p[i] = 92          '' '/' -> '\'
		#else
			if( p[i] = 92 ) then p[i] = 47          '' '\' -> '/'
		#endif
	next
end sub

'' ------------------------------------------------------------ system flush

'' NOT fflush. That empties the CRT's buffer into the OS; this asks the OS to
'' commit to the medium, which is the difference between surviving a crash and
'' surviving a power cut.
function tkort_hFileFlushEx alias "fb_hFileFlushEx" ( byval f as FILE ptr ) as long

	#ifdef __FB_WIN32__
		if( FlushFileBuffers_( crt_get_osfhandle( crt_fileno( f ) ) ) = 0 ) then
			return tkrt_ErrorSetNum( FB_RTERROR_FILEIO )
		end if
	#else
		if( u_fsync( crt_fileno( f ) ) <> 0 ) then
			return tkrt_ErrorSetNum( FB_RTERROR_FILEIO )
		end if
	#endif

	return tkrt_ErrorSetNum( FB_RTERROR_OK )
end function

'' ------------------------------------------------------------ set end of file

'' TRUNCATES AT THE CURRENT POSITION. POSIX reads the position and passes it to
'' ftruncate; Windows' SetEndOfFile takes the handle's own position and needs no
'' argument -- so the ftello is a POSIX-only step and not a shared one.
function tkort_hFileSetEofEx alias "fb_hFileSetEofEx" ( byval f as FILE ptr ) as long

	#ifdef __FB_WIN32__
		if( SetEndOfFile_( crt_get_osfhandle( crt_fileno( f ) ) ) = 0 ) then
			return tkrt_ErrorSetNum( FB_RTERROR_FILEIO )
		end if
	#else
		dim as longint pos_ = crt_ftello( f )
		if( u_ftruncate( crt_fileno( f ), pos_ ) <> 0 ) then
			return tkrt_ErrorSetNum( FB_RTERROR_FILEIO )
		end if
	#endif

	return tkrt_ErrorSetNum( FB_RTERROR_OK )
end function

'' ------------------------------------------------------------------ locking

#ifndef __FB_WIN32__

'' THE READ-LOCK BRANCH IS DEAD CODE AND IS KEPT DEAD. `fcntl(fd, F_GETFL) &
'' O_RDONLY` with O_RDONLY == 0 is always false, so every lock is a WRITE lock --
'' see the file header. Reproduced exactly.
private function hDoLock( byval f as FILE ptr, byval lock_ as long, _
                          byval inipos as longint, byval size_ as longint ) as long

	dim as FLOCK_ lck
	dim as long fd = crt_fileno( f )

	if( lock_ <> 0 ) then
		if( (u_fcntl( fd, F_GETFL_ ) and O_RDONLY_) <> 0 ) then
			lck.l_type = F_RDLCK_
		else
			lck.l_type = F_WRLCK_
		end if
	else
		lck.l_type = F_UNLCK_
	end if

	lck.l_whence = SEEK_SET_
	lck.l_start = inipos
	lck.l_len = size_

	'' F_SETLKW BLOCKS until a conflicting lock clears.
	return tkrt_ErrorSetNum( iif( u_fcntl( fd, F_SETLKW_, @lck ) <> 0, _
	                              FB_RTERROR_FILEIO, FB_RTERROR_OK ) )
end function

#endif

function tkort_hFileLock alias "fb_hFileLock" _
	( byval f as FILE ptr, byval inipos as longint, byval size_ as longint ) as long

	#ifdef __FB_WIN32__
		'' THE OFFSET AND LENGTH ARE SPLIT INTO TWO 32-BIT HALVES, and fbc
		'' passes ZERO for both high halves -- so a lock past 4 GB silently
		'' wraps. Reproduced.
		return tkrt_ErrorSetNum( iif( LockFile_( crt_get_osfhandle( crt_fileno( f ) ), _
		                                         cast( ulong, inipos ), 0, _
		                                         cast( ulong, size_ ), 0 ) <> 0, _
		                              FB_RTERROR_OK, FB_RTERROR_FILEIO ) )
	#else
		return hDoLock( f, 1, inipos, size_ )
	#endif
end function

function tkort_hFileUnlock alias "fb_hFileUnlock" _
	( byval f as FILE ptr, byval inipos as longint, byval size_ as longint ) as long

	#ifdef __FB_WIN32__
		return tkrt_ErrorSetNum( iif( UnlockFile_( crt_get_osfhandle( crt_fileno( f ) ), _
		                                           cast( ulong, inipos ), 0, _
		                                           cast( ulong, size_ ), 0 ) <> 0, _
		                              FB_RTERROR_OK, FB_RTERROR_FILEIO ) )
	#else
		return hDoLock( f, 0, inipos, size_ )
	#endif
end function

'' ------------------------------------------------------- the stream reset

'' REOPENS THE TERMINAL BY NAME, which is what makes it work after the program's
'' own stdout was redirected -- freopen on the existing FILE* would just reopen
'' the redirection target.
''
'' RETURNS A BOOLEAN, not an error code: the caller in io/fileinput.bas turns it
'' into FB_RTERROR_OK or FB_RTERROR_FILEIO.
function tkort_hFileResetEx alias "fb_hFileResetEx" ( byval streamno as long ) as long

	dim as FILE ptr f = any

	#ifdef __FB_WIN32__
		'' THE HANDLE CACHE MUST GO FIRST. The cached console handle refers to
		'' the redirection target, so reopening without dropping it would leave
		'' every later console call pointed at the old file.
		tkrt_hConsoleResetHandles( )

		if( streamno = 0 ) then
			f = crt_freopen( @"CONIN$", @"r", stdin )
		else
			f = crt_freopen( @"CONOUT$", @"w", stdout )
		end if

		'' And re-read it NOW rather than lazily, so the next call does not
		'' find an empty cache mid-print.
		tkrt_hConsoleGetHandle( -1 )
	#else
		if( streamno = 0 ) then
			f = crt_freopen( @"/dev/tty", @"r", stdin )
		else
			f = crt_freopen( @"/dev/tty", @"w", stdout )
		end if
	#endif

	return iif( f <> 0, 1, 0 )
end function

'' ------------------------------------------------------- the INKEY string

'' ONE BYTE, OR TWO WITH THE LOW BYTE FIRST. An extended key arrives as a 16-bit
'' code and comes out as CHR(low, high) -- 0x4800 becomes CHR(0, 72) -- so every
'' caller tells the two apart by LEN(), and both the order and the length are the
'' contract.
function tkort_hMakeInkeyStr alias "fb_hMakeInkeyStr" ( byval key as long ) as FBSTRING ptr

	if( key > &hFF ) then
		return tkrt_CHR( 2, (key and &hFF), (key shr 8) )
	end if

	return tkrt_CHR( 1, key )
end function

end extern
