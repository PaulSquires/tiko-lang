'' fspath-parity.bas -- pure path algebra: sixteen entry points, BOTH grammars.
''
'' NEEDS-GEN-LLVM
''
'' EVERY CASE IS RUN UNDER BOTH FB_PATH_POSIX AND FB_PATH_WIN32 ON THIS HOST.
'' The grammar is a parameter rather than an #ifdef, so Windows path rules are
'' testable on Linux and POSIX rules on Windows -- which is the only way the
'' win32 half of this file gets exercised by the Linux gate at all.
''
'' THE DISTINCTIONS THAT PRODUCE A PLAUSIBLE WRONG ANSWER:
''   - "C:\" root 3 vs "C:" root 2: that is drive-absolute vs drive-RELATIVE
''   - "\foo" is rooted but NOT absolute
''   - "\?\..." is copied verbatim; '.' and '..' inside it are ordinary names
''   - ".gitignore" has NO extension; "a." has none either
''   - ".." past the top of a RELATIVE path is kept; past an absolute root it
''     is dropped
''   - StartsWith compares WHOLE COMPONENTS: "C:\abc" does not start with "C:\ab"
''   - Relative across different roots FAILS rather than fabricating a path
#include once "fbc-int/string.bi"

extern "rtlib"
	declare function pRootLen alias "fb_UStrPathRootLen" ( byval p as FBC.FBUSTRING ptr, byval g as long ) as integer
	declare function pIsAbs alias "fb_UStrPathIsAbsolute" ( byval p as FBC.FBUSTRING ptr, byval g as long ) as long
	declare function pIsRoot alias "fb_UStrPathIsRoot" ( byval p as FBC.FBUSTRING ptr, byval g as long ) as long
	declare function pRoot alias "fb_UStrPathRoot" ( byval p as FBC.FBUSTRING ptr, byval g as long ) as FBC.FBUSTRING ptr
	declare function pParent alias "fb_UStrPathParent" ( byval p as FBC.FBUSTRING ptr, byval g as long ) as FBC.FBUSTRING ptr
	declare function pFileName alias "fb_UStrPathFileName" ( byval p as FBC.FBUSTRING ptr, byval g as long ) as FBC.FBUSTRING ptr
	declare function pExt alias "fb_UStrPathExtension" ( byval p as FBC.FBUSTRING ptr, byval g as long ) as FBC.FBUSTRING ptr
	declare function pStem alias "fb_UStrPathStem" ( byval p as FBC.FBUSTRING ptr, byval g as long ) as FBC.FBUSTRING ptr
	declare function pNorm alias "fb_UStrPathNormalize" ( byval p as FBC.FBUSTRING ptr, byval g as long ) as FBC.FBUSTRING ptr
	declare function pNative alias "fb_UStrPathToNative" ( byval p as FBC.FBUSTRING ptr, byval g as long ) as FBC.FBUSTRING ptr
	declare function pJoin alias "fb_UStrPathJoin2" ( byval a as FBC.FBUSTRING ptr, byval b as FBC.FBUSTRING ptr, byval g as long ) as FBC.FBUSTRING ptr
	declare function pChgExt alias "fb_UStrPathChangeExt" ( byval p as FBC.FBUSTRING ptr, byval e as FBC.FBUSTRING ptr, byval g as long ) as FBC.FBUSTRING ptr
	declare function pEquals alias "fb_UStrPathEquals" ( byval a as FBC.FBUSTRING ptr, byval b as FBC.FBUSTRING ptr, byval g as long ) as long
	declare function pStarts alias "fb_UStrPathStartsWith" ( byval p as FBC.FBUSTRING ptr, byval pre as FBC.FBUSTRING ptr, byval g as long ) as long
	declare function pRel alias "fb_UStrPathRelative" ( byval p as FBC.FBUSTRING ptr, byval b as FBC.FBUSTRING ptr, byval g as long, byval st as long ptr ) as FBC.FBUSTRING ptr
	declare function pDelTemp alias "fb_hUStrDelTemp" ( byval s as FBC.FBUSTRING ptr ) as long
	declare function pNextComp alias "fb_UStrPathNextComp" ( byval p as FBC.FBUSTRING ptr, byval g as long, byval f as integer, byval ol as integer ptr ) as integer
end extern

