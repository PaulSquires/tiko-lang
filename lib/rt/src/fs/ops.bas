'' ops.bas -- the single-object filesystem operations: fourteen entry points
'' over one fbc member, split by platform. CreateDirAll, RemoveDirAll and
'' CopyDir are FreeBASIC built on these plus ListDir, and are not here.
''
'' WHERE THIS FILE KNOWS BETTER THAN THE OS CODE, IT SAYS SO. Windows reports
'' ERROR_ACCESS_DENIED for a wide range of unrelated causes -- deleting a
'' read-only file, opening a directory as a file -- and the shared mapping table
'' deliberately does not guess. The guessing happens here instead, per
'' operation, where the intent is known: RemoveFile checks for a directory and
'' for the read-only attribute BEFORE calling, so it can report
'' FS_IS_A_DIRECTORY and FS_READ_ONLY rather than a uniform "denied". POSIX does
'' the same for its own reasons: open( ) on a directory SUCCEEDS there and only
'' the read fails, and unlink reports EPERM on some systems and EISDIR on
'' others, so both are checked rather than mapped.
''
'' EINTR IS RETRIED IN THE READ AND WRITE LOOPS AND NOWHERE ELSE. The mapping
'' surfaces EINTR as FS_INTERRUPTED, because hiding a signal the program may
'' care about is not a library's decision -- but a partial-transfer loop is
'' already required here, so surfacing it would just make every caller write
'' this same loop. These are the promised exceptions.
''
'' A C FUNCTION MUST NOT ALLOCATE A TEMP DESCRIPTOR FOR ITS OWN USE, and the
'' same applies here. The FB caller only ever frees the descriptor RETURNED to
'' it, so an internally-allocated one leaks; the pool is 256 slots, so the leak
'' is completely invisible for 256 calls and then the temp directory comes back
'' EMPTY and every temp file is attempted at the drive root. That is why
'' hCreateTemp asks for the temp directory as a PLAIN BUFFER and never calls
'' fb_UStrFsTempDir.

#include once "inc/descriptors.bi"
#include once "inc/fserror.bi"
#include once "inc/fspath.bi"
#include once "inc/sysbind.bi"

extern "rtlib"
	declare function tkrt_FsMapOsError alias "fb_FsMapOsError" ( ) as long
end extern

extern "c"   '' NON-FBCALL: the ustring temp builder, declared plain.
	declare function tkrt_UStrAllocTemp alias "fb_hUStrAllocTemp" _
		( byval s as FBUSTRING ptr, byval units as integer ) as FBUSTRING ptr
	declare sub tkrt_UStrCopy2 alias "fb_hUStrCopy" _
		( byval dst as FB_UCHAR ptr, byval src as FB_UCHAR ptr, byval units as integer )
end extern

private sub hUArg( byval s as FBUSTRING ptr, byval ptr_ as FB_UCHAR ptr ptr, byval len_ as integer ptr )
	static as FB_UCHAR empty_(0 to 0) = { 0 }
	if( s = 0 ) then
		*ptr_ = @empty_(0) : *len_ = 0
	elseif( s->data = 0 ) then
		*ptr_ = @empty_(0) : *len_ = 0
	else
		*ptr_ = s->data
		*len_ = FB_USTRSIZE( s )
	end if
end sub

private function hTemp( byval src as FB_UCHAR ptr, byval units as integer ) as FBUSTRING ptr
	dim as FBUSTRING ptr dst = any
	if( units <= 0 ) then return TKORT_UNULL_DESC()
	dst = tkrt_UStrAllocTemp( 0, units )
	if( dst = 0 ) then return TKORT_UNULL_DESC()
	if( dst->data <> 0 ) then
		if( src <> 0 ) then tkrt_UStrCopy2( dst->data, src, units )
		dst->data[units] = 0
	end if
	return dst
end function

'' The hex alphabet the temp-name generator spells its 8 random bytes with.
private function hHexDigit( byval v as long ) as long
	if( v < 10 ) then return 48 + v
	return 97 + (v - 10)
end function

#if defined( __FB_WIN32__ ) or defined( __FB_WIN64__ )

'' ---------------------------------------------------------- Windows backend

const INVALID_HANDLE_VALUE_    = -1
const INVALID_FILE_ATTRIBUTES_ = &hFFFFFFFFul
const MAX_PATH_                = 260
const GENERIC_READ_            = &h80000000ul
const GENERIC_WRITE_           = &h40000000ul
const FILE_APPEND_DATA_        = &h00000004ul
const FILE_SHARE_READ_         = &h00000001ul
const FILE_SHARE_WRITE_        = &h00000002ul
const CREATE_NEW_              = 1
const CREATE_ALWAYS_           = 2
const OPEN_EXISTING_           = 3
const OPEN_ALWAYS_             = 4
const FILE_ATTRIBUTE_NORMAL_   = &h00000080ul
const FILE_ATTRIBUTE_READONLY_ = &h00000001ul
const FILE_ATTRIBUTE_DIRECTORY_ = &h00000010ul
const FILE_END_                = 2
const MOVEFILE_REPLACE_EXISTING_    = &h00000001ul
const REPLACEFILE_IGNORE_MERGE_ERRORS_ = &h00000002ul

'' The largest single ReadFile/WriteFile request. A DWORD would take 4 GB, but
'' a 256 MB chunk keeps the loop honest on a file bigger than the address space.
const IO_CHUNK_ = &h10000000ll

