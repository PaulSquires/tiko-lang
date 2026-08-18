'' Pattern matching and glob -- C:\dev\docs\filesystem\RFC-0006-glob.md.
''
'' The MATCHER half is pure and table-driven, so -- exactly as in
'' fspath_core.bas -- every case runs under BOTH grammars on whatever host this
'' is, and neither grammar is reachable only from its own platform.
''
'' One TEST block per numbered rule of RFC-0006 section 2, named after it, so a
'' failure names the rule it broke.

#include "fbcunit.bi"
#include once "fb/filesystem.bi"

using FB

'' Not `W`/`P`: FreeBASIC identifiers are case-insensitive, so a single-letter
'' macro silently swallows any local of the same name.
#define GW FB_PATH_WIN32
#define GP FB_PATH_POSIX

private function hTempTree( ) as ustring
	dim as FsResultUStr r = CreateTempDir( "fbcuglob" )
	if( r.IsOk( ) = FALSE ) then return ""
	return r.Value( )
end function

SUITE( fbc_tests.filesystem.fsglob )

	'' Rule 1: '*' does not cross a separator. This is the shell convention
	'' and the one every caller expects.
	TEST( rule01_star_does_not_cross_separator )
		CU_ASSERT_TRUE ( MatchPattern( "abc", "a*c", GP ) )
		CU_ASSERT_FALSE( MatchPattern( "a/b/c", "a*c", GP ) )
		CU_ASSERT_FALSE( MatchPattern( "a/c", "a*c", GP ) )
		CU_ASSERT_TRUE ( MatchPattern( "a/c", "a/*", GP ) )

		'' and the same under the Windows grammar, with its separator
		CU_ASSERT_FALSE( MatchPattern( "a\b\c", "a*c", GW ) )
	END_TEST

	'' Rule 2: '**' is only meaningful as a WHOLE component. Adjacent to other
	'' characters it degrades to a single '*' rather than inventing a third
	'' meaning -- matching Go's filepath.Match.
	TEST( rule02_doublestar_only_as_whole_component )
		CU_ASSERT_TRUE ( MatchPattern( "axxb", "a**b", GP ) )
		CU_ASSERT_FALSE( MatchPattern( "a/x/b", "a**b", GP ) )
	END_TEST

	'' Rule 3: '**' MATCHES ZERO COMPONENTS. Getting this wrong is the most
	'' common glob bug, so it gets its own block.
	TEST( rule03_doublestar_matches_zero_components )
		CU_ASSERT_TRUE( MatchPattern( "a/c", "a/**/c", GP ) )
		CU_ASSERT_TRUE( MatchPattern( "a/b/c", "a/**/c", GP ) )
		CU_ASSERT_TRUE( MatchPattern( "a/b/x/c", "a/**/c", GP ) )

		CU_ASSERT_TRUE( MatchPattern( "x", "**/x", GP ) )
		CU_ASSERT_TRUE( MatchPattern( "a/x", "**/x", GP ) )

		CU_ASSERT_TRUE( MatchPattern( "a", "a/**", GP ) )
		CU_ASSERT_TRUE( MatchPattern( "a/b", "a/**", GP ) )
		CU_ASSERT_TRUE( MatchPattern( "a/b/c", "a/**", GP ) )
	END_TEST

	'' Rule 4: case sensitivity follows the grammar, asserted under BOTH on
	'' whatever host this is.
	TEST( rule04_case_follows_the_grammar )
		CU_ASSERT_TRUE ( MatchPattern( "FOO.BAS", "*.bas", GW ) )
		CU_ASSERT_FALSE( MatchPattern( "FOO.BAS", "*.bas", GP ) )
		CU_ASSERT_TRUE ( MatchPattern( "foo.bas", "*.bas", GP ) )
		CU_ASSERT_TRUE ( MatchPattern( "FOO", "[a-z]*", GW ) )
		CU_ASSERT_FALSE( MatchPattern( "FOO", "[a-z]*", GP ) )
	END_TEST

	'' Rule 5: separators are equivalent under the Windows grammar, so a
	'' pattern written with '/' matches a path written with '\'.
	TEST( rule05_separators_equivalent_on_windows )
		CU_ASSERT_TRUE ( MatchPattern( "a\b\c.bas", "a/b/*.bas", GW ) )
		CU_ASSERT_TRUE ( MatchPattern( "a/b/c.bas", "a\b\*.bas", GW ) )

		'' under POSIX a backslash is NOT a separator
		CU_ASSERT_FALSE( MatchPattern( "a\b", "a/b", GP ) )
	END_TEST

	'' Rule 6: no escape character on Windows, because '\' is the separator.
	'' A literal '[' is matched there by the class "[[]".
	TEST( rule06_escape_is_posix_only )
		'' POSIX: backslash escapes the wildcard
		CU_ASSERT_TRUE ( MatchPattern( "a*b", "a\*b", GP ) )
		CU_ASSERT_FALSE( MatchPattern( "axxb", "a\*b", GP ) )

		'' both grammars: a class can carry a literal '['
		CU_ASSERT_TRUE( MatchPattern( "[", "[[]", GP ) )
		CU_ASSERT_TRUE( MatchPattern( "[", "[[]", GW ) )
	END_TEST

	'' Rule 7: a malformed class is a LITERAL. Raising on a typo in a
	'' user-supplied pattern would be worse than matching nothing.
	TEST( rule07_malformed_class_is_literal )
		CU_ASSERT_TRUE ( MatchPattern( "[abc", "[abc", GP ) )
		CU_ASSERT_FALSE( MatchPattern( "a", "[abc", GP ) )
		CU_ASSERT_TRUE ( MatchPattern( "[abc", "[abc", GW ) )
	END_TEST

	'' Rule 8: whole-string match. No implicit '*' at either end.
	TEST( rule08_match_is_whole_string )
		CU_ASSERT_FALSE( MatchPattern( "xa.bas", "a.bas", GP ) )
		CU_ASSERT_FALSE( MatchPattern( "a.basx", "a.bas", GP ) )
		CU_ASSERT_TRUE ( MatchPattern( "a.bas", "a.bas", GP ) )

		'' empty cases
		CU_ASSERT_TRUE ( MatchPattern( "", "", GP ) )
		CU_ASSERT_TRUE ( MatchPattern( "", "*", GP ) )
		CU_ASSERT_FALSE( MatchPattern( "a", "", GP ) )
	END_TEST

	'' '?' is exactly one character and never a separator.
	TEST( question_is_one_non_separator )
		CU_ASSERT_TRUE ( MatchPattern( "abc", "a?c", GP ) )
		CU_ASSERT_FALSE( MatchPattern( "ac", "a?c", GP ) )
		CU_ASSERT_FALSE( MatchPattern( "abbc", "a?c", GP ) )
		CU_ASSERT_FALSE( MatchPattern( "a/c", "a?c", GP ) )
	END_TEST

	'' Class edge cases, each of which has bitten a real glob implementation.
	TEST( class_edge_cases )
		CU_ASSERT_TRUE ( MatchPattern( "b", "[abc]", GP ) )
		CU_ASSERT_FALSE( MatchPattern( "d", "[abc]", GP ) )
		CU_ASSERT_TRUE ( MatchPattern( "m", "[a-z]", GP ) )
		CU_ASSERT_FALSE( MatchPattern( "M", "[a-z]", GP ) )

		'' negation, both spellings
		CU_ASSERT_TRUE ( MatchPattern( "d", "[!abc]", GP ) )
		CU_ASSERT_FALSE( MatchPattern( "a", "[!abc]", GP ) )
		CU_ASSERT_TRUE ( MatchPattern( "d", "[^abc]", GP ) )

		'' ']' as the first member is a LITERAL ']'
		CU_ASSERT_TRUE ( MatchPattern( "]", "[]]", GP ) )
		CU_ASSERT_TRUE ( MatchPattern( "x", "[!]]", GP ) )
		CU_ASSERT_FALSE( MatchPattern( "]", "[!]]", GP ) )

		'' a trailing '-' is a literal, not a dangling range
		CU_ASSERT_TRUE ( MatchPattern( "-", "[a-]", GP ) )
		CU_ASSERT_TRUE ( MatchPattern( "a", "[a-]", GP ) )
		CU_ASSERT_TRUE ( MatchPattern( "-", "[-a]", GP ) )
	END_TEST

	'' THE TEST THAT JUSTIFIES THE ITERATIVE MATCHER. A recursive
	'' implementation is exponential on this and would hang or blow the
	'' stack; the failure mode is not a wrong answer, so the assertion is
	'' really "it returns at all".
	TEST( pathological_pattern_terminates )
		dim as ustring hay = string( 64, "a" )

		CU_ASSERT_FALSE( MatchPattern( hay, "a*a*a*a*a*a*a*b", GP ) )
		CU_ASSERT_TRUE ( MatchPattern( hay, "a*a*a*a*a*a*a*a", GP ) )

		'' the same shape one level up, with '**' across components
		dim as ustring deep = "a/a/a/a/a/a/a/a/a/a/a/a"
		CU_ASSERT_FALSE( MatchPattern( deep, "a/**/a/**/a/**/a/**/b", GP ) )
	END_TEST

	'' Rule 3.1: the walk root is the last component with no wildcard. This
	'' is the difference between a glob and a full-disk scan.
	TEST( globroot_extraction )
		CU_ASSERT_EQUAL( GlobRoot( "C:\a\b\*.bas", GW ), "C:\a\b" )
		CU_ASSERT_EQUAL( GlobRoot( "C:\a\**\x", GW ), "C:\a" )
		CU_ASSERT_EQUAL( GlobRoot( "*.bas", GW ), "." )
		CU_ASSERT_EQUAL( GlobRoot( "/usr/lib/*.so", GP ), "/usr/lib" )

		'' no wildcard at all: the parent is the root
		CU_ASSERT_EQUAL( GlobRoot( "C:\a\b\c.bas", GW ), "C:\a\b" )

		'' a malformed class is a LITERAL and so must NOT drag the root up
		CU_ASSERT_EQUAL( GlobRoot( "C:\a\[abc", GW ), "C:\a" )
	END_TEST

	TEST( pattern_is_recursive_detection )
		CU_ASSERT_TRUE ( PatternIsRecursive( "a/**/b", GP ) )
		CU_ASSERT_TRUE ( PatternIsRecursive( "**", GP ) )
		CU_ASSERT_FALSE( PatternIsRecursive( "a/*/b", GP ) )
		CU_ASSERT_FALSE( PatternIsRecursive( "a**b", GP ) )   '' rule 2
	END_TEST

	'' ------------------------------------------------------ Glob on disk

	TEST( glob_matches_one_level )
		dim as ustring root = hTempTree( )
		CU_ASSERT_TRUE( len( root ) > 0 )

		WriteAllText( PathJoin( root, "one.bas" ), "1" )
		WriteAllText( PathJoin( root, "two.bas" ), "2" )
		WriteAllText( PathJoin( root, "three.txt" ), "3" )
		CreateDirAll( PathJoin( root, "sub" ) )
		WriteAllText( PathJoin( root, "sub", "deep.bas" ), "d" )

		dim as Array( of ustring ) got
		dim as FsResultLong n = Glob( PathJoin( root, "*.bas" ), got )

		CU_ASSERT_TRUE( n.IsOk( ) )
		CU_ASSERT_EQUAL( n.Value( ), 2 )

		'' Rule 3.2: a pattern without '**' must NOT recurse. The planted
		'' file one level deeper proves it.
		for i as long = 0 to got.Count( ) - 1
			CU_ASSERT_NOT_EQUAL( PathFileName( got[i] ), "deep.bas" )
		next

		RemoveDirAll( root )
	END_TEST

	TEST( glob_doublestar_recurses )
		dim as ustring root = hTempTree( )

		WriteAllText( PathJoin( root, "top.bas" ), "1" )
		CreateDirAll( PathJoin( root, "a", "b" ) )
		WriteAllText( PathJoin( root, "a", "mid.bas" ), "2" )
		WriteAllText( PathJoin( root, "a", "b", "deep.bas" ), "3" )
		WriteAllText( PathJoin( root, "a", "b", "no.txt" ), "4" )

		dim as Array( of ustring ) got
		dim as FsResultLong n = Glob( PathJoin( root, "**", "*.bas" ), got )

		CU_ASSERT_TRUE( n.IsOk( ) )

		'' '**' matches zero components too, so top.bas is included
		CU_ASSERT_EQUAL( n.Value( ), 3 )

		RemoveDirAll( root )
	END_TEST

	'' Rule 6: hidden entries ARE matched. Unlike a shell, '*' matches a
	'' leading dot. This will surprise someone coming from bash, so it is
	'' asserted rather than left implicit.
	TEST( glob_matches_hidden_entries )
		dim as ustring root = hTempTree( )

		WriteAllText( PathJoin( root, "plain.cfg" ), "1" )
		WriteAllText( PathJoin( root, ".hidden.cfg" ), "2" )

		dim as Array( of ustring ) got
		dim as FsResultLong n = Glob( PathJoin( root, "*.cfg" ), got )

		CU_ASSERT_TRUE( n.IsOk( ) )
		CU_ASSERT_EQUAL( n.Value( ), 2 )

		RemoveDirAll( root )
	END_TEST

	'' Rule 5: the only whole-call failure is an unopenable walk root.
	TEST( glob_fails_only_on_unopenable_root )
		dim as Array( of ustring ) got

		'' The absent root has to be spelled per platform. On POSIX the
		'' Windows spelling contains no separator at all, so it is one
		'' relative FILENAME, the directory to walk is ".", and Glob quite
		'' correctly succeeds with no matches.
		#if defined( __FB_WIN32__ )
			dim as ustring absent = "C:\definitely\not\here\*.bas"
		#else
			dim as ustring absent = "/definitely/not/here/*.bas"
		#endif

		dim as FsResultLong n = Glob( absent, got )
		CU_ASSERT_FALSE( n.IsOk( ) )
		if( n.IsOk( ) = FALSE ) then
			CU_ASSERT_EQUAL( n.Failure( ).Code( ), FS_NOT_FOUND )
		end if

		'' a root that exists but is a FILE is not a directory to walk
		dim as ustring root = hTempTree( )
		dim as ustring f = PathJoin( root, "afile" )
		WriteAllText( f, "x" )

		dim as FsResultLong m = Glob( PathJoin( f, "*.bas" ), got )
		CU_ASSERT_FALSE( m.IsOk( ) )
		if( m.IsOk( ) = FALSE ) then
			CU_ASSERT_EQUAL( m.Failure( ).Code( ), FS_NOT_A_DIRECTORY )
		end if

		RemoveDirAll( root )
	END_TEST

	'' A pattern matching nothing is an EMPTY SUCCESS, not a failure. The
	'' distinction matters: "no matches" and "could not look" are different
	'' answers and a caller may need to branch on it.
	TEST( glob_no_matches_is_empty_success )
		dim as ustring root = hTempTree( )
		WriteAllText( PathJoin( root, "a.txt" ), "1" )

		dim as Array( of ustring ) got
		dim as FsResultLong n = Glob( PathJoin( root, "*.nomatch" ), got )

		CU_ASSERT_TRUE( n.IsOk( ) )
		CU_ASSERT_EQUAL( n.Value( ), 0 )
		CU_ASSERT_EQUAL( got.Count( ), 0 )

		RemoveDirAll( root )
	END_TEST

	'' Results are full usable paths, not bare leaves -- the same reason
	'' DirEntry.Path( ) exists.
	TEST( glob_returns_usable_paths )
		dim as ustring root = hTempTree( )
		WriteAllText( PathJoin( root, "hit.bas" ), "content" )

		dim as Array( of ustring ) got
		dim as FsResultLong n = Glob( PathJoin( root, "*.bas" ), got )

		CU_ASSERT_TRUE( n.IsOk( ) )
		CU_ASSERT_EQUAL( n.Value( ), 1 )

		'' the returned path can be handed straight back to the module
		CU_ASSERT_EQUAL( ReadAllText( got[0] ).Value( ), "content" )
		CU_ASSERT_TRUE( PathStartsWith( got[0], root ) )

		RemoveDirAll( root )
	END_TEST

	'' The STRING and WSTRING overloads must agree with the USTRING kernel,
	'' and ZSTRING must reach the STRING one by implicit conversion.
	TEST( matchpattern_overloads_agree )
		dim as string       ss = "frmMain.bas"
		dim as wstring * 32 ww = "frmMain.bas"
		dim as ustring      uu = "frmMain.bas"
		dim as zstring * 32 zz = "frmMain.bas"

		CU_ASSERT_TRUE( MatchPattern( ss, "*.bas", GP ) )
		CU_ASSERT_TRUE( MatchPattern( ww, "*.bas", GP ) )
		CU_ASSERT_TRUE( MatchPattern( uu, "*.bas", GP ) )
		CU_ASSERT_TRUE( MatchPattern( zz, "*.bas", GP ) )

		CU_ASSERT_FALSE( MatchPattern( ss, "*.txt", GP ) )
	END_TEST

	'' Non-ASCII must survive the matcher, which is the property the
	'' USTRING-as-kernel decision exists to protect.
	TEST( non_ascii_matches )
		dim as ustring nm = wchr( &h00E9 ) + wchr( &h4E2D ) + ".bas"

		CU_ASSERT_TRUE ( MatchPattern( nm, "*.bas", GP ) )
		CU_ASSERT_TRUE ( MatchPattern( nm, "??.bas", GP ) )
		CU_ASSERT_FALSE( MatchPattern( nm, "?.bas", GP ) )
	END_TEST

	'' PatternWildcardAt is how Glob decides how much of a pattern is a fixed
	'' directory prefix it can walk to directly instead of enumerating from the
	'' root. It returns the offset of the FIRST wildcard, or -1 when there is
	'' nothing to expand -- so, like PathNextComponent, the sentinel is NEGATIVE
	'' and zero is a real answer.
	TEST( patternwildcardat_finds_the_first_wildcard )
		CU_ASSERT_EQUAL( PatternWildcardAt( "src\*.bas", GW ), 4 )
		CU_ASSERT_EQUAL( PatternWildcardAt( "src\main.bas", GW ), -1 )
		CU_ASSERT_EQUAL( PatternWildcardAt( "", GW ), -1 )

		'' zero is a real offset: the pattern begins with the wildcard
		CU_ASSERT_EQUAL( PatternWildcardAt( "*.bas", GW ), 0 )
		CU_ASSERT_EQUAL( PatternWildcardAt( "?x", GW ), 0 )
		CU_ASSERT_EQUAL( PatternWildcardAt( "[ab]c", GW ), 0 )

		'' FIRST, not any: whichever metacharacter comes soonest wins
		CU_ASSERT_EQUAL( PatternWildcardAt( "a?b*c", GW ), 1 )
		CU_ASSERT_EQUAL( PatternWildcardAt( "a*b?c", GW ), 1 )
		CU_ASSERT_EQUAL( PatternWildcardAt( "ab[c]*", GW ), 2 )

		'' ** is recursive but is still just a wildcard to this cursor
		CU_ASSERT_EQUAL( PatternWildcardAt( "src\**\*.bas", GW ), 4 )
		CU_ASSERT_TRUE( PatternIsRecursive( "src\**\*.bas", GW ) )

		'' the offset indexes the ORIGINAL pattern, which is what makes it
		'' usable to cut the fixed prefix off
		dim as ustring pat = "src\sub\*.bas"
		dim as integer w = PatternWildcardAt( pat, GW )
		CU_ASSERT_EQUAL( mid( pat, w + 1, 1 ), "*" )
		CU_ASSERT_EQUAL( left( pat, w ), "src\sub\" )

		'' and the prefix it cuts is always wildcard-free, which is the
		'' property Glob depends on
		for i as long = 0 to w - 1
			CU_ASSERT_EQUAL( PatternWildcardAt( left( pat, i ), GW ), -1 )
		next

		'' POSIX grammar answers on the same rules
		CU_ASSERT_EQUAL( PatternWildcardAt( "src/*.bas", GP ), 4 )
		CU_ASSERT_EQUAL( PatternWildcardAt( "src/main.bas", GP ), -1 )
	END_TEST

END_SUITE
