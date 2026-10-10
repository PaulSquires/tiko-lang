'' Locking, memory mapping and change watching -- RFC-0009.
''
'' THE WATCH TESTS ARE INHERENTLY TIMING-DEPENDENT and are written to be
'' tolerant rather than precise: generous timeouts, drain-until-quiet helpers,
'' and assertions about what MUST appear rather than about exact event counts.
'' A filesystem change can legitimately produce more than one event -- writing a
'' new file yields both a CREATED and a MODIFIED on Windows -- so asserting an
'' exact count would be asserting a platform detail, not the contract.
''
'' NOT ASSERTED HERE:
''
''   - That a truncating writer turns a mapped read into a fault. The behaviour
''     is real and documented, and deliberately triggering a SIGBUS or a
''     structured exception inside a test would take the whole run down.
''   - Cross-PROCESS lock exclusion. Two FileLocks in one process is the
''     strongest exclusion this suite can demonstrate without spawning a
''     second process; the mandatory-vs-advisory divergence is a documented
''     contract, not something a single-process test can probe.

#import "std/fs"
#include "fbcunit.bi"

#include once "fb/result.bi"

#include once "fb/array.bi"

using fs

using FB
private function hTempTree( ) as ustring
	dim as FsResultUStr r = CreateTempDir( "fbcuadv" )
	if( r.IsOk( ) = FALSE ) then return ""
	return r.Value( )
end function

'' Drain a watcher until it reports nothing for a full short timeout, so a test
'' can start from a known-quiet state. Returns how many it discarded.
private function hDrain( byref w as FileWatcher ) as long
	dim as Array( of FsChange ) ch
	dim as long total = 0

	for i as long = 1 to 20
		dim as FsResultLong n = w.Poll( ch, 200 )
		if( n.IsOk( ) = FALSE ) then exit for
		if( n.Value( ) = 0 ) then exit for
		total += n.Value( )
	next

	return total
end function

'' Poll repeatedly, up to a few seconds, until an event of `kind` naming `leaf`
'' turns up. Tolerant of extra events and of ordering.
private function hWaitFor( byref w as FileWatcher, byval kind as FsChangeKind, byref leaf as const ustring ) as boolean
	dim as Array( of FsChange ) ch

	for attempt as long = 1 to 15
		dim as FsResultLong n = w.Poll( ch, 400 )
		if( n.IsOk( ) = FALSE ) then return FALSE

		for i as long = 0 to ch.Count( ) - 1
			if( ch[i].Kind( ) = kind ) then
				if( PathFileName( ch[i].Path( ) ) = leaf ) then return TRUE
			end if
		next
	next

	return FALSE
end function