extern "c"   '' NON-FBCALL: kernel32 and advapi32 imports, not rtlib entry points.
	declare function w_CreateFileW stdcall alias "CreateFileW" _
		( byval n as wstring ptr, byval acc as ulong, byval share as ulong, byval sa as any ptr, _
		  byval disp as ulong, byval flags as ulong, byval templ as any ptr ) as any ptr
	declare function w_CloseHandle stdcall alias "CloseHandle" ( byval h as any ptr ) as long
	declare function w_GetFileSizeEx stdcall alias "GetFileSizeEx" ( byval h as any ptr, byval sz as longint ptr ) as long
	declare function w_ReadFile stdcall alias "ReadFile" _
		( byval h as any ptr, byval buf as any ptr, byval n as ulong, byval got as ulong ptr, byval ov as any ptr ) as long
	declare function w_WriteFile stdcall alias "WriteFile" _
		( byval h as any ptr, byval buf as any ptr, byval n as ulong, byval wrote as ulong ptr, byval ov as any ptr ) as long
	declare function w_SetFilePointer stdcall alias "SetFilePointer" _
		( byval h as any ptr, byval lo as long, byval hi as long ptr, byval whence as ulong ) as ulong
	declare function w_GetFileAttributesW stdcall alias "GetFileAttributesW" ( byval n as wstring ptr ) as ulong
	declare function w_SetFileAttributesW stdcall alias "SetFileAttributesW" _
		( byval n as wstring ptr, byval attrs as ulong ) as long
	declare function w_CreateDirectoryW stdcall alias "CreateDirectoryW" _
		( byval n as wstring ptr, byval sa as any ptr ) as long
	declare function w_RemoveDirectoryW stdcall alias "RemoveDirectoryW" ( byval n as wstring ptr ) as long
	declare function w_DeleteFileW stdcall alias "DeleteFileW" ( byval n as wstring ptr ) as long
	declare function w_CopyFileW stdcall alias "CopyFileW" _
		( byval s as wstring ptr, byval d as wstring ptr, byval failexists as long ) as long
	declare function w_MoveFileExW stdcall alias "MoveFileExW" _
		( byval s as wstring ptr, byval d as wstring ptr, byval flags as ulong ) as long
	declare function w_ReplaceFileW stdcall alias "ReplaceFileW" _
		( byval t as wstring ptr, byval r as wstring ptr, byval backup as wstring ptr, _
		  byval flags as ulong, byval x as any ptr, byval y as any ptr ) as long
	declare function w_GetTempPathW stdcall alias "GetTempPathW" ( byval cap as ulong, byval buf as wstring ptr ) as ulong
	declare function w_LoadLibraryW stdcall alias "LoadLibraryW" ( byval n as wstring ptr ) as any ptr
	declare function w_GetProcAddress stdcall alias "GetProcAddress" ( byval h as any ptr, byval n as zstring ptr ) as any ptr
end extern

type RTLGENRANDOM as function stdcall ( byval buf as any ptr, byval n as ulong ) as ubyte

private function hFsWide( byval p as FBUSTRING ptr ) as wstring ptr
	dim as FB_UCHAR ptr s = any
	dim as integer len_ = any
	dim as FB_UCHAR ptr w = any

	hUArg( p, @s, @len_ )
	w = malloc( (len_ + 1) * sizeof( FB_UCHAR ) )
	if( w = 0 ) then return 0
	if( len_ > 0 ) then memcpy( w, s, len_ * sizeof( FB_UCHAR ) )
	w[len_] = 0
	return cptr( wstring ptr, w )
end function

'' The temp directory as a PLAIN BUFFER, with NO descriptor allocated -- see the
'' file header. Returns the length in code units, or 0 on failure.
private function hTempDirWide( byval buf as FB_UCHAR ptr, byval cap as long ) as long
	dim as ulong n = w_GetTempPathW( cap, cptr( wstring ptr, buf ) )

	if( (n = 0) orelse (n > cap) ) then return 0

	'' GetTempPathW always ends with a separator; drop it so the result composes
	'' with PathJoin like every other path this module returns.
	while( (n > 1) andalso ((buf[n - 1] = 92) orelse (buf[n - 1] = 47)) )
		n -= 1
	wend

	buf[n] = 0
	return n
end function

extern "rtlib"

sub tkort_FsFreeBuf alias "fb_FsFreeBuf" ( byval b as any ptr )
	free( b )
end sub

function tkort_UStrFsReadWhole alias "fb_UStrFsReadWhole" _
	( byval p as FBUSTRING ptr, byval out_ as ubyte ptr ptr, byval outlen as longint ptr ) as long

	dim as wstring ptr w = any
	dim as any ptr h = any
	dim as longint sz = any, got = 0
	dim as ubyte ptr buf = any
	dim as ulong attrs = any, chunk = any, red = any
	dim as long e = any

	*out_ = 0
	*outlen = 0

	w = hFsWide( p )
	if( w = 0 ) then return FB_FS_UNKNOWN

	'' Checked BEFORE opening so a directory reports FS_IS_A_DIRECTORY. Windows
	'' has no such code natively and would say "access denied".
	attrs = w_GetFileAttributesW( w )
	if( (attrs <> INVALID_FILE_ATTRIBUTES_) andalso ((attrs and FILE_ATTRIBUTE_DIRECTORY_) <> 0) ) then
		free( w )
		return FB_FS_IS_A_DIRECTORY
	end if

	h = w_CreateFileW( w, GENERIC_READ_, FILE_SHARE_READ_ or FILE_SHARE_WRITE_, _
		0, OPEN_EXISTING_, FILE_ATTRIBUTE_NORMAL_, 0 )
	free( w )

	if( cast( integer, h ) = INVALID_HANDLE_VALUE_ ) then return tkrt_FsMapOsError( )

	if( w_GetFileSizeEx( h, @sz ) = 0 ) then
		e = tkrt_FsMapOsError( )
		w_CloseHandle( h )
		return e
	end if

	'' A file larger than the address space is FS_NO_SPACE, not a truncation and
	'' not a crash. FS_UNSUPPORTED was rejected: it reads as "never possible"
	'' when the same call succeeds on win64.
	''
	'' BOTH SIDES MUST BE UNSIGNED. Signed, this compares against -2, so EVERY
	'' file looks too large and reading a five-byte file fails with NO_SPACE.
	if( cast( ulongint, sz ) > cast( ulongint, cast( uinteger, -1 ) ) - 1 ) then
		w_CloseHandle( h )
		return FB_FS_NO_SPACE
	end if

	buf = malloc( cast( uinteger, sz ) + 1 )
	if( buf = 0 ) then
		w_CloseHandle( h )
		return FB_FS_NO_SPACE
	end if

	while( got < sz )
		dim as longint left_ = sz - got
		chunk = iif( left_ > IO_CHUNK_, cast( ulong, IO_CHUNK_ ), cast( ulong, left_ ) )
		red = 0

		if( w_ReadFile( h, buf + got, chunk, @red, 0 ) = 0 ) then
			e = tkrt_FsMapOsError( )
			free( buf )
			w_CloseHandle( h )
			return e
		end if

		'' short read: the file shrank under us
		if( red = 0 ) then exit while

		got += red
	wend

	w_CloseHandle( h )

	buf[got] = 0
	*out_ = buf
	*outlen = got
	return FB_FS_OK
