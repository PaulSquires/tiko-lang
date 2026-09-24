'' dir.bas -- directory enumeration. Three entry points over one fbc member,
'' split by platform.
''
'' EACH FB_FSDIR OWNS ITS OWN HANDLE. That is the whole point. The legacy
'' Dir/DirNext keeps ONE cursor per thread, so a second Dir( ) on the same
'' thread silently resets the first and the obvious recursive scan enumerates
'' the wrong directory halfway through. Nothing here touches that cursor; Dir
'' keeps its behaviour exactly.
''
'' "." AND ".." ARE DROPPED HERE, not left to the caller. They are an artefact
'' of the enumeration API, every caller filters them, and one that forgets
'' writes an infinite recursion.
''
'' THE KIND IS FREE ON WINDOWS AND NOT ON POSIX, and that asymmetry is the
'' reason FB_FSDIRENT has a has_info flag instead of pretending otherwise.
'' WIN32_FIND_DATAW already carries attributes, size and all three times, so
'' DirEntry.Info( ) answers from memory there. dirent has only a name and a
'' type -- and on some network and older filesystems not even the type, which is
'' DT_UNKNOWN and costs ONE lstat for THAT ENTRY ONLY. has_info stays 0 on
'' POSIX and Info( ) stats on demand in the FB layer.

#include once "inc/descriptors.bi"
#include once "inc/fsdefs.bi"
#include once "inc/fserror.bi"
#include once "inc/fspath.bi"
#include once "inc/sysbind.bi"

extern "rtlib"
	declare function tkrt_FsMapOsError alias "fb_FsMapOsError" ( ) as long
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

#if defined( __FB_WIN32__ ) or defined( __FB_WIN64__ )

'' ---------------------------------------------------------- Windows backend

const INVALID_HANDLE_VALUE_    = -1
const INVALID_FILE_ATTRIBUTES_ = &hFFFFFFFFul
const FILE_ATTRIBUTE_READONLY_ = &h00000001ul
const FILE_ATTRIBUTE_HIDDEN_   = &h00000002ul
const FILE_ATTRIBUTE_DIRECTORY_ = &h00000010ul
const FILE_ATTRIBUTE_DEVICE_    = &h00000040ul
const FILE_ATTRIBUTE_REPARSE_POINT_ = &h00000400ul
const IO_REPARSE_TAG_SYMLINK_     = &hA000000Cul
const IO_REPARSE_TAG_MOUNT_POINT_ = &hA0000003ul

'' WIN32_FIND_DATAW: attrs, three FILETIMEs, the two size halves, dwReserved0
'' (the reparse tag), dwReserved1, cFileName(260) and cAlternateFileName(14).
const WFD_SIZE_      = 592
const WFD_ATTRS_     = 0
const WFD_CTIME_     = 4
const WFD_ATIME_     = 12
const WFD_MTIME_     = 20
const WFD_SIZEHIGH_  = 28
const WFD_SIZELOW_   = 32
const WFD_RESERVED0_ = 36
const WFD_NAME_      = 44

type FB_FSDIR
	as any ptr  h
	as ubyte    fd( 0 to WFD_SIZE_ - 1 )
	as long     have          '' fd holds an entry not yet handed out
end type

extern "c"   '' NON-FBCALL: kernel32 imports, not rtlib entry points.
	declare function w_FindFirstFileW stdcall alias "FindFirstFileW" _
		( byval n as wstring ptr, byval fd as any ptr ) as any ptr
	declare function w_FindNextFileW stdcall alias "FindNextFileW" _
		( byval h as any ptr, byval fd as any ptr ) as long
	declare function w_FindClose stdcall alias "FindClose" ( byval h as any ptr ) as long
end extern

private function hTicks( byval ft as ubyte ptr ) as longint
	dim as ulong lo = *cptr( ulong ptr, ft )
	dim as ulong hi = *cptr( ulong ptr, ft + 4 )
	if( (lo = 0) andalso (hi = 0) ) then return 0
	return cast( longint, (cast( ulongint, hi ) shl 32) or cast( ulongint, lo ) ) + FB_FS_TICKS_TO_FILETIME
end function

private function hIsLinkTag( byval tag as ulong ) as long
	return iif( (tag = IO_REPARSE_TAG_SYMLINK_) orelse (tag = IO_REPARSE_TAG_MOUNT_POINT_), 1, 0 )
