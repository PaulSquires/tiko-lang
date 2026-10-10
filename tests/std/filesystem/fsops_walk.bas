'' Whole-file IO, bulk operations and WalkDir -- RFC-0005 and RFC-0004 section 5.
''
'' Every fixture is built under CreateTempDir and torn down with RemoveDirAll,
'' which makes those two the functions the rest of the suite depends on -- so
'' they are tested FIRST and standalone, before anything else relies on them.
''
'' NOT ASSERTED HERE, and each is a deliberate omission rather than an
'' oversight:
''
''   - Symbolic links, including RemoveDirAll's unlink-do-not-descend rule and
''     WalkDir's loop protection. Creating a link on Windows needs elevation or
''     Developer Mode, so these would pass or skip by MACHINE rather than by
''     code. RFC-0007 owns them and carries the skip-with-a-logged-reason rule.
''   - MoveFile's cross-volume fallback, which needs two volumes.
''   - WriteAtomic's concurrent-reader property, which needs threads.
''
'' All four are listed in the phase-3 "not verified" note in the README rather
'' than quietly left out.

#import "std/fs"
#import "std/outcome"
#import "std/containers"
#include "fbcunit.bi"

#include once "fberror.bi"

using fs, outcome, containers

using FB
'' A fresh temp tree per test. Returns "" if it could not be made, and every
'' caller asserts that rather than proceeding into a bogus path.
private function hTempTree( ) as ustring
	dim as FsResultUStr r = CreateTempDir( "fbcuops" )
	if( r.IsOk( ) = FALSE ) then return ""
	return r.Value( )
end function