end function

function tkort_UStrFsWriteWhole alias "fb_UStrFsWriteWhole" _
	( byval p as FBUSTRING ptr, byval data_ as ubyte ptr, byval len_ as longint, byval append_ as long ) as long

	dim as wstring ptr w = any
	dim as any ptr h = any
	dim as longint done = 0
	dim as ulong chunk = any, wrote = any
	dim as long e = any

	w = hFsWide( p )
	if( w = 0 ) then return FB_FS_UNKNOWN

	h = w_CreateFileW( w, iif( append_ <> 0, FILE_APPEND_DATA_, GENERIC_WRITE_ ), _
		FILE_SHARE_READ_, 0, iif( append_ <> 0, OPEN_ALWAYS_, CREATE_ALWAYS_ ), _
		FILE_ATTRIBUTE_NORMAL_, 0 )
	free( w )

	if( cast( integer, h ) = INVALID_HANDLE_VALUE_ ) then return tkrt_FsMapOsError( )

	if( append_ <> 0 ) then w_SetFilePointer( h, 0, 0, FILE_END_ )

	while( done < len_ )
		dim as longint left_ = len_ - done
		chunk = iif( left_ > IO_CHUNK_, cast( ulong, IO_CHUNK_ ), cast( ulong, left_ ) )
		wrote = 0

		if( w_WriteFile( h, data_ + done, chunk, @wrote, 0 ) = 0 ) then
			e = tkrt_FsMapOsError( )
			w_CloseHandle( h )
			return e
		end if

		done += wrote
	wend

	w_CloseHandle( h )
	return FB_FS_OK
end function

function tkort_UStrFsCreateDir alias "fb_UStrFsCreateDir" ( byval p as FBUSTRING ptr ) as long
	dim as wstring ptr w = hFsWide( p )
	dim as long r = FB_FS_OK

	if( w = 0 ) then return FB_FS_UNKNOWN
	if( w_CreateDirectoryW( w, 0 ) = 0 ) then r = tkrt_FsMapOsError( )
	free( w )
	return r
end function

function tkort_UStrFsRemoveDir alias "fb_UStrFsRemoveDir" ( byval p as FBUSTRING ptr ) as long
	dim as wstring ptr w = hFsWide( p )
	dim as long r = FB_FS_OK

	if( w = 0 ) then return FB_FS_UNKNOWN
	if( w_RemoveDirectoryW( w ) = 0 ) then r = tkrt_FsMapOsError( )
	free( w )
	return r
end function

'' Reports FS_IS_A_DIRECTORY and FS_READ_ONLY rather than letting both come back
'' as FS_ACCESS_DENIED. It does NOT clear the read-only attribute -- that is
'' RemoveDirAll's documented rm -rf behaviour, not the behaviour of deleting one
'' named file.
function tkort_UStrFsRemoveFile alias "fb_UStrFsRemoveFile" ( byval p as FBUSTRING ptr ) as long
	dim as wstring ptr w = hFsWide( p )
	dim as ulong attrs = any
	dim as long r = FB_FS_OK

	if( w = 0 ) then return FB_FS_UNKNOWN

	attrs = w_GetFileAttributesW( w )

	if( attrs <> INVALID_FILE_ATTRIBUTES_ ) then
		if( (attrs and FILE_ATTRIBUTE_DIRECTORY_) <> 0 ) then
			free( w )
			return FB_FS_IS_A_DIRECTORY
		end if
		if( (attrs and FILE_ATTRIBUTE_READONLY_) <> 0 ) then
			free( w )
			return FB_FS_READ_ONLY
		end if
	end if

	if( w_DeleteFileW( w ) = 0 ) then r = tkrt_FsMapOsError( )

	free( w )
	return r
end function

function tkort_UStrFsCopyFile alias "fb_UStrFsCopyFile" _
	( byval s as FBUSTRING ptr, byval d as FBUSTRING ptr, byval overwrite as long ) as long

	dim as wstring ptr ws = any, wd = any
	dim as long r = FB_FS_OK

	ws = hFsWide( s )
	wd = hFsWide( d )

	if( (ws = 0) orelse (wd = 0) ) then
		free( ws ) : free( wd )
		return FB_FS_UNKNOWN
	end if

	'' fail-if-exists is the DEFAULT. The legacy FileCopy overwrites
	'' unconditionally; that default has cost people data.
	if( w_CopyFileW( ws, wd, iif( overwrite <> 0, 0, 1 ) ) = 0 ) then r = tkrt_FsMapOsError( )

	free( ws ) : free( wd )
	return r
end function

'' The native rename only. The cross-volume copy-then-delete fallback lives in
'' the FB layer, because it needs CopyFile and RemoveFile and their error shapes.
function tkort_UStrFsMoveFile alias "fb_UStrFsMoveFile" _
	( byval s as FBUSTRING ptr, byval d as FBUSTRING ptr, byval overwrite as long ) as long

	dim as wstring ptr ws = any, wd = any
	dim as ulong flags = 0
	dim as long r = FB_FS_OK

	ws = hFsWide( s )
	wd = hFsWide( d )

	if( (ws = 0) orelse (wd = 0) ) then
		free( ws ) : free( wd )
		return FB_FS_UNKNOWN
	end if

	if( overwrite <> 0 ) then flags or= MOVEFILE_REPLACE_EXISTING_

	if( w_MoveFileExW( ws, wd, flags ) = 0 ) then r = tkrt_FsMapOsError( )

	free( ws ) : free( wd )
	return r
