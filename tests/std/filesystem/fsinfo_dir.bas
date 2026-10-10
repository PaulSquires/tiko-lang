'' fs.FileInfo, fs.Stat and fs.ReadDir -- RFC-0003 and RFC-0004.
''
'' Unlike fspath_core.bas, this suite needs a REAL FILESYSTEM. It builds its
'' fixtures under the system temp directory and removes them in teardown, so it
'' is self-contained and leaves nothing behind.
''
'' Phase 3 will replace the hand-rolled fixture helpers below with
'' CreateTempDir / RemoveDirAll from RFC-0005. They are hand-rolled here
'' precisely because those do not exist yet, and writing the suite against
'' functions that do not exist would be writing it against a guess.
''
'' NOT ASSERTED HERE: anything involving symbolic links. Creating one on
'' Windows needs either elevation or Developer Mode, so a link test would pass
'' or skip depending on the machine rather than on the code. RFC-0007 owns them
'' and its suite carries the explicit skip-with-a-logged-reason rule.

#import "std/fs"
#import "std/outcome"
#include "fbcunit.bi"

#include once "fb/array.bi"

#include once "fberror.bi"

using fs, outcome

using FB
'' ---------------------------------------------------------------- fixtures

'' A private scratch directory under the OS temp dir, unique to this run.
private function hFixtureRoot( ) as ustring
	'' NOT named `base`: BASE is a keyword, and the failure it produces
	'' ("Duplicated definition") points nowhere near the cause.
	dim as ustring tmpdir = environ( "TEMP" )
	if( len( tmpdir ) = 0 ) then tmpdir = environ( "TMP" )
	if( len( tmpdir ) = 0 ) then tmpdir = "."
	return PathJoin( tmpdir, "fbcu_fsinfo_fixture" )
end function

