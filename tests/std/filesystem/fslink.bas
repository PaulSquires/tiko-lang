'' Links and permissions -- C:\dev\docs\filesystem\RFC-0007-links-permissions.md.
''
'' EVERY SYMLINK TEST SKIPS WITH A LOGGED REASON where links cannot be created,
'' and the skip condition is checked ONCE, up front, by actually trying. On
'' Windows that needs elevation or Developer Mode; a machine without either
'' still runs the whole suite, it just reports how many blocks it could not
'' exercise. Silent skipping is how a suite reports green on a platform it never
'' touched, so hCanSymlink prints its reason.
''
'' THIS SUITE ALSO CLOSES THE TWO BIGGEST GAPS LEFT BY PHASES 3 AND 4: that
'' RemoveDirAll UNLINKS a directory symlink instead of descending it, and that
'' WalkDir terminates on a symlink loop. Both are destructive or
'' non-terminating when wrong, and neither could be tested before links existed.

#import "std/fs"
#import "std/outcome"
#import "std/containers"
#include "fbcunit.bi"

#include once "fberror.bi"

using fs, outcome, containers

using FB
private function hTempTree( ) as ustring
	dim as FsResultUStr r = CreateTempDir( "fbculink" )
	if( r.IsOk( ) = FALSE ) then return ""
	return r.Value( )
end function

'' Tries once, for real, and says why not. Cached so the reason prints once.
private function hCanSymlink( ) as boolean
	static as boolean tried, ok

	if( tried ) then return ok
	tried = TRUE

	dim as ustring root = hTempTree( )
	if( len( root ) = 0 ) then return FALSE

	dim as ustring tgt = PathJoin( root, "t" )
	WriteAllText( tgt, "x" )

	dim as FsResultBool r = CreateSymlink( tgt, PathJoin( root, "l" ) )
	ok = r.IsOk( )

	if( ok = FALSE ) then
		print
		print "  [fslink] symlink tests SKIPPED: "; r.Failure( ).Message( ); _
		      " (code "; r.Failure( ).Code( ); ")"
		print "  [fslink] on Windows this needs elevation or Developer Mode."
	end if

	RemoveDirAll( root )
	return ok
end function