'' The descriptors are built from FB ustrings, whose layout IS FBUSTRING.
dim shared as ustring ua, ub
'' A comma-expression macro is not FreeBASIC; these are functions. Each keeps
'' its own shared USTRING alive, because a temp descriptor would be freed
'' before the entry point under test ever read it.
function MKU( byref s as string ) as FBC.FBUSTRING ptr
	ua = s
	return cast( FBC.FBUSTRING ptr, @ua )
end function

'' EVERY RETURNED DESCRIPTOR IS A TEMP AND IS FREED HERE.
''
'' Without the delete this test passed 52/52 while measuring nothing for half
'' its cases. The temp pool is 256 descriptors; the POSIX pass consumed all of
'' them, and every allocation in the WIN32 pass then returned the null
'' descriptor. Both runtimes did it identically, so the differential compared
'' equal and reported success -- with every Windows-grammar answer blank.
''
'' fb_hUStrDelTemp is a no-op on a descriptor without the temp bit, so the
'' shared unull_desc passes through it safely.
function shows( byval du as FBC.FBUSTRING ptr ) as string
	if( du = 0 ) then return "<null>"
	dim as string o = ""
	dim as integer n = du->len and (not (cast(integer,1) shl (sizeof(integer)*8-1)))
	dim as integer i = any
	if( du->data = 0 ) then
		pDelTemp( du )
		return "<nodata>"
	end if
	for i = 0 to n - 1
		o += chr( du->data[i] and 255 )
	next
	pDelTemp( du )
	return "'" & o & "'"
end function

dim shared as string ps(0 to 47)
sub init_ps( )
	ps( 0) = ""              : ps( 1) = "."            : ps( 2) = ".."
	ps( 3) = "/"             : ps( 4) = "\"            : ps( 5) = "C:"
	ps( 6) = "C:\"           : ps( 7) = "C:/"          : ps( 8) = "C:foo"
	ps( 9) = "C:\foo"        : ps(10) = "\foo"         : ps(11) = "/foo"
	ps(12) = "foo"           : ps(13) = "foo/bar"      : ps(14) = "foo\bar"
	ps(15) = "\srv\share"   : ps(16) = "\srv\share\" : ps(17) = "\srv\share\d\f"
	ps(18) = "\srv"         : ps(19) = "\\"           : ps(20) = "\?\C:\x"
	ps(21) = "\?\UNC\s\h\x" : ps(22) = "\.\PhysicalDrive0"
	ps(23) = "\?\C:\a\..\b" : ps(24) = "a/./b"        : ps(25) = "a/../b"
	ps(26) = "a/b/../.."     : ps(27) = "a/b/../../.." : ps(28) = "/a/b/../../.."
	ps(29) = "C:\a\b\..\..\..": ps(30) = "a//b///c"    : ps(31) = "a/b/"
	ps(32) = "a/b//"         : ps(33) = ".gitignore"   : ps(34) = "a."
	ps(35) = "a.txt"         : ps(36) = "a.tar.gz"     : ps(37) = "dir.d/file"
	ps(38) = "dir.d/file.x"  : ps(39) = "/a/.hidden"   : ps(40) = "C:\dir\.x"
	ps(41) = "..\..\a"       : ps(42) = "./"           : ps(43) = "/."
	ps(44) = "C:\."          : ps(45) = "  spaced  "   : ps(46) = "a/b/c/d/e"
	ps(47) = "\srv\share\a\b"
end sub
init_ps( )

dim as long i = any, g = any, st = any
dim as integer from_ = any, clen = any, at_ = any

for g = 0 to 1
	print "===== grammar "; g; " ====="
	for i = 0 to 47
		dim as string s = ps(i)
		print "'"; s; "'";
		print " rl="; pRootLen( MKU( s ), g );
		print " abs="; pIsAbs( MKU( s ), g );
		print " isroot="; pIsRoot( MKU( s ), g )
		print "    root="; shows( pRoot( MKU( s ), g ) );
		print " parent="; shows( pParent( MKU( s ), g ) );
		print " name="; shows( pFileName( MKU( s ), g ) )
		print "    ext="; shows( pExt( MKU( s ), g ) );
		print " stem="; shows( pStem( MKU( s ), g ) );
		print " norm="; shows( pNorm( MKU( s ), g ) );
		print " native="; shows( pNative( MKU( s ), g ) )
	next
next

