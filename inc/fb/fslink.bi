'' fb/fslink.bi -- symbolic links, hard links, permissions and attributes
''
'' Specified in C:\dev\docs\filesystem\RFC-0007-links-permissions.md.
''
'' ARGUMENT ORDER IS (target, link) -- the thing that EXISTS first, matching
'' ln -s, symlink(2) and Python. It is the opposite of CreateSymbolicLinkW.
'' Getting it backwards silently creates a dangling link pointing at the wrong
'' place, which is why it is stated here, again on the member, and asserted with
'' two distinguishable paths in the suite.
''
'' THE PERMISSION MODEL IS THREE SEPARATE THINGS, not one, because the two
'' platforms have no common core worth the name. POSIX has nine mode bits plus
'' setuid/setgid/sticky and an owner and group; Windows has a handful of
'' attribute flags plus a full discretionary ACL. Mapping either onto the other
'' produces something wrong in both directions, so this file offers:
''
''   1. SetReadOnly / SetHidden      -- the portable subset
''   2. GetPosixMode / SetPosixMode  -- FS_UNSUPPORTED on Windows
''   3. GetWin32Attributes / Set...  -- FS_UNSUPPORTED on POSIX
''
'' FS_UNSUPPORTED is the right code for the off-platform calls, and is why
'' RFC-0001 distinguishes it from FS_ACCESS_DENIED: it means THIS WILL NEVER
'' WORK HERE, so a caller can branch on it once at startup rather than treating
'' it as a transient failure.
''
'' NO OWNER, NO GROUP, NO ACLs. A Windows DACL is a variable-length list of ACEs
'' with inheritance semantics and no POSIX analogue; POSIX ACLs are an optional
'' extension with a different model again. There is no portable subset beyond
'' the read-only bit, and a PARTIAL ACL API is worse than none -- it invites
'' code that looks portable and silently grants more than it meant to on one
'' platform.

#pragma once

#include once "fb/fserror.bi"
#include once "fb/fspath.bi"
#include once "fb/fsinfo.bi"
#include once "fb/fsdir.bi"
#include once "fb/fsops.bi"

#if __FB_LANG__ <> "fb"
	#error "fb/fslink.bi requires -lang fb (it uses namespaces)"
#endif

#if defined( __FB_WIN32__ ) and ( not defined( __FB_64BIT__ ) )
	#define FBFSLINK_EXTERN extern "Windows"
#else
	#define FBFSLINK_EXTERN extern "C"
#endif

namespace FB

type FsResultULong as Result( of ulong, FsError )

FBFSLINK_EXTERN
	declare function FsCreateSymlinkRaw alias "fb_UStrFsCreateSymlink" _
		( byref target as const ustring, byref lnk as const ustring, byval isdir as long ) as long

	declare function FsCreateHardLinkRaw alias "fb_UStrFsCreateHardLink" _
		( byref target as const ustring, byref lnk as const ustring ) as long

	declare function FsReadLinkRaw alias "fb_UStrFsReadLink" _
		( byref lnk as const ustring, byref status as long ) as ustring

	declare function FsLinkCountRaw alias "fb_UStrFsLinkCount" _
		( byref p as const ustring, byref out as ulong ) as long

	declare function FsGetPermRaw alias "fb_UStrFsGetPerm" _
		( byref p as const ustring, byref out as ulong ) as long

	declare function FsSetPermRaw alias "fb_UStrFsSetPerm" _
		( byref p as const ustring, byval v as ulong ) as long

	declare function FsSetHiddenRaw alias "fb_UStrFsSetHidden" _
		( byref p as const ustring, byval v as long ) as long

	declare function FsSetTimesRaw alias "fb_UStrFsSetTimes" _
		( byref p as const ustring, byval mtime as longint, byval atime as longint ) as long
end extern

'' ------------------------------------------------------------------- links

declare function CreateSymlink overload ( byref target as const ustring, byref lnk as const ustring, byval targetIsDir as boolean = FALSE ) as FsResultBool
declare function CreateHardLink overload ( byref target as const ustring, byref lnk as const ustring ) as FsResultBool
declare function ReadLink overload ( byref lnk as const ustring ) as FsResultUStr
declare function IsLink overload ( byref p as const ustring ) as boolean
declare function LinkCount overload ( byref p as const ustring ) as FsResultULong

