'' watch.bas -- filesystem change notification. Four entry points over one fbc
'' member, split by platform, and the two platforms are structurally different
'' rather than superficially so.
''
'' WINDOWS: OVERLAPPED, AND THAT IS FORCED BY THE TIMEOUT. A synchronous
'' ReadDirectoryChangesW blocks until something changes, with no way to give up
'' -- so Poll( timeoutMs ) could not be honoured at all. Overlapped IO plus an
'' event and WaitForSingleObject is what makes "wait up to N milliseconds"
'' expressible, and a watcher that can only wait forever is not usable from a
'' single-threaded program.
''
'' ONE READ IS ALWAYS OUTSTANDING, re-issued as soon as its results are copied
'' out: there is no queue behind ReadDirectoryChangesW, only the buffer of the
'' call in flight, so changes occurring between completion and re-issue are lost
'' outright. The window is kept as small as the code allows.
''
'' A ZERO-BYTE COMPLETION MEANS OVERFLOW, not "nothing happened". The kernel
'' signals a buffer overrun that way, and every correct consumer must respond by
'' rescanning -- which is why it surfaces as an EVENT and not as an error the
'' caller can ignore. IN_Q_OVERFLOW is the POSIX counterpart.
''
'' POSIX: inotify, AND RECURSION IS WHERE THE REAL COMPLEXITY IS. inotify does
'' not watch recursively: every subdirectory needs its own watch descriptor. So
'' a recursive watch means walking the tree at Start -- AND ADDING A WATCH FOR
'' EVERY DIRECTORY CREATED WHILE WATCHING, because a subtree created after Start
'' would otherwise be invisible forever. That is the single reason this side is
'' longer than the Windows one, which gets recursion from one flag.
''
'' Watches for deleted directories are dropped by the kernel (IN_IGNORED), so
'' there is no removal bookkeeping to get wrong.
''
'' RENAMES ARE TWO EVENTS on both platforms, and a rename OUT of the watched
'' tree produces only the first. A single RENAMED event carrying both paths
'' could not represent that, so it is not offered.

#include once "inc/descriptors.bi"
#include once "inc/fsdefs.bi"
#include once "inc/fserror.bi"
#include once "inc/fspath.bi"
#include once "crt/stdlib.bi"
#include once "crt/string.bi"

const FB_FSWATCH_BUFBYTES = 65536
const FB_FSWATCH_MAXITEMS = 512

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

const INVALID_HANDLE_VALUE_ = -1
const FILE_LIST_DIRECTORY_  = &h00000001ul
const FILE_SHARE_READ_      = &h00000001ul
const FILE_SHARE_WRITE_     = &h00000002ul
const FILE_SHARE_DELETE_    = &h00000004ul
const OPEN_EXISTING_        = 3
const FILE_FLAG_BACKUP_SEMANTICS_ = &h02000000ul
const FILE_FLAG_OVERLAPPED_       = &h40000000ul
const FILE_NOTIFY_CHANGE_FILE_NAME_  = &h00000001ul
const FILE_NOTIFY_CHANGE_DIR_NAME_   = &h00000002ul
const FILE_NOTIFY_CHANGE_SIZE_       = &h00000008ul
const FILE_NOTIFY_CHANGE_LAST_WRITE_ = &h00000010ul
const ERROR_IO_PENDING_ = 997
const WAIT_OBJECT_0_ = 0
const WAIT_TIMEOUT_  = 258
const INFINITE_      = &hFFFFFFFFul

const FILE_ACTION_ADDED_            = 1
const FILE_ACTION_REMOVED_          = 2
const FILE_ACTION_MODIFIED_         = 3
const FILE_ACTION_RENAMED_OLD_NAME_ = 4
const FILE_ACTION_RENAMED_NEW_NAME_ = 5

'' FILE_NOTIFY_INFORMATION: NextEntryOffset 0, Action 4, FileNameLength 8,
'' FileName at 12.
const FNI_NEXT_   = 0
const FNI_ACTION_ = 4
const FNI_NAMELEN_ = 8
const FNI_NAME_   = 12