SUITE( fbc_tests.filesystem.fslink )

	'' ARGUMENT ORDER IS (target, link). Asserted with two DISTINGUISHABLE
	'' paths, so a reversed implementation cannot pass by accident -- a
	'' symmetric fixture would let it through.
	TEST( symlink_argument_order_is_target_then_link )
		if( hCanSymlink( ) = FALSE ) then exit sub

		dim as ustring root = hTempTree( )
		dim as ustring tgt = PathJoin( root, "THE_TARGET.txt" )
		dim as ustring lnk = PathJoin( root, "THE_LINK.txt" )

		WriteAllText( tgt, "target content" )
		CU_ASSERT_TRUE( CreateSymlink( tgt, lnk ).IsOk( ) )

		'' the LINK is what got created
		CU_ASSERT_TRUE ( IsLink( lnk ) )
		CU_ASSERT_FALSE( IsLink( tgt ) )

		'' and it points AT THE TARGET
		dim as FsResultUStr rl = ReadLink( lnk )
		CU_ASSERT_TRUE( rl.IsOk( ) )
		CU_ASSERT_TRUE( PathEquals( rl.Value( ), tgt ) )

		'' reading through the link reaches the target's content
		CU_ASSERT_EQUAL( ReadAllText( lnk ).Value( ), "target content" )

		RemoveDirAll( root )
	END_TEST

	'' Cross-checks RFC-0003: Stat FOLLOWS and reports the target's kind and
	'' size; LStat does NOT and reports IsSymlink. A Stat result with
	'' IsSymlink true would be a contradiction.
	TEST( stat_follows_lstat_does_not )
		if( hCanSymlink( ) = FALSE ) then exit sub

		dim as ustring root = hTempTree( )
		dim as ustring tgt = PathJoin( root, "t.txt" )
		dim as ustring lnk = PathJoin( root, "l.txt" )

		WriteAllText( tgt, "12345" )
		CU_ASSERT_TRUE( CreateSymlink( tgt, lnk ).IsOk( ) )

		dim as FsResultInfo s = Stat( lnk )
		CU_ASSERT_TRUE ( s.IsOk( ) )
		CU_ASSERT_TRUE ( s.Value( ).IsFile( ) )
		CU_ASSERT_FALSE( s.Value( ).IsSymlink( ) )
		CU_ASSERT_EQUAL( s.Value( ).Size( ), 5 )

		dim as FsResultInfo l = LStat( lnk )
		CU_ASSERT_TRUE ( l.IsOk( ) )
		CU_ASSERT_TRUE ( l.Value( ).IsSymlink( ) )
		CU_ASSERT_FALSE( l.Value( ).IsFile( ) )

		RemoveDirAll( root )
	END_TEST

	'' A dangling link is a real thing and must stay readable -- which is
	'' exactly why ReadLink does not canonicalize.
	TEST( dangling_link_is_readable )
		if( hCanSymlink( ) = FALSE ) then exit sub

		dim as ustring root = hTempTree( )
		dim as ustring gone = PathJoin( root, "never_existed.txt" )
		dim as ustring lnk = PathJoin( root, "dangling" )

		CU_ASSERT_TRUE( CreateSymlink( gone, lnk ).IsOk( ) )

		'' LStat succeeds -- the LINK exists
		CU_ASSERT_TRUE( LStat( lnk ).IsOk( ) )
		CU_ASSERT_TRUE( LStat( lnk ).Value( ).IsSymlink( ) )

		'' Stat follows and finds nothing
		dim as FsResultInfo s = Stat( lnk )
		CU_ASSERT_FALSE( s.IsOk( ) )
		CU_ASSERT_EQUAL( s.Failure( ).Code( ), FS_NOT_FOUND )

		'' but the stored target comes back unchanged
		dim as FsResultUStr rl = ReadLink( lnk )
		CU_ASSERT_TRUE( rl.IsOk( ) )
		CU_ASSERT_TRUE( PathEquals( rl.Value( ), gone ) )

		RemoveDirAll( root )
	END_TEST

	'' A relative target stays relative. Canonicalizing here would destroy
	'' that, which is why ReadLink returns the target AS STORED.
	TEST( relative_link_target_is_verbatim )
		if( hCanSymlink( ) = FALSE ) then exit sub

		dim as ustring root = hTempTree( )
		WriteAllText( PathJoin( root, "real.txt" ), "r" )

		CU_ASSERT_TRUE( CreateSymlink( "real.txt", PathJoin( root, "rel" ) ).IsOk( ) )

		dim as FsResultUStr rl = ReadLink( PathJoin( root, "rel" ) )
		CU_ASSERT_TRUE( rl.IsOk( ) )
		CU_ASSERT_EQUAL( rl.Value( ), "real.txt" )

		RemoveDirAll( root )
	END_TEST

	'' FS_INVALID_PATH on both platforms, so "this is not a link" is one code
	'' everywhere -- Windows reports ERROR_NOT_A_REPARSE_POINT and POSIX
	'' reports EINVAL, and both are mapped to it.
	TEST( readlink_on_a_non_link_is_invalid_path )
		dim as ustring root = hTempTree( )
		dim as ustring f = PathJoin( root, "plain.txt" )
		WriteAllText( f, "x" )

		dim as FsResultUStr rl = ReadLink( f )
		CU_ASSERT_FALSE( rl.IsOk( ) )
		CU_ASSERT_EQUAL( rl.Failure( ).Code( ), FS_INVALID_PATH )

		'' and IsLink is simply false, never raising
		CU_ASSERT_FALSE( IsLink( f ) )
		CU_ASSERT_FALSE( IsLink( PathJoin( root, "nothing_here" ) ) )

		RemoveDirAll( root )
	END_TEST

	'' Hard links: both names are the same file, so a write through one is
	'' visible through the other and LinkCount reports the sharing.
	TEST( hard_links_share_one_file )
		dim as ustring root = hTempTree( )
		dim as ustring a = PathJoin( root, "a.txt" )
		dim as ustring b = PathJoin( root, "b.txt" )

		WriteAllText( a, "shared" )
		CU_ASSERT_EQUAL( LinkCount( a ).Value( ), 1 )

		dim as FsResultBool hl = CreateHardLink( a, b )
		if( hl.IsOk( ) = FALSE ) then
			print "  [fslink] hard-link test SKIPPED: "; hl.Failure( ).Message( )
			RemoveDirAll( root )
			exit sub
		end if

		CU_ASSERT_EQUAL( LinkCount( a ).Value( ), 2 )
		CU_ASSERT_EQUAL( LinkCount( b ).Value( ), 2 )
		CU_ASSERT_EQUAL( ReadAllText( b ).Value( ), "shared" )

		'' a write through one name is visible through the other
		WriteAllText( b, "rewritten" )
		CU_ASSERT_EQUAL( ReadAllText( a ).Value( ), "rewritten" )

		'' deleting one leaves the other readable, with the count back to 1
		CU_ASSERT_TRUE( RemoveFile( b ).IsOk( ) )
		CU_ASSERT_TRUE( Exists( a ) )
		CU_ASSERT_EQUAL( LinkCount( a ).Value( ), 1 )

		RemoveDirAll( root )
	END_TEST

	'' ============================================================
	'' THE TWO RULES PHASES 3 AND 4 COULD NOT TEST
	'' ============================================================

	'' RemoveDirAll UNLINKS a directory symlink and NEVER DESCENDS IT. This is
	'' what stops rm -rf on a tree containing a link to somewhere else from
	'' doing what it sounds like, and it is the single most important
	'' destructive-behaviour assertion in the module.
	''
	'' The target's contents are checked AFTERWARDS -- asserting only that the
	'' call succeeded would pass even if it had deleted everything.
	TEST( removedirall_unlinks_and_does_not_descend )
		if( hCanSymlink( ) = FALSE ) then exit sub

		dim as ustring outside = hTempTree( )
		dim as ustring victim = PathJoin( outside, "PRECIOUS.txt" )
		WriteAllText( victim, "must survive" )

		dim as ustring root = hTempTree( )
		WriteAllText( PathJoin( root, "ordinary.txt" ), "x" )

		'' a DIRECTORY symlink pointing outside the tree being removed
		dim as FsResultBool mk = CreateSymlink( outside, PathJoin( root, "escape" ), TRUE )
		if( mk.IsOk( ) = FALSE ) then
			print "  [fslink] dir-symlink test SKIPPED: "; mk.Failure( ).Message( )
			RemoveDirAll( root )
			RemoveDirAll( outside )
			exit sub
		end if

		CU_ASSERT_TRUE( RemoveDirAll( root ).IsOk( ) )
		CU_ASSERT_FALSE( Exists( root ) )

		'' THE POINT: the link's target is untouched
		CU_ASSERT_TRUE ( Exists( outside ) )
		CU_ASSERT_TRUE ( Exists( victim ) )
		CU_ASSERT_EQUAL( ReadAllText( victim ).Value( ), "must survive" )

		RemoveDirAll( outside )
	END_TEST

	'' WalkDir does not follow directory symlinks by default, so a link to an
	'' ancestor cannot make the walk infinite. The assertion is really "it
	'' terminates", since the failure mode of getting this wrong is a hang.
	TEST( walk_does_not_follow_links_by_default )
		if( hCanSymlink( ) = FALSE ) then exit sub

		dim as ustring root = hTempTree( )
		CreateDirAll( PathJoin( root, "sub" ) )
		WriteAllText( PathJoin( root, "sub", "f.txt" ), "x" )

		'' a link pointing back at its own parent -- an infinite tree if
		'' followed
		dim as FsResultBool mk = CreateSymlink( root, PathJoin( root, "sub", "loop" ), TRUE )
		if( mk.IsOk( ) = FALSE ) then
			print "  [fslink] loop test SKIPPED: "; mk.Failure( ).Message( )
			RemoveDirAll( root )
			exit sub
		end if

		dim as long n = 0, links = 0
		for each r in WalkDir( root )
			if( r.IsOk( ) ) then
				n += 1
				if( r.Value( ).IsSymlink( ) ) then links += 1
			end if
			if( n > 500 ) then exit for      '' would only trip on a loop
		next

		'' sub, f.txt, loop
		CU_ASSERT_EQUAL( n, 3 )
		CU_ASSERT_EQUAL( links, 1 )

		RemoveDirAll( root )
	END_TEST

	'' With FollowSymlinks the visited set becomes mandatory. It is scoped to
	'' the CURRENT PATH, so a genuine cycle is cut with FS_LOOP while a
	'' directory legitimately reachable twice is still visited twice.
	TEST( walk_following_links_cuts_the_cycle )
		if( hCanSymlink( ) = FALSE ) then exit sub

		dim as ustring root = hTempTree( )
		CreateDirAll( PathJoin( root, "sub" ) )
		WriteAllText( PathJoin( root, "sub", "f.txt" ), "x" )

		dim as FsResultBool mk = CreateSymlink( root, PathJoin( root, "sub", "loop" ), TRUE )
		if( mk.IsOk( ) = FALSE ) then
			print "  [fslink] follow-loop test SKIPPED: "; mk.Failure( ).Message( )
			RemoveDirAll( root )
			exit sub
		end if

		dim as WalkOptions o
		o.FollowSymlinks = TRUE

		dim as long n = 0
		for each r in WalkDir( root, o )
			n += 1
			if( n > 500 ) then exit for      '' the loop guard
		next

		'' TERMINATION is the assertion. Without the visited set this never
		'' finishes; the bound proves it did.
		CU_ASSERT_TRUE( n < 500 )

		RemoveDirAll( root )
	END_TEST

	'' ------------------------------------------------------- permissions

	'' Genuinely portable, and NOT an exact inverse on POSIX -- clearing
	'' restores the write bits subject to umask. The lossiness is asserted as
	'' lossiness rather than asserted away.
	TEST( setreadonly_round_trip )
		dim as ustring root = hTempTree( )
		dim as ustring f = PathJoin( root, "ro.txt" )
		WriteAllText( f, "x" )

		CU_ASSERT_FALSE( Stat( f ).Value( ).IsReadOnly( ) )

		CU_ASSERT_TRUE( SetReadOnly( f, TRUE ).IsOk( ) )
		CU_ASSERT_TRUE( Stat( f ).Value( ).IsReadOnly( ) )

		'' A read-only file refuses deletion, with a specific code -- ON WINDOWS.
		'' POSIX takes deletion permission from the DIRECTORY, not the file, so a
		'' read-only file in a writable directory is removed without complaint and
		'' there is no refusal to observe. Attempting it anyway would also delete
		'' the file the rest of this test still needs.
		#if defined( __FB_WIN32__ )
			dim as FsResultBool rm = RemoveFile( f )
			CU_ASSERT_FALSE( rm.IsOk( ) )
			if( rm.IsOk( ) = FALSE ) then
				CU_ASSERT_EQUAL( rm.Failure( ).Code( ), FS_READ_ONLY )
			end if
		#endif

		CU_ASSERT_TRUE ( SetReadOnly( f, FALSE ).IsOk( ) )
		CU_ASSERT_FALSE( Stat( f ).Value( ).IsReadOnly( ) )
		CU_ASSERT_TRUE ( RemoveFile( f ).IsOk( ) )

		RemoveDirAll( root )
	END_TEST

	'' Each of the platform-specific pairs returns exactly FS_UNSUPPORTED off
	'' its own platform -- never FS_UNKNOWN, because a caller must be able to
	'' branch on it once rather than treat it as transient.
	TEST( off_platform_calls_are_unsupported )
		dim as ustring root = hTempTree( )
		dim as ustring f = PathJoin( root, "p.txt" )
		WriteAllText( f, "x" )

		#if defined( __FB_WIN32__ )
			CU_ASSERT_FALSE( GetPosixMode( f ).IsOk( ) )
			CU_ASSERT_EQUAL( GetPosixMode( f ).Failure( ).Code( ), FS_UNSUPPORTED )
			CU_ASSERT_EQUAL( SetPosixMode( f, &o644 ).Failure( ).Code( ), FS_UNSUPPORTED )

			'' and the native pair works
			CU_ASSERT_TRUE( GetWin32Attributes( f ).IsOk( ) )
			CU_ASSERT_TRUE( SetHidden( f, TRUE ).IsOk( ) )
			CU_ASSERT_TRUE( Stat( f ).Value( ).IsHidden( ) )
			CU_ASSERT_TRUE( SetHidden( f, FALSE ).IsOk( ) )
		#else
			CU_ASSERT_FALSE( GetWin32Attributes( f ).IsOk( ) )
			CU_ASSERT_EQUAL( GetWin32Attributes( f ).Failure( ).Code( ), FS_UNSUPPORTED )

			'' SetHidden is portable IN NAME ONLY and says so
			CU_ASSERT_EQUAL( SetHidden( f, TRUE ).Failure( ).Code( ), FS_UNSUPPORTED )

			'' and the native pair works
			CU_ASSERT_TRUE( GetPosixMode( f ).IsOk( ) )
			CU_ASSERT_TRUE( SetPosixMode( f, &o600 ).IsOk( ) )
			CU_ASSERT_EQUAL( GetPosixMode( f ).Value( ), &o600 )
		#endif

		RemoveDirAll( root )
	END_TEST

	'' ------------------------------------------------------ CopyOptions

	'' The no-options overload must keep its phase-3 behaviour EXACTLY, so
	'' nothing that compiled before this phase changes meaning now.
	TEST( copydir_without_options_is_unchanged )
		dim as ustring root = hTempTree( )
		dim as ustring src = PathJoin( root, "src" )
		dim as ustring dst = PathJoin( root, "dst" )

		CreateDirAll( PathJoin( src, "sub" ) )
		WriteAllText( PathJoin( src, "one.txt" ), "1" )
		WriteAllText( PathJoin( src, "sub", "two.txt" ), "22" )

		dim as FsResultI64 r = CopyDir( src, dst )
		CU_ASSERT_TRUE( r.IsOk( ) )
		CU_ASSERT_EQUAL( r.Value( ), 4 )
		CU_ASSERT_EQUAL( ReadAllText( PathJoin( dst, "sub", "two.txt" ) ).Value( ), "22" )

		RemoveDirAll( root )
	END_TEST

	TEST( copydir_preserves_timestamps_when_asked )
		dim as ustring root = hTempTree( )
		dim as ustring src = PathJoin( root, "src" )
		dim as ustring dst = PathJoin( root, "dst" )

		CreateDirAll( src )
		WriteAllText( PathJoin( src, "f.txt" ), "content" )

		'' push the source's time well into the past so a copied-now file
		'' could not match by accident
		dim as longint want = Stat( PathJoin( src, "f.txt" ) ).Value( ).ModifiedUtc( ) - 864000000000ll
		CU_ASSERT_TRUE( SetTimes( PathJoin( src, "f.txt" ), want ).IsOk( ) )

		dim as CopyOptions o
		o.PreserveTimestamps = TRUE

		CU_ASSERT_TRUE( CopyDir( src, dst, o ).IsOk( ) )

		dim as longint got = Stat( PathJoin( dst, "f.txt" ) ).Value( ).ModifiedUtc( )

		'' within one second: some filesystems store coarser than a tick
		CU_ASSERT_TRUE( abs( got - want ) < 10000000ll )

		RemoveDirAll( root )
	END_TEST

	'' WITHOUT the option the timestamp behaviour is PLATFORM-DEFINED, and
	'' this asserts the real divergence rather than a convenient fiction.
	''
	'' On Windows CopyFileW copies the source's last-write time as part of
	'' copying the file -- so a plain CopyDir preserves it whether you asked
	'' or not. On POSIX there is no copy syscall and the read/write loop
	'' creates an ordinary new file, which gets the current time.
	''
	'' Measured, not assumed: an earlier version of this test asserted "not
	'' preserved" on both platforms and failed on Windows. A caller who cares
	'' must pass PreserveTimestamps and not rely on the default either way.
	TEST( copydir_default_timestamp_behaviour_is_platform_defined )
		dim as ustring root = hTempTree( )
		dim as ustring src = PathJoin( root, "src" )
		dim as ustring dst = PathJoin( root, "dst" )

		CreateDirAll( src )
		WriteAllText( PathJoin( src, "f.txt" ), "content" )

		dim as longint old = Stat( PathJoin( src, "f.txt" ) ).Value( ).ModifiedUtc( ) - 864000000000ll
		SetTimes( PathJoin( src, "f.txt" ), old )

		CU_ASSERT_TRUE( CopyDir( src, dst ).IsOk( ) )

		dim as longint got = Stat( PathJoin( dst, "f.txt" ) ).Value( ).ModifiedUtc( )

		#if defined( __FB_WIN32__ )
			'' CopyFileW carried the time across on its own
			CU_ASSERT_TRUE( abs( got - old ) < 10000000ll )
		#else
			'' a fresh file from the read/write loop
			CU_ASSERT_TRUE( got > old + 10000000ll )
		#endif

		RemoveDirAll( root )
	END_TEST

	'' A link inside the source is RECREATED AS A LINK, not followed and
	'' copied -- following it would silently duplicate whatever it points at.
	TEST( copydir_recreates_symlinks_as_links )
		if( hCanSymlink( ) = FALSE ) then exit sub

		dim as ustring root = hTempTree( )
		dim as ustring src = PathJoin( root, "src" )
		dim as ustring dst = PathJoin( root, "dst" )

		CreateDirAll( src )
		WriteAllText( PathJoin( src, "real.txt" ), "R" )

		dim as FsResultBool mk = CreateSymlink( "real.txt", PathJoin( src, "alias" ) )
		if( mk.IsOk( ) = FALSE ) then
			print "  [fslink] copydir-symlink test SKIPPED: "; mk.Failure( ).Message( )
			RemoveDirAll( root )
			exit sub
		end if

		dim as CopyOptions o        '' CopySymlinksAsLinks defaults TRUE
		CU_ASSERT_TRUE( o.CopySymlinksAsLinks )
		CU_ASSERT_TRUE( CopyDir( src, dst, o ).IsOk( ) )

		CU_ASSERT_TRUE ( IsLink( PathJoin( dst, "alias" ) ) )
		CU_ASSERT_EQUAL( ReadLink( PathJoin( dst, "alias" ) ).Value( ), "real.txt" )

		RemoveDirAll( root )
	END_TEST

END_SUITE