'' TARGET FIRST. `targetIsDir` is required on Windows -- which encodes the target's
'' kind IN THE LINK and needs it at creation time even when the target does not
'' exist yet, so it cannot be inferred -- and ignored on POSIX.
''
'' ON WINDOWS THIS USUALLY NEEDS PRIVILEGE: SeCreateSymbolicLink is not held by
'' a normal user, so expect FS_ACCESS_DENIED unless the process is elevated or
'' Developer Mode is on. The kernel always asks for the unprivileged path first
'' and falls back, so nothing here is left on the table.
''
'' THE PARAMETER IS `targetIsDir`, NOT `isdir`. FreeBASIC identifiers are
'' case-insensitive, so a parameter named `isdir` inside NAMESPACE FB collides
'' with FB.IsDir from fsinfo.bi and the compiler reports
'' "error 4: Duplicated definition, at parameter 3" -- which points at the
'' parameter and says nothing about the function it clashed with.
private function CreateSymlink( byref target as const ustring, byref lnk as const ustring, byval targetIsDir as boolean ) as FsResultBool
	dim as long r = FsCreateSymlinkRaw( target, lnk, iif( targetIsDir, 1, 0 ) )

	if( r <> FS_OK ) then
		dim as FsError failure_ = FsError( cast( FsErrorCode, r ), FsOsError( ), "CreateSymlink", lnk )
		failure_.SetPath2( target )
		return Fail( of boolean, FsError )( failure_ )
	end if

	return Ok( of boolean, FsError )( TRUE )
end function

private function CreateHardLink( byref target as const ustring, byref lnk as const ustring ) as FsResultBool
	dim as long r = FsCreateHardLinkRaw( target, lnk )

	if( r <> FS_OK ) then
		dim as FsError failure_ = FsError( cast( FsErrorCode, r ), FsOsError( ), "CreateHardLink", lnk )
		failure_.SetPath2( target )
		return Fail( of boolean, FsError )( failure_ )
	end if

	return Ok( of boolean, FsError )( TRUE )
end function

'' Returns the target AS STORED -- unresolved, possibly relative, possibly
'' dangling. It does NOT canonicalize; CanonicalPath (RFC-0003) is that call,
'' and the two answer different questions. Conflating them would make a
'' dangling link unreadable.
''
'' FS_INVALID_PATH when the path is not a link, on both platforms.
private function ReadLink( byref lnk as const ustring ) as FsResultUStr
	dim as long status = FS_OK
	dim as ustring r = FsReadLinkRaw( lnk, status )

	if( status <> FS_OK ) then
		return FsFail( of ustring )( cast( FsErrorCode, status ), "ReadLink", lnk )
	end if

	return Ok( of ustring, FsError )( r )
end function

'' Unlike the Stat/LStat pair there is no ambiguity to resolve here: this is
'' always the LStat-shaped question, because "is this thing a link" has only one
'' sensible reading.
private function IsLink( byref p as const ustring ) as boolean
	dim as FsResultInfo r = LStat( p )
	if( r.IsOk( ) = FALSE ) then return FALSE
	return r.Value( ).IsSymlink( )
end function

'' The only way to know whether deleting a file frees its data.
private function LinkCount( byref p as const ustring ) as FsResultULong
	dim as ulong n = 0
	dim as long r = FsLinkCountRaw( p, n )

	if( r <> FS_OK ) then
		return FsFail( of ulong )( cast( FsErrorCode, r ), "LinkCount", p )
	end if

	return Ok( of ulong, FsError )( n )
end function

'' -------------------------------------------------------- portable subset

declare function SetReadOnly overload ( byref p as const ustring, byval v as boolean ) as FsResultBool
declare function SetHidden overload ( byref p as const ustring, byval v as boolean ) as FsResultBool

'' GENUINELY PORTABLE. FILE_ATTRIBUTE_READONLY on Windows; the write bits on
'' POSIX.
''
'' NOT AN EXACT INVERSE ON POSIX: clearing restores the write bits subject to
'' the current umask, so SetReadOnly( p, FALSE ) after SetReadOnly( p, TRUE )
'' does not necessarily restore the original mode. A caller needing exactness
'' uses GetPosixMode/SetPosixMode. The lossiness is asserted as lossiness in the
'' suite rather than asserted away.
''
'' This is the same entry point RemoveDirAll has used since phase 3 -- rm -rf
'' must clear the attribute or it fails partway through a checked-out
'' repository. Phase 5 gives it a public name; there was never a private copy
'' to delete.
private function SetReadOnly( byref p as const ustring, byval v as boolean ) as FsResultBool
	dim as long r = FsSetReadOnlyRaw( p, iif( v, 1, 0 ) )

	if( r <> FS_OK ) then
		return FsFail( of boolean )( cast( FsErrorCode, r ), "SetReadOnly", p )
	end if

	return Ok( of boolean, FsError )( TRUE )
end function