'' OVERLAPPED: Internal, InternalHigh, the Offset union, then hEvent -- four
'' pointer-sized slots, so hEvent sits three pointers in.
const OVERLAPPED_SIZE_   = 32
const OVERLAPPED_HEVENT_ = 24

type FB_FSWATCH
	as any ptr   hdir
	as any ptr   hev
	as ubyte     ov( 0 to OVERLAPPED_SIZE_ - 1 )
	as long      recursive
	as long      pending

	as FB_UCHAR  root( 0 to FB_FS_MAXPATH - 1 )
	as long      rootlen

	as FB_FSCHANGE items( 0 to FB_FSWATCH_MAXITEMS - 1 )
	as long      nitems
	as long      nread

	'' ReadDirectoryChangesW REQUIRES a DWORD-aligned buffer. A ulong array
	'' rather than a byte array with an alignment attribute, because FreeBASIC
	'' has no alignment attribute and the element type is guaranteed to give it
	'' -- the same thing C's union-with-a-DWORD idiom buys.
	as ulong     buf( 0 to (FB_FSWATCH_BUFBYTES \ 4) - 1 )
end type

extern "c"   '' NON-FBCALL: kernel32 imports, not rtlib entry points.
	declare function w_CreateFileW stdcall alias "CreateFileW" _
		( byval n as wstring ptr, byval acc as ulong, byval share as ulong, byval sa as any ptr, _
		  byval disp as ulong, byval flags as ulong, byval templ as any ptr ) as any ptr
	declare function w_CloseHandle stdcall alias "CloseHandle" ( byval h as any ptr ) as long
	declare function w_CreateEventW stdcall alias "CreateEventW" _
		( byval sa as any ptr, byval manual as long, byval initial as long, byval n as wstring ptr ) as any ptr
	declare function w_ResetEvent stdcall alias "ResetEvent" ( byval h as any ptr ) as long
	declare function w_ReadDirectoryChangesW stdcall alias "ReadDirectoryChangesW" _
		( byval h as any ptr, byval buf as any ptr, byval n as ulong, byval subtree as long, _
		  byval filter as ulong, byval got as ulong ptr, byval ov as any ptr, byval cr as any ptr ) as long
	declare function w_WaitForSingleObject stdcall alias "WaitForSingleObject" _
		( byval h as any ptr, byval ms as ulong ) as ulong
	declare function w_GetOverlappedResult stdcall alias "GetOverlappedResult" _
		( byval h as any ptr, byval ov as any ptr, byval got as ulong ptr, byval wait_ as long ) as long
	declare function w_CancelIo stdcall alias "CancelIo" ( byval h as any ptr ) as long
	declare function w_GetLastError stdcall alias "GetLastError" ( ) as ulong
end extern

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

private function hIssueRead( byval w as FB_FSWATCH ptr ) as long
	dim as ulong got = 0

	w_ResetEvent( w->hev )
	memset( @w->ov(0), 0, OVERLAPPED_SIZE_ )
	*cptr( any ptr ptr, @w->ov(OVERLAPPED_HEVENT_) ) = w->hev

	if( w_ReadDirectoryChangesW( w->hdir, @w->buf(0), FB_FSWATCH_BUFBYTES, _
	        iif( w->recursive <> 0, 1, 0 ), _
	        FILE_NOTIFY_CHANGE_FILE_NAME_ or FILE_NOTIFY_CHANGE_DIR_NAME_ or _
	        FILE_NOTIFY_CHANGE_LAST_WRITE_ or FILE_NOTIFY_CHANGE_SIZE_, _
	        @got, @w->ov(0), 0 ) = 0 ) then
		if( w_GetLastError( ) <> ERROR_IO_PENDING_ ) then return tkrt_FsMapOsError( )
	end if

	w->pending = 1
	return FB_FS_OK
end function