end function

private function hKindFromAttrs( byval attrs as ulong, byval tag as ulong ) as long
	if( attrs = INVALID_FILE_ATTRIBUTES_ ) then return FB_FSKIND_NONE
	if( ((attrs and FILE_ATTRIBUTE_REPARSE_POINT_) <> 0) andalso (hIsLinkTag( tag ) <> 0) ) then
		return FB_FSKIND_LINK
	end if
	if( (attrs and FILE_ATTRIBUTE_DIRECTORY_) <> 0 ) then return FB_FSKIND_DIR
	if( (attrs and (FILE_ATTRIBUTE_DEVICE_ or FILE_ATTRIBUTE_REPARSE_POINT_)) <> 0 ) then return FB_FSKIND_OTHER
	return FB_FSKIND_FILE
end function

private function hName( byval d as FB_FSDIR ptr ) as FB_UCHAR ptr
	return cptr( FB_UCHAR ptr, @d->fd(WFD_NAME_) )
end function

private function hIsDotOrDotDot( byval n as FB_UCHAR ptr ) as long
	if( n[0] <> 46 ) then return 0                      '' '.'
	if( n[1] = 0 ) then return 1
	return iif( (n[1] = 46) andalso (n[2] = 0), 1, 0 )
end function

'' Advance past any "." / ".." the API produced. Sets have=0 at the end.
private sub hSkipDots( byval d as FB_FSDIR ptr )
	while( d->have <> 0 )
		if( hIsDotOrDotDot( hName( d ) ) = 0 ) then exit while
		if( w_FindNextFileW( d->h, @d->fd(0) ) = 0 ) then d->have = 0
	wend
end sub

extern "rtlib"

function tkort_UStrFsDirOpen alias "fb_UStrFsDirOpen" _
	( byval p as FBUSTRING ptr, byval out_ as FB_FSDIR ptr ptr ) as long

	dim as FB_UCHAR ptr s = any, pat = any
	dim as integer len_ = any, n = any
	dim as FB_FSDIR ptr d = any
	dim as long e = any

	*out_ = 0

	hUArg( p, @s, @len_ )

	'' pattern = path + "\*", with the separator only if one is needed
	pat = malloc( (len_ + 3) * sizeof( FB_UCHAR ) )
	if( pat = 0 ) then return FB_FS_UNKNOWN

	if( len_ > 0 ) then memcpy( pat, s, len_ * sizeof( FB_UCHAR ) )
	n = len_

	if( n > 0 ) then
		if( (pat[n - 1] <> 92) andalso (pat[n - 1] <> 47) ) then
			pat[n] = 92 : n += 1
		end if
	end if
	pat[n] = 42 : n += 1                                '' '*'
	pat[n] = 0

	d = calloc( 1, sizeof( FB_FSDIR ) )
	if( d = 0 ) then
		free( pat )
		return FB_FS_UNKNOWN
	end if

	d->h = w_FindFirstFileW( cptr( wstring ptr, pat ), @d->fd(0) )
	free( pat )

	if( cast( integer, d->h ) = INVALID_HANDLE_VALUE_ ) then
		e = tkrt_FsMapOsError( )
		free( d )
		'' An EMPTY directory still yields "." and "..", so
		'' ERROR_FILE_NOT_FOUND here means the DIRECTORY is missing, not that
		'' it is empty. Reported as such.
		return e
	end if

	d->have = 1
	hSkipDots( d )

	*out_ = d
	return FB_FS_OK
end function