'' PORTABLE IN NAME ONLY, and it says so. On Windows it sets
'' FILE_ATTRIBUTE_HIDDEN. On POSIX hiddenness is a NAMING CONVENTION, so
'' honouring this would mean RENAMING the file -- a different operation with
'' different consequences, done behind the caller's back. It returns
'' FS_UNSUPPORTED there instead.
''
'' It sits among the "portable" pair only because IsHidden IS portable, and an
'' asymmetric pair would be stranger than a documented gap.
private function SetHidden( byref p as const ustring, byval v as boolean ) as FsResultBool
	dim as long r = FsSetHiddenRaw( p, iif( v, 1, 0 ) )

	if( r <> FS_OK ) then
		return FsFail( of boolean )( cast( FsErrorCode, r ), "SetHidden", p )
	end if

	return Ok( of boolean, FsError )( TRUE )
end function

'' ------------------------------------------------------- platform-specific
''
'' One C pair underneath both names; each returns FS_UNSUPPORTED off its own
'' platform, so a caller can branch once at startup instead of treating it as a
'' transient failure.

declare function GetPosixMode overload ( byref p as const ustring ) as FsResultULong
declare function SetPosixMode overload ( byref p as const ustring, byval mode as ulong ) as FsResultBool
declare function GetWin32Attributes overload ( byref p as const ustring ) as FsResultULong
declare function SetWin32Attributes overload ( byref p as const ustring, byval attrs as ulong ) as FsResultBool

private function GetPosixMode( byref p as const ustring ) as FsResultULong
	#if defined( __FB_WIN32__ )
		return FsFail( of ulong )( FS_UNSUPPORTED, "GetPosixMode", p )
	#else
		dim as ulong v = 0
		dim as long r = FsGetPermRaw( p, v )
		if( r <> FS_OK ) then
			return FsFail( of ulong )( cast( FsErrorCode, r ), "GetPosixMode", p )
		end if
		return Ok( of ulong, FsError )( v )
	#endif
end function

private function SetPosixMode( byref p as const ustring, byval mode as ulong ) as FsResultBool
	#if defined( __FB_WIN32__ )
		return FsFail( of boolean )( FS_UNSUPPORTED, "SetPosixMode", p )
	#else
		dim as long r = FsSetPermRaw( p, mode )
		if( r <> FS_OK ) then
			return FsFail( of boolean )( cast( FsErrorCode, r ), "SetPosixMode", p )
		end if
		return Ok( of boolean, FsError )( TRUE )
	#endif
end function

private function GetWin32Attributes( byref p as const ustring ) as FsResultULong
	#if defined( __FB_WIN32__ )
		dim as ulong v = 0
		dim as long r = FsGetPermRaw( p, v )
		if( r <> FS_OK ) then
			return FsFail( of ulong )( cast( FsErrorCode, r ), "GetWin32Attributes", p )
		end if
		return Ok( of ulong, FsError )( v )
	#else
		return FsFail( of ulong )( FS_UNSUPPORTED, "GetWin32Attributes", p )
	#endif
end function

private function SetWin32Attributes( byref p as const ustring, byval attrs as ulong ) as FsResultBool
	#if defined( __FB_WIN32__ )
		dim as long r = FsSetPermRaw( p, attrs )
		if( r <> FS_OK ) then
			return FsFail( of boolean )( cast( FsErrorCode, r ), "SetWin32Attributes", p )
		end if
		return Ok( of boolean, FsError )( TRUE )
	#else
		return FsFail( of boolean )( FS_UNSUPPORTED, "SetWin32Attributes", p )
	#endif
end function

'' ------------------------------------------------------- timestamps

declare function SetTimes overload ( byref p as const ustring, byval mtimeUtc as longint, byval atimeUtc as longint = 0 ) as FsResultBool

'' Ticks of 100 ns since 0001-01-01 UTC, the same unit FileInfo reports. A tick
'' of 0 means LEAVE THAT ONE ALONE, so one time can be set without inventing a
'' value for the other.
private function SetTimes( byref p as const ustring, byval mtimeUtc as longint, byval atimeUtc as longint ) as FsResultBool
	dim as long r = FsSetTimesRaw( p, mtimeUtc, atimeUtc )

	if( r <> FS_OK ) then
		return FsFail( of boolean )( cast( FsErrorCode, r ), "SetTimes", p )
	end if

	return Ok( of boolean, FsError )( TRUE )
end function

'' ------------------------------------------------------ CopyDir options
''
'' RFC-0007 section 3. This overload lives HERE rather than in fsops.bi because
'' preserving permissions and timestamps needs this file's API, and putting it
'' the other way round would make fsops.bi depend on fslink.bi while fslink.bi
'' already depends on fsops.bi.
''
'' THE NO-OPTIONS OVERLOAD IN fsops.bi KEEPS ITS PHASE-3 BEHAVIOUR EXACTLY, so
'' nothing that compiled before this phase changes meaning now. That is the
'' contract RFC-0007 section 3 makes, and phase 3's CopyDir tests still pass
'' unchanged -- which is what proves it.