'' The reported name is RELATIVE to the watched root, so it is joined back on --
'' an event carrying a bare leaf would make every caller re-derive the path and
'' half of them get it wrong.
private sub hPushChange( byval w as FB_FSWATCH ptr, byval kind as long, _
                         byval rel as FB_UCHAR ptr, byval rellen as long )
	dim as long n = 0, i = any

	if( w->nitems >= FB_FSWATCH_MAXITEMS ) then exit sub

	for i = 0 to w->rootlen - 1
		if( n >= FB_FS_MAXPATH - 1 ) then exit for
		w->items(w->nitems).path(n) = w->root(i) : n += 1
	next

	if( (n > 0) andalso (n < FB_FS_MAXPATH - 1) andalso (rellen > 0) ) then
		if( w->items(w->nitems).path(n - 1) <> 92 ) then
			w->items(w->nitems).path(n) = 92 : n += 1
		end if
	end if

	for i = 0 to rellen - 1
		if( n >= FB_FS_MAXPATH - 1 ) then exit for
		w->items(w->nitems).path(n) = rel[i] : n += 1
	next

	w->items(w->nitems).path(n) = 0
	w->items(w->nitems).pathlen = n
	w->items(w->nitems).kind = kind

	w->nitems += 1
end sub

private sub hParseBuffer( byval w as FB_FSWATCH ptr, byval bytes as ulong )
	dim as ubyte ptr at_ = cptr( ubyte ptr, @w->buf(0) )
	dim as ulong action = any, next_ = any, namelen = any
	dim as long kind = any

	w->nitems = 0
	w->nread = 0

	'' A zero-byte completion is the kernel reporting that the buffer overran
	'' and events were DROPPED.
	if( bytes = 0 ) then
		hPushChange( w, FB_FSCHANGE_OVERFLOW, 0, 0 )
		exit sub
	end if

	do
		action = *cptr( ulong ptr, at_ + FNI_ACTION_ )

		if( action = FILE_ACTION_ADDED_ ) then
			kind = FB_FSCHANGE_CREATED
		elseif( action = FILE_ACTION_REMOVED_ ) then
			kind = FB_FSCHANGE_DELETED
		elseif( action = FILE_ACTION_RENAMED_OLD_NAME_ ) then
			kind = FB_FSCHANGE_RENAMED_FROM
		elseif( action = FILE_ACTION_RENAMED_NEW_NAME_ ) then
			kind = FB_FSCHANGE_RENAMED_TO
		else
			kind = FB_FSCHANGE_MODIFIED
		end if

		namelen = *cptr( ulong ptr, at_ + FNI_NAMELEN_ )

		hPushChange( w, kind, cptr( FB_UCHAR ptr, at_ + FNI_NAME_ ), _
		             cast( long, namelen \ sizeof( FB_UCHAR ) ) )

		next_ = *cptr( ulong ptr, at_ + FNI_NEXT_ )
		if( next_ = 0 ) then exit do

		at_ += next_
	loop
end sub

extern "rtlib"

function tkort_UStrFsWatchStart alias "fb_UStrFsWatchStart" _
	( byval p as FBUSTRING ptr, byval recursive as long, byval out_ as FB_FSWATCH ptr ptr ) as long

	dim as FB_UCHAR ptr s = any
	dim as integer len_ = any
	dim as wstring ptr w = any
	dim as FB_FSWATCH ptr h = any
	dim as long r = any, i = any

	*out_ = 0

	hUArg( p, @s, @len_ )

	if( len_ > FB_FS_MAXPATH - 1 ) then return FB_FS_NAME_TOO_LONG

	w = hFsWide( p )
	if( w = 0 ) then return FB_FS_UNKNOWN

	h = calloc( 1, sizeof( FB_FSWATCH ) )
	if( h = 0 ) then
		free( w )
		return FB_FS_UNKNOWN
	end if

	'' FILE_LIST_DIRECTORY plus BACKUP_SEMANTICS is what opens a DIRECTORY for
	'' watching; without the latter CreateFileW refuses directories outright.
	'' OVERLAPPED is required by hIssueRead.
	h->hdir = w_CreateFileW( w, FILE_LIST_DIRECTORY_, _
		FILE_SHARE_READ_ or FILE_SHARE_WRITE_ or FILE_SHARE_DELETE_, _
		0, OPEN_EXISTING_, FILE_FLAG_BACKUP_SEMANTICS_ or FILE_FLAG_OVERLAPPED_, 0 )
	free( w )

	if( cast( integer, h->hdir ) = INVALID_HANDLE_VALUE_ ) then
		r = tkrt_FsMapOsError( )
		free( h )
		return r
	end if

	h->hev = w_CreateEventW( 0, 1, 0, 0 )
	if( h->hev = 0 ) then
		r = tkrt_FsMapOsError( )
		w_CloseHandle( h->hdir )
		free( h )
		return r
	end if

	for i = 0 to len_ - 1
		h->root(i) = s[i]
	next
	h->rootlen = len_
	h->recursive = recursive

	r = hIssueRead( h )
	if( r <> FB_FS_OK ) then
		w_CloseHandle( h->hev )
		w_CloseHandle( h->hdir )
		free( h )
		return r
	end if

	*out_ = h
	return FB_FS_OK
