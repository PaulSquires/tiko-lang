'' The STRING overload layer, audited across the whole module -- phase 8.
''
'' The module's kernel is USTRING and its convenience layer is STRING. Almost
'' every entry point takes `byref as const ustring` and relies on fbc's IMPLICIT
'' conversion to accept the other three types -- which is load-bearing, because
'' every other suite in this directory passes STRING literals into ustring
'' parameters and always has. This suite is what makes that path deliberate
'' rather than incidental.
''
'' WHAT THE CONVERSION ACTUALLY DOES, measured rather than assumed:
''
''   STRING  -> USTRING   decodes as UTF-8; invalid bytes become U+FFFD
''   USTRING -> STRING    encodes as UTF-8
''
'' It is UTF-8 in BOTH directions and on BOTH platforms -- not the ANSI
'' codepage, and not lossless. Those two facts are asserted below, because
'' RFC-0001 section 5 originally described the inward direction as "total on
'' Windows" and claimed invalid input would be rejected with FS_INVALID_PATH.
'' Neither is true: it substitutes silently, everywhere.

#import "std/fs"
#import "std/outcome"
#import "std/containers"
#include "fbcunit.bi"

#include once "fberror.bi"

using fs, outcome, containers

using FB
'' Resolves on the ACTUAL type of whatever it is handed, so a test can assert
'' which overload a call selected rather than guessing from the value.
private function which overload ( byref x as const string ) as string
	return "string"
end function

private function which overload ( byref x as const ustring ) as string
	return "ustring"
end function

private function hTempTree( ) as ustring
	dim as FsResultUStr r = CreateTempDir( "fbcustr" )
	if( r.IsOk( ) = FALSE ) then return ""
	return r.Value( )
end function