type CopyOptions
	'' Constructed, not zero-initialised: CopySymlinksAsLinks defaults TRUE
	'' and a dim'd UDT would come out FALSE.
	declare constructor( )

	as boolean PreserveTimestamps   '' default FALSE
	as boolean PreservePermissions  '' default FALSE
	as boolean CopySymlinksAsLinks  '' default TRUE
	as boolean Overwrite            '' default FALSE
end type

private constructor CopyOptions( )
	this.PreserveTimestamps  = FALSE
	this.PreservePermissions = FALSE
	this.CopySymlinksAsLinks = TRUE
	this.Overwrite           = FALSE
end constructor

declare function CopyDir overload ( byref src as const ustring, byref dst as const ustring, byref opts as const CopyOptions ) as FsResultI64

'' PreservePermissions is SetPosixMode on POSIX and the attribute word on
'' Windows -- the same operation on each platform's OWN model, not a
'' translation between them. There is no portable mode to translate.
private sub hCopyMeta( byref src as const ustring, byref dst as const ustring, byref opts as const CopyOptions )
	if( opts.PreservePermissions ) then
		dim as ulong v = 0
		if( FsGetPermRaw( src, v ) = FS_OK ) then
			FsSetPermRaw( dst, v )
		end if
	end if

	'' Timestamps LAST: copying content and permissions both touch the
	'' modification time, so setting it first would be undone.
	if( opts.PreserveTimestamps ) then
		dim as FsResultInfo si = LStat( src )
		if( si.IsOk( ) ) then
			FsSetTimesRaw( dst, si.Value( ).ModifiedUtc( ), si.Value( ).AccessedUtc( ) )
		end if
	end if
end sub

private function CopyDir( byref src as const ustring, byref dst as const ustring, byref opts as const CopyOptions ) as FsResultI64
	dim as ustring asrc, adst

	dim as FsResultUStr ra = AbsolutePath( src )
	dim as FsResultUStr rb = AbsolutePath( dst )
	if( ra.IsOk( ) = FALSE ) then return Fail( of longint, FsError )( ra.Failure( ) )
	if( rb.IsOk( ) = FALSE ) then return Fail( of longint, FsError )( rb.Failure( ) )

	asrc = PathNormalize( ra.Value( ) )
	adst = PathNormalize( rb.Value( ) )

	'' Without this the call never terminates -- see fsops.bi.
	if( PathStartsWith( adst, asrc ) ) then
		return FsFail( of longint )( FS_INVALID_PATH, "CopyDir", dst )
	end if

	dim as FsResultBool made = CreateDirAll( dst )
	if( made.IsOk( ) = FALSE ) then
		return Fail( of longint, FsError )( made.Failure( ) )
	end if

	dim as Array( of DirEntry ) entries
	dim as FsResultLong listed = ListDir( src, entries )
	if( listed.IsOk( ) = FALSE ) then
		return Fail( of longint, FsError )( listed.Failure( ) )
	end if

	dim as longint created = 1

	for i as long = 0 to entries.Count( ) - 1
		dim as ustring target = PathJoin( dst, entries[i].Name( ) )

		'' A LINK IS RECREATED AS A LINK, not followed and copied. Following
		'' it would silently duplicate whatever it points at -- possibly an
		'' enormous tree, possibly one outside the source entirely.
		if( entries[i].IsSymlink( ) andalso opts.CopySymlinksAsLinks ) then
			dim as FsResultUStr tgt = ReadLink( entries[i].Path( ) )
			if( tgt.IsOk( ) ) then
				dim as FsResultBool mk = CreateSymlink( tgt.Value( ), target, entries[i].IsDirectory( ) )
				if( mk.IsOk( ) = FALSE ) then
					return Fail( of longint, FsError )( mk.Failure( ) )
				end if
				created += 1
				continue for
			end if
			'' unreadable link: fall through and treat it as its target
		end if

		if( entries[i].IsDirectory( ) andalso ( entries[i].IsSymlink( ) = FALSE ) ) then
			dim as FsResultI64 sub_ = CopyDir( entries[i].Path( ), target, opts )
			if( sub_.IsOk( ) = FALSE ) then return sub_
			created += sub_.Value( )
		else
			dim as FsResultBool c = CopyFile( entries[i].Path( ), target, opts.Overwrite )
			if( c.IsOk( ) = FALSE ) then
				return Fail( of longint, FsError )( c.Failure( ) )
			end if
			hCopyMeta( entries[i].Path( ), target, opts )
			created += 1
		end if
	next

	'' the directory's own metadata, after its contents are in place
	hCopyMeta( src, dst, opts )

	return Ok( of longint, FsError )( created )
end function

end namespace