function tkort_FsDirRead alias "fb_FsDirRead" _
	( byval d as FB_FSDIR ptr, byval out_ as FB_FSDIRENT ptr ) as long

	dim as integer n = any
	dim as FB_UCHAR ptr nm = any
	dim as ulong attrs = any

	if( d = 0 ) then return FB_FS_EXHAUSTED
	if( d->have = 0 ) then return FB_FS_EXHAUSTED

	nm = hName( d )

	n = 0
	while( n < FB_FS_MAXNAME - 1 )
		if( nm[n] = 0 ) then exit while
		out_->name(n) = nm[n]
		n += 1
	wend
	out_->name(n) = 0
	out_->namelen = n

	attrs = *cptr( ulong ptr, @d->fd(WFD_ATTRS_) )
	out_->kind = hKindFromAttrs( attrs, *cptr( ulong ptr, @d->fd(WFD_RESERVED0_) ) )

	'' Free on this platform -- the find record already has everything.
	memset( @out_->info, 0, sizeof( FB_FSINFO ) )
	out_->info.size_ = (cast( ulongint, *cptr( ulong ptr, @d->fd(WFD_SIZEHIGH_) ) ) shl 32) or _
	                   cast( ulongint, *cptr( ulong ptr, @d->fd(WFD_SIZELOW_) ) )
	out_->info.mtime = hTicks( @d->fd(WFD_MTIME_) )
	out_->info.ctime = hTicks( @d->fd(WFD_CTIME_) )
	out_->info.atime = hTicks( @d->fd(WFD_ATIME_) )
	out_->info.native_attrs = attrs
	out_->info.kind = out_->kind
	out_->info.flags = FB_FSFLAG_HAS_CTIME or FB_FSFLAG_HAS_ATIME

	if( (attrs and FILE_ATTRIBUTE_READONLY_) <> 0 ) then out_->info.flags or= FB_FSFLAG_READONLY
	if( (attrs and FILE_ATTRIBUTE_HIDDEN_) <> 0 ) then out_->info.flags or= FB_FSFLAG_HIDDEN

	if( out_->kind = FB_FSKIND_DIR ) then out_->info.size_ = 0

	out_->has_info = 1

	if( w_FindNextFileW( d->h, @d->fd(0) ) = 0 ) then
		d->have = 0
	else
		hSkipDots( d )
	end if

	return FB_FS_OK
end function

sub tkort_FsDirClose alias "fb_FsDirClose" ( byval d as FB_FSDIR ptr )
	if( d = 0 ) then exit sub
	if( cast( integer, d->h ) <> INVALID_HANDLE_VALUE_ ) then w_FindClose( d->h )
	free( d )
end sub

end extern

#else

'' ------------------------------------------------------------ POSIX backend
''
'' struct dirent on linux-x86_64: d_ino 0 (8), d_off 8 (8), d_reclen 16 (2),
'' d_type 18 (1), d_name 19. Only d_type and d_name are read.
const DIRENT_TYPE_ = 18
const DIRENT_NAME_ = 19

const DT_UNKNOWN_ = 0
const DT_DIR_     = 4
const DT_REG_     = 8
const DT_LNK_     = 10

'' struct stat: st_mode at 24.
const STAT_BUF_SIZE = 144
const STAT_MODE_    = 24

const S_IFMT_  = &o170000
const S_IFDIR_ = &o040000
const S_IFREG_ = &o100000
const S_IFLNK_ = &o120000

type stat_
	as ubyte raw( 0 to STAT_BUF_SIZE - 1 )
end type

type FB_FSDIR
	as any ptr      d
	as zstring ptr  path_        '' kept for the DT_UNKNOWN lstat fallback
	as long         pathlen
end type

extern "c"   '' NON-FBCALL: libc, not rtlib entry points.
	declare function u_opendir alias "opendir" ( byval p as zstring ptr ) as any ptr
	declare function u_readdir alias "readdir" ( byval d as any ptr ) as ubyte ptr
	declare function u_closedir alias "closedir" ( byval d as any ptr ) as long
	declare function u_lstat alias "lstat" ( byval p as zstring ptr, byval st as stat_ ptr ) as long
	declare function u_strlen alias "strlen" ( byval s as zstring ptr ) as uinteger
	declare function u_errno_location alias "__errno_location" ( ) as long ptr
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

private function hKindFromMode( byval m as ulong ) as long
	dim as ulong t = m and S_IFMT_
	if( t = S_IFLNK_ ) then return FB_FSKIND_LINK
	if( t = S_IFDIR_ ) then return FB_FSKIND_DIR
	if( t = S_IFREG_ ) then return FB_FSKIND_FILE
	return FB_FSKIND_OTHER
end function