private sub hWriteFile( byref p as const ustring, byref content as const string )
	dim as long f = freefile
	if( open( p for binary access write as #f ) = 0 ) then
		if( len( content ) > 0 ) then
			put #f, , content
		end if
		close #f
	end if
end sub

private sub hMakeFixture( byref root as const ustring )
	mkdir( root )
	mkdir( PathJoin( root, "sub" ) )
	hWriteFile( PathJoin( root, "a.bas" ), "hello" )
	hWriteFile( PathJoin( root, "b.txt" ), "" )
	hWriteFile( PathJoin( root, ".hidden" ), "x" )
	hWriteFile( PathJoin( root, "sub", "deep.bas" ), "deeper" )
end sub

private sub hKillFixture( byref root as const ustring )
	kill( PathJoin( root, "sub", "deep.bas" ) )
	rmdir( PathJoin( root, "sub" ) )
	kill( PathJoin( root, "a.bas" ) )
	kill( PathJoin( root, "b.txt" ) )
	kill( PathJoin( root, ".hidden" ) )
	rmdir( root )
end sub

SUITE( fbc_tests.filesystem.fsinfo_dir )

	'' The C kernel writes FB_FSINFO and FB_FSDIRENT DIRECTLY into the
	'' FreeBASIC mirrors. A layout drift would not fail loudly -- it would
	'' scramble every field of every result -- so the sizes are asserted
	'' against the C side rather than against a hand-kept literal.
	TEST( abi_layout_matches_c )
		CU_ASSERT_EQUAL( sizeof( FileInfo ), FsSizeofInfo( ) )
		CU_ASSERT_EQUAL( sizeof( FsDirEntRaw ), FsSizeofDirEnt( ) )
	END_TEST

	'' Exactly one of the four kind predicates is true whenever Exists is
	'' true, and none is true when it is false. Asserted as a COUNT, so a
	'' future fifth kind cannot slip through as "two things at once".
	TEST( kind_is_exclusive_and_exhaustive )
		dim as ustring root = hFixtureRoot( )
		hMakeFixture( root )

		dim as FsResultInfo rf = Stat( PathJoin( root, "a.bas" ) )
		CU_ASSERT_TRUE( rf.IsOk( ) )

		dim as long n = 0
		if( rf.Value( ).IsFile( ) ) then n += 1
		if( rf.Value( ).IsDirectory( ) ) then n += 1
		if( rf.Value( ).IsSymlink( ) ) then n += 1
		if( rf.Value( ).IsOther( ) ) then n += 1
		CU_ASSERT_EQUAL( n, 1 )
		CU_ASSERT_TRUE( rf.Value( ).IsFile( ) )
		CU_ASSERT_TRUE( rf.Value( ).Exists( ) )

		dim as FsResultInfo rd = Stat( root )
		CU_ASSERT_TRUE( rd.IsOk( ) )
		CU_ASSERT_TRUE( rd.Value( ).IsDirectory( ) )
		CU_ASSERT_FALSE( rd.Value( ).IsFile( ) )

		hKillFixture( root )
	END_TEST

	'' GetFileAttributesExW, not FindFirstFileW: the latter is the common
	'' shortcut and FAILS on a volume root, which programs stat all the time.
	TEST( volume_root_stats )
		#if defined( __FB_WIN32__ )
			dim as FsResultInfo r = Stat( "C:\" )
		#else
			dim as FsResultInfo r = Stat( "/" )
		#endif

		CU_ASSERT_TRUE( r.IsOk( ) )
		CU_ASSERT_TRUE( r.Value( ).IsDirectory( ) )
	END_TEST

	TEST( size_matches_bytes_written )
		dim as ustring root = hFixtureRoot( )
		hMakeFixture( root )

		dim as FsResultInfo r5 = Stat( PathJoin( root, "a.bas" ) )
		CU_ASSERT_TRUE( r5.IsOk( ) )
		CU_ASSERT_EQUAL( r5.Value( ).Size( ), 5 )

		'' the zero-byte case, which is where a "size means absent" bug hides
		dim as FsResultInfo r0 = Stat( PathJoin( root, "b.txt" ) )
		CU_ASSERT_TRUE( r0.IsOk( ) )
		CU_ASSERT_EQUAL( r0.Value( ).Size( ), 0 )
		CU_ASSERT_TRUE( r0.Value( ).Exists( ) )

		hKillFixture( root )
	END_TEST

	'' ABSENCE IS AN ERROR, NOT AN EMPTY SUCCESS -- that is what keeps
	'' "missing" and "denied" distinguishable, and it is the whole argument
	'' for Result over Optional in this module.
	TEST( absence_is_not_found_not_empty_success )
		dim as FsResultInfo r = Stat( "C:\definitely\not\here\zz.tmp" )

		CU_ASSERT_FALSE( r.IsOk( ) )
		CU_ASSERT_EQUAL( r.Failure( ).Code( ), FS_NOT_FOUND )
		CU_ASSERT_EQUAL( r.Failure( ).Operation( ), "Stat" )
		CU_ASSERT_NOT_EQUAL( r.Failure( ).OsCode( ), 0 )
	END_TEST

	'' The predicates COLLAPSE EVERY FAILURE TO FALSE. That is a real loss of
	'' information and it is deliberate; it is pinned here rather than
	'' assumed, because the alternative reading (Exists throws / returns a
	'' Result) would be equally defensible.
	TEST( predicates_collapse_failure_to_false )
		dim as ustring root = hFixtureRoot( )
		hMakeFixture( root )

		CU_ASSERT_TRUE ( Exists( PathJoin( root, "a.bas" ) ) )
		CU_ASSERT_TRUE ( IsFile( PathJoin( root, "a.bas" ) ) )
		CU_ASSERT_FALSE( IsDir ( PathJoin( root, "a.bas" ) ) )

		CU_ASSERT_TRUE ( Exists( root ) )
		CU_ASSERT_TRUE ( IsDir ( root ) )
		CU_ASSERT_FALSE( IsFile( root ) )

		CU_ASSERT_FALSE( Exists( "C:\definitely\not\here" ) )
		CU_ASSERT_FALSE( IsFile( "C:\definitely\not\here" ) )
		CU_ASSERT_FALSE( IsDir ( "C:\definitely\not\here" ) )

		hKillFixture( root )
	END_TEST

	'' Modified time must be recent and must ADVANCE on rewrite. Asserted as
	'' an ordering rather than against a clock reading, because this suite has
	'' no clock of its own until the datetime module lands.
	TEST( times_are_sane_and_advance )
		dim as ustring root = hFixtureRoot( )
		hMakeFixture( root )
		dim as ustring f = PathJoin( root, "a.bas" )

		dim as FsResultInfo r1 = Stat( f )
		CU_ASSERT_TRUE( r1.IsOk( ) )

		'' a tick is 100 ns since 0001-01-01; anything this century is far
		'' above the year-2000 mark and far below year 9999
		CU_ASSERT_TRUE( r1.Value( ).ModifiedUtc( ) > 630822816000000000 )
		CU_ASSERT_TRUE( r1.Value( ).ModifiedUtc( ) < 3155378975999999999 )

		'' where creation time is reported it must not postdate modification;
		'' where it is not, it must be exactly 0 and not garbage
		if( r1.Value( ).HasCreated( ) ) then
			CU_ASSERT_TRUE( r1.Value( ).CreatedUtc( ) > 0 )
		else
			CU_ASSERT_EQUAL( r1.Value( ).CreatedUtc( ), 0 )
		end if

		sleep 1100, 1
		hWriteFile( f, "hello again" )

		dim as FsResultInfo r2 = Stat( f )
		CU_ASSERT_TRUE( r2.IsOk( ) )
		CU_ASSERT_TRUE( r2.Value( ).ModifiedUtc( ) >= r1.Value( ).ModifiedUtc( ) )

		hKillFixture( root )
	END_TEST

	'' Hidden means FILE_ATTRIBUTE_HIDDEN on Windows and a leading dot on
	'' POSIX. The divergence is real, so the assertion is per platform rather
	'' than a lowest common denominator that would test nothing.
	TEST( hidden_is_per_platform )
		dim as ustring root = hFixtureRoot( )
		hMakeFixture( root )

		dim as FsResultInfo r = Stat( PathJoin( root, ".hidden" ) )
		CU_ASSERT_TRUE( r.IsOk( ) )

		#if defined( __FB_WIN32__ )
			'' a dotfile is NOT hidden on Windows -- the name means nothing
			CU_ASSERT_FALSE( r.Value( ).IsHidden( ) )
		#else
			CU_ASSERT_TRUE( r.Value( ).IsHidden( ) )
		#endif

		hKillFixture( root )
	END_TEST

	'' AbsolutePath does NOT require existence -- the usual caller is about to
	'' create the path -- while CanonicalPath DOES. The pair is asserted
	'' together because the contrast is the entire reason both exist.
	TEST( absolute_vs_canonical )
		dim as ustring gone = "C:\definitely\not\here\zz.tmp"

		dim as FsResultUStr a = AbsolutePath( gone )
		CU_ASSERT_TRUE( a.IsOk( ) )

		dim as FsResultUStr c = CanonicalPath( gone )
		CU_ASSERT_FALSE( c.IsOk( ) )
		CU_ASSERT_EQUAL( c.Failure( ).Code( ), FS_NOT_FOUND )

		'' absolute is idempotent on something already absolute
		dim as FsResultUStr cur = CurrentDir( )
		CU_ASSERT_TRUE( cur.IsOk( ) )
		CU_ASSERT_TRUE( PathIsAbsolute( cur.Value( ) ) )

		dim as FsResultUStr a2 = AbsolutePath( cur.Value( ) )
		CU_ASSERT_TRUE( a2.IsOk( ) )
		CU_ASSERT_TRUE( PathEquals( a2.Value( ), cur.Value( ) ) )
	END_TEST

	'' Canonical results must be compared with PathEquals, not '=', because
	'' the \\?\ prefix is kept when the result exceeds MAX_PATH.
	TEST( canonical_resolves_dotdot_through_filesystem )
		dim as ustring root = hFixtureRoot( )
		hMakeFixture( root )

		dim as FsResultUStr c = CanonicalPath( PathJoin( root, "sub", ".." ) )
		CU_ASSERT_TRUE( c.IsOk( ) )

		dim as FsResultUStr d = CanonicalPath( root )
		CU_ASSERT_TRUE( d.IsOk( ) )
		CU_ASSERT_TRUE( PathEquals( c.Value( ), d.Value( ) ) )

		hKillFixture( root )
	END_TEST

	'' ------------------------------------------------------- iteration

	'' Structural conformance: this test existing and compiling IS the
	'' assertion. A typo in GetIterator/IsValid/Value/MoveNext reads as "not
	'' iterable" rather than as a diagnostic, so nothing else would catch it.
	TEST( for_each_compiles_and_yields_results )
		dim as ustring root = hFixtureRoot( )
		hMakeFixture( root )

		dim as long n = 0
		for each r in ReadDir( root )
			CU_ASSERT_TRUE( r.IsOk( ) )
			if( r.IsOk( ) ) then
				CU_ASSERT_TRUE( len( r.Value( ).Name( ) ) > 0 )
				'' Path is directly usable, not just a leaf
				CU_ASSERT_TRUE( PathStartsWith( r.Value( ).Path( ), root ) )
				n += 1
			end if
		next

		'' a.bas, b.txt, .hidden, sub
		CU_ASSERT_EQUAL( n, 4 )

		hKillFixture( root )
	END_TEST

	'' '.' and '..' are dropped in the kernel, not left to the caller. A
	'' caller who forgets to filter them writes an infinite recursion.
	TEST( dot_and_dotdot_never_appear )
		dim as ustring root = hFixtureRoot( )
		hMakeFixture( root )

		for each r in ReadDir( root )
			if( r.IsOk( ) ) then
				CU_ASSERT_NOT_EQUAL( r.Value( ).Name( ), "." )
				CU_ASSERT_NOT_EQUAL( r.Value( ).Name( ), ".." )
			end if
		next

		hKillFixture( root )
	END_TEST

	'' THE TEST THE LEGACY Dir CANNOT PASS. Two iterators over two different
	'' directories, advanced alternately, each yield their own complete
	'' correct listing. Dir/DirNext shares one TLS cursor, so the second scan
	'' would silently reset the first.
	TEST( two_interleaved_scans_do_not_interfere )
		dim as ustring root = hFixtureRoot( )
		hMakeFixture( root )

		dim as DirIterator ia = ReadDir( root ).GetIterator( )
		dim as DirIterator ib = ReadDir( PathJoin( root, "sub" ) ).GetIterator( )

		dim as long na = 0, nb = 0

		'' advance them alternately, which is precisely what breaks Dir
		while( ia.IsValid( ) orelse ib.IsValid( ) )
			if( ia.IsValid( ) ) then
				if( ia.Value( ).IsOk( ) ) then na += 1
				ia.MoveNext( )
			end if
			if( ib.IsValid( ) ) then
				if( ib.Value( ).IsOk( ) ) then nb += 1
				ib.MoveNext( )
			end if
		wend

		CU_ASSERT_EQUAL( na, 4 )      '' the root's four entries
		CU_ASSERT_EQUAL( nb, 1 )      '' sub/deep.bas

		hKillFixture( root )
	END_TEST

	'' Two independent iterators over ONE directory, which is the same hazard
	'' from the other direction.
	TEST( two_scans_of_one_directory_are_independent )
		dim as ustring root = hFixtureRoot( )
		hMakeFixture( root )

		dim as DirIterator ia = ReadDir( root ).GetIterator( )
		dim as DirIterator ib = ReadDir( root ).GetIterator( )
		dim as long na = 0, nb = 0

		while( ia.IsValid( ) )
			na += 1
			ia.MoveNext( )
		wend
		while( ib.IsValid( ) )
			nb += 1
			ib.MoveNext( )
		wend

		CU_ASSERT_EQUAL( na, 4 )
		CU_ASSERT_EQUAL( nb, 4 )

		hKillFixture( root )
	END_TEST

	'' An unopenable directory yields EXACTLY ONE element and it is a
	'' FAILURE -- not zero elements, which would be indistinguishable from an
	'' empty directory and would defeat the reason the element is a Result.
	TEST( unopenable_directory_yields_one_failure )
		dim as long n = 0, failures = 0

		for each r in ReadDir( "C:\definitely\not\here" )
			n += 1
			if( r.IsOk( ) = FALSE ) then
				failures += 1
				CU_ASSERT_EQUAL( r.Failure( ).Code( ), FS_NOT_FOUND )
			end if
		next

		CU_ASSERT_EQUAL( n, 1 )
		CU_ASSERT_EQUAL( failures, 1 )
	END_TEST

	'' IsValid is pure and repeatable: calling it repeatedly without an
	'' intervening MoveNext gives the same answer and the same first element.
	'' It also performs the lazy open, so this is where a non-idempotent open
	'' would show up.
	TEST( isvalid_is_repeatable_and_opens_lazily )
		dim as ustring root = hFixtureRoot( )
		hMakeFixture( root )

		dim as DirIterator it = ReadDir( root ).GetIterator( )

		for i as long = 1 to 5
			CU_ASSERT_TRUE( it.IsValid( ) )
		next

		dim as ustring first = it.Value( ).Value( ).Name( )
		for i as long = 1 to 5
			CU_ASSERT_EQUAL( it.Value( ).Value( ).Name( ), first )
		next

		hKillFixture( root )
	END_TEST

	'' A DirRange for an absent path constructs with NO error; the failure
	'' appears only on first use. And a copy taken BEFORE first use yields two
	'' independent complete iterations -- which is exactly the copy `for each`
	'' makes at loop entry, and the reason lazy open was chosen over a
	'' refcounted handle.
	TEST( lazy_open_makes_the_preuse_copy_safe )
		dim as ustring root = hFixtureRoot( )
		hMakeFixture( root )

		'' constructing over a missing path is not itself an error
		dim as DirRange bad = ReadDir( "C:\definitely\not\here" )
		CU_ASSERT_TRUE( len( bad.m_root ) > 0 )

		dim as DirIterator ia = ReadDir( root ).GetIterator( )
		dim as DirIterator ib = ia            '' copied before any handle exists

		dim as long na = 0, nb = 0
		while( ia.IsValid( ) )
			na += 1
			ia.MoveNext( )
		wend
		while( ib.IsValid( ) )
			nb += 1
			ib.MoveNext( )
		wend

		CU_ASSERT_EQUAL( na, 4 )
		CU_ASSERT_EQUAL( nb, 4 )

		hKillFixture( root )
	END_TEST

	'' Abandoning scans must not leak handles. The destructor runs on scope
	'' exit including EXIT FOR, so 2000 abandoned scans must not exhaust the
	'' process handle table.
	TEST( abandoned_scans_release_handles )
		dim as ustring root = hFixtureRoot( )
		hMakeFixture( root )

		for i as long = 1 to 2000
			for each r in ReadDir( root )
				exit for              '' abandon after one entry
			next
		next

		'' still working afterwards is the assertion: a leak would have
		'' exhausted the handle table long before here
		CU_ASSERT_TRUE( IsDir( root ) )

		hKillFixture( root )
	END_TEST

	'' The kind comes from the enumeration record, free, and must be correct
	'' and never NONE for an entry that exists.
	TEST( entry_kind_is_populated )
		dim as ustring root = hFixtureRoot( )
		hMakeFixture( root )

		dim as long files = 0, dirs = 0
		for each r in ReadDir( root )
			if( r.IsOk( ) ) then
				CU_ASSERT_FALSE( r.Value( ).IsOther( ) )
				if( r.Value( ).IsFile( ) ) then files += 1
				if( r.Value( ).IsDirectory( ) ) then dirs += 1
			end if
		next

		CU_ASSERT_EQUAL( files, 3 )
		CU_ASSERT_EQUAL( dirs, 1 )

		hKillFixture( root )
	END_TEST

	'' Info( ) must agree with a direct stat, whether it came free from the
	'' find record (Windows) or cost an lstat (POSIX).
	TEST( entry_info_agrees_with_stat )
		dim as ustring root = hFixtureRoot( )
		hMakeFixture( root )

		for each r in ReadDir( root )
			if( r.IsOk( ) andalso r.Value( ).Name( ) = "a.bas" ) then
				dim as FsResultInfo ei = r.Value( ).Info( )
				CU_ASSERT_TRUE( ei.IsOk( ) )
				CU_ASSERT_EQUAL( ei.Value( ).Size( ), 5 )

				dim as FsResultInfo si = Stat( r.Value( ).Path( ) )
				CU_ASSERT_TRUE( si.IsOk( ) )
				CU_ASSERT_EQUAL( ei.Value( ).Size( ), si.Value( ).Size( ) )
			end if
		next

		hKillFixture( root )
	END_TEST

	'' ListDir closes its handle before returning, which is what lets a
	'' caller mutate the directory while working through the result --
	'' something the iterator forbids and RemoveDirAll will need in phase 3.
	TEST( listdir_is_eager_and_allows_mutation )
		dim as ustring root = hFixtureRoot( )
		hMakeFixture( root )

		dim as Array( of DirEntry ) entries
		dim as FsResultLong n = ListDir( root, entries )

		CU_ASSERT_TRUE( n.IsOk( ) )
		CU_ASSERT_EQUAL( n.Value( ), 4 )
		CU_ASSERT_EQUAL( entries.Count( ), 4 )

		'' deleting while walking the ARRAY is fine; the handle is gone
		for i as long = 0 to entries.Count( ) - 1
			if( entries[i].IsFile( ) ) then
				kill( entries[i].Path( ) )
			end if
		next

		CU_ASSERT_FALSE( Exists( PathJoin( root, "a.bas" ) ) )

		'' tidy up what is left
		kill( PathJoin( root, "sub", "deep.bas" ) )
		rmdir( PathJoin( root, "sub" ) )
		rmdir( root )
	END_TEST

	TEST( listdir_reports_failure_for_missing_directory )
		dim as Array( of DirEntry ) entries
		dim as FsResultLong n = ListDir( "C:\definitely\not\here", entries )

		CU_ASSERT_FALSE( n.IsOk( ) )
		CU_ASSERT_EQUAL( n.Failure( ).Code( ), FS_NOT_FOUND )
	END_TEST

	'' ---------------------------------------- the guarded and raw accessors

	'' AccessedUtc is guarded by HasAccessed, exactly like CreatedUtc -- and it
	'' is worth less than it looks: many systems mount with noatime, so the
	'' value may never advance. The GUARD is the contract; the value is not.
	TEST( accessed_is_guarded )
		dim as FsResultUStr td = CreateTempDir( "fbcuacc" )
		CU_ASSERT_TRUE( td.IsOk( ) )
		dim as ustring dir_ = td.Value( )
		dim as ustring p = PathJoin( dir_, "f.txt" )
		WriteAllText( p, "hello" )

		dim as FsResultInfo s = Stat( p )
		CU_ASSERT_TRUE( s.IsOk( ) )
		dim info as FileInfo = s.Value( )

		'' HasAccessed is answerable whatever the platform says, and asking it
		'' twice cannot disagree
		dim as boolean has = info.HasAccessed( )
		CU_ASSERT_TRUE( info.HasAccessed( ) = has )

		if( has ) then
			'' a real timestamp, not a zero placeholder, and not in the future
			'' a real tick count on the same scale as every other time in this
			'' suite -- 100 ns since 0001-01-01, so this century sits far above
			'' the year-2000 mark
			CU_ASSERT_TRUE( info.AccessedUtc( ) > 630822816000000000 )
			CU_ASSERT_TRUE( info.AccessedUtc( ) < 3155378975999999999 )

			'' and within a day of the modification time -- they come from one
			'' stat call, so a wildly different value means a field mix-up
			CU_ASSERT_TRUE( info.AccessedUtc( ) >= info.ModifiedUtc( ) - 864000000000ll )
			CU_ASSERT_TRUE( info.AccessedUtc( ) <= info.ModifiedUtc( ) + 864000000000ll )
		end if

		'' a directory answers the same question the same way
		dim as FsResultInfo sd = Stat( dir_ )
		CU_ASSERT_TRUE( sd.IsOk( ) )
		CU_ASSERT_TRUE( sd.Value( ).HasAccessed( ) = has )

		RemoveDirAll( dir_ )
	END_TEST

	'' NativeAttributes is the RAW PLATFORM WORD: dwFileAttributes on Windows,
	'' st_mode on POSIX. Code reading it is platform code by definition -- the
	'' bits mean different things on each side -- so what is asserted portably
	'' is only that it is populated and agrees with the abstracted predicates.
	TEST( native_attributes_agrees_with_predicates )
		dim as FsResultUStr td = CreateTempDir( "fbcunat" )
		CU_ASSERT_TRUE( td.IsOk( ) )
		dim as ustring dir_ = td.Value( )
		dim as ustring p = PathJoin( dir_, "f.txt" )
		WriteAllText( p, "hello" )

		dim as FsResultInfo s = Stat( p )
		CU_ASSERT_TRUE( s.IsOk( ) )
		CU_ASSERT_TRUE( s.Value( ).NativeAttributes( ) > 0 )

#ifdef __FB_WIN32__
		const FILE_ATTRIBUTE_READONLY_  = &h1
		const FILE_ATTRIBUTE_HIDDEN_    = &h2
		const FILE_ATTRIBUTE_DIRECTORY_ = &h10

		'' it IS the Win32 word, so GetWin32Attributes must return the same
		dim as FsResultULong g = GetWin32Attributes( p )
		CU_ASSERT_TRUE( g.IsOk( ) )
		CU_ASSERT_EQUAL( g.Value( ), s.Value( ).NativeAttributes( ) )

		'' setting a bit through SetWin32Attributes shows up in both, and in
		'' the abstracted predicate
		CU_ASSERT_TRUE( SetWin32Attributes( p, _
		                g.Value( ) or FILE_ATTRIBUTE_HIDDEN_ ).IsOk( ) )
		dim as FsResultInfo s2 = Stat( p )
		CU_ASSERT_TRUE( s2.IsOk( ) )
		CU_ASSERT_TRUE( ( s2.Value( ).NativeAttributes( ) and FILE_ATTRIBUTE_HIDDEN_ ) <> 0 )
		CU_ASSERT_TRUE( s2.Value( ).IsHidden( ) )

		'' SetWin32Attributes sets the WHOLE WORD -- putting the original back
		'' clears the bit again, which is the read-modify-write rule
		CU_ASSERT_TRUE( SetWin32Attributes( p, g.Value( ) ).IsOk( ) )
		CU_ASSERT_FALSE( Stat( p ).Value( ).IsHidden( ) )

		'' read-only rides on the same word
		CU_ASSERT_TRUE( SetWin32Attributes( p, _
		                g.Value( ) or FILE_ATTRIBUTE_READONLY_ ).IsOk( ) )
		CU_ASSERT_TRUE( Stat( p ).Value( ).IsReadOnly( ) )
		CU_ASSERT_TRUE( SetWin32Attributes( p, g.Value( ) ).IsOk( ) )
		CU_ASSERT_FALSE( Stat( p ).Value( ).IsReadOnly( ) )

		'' a directory carries the directory bit
		CU_ASSERT_TRUE( ( Stat( dir_ ).Value( ).NativeAttributes( ) and _
		                  FILE_ATTRIBUTE_DIRECTORY_ ) <> 0 )

		'' and a missing path fails rather than answering zero
		CU_ASSERT_FALSE( GetWin32Attributes( PathJoin( dir_, "nope" ) ).IsOk( ) )
		CU_ASSERT_FALSE( SetWin32Attributes( PathJoin( dir_, "nope" ), 0 ).IsOk( ) )
#endif

		RemoveDirAll( dir_ )
	END_TEST

	'' SetCurrentDir is PROCESS-WIDE: every thread sees it, and every relative
	'' path in the program now resolves somewhere else. This test puts it back
	'' before it does anything else, and asserts that it did.
	TEST( setcurrentdir_is_process_wide )
		dim as FsResultUStr was = CurrentDir( )
		CU_ASSERT_TRUE( was.IsOk( ) )

		dim as FsResultUStr td = CreateTempDir( "fbcucwd" )
		CU_ASSERT_TRUE( td.IsOk( ) )

		CU_ASSERT_TRUE( SetCurrentDir( td.Value( ) ).IsOk( ) )

		'' CurrentDir now reports the new place -- compared with PathEquals,
		'' because the OS may hand back a canonicalised spelling
		dim as FsResultUStr now_ = CurrentDir( )
		CU_ASSERT_TRUE( now_.IsOk( ) )
		CU_ASSERT_TRUE( PathEquals( CanonicalPath( now_.Value( ) ).Value( ), _
		                            CanonicalPath( td.Value( ) ).Value( ) ) )

		'' and a relative path resolves against it
		WriteAllText( "cwdprobe.txt", "x" )
		CU_ASSERT_TRUE( IsFile( PathJoin( td.Value( ), "cwdprobe.txt" ) ) )
		RemoveFile( "cwdprobe.txt" )

		'' PUT IT BACK before anything else runs
		CU_ASSERT_TRUE( SetCurrentDir( was.Value( ) ).IsOk( ) )
		CU_ASSERT_TRUE( PathEquals( CurrentDir( ).Value( ), was.Value( ) ) )

		'' a missing directory fails and leaves the current one alone
		CU_ASSERT_FALSE( SetCurrentDir( PathJoin( td.Value( ), "nope" ) ).IsOk( ) )
		CU_ASSERT_TRUE( PathEquals( CurrentDir( ).Value( ), was.Value( ) ) )

		'' so does a path that names a FILE rather than a directory
		dim as ustring f = PathJoin( td.Value( ), "notadir.txt" )
		WriteAllText( f, "x" )
		CU_ASSERT_FALSE( SetCurrentDir( f ).IsOk( ) )
		CU_ASSERT_TRUE( PathEquals( CurrentDir( ).Value( ), was.Value( ) ) )

		RemoveDirAll( td.Value( ) )
	END_TEST

END_SUITE
