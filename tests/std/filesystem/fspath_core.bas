'' FB.Path* -- the pure path algebra, C:\dev\docs\filesystem\RFC-0002-path.md.
''
'' BOTH GRAMMARS ARE RUN ON BOTH PLATFORMS. Every case names its grammar
'' explicitly rather than relying on the host default, because the C kernel
'' takes the grammar as a PARAMETER precisely so that Windows path rules can be
'' checked on Linux and POSIX rules on Windows. A grammar reachable only on its
'' own host is a grammar tested on one host, and per this project's platform
'' bug-class note that is exactly where the bugs live.
''
'' The suite is table-driven and needs no filesystem at all -- that is what
'' "pure" buys, and it is why this layer can afford to assert every rule
'' individually. One TEST block per numbered rule of RFC-0002 section 3, named
'' after it, so a failure names the rule it broke.

#import "std/fs"
#import "std/outcome"
#include "fbcunit.bi"

#include once "fb/array.bi"

#include once "fberror.bi"

using fs, outcome

using FB
#define GW FB_PATH_WIN32
#define GP FB_PATH_POSIX

SUITE( fbc_tests.filesystem.fspath_core )

	'' ------------------------------------------------- section 1.2: forms
	''
	'' The eight Windows path forms. Three of these are where hand-rolled
	'' path code dies, and each has its own assertions below.

	TEST( win_root_of_each_form )
		CU_ASSERT_EQUAL( PathRoot( "C:\dev\tiko", GW ), "C:\" )
		CU_ASSERT_EQUAL( PathRoot( "C:dev\tiko", GW ), "C:" )
		CU_ASSERT_EQUAL( PathRoot( "\dev\tiko", GW ), "\" )
		CU_ASSERT_EQUAL( PathRoot( "dev\tiko", GW ), "" )
		CU_ASSERT_EQUAL( PathRoot( "\\srv\share\dev", GW ), "\\srv\share\" )
		CU_ASSERT_EQUAL( PathRoot( "\\?\C:\dev", GW ), "\\?\C:\" )
		CU_ASSERT_EQUAL( PathRoot( "\\?\UNC\srv\share\dev", GW ), "\\?\UNC\srv\share\" )
	END_TEST

	'' Drive-relative "C:dev" is NOT absolute -- it names a path relative to
	'' the per-drive current directory, a DOS survival Windows still keeps.
	'' Rooted-no-drive "\dev" is not absolute either: it is on the current
	'' drive. Treating either as absolute is a real bug with real
	'' consequences, so both are asserted here and not merely in a table.
	TEST( win_drive_relative_is_not_absolute )
		CU_ASSERT_TRUE ( PathIsAbsolute( "C:\dev", GW ) )
		CU_ASSERT_FALSE( PathIsAbsolute( "C:dev", GW ) )
		CU_ASSERT_FALSE( PathIsAbsolute( "\dev", GW ) )
		CU_ASSERT_FALSE( PathIsAbsolute( "dev", GW ) )
		CU_ASSERT_TRUE ( PathIsAbsolute( "\\srv\share\dev", GW ) )
		CU_ASSERT_TRUE ( PathIsAbsolute( "\\?\C:\dev", GW ) )

		'' and the two roots are DIFFERENT, which is the whole point
		CU_ASSERT_NOT_EQUAL( PathRoot( "C:dev", GW ), PathRoot( "C:\dev", GW ) )
	END_TEST

	TEST( posix_roots )
		CU_ASSERT_EQUAL( PathRoot( "/usr/lib", GP ), "/" )
		CU_ASSERT_EQUAL( PathRoot( "usr/lib", GP ), "" )
		CU_ASSERT_TRUE ( PathIsAbsolute( "/usr", GP ) )
		CU_ASSERT_FALSE( PathIsAbsolute( "usr", GP ) )

		'' a backslash is an ordinary character under POSIX
		CU_ASSERT_EQUAL( PathRoot( "\dev", GP ), "" )
		CU_ASSERT_EQUAL( PathFileName( "a\b", GP ), "a\b" )
	END_TEST

	TEST( is_root )
		CU_ASSERT_TRUE ( PathIsRoot( "C:\", GW ) )
		CU_ASSERT_TRUE ( PathIsRoot( "\\srv\share\", GW ) )
		CU_ASSERT_TRUE ( PathIsRoot( "/", GP ) )
		CU_ASSERT_FALSE( PathIsRoot( "C:\a", GW ) )
		CU_ASSERT_FALSE( PathIsRoot( "", GW ) )
	END_TEST

	'' ------------------------------------------- rule 1: join discards `b`
	''
	'' PathJoin( base, userInput ) is therefore a security consideration and
	'' not merely a convenience -- which is why rule 11's PathStartsWith
	'' exists and why this is asserted rather than assumed.

	TEST( rule01_join_absolute_b_wins )
		CU_ASSERT_EQUAL( PathJoin( "C:\a", "\b", GW ), "\b" )
		CU_ASSERT_EQUAL( PathJoin( "C:\a", "D:\b", GW ), "D:\b" )
		CU_ASSERT_EQUAL( PathJoin( "/a", "/b", GP ), "/b" )
	END_TEST

	TEST( rule02_join_one_separator_never_leading )
		CU_ASSERT_EQUAL( PathJoin( "C:\dev", "tiko", GW ), "C:\dev\tiko" )
		CU_ASSERT_EQUAL( PathJoin( "C:\dev\", "tiko", GW ), "C:\dev\tiko" )
		CU_ASSERT_EQUAL( PathJoin( "a", "", GW ), "a" )
		CU_ASSERT_EQUAL( PathJoin( "", "b", GW ), "b" )
		CU_ASSERT_EQUAL( PathJoin( "", "", GW ), "" )
		CU_ASSERT_EQUAL( PathJoin( "a", "b", GP ), "a/b" )

		'' three- and four-argument folds
		CU_ASSERT_EQUAL( PathJoin( "C:\dev", "tiko", "src", GW ), "C:\dev\tiko\src" )
		CU_ASSERT_EQUAL( PathJoin( "C:\dev", "tiko", "src", "x.bas", GW ), "C:\dev\tiko\src\x.bas" )
	END_TEST

	'' Join does NOT normalize. A join that quietly resolved '..' would be
	'' resolving it without knowing whether the previous component is a
	'' symlink -- the exact mistake the lexical/canonical split exists for.
	TEST( rule03_join_does_not_normalize )
		CU_ASSERT_EQUAL( PathJoin( "a/b", "..", GP ), "a/b/.." )
		CU_ASSERT_EQUAL( PathJoin( "a", ".", GP ), "a/." )
	END_TEST

	TEST( rule04_normalize )
		CU_ASSERT_EQUAL( PathNormalize( "C:\a\.\b\..\c\", GW ), "C:\a\c" )
		CU_ASSERT_EQUAL( PathNormalize( "C:\", GW ), "C:\" )
		CU_ASSERT_EQUAL( PathNormalize( "", GW ), "." )
		CU_ASSERT_EQUAL( PathNormalize( "/", GP ), "/" )
		CU_ASSERT_EQUAL( PathNormalize( "a//b///c", GP ), "a/b/c" )
		CU_ASSERT_EQUAL( PathNormalize( "a/b/", GP ), "a/b" )
		CU_ASSERT_EQUAL( PathNormalize( ".", GP ), "." )

		'' separators unify under the Windows grammar
		CU_ASSERT_EQUAL( PathNormalize( "C:/a/b", GW ), "C:\a\b" )
	END_TEST

	'' '..' clamps at a root and never escapes it. For a RELATIVE path there
	'' is no root to clamp to, so leading '..' survive.
	TEST( rule05_dotdot_clamps_at_root )
		CU_ASSERT_EQUAL( PathNormalize( "/a/../..", GP ), "/" )
		CU_ASSERT_EQUAL( PathNormalize( "C:\a\..\..\..", GW ), "C:\" )
		CU_ASSERT_EQUAL( PathNormalize( "\\srv\share\..\..", GW ), "\\srv\share\" )
		CU_ASSERT_EQUAL( PathNormalize( "a/../../b", GP ), "../b" )
		CU_ASSERT_EQUAL( PathNormalize( "../a", GP ), "../a" )
	END_TEST

	'' Under \\?\ the OS does no parsing at all: '.' and '..' are ORDINARY
	'' NAMES and '/' is not a separator. Collapsing them would change which
	'' file is named, so normalization must leave the interior alone.
	TEST( rule05_device_path_interior_untouched )
		CU_ASSERT_EQUAL( PathNormalize( "\\?\C:\a\..\b", GW ), "\\?\C:\a\..\b" )
		CU_ASSERT_EQUAL( PathNormalize( "\\?\C:\a\.\b", GW ), "\\?\C:\a\.\b" )
	END_TEST

	TEST( rule06_parent )
		CU_ASSERT_EQUAL( PathParent( "C:\a\b\", GW ), "C:\a" )
		CU_ASSERT_EQUAL( PathParent( "C:\a\b", GW ), "C:\a" )
		CU_ASSERT_EQUAL( PathParent( "C:\a", GW ), "C:\" )
		CU_ASSERT_EQUAL( PathParent( "C:\", GW ), "" )         '' parent of a root
		CU_ASSERT_EQUAL( PathParent( "a", GP ), "" )           '' single component
		CU_ASSERT_EQUAL( PathParent( "/a", GP ), "/" )
		CU_ASSERT_EQUAL( PathParent( "/a/b", GP ), "/a" )
		CU_ASSERT_EQUAL( PathParent( "a/b", GP ), "a" )
	END_TEST

	TEST( rule07_filename )
		CU_ASSERT_EQUAL( PathFileName( "C:\a\b.bas", GW ), "b.bas" )
		CU_ASSERT_EQUAL( PathFileName( "C:\a\b\", GW ), "b" )
		CU_ASSERT_EQUAL( PathFileName( "C:\", GW ), "" )
		CU_ASSERT_EQUAL( PathFileName( "/", GP ), "" )
		CU_ASSERT_EQUAL( PathFileName( "b.bas", GP ), "b.bas" )
	END_TEST

	'' The extension is the FINAL '.' in the FILE NAME, and only when that
	'' dot is neither first nor last. A dotfile is a name, not an extension.
	TEST( rule08_extension_and_stem )
		CU_ASSERT_EQUAL( PathExtension( "a.bas", GP ), ".bas" )
		CU_ASSERT_EQUAL( PathExtension( ".gitignore", GP ), "" )
		CU_ASSERT_EQUAL( PathExtension( "a.", GP ), "" )
		CU_ASSERT_EQUAL( PathExtension( "a.b.c", GP ), ".c" )
		CU_ASSERT_EQUAL( PathExtension( "C:\a.b\c", GW ), "" )
		CU_ASSERT_EQUAL( PathExtension( "", GP ), "" )
		CU_ASSERT_EQUAL( PathExtension( ".", GP ), "" )
		CU_ASSERT_EQUAL( PathExtension( "..", GP ), "" )

		CU_ASSERT_EQUAL( PathStem( "a.bas", GP ), "a" )
		CU_ASSERT_EQUAL( PathStem( ".gitignore", GP ), ".gitignore" )
		CU_ASSERT_EQUAL( PathStem( "a.", GP ), "a." )
		CU_ASSERT_EQUAL( PathStem( "a.b.c", GP ), "a.b" )
		CU_ASSERT_EQUAL( PathStem( "C:\a\b.bas", GW ), "b" )

		CU_ASSERT_TRUE ( PathHasExtension( "a.bas", GP ) )
		CU_ASSERT_FALSE( PathHasExtension( ".gitignore", GP ) )
	END_TEST

	TEST( rule09_change_extension )
		CU_ASSERT_EQUAL( PathChangeExtension( "a.bas", ".o", GP ), "a.o" )
		CU_ASSERT_EQUAL( PathChangeExtension( "a.bas", "o", GP ), "a.o" )
		CU_ASSERT_EQUAL( PathChangeExtension( "a.bas", "", GP ), "a" )
		CU_ASSERT_EQUAL( PathChangeExtension( "a", ".o", GP ), "a.o" )
		CU_ASSERT_EQUAL( PathChangeExtension( ".gitignore", ".o", GP ), ".gitignore.o" )
		CU_ASSERT_EQUAL( PathChangeExtension( "C:\a\b.bas", ".o", GW ), "C:\a\b.o" )
	END_TEST

	'' Case-insensitive under the Windows grammar, byte-wise under POSIX,
	'' with '\' and '/' unified on Windows. Asserted under BOTH grammars on
	'' whatever host this is running on.
	TEST( rule10_equals_case_and_separators )
		CU_ASSERT_TRUE ( PathEquals( "C:\A", "c:\a", GW ) )
		CU_ASSERT_FALSE( PathEquals( "/A", "/a", GP ) )
		CU_ASSERT_TRUE ( PathEquals( "C:/a/b", "C:\a\b", GW ) )
		CU_ASSERT_TRUE ( PathEquals( "C:\a\.\b", "C:\a\b", GW ) )
		CU_ASSERT_TRUE ( PathEquals( "a/b/", "a/b", GP ) )
		CU_ASSERT_FALSE( PathEquals( "a/b", "a/c", GP ) )
	END_TEST

	'' Whole components. "C:\abc" does not start with "C:\ab" -- anything
	'' else makes this useless for the containment check rule 1 sends
	'' callers here for.
	TEST( rule11_startswith_component_boundary )
		CU_ASSERT_FALSE( PathStartsWith( "C:\abc", "C:\ab", GW ) )
		CU_ASSERT_TRUE ( PathStartsWith( "C:\a\b", "C:\a", GW ) )
		CU_ASSERT_TRUE ( PathStartsWith( "C:\a\b", "C:\a\", GW ) )
		CU_ASSERT_TRUE ( PathStartsWith( "C:\a", "C:\a", GW ) )
		CU_ASSERT_TRUE ( PathStartsWith( "C:\a\b", "C:\", GW ) )
		CU_ASSERT_FALSE( PathStartsWith( "C:\a", "C:\a\b", GW ) )
		CU_ASSERT_TRUE ( PathStartsWith( "/a/b", "/a", GP ) )
		CU_ASSERT_FALSE( PathStartsWith( "/abc", "/ab", GP ) )
	END_TEST

	'' The round trip is normative: PathRoot joined with the components of
	'' PathSplit reconstructs PathNormalize exactly.
	TEST( rule12_split_root_roundtrip )
		dim as Array( of ustring ) comps
		dim as long n
		dim as ustring rebuilt, i

		n = PathSplit( "C:\dev\tiko\src", comps, GW )
		CU_ASSERT_EQUAL( n, 3 )
		CU_ASSERT_EQUAL( comps[0], "dev" )
		CU_ASSERT_EQUAL( comps[1], "tiko" )
		CU_ASSERT_EQUAL( comps[2], "src" )

		'' the root is NOT a component
		n = PathSplit( "C:\", comps, GW )
		CU_ASSERT_EQUAL( n, 0 )

		'' round trip over a normalised path
		dim as ustring src = "C:\a\.\b\..\c"
		n = PathSplit( src, comps, GW )
		rebuilt = PathRoot( src, GW )
		for k as long = 0 to n - 1
			rebuilt = PathJoin( rebuilt, comps[k], GW )
		next
		CU_ASSERT_EQUAL( rebuilt, PathNormalize( src, GW ) )

		'' and a relative one
		n = PathSplit( "a/b/c", comps, GP )
		CU_ASSERT_EQUAL( n, 3 )
		CU_ASSERT_EQUAL( comps[2], "c" )
	END_TEST

	'' There IS no relative path between C:\a and D:\b, and returning
	'' "..\..\D:\b" would be a fabrication.
	TEST( rule13_relativeto_different_roots_fail )
		dim as FsResultUStr r

		r = PathRelativeTo( "C:\a", "D:\b", GW )
		CU_ASSERT_FALSE( r.IsOk( ) )
		CU_ASSERT_EQUAL( r.Failure( ).Code( ), FS_INVALID_PATH )

		r = PathRelativeTo( "C:\a", "a\b", GW )
		CU_ASSERT_FALSE( r.IsOk( ) )

		r = PathRelativeTo( "/a", "a/b", GP )
		CU_ASSERT_FALSE( r.IsOk( ) )
	END_TEST

	TEST( rule13_relativeto_success )
		dim as FsResultUStr r

		r = PathRelativeTo( "C:\a\b\c", "C:\a", GW )
		CU_ASSERT_TRUE( r.IsOk( ) )
		CU_ASSERT_EQUAL( r.Value( ), "b\c" )

		'' identity is "."
		r = PathRelativeTo( "C:\a", "C:\a", GW )
		CU_ASSERT_TRUE( r.IsOk( ) )
		CU_ASSERT_EQUAL( r.Value( ), "." )

		'' three levels up
		r = PathRelativeTo( "/a/x", "/a/b/c/d", GP )
		CU_ASSERT_TRUE( r.IsOk( ) )
		CU_ASSERT_EQUAL( r.Value( ), "../../../x" )

		'' pure ascent, no descent
		r = PathRelativeTo( "/a", "/a/b", GP )
		CU_ASSERT_TRUE( r.IsOk( ) )
		CU_ASSERT_EQUAL( r.Value( ), ".." )
	END_TEST

	'' ------------------------------------------------------------- extras

	TEST( to_native_collapses_but_does_not_resolve )
		CU_ASSERT_EQUAL( PathToNative( "C:/a//b", GW ), "C:\a\b" )
		CU_ASSERT_EQUAL( PathToNative( "C:/a/../b", GW ), "C:\a\..\b" )
		CU_ASSERT_EQUAL( PathToNative( "a//b", GP ), "a/b" )

		'' the doubled separator in a UNC root is MEANINGFUL and survives
		CU_ASSERT_EQUAL( PathToNative( "\\srv\share\a", GW ), "\\srv\share\a" )
	END_TEST

	TEST( separator_and_case_sensitivity )
		CU_ASSERT_EQUAL( PathSeparator( GW ), "\" )
		CU_ASSERT_EQUAL( PathSeparator( GP ), "/" )
		CU_ASSERT_FALSE( PathIsCaseSensitive( GW ) )
		CU_ASSERT_TRUE ( PathIsCaseSensitive( GP ) )
	END_TEST

	'' The STRING and WSTRING overloads must agree with the USTRING kernel.
	'' ZSTRING is served by the STRING overload through fbc's own implicit
	'' conversion, so a zstring case is included specifically to prove that
	'' conversion picks the right overload -- the thing a three-overload set
	'' could plausibly get wrong.
	TEST( overload_families_agree )
		'' Single-letter locals are avoided throughout this file: FreeBASIC
		'' identifiers are case-insensitive, so a local `w` IS the `GW` macro
		'' if that macro is called `W`, and the expansion is silent.
		dim as string       ss = "C:\dev\tiko\frmMain.bas"
		dim as wstring * 64 ww = "C:\dev\tiko\frmMain.bas"
		dim as ustring      uu = "C:\dev\tiko\frmMain.bas"
		dim as zstring * 64 zz = "C:\dev\tiko\frmMain.bas"

		CU_ASSERT_EQUAL( PathExtension( ss, GW ), ".bas" )
		CU_ASSERT_EQUAL( PathExtension( ww, GW ), ".bas" )
		CU_ASSERT_EQUAL( PathExtension( uu, GW ), ".bas" )
		CU_ASSERT_EQUAL( PathExtension( zz, GW ), ".bas" )

		CU_ASSERT_EQUAL( PathFileName( ss, GW ), "frmMain.bas" )
		CU_ASSERT_EQUAL( PathFileName( ww, GW ), "frmMain.bas" )
		CU_ASSERT_EQUAL( PathStem( ss, GW ), "frmMain" )
		CU_ASSERT_EQUAL( PathParent( ss, GW ), "C:\dev\tiko" )
	END_TEST

	'' Non-ASCII must survive the kernel untouched. This is the property the
	'' whole USTRING-as-kernel decision exists to protect.
	TEST( non_ascii_survives )
		'' e-acute, a-grave, and two CJK ideographs -- built with wchr so the
		'' source file's own encoding cannot affect what is being asserted.
		dim as ustring nm = wchr( &h00E9 ) + wchr( &h00E0 ) + wchr( &h4E2D ) + wchr( &h6587 )
		dim as ustring pp = PathJoin( PathJoin( "C:\dev", nm, GW ), "x.bas", GW )

		CU_ASSERT_EQUAL( PathExtension( pp, GW ), ".bas" )
		CU_ASSERT_EQUAL( PathFileName( pp, GW ), "x.bas" )
		CU_ASSERT_EQUAL( PathParent( pp, GW ), "C:\dev\" + nm )
		CU_ASSERT_EQUAL( PathNormalize( pp, GW ), pp )
	END_TEST

	'' A long path must not be truncated or overflow the sizing logic.
	TEST( long_path_no_truncation )
		dim as ustring p = "C:"
		for i as long = 1 to 300
			p = PathJoin( p, "component", GW )
		next
		CU_ASSERT_EQUAL( PathFileName( p, GW ), "component" )
		CU_ASSERT_EQUAL( PathNormalize( p, GW ), p )
		CU_ASSERT_EQUAL( len( PathNormalize( p + "\a\..", GW ) ), len( p ) )
	END_TEST

	'' ------------------------------------------------- the two raw cursors

	'' PathRootLen is the length IN CODE UNITS of the root, so it can index the
	'' original string directly. Zero for a relative path.
	TEST( pathrootlen_indexes_the_original )
		CU_ASSERT_EQUAL( PathRootLen( "C:\dev\src", GW ), 3 )
		CU_ASSERT_EQUAL( PathRootLen( "C:\", GW ), 3 )
		CU_ASSERT_EQUAL( PathRootLen( "relative", GW ), 0 )
		CU_ASSERT_EQUAL( PathRootLen( "", GW ), 0 )

		'' drive-relative "C:foo" has a two-unit root and is NOT absolute
		CU_ASSERT_EQUAL( PathRootLen( "C:foo", GW ), 2 )
		CU_ASSERT_FALSE( PathIsAbsolute( "C:foo", GW ) )

		'' rooted-no-drive
		CU_ASSERT_EQUAL( PathRootLen( "\foo", GW ), 1 )

		'' UNC: the root runs to the end of the share
		CU_ASSERT_EQUAL( PathRootLen( "\\srv\share\a", GW ), len( "\\srv\share\" ) )

		'' POSIX
		CU_ASSERT_EQUAL( PathRootLen( "/usr/bin", GP ), 1 )
		CU_ASSERT_EQUAL( PathRootLen( "usr/bin", GP ), 0 )
		CU_ASSERT_EQUAL( PathRootLen( "/", GP ), 1 )

		'' it indexes: everything past the root is the relative remainder, and
		'' PathIsRoot agrees with a length that covers the whole string
		dim as ustring p = "C:\dev\src"
		CU_ASSERT_EQUAL( mid( p, PathRootLen( p, GW ) + 1 ), "dev\src" )
		CU_ASSERT_TRUE( PathIsRoot( left( p, PathRootLen( p, GW ) ), GW ) )

		'' and it agrees with PathRoot, which is the allocating spelling
		CU_ASSERT_EQUAL( left( p, PathRootLen( p, GW ) ), PathRoot( p, GW ) )
	END_TEST

	'' PathNextComponent is the cursor PathSplit is built on, so the C side
	'' never allocates. THE TERMINATOR IS A NEGATIVE RETURN, not zero -- zero is
	'' a perfectly good offset and a loop that tests for it never ends.
	TEST( pathnextcomponent_walks_components_only )
		dim as ustring p = "C:\dev\src"
		dim as integer at = 0, clen = 0, start_
		dim as Array( of ustring ) got

		do
			start_ = PathNextComponent( p, GW, at, clen )
			if( start_ < 0 ) then exit do
			got.Push( mid( p, start_ + 1, clen ) )
			at = start_ + clen
		loop

		'' the ROOT IS NOT A COMPONENT, exactly as for PathSplit
		CU_ASSERT_EQUAL( got.Count( ), 2 )
		CU_ASSERT_EQUAL( got[0], "dev" )
		CU_ASSERT_EQUAL( got[1], "src" )

		'' every component it yields is non-empty, which is what makes the
		'' cursor safe to drive with `at = start + clen`
		for i as long = 0 to got.Count( ) - 1
			CU_ASSERT_TRUE( len( got[i] ) > 0 )
		next

		'' a root-only path has no components at all
		clen = 0
		CU_ASSERT_TRUE( PathNextComponent( "C:\", GW, 0, clen ) < 0 )
		CU_ASSERT_TRUE( PathNextComponent( "/", GP, 0, clen ) < 0 )
		CU_ASSERT_TRUE( PathNextComponent( "", GW, 0, clen ) < 0 )

		'' a relative path starts at offset zero -- the case that makes
		'' testing for zero as "exhausted" wrong
		dim as integer s0 = PathNextComponent( "dev\src", GW, 0, clen )
		CU_ASSERT_EQUAL( s0, 0 )
		CU_ASSERT_EQUAL( clen, 3 )

		'' it agrees with PathSplit on the same input, on both grammars
		dim as Array( of ustring ) parts
		PathSplit( p, parts, GW )
		CU_ASSERT_EQUAL( parts.Count( ), got.Count( ) )
		for i as long = 0 to parts.Count( ) - 1
			CU_ASSERT_EQUAL( parts[i], got[i] )
		next

		dim as ustring q = "/usr/local/bin"
		dim as Array( of ustring ) uparts, ugot
		PathSplit( q, uparts, GP )
		at = 0 : clen = 0
		do
			start_ = PathNextComponent( q, GP, at, clen )
			if( start_ < 0 ) then exit do
			ugot.Push( mid( q, start_ + 1, clen ) )
			at = start_ + clen
		loop
		CU_ASSERT_EQUAL( ugot.Count( ), uparts.Count( ) )
		for i as long = 0 to uparts.Count( ) - 1
			CU_ASSERT_EQUAL( uparts[i], ugot[i] )
		next

		'' starting past the end is exhausted, not an error
		CU_ASSERT_TRUE( PathNextComponent( p, GW, len( p ), clen ) < 0 )
		CU_ASSERT_TRUE( PathNextComponent( p, GW, len( p ) + 100, clen ) < 0 )
	END_TEST

END_SUITE