end function

'' ReplaceFileW, falling back to MoveFileExW. Guarantees a reader sees the old
'' or the new content and never a partial file; does NOT guarantee survival of
'' power loss -- WriteAtomic flushes the temp before calling this, and the
'' stronger durability guarantee is explicitly not on offer.
function tkort_UStrFsReplaceFile alias "fb_UStrFsReplaceFile" _
	( byval target as FBUSTRING ptr, byval replacement as FBUSTRING ptr ) as long

	dim as wstring ptr wt = any, wr = any
	dim as long r = FB_FS_OK

	wt = hFsWide( target )
	wr = hFsWide( replacement )

	if( (wt = 0) orelse (wr = 0) ) then
		free( wt ) : free( wr )
		return FB_FS_UNKNOWN
	end if

	if( w_ReplaceFileW( wt, wr, 0, REPLACEFILE_IGNORE_MERGE_ERRORS_, 0, 0 ) = 0 ) then
		'' ReplaceFileW requires the target to exist. For a first write it does
		'' not, and a plain replacing rename is then both correct and equally
		'' atomic.
		if( w_MoveFileExW( wr, wt, MOVEFILE_REPLACE_EXISTING_ ) = 0 ) then r = tkrt_FsMapOsError( )
	end if

	free( wt ) : free( wr )
	return r
end function

'' RtlGenRandom rather than BCryptGenRandom: advapi32 is already in the link
'' line, so this adds no new dependency, and it is reached through
'' GetProcAddress so a Windows build without it degrades rather than fails to
'' link.
function tkort_FsRandomBytes alias "fb_FsRandomBytes" ( byval buf as ubyte ptr, byval len_ as long ) as long
	static as RTLGENRANDOM pRtlGenRandom = 0
	static as long tried = 0

	if( tried = 0 ) then
		dim as any ptr h = w_LoadLibraryW( wstr( "advapi32.dll" ) )
		if( h <> 0 ) then pRtlGenRandom = cast( RTLGENRANDOM, w_GetProcAddress( h, @"SystemFunction036" ) )
		tried = 1
	end if

	if( pRtlGenRandom <> 0 ) then
		if( pRtlGenRandom( buf, cast( ulong, len_ ) ) <> 0 ) then return FB_FS_OK
	end if

	return FB_FS_UNSUPPORTED
end function

function tkort_UStrFsTempDir alias "fb_UStrFsTempDir" ( byval status as long ptr ) as FBUSTRING ptr
	dim as FB_UCHAR buf( 0 to MAX_PATH_ + 1 ) = any
	dim as long n = any

	if( status <> 0 ) then *status = FB_FS_OK

	n = hTempDirWide( @buf(0), MAX_PATH_ + 1 )
	if( n = 0 ) then
		if( status <> 0 ) then *status = tkrt_FsMapOsError( )
		return TKORT_UNULL_DESC()
	end if

	return hTemp( @buf(0), n )
end function

'' Builds <dir>\<prefix><16 hex digits> and creates it atomically. Retried on
'' collision a bounded number of times, then reported -- an unbounded retry on a
'' broken CSPRNG would hang instead of failing.
private function hCreateTemp( byval prefix as FBUSTRING ptr, byval wantdir as long, byval status as long ptr ) as FBUSTRING ptr
	dim as FB_UCHAR dirbuf( 0 to MAX_PATH_ + 1 ) = any
	dim as FB_UCHAR ptr pres = any, w = any
	dim as integer prelen = any
	dim as long dirlen = any, attempt = any, i = any, made = any, e = any
	dim as integer n = any
	dim as ubyte rb( 0 to 7 ) = any
	dim as any ptr h = any

	if( status <> 0 ) then *status = FB_FS_OK

	'' NO DESCRIPTOR ALLOCATED HERE -- see the file header.
	dirlen = hTempDirWide( @dirbuf(0), MAX_PATH_ + 1 )
	if( dirlen = 0 ) then
		if( status <> 0 ) then *status = tkrt_FsMapOsError( )
		return TKORT_UNULL_DESC()
	end if

	hUArg( prefix, @pres, @prelen )

	for attempt = 0 to 63
		if( tkort_FsRandomBytes( @rb(0), 8 ) <> FB_FS_OK ) then
			if( status <> 0 ) then *status = FB_FS_UNSUPPORTED
			return TKORT_UNULL_DESC()
		end if

		w = malloc( (dirlen + 1 + prelen + 16 + 1) * sizeof( FB_UCHAR ) )
		if( w = 0 ) then
			if( status <> 0 ) then *status = FB_FS_UNKNOWN
			return TKORT_UNULL_DESC()
		end if

		n = 0
		for i = 0 to dirlen - 1
			w[n] = dirbuf(i) : n += 1
		next
		w[n] = 92 : n += 1
		for i = 0 to prelen - 1
			w[n] = pres[i] : n += 1
		next

		for i = 0 to 7
			w[n] = hHexDigit( (rb(i) shr 4) and &hF ) : n += 1
			w[n] = hHexDigit( rb(i) and &hF ) : n += 1
		next
		w[n] = 0

		made = 0

		if( wantdir <> 0 ) then
			made = iif( w_CreateDirectoryW( cptr( wstring ptr, w ), 0 ) <> 0, 1, 0 )
		else
			'' CREATE_NEW is the atomic part: it fails if the name exists, so
			'' there is no window between choosing and creating.
			h = w_CreateFileW( cptr( wstring ptr, w ), GENERIC_WRITE_, 0, 0, CREATE_NEW_, _
				FILE_ATTRIBUTE_NORMAL_, 0 )
			if( cast( integer, h ) <> INVALID_HANDLE_VALUE_ ) then
				w_CloseHandle( h )
				made = 1
			end if
		end if

		if( made <> 0 ) then
			dim as FBUSTRING ptr res = hTemp( w, n )
			free( w )
			return res
		end if

		e = tkrt_FsMapOsError( )
		free( w )

		'' only a name collision is worth retrying
		if( e <> FB_FS_ALREADY_EXISTS ) then
			if( status <> 0 ) then *status = e
			return TKORT_UNULL_DESC()
		end if
	next

	if( status <> 0 ) then *status = FB_FS_ALREADY_EXISTS
	return TKORT_UNULL_DESC()