end function

function tkort_FsWatchPoll alias "fb_FsWatchPoll" _
	( byval w as FB_FSWATCH ptr, byval timeoutms as long ) as long

	dim as ulong wait_ = any, bytes = 0
	dim as long r = any

	if( w = 0 ) then return FB_FS_UNKNOWN

	'' anything already drained-but-unread is reported without waiting
	if( w->nread < w->nitems ) then return FB_FS_OK

	if( w->pending = 0 ) then
		r = hIssueRead( w )
		if( r <> FB_FS_OK ) then return r
	end if

	wait_ = w_WaitForSingleObject( w->hev, iif( timeoutms < 0, INFINITE_, cast( ulong, timeoutms ) ) )

	if( wait_ = WAIT_TIMEOUT_ ) then return FB_FS_EXHAUSTED
	if( wait_ <> WAIT_OBJECT_0_ ) then return tkrt_FsMapOsError( )

	if( w_GetOverlappedResult( w->hdir, @w->ov(0), @bytes, 0 ) = 0 ) then
		w->pending = 0
		return tkrt_FsMapOsError( )
	end if

	w->pending = 0
	hParseBuffer( w, bytes )

	'' re-armed IMMEDIATELY: changes between completion and re-issue are lost
	'' outright, so the window is kept as small as the code allows
	hIssueRead( w )

	return iif( w->nitems > 0, FB_FS_OK, FB_FS_EXHAUSTED )
end function

function tkort_FsWatchNext alias "fb_FsWatchNext" _
	( byval w as FB_FSWATCH ptr, byval out_ as FB_FSCHANGE ptr ) as long

	if( w = 0 ) then return FB_FS_EXHAUSTED
	if( w->nread >= w->nitems ) then return FB_FS_EXHAUSTED

	*out_ = w->items(w->nread)
	w->nread += 1
	return FB_FS_OK
end function

sub tkort_FsWatchStop alias "fb_FsWatchStop" ( byval w as FB_FSWATCH ptr )
	if( w = 0 ) then exit sub

	'' CancelIo BEFORE closing, so the outstanding overlapped read is not
	'' completing into a buffer that is about to be freed.
	if( cast( integer, w->hdir ) <> INVALID_HANDLE_VALUE_ ) then
		if( w->pending <> 0 ) then w_CancelIo( w->hdir )
		w_CloseHandle( w->hdir )
	end if

	if( w->hev <> 0 ) then w_CloseHandle( w->hev )

	free( w )
end sub

end extern

#else

'' ------------------------------------------------------------ POSIX backend

const FB_FSWATCH_MAXWATCH = 4096
const FB_FSWATCH_PATHMAX  = 1024

const IN_MODIFY_      = &h00000002ul
const IN_CLOSE_WRITE_ = &h00000008ul
const IN_MOVED_FROM_  = &h00000040ul
const IN_MOVED_TO_    = &h00000080ul
const IN_CREATE_      = &h00000100ul
const IN_DELETE_      = &h00000200ul
const IN_Q_OVERFLOW_  = &h00004000ul
const IN_IGNORED_     = &h00008000ul
const IN_ISDIR_       = &h40000000ul
const IN_NONBLOCK_    = &o4000

'' struct inotify_event: wd 0, mask 4, cookie 8, len 12, name at 16.
const INEV_WD_   = 0
const INEV_MASK_ = 4
const INEV_LEN_  = 12
const INEV_NAME_ = 16
const INEV_SIZE_ = 16