SUITE( fbc_tests.filesystem.fsstrings )

	'' ============================================ the conversion itself

	'' STRING -> USTRING IS UTF-8, not the ANSI codepage. Two UTF-8 bytes for
	'' U+00E9 must become ONE code unit; if this were a codepage or byte-per-
	'' char conversion it would become two.
	TEST( string_to_ustring_decodes_utf8 )
		dim as string utf8 = chr( &hC3 ) + chr( &hA9 )      '' U+00E9
		dim as ustring u = utf8

		CU_ASSERT_EQUAL( len( u ), 1 )
		CU_ASSERT_EQUAL( u[0], &h00E9 )
	END_TEST

	'' USTRING -> STRING is UTF-8 too, so the round trip is exact for anything
	'' that was valid UTF-8 to begin with.
	TEST( ustring_to_string_encodes_utf8 )
		dim as ustring u = wchr( &h00E9 )
		dim as string s = u

		CU_ASSERT_EQUAL( len( s ), 2 )
		CU_ASSERT_EQUAL( s[0], &hC3 )
		CU_ASSERT_EQUAL( s[1], &hA9 )

		'' and back again unchanged
		dim as ustring back = s
		CU_ASSERT_EQUAL( back, u )
	END_TEST

	'' INVALID UTF-8 IS REPLACED, SILENTLY, AND DOES NOT FAIL. A lone 0xE9 --
	'' which is what a legacy Latin-1 or codepage string holds for e-acute --
	'' becomes U+FFFD. There is no error and no way to detect it after the
	'' fact, which is exactly why RFC-0001 tells callers to use the USTRING
	'' family for paths that came FROM the filesystem.
	TEST( invalid_utf8_becomes_replacement_not_an_error )
		dim as string latin1 = chr( &hE9 )
		dim as ustring u = latin1

		CU_ASSERT_EQUAL( len( u ), 1 )
		CU_ASSERT_EQUAL( u[0], &hFFFD )
		CU_ASSERT_NOT_EQUAL( u[0], &h00E9 )
	END_TEST

	'' The documented lossy case, asserted as LOSSY rather than asserted away:
	'' an unpaired surrogate cannot survive a trip through STRING.
	TEST( unpaired_surrogate_narrowing_is_platform_lossy )
		dim as ustring odd = "x" + wchr( &hD800 ) + "y"
		dim as string narrowed = odd
		dim as ustring back = narrowed

		'' Lossy on EVERY target: UTF-8 has no encoding for a lone surrogate, so
		'' the encoder substitutes U+FFFD, and the byte form is the same three
		'' bytes on Windows and POSIX alike.
		''
		'' This used to be a #if, asserting the round trip was LOSSLESS on POSIX
		'' because "the surrogate survives as WTF-8". It does not, and it never
		'' did. What actually happened was the WCHR bug: on a 32-bit-wchar target
		'' wchr( &hD800 ) turned into U+FFFD on the way into the ustring, so
		'' 'odd' held no surrogate at all and FFFD round-tripped to itself. With
		'' WCHR fixed the surrogate is really there, and the loss is visible --
		'' the same loss Windows always showed. See string/wchr-surrogate.bas.
		CU_ASSERT_NOT_EQUAL( back, odd )

		'' and the loss is exactly one U+FFFD, not mojibake or a dropped unit
		CU_ASSERT_EQUAL( len( back ), 3 )
		CU_ASSERT_EQUAL( back[1], &hFFFD )

		'' but a well-formed astral PAIR does survive
		'' via an explicit STRING local: there is no cast( string, ustring ),
		'' the conversion is an assignment
		dim as ustring astral = wchr( &hD83D ) + wchr( &hDE00 )
		dim as string astralnarrow = astral
		dim as ustring astralback = astralnarrow
		CU_ASSERT_EQUAL( astralback, astral )
	END_TEST

	'' ==================================== the three-overload path family

	'' string in -> string out, wstring/ustring in -> ustring out
	'' (fb/string.bi:53-54). Asserted on the RETURN TYPE, not on the value,
	'' because implicit conversion makes the value agree either way and would
	'' hide a wrong return type completely.
	TEST( path_family_returns_the_callers_width )
		dim as string       s = "C:\dev\a.bas"
		dim as wstring * 32 w = "C:\dev\a.bas"
		dim as ustring      u = "C:\dev\a.bas"

		'' the seven decomposition functions
		CU_ASSERT_EQUAL( which( PathRoot( s ) ), "string" )
		CU_ASSERT_EQUAL( which( PathParent( s ) ), "string" )
		CU_ASSERT_EQUAL( which( PathFileName( s ) ), "string" )
		CU_ASSERT_EQUAL( which( PathStem( s ) ), "string" )
		CU_ASSERT_EQUAL( which( PathExtension( s ) ), "string" )
		CU_ASSERT_EQUAL( which( PathNormalize( s ) ), "string" )
		CU_ASSERT_EQUAL( which( PathToNative( s ) ), "string" )

		'' THE TWO COMPOSERS, which returned ustring for a STRING argument
		'' until the phase-8 audit -- same family, two different rules, and
		'' implicit conversion hid it at every call site.
		CU_ASSERT_EQUAL( which( PathJoin( s, "x" ) ), "string" )
		CU_ASSERT_EQUAL( which( PathJoin( s, "x", "y" ) ), "string" )
		CU_ASSERT_EQUAL( which( PathJoin( s, "x", "y", "z" ) ), "string" )
		CU_ASSERT_EQUAL( which( PathChangeExtension( s, ".o" ) ), "string" )

		'' the wide families both yield ustring -- there is no dynamic
		'' WSTRING to return
		CU_ASSERT_EQUAL( which( PathExtension( w ) ), "ustring" )
		CU_ASSERT_EQUAL( which( PathExtension( u ) ), "ustring" )
		CU_ASSERT_EQUAL( which( PathJoin( w, "x" ) ), "ustring" )
		CU_ASSERT_EQUAL( which( PathJoin( u, "x" ) ), "ustring" )
	END_TEST

	'' Whatever width was chosen, the ANSWER must be the same.
	TEST( path_family_answers_agree_across_widths )
		'' The PATH is per-platform; the point of the test is not. A backslash
		'' is not a separator on POSIX, so the Windows spelling is one long
		'' filename there and PathStem correctly answers
		'' "C:\dev\tiko\frmMain". PathExtension agrees either way, which is
		'' why only the stem assertions noticed.
		#if defined( __FB_WIN32__ )
			const TESTPATH = "C:\dev\tiko\frmMain.bas"
		#else
			const TESTPATH = "/dev/tiko/frmMain.bas"
		#endif

		dim as string       s = TESTPATH
		dim as wstring * 64 w = TESTPATH
		dim as ustring      u = TESTPATH
		dim as zstring * 64 z = TESTPATH

		CU_ASSERT_EQUAL( PathExtension( s ), ".bas" )
		CU_ASSERT_EQUAL( PathExtension( w ), ".bas" )
		CU_ASSERT_EQUAL( PathExtension( u ), ".bas" )
		CU_ASSERT_EQUAL( PathExtension( z ), ".bas" )

		CU_ASSERT_EQUAL( PathStem( s ), "frmMain" )
		CU_ASSERT_EQUAL( PathStem( w ), "frmMain" )
		CU_ASSERT_EQUAL( PathStem( z ), "frmMain" )

		CU_ASSERT_EQUAL( PathJoin( s, "x" ), PathJoin( u, "x" ) )
		CU_ASSERT_EQUAL( PathChangeExtension( s, ".o" ), PathChangeExtension( u, ".o" ) )
	END_TEST

	'' ZSTRING is served by the STRING overload through fbc's own implicit
	'' conversion, which for bytes-to-bytes is exact and involves no locale.
	'' So all four types work and the caller never names which.
	TEST( zstring_reaches_the_string_overload )
		dim as zstring * 32 z = "a.bas"

		CU_ASSERT_EQUAL( which( PathExtension( z ) ), "string" )
		CU_ASSERT_EQUAL( PathExtension( z ), ".bas" )
	END_TEST

	'' ================================= the IO layer accepts every width
	''
	'' These entry points are USTRING-only by design -- see the note at the end
	'' of this suite -- so what matters is that all four widths reach them
	'' through implicit conversion and give identical answers. Every other
	'' suite in this directory depends on that silently; here it is asserted.

	TEST( io_layer_accepts_all_four_widths )
		dim as ustring root = hTempTree( )
		CU_ASSERT_TRUE( len( root ) > 0 )

		dim as ustring      up = PathJoin( root, "probe.txt" )
		dim as string       sp = up
		dim as wstring * 512 wp
		wp = up

		CU_ASSERT_TRUE( WriteAllText( sp, "content" ).IsOk( ) )

		'' every width finds the same file
		CU_ASSERT_TRUE( Exists( sp ) )
		CU_ASSERT_TRUE( Exists( wp ) )
		CU_ASSERT_TRUE( Exists( up ) )
		CU_ASSERT_TRUE( IsFile( sp ) )

		CU_ASSERT_EQUAL( ReadAllText( sp ).Value( ), "content" )
		CU_ASSERT_EQUAL( ReadAllText( wp ).Value( ), "content" )
		CU_ASSERT_EQUAL( ReadAllText( up ).Value( ), "content" )

		'' Stat agrees across widths
		CU_ASSERT_EQUAL( Stat( sp ).Value( ).Size( ), Stat( up ).Value( ).Size( ) )

		'' two-path operations take mixed widths
		dim as string dstS = PathJoin( root, "copy.txt" )
		CU_ASSERT_TRUE( CopyFile( sp, dstS ).IsOk( ) )
		CU_ASSERT_TRUE( Exists( dstS ) )

		'' directory operations
		dim as string dirS = PathJoin( root, "made" )
		CU_ASSERT_TRUE( CreateDirAll( dirS ).IsOk( ) )
		CU_ASSERT_TRUE( IsDir( dirS ) )

		'' iteration and glob
		dim as Array( of DirEntry ) entries
		CU_ASSERT_TRUE( ListDir( root, entries ).IsOk( ) )

		dim as Array( of ustring ) hits
		CU_ASSERT_TRUE( Glob( PathJoin( root, "*.txt" ), hits ).IsOk( ) )
		CU_ASSERT_EQUAL( hits.Count( ), 2 )

		RemoveDirAll( root )
	END_TEST

	'' Non-ASCII must survive an entire round trip through the STRING layer,
	'' because that is what a real path from a real machine looks like. The
	'' name is built with wchr so the source file's own encoding cannot affect
	'' what is being tested.
	TEST( non_ascii_paths_survive_the_string_layer )
		dim as ustring root = hTempTree( )

		dim as ustring leaf = wchr( &h00E9 ) + wchr( &h00E0 ) + wchr( &h4E2D ) + ".txt"
		dim as ustring up = PathJoin( root, leaf )

		'' created through the USTRING kernel...
		CU_ASSERT_TRUE( WriteAllText( up, "accented" ).IsOk( ) )

		'' ...and found again through the STRING layer
		dim as string sp = up
		CU_ASSERT_TRUE( Exists( sp ) )
		CU_ASSERT_EQUAL( ReadAllText( sp ).Value( ), "accented" )

		'' the leaf survives decomposition through STRING
		dim as string leafnarrow = leaf
		CU_ASSERT_EQUAL( PathFileName( sp ), leafnarrow )

		'' and the directory scan reports it identically
		dim as boolean found = FALSE
		for each r in ReadDir( root )
			if( r.IsOk( ) andalso ( r.Value( ).Name( ) = leaf ) ) then found = TRUE
		next
		CU_ASSERT_TRUE( found )

		RemoveDirAll( root )
	END_TEST

	'' The error type carries USTRING, so a path that reached it losslessly
	'' comes back losslessly -- FsError.Path is not narrowed on the way in.
	TEST( fserror_path_is_not_narrowed )
		dim as ustring odd = "C:\nope\" + wchr( &hD800 ) + ".txt"
		dim as FsResultUStr r = ReadAllText( odd )

		CU_ASSERT_FALSE( r.IsOk( ) )

		'' the stored path is the ustring it was given, surrogate intact
		CU_ASSERT_EQUAL( r.Failure( ).Path( ), odd )
		CU_ASSERT_EQUAL( len( r.Failure( ).Path( ) ), len( odd ) )
	END_TEST

	'' MatchPattern carries the same three-overload family as the path
	'' functions; it returns a boolean, so only the ARGUMENT widths matter.
	TEST( matchpattern_accepts_all_widths )
		dim as string       s = "frmMain.bas"
		dim as wstring * 32 w = "frmMain.bas"
		dim as ustring      u = "frmMain.bas"
		dim as zstring * 32 z = "frmMain.bas"

		CU_ASSERT_TRUE( MatchPattern( s, "*.bas" ) )
		CU_ASSERT_TRUE( MatchPattern( w, "*.bas" ) )
		CU_ASSERT_TRUE( MatchPattern( u, "*.bas" ) )
		CU_ASSERT_TRUE( MatchPattern( z, "*.bas" ) )
	END_TEST

	'' ============================================== the deliberate limit
	''
	'' THE IO LAYER RETURNS USTRING AND WILL NOT GAIN STRING-RETURNING
	'' OVERLOADS, and that is a decision rather than an omission.
	''
	'' A path that came FROM the filesystem is exactly the path that must not
	'' be narrowed: RFC-0001 section 5 rule 1 says so. Adding, say, a
	'' ReadLink returning STRING would hand callers a convenient way to do the
	'' one thing the whole USTRING-kernel design exists to prevent -- and it
	'' would look like the safe option because it matches the type they
	'' already have.
	''
	'' The PATH layer keeps its three overloads because it is PURE string
	'' manipulation: nothing there came from the filesystem, so preserving the
	'' caller's width costs nothing and loses nothing.
	''
	'' This test asserts the boundary so that a future "for consistency" patch
	'' has to argue with a failing test rather than with a comment.
	TEST( io_layer_returns_ustring_deliberately )
		dim as ustring root = hTempTree( )
		dim as string sp = PathJoin( root, "u.txt" )
		WriteAllText( sp, "x" )

		'' text and paths coming OUT of the filesystem are ustring
		CU_ASSERT_EQUAL( which( ReadAllText( sp ).Value( ) ), "ustring" )
		CU_ASSERT_EQUAL( which( CurrentDir( ).Value( ) ), "ustring" )
		CU_ASSERT_EQUAL( which( TempDir( ).Value( ) ), "ustring" )
		CU_ASSERT_EQUAL( which( CanonicalPath( sp ).Value( ) ), "ustring" )

		'' as are the names an enumeration reports
		for each r in ReadDir( root )
			if( r.IsOk( ) ) then
				CU_ASSERT_EQUAL( which( r.Value( ).Name( ) ), "ustring" )
				CU_ASSERT_EQUAL( which( r.Value( ).Path( ) ), "ustring" )
			end if
		next

		RemoveDirAll( root )
	END_TEST

END_SUITE