end function

function tkort_UStrFsCreateTempFile alias "fb_UStrFsCreateTempFile" _
	( byval prefix as FBUSTRING ptr, byval status as long ptr ) as FBUSTRING ptr
	return hCreateTemp( prefix, 0, status )
end function

function tkort_UStrFsCreateTempDir alias "fb_UStrFsCreateTempDir" _
	( byval prefix as FBUSTRING ptr, byval status as long ptr ) as FBUSTRING ptr
	return hCreateTemp( prefix, 1, status )
end function

'' The MINIMUM SLICE of the permissions RFC that RemoveDirAll needs: rm -rf must
'' clear the read-only attribute or it fails partway through a checked-out
'' repository.
function tkort_UStrFsSetReadOnly alias "fb_UStrFsSetReadOnly" _
	( byval p as FBUSTRING ptr, byval v as long ) as long

	dim as wstring ptr w = hFsWide( p )
	dim as ulong attrs = any
	dim as long r = FB_FS_OK

	if( w = 0 ) then return FB_FS_UNKNOWN

	attrs = w_GetFileAttributesW( w )
	if( attrs = INVALID_FILE_ATTRIBUTES_ ) then
		free( w )
		return tkrt_FsMapOsError( )
	end if

	if( v <> 0 ) then
		attrs or= FILE_ATTRIBUTE_READONLY_
	else
		attrs and= not FILE_ATTRIBUTE_READONLY_
	end if

	if( w_SetFileAttributesW( w, attrs ) = 0 ) then r = tkrt_FsMapOsError( )

	free( w )
	return r
end function

end extern

#else

'' ------------------------------------------------------------ POSIX backend
''
'' struct stat on linux-x86_64: st_dev 0, st_ino 8, st_mode 24, st_size 48.
const STAT_BUF_SIZE = 144
const STAT_DEV_     = 0
const STAT_INO_     = 8
const STAT_MODE_    = 24
const STAT_SIZE_    = 48

const S_IFMT_  = &o170000
const S_IFDIR_ = &o040000
const S_IWUSR_ = &o000200
const S_IWGRP_ = &o000020
const S_IWOTH_ = &o000002

const O_RDONLY_ = &o0
const O_WRONLY_ = &o1
const O_CREAT_  = &o100
const O_EXCL_   = &o200
const O_TRUNC_  = &o1000
const O_APPEND_ = &o2000

const EINTR_ = 4

const SYS_getrandom_ = 318

const COPY_CHUNK_ = 65536

type stat_
	as ubyte raw( 0 to STAT_BUF_SIZE - 1 )
end type

extern "c"   '' NON-FBCALL: libc, not rtlib entry points.
	declare function u_open alias "open" ( byval p as zstring ptr, byval flags as long, ... ) as long
	declare function u_close alias "close" ( byval fd as long ) as long
	declare function u_read alias "read" ( byval fd as long, byval buf as any ptr, byval n as uinteger ) as integer
	declare function u_write alias "write" ( byval fd as long, byval buf as any ptr, byval n as uinteger ) as integer
	declare function u_fstat alias "fstat" ( byval fd as long, byval st as stat_ ptr ) as long
	declare function u_stat alias "stat" ( byval p as zstring ptr, byval st as stat_ ptr ) as long
	declare function u_lstat alias "lstat" ( byval p as zstring ptr, byval st as stat_ ptr ) as long
	declare function u_mkdir alias "mkdir" ( byval p as zstring ptr, byval mode_ as ulong ) as long
	declare function u_rmdir alias "rmdir" ( byval p as zstring ptr ) as long
	declare function u_unlink alias "unlink" ( byval p as zstring ptr ) as long
	declare function u_rename alias "rename" ( byval s as zstring ptr, byval d as zstring ptr ) as long
	declare function u_chmod alias "chmod" ( byval p as zstring ptr, byval mode_ as ulong ) as long
	declare function u_umask alias "umask" ( byval m as ulong ) as ulong
	declare function u_getenv alias "getenv" ( byval n as zstring ptr ) as zstring ptr
	declare function u_strlen alias "strlen" ( byval s as zstring ptr ) as uinteger
	declare function u_errno_location alias "__errno_location" ( ) as long ptr
	declare function u_syscall alias "syscall" ( byval n as longint, ... ) as longint
	declare function u_utf16to8 alias "fb_hUtf16ToUtf8" _
		( byval src as FB_UCHAR ptr, byval units as integer, byval dst as zstring ptr, byval cap as integer ) as integer
	declare function u_utf8to16 alias "fb_hUtf8ToUtf16" _
		( byval src as zstring ptr, byval bytes as integer, byval dst as FB_UCHAR ptr, byval cap as integer ) as integer
end extern

#define TKORT_ERRNO (*u_errno_location( ))

private function hFsNarrow( byval p as FBUSTRING ptr ) as zstring ptr
	dim as FB_UCHAR ptr s = any
	dim as integer len_ = any, cap = any, n = any
	dim as zstring ptr b = any

	hUArg( p, @s, @len_ )
	cap = len_ * 3 + 1
	b = malloc( cap )
	if( b = 0 ) then return 0
	n = u_utf16to8( s, len_, b, cap - 1 )
	if( n < 0 ) then n = 0
	b[n] = 0
	return b
end function

private function hFsFromNarrow( byval b as zstring ptr, byval bytes as integer ) as FBUSTRING ptr
	dim as FB_UCHAR ptr tmp = any
	dim as FBUSTRING ptr res = any
	dim as integer cap = any, n = any, nb = bytes

	if( nb < 0 ) then nb = u_strlen( b )
	if( nb <= 0 ) then return TKORT_UNULL_DESC()

	cap = nb + 1
	tmp = malloc( cap * sizeof( FB_UCHAR ) )
	if( tmp = 0 ) then return TKORT_UNULL_DESC()

	n = u_utf8to16( b, nb, tmp, cap )
	if( n < 0 ) then n = 0

	res = hTemp( tmp, n )
	free( tmp )
	return res