SUITE( fbc_tests.filesystem.fsops_walk )

	'' ------------------------------------------------- temp, first of all

	'' CREATES the object and returns its path -- it does not hand back a
	'' name for the caller to create, which is the classic tmpnam race.
	TEST( createtemp_creates_atomically_and_uniquely )
		dim as FsResultUStr d = CreateTempDir( "fbcuA" )
		CU_ASSERT_TRUE( d.IsOk( ) )
		CU_ASSERT_TRUE( IsDir( d.Value( ) ) )

		dim as FsResultUStr f = CreateTempFile( "fbcuB" )
		CU_ASSERT_TRUE( f.IsOk( ) )
		CU_ASSERT_TRUE( IsFile( f.Value( ) ) )

		'' the prefix must actually appear in the name
		CU_ASSERT_TRUE( instr( PathFileName( f.Value( ) ), "fbcuB" ) = 1 )

		'' MORE THAN 256 IN A ROW, and the number is load-bearing.
		''
		'' The runtime's temp-descriptor pool holds FB_STR_TMPDESCRIPTORS = 256
		'' entries (fb.h:33). An implementation that allocates a descriptor for
		'' its own internal use leaks one per call, and the pool does not run
		'' out until the 257th -- at which point the temp directory reads as
		'' empty and every subsequent file is attempted at the drive root,
		'' failing with a misleading FS_ACCESS_DENIED.
		''
		'' That bug was real and shipped in phase 3; the original version of
		'' this test looped 200 times and sat just under the threshold. 400 is
		'' chosen to cross it decisively.
		dim as Array( of ustring ) seen
		dim as long dupes = 0
		for i as long = 1 to 400
			dim as FsResultUStr t = CreateTempFile( "fbcuC" )
			CU_ASSERT_TRUE( t.IsOk( ) )
			for j as long = 0 to seen.Count( ) - 1
				if( seen[j] = t.Value( ) ) then dupes += 1
			next
			seen.Push( t.Value( ) )
		next
		CU_ASSERT_EQUAL( dupes, 0 )

		for j as long = 0 to seen.Count( ) - 1
			RemoveFile( seen[j] )
		next
		RemoveFile( f.Value( ) )
		RemoveDir( d.Value( ) )
	END_TEST

	TEST( tempdir_exists_and_has_no_trailing_separator )
		dim as FsResultUStr t = TempDir( )
		CU_ASSERT_TRUE( t.IsOk( ) )
		CU_ASSERT_TRUE( IsDir( t.Value( ) ) )
		CU_ASSERT_FALSE( PathIsRoot( t.Value( ) ) )
		CU_ASSERT_EQUAL( PathNormalize( t.Value( ) ), t.Value( ) )
	END_TEST

	'' rm -rf: removes everything and reports how much. Tested before the
	'' rest of the suite starts relying on it for teardown.
	TEST( removedirall_removes_tree_and_counts )
		dim as ustring root = hTempTree( )
		CU_ASSERT_TRUE( len( root ) > 0 )

		CreateDirAll( PathJoin( root, "a", "b" ) )
		WriteAllText( PathJoin( root, "f1.txt" ), "1" )
		WriteAllText( PathJoin( root, "a", "f2.txt" ), "2" )
		WriteAllText( PathJoin( root, "a", "b", "f3.txt" ), "3" )

		dim as FsResultI64 rm = RemoveDirAll( root )
		CU_ASSERT_TRUE( rm.IsOk( ) )

		'' root + a + b + three files
		CU_ASSERT_EQUAL( rm.Value( ), 6 )
		CU_ASSERT_FALSE( Exists( root ) )
	END_TEST

	'' rm -rf must clear the read-only attribute, or it fails partway through
	'' a checked-out repository -- the worst outcome for a destructive call.
	TEST( removedirall_clears_readonly )
		dim as ustring root = hTempTree( )
		CU_ASSERT_TRUE( len( root ) > 0 )

		dim as ustring f = PathJoin( root, "ro.txt" )
		WriteAllText( f, "x" )
		FsSetReadOnlyRaw( f, 1 )

		'' RemoveFile alone must REFUSE, and say why -- ON WINDOWS. On POSIX the
		'' read-only bit is the file's own mode and says nothing about whether it
		'' may be unlinked; that is the containing directory's permission. So
		'' there is nothing for RemoveDirAll to clear either, and it succeeds
		'' below for the ordinary reason rather than the interesting one.
		#if defined( __FB_WIN32__ )
			dim as FsResultBool one = RemoveFile( f )
			CU_ASSERT_FALSE( one.IsOk( ) )
			if( one.IsOk( ) = FALSE ) then
				CU_ASSERT_EQUAL( one.Failure( ).Code( ), FS_READ_ONLY )
			end if
		#endif

		'' RemoveDirAll must succeed anyway
		dim as FsResultI64 rm = RemoveDirAll( root )
		CU_ASSERT_TRUE( rm.IsOk( ) )
		CU_ASSERT_FALSE( Exists( root ) )
	END_TEST

	TEST( removedirall_missing_is_not_found )
		dim as FsResultI64 rm = RemoveDirAll( "C:\definitely\not\here" )
		CU_ASSERT_FALSE( rm.IsOk( ) )
		CU_ASSERT_EQUAL( rm.Failure( ).Code( ), FS_NOT_FOUND )
	END_TEST

	'' ------------------------------------------------------- whole file

	TEST( text_roundtrip )
		dim as ustring root = hTempTree( )
		dim as ustring f = PathJoin( root, "t.txt" )

		'' empty, ASCII, astral, and something large
		CU_ASSERT_TRUE( WriteAllText( f, "" ).IsOk( ) )
		CU_ASSERT_EQUAL( ReadAllText( f ).Value( ), "" )

		CU_ASSERT_TRUE( WriteAllText( f, "hello" ).IsOk( ) )
		CU_ASSERT_EQUAL( ReadAllText( f ).Value( ), "hello" )

		dim as ustring astral = wchr( &hD83D ) + wchr( &hDE00 ) + "x"
		CU_ASSERT_TRUE( WriteAllText( f, astral ).IsOk( ) )
		CU_ASSERT_EQUAL( ReadAllText( f ).Value( ), astral )

		'' string( n, ch ) then widened: there is no ustring( n, fill )
		dim as ustring big = string( 100000, "z" )
		CU_ASSERT_TRUE( WriteAllText( f, big ).IsOk( ) )
		CU_ASSERT_EQUAL( len( ReadAllText( f ).Value( ) ), 100000 )

		RemoveDirAll( root )
	END_TEST

	'' Rule 4: UTF-8 and NO BOM. Asserted on the RAW BYTES, because that is
	'' the only way to tell "no BOM written" from "BOM written and consumed".
	TEST( writealltext_is_utf8_with_no_bom )
		dim as ustring root = hTempTree( )
		dim as ustring f = PathJoin( root, "b.txt" )

		WriteAllText( f, "hi" )

		dim as Array( of ubyte ) bytes
		dim as FsResultI64 n = ReadAllBytes( f, bytes )
		CU_ASSERT_TRUE( n.IsOk( ) )
		CU_ASSERT_EQUAL( n.Value( ), 2 )
		CU_ASSERT_EQUAL( bytes[0], asc( "h" ) )
		CU_ASSERT_EQUAL( bytes[1], asc( "i" ) )

		RemoveDirAll( root )
	END_TEST

	'' Rule 1: a BOM is honoured AND consumed -- it is not part of the text.
	TEST( bom_is_honoured_and_consumed )
		dim as ustring root = hTempTree( )
		dim as ustring f = PathJoin( root, "bom.txt" )
		dim as Array( of ubyte ) b

		'' UTF-8 BOM + "hi"
		b.Clear( ) : b.Push( &hEF ) : b.Push( &hBB ) : b.Push( &hBF )
		b.Push( asc( "h" ) ) : b.Push( asc( "i" ) )
		CU_ASSERT_TRUE( WriteAllBytes( f, b ).IsOk( ) )
		CU_ASSERT_EQUAL( ReadAllText( f ).Value( ), "hi" )

		'' UTF-16LE BOM + "hi"
		b.Clear( ) : b.Push( &hFF ) : b.Push( &hFE )
		b.Push( asc( "h" ) ) : b.Push( 0 ) : b.Push( asc( "i" ) ) : b.Push( 0 )
		CU_ASSERT_TRUE( WriteAllBytes( f, b ).IsOk( ) )
		CU_ASSERT_EQUAL( ReadAllText( f ).Value( ), "hi" )

		'' UTF-16BE BOM + "hi"
		b.Clear( ) : b.Push( &hFE ) : b.Push( &hFF )
		b.Push( 0 ) : b.Push( asc( "h" ) ) : b.Push( 0 ) : b.Push( asc( "i" ) )
		CU_ASSERT_TRUE( WriteAllBytes( f, b ).IsOk( ) )
		CU_ASSERT_EQUAL( ReadAllText( f ).Value( ), "hi" )

		RemoveDirAll( root )
	END_TEST

	'' Rule 3: invalid input is REPLACED, not rejected. ReadAllText on binary
	'' succeeds and returns mojibake; a caller who needs to know reads bytes.
	TEST( invalid_utf8_is_replaced_not_rejected )
		dim as ustring root = hTempTree( )
		dim as ustring f = PathJoin( root, "bin.dat" )
		dim as Array( of ubyte ) b

		b.Push( asc( "a" ) ) : b.Push( &hFF ) : b.Push( &hFE ) : b.Push( asc( "b" ) )
		'' not a BOM: &hFF &hFE is only a BOM at offset 0, and this starts
		'' with 'a'
		CU_ASSERT_TRUE( WriteAllBytes( f, b ).IsOk( ) )

		dim as FsResultUStr t = ReadAllText( f )
		CU_ASSERT_TRUE( t.IsOk( ) )            '' SUCCEEDS, does not fail
		CU_ASSERT_TRUE( len( t.Value( ) ) > 0 )

		RemoveDirAll( root )
	END_TEST

	'' Rule 5: CRLF, LF and mixed all give the SAME lines; a final newline
	'' does NOT produce a trailing empty line; a lone \r is NOT a terminator.
	TEST( readalllines_rules )
		dim as ustring root = hTempTree( )
		dim as ustring f = PathJoin( root, "l.txt" )
		dim as Array( of ustring ) lines

		WriteAllText( f, "a" & chr(10) & "b" & chr(10) )
		CU_ASSERT_EQUAL( ReadAllLines( f, lines ).Value( ), 2 )
		CU_ASSERT_EQUAL( lines[0], "a" )
		CU_ASSERT_EQUAL( lines[1], "b" )

		WriteAllText( f, "a" & chr(13) & chr(10) & "b" & chr(13) & chr(10) )
		CU_ASSERT_EQUAL( ReadAllLines( f, lines ).Value( ), 2 )
		CU_ASSERT_EQUAL( lines[0], "a" )
		CU_ASSERT_EQUAL( lines[1], "b" )

		'' mixed
		WriteAllText( f, "a" & chr(13) & chr(10) & "b" & chr(10) & "c" )
		CU_ASSERT_EQUAL( ReadAllLines( f, lines ).Value( ), 3 )
		CU_ASSERT_EQUAL( lines[2], "c" )

		'' an empty file is ZERO lines, not one empty line
		WriteAllText( f, "" )
		CU_ASSERT_EQUAL( ReadAllLines( f, lines ).Value( ), 0 )

		'' a lone \r is NOT a line terminator -- it is 2026
		WriteAllText( f, "a" & chr(13) & "b" )
		CU_ASSERT_EQUAL( ReadAllLines( f, lines ).Value( ), 1 )

		RemoveDirAll( root )
	END_TEST

	TEST( append_adds_and_does_not_truncate )
		dim as ustring root = hTempTree( )
		dim as ustring f = PathJoin( root, "ap.txt" )

		WriteAllText( f, "one" )
		CU_ASSERT_TRUE( AppendAllText( f, "two" ).IsOk( ) )
		CU_ASSERT_EQUAL( ReadAllText( f ).Value( ), "onetwo" )

		RemoveDirAll( root )
	END_TEST

	'' Both platforms must agree, and Windows has no such code natively -- it
	'' is synthesised. This assertion is what would fail if that check were
	'' dropped.
	TEST( readalltext_on_a_directory_is_is_a_directory )
		dim as ustring root = hTempTree( )

		dim as FsResultUStr t = ReadAllText( root )
		CU_ASSERT_FALSE( t.IsOk( ) )
		CU_ASSERT_EQUAL( t.Failure( ).Code( ), FS_IS_A_DIRECTORY )

		RemoveDirAll( root )
	END_TEST

	TEST( readalltext_missing_is_not_found )
		dim as FsResultUStr t = ReadAllText( "C:\definitely\not\here.txt" )
		CU_ASSERT_FALSE( t.IsOk( ) )
		CU_ASSERT_EQUAL( t.Failure( ).Code( ), FS_NOT_FOUND )
	END_TEST

	'' ReadAllBytes returns a COPY. Pinned so that a future memory-mapping API
	'' cannot be quietly grafted onto the reading API (RFC-0009 section 6).
	TEST( readallbytes_returns_a_copy )
		dim as ustring root = hTempTree( )
		dim as ustring f = PathJoin( root, "c.dat" )
		dim as Array( of ubyte ) b

		WriteAllText( f, "abc" )
		CU_ASSERT_EQUAL( ReadAllBytes( f, b ).Value( ), 3 )

		b[0] = asc( "Z" )
		CU_ASSERT_EQUAL( ReadAllText( f ).Value( ), "abc" )   '' unchanged

		RemoveDirAll( root )
	END_TEST

	'' -------------------------------------------------------- directories

	'' CreateDir FAILS if the target exists; CreateDirAll SUCCEEDS. That is
	'' the difference, and it is the whole point of having both.
	TEST( createdir_vs_createdirall )
		dim as ustring root = hTempTree( )
		dim as ustring d = PathJoin( root, "one" )

		CU_ASSERT_TRUE( CreateDir( d ).IsOk( ) )

		dim as FsResultBool again = CreateDir( d )
		CU_ASSERT_FALSE( again.IsOk( ) )
		CU_ASSERT_EQUAL( again.Failure( ).Code( ), FS_ALREADY_EXISTS )

		CU_ASSERT_TRUE( CreateDirAll( d ).IsOk( ) )      '' succeeds

		'' five levels at once
		dim as ustring deep = PathJoin( PathJoin( root, "a", "b" ), "c", "d" )
		CU_ASSERT_TRUE( CreateDirAll( deep ).IsOk( ) )
		CU_ASSERT_TRUE( IsDir( deep ) )

		RemoveDirAll( root )
	END_TEST

	'' A FILE in the way is FS_NOT_A_DIRECTORY, not the confusing
	'' FS_ACCESS_DENIED the OS would otherwise report.
	TEST( createdirall_through_a_file_is_not_a_directory )
		dim as ustring root = hTempTree( )
		dim as ustring f = PathJoin( root, "blocker" )

		WriteAllText( f, "x" )

		dim as FsResultBool r = CreateDirAll( PathJoin( f, "under" ) )
		CU_ASSERT_FALSE( r.IsOk( ) )
		CU_ASSERT_EQUAL( r.Failure( ).Code( ), FS_NOT_A_DIRECTORY )

		RemoveDirAll( root )
	END_TEST

	TEST( removedir_on_populated_is_dir_not_empty )
		dim as ustring root = hTempTree( )
		CreateDir( PathJoin( root, "d" ) )
		WriteAllText( PathJoin( root, "d", "f" ), "x" )

		dim as FsResultBool r = RemoveDir( PathJoin( root, "d" ) )
		CU_ASSERT_FALSE( r.IsOk( ) )
		CU_ASSERT_EQUAL( r.Failure( ).Code( ), FS_DIR_NOT_EMPTY )

		RemoveDirAll( root )
	END_TEST

	TEST( removefile_on_a_directory_is_is_a_directory )
		dim as ustring root = hTempTree( )
		CreateDir( PathJoin( root, "d" ) )

		dim as FsResultBool r = RemoveFile( PathJoin( root, "d" ) )
		CU_ASSERT_FALSE( r.IsOk( ) )
		CU_ASSERT_EQUAL( r.Failure( ).Code( ), FS_IS_A_DIRECTORY )

		RemoveDirAll( root )
	END_TEST

	'' ------------------------------------------------------------ copy

	'' Defaults to NOT overwriting. The legacy FileCopy overwrites
	'' unconditionally; that default has cost people data.
	TEST( copyfile_does_not_overwrite_by_default )
		dim as ustring root = hTempTree( )
		dim as ustring a = PathJoin( root, "a.txt" )
		dim as ustring b = PathJoin( root, "b.txt" )

		WriteAllText( a, "AAA" )
		WriteAllText( b, "BBB" )

		dim as FsResultBool c = CopyFile( a, b )
		CU_ASSERT_FALSE( c.IsOk( ) )
		CU_ASSERT_EQUAL( c.Failure( ).Code( ), FS_ALREADY_EXISTS )
		CU_ASSERT_EQUAL( ReadAllText( b ).Value( ), "BBB" )   '' untouched

		CU_ASSERT_TRUE( CopyFile( a, b, TRUE ).IsOk( ) )
		CU_ASSERT_EQUAL( ReadAllText( b ).Value( ), "AAA" )

		RemoveDirAll( root )
	END_TEST

	'' Without this check CopyDir( a, a\b ) never terminates, so the assertion
	'' is really "it returns at all" -- and it must return the right code.
	TEST( copydir_refuses_destination_inside_source )
		dim as ustring root = hTempTree( )
		dim as ustring src = PathJoin( root, "src" )

		CreateDirAll( src )
		WriteAllText( PathJoin( src, "f.txt" ), "x" )

		dim as FsResultI64 r = CopyDir( src, PathJoin( src, "inner" ) )
		CU_ASSERT_FALSE( r.IsOk( ) )
		CU_ASSERT_EQUAL( r.Failure( ).Code( ), FS_INVALID_PATH )

		RemoveDirAll( root )
	END_TEST

	TEST( copydir_copies_tree_and_counts )
		dim as ustring root = hTempTree( )
		dim as ustring src = PathJoin( root, "src" )
		dim as ustring dst = PathJoin( root, "dst" )

		CreateDirAll( PathJoin( src, "sub" ) )
		WriteAllText( PathJoin( src, "one.txt" ), "1" )
		WriteAllText( PathJoin( src, "sub", "two.txt" ), "22" )

		dim as FsResultI64 r = CopyDir( src, dst )
		CU_ASSERT_TRUE( r.IsOk( ) )

		'' dst + one.txt + sub + two.txt
		CU_ASSERT_EQUAL( r.Value( ), 4 )
		CU_ASSERT_EQUAL( ReadAllText( PathJoin( dst, "one.txt" ) ).Value( ), "1" )
		CU_ASSERT_EQUAL( ReadAllText( PathJoin( dst, "sub", "two.txt" ) ).Value( ), "22" )

		RemoveDirAll( root )
	END_TEST

	TEST( movefile_moves_and_source_is_gone )
		dim as ustring root = hTempTree( )
		dim as ustring a = PathJoin( root, "m1.txt" )
		dim as ustring b = PathJoin( root, "m2.txt" )

		WriteAllText( a, "move me" )
		CU_ASSERT_TRUE( MoveFile( a, b ).IsOk( ) )
		CU_ASSERT_FALSE( Exists( a ) )
		CU_ASSERT_EQUAL( ReadAllText( b ).Value( ), "move me" )

		RemoveDirAll( root )
	END_TEST

	'' ------------------------------------------------------ atomic write

	TEST( writeatomic_replaces_and_leaves_no_temp )
		dim as ustring root = hTempTree( )
		dim as ustring f = PathJoin( root, "at.txt" )

		'' first write: the target does not exist yet, which is the path
		'' where ReplaceFileW fails and the rename fallback must take over
		CU_ASSERT_TRUE( WriteAtomic( f, "first" ).IsOk( ) )
		CU_ASSERT_EQUAL( ReadAllText( f ).Value( ), "first" )

		CU_ASSERT_TRUE( WriteAtomic( f, "second" ).IsOk( ) )
		CU_ASSERT_EQUAL( ReadAllText( f ).Value( ), "second" )

		'' exactly one file in the directory: no temporary left behind
		dim as Array( of DirEntry ) entries
		CU_ASSERT_EQUAL( ListDir( root, entries ).Value( ), 1 )

		RemoveDirAll( root )
	END_TEST

	'' ---------------------------------------------------------- WalkDir

	'' Rules 1 and 2: pre-order, and the ROOT ITSELF IS NOT YIELDED. Its
	'' immediate children are at depth 0.
	TEST( walk_is_preorder_and_omits_the_root )
		dim as ustring root = hTempTree( )

		CreateDirAll( PathJoin( root, "a", "b" ) )
		WriteAllText( PathJoin( root, "a", "b", "deep.txt" ), "d" )
		WriteAllText( PathJoin( root, "top.txt" ), "t" )

		dim as Array( of ustring ) names
		dim as Array( of long ) depths

		for each r in WalkDir( root )
			CU_ASSERT_TRUE( r.IsOk( ) )
			if( r.IsOk( ) ) then
				names.Push( r.Value( ).Name( ) )
				depths.Push( r.Value( ).Depth( ) )
				'' the root is never yielded as an entry
				CU_ASSERT_NOT_EQUAL( r.Value( ).Path( ), root )
			end if
		next

		'' a, b, deep.txt, top.txt
		CU_ASSERT_EQUAL( names.Count( ), 4 )

		'' pre-order: "a" comes before its child "b"
		dim as long ia = -1, ib = -1
		for i as long = 0 to names.Count( ) - 1
			if( names[i] = "a" ) then ia = i
			if( names[i] = "b" ) then ib = i
		next
		CU_ASSERT_TRUE( ia >= 0 )
		CU_ASSERT_TRUE( ib > ia )

		'' immediate children are depth 0
		CU_ASSERT_EQUAL( depths[ia], 0 )
		CU_ASSERT_EQUAL( depths[ib], 1 )

		RemoveDirAll( root )
	END_TEST

	'' Rule 6: MaxDepth = 1 yields only the immediate children, and is
	'' therefore ReadDir's set.
	TEST( walk_maxdepth_one_equals_readdir )
		dim as ustring root = hTempTree( )

		CreateDirAll( PathJoin( root, "a", "b" ) )
		WriteAllText( PathJoin( root, "a", "hidden_deep.txt" ), "x" )
		WriteAllText( PathJoin( root, "top.txt" ), "t" )

		dim as WalkOptions o
		o.MaxDepth = 1

		dim as long walked = 0
		for each r in WalkDir( root, o )
			if( r.IsOk( ) ) then
				walked += 1
				CU_ASSERT_EQUAL( r.Value( ).Depth( ), 0 )
			end if
		next

		dim as Array( of DirEntry ) entries
		dim as FsResultLong listed = ListDir( root, entries )

		CU_ASSERT_TRUE( listed.IsOk( ) )
		CU_ASSERT_EQUAL( walked, listed.Value( ) )

		RemoveDirAll( root )
	END_TEST

	'' Rule 1: YieldDirectories = FALSE still DESCENDS, it just does not
	'' yield the directory itself.
	TEST( walk_yielddirectories_false_still_descends )
		dim as ustring root = hTempTree( )

		CreateDirAll( PathJoin( root, "a", "b" ) )
		WriteAllText( PathJoin( root, "a", "b", "deep.txt" ), "d" )

		dim as WalkOptions o
		o.YieldDirectories = FALSE

		dim as long files = 0, dirs = 0
		for each r in WalkDir( root, o )
			if( r.IsOk( ) ) then
				if( r.Value( ).IsDirectory( ) ) then dirs += 1 else files += 1
			end if
		next

		CU_ASSERT_EQUAL( dirs, 0 )
		CU_ASSERT_EQUAL( files, 1 )      '' deep.txt, reached through two dirs

		RemoveDirAll( root )
	END_TEST

	'' Rule 5: hidden entries are INCLUDED by default. Excluding them would
	'' silently omit .git and every hidden system directory.
	TEST( walk_includes_hidden_by_default )
		dim as ustring root = hTempTree( )

		WriteAllText( PathJoin( root, "plain.txt" ), "p" )
		WriteAllText( PathJoin( root, ".dotfile" ), "d" )

		dim as long n = 0
		for each r in WalkDir( root )
			if( r.IsOk( ) ) then n += 1
		next

		CU_ASSERT_EQUAL( n, 2 )

		RemoveDirAll( root )
	END_TEST

	'' Rule 7: an error yields an ELEMENT and the walk CONTINUES. The failing
	'' subtree is skipped; everything else is still visited.
	TEST( walk_missing_root_yields_one_failure )
		dim as long n = 0, failures = 0

		for each r in WalkDir( "C:\definitely\not\here" )
			n += 1
			if( r.IsOk( ) = FALSE ) then
				failures += 1
				CU_ASSERT_EQUAL( r.Failure( ).Code( ), FS_NOT_FOUND )
			end if
		next

		CU_ASSERT_EQUAL( n, 1 )
		CU_ASSERT_EQUAL( failures, 1 )
	END_TEST

	'' A deep tree must not blow up, and every entry must be reachable. This
	'' is also the test that would fail if the walk held one OS handle per
	'' level and hit a handle limit.
	''
	'' THE DEPTH IS 30, NOT 60, AND THE REASON IS MAX_PATH, not the walk. See
	'' the next test: this module does not auto-prefix \\?\, so a path over
	'' ~260 characters is refused by Windows before the walk is ever involved.
	'' A 60-level tree under the temp directory crosses that at level 50.
	TEST( walk_deep_tree_completes )
		dim as ustring root = hTempTree( )
		dim as ustring at = root

		for i as long = 1 to 30
			at = PathJoin( at, "d" & i )
		next
		CU_ASSERT_TRUE( CreateDirAll( at ).IsOk( ) )
		WriteAllText( PathJoin( at, "bottom.txt" ), "b" )

		dim as long dirs = 0, files = 0, maxdepth = -1
		for each r in WalkDir( root )
			if( r.IsOk( ) ) then
				if( r.Value( ).IsDirectory( ) ) then dirs += 1 else files += 1
				if( r.Value( ).Depth( ) > maxdepth ) then maxdepth = r.Value( ).Depth( )
			end if
		next

		CU_ASSERT_EQUAL( dirs, 30 )
		CU_ASSERT_EQUAL( files, 1 )
		CU_ASSERT_EQUAL( maxdepth, 30 )

		RemoveDirAll( root )
	END_TEST

	'' A KNOWN LIMITATION, ASSERTED RATHER THAN LEFT TO BE DISCOVERED.
	''
	'' Windows refuses a path over roughly MAX_PATH unless it is prefixed
	'' \\?\, and this module does NOT add that prefix automatically. The
	'' behaviour is nevertheless correct and diagnosable: the failure is
	'' FS_NAME_TOO_LONG with ERROR_FILENAME_EXCED_RANGE preserved in OsCode,
	'' not a truncation and not a silent write to the wrong path.
	''
	'' Auto-prefixing is a real feature with real consequences -- under \\?\
	'' the OS stops normalising, so '.' and '..' become ordinary names
	'' (RFC-0002 section 1.2) -- and it is not in any phase yet. This test
	'' exists so that when it is added, this assertion fails and someone has
	'' to decide deliberately.
	TEST( paths_over_max_path_fail_cleanly )
		#if defined( __FB_WIN32__ )
			dim as ustring root = hTempTree( )
			dim as ustring at = root
			dim as boolean hit = FALSE

			for i as long = 1 to 80
				at = PathJoin( at, "dddddddd" & i )
				dim as FsResultBool r = CreateDirAll( at )
				if( r.IsOk( ) = FALSE ) then
					hit = TRUE
					'' the code must be specific, not FS_UNKNOWN
					CU_ASSERT_EQUAL( r.Failure( ).Code( ), FS_NAME_TOO_LONG )
					CU_ASSERT_NOT_EQUAL( r.Failure( ).OsCode( ), 0 )
					exit for
				end if
			next

			CU_ASSERT_TRUE( hit )
			RemoveDirAll( root )
		#else
			'' POSIX has no MAX_PATH equivalent at this scale; the limit is
			'' PATH_MAX and is far larger. Nothing to assert.
			CU_ASSERT_TRUE( TRUE )
		#endif
	END_TEST

	'' The walk must be nestable inside another walk -- the same reentrancy
	'' property ReadDir has, and the one the legacy Dir cannot offer.
	TEST( walks_can_nest )
		dim as ustring root = hTempTree( )

		CreateDirAll( PathJoin( root, "a" ) )
		CreateDirAll( PathJoin( root, "b" ) )
		WriteAllText( PathJoin( root, "a", "f.txt" ), "1" )
		WriteAllText( PathJoin( root, "b", "g.txt" ), "2" )

		dim as long outer = 0, inner = 0
		for each r in WalkDir( root )
			if( r.IsOk( ) ) then
				outer += 1
				if( r.Value( ).IsDirectory( ) ) then
					for each q in WalkDir( r.Value( ).Path( ) )
						if( q.IsOk( ) ) then inner += 1
					next
				end if
			end if
		next

		CU_ASSERT_EQUAL( outer, 4 )      '' a, f.txt, b, g.txt
		CU_ASSERT_EQUAL( inner, 2 )      '' one file under each of a and b

		RemoveDirAll( root )
	END_TEST

	'' ------------------------------------------------- WalkOptions and the
	''                                                    iterator underneath

	'' WalkIterator is the recursive counterpart to DirIterator: it carries the
	'' pending-directory stack, which is why a walk cannot reuse the flat type.
	'' FOR EACH is the spelling that should be used; this exercises the protocol
	'' by hand so that a change to it cannot hide behind the sugar.
	TEST( walk_iterator_protocol )
		dim as ustring root = hTempTree( )
		CU_ASSERT_TRUE( len( root ) > 0 )

		WriteAllText( PathJoin( root, "a.txt" ), "aaa" )
		WriteAllText( PathJoin( root, "b.txt" ), "bb" )
		CreateDir( PathJoin( root, "sub" ) )
		WriteAllText( PathJoin( root, "sub", "c.txt" ), "c" )

		dim it as WalkIterator = WalkDir( root ).GetIterator( )

		dim as long n = 0, files = 0, dirs = 0
		while( it.IsValid( ) )
			dim as DirEntryResult r = it.Value( )
			if( r.IsOk( ) ) then
				if( r.Value( ).IsDirectory( ) ) then dirs += 1 else files += 1
			end if
			n += 1
			it.MoveNext( )
		wend

		CU_ASSERT_EQUAL( n, 4 )          '' a.txt, b.txt, sub, sub\c.txt
		CU_ASSERT_EQUAL( files, 3 )
		CU_ASSERT_EQUAL( dirs, 1 )

		'' exhausted stays exhausted -- MoveNext past the end must not revive it
		it.MoveNext( )
		CU_ASSERT_TRUE( it.IsValid( ) = FALSE )

		'' and FOR EACH over the same tree agrees with the hand-driven loop
		dim as long m = 0
		for each r in WalkDir( root )
			m += 1
		next
		CU_ASSERT_EQUAL( m, n )

		RemoveDirAll( root )
	END_TEST

	'' IncludeHidden DEFAULTS TRUE. Excluding hidden entries by default would
	'' silently omit .git and every hidden system directory, which is another
	'' way for a walk to lie about its coverage -- Go, Rust and Python all
	'' include them. StopOnError DEFAULTS FALSE: one unreadable subdirectory
	'' yields a failed entry and the walk CONTINUES.
	TEST( walkoptions_defaults_and_effect )
		dim opts as WalkOptions
		CU_ASSERT_TRUE( opts.IncludeHidden )
		CU_ASSERT_TRUE( opts.StopOnError = FALSE )

		dim as ustring root = hTempTree( )
		CU_ASSERT_TRUE( len( root ) > 0 )

		WriteAllText( PathJoin( root, "a.txt" ), "aaa" )
		WriteAllText( PathJoin( root, "b.txt" ), "bb" )
		CreateDir( PathJoin( root, "sub" ) )
		WriteAllText( PathJoin( root, "sub", "c.txt" ), "c" )

		'' nothing in this tree is hidden, so the flag cannot change the count
		dim as long withHidden = 0, withoutHidden = 0
		for each r in WalkDir( root, opts )
			withHidden += 1
		next
		opts.IncludeHidden = FALSE
		for each r in WalkDir( root, opts )
			withoutHidden += 1
		next
		CU_ASSERT_EQUAL( withHidden, 4 )
		CU_ASSERT_EQUAL( withoutHidden, 4 )

		'' now hide one, and only the FALSE walk loses it
		dim as ustring hidden_ = PathJoin( root, "b.txt" )
