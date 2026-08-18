'' Volumes -- C:\dev\docs\filesystem\RFC-0008-volumes.md.
''
'' ALMOST NOTHING HERE CAN ASSERT AN EXACT VALUE, because every answer describes
'' the machine the suite is running on. So this asserts INVARIANTS and
'' RELATIONSHIPS -- orderings, that a number moves the right way, that two
'' routes to the same volume agree. That is the honest limit of testing this
'' module, and it is stated rather than worked around with a fixture that would
'' only pass on one machine.
''
'' The ONE field that can be checked against ground truth is IsCaseSensitive,
'' and it is checked by creating a file and asking the filesystem -- which is
'' what caught the implementation reporting FILE_CASE_SENSITIVE_SEARCH (a
'' property of the FILESYSTEM) where Win32's observable behaviour (a property of
'' the NAMESPACE) was meant.

#include "fbcunit.bi"
#include once "fb/filesystem.bi"

using FB

private function hTempTree( ) as ustring
	dim as FsResultUStr r = CreateTempDir( "fbcuvol" )
	if( r.IsOk( ) = FALSE ) then return ""
	return r.Value( )
end function

SUITE( fbc_tests.filesystem.fsvolume )

	'' The C kernel writes FB_FSVOLUME directly into the FreeBASIC mirror, so
	'' a layout drift would scramble every field rather than fail loudly.
	TEST( abi_layout_matches_c )
		CU_ASSERT_EQUAL( sizeof( VolumeInfoRaw ), FsSizeofVolume( ) )
	END_TEST

	'' AvailableBytes <= FreeBytes <= TotalBytes, always. The middle one is
	'' where a quota or reserved blocks show up.
	TEST( space_invariants_hold )
		dim as ustring root = hTempTree( )
		CU_ASSERT_TRUE( len( root ) > 0 )

		dim as FsResultSpace s = GetDiskSpace( root )
		CU_ASSERT_TRUE( s.IsOk( ) )

		CU_ASSERT_TRUE( s.Value( ).TotalBytes > 0 )
		CU_ASSERT_TRUE( s.Value( ).FreeBytes <= s.Value( ).TotalBytes )
		CU_ASSERT_TRUE( s.Value( ).AvailableBytes <= s.Value( ).FreeBytes )

		RemoveDirAll( root )
	END_TEST

	'' "Any path on the volume" must mean it: a deep path and the volume root
	'' must report the same capacity.
	TEST( any_path_on_the_volume_gives_the_same_answer )
		dim as ustring root = hTempTree( )
		CreateDirAll( PathJoin( root, "a", "b" ) )

		dim as FsResultSpace deep = GetDiskSpace( PathJoin( root, "a", "b" ) )
		dim as FsResultSpace top = GetDiskSpace( root )

		CU_ASSERT_TRUE( deep.IsOk( ) )
		CU_ASSERT_TRUE( top.IsOk( ) )
		CU_ASSERT_EQUAL( deep.Value( ).TotalBytes, top.Value( ).TotalBytes )

		'' and a FILE path works too, not just a directory
		dim as ustring f = PathJoin( root, "a", "f.txt" )
		WriteAllText( f, "x" )
		dim as FsResultSpace onfile = GetDiskSpace( f )
		CU_ASSERT_TRUE( onfile.IsOk( ) )
		CU_ASSERT_EQUAL( onfile.Value( ).TotalBytes, top.Value( ).TotalBytes )

		RemoveDirAll( root )
	END_TEST

	'' Space must move the RIGHT WAY when a file appears and disappears.
	''
	'' The bound is deliberately loose and ASYMMETRIC -- at least half of what
	'' was written -- because other processes are using the same disk during
	'' the test. A tight equality here would be a flaky test, and a flaky test
	'' is worse than a loose one.
	TEST( space_moves_when_a_file_is_written )
		dim as ustring root = hTempTree( )
		dim as ustring f = PathJoin( root, "big.bin" )

		'' Queried through a path that OUTLIVES the fixture. GetDiskSpace now
		'' requires its path to exist, so asking about `root` after removing
		'' it would be a failure -- and reading .Value( ) off that failure
		'' aborts the whole run rather than failing one case.
		dim as ustring probe = TempDir( ).Value( )

		dim as ulongint before = GetDiskSpace( probe ).Value( ).AvailableBytes

		'' 16 MiB, written in 1 MiB appends
		for chunk as long = 1 to 16
			AppendAllText( f, string( 1048576, "A" ) )
		next

		dim as ulongint afterw = GetDiskSpace( probe ).Value( ).AvailableBytes
		CU_ASSERT_TRUE( before - afterw >= 8388608 )

		CU_ASSERT_TRUE( RemoveDirAll( root ).IsOk( ) )
		CU_ASSERT_FALSE( Exists( f ) )

		'' THE RECOVERY DIRECTION IS DELIBERATELY NOT ASSERTED, and this is a
		'' limit of what a test can observe rather than a gap in the library.
		''
		'' Free space is a SHARED, CONTENDED counter. Two things were measured
		'' here, both reproducible:
		''
		''   1. On an idle machine, NTFS does not reflect a deletion in the
		''      volume's free-space accounting for roughly three seconds --
		''      sampling immediately sees zero recovered, every single time.
		''   2. Under load -- the full test suite building 2,600 modules on the
		''      same disk -- it does not recover within TWELVE seconds either,
		''      because other processes consume more than the 16 MiB freed here
		''      while we wait.
		''
		'' A polling version of this assertion therefore passed in isolation and
		'' failed in the full run, which is the worst possible outcome: a test
		'' that reports on machine load rather than on code. No timeout fixes
		'' that, because any bound can be exceeded by an unrelated process.
		''
		'' What IS asserted above is the write direction, and that one is sound:
		'' masking a 16 MiB allocation would require something else to FREE
		'' 8 MiB in the same short window, whereas the ambient noise runs the
		'' other way. Deletion is verified by Exists, which is exact.
		CU_ASSERT_TRUE( afterw <= before )
	END_TEST

	TEST( absent_path_is_not_found_not_a_zeroed_success )
		dim as FsResultSpace s = GetDiskSpace( "C:\definitely\not\here\at\all" )

		CU_ASSERT_FALSE( s.IsOk( ) )
		CU_ASSERT_NOT_EQUAL( s.Failure( ).Code( ), FS_OK )

		dim as FsResultVol v = GetVolumeInfo( "C:\definitely\not\here\at\all" )
		CU_ASSERT_FALSE( v.IsOk( ) )
	END_TEST

	TEST( volume_info_basics )
		dim as ustring root = hTempTree( )

		dim as FsResultVol v = GetVolumeInfo( root )
		CU_ASSERT_TRUE( v.IsOk( ) )

		'' the reported root must actually contain the path it was asked about
		CU_ASSERT_TRUE( len( v.Value( ).RootPath ) > 0 )
		CU_ASSERT_TRUE( PathStartsWith( root, v.Value( ).RootPath ) )

		'' true of every filesystem this project targets
		CU_ASSERT_TRUE( v.Value( ).MaxComponentLen >= 255 )

		'' a volume we just created a directory on is not read-only
		CU_ASSERT_FALSE( v.Value( ).IsReadOnly )

		RemoveDirAll( root )
	END_TEST

	'' THE ONLY FIELD CHECKABLE AGAINST GROUND TRUTH, and the one section 2
	'' says is easy to get wrong.
	''
	'' Create "a.tmp", then ask whether "A.tmp" resolves to it. Whatever the
	'' filesystem actually does is what IsCaseSensitive must report -- not what
	'' a capability flag claims. On NTFS FILE_CASE_SENSITIVE_SEARCH is SET
	'' while Win32 lookup is case-INSENSITIVE, so an implementation reporting
	'' the flag fails right here.
	TEST( iscasesensitive_agrees_with_reality )
		dim as ustring root = hTempTree( )
		dim as ustring lower = PathJoin( root, "casetest.tmp" )
		dim as ustring upper = PathJoin( root, "CASETEST.TMP" )

		WriteAllText( lower, "x" )

		'' observed behaviour: does the differently-cased name find the file?
		dim as boolean collides = Exists( upper )

		dim as FsResultVol v = GetVolumeInfo( root )
		CU_ASSERT_TRUE( v.IsOk( ) )

		'' case-sensitive means they must NOT collide, and vice versa
		CU_ASSERT_EQUAL( v.Value( ).IsCaseSensitive, ( collides = FALSE ) )

		RemoveDirAll( root )
	END_TEST

	'' SupportsLinks is documented as ASYMMETRIC: a FALSE is reliable, a TRUE
	'' is best-effort. So only the reliable direction is asserted -- where it
	'' says links are impossible, creating one must fail.
	TEST( supportslinks_false_is_reliable )
		dim as ustring root = hTempTree( )

		dim as FsResultVol v = GetVolumeInfo( root )
		CU_ASSERT_TRUE( v.IsOk( ) )

		if( v.Value( ).SupportsLinks = FALSE ) then
			dim as ustring tgt = PathJoin( root, "t.txt" )
			WriteAllText( tgt, "x" )

			dim as FsResultBool mk = CreateSymlink( tgt, PathJoin( root, "l" ) )
			CU_ASSERT_FALSE( mk.IsOk( ) )
		else
			'' the TRUE direction is explicitly NOT asserted -- it is a
			'' best-effort answer on Linux and asserting it would make this
			'' test fail on a filesystem the library was honest about
			CU_ASSERT_TRUE( TRUE )
		end if

		RemoveDirAll( root )
	END_TEST

	'' The enumeration must include the volume the temp directory lives on --
	'' the one assertion about GetVolumes that holds on both platforms.
	TEST( getvolumes_includes_this_one )
		dim as ustring root = hTempTree( )

		dim as FsResultVol mine = GetVolumeInfo( root )
		CU_ASSERT_TRUE( mine.IsOk( ) )

		dim as Array( of VolumeInfo ) vols
		dim as FsResultLong n = GetVolumes( vols )

		CU_ASSERT_TRUE( n.IsOk( ) )
		CU_ASSERT_TRUE( n.Value( ) >= 1 )
		CU_ASSERT_EQUAL( n.Value( ), vols.Count( ) )

		dim as boolean found = FALSE
		for i as long = 0 to vols.Count( ) - 1
			if( PathEquals( vols[i].RootPath, mine.Value( ).RootPath ) ) then
				found = TRUE
			end if
		next

		CU_ASSERT_TRUE( found )

		RemoveDirAll( root )
	END_TEST

	'' Every enumerated volume must be usable: a root that exists, and space
	'' figures that obey the same invariants. A drive with no media must have
	'' been skipped, not reported with zeros.
	TEST( every_enumerated_volume_is_usable )
		dim as Array( of VolumeInfo ) vols
		CU_ASSERT_TRUE( GetVolumes( vols ).IsOk( ) )

		for i as long = 0 to vols.Count( ) - 1
			CU_ASSERT_TRUE( len( vols[i].RootPath ) > 0 )
			CU_ASSERT_TRUE( IsDir( vols[i].RootPath ) )

			dim as FsResultSpace s = GetDiskSpace( vols[i].RootPath )
			CU_ASSERT_TRUE( s.IsOk( ) )
			CU_ASSERT_TRUE( s.Value( ).TotalBytes > 0 )
			CU_ASSERT_TRUE( s.Value( ).AvailableBytes <= s.Value( ).FreeBytes )
		next
	END_TEST

	'' GetVolumes MUST RETURN PROMPTLY even with an empty optical drive or an
	'' unmapped network letter present. Without
	'' SetThreadErrorMode( SEM_FAILCRITICALERRORS ) that probe pops a system
	'' modal dialog and this never returns -- so the assertion is really
	'' "it finished", and the failure mode of getting it wrong is a hang.
	TEST( getvolumes_returns_promptly )
		dim as double t0 = timer

		for rep as long = 1 to 3
			dim as Array( of VolumeInfo ) vols
			CU_ASSERT_TRUE( GetVolumes( vols ).IsOk( ) )
		next

		'' three full enumerations in well under the multi-second timeout a
		'' no-media probe would cost
		CU_ASSERT_TRUE( ( timer - t0 ) < 10.0 )
	END_TEST

	'' The per-volume answer and the compile-time per-platform constant are
	'' DIFFERENT QUESTIONS and must not be conflated. This does not assert they
	'' agree -- they legitimately need not -- only that both are reachable and
	'' that the lexical one matches the grammar it was built for.
	TEST( per_volume_and_lexical_case_rules_are_distinct )
		#if defined( __FB_WIN32__ )
			CU_ASSERT_FALSE( PathIsCaseSensitive( ) )
		#else
			CU_ASSERT_TRUE( PathIsCaseSensitive( ) )
		#endif

		dim as ustring root = hTempTree( )
		dim as FsResultVol v = GetVolumeInfo( root )
		CU_ASSERT_TRUE( v.IsOk( ) )

		'' both answered; whether they agree is the machine's business
		RemoveDirAll( root )
	END_TEST

	'' Linux only: the pseudo-filesystem filter. Nothing that GetVolumes
	'' reports should be proc, sysfs, cgroup or devtmpfs.
	TEST( no_pseudo_filesystems_are_reported )
		#if defined( __FB_LINUX__ )
			dim as Array( of VolumeInfo ) vols
			CU_ASSERT_TRUE( GetVolumes( vols ).IsOk( ) )

			for i as long = 0 to vols.Count( ) - 1
				CU_ASSERT_NOT_EQUAL( vols[i].FileSystem, "proc" )
				CU_ASSERT_NOT_EQUAL( vols[i].FileSystem, "sysfs" )
				CU_ASSERT_NOT_EQUAL( vols[i].FileSystem, "cgroup2" )
				CU_ASSERT_NOT_EQUAL( vols[i].FileSystem, "devtmpfs" )
			next
		#else
			'' Windows enumerates drive letters, so there is no pseudo-
			'' filesystem class to filter
			CU_ASSERT_TRUE( TRUE )
		#endif
	END_TEST

END_SUITE