end function

'' The temp directory as a PLAIN STRING, with no descriptor allocated -- see the
'' file header.
private function hTempDirNarrow( ) as zstring ptr
	dim as zstring ptr t = u_getenv( @"TMPDIR" )
	if( t = 0 ) then return @"/tmp"
	if( t[0] = 0 ) then return @"/tmp"
	return t
end function

extern "rtlib"

sub tkort_FsFreeBuf alias "fb_FsFreeBuf" ( byval b as any ptr )
	free( b )
end sub

function tkort_UStrFsReadWhole alias "fb_UStrFsReadWhole" _
	( byval p as FBUSTRING ptr, byval out_ as ubyte ptr ptr, byval outlen as longint ptr ) as long

	dim as zstring ptr path_ = any
	dim as stat_ st = any
	dim as ubyte ptr buf = any
	dim as longint sz = any, got = 0
	dim as long fd = any, e = any
	dim as integer n = any

	*out_ = 0
	*outlen = 0

	path_ = hFsNarrow( p )
	if( path_ = 0 ) then return FB_FS_UNKNOWN

	fd = u_open( path_, O_RDONLY_ )
	if( fd < 0 ) then
		e = tkrt_FsMapOsError( )
		free( path_ )
		return e
	end if

	free( path_ )

	if( u_fstat( fd, @st ) <> 0 ) then
		e = tkrt_FsMapOsError( )
		u_close( fd )
		return e
	end if

	'' POSIX open( ) on a directory SUCCEEDS; only the read fails, and with
	'' EISDIR. Checked here so the code is FS_IS_A_DIRECTORY either way and the
	'' two platforms agree.
	if( (*cptr( ulong ptr, @st.raw(STAT_MODE_) ) and S_IFMT_) = S_IFDIR_ ) then
		u_close( fd )
		return FB_FS_IS_A_DIRECTORY
	end if

	sz = *cptr( longint ptr, @st.raw(STAT_SIZE_) )

	if( cast( ulongint, sz ) > cast( ulongint, cast( uinteger, -1 ) ) - 1 ) then
		u_close( fd )
		return FB_FS_NO_SPACE
	end if

	buf = malloc( cast( uinteger, sz ) + 1 )
	if( buf = 0 ) then
		u_close( fd )
		return FB_FS_NO_SPACE
	end if

	while( got < sz )
		n = u_read( fd, buf + got, cast( uinteger, sz - got ) )

		if( n < 0 ) then
			'' the promised retry
			if( TKORT_ERRNO = EINTR_ ) then continue while

			e = tkrt_FsMapOsError( )
			free( buf )
			u_close( fd )
			return e
		end if

		'' the file shrank under us
		if( n = 0 ) then exit while

		got += n
	wend

	u_close( fd )

	buf[got] = 0
	*out_ = buf
	*outlen = got
	return FB_FS_OK
end function

function tkort_UStrFsWriteWhole alias "fb_UStrFsWriteWhole" _
	( byval p as FBUSTRING ptr, byval data_ as ubyte ptr, byval len_ as longint, byval append_ as long ) as long

	dim as zstring ptr path_ = any
	dim as longint done = 0
	dim as long fd = any, flags = any, e = any
	dim as integer n = any

	path_ = hFsNarrow( p )
	if( path_ = 0 ) then return FB_FS_UNKNOWN

	flags = O_WRONLY_ or O_CREAT_ or iif( append_ <> 0, O_APPEND_, O_TRUNC_ )

	fd = u_open( path_, flags, &o666 )
	free( path_ )

	if( fd < 0 ) then return tkrt_FsMapOsError( )

	while( done < len_ )
		n = u_write( fd, data_ + done, cast( uinteger, len_ - done ) )

		if( n < 0 ) then
			if( TKORT_ERRNO = EINTR_ ) then continue while

			e = tkrt_FsMapOsError( )
			u_close( fd )
			return e
		end if

		done += n
	wend

	if( u_close( fd ) <> 0 ) then return tkrt_FsMapOsError( )

	return FB_FS_OK
end function

function tkort_UStrFsCreateDir alias "fb_UStrFsCreateDir" ( byval p as FBUSTRING ptr ) as long
	dim as zstring ptr path_ = hFsNarrow( p )
	dim as long r = FB_FS_OK

	if( path_ = 0 ) then return FB_FS_UNKNOWN
	if( u_mkdir( path_, &o777 ) <> 0 ) then r = tkrt_FsMapOsError( )
	free( path_ )
	return r
end function

function tkort_UStrFsRemoveDir alias "fb_UStrFsRemoveDir" ( byval p as FBUSTRING ptr ) as long
	dim as zstring ptr path_ = hFsNarrow( p )
	dim as long r = FB_FS_OK

	if( path_ = 0 ) then return FB_FS_UNKNOWN

	if( u_rmdir( path_ ) <> 0 ) then
		r = tkrt_FsMapOsError( )

		'' POSIX permits either ENOTEMPTY or EEXIST here, and the shared table
		'' maps EEXIST to FS_ALREADY_EXISTS because that is right for every
		'' other call. This operation knows better -- the same rule the Windows
		'' table applies to ERROR_ACCESS_DENIED.
		if( r = FB_FS_ALREADY_EXISTS ) then r = FB_FS_DIR_NOT_EMPTY
	end if

	free( path_ )
	return r
end function

function tkort_UStrFsRemoveFile alias "fb_UStrFsRemoveFile" ( byval p as FBUSTRING ptr ) as long
	dim as zstring ptr path_ = hFsNarrow( p )
	dim as stat_ st = any
	dim as long r = FB_FS_OK

	if( path_ = 0 ) then return FB_FS_UNKNOWN

	'' Matches the Windows behaviour: a directory is FS_IS_A_DIRECTORY, not
	'' whatever unlink happens to report (EPERM on some systems, EISDIR on
	'' others -- neither is portable).
	if( u_lstat( path_, @st ) = 0 ) then
		if( (*cptr( ulong ptr, @st.raw(STAT_MODE_) ) and S_IFMT_) = S_IFDIR_ ) then
			free( path_ )
			return FB_FS_IS_A_DIRECTORY
		end if
	end if

	if( u_unlink( path_ ) <> 0 ) then r = tkrt_FsMapOsError( )

	free( path_ )
	return r