'' struct pollfd: fd 0 (int), events 4 (short), revents 6 (short).
const POLLFD_SIZE_ = 8
const POLLIN_      = 1

'' struct dirent: d_type 18, d_name 19. struct stat: st_mode 24.
const DIRENT_TYPE_ = 18
const DIRENT_NAME_ = 19
const DT_DIR_      = 4
const DT_UNKNOWN_  = 0
const STAT_BUF_SIZE = 144
const STAT_MODE_    = 24
const S_IFMT_  = &o170000
const S_IFDIR_ = &o040000

const EINTR_ = 4

type stat_
	as ubyte raw( 0 to STAT_BUF_SIZE - 1 )
end type

type FB_FSWATCHDIR
	as long     wd
	as zstring * FB_FSWATCH_PATHMAX path_
end type

type FB_FSWATCH
	as long        fd
	as long        recursive

	as FB_FSWATCHDIR dirs( 0 to FB_FSWATCH_MAXWATCH - 1 )
	as long        ndirs

	as FB_FSCHANGE items( 0 to FB_FSWATCH_MAXITEMS - 1 )
	as long        nitems
	as long        nread

	as ubyte       buf( 0 to FB_FSWATCH_BUFBYTES - 1 )
end type

extern "c"   '' NON-FBCALL: libc, not rtlib entry points.
	declare function u_inotify_init1 alias "inotify_init1" ( byval flags as long ) as long
	declare function u_inotify_add_watch alias "inotify_add_watch" _
		( byval fd as long, byval p as zstring ptr, byval mask as ulong ) as long
	declare function u_close alias "close" ( byval fd as long ) as long
	declare function u_read alias "read" ( byval fd as long, byval buf as any ptr, byval n as uinteger ) as integer
	declare function u_poll alias "poll" ( byval fds as any ptr, byval n as uinteger, byval ms as long ) as long
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

const FB_FSWATCH_MASK = IN_CREATE_ or IN_DELETE_ or IN_MODIFY_ or _
                        IN_MOVED_FROM_ or IN_MOVED_TO_ or IN_CLOSE_WRITE_

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

'' Bounded "a/b" join into a fixed buffer. Truncation is silent and harmless
'' here -- the result is only ever used to add a watch or to name an event, and
'' a truncated name simply fails to resolve.
private sub hJoin( byval dst as zstring ptr, byval cap as long, _
                   byval a as zstring ptr, byval b as zstring ptr )
	dim as long n = 0, i = any

	i = 0
	while( (a[i] <> 0) andalso (n < cap - 1) )
		dst[n] = a[i] : n += 1 : i += 1
	wend

	if( b <> 0 ) then
		if( (n > 0) andalso (n < cap - 1) andalso (dst[n - 1] <> 47) ) then
			dst[n] = 47 : n += 1
		end if
		i = 0
		while( (b[i] <> 0) andalso (n < cap - 1) )
			dst[n] = b[i] : n += 1 : i += 1
		wend
	end if

	dst[n] = 0
end sub

private function hAddWatch( byval w as FB_FSWATCH ptr, byval path_ as zstring ptr ) as long
	dim as long wd = any

	if( w->ndirs >= FB_FSWATCH_MAXWATCH ) then return -1

	wd = u_inotify_add_watch( w->fd, path_, FB_FSWATCH_MASK )
	if( wd < 0 ) then return -1

	w->dirs(w->ndirs).wd = wd
	hJoin( @w->dirs(w->ndirs).path_, FB_FSWATCH_PATHMAX, path_, 0 )
	w->ndirs += 1

	return wd
end function

private function hPathForWd( byval w as FB_FSWATCH ptr, byval wd as long ) as zstring ptr
	dim as long i = any
	for i = 0 to w->ndirs - 1
		if( w->dirs(i).wd = wd ) then return @w->dirs(i).path_
	next
	return 0
end function