SUITE( fbc_tests.filesystem.fsadvanced )

	TEST( abi_layout_matches_c )
		CU_ASSERT_EQUAL( sizeof( FsChangeRaw ), FsSizeofChange( ) )
	END_TEST

	'' ============================================================ locking

	'' A second exclusive acquire must FAIL while the first is held, and the
	'' code must be specific -- FS_IN_USE, not a generic denial.
	TEST( exclusive_lock_excludes )
		dim as ustring root = hTempTree( )
		dim as ustring lf = PathJoin( root, "guard.lock" )

		dim as FileLock a
		CU_ASSERT_TRUE( a.Acquire( lf ).IsOk( ) )
		CU_ASSERT_TRUE( a.IsHeld( ) )

		scope
			dim as FileLock b
			dim as FsResultBool second = b.Acquire( lf, TRUE, 0 )
			CU_ASSERT_FALSE( second.IsOk( ) )
			CU_ASSERT_EQUAL( second.Failure( ).Code( ), FS_IN_USE )
			CU_ASSERT_FALSE( b.IsHeld( ) )
		end scope

		'' released explicitly, then available again
		a.Release( )
		CU_ASSERT_FALSE( a.IsHeld( ) )

		scope
			dim as FileLock c
			CU_ASSERT_TRUE( c.Acquire( lf, TRUE, 0 ).IsOk( ) )
		end scope

		RemoveDirAll( root )
	END_TEST

	'' The destructor must release, so an abandoned lock is not a deadlock
	'' waiting to happen. Asserted by taking the lock in an inner scope and
	'' then acquiring it again after that scope ends.
	TEST( destructor_releases_the_lock )
		dim as ustring root = hTempTree( )
		dim as ustring lf = PathJoin( root, "scoped.lock" )

		scope
			dim as FileLock inner
			CU_ASSERT_TRUE( inner.Acquire( lf ).IsOk( ) )
		end scope

		dim as FileLock after
		CU_ASSERT_TRUE( after.Acquire( lf, TRUE, 0 ).IsOk( ) )
		after.Release( )

		RemoveDirAll( root )
	END_TEST

	'' A positive timeout must GIVE UP rather than wait forever -- the one
	'' behaviour a lock API must not force on a caller.
	TEST( lock_timeout_expires_and_returns_in_use )
		dim as ustring root = hTempTree( )
		dim as ustring lf = PathJoin( root, "slow.lock" )

		dim as FileLock held
		CU_ASSERT_TRUE( held.Acquire( lf ).IsOk( ) )

		dim as double t0 = timer
		dim as FileLock waiter
		dim as FsResultBool r = waiter.Acquire( lf, TRUE, 300 )
		dim as double elapsed = timer - t0

		CU_ASSERT_FALSE( r.IsOk( ) )
		CU_ASSERT_EQUAL( r.Failure( ).Code( ), FS_IN_USE )

		'' it actually waited, and it actually stopped
		CU_ASSERT_TRUE( elapsed >= 0.2 )
		CU_ASSERT_TRUE( elapsed < 5.0 )

		held.Release( )
		RemoveDirAll( root )
	END_TEST

	'' Shared locks coexist; a shared lock still excludes an exclusive one.
	TEST( shared_locks_coexist )
		dim as ustring root = hTempTree( )
		dim as ustring lf = PathJoin( root, "shared.lock" )

		dim as FileLock a, b
		CU_ASSERT_TRUE( a.Acquire( lf, FALSE ).IsOk( ) )
		CU_ASSERT_TRUE( b.Acquire( lf, FALSE, 0 ).IsOk( ) )

		scope
			dim as FileLock x
			CU_ASSERT_FALSE( x.Acquire( lf, TRUE, 0 ).IsOk( ) )
		end scope

		a.Release( )
		b.Release( )
		RemoveDirAll( root )
	END_TEST

	'' ====================================================== memory mapping

	TEST( mapping_reads_the_file_contents )
		dim as ustring root = hTempTree( )
		dim as ustring f = PathJoin( root, "m.bin" )
		WriteAllText( f, "HELLO-MAPPED" )

		dim as MemoryMappedFile m
		CU_ASSERT_TRUE( m.Open( f ).IsOk( ) )
		CU_ASSERT_TRUE( m.IsOpen( ) )
		CU_ASSERT_EQUAL( m.Size( ), 12 )

		dim as ubyte ptr d = m.Data( )
		CU_ASSERT_TRUE( d <> 0 )
		CU_ASSERT_EQUAL( d[0], asc( "H" ) )
		CU_ASSERT_EQUAL( d[11], asc( "D" ) )

		m.Close( )
		CU_ASSERT_FALSE( m.IsOpen( ) )

		RemoveDirAll( root )
	END_TEST

	'' A write through the mapping must reach the file -- that is the whole
	'' reason for a writable mapping.
	TEST( writable_mapping_writes_through )
		dim as ustring root = hTempTree( )
		dim as ustring f = PathJoin( root, "w.bin" )
		WriteAllText( f, "HELLO" )

		dim as MemoryMappedFile m
		CU_ASSERT_TRUE( m.Open( f, TRUE ).IsOk( ) )

		dim as ubyte ptr d = m.Data( )
		d[0] = asc( "J" )

		CU_ASSERT_TRUE( m.Flush( ).IsOk( ) )
		m.Close( )

		CU_ASSERT_EQUAL( ReadAllText( f ).Value( ), "JELLO" )

		RemoveDirAll( root )
	END_TEST

	'' A read-only mapping must not be writable through the OS, and Flush on
	'' one is a harmless no-op rather than an error.
	TEST( readonly_mapping_flush_is_a_noop )
		dim as ustring root = hTempTree( )
		dim as ustring f = PathJoin( root, "r.bin" )
		WriteAllText( f, "ABC" )

		dim as MemoryMappedFile m
		CU_ASSERT_TRUE( m.Open( f, FALSE ).IsOk( ) )
		CU_ASSERT_TRUE( m.Flush( ).IsOk( ) )
		m.Close( )

		CU_ASSERT_EQUAL( ReadAllText( f ).Value( ), "ABC" )

		RemoveDirAll( root )
	END_TEST

	'' A zero-length file CANNOT be mapped, on either platform, and the
	'' refusal is explicit rather than a pointer that cannot be dereferenced.
	TEST( empty_file_cannot_be_mapped )
		dim as ustring root = hTempTree( )
		dim as ustring f = PathJoin( root, "empty.bin" )
		WriteAllText( f, "" )

		dim as MemoryMappedFile m
		dim as FsResultBool r = m.Open( f )

		CU_ASSERT_FALSE( r.IsOk( ) )
		CU_ASSERT_EQUAL( r.Failure( ).Code( ), FS_INVALID_PATH )
		CU_ASSERT_FALSE( m.IsOpen( ) )

		RemoveDirAll( root )
	END_TEST

	TEST( mapping_a_missing_file_fails )
		dim as MemoryMappedFile m
		dim as FsResultBool r = m.Open( "C:\definitely\not\here.bin" )

		CU_ASSERT_FALSE( r.IsOk( ) )
		CU_ASSERT_EQUAL( r.Failure( ).Code( ), FS_NOT_FOUND )
	END_TEST

	'' The destructor must unmap, so an abandoned mapping does not pin the
	'' file. Asserted by deleting the file afterwards, which fails on Windows
	'' while a mapping is live.
	TEST( destructor_unmaps )
		dim as ustring root = hTempTree( )
		dim as ustring f = PathJoin( root, "d.bin" )
		WriteAllText( f, "XYZ" )

		scope
			dim as MemoryMappedFile m
			CU_ASSERT_TRUE( m.Open( f ).IsOk( ) )
		end scope

		'' a still-mapped file cannot be deleted on Windows, so this
		'' succeeding is the proof that the destructor ran
		CU_ASSERT_TRUE( RemoveFile( f ).IsOk( ) )

		RemoveDirAll( root )
	END_TEST

	'' ========================================================== watching

	TEST( watch_start_and_stop )
		dim as ustring root = hTempTree( )

		dim as FileWatcher w
		CU_ASSERT_TRUE( w.Start( root ).IsOk( ) )
		CU_ASSERT_TRUE( w.IsWatching( ) )

		w.Stop( )
		CU_ASSERT_FALSE( w.IsWatching( ) )

		RemoveDirAll( root )
	END_TEST

	TEST( watching_a_missing_directory_fails )
		dim as FileWatcher w
		dim as FsResultBool r = w.Start( "C:\definitely\not\here" )

		CU_ASSERT_FALSE( r.IsOk( ) )
		CU_ASSERT_FALSE( w.IsWatching( ) )
	END_TEST

	'' Polling a watcher that was never started is an ERROR, not an empty
	'' success -- "nothing happened" and "there is no watch" are different.
	TEST( polling_an_unstarted_watcher_is_an_error )
		dim as FileWatcher w
		dim as Array( of FsChange ) ch

		dim as FsResultLong r = w.Poll( ch, 0 )
		CU_ASSERT_FALSE( r.IsOk( ) )
	END_TEST

	'' A TIMEOUT IS AN EMPTY SUCCESS, not a failure. This is the assertion
	'' that keeps "nothing happened" distinguishable from "the watch broke".
	TEST( timeout_is_an_empty_success )
		dim as ustring root = hTempTree( )

		dim as FileWatcher w
		CU_ASSERT_TRUE( w.Start( root ).IsOk( ) )

		hDrain( w )                  '' start from quiet

		dim as Array( of FsChange ) ch
		dim as FsResultLong n = w.Poll( ch, 300 )

		CU_ASSERT_TRUE( n.IsOk( ) )
		CU_ASSERT_EQUAL( n.Value( ), 0 )
		CU_ASSERT_EQUAL( ch.Count( ), 0 )

		w.Stop( )
		RemoveDirAll( root )
	END_TEST

	'' Creating a file must produce a CREATED event naming it. The path must
	'' be the FULL path, not a bare leaf -- the same rule DirEntry.Path
	'' follows, and for the same reason.
	TEST( creating_a_file_is_reported )
		dim as ustring root = hTempTree( )

		dim as FileWatcher w
		CU_ASSERT_TRUE( w.Start( root ).IsOk( ) )
		hDrain( w )

		WriteAllText( PathJoin( root, "made.txt" ), "x" )

		CU_ASSERT_TRUE( hWaitFor( w, FS_CHANGE_CREATED, "made.txt" ) )

		w.Stop( )
		RemoveDirAll( root )
	END_TEST

	TEST( deleting_a_file_is_reported )
		dim as ustring root = hTempTree( )
		dim as ustring f = PathJoin( root, "doomed.txt" )
		WriteAllText( f, "x" )

		dim as FileWatcher w
		CU_ASSERT_TRUE( w.Start( root ).IsOk( ) )
		hDrain( w )

		RemoveFile( f )

		CU_ASSERT_TRUE( hWaitFor( w, FS_CHANGE_DELETED, "doomed.txt" ) )

		w.Stop( )
		RemoveDirAll( root )
	END_TEST

	'' The reported path must be usable, not a leaf the caller has to re-join.
	TEST( reported_paths_are_full_paths )
		dim as ustring root = hTempTree( )

		dim as FileWatcher w
		CU_ASSERT_TRUE( w.Start( root ).IsOk( ) )
		hDrain( w )

		WriteAllText( PathJoin( root, "full.txt" ), "x" )

		dim as Array( of FsChange ) ch
		dim as boolean sawfull = FALSE

		for attempt as long = 1 to 15
			dim as FsResultLong n = w.Poll( ch, 400 )
			if( n.IsOk( ) = FALSE ) then exit for

			for i as long = 0 to ch.Count( ) - 1
				if( PathFileName( ch[i].Path( ) ) = "full.txt" ) then
					CU_ASSERT_TRUE( PathStartsWith( ch[i].Path( ), root ) )
					sawfull = TRUE
				end if
			next

			if( sawfull ) then exit for
		next

		CU_ASSERT_TRUE( sawfull )

		w.Stop( )
		RemoveDirAll( root )
	END_TEST

	'' A non-recursive watch must NOT report activity in a subdirectory, and
	'' a recursive one must. This is the pair that proves the flag does
	'' anything at all.
	TEST( recursive_flag_controls_subdirectory_events )
		dim as ustring root = hTempTree( )
		dim as ustring sub_ = PathJoin( root, "deeper" )
		CreateDirAll( sub_ )

		'' recursive: the event must arrive
		scope
			dim as FileWatcher w
			CU_ASSERT_TRUE( w.Start( root, TRUE ).IsOk( ) )
			hDrain( w )

			WriteAllText( PathJoin( sub_, "inner.txt" ), "x" )
			CU_ASSERT_TRUE( hWaitFor( w, FS_CHANGE_CREATED, "inner.txt" ) )
			w.Stop( )
		end scope

		'' non-recursive: it must not
		scope
			dim as FileWatcher w
			CU_ASSERT_TRUE( w.Start( root, FALSE ).IsOk( ) )
			hDrain( w )

			WriteAllText( PathJoin( sub_, "inner2.txt" ), "x" )

			dim as Array( of FsChange ) ch
			dim as boolean saw = FALSE

			for attempt as long = 1 to 4
				dim as FsResultLong n = w.Poll( ch, 300 )
				if( n.IsOk( ) = FALSE ) then exit for
				for i as long = 0 to ch.Count( ) - 1
					if( PathFileName( ch[i].Path( ) ) = "inner2.txt" ) then saw = TRUE
				next
			next

			CU_ASSERT_FALSE( saw )
			w.Stop( )
		end scope

		RemoveDirAll( root )
	END_TEST

	'' A directory created AFTER the watch started must also be watched, or
	'' everything inside it is invisible for the watcher's lifetime. On Linux
	'' this needs an explicit inotify_add_watch per new directory; on Windows
	'' the recursive flag covers it. Both must behave the same.
	TEST( directories_created_while_watching_are_watched )
		dim as ustring root = hTempTree( )

		dim as FileWatcher w
		CU_ASSERT_TRUE( w.Start( root, TRUE ).IsOk( ) )
		hDrain( w )

		dim as ustring fresh = PathJoin( root, "appeared" )
		CreateDirAll( fresh )

		'' let the watcher notice the directory before writing into it
		CU_ASSERT_TRUE( hWaitFor( w, FS_CHANGE_CREATED, "appeared" ) )

		WriteAllText( PathJoin( fresh, "within.txt" ), "x" )
		CU_ASSERT_TRUE( hWaitFor( w, FS_CHANGE_CREATED, "within.txt" ) )

		w.Stop( )
		RemoveDirAll( root )
	END_TEST

	'' Restarting must drop the old watch cleanly rather than leaking it.
	TEST( restart_replaces_the_watch )
		dim as ustring root = hTempTree( )
		dim as ustring other = hTempTree( )

		dim as FileWatcher w
		CU_ASSERT_TRUE( w.Start( root ).IsOk( ) )
		CU_ASSERT_TRUE( w.Start( other ).IsOk( ) )
		CU_ASSERT_TRUE( w.IsWatching( ) )

		hDrain( w )
		WriteAllText( PathJoin( other, "second.txt" ), "x" )
		CU_ASSERT_TRUE( hWaitFor( w, FS_CHANGE_CREATED, "second.txt" ) )

		w.Stop( )
		RemoveDirAll( root )
		RemoveDirAll( other )
	END_TEST

END_SUITE