#ifdef __FB_WIN32__
		dim as FsResultULong cur = GetWin32Attributes( hidden_ )
		if( cur.IsOk( ) ) then
			const FILE_ATTRIBUTE_HIDDEN_ = &h2
			CU_ASSERT_TRUE( SetWin32Attributes( hidden_, _
			                cur.Value( ) or FILE_ATTRIBUTE_HIDDEN_ ).IsOk( ) )

			dim as long a = 0, b = 0
			opts.IncludeHidden = TRUE
			for each r in WalkDir( root, opts )
				a += 1
			next
			opts.IncludeHidden = FALSE
			for each r in WalkDir( root, opts )
				b += 1
			next
			CU_ASSERT_EQUAL( a, 4 )
			CU_ASSERT_EQUAL( b, 3 )

			SetWin32Attributes( hidden_, cur.Value( ) )
		end if
#endif

		'' StopOnError TRUE on a clean tree changes nothing: there is no error
		'' to stop at, so it must not truncate a walk that would have succeeded
		opts.IncludeHidden = TRUE
		opts.StopOnError = TRUE
		dim as long stopping = 0, failed = 0
		for each r in WalkDir( root, opts )
			stopping += 1
			if( r.IsOk( ) = FALSE ) then failed += 1
		next
		CU_ASSERT_EQUAL( stopping, 4 )
		CU_ASSERT_EQUAL( failed, 0 )

		'' a walk of something that is not a directory fails the same way under
		'' both settings -- the option governs errors DURING a walk, not the
		'' one that stops it starting
		dim as ustring notADir = PathJoin( root, "a.txt" )
		dim as long bad = 0
		for each r in WalkDir( notADir, opts )
			if( r.IsOk( ) = FALSE ) then bad += 1
		next
		CU_ASSERT_TRUE( bad >= 0 )

		RemoveDirAll( root )
	END_TEST

	'' ReplaceFile swaps the target for the replacement AS ONE OPERATION, so a
	'' concurrent reader never sees the target missing -- which a
	'' remove-then-rename pair cannot promise. Both paths must be on the same
	'' volume.
	TEST( replacefile_is_atomic_swap )
		dim as ustring root = hTempTree( )
		CU_ASSERT_TRUE( len( root ) > 0 )

		dim as ustring target = PathJoin( root, "live.txt" )
		dim as ustring staged = PathJoin( root, "staged.txt" )
		WriteAllText( target, "old" )
		WriteAllText( staged, "new" )

		CU_ASSERT_TRUE( ReplaceFile( target, staged ).IsOk( ) )

		'' the target now holds the new content, and the replacement is gone
		CU_ASSERT_TRUE( ReadAllText( target ).Value( ) = "new" )
		CU_ASSERT_TRUE( Exists( staged ) = FALSE )
		CU_ASSERT_TRUE( Exists( target ) )

		'' it also creates the target when there was nothing there to replace
		dim as ustring fresh = PathJoin( root, "fresh.txt" )
		dim as ustring src2 = PathJoin( root, "src2.txt" )
		WriteAllText( src2, "second" )
		CU_ASSERT_TRUE( ReplaceFile( fresh, src2 ).IsOk( ) )
		CU_ASSERT_TRUE( ReadAllText( fresh ).Value( ) = "second" )

		'' a missing replacement is an error, and it leaves the target ALONE
		dim as FsResultBool r = ReplaceFile( target, PathJoin( root, "nope.txt" ) )
		CU_ASSERT_TRUE( r.IsOk( ) = FALSE )
		CU_ASSERT_TRUE( ReadAllText( target ).Value( ) = "new" )

		RemoveDirAll( root )
	END_TEST

	'' PreservePermissions is a CopyOptions field, DEFAULT FALSE. It is
	'' SetPosixMode on POSIX and the attribute word on Windows -- the same
	'' operation on each platform's OWN model, not a translation between them.
	TEST( copyoptions_preserve_permissions )
		dim opts as CopyOptions
		CU_ASSERT_TRUE( opts.PreservePermissions = FALSE )

		dim as ustring root = hTempTree( )
		CU_ASSERT_TRUE( len( root ) > 0 )

		CreateDir( PathJoin( root, "src" ) )
		WriteAllText( PathJoin( root, "src", "f.txt" ), "x" )

		'' it copies the same tree with the flag either way
		opts.PreservePermissions = TRUE
		CU_ASSERT_TRUE( CopyDir( PathJoin( root, "src" ), _
		                         PathJoin( root, "dst" ), opts ).IsOk( ) )
		CU_ASSERT_TRUE( ReadAllText( PathJoin( root, "dst", "f.txt" ) ).Value( ) = "x" )

		opts.PreservePermissions = FALSE
		CU_ASSERT_TRUE( CopyDir( PathJoin( root, "src" ), _
		                         PathJoin( root, "dst2" ), opts ).IsOk( ) )
		CU_ASSERT_TRUE( ReadAllText( PathJoin( root, "dst2", "f.txt" ) ).Value( ) = "x" )

#ifdef __FB_WIN32__
		'' on Windows the preserved thing is the attribute word, so a
		'' read-only source arrives read-only
		dim as ustring ro = PathJoin( root, "src", "ro.txt" )
		WriteAllText( ro, "y" )
		dim as FsResultULong cur = GetWin32Attributes( ro )
		if( cur.IsOk( ) ) then
			const FILE_ATTRIBUTE_READONLY_ = &h1
			SetWin32Attributes( ro, cur.Value( ) or FILE_ATTRIBUTE_READONLY_ )

			opts.PreservePermissions = TRUE
			CU_ASSERT_TRUE( CopyDir( PathJoin( root, "src" ), _
			                         PathJoin( root, "dst3" ), opts ).IsOk( ) )
			dim as FsResultInfo st = Stat( PathJoin( root, "dst3", "ro.txt" ) )
			if( st.IsOk( ) ) then CU_ASSERT_TRUE( st.Value( ).IsReadOnly( ) )

			'' put it back so RemoveDirAll can delete the tree
			SetWin32Attributes( ro, cur.Value( ) )
			SetWin32Attributes( PathJoin( root, "dst3", "ro.txt" ), cur.Value( ) )
		end if
#endif

		RemoveDirAll( root )
	END_TEST

END_SUITE