'' One lstat for a single entry whose d_type the filesystem would not tell us.
private function hKindByLStat( byval d as FB_FSDIR ptr, byval name_ as zstring ptr ) as long
	dim as stat_ st = any
	dim as zstring ptr full = any
	dim as integer n = any, i = any, at = any
	dim as long kind = FB_FSKIND_OTHER

	n = d->pathlen + 1 + cast( integer, u_strlen( name_ ) ) + 1

	full = malloc( n )
	if( full = 0 ) then return FB_FSKIND_OTHER

	at = 0
	for i = 0 to d->pathlen - 1
		full[at] = d->path_[i] : at += 1
	next
	if( d->pathlen > 0 ) then
		if( d->path_[d->pathlen - 1] <> 47 ) then
			full[at] = 47 : at += 1
		end if
	end if
	for i = 0 to cast( integer, u_strlen( name_ ) ) - 1
		full[at] = name_[i] : at += 1
	next
	full[at] = 0

	if( u_lstat( full, @st ) = 0 ) then kind = hKindFromMode( *cptr( ulong ptr, @st.raw(STAT_MODE_) ) )

	free( full )
	return kind
end function

private function hIsDotOrDotDot( byval n as zstring ptr ) as long
	if( n[0] <> 46 ) then return 0
	if( n[1] = 0 ) then return 1
	return iif( (n[1] = 46) andalso (n[2] = 0), 1, 0 )
end function

extern "rtlib"

function tkort_UStrFsDirOpen alias "fb_UStrFsDirOpen" _
	( byval p as FBUSTRING ptr, byval out_ as FB_FSDIR ptr ptr ) as long

	dim as FB_FSDIR ptr h = any
	dim as zstring ptr path_ = any
	dim as long e = any

	*out_ = 0

	path_ = hFsNarrow( p )
	if( path_ = 0 ) then return FB_FS_UNKNOWN

	h = calloc( 1, sizeof( FB_FSDIR ) )
	if( h = 0 ) then
		free( path_ )
		return FB_FS_UNKNOWN
	end if

	h->d = u_opendir( path_ )
	if( h->d = 0 ) then
		e = tkrt_FsMapOsError( )
		free( path_ )
		free( h )
		return e
	end if

	h->path_ = path_
	h->pathlen = cast( long, u_strlen( path_ ) )

	*out_ = h
	return FB_FS_OK
end function

function tkort_FsDirRead alias "fb_FsDirRead" _
	( byval d as FB_FSDIR ptr, byval out_ as FB_FSDIRENT ptr ) as long

	dim as ubyte ptr e = any
	dim as zstring ptr nm = any
	dim as ubyte dtype = any
	dim as integer n = any

	if( d = 0 ) then return FB_FS_EXHAUSTED
	if( d->d = 0 ) then return FB_FS_EXHAUSTED

	do
		'' readdir returns NULL for both end-of-stream and error; errno is the
		'' only way to tell them apart, and it MUST be cleared first.
		TKORT_ERRNO = 0
		e = u_readdir( d->d )

		if( e = 0 ) then
			if( TKORT_ERRNO <> 0 ) then return tkrt_FsMapOsError( )
			return FB_FS_EXHAUSTED
		end if

		nm = cptr( zstring ptr, e + DIRENT_NAME_ )
	loop while( hIsDotOrDotDot( nm ) <> 0 )

	n = u_utf8to16( nm, cast( integer, u_strlen( nm ) ), @out_->name(0), FB_FS_MAXNAME - 1 )
	if( n < 0 ) then n = 0
	out_->name(n) = 0
	out_->namelen = n

	dtype = e[DIRENT_TYPE_]

	if( dtype = DT_DIR_ ) then
		out_->kind = FB_FSKIND_DIR
	elseif( dtype = DT_REG_ ) then
		out_->kind = FB_FSKIND_FILE
	elseif( dtype = DT_LNK_ ) then
		out_->kind = FB_FSKIND_LINK
	elseif( dtype = DT_UNKNOWN_ ) then
		out_->kind = hKindByLStat( d, nm )
	else
		out_->kind = FB_FSKIND_OTHER
	end if

	'' dirent has nothing else. Info( ) stats on demand in the FB layer.
	memset( @out_->info, 0, sizeof( FB_FSINFO ) )
	out_->info.kind = out_->kind
	out_->has_info = 0

	return FB_FS_OK
end function

sub tkort_FsDirClose alias "fb_FsDirClose" ( byval d as FB_FSDIR ptr )
	if( d = 0 ) then exit sub
	if( d->d <> 0 ) then u_closedir( d->d )
	free( d->path_ )
	free( d )
end sub

end extern

#endif
