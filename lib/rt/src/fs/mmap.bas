'' mmap.bas -- memory-mapped files: five entry points over one fbc member,
'' split by platform.
''
'' Data( ) HANDS OUT A RAW POINTER, which is the entire point of the facility:
'' the alternative is a copy, and a copy is just reading the file. The
'' consequences are documented rather than defended against, because no library
'' can defend against them:
''
''   - the pointer is invalid after Close
''   - another process TRUNCATING the file turns reads into a structured
''     exception on Windows and SIGBUS on POSIX, not an error return
''   - mapping a file on a network share is permitted and is a good way to hang
''
'' A ZERO-LENGTH FILE CANNOT BE MAPPED, and BOTH PLATFORMS REPORT THE SAME
'' CODE for it. CreateFileMapping rejects a zero size and mmap rejects a zero
'' length with EINVAL; each side returns INVALID_PATH explicitly so the refusal
'' reads the same everywhere. Handing back an empty Data() that could not be
'' dereferenced would be worse than a clear refusal.
''
'' The mapped-address local is `vw`, not `view`: VIEW is a FreeBASIC statement,
'' and like PRESET, RUN, FRAC, ABSOLUTE and WIDTH before it the clash is
'' reported at the first USE rather than at the declaration.
''
'' TEARDOWN IS THE REVERSE OF CREATION -- vw, then mapping, then file.
'' Closing the file first leaves a vw referencing a closed handle, which
'' happens to work and is exactly the kind of thing that stops working.

#include once "inc/descriptors.bi"
#include once "inc/fserror.bi"
#include once "inc/fspath.bi"
#include once "crt/stdlib.bi"
#include once "crt/string.bi"

extern "rtlib"
	declare function tkrt_FsMapOsError alias "fb_FsMapOsError" ( ) as long
end extern

'' Unpack a USTRING argument through FB_USTRSIZE, never ->len raw: the temp
'' flag lives in the sign bit.
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

#if defined( __FB_WIN32__ ) or defined( __FB_WIN64__ )

'' ---------------------------------------------------------- Windows backend

type FB_FSMAP
	as any ptr    hfile
	as any ptr    hmap
	as ubyte ptr  data_
	as ulongint   size_
	as long       writable
end type

const INVALID_HANDLE_VALUE_ = -1
const GENERIC_READ_    = &h80000000ul
const GENERIC_WRITE_   = &h40000000ul
const FILE_SHARE_READ_  = &h00000001ul
const FILE_SHARE_WRITE_ = &h00000002ul
const OPEN_EXISTING_    = 3
const FILE_ATTRIBUTE_NORMAL_ = &h00000080ul
const PAGE_READONLY_    = &h02ul
const PAGE_READWRITE_   = &h04ul
const FILE_MAP_WRITE_   = &h0002ul
const FILE_MAP_READ_    = &h0004ul

extern "c"   '' NON-FBCALL: kernel32 imports, not rtlib entry points.
	declare function w_CreateFileW stdcall alias "CreateFileW" _
		( byval n as wstring ptr, byval acc as ulong, byval share as ulong, byval sa as any ptr, _
		  byval disp as ulong, byval flags as ulong, byval templ as any ptr ) as any ptr
	declare function w_GetFileSizeEx stdcall alias "GetFileSizeEx" ( byval h as any ptr, byval sz as longint ptr ) as long
	declare function w_CreateFileMappingW stdcall alias "CreateFileMappingW" _
		( byval h as any ptr, byval sa as any ptr, byval prot as ulong, byval hi as ulong, _
		  byval lo as ulong, byval n as wstring ptr ) as any ptr
	declare function w_MapViewOfFile stdcall alias "MapViewOfFile" _
		( byval hm as any ptr, byval acc as ulong, byval hi as ulong, byval lo as ulong, byval n as uinteger ) as any ptr
	declare function w_UnmapViewOfFile stdcall alias "UnmapViewOfFile" ( byval p as any ptr ) as long
	declare function w_CloseHandle stdcall alias "CloseHandle" ( byval h as any ptr ) as long
	declare function w_FlushViewOfFile stdcall alias "FlushViewOfFile" ( byval p as any ptr, byval n as uinteger ) as long
	declare function w_FlushFileBuffers stdcall alias "FlushFileBuffers" ( byval h as any ptr ) as long
end extern

'' NUL-terminated wide copy of a USTRING path, heap-allocated because paths are
'' NOT bounded by MAX_PATH -- a \?\ path may be far longer, and truncating one
'' silently operates on the WRONG FILE.
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

extern "rtlib"