end function

'' No POSIX copy syscall, so this is an explicit loop. copy_file_range and
'' reflinks are a candidate optimisation, not a feature -- each needs this exact
'' fallback anyway.
function tkort_UStrFsCopyFile alias "fb_UStrFsCopyFile" _
	( byval s as FBUSTRING ptr, byval d as FBUSTRING ptr, byval overwrite as long ) as long

	dim as zstring ptr sp = any, dp = any
	dim as stat_ st = any
	dim as ubyte buf( 0 to COPY_CHUNK_ - 1 ) = any
	dim as long sfd = any, dfd = any, flags = any, r = FB_FS_OK
	dim as ulong mode_ = any
	dim as integer n = any, w = any, k = any

	sp = hFsNarrow( s )
	dp = hFsNarrow( d )

	if( (sp = 0) orelse (dp = 0) ) then
		free( sp ) : free( dp )
		return FB_FS_UNKNOWN
	end if

	sfd = u_open( sp, O_RDONLY_ )
	if( sfd < 0 ) then
		r = tkrt_FsMapOsError( )
		free( sp ) : free( dp )
		return r
	end if

	if( u_fstat( sfd, @st ) <> 0 ) then
		mode_ = &o666
	else
		mode_ = *cptr( ulong ptr, @st.raw(STAT_MODE_) )
	end if

	'' O_EXCL is what makes "do not overwrite" the default and atomic.
	flags = O_WRONLY_ or O_CREAT_ or iif( overwrite <> 0, O_TRUNC_, O_EXCL_ )

	dfd = u_open( dp, flags, mode_ and &o777 )
	if( dfd < 0 ) then
		r = tkrt_FsMapOsError( )
		u_close( sfd )
		free( sp ) : free( dp )
		return r
	end if

	do
		n = u_read( sfd, @buf(0), COPY_CHUNK_ )

		if( n < 0 ) then
			if( TKORT_ERRNO = EINTR_ ) then continue do
			r = tkrt_FsMapOsError( )
			exit do
		end if

		if( n = 0 ) then exit do

		w = 0
		while( w < n )
			k = u_write( dfd, @buf(w), cast( uinteger, n - w ) )
			if( k < 0 ) then
				if( TKORT_ERRNO = EINTR_ ) then continue while
				r = tkrt_FsMapOsError( )
				exit while
			end if
			w += k
		wend

		if( r <> FB_FS_OK ) then exit do
	loop

	u_close( sfd )
	if( (u_close( dfd ) <> 0) andalso (r = FB_FS_OK) ) then r = tkrt_FsMapOsError( )

	free( sp ) : free( dp )
	return r
end function

function tkort_UStrFsMoveFile alias "fb_UStrFsMoveFile" _
	( byval s as FBUSTRING ptr, byval d as FBUSTRING ptr, byval overwrite as long ) as long

	dim as zstring ptr sp = any, dp = any
	dim as stat_ st = any
	dim as long r = FB_FS_OK

	sp = hFsNarrow( s )
	dp = hFsNarrow( d )

	if( (sp = 0) orelse (dp = 0) ) then
		free( sp ) : free( dp )
		return FB_FS_UNKNOWN
	end if

	'' rename(2) always replaces. Refusing to overwrite therefore has to be a
	'' separate check, and it is inherently racy -- documented rather than
	'' pretended away.
	if( overwrite = 0 ) then
		if( u_lstat( dp, @st ) = 0 ) then
			free( sp ) : free( dp )
			return FB_FS_ALREADY_EXISTS
		end if
	end if

	if( u_rename( sp, dp ) <> 0 ) then r = tkrt_FsMapOsError( )

	free( sp ) : free( dp )
	return r
end function

'' rename(2) gives exactly the guarantee WriteAtomic needs: a reader sees the
'' old file or the new one, never a partial.
function tkort_UStrFsReplaceFile alias "fb_UStrFsReplaceFile" _
	( byval target as FBUSTRING ptr, byval replacement as FBUSTRING ptr ) as long
	return tkort_UStrFsMoveFile( replacement, target, 1 )
end function

'' Identity for WalkDir's FollowSymlinks visited set. stat, not lstat: the walk
'' wants the identity of what it would DESCEND INTO, which for a link is its
'' target -- that is what could form a cycle.
''
'' It lives in this file rather than fs/stat.bas because fbc puts it in
'' fs_ops.o on POSIX and in fs_stat.o on Windows, and the gate replaces fbc
'' MEMBERS: a symbol on the wrong side would leave the other member half-covered.
function tkort_UStrFsIdentity alias "fb_UStrFsIdentity" _
	( byval p as FBUSTRING ptr, byval vol as ulongint ptr, byval id as ulongint ptr ) as long

	dim as zstring ptr path_ = any
	dim as stat_ st = any
	dim as long e = any

	*vol = 0
	*id = 0

	path_ = hFsNarrow( p )
	if( path_ = 0 ) then return FB_FS_UNKNOWN

	if( u_stat( path_, @st ) <> 0 ) then
		e = tkrt_FsMapOsError( )
		free( path_ )
		return e
	end if

	free( path_ )

	*vol = *cptr( ulongint ptr, @st.raw(STAT_DEV_) )
	*id  = *cptr( ulongint ptr, @st.raw(STAT_INO_) )
	return FB_FS_OK
end function