'' Two-argument forms need two live descriptors, so they use ua and ub
'' separately rather than the single-slot U() macro.
function MKA( byref s as string ) as FBC.FBUSTRING ptr
	ua = s
	return cast( FBC.FBUSTRING ptr, @ua )
end function
function MKB( byref s as string ) as FBC.FBUSTRING ptr
	ub = s
	return cast( FBC.FBUSTRING ptr, @ub )
end function

dim shared as string qa(0 to 23), qb(0 to 23)
sub init_q( )
	qa( 0) = "a"          : qb( 0) = "b"
	qa( 1) = "a/"         : qb( 1) = "b"
	qa( 2) = "a"          : qb( 2) = "/b"
	qa( 3) = "a"          : qb( 3) = "C:\b"
	qa( 4) = "a"          : qb( 4) = "C:b"
	qa( 5) = ""           : qb( 5) = "b"
	qa( 6) = "a"          : qb( 6) = ""
	qa( 7) = ""           : qb( 7) = ""
	qa( 8) = "C:\x"       : qb( 8) = "C:\x\y"
	qa( 9) = "C:\x"       : qb( 9) = "C:\X"
	qa(10) = "C:\ab"      : qb(10) = "C:\abc"
	qa(11) = "C:\abc"     : qb(11) = "C:\ab"
	qa(12) = "C:\a\b"     : qb(12) = "C:\a"
	qa(13) = "C:\a"       : qb(13) = "D:\a"
	qa(14) = "/a/b/c"     : qb(14) = "/a"
	qa(15) = "/a"         : qb(15) = "/a/b/c"
	qa(16) = "/a/b"       : qb(16) = "/a/b"
	qa(17) = "a/b"        : qb(17) = "a"
	qa(18) = "a"          : qb(18) = "b"
	qa(19) = "/a/b"       : qb(19) = "c/d"
	qa(20) = "\s\h\a"    : qb(20) = "\s\h"
	qa(21) = "\s\h"      : qb(21) = "\t\h"
	qa(22) = "C:\a\b\c"   : qb(22) = "C:\a\x\y"
	qa(23) = "C:\"        : qb(23) = "C:\a"
end sub
init_q( )

for g = 0 to 1
	print "===== two-arg, grammar "; g; " ====="
	for i = 0 to 23
		print "'"; qa(i); "' + '"; qb(i); "'";
		print " join="; shows( pJoin( MKA( qa(i) ), MKB( qb(i) ), g ) );
		print " eq="; pEquals( MKA( qa(i) ), MKB( qb(i) ), g );
		print " starts="; pStarts( MKA( qa(i) ), MKB( qb(i) ), g );
		st = -1
		print " rel="; shows( pRel( MKA( qa(i) ), MKB( qb(i) ), g, @st ) ); " st="; st
	next
next

print "-- ChangeExt: with and without the dot, and removal"
dim shared as string exts(0 to 5)
exts(0) = ".x" : exts(1) = "x" : exts(2) = "" : exts(3) = ".tar.gz" : exts(4) = "." : exts(5) = "xyz"
for g = 0 to 1
	for i = 33 to 40
		dim as long k = any
		for k = 0 to 5
			print "g"; g; " '"; ps(i); "' + '"; exts(k); "' = "; _
			      shows( pChgExt( MKA( ps(i) ), MKB( exts(k) ), g ) )
		next
	next
next

print "-- NextComp iteration, both grammars"
for g = 0 to 1
	for i = 0 to 47
		dim as string s = ps(i)
		print "g"; g; " '"; s; "':";
		from_ = 0
		dim as long guard = 0
		do
			at_ = pNextComp( MKU( s ), g, from_, @clen )
			if( at_ < 0 ) then exit do
			print " ("; at_; ","; clen; ")";
			from_ = at_ + clen
			guard += 1
			if( guard > 20 ) then print " RUNAWAY"; : exit do
		loop
		print
	next
next
print "-- NULL descriptors"
print "rl="; pRootLen( 0, 0 ); " abs="; pIsAbs( 0, 0 ); " root="; shows( pRoot( 0, 0 ) );
print " join="; shows( pJoin( 0, 0, 0 ) ); " eq="; pEquals( 0, 0, 0 )
st = -1
print "rel="; shows( pRel( 0, 0, 0, @st ) ); " st="; st
print "nextcomp="; pNextComp( 0, 0, 0, 0 )
print "done"