function tkort_UStrFsMmapOpen alias "fb_UStrFsMmapOpen" _
	( byval p as FBUSTRING ptr, byval writable as long, byval out_ as FB_FSMAP ptr ptr ) as long

	dim as wstring ptr w = any
	dim as FB_FSMAP ptr m = any
	dim as any ptr hf = any, hm = any, vw = any
	dim as longint sz = any
	dim as long r = any

	*out_ = 0

	w = hFsWide( p )
	if( w = 0 ) then return FB_FS_UNKNOWN

	'' A read-only mapping still SHARES WRITE, so another process may modify
	'' the file underneath; a writable one does not.
	hf = w_CreateFileW( w, _
		iif( writable <> 0, GENERIC_READ_ or GENERIC_WRITE_, GENERIC_READ_ ), _
		FILE_SHARE_READ_ or iif( writable <> 0, 0, FILE_SHARE_WRITE_ ), _
		0, OPEN_EXISTING_, FILE_ATTRIBUTE_NORMAL_, 0 )
	free( w )

	if( cast( integer, hf ) = INVALID_HANDLE_VALUE_ ) then return tkrt_FsMapOsError( )

	if( w_GetFileSizeEx( hf, @sz ) = 0 ) then
		r = tkrt_FsMapOsError( )
		w_CloseHandle( hf )
		return r
	end if

	if( sz = 0 ) then
		w_CloseHandle( hf )
		return FB_FS_INVALID_PATH
	end if

	hm = w_CreateFileMappingW( hf, 0, iif( writable <> 0, PAGE_READWRITE_, PAGE_READONLY_ ), 0, 0, 0 )
	if( hm = 0 ) then
		r = tkrt_FsMapOsError( )
		w_CloseHandle( hf )
		return r
	end if

	vw = w_MapViewOfFile( hm, iif( writable <> 0, FILE_MAP_WRITE_, FILE_MAP_READ_ ), 0, 0, 0 )
	if( vw = 0 ) then
		r = tkrt_FsMapOsError( )
		w_CloseHandle( hm )
		w_CloseHandle( hf )
		return r
	end if

	m = calloc( 1, sizeof( FB_FSMAP ) )
	if( m = 0 ) then
		w_UnmapViewOfFile( vw )
		w_CloseHandle( hm )
		w_CloseHandle( hf )
		return FB_FS_UNKNOWN
	end if

	m->hfile = hf
	m->hmap = hm
	m->data_ = vw
	m->size_ = cast( ulongint, sz )
	m->writable = writable

	*out_ = m
	return FB_FS_OK
end function

sub tkort_FsMmapClose alias "fb_FsMmapClose" ( byval m as FB_FSMAP ptr )
	if( m = 0 ) then exit sub
	'' Reverse of creation -- see the header.
	if( m->data_ <> 0 ) then w_UnmapViewOfFile( m->data_ )
	if( m->hmap <> 0 ) then w_CloseHandle( m->hmap )
	if( cast( integer, m->hfile ) <> INVALID_HANDLE_VALUE_ ) then w_CloseHandle( m->hfile )
	free( m )
end sub

function tkort_FsMmapData alias "fb_FsMmapData" ( byval m as FB_FSMAP ptr ) as ubyte ptr
	if( m = 0 ) then return 0
	return m->data_
end function

function tkort_FsMmapSize alias "fb_FsMmapSize" ( byval m as FB_FSMAP ptr ) as ulongint
	if( m = 0 ) then return 0
	return m->size_
end function

'' BOTH FLUSHES ARE REQUIRED. FlushViewOfFile only pushes the pages into the
'' file system cache; FlushFileBuffers is what reaches the disk. One without
'' the other makes the call mean less than the caller thinks.
function tkort_FsMmapFlush alias "fb_FsMmapFlush" ( byval m as FB_FSMAP ptr ) as long
	if( m = 0 ) then return FB_FS_UNKNOWN
	'' A read-only mapping has nothing to write back, and says so rather
	'' than failing.
	if( m->writable = 0 ) then return FB_FS_OK
	if( w_FlushViewOfFile( m->data_, 0 ) = 0 ) then return tkrt_FsMapOsError( )
	if( w_FlushFileBuffers( m->hfile ) = 0 ) then return tkrt_FsMapOsError( )
	return FB_FS_OK
end function

end extern

#else

'' ------------------------------------------------------------- Unix backend

type FB_FSMAP
	as long       fd
	as ubyte ptr  data_
	as ulongint   size_
	as long       writable
end type

const O_RDONLY_ = 0
const O_RDWR_   = 2
const PROT_READ_  = 1
const PROT_WRITE_ = 2
const MAP_SHARED_ = 1
const MS_SYNC_    = 4
const S_IFMT_  = &o170000
const S_IFDIR_ = &o040000

'' Only the two fields this file reads are named; the rest of struct stat is
'' padding as far as the mapping is concerned. st_mode and st_size are at fixed
'' offsets on x86-64 glibc.
type stat_
	as ubyte raw( 0 to 143 )
end type

const STAT_MODE_OFFSET = 24
const STAT_SIZE_OFFSET = 48