'' NEVER the program's own Rnd, which is seeded predictably and shared with the
'' caller -- a guessable temp name is a real attack.
function tkort_FsRandomBytes alias "fb_FsRandomBytes" ( byval buf as ubyte ptr, byval len_ as long ) as long
	dim as long got = 0, fd = any
	dim as longint n = any
	dim as integer k = any

	while( got < len_ )
		n = u_syscall( SYS_getrandom_, buf + got, cast( uinteger, len_ - got ), 0 )
		if( n < 0 ) then
			if( TKORT_ERRNO = EINTR_ ) then continue while
			'' fall through to /dev/urandom
			exit while
		end if
		got += cast( long, n )
	wend

	if( got >= len_ ) then return FB_FS_OK

	'' Fallback for kernels without getrandom.
	fd = u_open( @"/dev/urandom", O_RDONLY_ )
	if( fd < 0 ) then return FB_FS_UNSUPPORTED

	got = 0
	while( got < len_ )
		k = u_read( fd, buf + got, cast( uinteger, len_ - got ) )
		if( k < 0 ) then
			if( TKORT_ERRNO = EINTR_ ) then continue while
			exit while
		end if
		if( k = 0 ) then exit while
		got += k
	wend

	u_close( fd )
	return iif( got >= len_, FB_FS_OK, FB_FS_UNSUPPORTED )
end function

function tkort_UStrFsTempDir alias "fb_UStrFsTempDir" ( byval status as long ptr ) as FBUSTRING ptr
	if( status <> 0 ) then *status = FB_FS_OK
	return hFsFromNarrow( hTempDirNarrow( ), -1 )
end function

private function hCreateTemp( byval prefix as FBUSTRING ptr, byval wantdir as long, byval status as long ptr ) as FBUSTRING ptr
	dim as zstring ptr dir_ = any, pre = any, full = any
	dim as ubyte rb( 0 to 7 ) = any
	dim as long attempt = any, i = any, made = any, e = any, fd = any
	dim as uinteger n = any, at = any

	if( status <> 0 ) then *status = FB_FS_OK

	'' NO DESCRIPTOR ALLOCATED HERE -- see the file header.
	dir_ = hTempDirNarrow( )
	pre = hFsNarrow( prefix )

	if( pre = 0 ) then
		if( status <> 0 ) then *status = FB_FS_UNKNOWN
		return TKORT_UNULL_DESC()
	end if

	for attempt = 0 to 63
		if( tkort_FsRandomBytes( @rb(0), 8 ) <> FB_FS_OK ) then
			free( pre )
			if( status <> 0 ) then *status = FB_FS_UNSUPPORTED
			return TKORT_UNULL_DESC()
		end if

		n = u_strlen( dir_ ) + 1 + u_strlen( pre ) + 16 + 1
		full = malloc( n )
		if( full = 0 ) then
			free( pre )
			if( status <> 0 ) then *status = FB_FS_UNKNOWN
			return TKORT_UNULL_DESC()
		end if

		at = 0
		for i = 0 to cast( long, u_strlen( dir_ ) ) - 1
			full[at] = dir_[i] : at += 1
		next
		full[at] = 47 : at += 1
		for i = 0 to cast( long, u_strlen( pre ) ) - 1
			full[at] = pre[i] : at += 1
		next

		for i = 0 to 7
			full[at] = hHexDigit( (rb(i) shr 4) and &hF ) : at += 1
			full[at] = hHexDigit( rb(i) and &hF ) : at += 1
		next
		full[at] = 0

		made = 0

		if( wantdir <> 0 ) then
			made = iif( u_mkdir( full, &o700 ) = 0, 1, 0 )
		else
			'' O_EXCL is the atomic part: no window between choosing the name
			'' and creating the file. 0600, because a world-readable temp file
			'' is the other half of the same mistake.
			fd = u_open( full, O_WRONLY_ or O_CREAT_ or O_EXCL_, &o600 )
			if( fd >= 0 ) then
				u_close( fd )
				made = 1
			end if
		end if

		if( made <> 0 ) then
			dim as FBUSTRING ptr res = hFsFromNarrow( full, cast( integer, at ) )
			free( full )
			free( pre )
			return res
		end if

		e = tkrt_FsMapOsError( )
		free( full )

		if( e <> FB_FS_ALREADY_EXISTS ) then
			free( pre )
			if( status <> 0 ) then *status = e
			return TKORT_UNULL_DESC()
		end if
	next

	free( pre )

	if( status <> 0 ) then *status = FB_FS_ALREADY_EXISTS
	return TKORT_UNULL_DESC()
end function

function tkort_UStrFsCreateTempFile alias "fb_UStrFsCreateTempFile" _
	( byval prefix as FBUSTRING ptr, byval status as long ptr ) as FBUSTRING ptr
	return hCreateTemp( prefix, 0, status )
end function

function tkort_UStrFsCreateTempDir alias "fb_UStrFsCreateTempDir" _
	( byval prefix as FBUSTRING ptr, byval status as long ptr ) as FBUSTRING ptr
	return hCreateTemp( prefix, 1, status )
end function

'' On POSIX "read-only" is "no write bit for the calling user", so clearing it
'' restores the write bits subject to the current umask -- which means this is
'' NOT an exact inverse. A caller needing exactness uses SetPosixMode.
function tkort_UStrFsSetReadOnly alias "fb_UStrFsSetReadOnly" _
	( byval p as FBUSTRING ptr, byval v as long ) as long

	dim as zstring ptr path_ = hFsNarrow( p )
	dim as stat_ st = any
	dim as ulong m = any, mask = any
	dim as long r = FB_FS_OK

	if( path_ = 0 ) then return FB_FS_UNKNOWN

	if( u_stat( path_, @st ) <> 0 ) then
		r = tkrt_FsMapOsError( )
		free( path_ )
		return r
	end if

	m = *cptr( ulong ptr, @st.raw(STAT_MODE_) )

	if( v <> 0 ) then
		m and= not cast( ulong, S_IWUSR_ or S_IWGRP_ or S_IWOTH_ )
	else
		mask = u_umask( 0 )
		u_umask( mask )
		m or= (cast( ulong, S_IWUSR_ or S_IWGRP_ or S_IWOTH_ ) and (not mask))
	end if

	if( u_chmod( path_, m ) <> 0 ) then r = tkrt_FsMapOsError( )

	free( path_ )
	return r
end function

end extern

#endif