'' Walk the tree at Start, one watch per directory. Symbolic links are NOT
'' followed -- the same rule WalkDir applies, and for the same reason: a link to
'' an ancestor would otherwise add watches forever.
private sub hAddTree( byval w as FB_FSWATCH ptr, byval path_ as zstring ptr, byval depth as long )
	dim as any ptr d = any
	dim as ubyte ptr e = any
	dim as zstring ptr nm = any
	dim as zstring * FB_FSWATCH_PATHMAX child = any
	dim as stat_ st = any
	dim as long isdir = any

	if( depth > 64 ) then exit sub
	if( hAddWatch( w, path_ ) < 0 ) then exit sub
	if( w->recursive = 0 ) then exit sub

	d = u_opendir( path_ )
	if( d = 0 ) then exit sub

	do
		e = u_readdir( d )
		if( e = 0 ) then exit do

		nm = cptr( zstring ptr, e + DIRENT_NAME_ )

		if( nm[0] = 46 ) then                       '' '.'
			if( nm[1] = 0 ) then continue do
			if( (nm[1] = 46) andalso (nm[2] = 0) ) then continue do
		end if

		hJoin( @child, FB_FSWATCH_PATHMAX, path_, nm )

		'' lstat rather than d_type, because the link rule above needs the
		'' UNRESOLVED kind and d_type reports DT_LNK for a link to a directory.
		if( u_lstat( @child, @st ) <> 0 ) then continue do

		isdir = iif( (*cptr( ulong ptr, @st.raw(STAT_MODE_) ) and S_IFMT_) = S_IFDIR_, 1, 0 )
		if( isdir <> 0 ) then hAddTree( w, @child, depth + 1 )
	loop

	u_closedir( d )
end sub

private sub hPushChange( byval w as FB_FSWATCH ptr, byval kind as long, byval full as zstring ptr )
	dim as integer n = any

	if( w->nitems >= FB_FSWATCH_MAXITEMS ) then exit sub

	if( full = 0 ) then
		w->items(w->nitems).pathlen = 0
		w->items(w->nitems).path(0) = 0
	else
		n = u_utf8to16( full, cast( integer, u_strlen( full ) ), _
		                @w->items(w->nitems).path(0), FB_FS_MAXPATH - 1 )
		if( n < 0 ) then n = 0
		w->items(w->nitems).path(n) = 0
		w->items(w->nitems).pathlen = n
	end if

	w->items(w->nitems).kind = kind
	w->nitems += 1
end sub

private sub hHandleEvent( byval w as FB_FSWATCH ptr, byval e as ubyte ptr )
	dim as ulong mask = *cptr( ulong ptr, e + INEV_MASK_ )
	dim as ulong elen = *cptr( ulong ptr, e + INEV_LEN_ )
	dim as long wd = *cptr( long ptr, e + INEV_WD_ )
	dim as zstring ptr dir_ = any
	dim as zstring * FB_FSWATCH_PATHMAX full = any
	dim as long kind = any

	if( (mask and IN_Q_OVERFLOW_) <> 0 ) then
		hPushChange( w, FB_FSCHANGE_OVERFLOW, 0 )
		exit sub
	end if

	'' the kernel dropped a dead watch
	if( (mask and IN_IGNORED_) <> 0 ) then exit sub

	dir_ = hPathForWd( w, wd )
	if( dir_ = 0 ) then exit sub

	if( elen > 0 ) then
		hJoin( @full, FB_FSWATCH_PATHMAX, dir_, cptr( zstring ptr, e + INEV_NAME_ ) )
	else
		hJoin( @full, FB_FSWATCH_PATHMAX, dir_, 0 )
	end if

	if( (mask and IN_CREATE_) <> 0 ) then
		kind = FB_FSCHANGE_CREATED
	elseif( (mask and IN_DELETE_) <> 0 ) then
		kind = FB_FSCHANGE_DELETED
	elseif( (mask and IN_MOVED_FROM_) <> 0 ) then
		kind = FB_FSCHANGE_RENAMED_FROM
	elseif( (mask and IN_MOVED_TO_) <> 0 ) then
		kind = FB_FSCHANGE_RENAMED_TO
	else
		kind = FB_FSCHANGE_MODIFIED
	end if

	hPushChange( w, kind, @full )

	'' A DIRECTORY CREATED WHILE WATCHING NEEDS ITS OWN WATCH, or everything
	'' inside it is invisible for the life of the watcher. This is the piece
	'' that has no Windows counterpart at all.
	if( (w->recursive <> 0) andalso ((mask and IN_ISDIR_) <> 0) andalso _
	    ((mask and (IN_CREATE_ or IN_MOVED_TO_)) <> 0) ) then
		hAddTree( w, @full, 0 )
	end if