extern "c"   '' NON-FBCALL: libc, not rtlib entry points.
	declare function u_open alias "open" ( byval path as zstring ptr, byval flags as long, ... ) as long
	declare function u_close alias "close" ( byval fd as long ) as long
	declare function u_fstat alias "fstat" ( byval fd as long, byval st as stat_ ptr ) as long
	declare function u_mmap alias "mmap" _
		( byval addr as any ptr, byval length as uinteger, byval prot as long, _
		  byval flags as long, byval fd as long, byval off as longint ) as any ptr
	declare function u_munmap alias "munmap" ( byval addr as any ptr, byval length as uinteger ) as long
	declare function u_msync alias "msync" ( byval addr as any ptr, byval length as uinteger, byval flags as long ) as long
	declare function u_utf16to8 alias "fb_hUtf16ToUtf8" _
		( byval src as FB_UCHAR ptr, byval units as integer, byval dst as zstring ptr, byval cap as integer ) as integer
end extern

'' UTF-16 -> UTF-8, heap-allocated. Three bytes per unit is the worst case for
'' the BMP, and a surrogate PAIR is two units producing four bytes, so the
'' bound holds for astral code points too.
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

extern "rtlib"

function tkort_UStrFsMmapOpen alias "fb_UStrFsMmapOpen" _
	( byval p as FBUSTRING ptr, byval writable as long, byval out_ as FB_FSMAP ptr ptr ) as long

	dim as zstring ptr path_ = any
	dim as FB_FSMAP ptr m = any
	dim as stat_ st = any
	dim as long fd = any, r = any
	dim as any ptr addr = any
	dim as ulong mode_ = any
	dim as longint size_ = any

	*out_ = 0

	path_ = hFsNarrow( p )
	if( path_ = 0 ) then return FB_FS_UNKNOWN

	fd = u_open( path_, iif( writable <> 0, O_RDWR_, O_RDONLY_ ) )
	free( path_ )

	if( fd < 0 ) then return tkrt_FsMapOsError( )

	if( u_fstat( fd, @st ) <> 0 ) then
		r = tkrt_FsMapOsError( )
		u_close( fd )
		return r
	end if

	mode_ = *cptr( ulong ptr, @st.raw(STAT_MODE_OFFSET) )
	size_ = *cptr( longint ptr, @st.raw(STAT_SIZE_OFFSET) )

	'' open( ) ON A DIRECTORY SUCCEEDS on POSIX, as everywhere; the refusal
	'' has to be explicit so this matches what Windows does on its own.
	if( (mode_ and S_IFMT_) = S_IFDIR_ ) then
		u_close( fd )
		return FB_FS_IS_A_DIRECTORY
	end if

	if( size_ = 0 ) then
		u_close( fd )
		return FB_FS_INVALID_PATH
	end if

	addr = u_mmap( 0, cast( uinteger, size_ ), _
		iif( writable <> 0, PROT_READ_ or PROT_WRITE_, PROT_READ_ ), _
		MAP_SHARED_, fd, 0 )

	'' MAP_FAILED is (void*)-1, NOT NULL -- a NULL test here would treat a
	'' failed mapping as a successful one at address zero.
	if( cast( integer, addr ) = -1 ) then
		r = tkrt_FsMapOsError( )
		u_close( fd )
		return r
	end if

	m = calloc( 1, sizeof( FB_FSMAP ) )
	if( m = 0 ) then
		u_munmap( addr, cast( uinteger, size_ ) )
		u_close( fd )
		return FB_FS_UNKNOWN
	end if

	m->fd = fd
	m->data_ = addr
	m->size_ = cast( ulongint, size_ )
	m->writable = writable

	*out_ = m
	return FB_FS_OK
end function

sub tkort_FsMmapClose alias "fb_FsMmapClose" ( byval m as FB_FSMAP ptr )
	if( m = 0 ) then exit sub
	if( m->data_ <> 0 ) then u_munmap( m->data_, cast( uinteger, m->size_ ) )
	if( m->fd >= 0 ) then u_close( m->fd )
	free( m )
end sub

function tkort_FsMmapData alias "fb_FsMmapData" ( byval m as FB_FSMAP ptr ) as ubyte ptr
	if( m = 0 ) then return 0
	return m->data_
end function

function tkort_FsMmapSize alias "fb_FsMmapSize" ( byval m as FB_FSMAP ptr ) as ulongint
	if( m = 0 ) then return 0
	return m->size_
end function

'' MS_SYNC, NOT MS_ASYNC: the caller asked to flush, and returning before the
'' data is durable would make the call a suggestion.
function tkort_FsMmapFlush alias "fb_FsMmapFlush" ( byval m as FB_FSMAP ptr ) as long
	if( m = 0 ) then return FB_FS_UNKNOWN
	if( m->writable = 0 ) then return FB_FS_OK
	if( u_msync( m->data_, cast( uinteger, m->size_ ), MS_SYNC_ ) <> 0 ) then return tkrt_FsMapOsError( )
	return FB_FS_OK
end function

end extern

#endif