end sub

extern "rtlib"

function tkort_UStrFsWatchStart alias "fb_UStrFsWatchStart" _
	( byval p as FBUSTRING ptr, byval recursive as long, byval out_ as FB_FSWATCH ptr ptr ) as long

	dim as zstring ptr path_ = any
	dim as FB_FSWATCH ptr w = any
	dim as long r = any

	*out_ = 0

	path_ = hFsNarrow( p )
	if( path_ = 0 ) then return FB_FS_UNKNOWN

	w = calloc( 1, sizeof( FB_FSWATCH ) )
	if( w = 0 ) then
		free( path_ )
		return FB_FS_UNKNOWN
	end if

	'' NONBLOCK, because Poll uses poll( ) for the timeout and then reads
	'' whatever is ready -- a blocking fd would hang past the deadline.
	w->fd = u_inotify_init1( IN_NONBLOCK_ )
	if( w->fd < 0 ) then
		r = tkrt_FsMapOsError( )
		free( path_ )
		free( w )
		return r
	end if

	w->recursive = recursive
	hAddTree( w, path_, 0 )

	free( path_ )

	if( w->ndirs = 0 ) then
		u_close( w->fd )
		free( w )
		return FB_FS_NOT_FOUND
	end if

	*out_ = w
	return FB_FS_OK
end function

function tkort_FsWatchPoll alias "fb_FsWatchPoll" _
	( byval w as FB_FSWATCH ptr, byval timeoutms as long ) as long

	dim as ubyte pfd( 0 to POLLFD_SIZE_ - 1 ) = any
	dim as integer got = any
	dim as long pr = any
	dim as ubyte ptr at_ = any, stop_ = any
	dim as ulong elen = any

	if( w = 0 ) then return FB_FS_UNKNOWN
	if( w->nread < w->nitems ) then return FB_FS_OK

	do
		memset( @pfd(0), 0, POLLFD_SIZE_ )
		*cptr( long ptr, @pfd(0) ) = w->fd
		*cptr( short ptr, @pfd(4) ) = POLLIN_

		pr = u_poll( @pfd(0), 1, timeoutms )

		if( pr < 0 ) then
			if( TKORT_ERRNO = EINTR_ ) then continue do
			return tkrt_FsMapOsError( )
		end if

		if( pr = 0 ) then return FB_FS_EXHAUSTED

		exit do
	loop

	got = u_read( w->fd, @w->buf(0), FB_FSWATCH_BUFBYTES )
	if( got <= 0 ) then return FB_FS_EXHAUSTED

	w->nitems = 0
	w->nread = 0

	at_ = @w->buf(0)
	stop_ = at_ + got

	while( at_ < stop_ )
		hHandleEvent( w, at_ )
		elen = *cptr( ulong ptr, at_ + INEV_LEN_ )
		at_ += INEV_SIZE_ + elen
	wend

	return iif( w->nitems > 0, FB_FS_OK, FB_FS_EXHAUSTED )
end function

function tkort_FsWatchNext alias "fb_FsWatchNext" _
	( byval w as FB_FSWATCH ptr, byval out_ as FB_FSCHANGE ptr ) as long

	if( w = 0 ) then return FB_FS_EXHAUSTED
	if( w->nread >= w->nitems ) then return FB_FS_EXHAUSTED

	*out_ = w->items(w->nread)
	w->nread += 1
	return FB_FS_OK
end function

sub tkort_FsWatchStop alias "fb_FsWatchStop" ( byval w as FB_FSWATCH ptr )
	if( w = 0 ) then exit sub
	'' closing the inotify fd drops every watch it holds
	if( w->fd >= 0 ) then u_close( w->fd )
	free( w )
end sub

end extern

#endif
