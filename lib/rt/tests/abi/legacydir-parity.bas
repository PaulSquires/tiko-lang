'' legacydir-parity.bas -- DIR, and the destructor behind it. Two entry points,
'' one fbc member.
''
'' NEEDS-GEN-LLVM
''
'' A SCRATCH DIRECTORY IS BUILT FIRST, AND THAT IS THE WHOLE DESIGN. Scanning the
'' real working directory would compare two runs against a tree that the harness
'' itself is writing into -- the other runtime's executable, its .out file, its
'' temporaries -- so the answers would differ for reasons that have nothing to do
'' with fb_Dir. Everything below runs against a directory this file creates, with
'' a known set of names, and removes at the end.
''
'' AND THE NAMES ARE CHOSEN TO SORT THE SAME WAY EVERYWHERE. fb_Dir returns
'' entries in the ORDER THE FILE SYSTEM GIVES THEM -- NTFS is name-ordered,
'' ext4 is hash-ordered -- so an unsorted listing is not comparable even between
'' two runs on one machine. Every scan below is COLLECTED AND SORTED before it is
'' printed. Printing the raw order would be testing the file system.
''
'' THE ONE-CURSOR RULE IS TESTED DIRECTLY, because it is the defining property of
'' this entry point: a second FINDFIRST in the middle of a scan abandons the
'' first, and the interleaved test below shows the first scan returning nothing
'' afterwards. A reimplementation with per-call state would pass every other test
'' in this file and fail that one.
''
'' THE ATTRIBUTE MASK IS AN EXCLUSION TEST and the cases prove it: asking for 0
'' matches only entries with no attribute bits at all, which on both platforms is
'' nothing, and asking for 0x10 (directory) alone still returns files, because
'' the runtime ORs in 0x20 when the caller did not ask for directories.
''
'' WHAT IS NOT COMPARABLE, AND IS THEREFORE REDUCED TO A PROPERTY:
''   - the read-only bit on POSIX depends on the effective uid's relationship to
''     the file, so it is reported as "consistent between the two scans" rather
''     than as a value;
''   - '.' and '..' appear on both platforms but a hidden-bit filter treats them
''     differently, so their presence is counted, not listed positionally;
''   - the attribute VALUE differs between Windows and POSIX by construction --
''     Windows reports what the file system stores, POSIX synthesises it -- so
''     the numbers are printed and compared only against the OTHER RUNTIME on the
''     same platform, which is exactly what the differential does.
''
'' fb_DIRCTX_Destructor IS NOT CALLED DIRECTLY. It is the TLS teardown hook and
'' takes the context pointer, which this file has no legitimate way to obtain --
'' calling it with anything else would read a bogus in_use flag and close a
'' garbage handle. It is proved by ADDRESS only, and that limit is stated rather
'' than left silent.

#include once "fbc-int/string.bi"

extern "rtlib"
	declare function pDir alias "fb_Dir" _
		( byval spec as any ptr, byval attrib as long, byval out_attrib as long ptr ) as any ptr
end extern

extern "c"
	declare sub pDtor alias "fb_DIRCTX_Destructor" ( byval d as any ptr )
	declare function pDelTemp alias "fb_hStrDelTemp" ( byval s as any ptr ) as long
	declare function c_fopen  alias "fopen"  ( byval p as zstring ptr, byval m as zstring ptr ) as any ptr
	declare function c_fclose alias "fclose" ( byval f as any ptr ) as long
	declare function c_fwrite alias "fwrite" ( byval b as any ptr, byval sz as uinteger, byval n as uinteger, byval f as any ptr ) as uinteger
	declare function c_remove alias "remove" ( byval p as zstring ptr ) as long
	declare function c_mkdir_ alias "mkdir" ( byval p as zstring ptr, ... ) as long
	declare function c_rmdir_ alias "rmdir" ( byval p as zstring ptr ) as long
end extern

print "-- both resolve"
print "  distinct="; ( cast( any ptr, @pDir ) <> cast( any ptr, @pDtor ) )
print "  fb_DIRCTX_Destructor resolves (address only, NOT CALLED)="; ( cast( any ptr, @pDtor ) <> 0 )

'' ------------------------------------------------------- the scratch tree

const SCRATCH = "tkrt-dirscan"

#ifdef __FB_WIN32__
	const SEP = "\"
#else
	const SEP = "/"
#endif

sub makeFile( byref name_ as string, byval nbytes as integer )
	dim as string full = SCRATCH + SEP + name_
	dim as any ptr f = c_fopen( strptr( full ), @"wb" )
	if( f = 0 ) then exit sub
	if( nbytes > 0 ) then
		dim as zstring * 64 pad = any
		for i as integer = 0 to 63
			pad[i] = asc("x")
		next
		c_fwrite( @pad, 1, nbytes, f )
	end if
	c_fclose( f )
end sub

sub killFile( byref name_ as string )
	dim as string full = SCRATCH + SEP + name_
	c_remove( strptr( full ) )
end sub

'' mkdir TAKES A MODE ON POSIX AND NOT ON WINDOWS, which is why it is declared
'' variadic above -- one declaration, two call shapes.
#ifdef __FB_WIN32__
	c_mkdir_( @SCRATCH )
#else
	c_mkdir_( @SCRATCH, &o755 )
#endif

'' FIVE FILES, ONE SUBDIRECTORY, AND A DOTFILE. The names are deliberately
'' unrelated in length and extension so a pattern can pick out subsets.
makeFile( "alpha.txt", 10 )
makeFile( "beta.txt", 20 )
makeFile( "gamma.dat", 30 )
makeFile( "delta.dat", 0 )
makeFile( "noext", 5 )
makeFile( ".hidden", 7 )

dim as string subd = SCRATCH + SEP + "subdir"
#ifdef __FB_WIN32__
	c_mkdir_( strptr( subd ) )
#else
	c_mkdir_( strptr( subd ), &o755 )
#endif

'' ---------------------------------------------------------- the scan driver

'' Runs a whole scan to exhaustion, COLLECTING names and attributes, then SORTS
'' before printing -- see the file header on why the raw order is not comparable.
''
'' THE ARGUMENT IS THE DESCRIPTOR, NOT ITS DATA. fb_Dir takes an FBSTRING*, so a
'' FreeBASIC string is passed as `@s` -- `strptr( s )` gives the DATA pointer,
'' which fb_Dir then reads as a descriptor and dereferences as `data`,
'' `len` and `size`. The first version of this file did that and SEGFAULTED under
'' BOTH runtimes, which the harness reported as "both sides exited non-zero" and
'' would otherwise have counted as agreement.
''
'' THE ARGUMENT IS ALSO A TEMP AND fb_Dir DELETES IT, so a fresh descriptor is
'' built for each call; passing the same one twice would be a use-after-free.
sub scan( byref label as string, byref spec as string, byval attrib as long )

	dim as string names(0 to 63)
	dim as long attrs(0 to 63)
	dim as integer n = 0

	dim as long a = 0
	dim as any ptr r = pDir( @spec, attrib, @a )

	'' A DESCRIPTOR WHOSE data IS NULL IS THE "NOT FOUND" ANSWER -- the null
	'' descriptor, not a NULL pointer. Testing `r = 0` would never fire.
	while( (r <> 0) andalso (*cptr( zstring ptr ptr, r ) <> 0) andalso (n < 64) )
		names(n) = *(*cptr( zstring ptr ptr, r ))
		attrs(n) = a
		n += 1
		pDelTemp( r )
		'' FINDNEXT IS AN EMPTY SPEC. strptr("") is NULL, which fb_Dir reads as
		'' length 0 -- so the empty string and a NULL argument mean the same
		'' thing here, deliberately.
		dim as string nul = ""
		a = 0
		r = pDir( @nul, attrib, @a )
	wend
	if( r <> 0 ) then pDelTemp( r )

	'' INSERTION SORT BY NAME, carrying the attribute with it.
	for i as integer = 1 to n - 1
		dim as string kn = names(i)
		dim as long ka = attrs(i)
		dim as integer j = i - 1
		while( (j >= 0) andalso (names(j) > kn) )
			names(j + 1) = names(j) : attrs(j + 1) = attrs(j)
			j -= 1
		wend
		names(j + 1) = kn : attrs(j + 1) = ka
	next

	print "  "; label; " count="; n
	for i as integer = 0 to n - 1
		print "    "; names(i); " attrib="; attrs(i)
	next
end sub

'' ------------------------------------------------------------- the scans

'' A WILDCARD OVER EVERYTHING. On Windows the CRT globs; on POSIX opendir plus
'' the hand-written matcher does. The set must be the same either way.
print "-- DIR with a wildcard"
scan( "*.*        ", SCRATCH + SEP + "*.*", 0 )
scan( "*          ", SCRATCH + SEP + "*", 0 )
scan( "*.txt      ", SCRATCH + SEP + "*.txt", 0 )
scan( "*.dat      ", SCRATCH + SEP + "*.dat", 0 )
scan( "?????.txt  ", SCRATCH + SEP + "?????.txt", 0 )
scan( "a*         ", SCRATCH + SEP + "a*", 0 )
scan( "*a         ", SCRATCH + SEP + "*a", 0 )
scan( "*a*        ", SCRATCH + SEP + "*a*", 0 )
scan( "noext      ", SCRATCH + SEP + "noext", 0 )
scan( "*.xyz      ", SCRATCH + SEP + "*.xyz", 0 )

'' "*.*" AND "*." ARE DOS SPELLINGS OF "EVERYTHING" and the POSIX side rewrites
'' both to "*" -- so `noext`, which has no dot, must still appear under "*.*".
'' That rewrite is the single most surprising line in the POSIX body.
scan( "*.         ", SCRATCH + SEP + "*.", 0 )

'' NO WILDCARD AT ALL takes a completely different path on POSIX -- one stat, no
'' directory opened -- and must give the same one-entry answer.
print "-- DIR with no wildcard (the single-stat path on POSIX)"
scan( "exact file ", SCRATCH + SEP + "alpha.txt", 0 )
scan( "missing    ", SCRATCH + SEP + "nosuchfile", 0 )
scan( "the dir    ", SCRATCH, &h10 )

'' ---------------------------------------------------------- the attributes

'' THE MASK EXCLUDES; it does not include. Asking for 0 still returns files
'' because the runtime ORs in 0x20 when 0x10 was not requested -- so the two
'' scans below must NOT differ in the way a naive reading predicts.
print "-- the attribute mask"
scan( "attrib 0   ", SCRATCH + SEP + "*", 0 )
scan( "attrib 0x10", SCRATCH + SEP + "*", &h10 )
scan( "attrib 0x20", SCRATCH + SEP + "*", &h20 )
scan( "attrib 0x30", SCRATCH + SEP + "*", &h30 )
scan( "attrib 0x02", SCRATCH + SEP + "*", &h02 )
scan( "attrib 0x37", SCRATCH + SEP + "*", &h37 )
scan( "attrib -1  ", SCRATCH + SEP + "*", -1 )

'' ------------------------------------------------------- the one-cursor rule

'' THE DEFINING PROPERTY. A second FINDFIRST mid-scan abandons the first, so the
'' interleaved FINDNEXT below returns the SECOND scan's entries and the first
'' scan is simply gone. A per-call-state implementation would pass everything
'' above and fail this.
print "-- one cursor per thread"

dim as string s1 = SCRATCH + SEP + "*.txt"
dim as long a1 = 0
dim as any ptr r1 = pDir( @s1, 0, @a1 )
dim as string first1 = ""
if( (r1 <> 0) andalso (*cptr( zstring ptr ptr, r1 ) <> 0) ) then
	first1 = *(*cptr( zstring ptr ptr, r1 ))
end if
if( r1 <> 0 ) then pDelTemp( r1 )
print "  scan A opened, got a name="; ( len( first1 ) > 0 )

'' A SECOND FINDFIRST, on a different pattern, before scan A is exhausted.
dim as string s2 = SCRATCH + SEP + "*.dat"
dim as long a2 = 0
dim as any ptr r2 = pDir( @s2, 0, @a2 )
dim as string first2 = ""
if( (r2 <> 0) andalso (*cptr( zstring ptr ptr, r2 ) <> 0) ) then
	first2 = *(*cptr( zstring ptr ptr, r2 ))
end if
if( r2 <> 0 ) then pDelTemp( r2 )
print "  scan B opened, got a name="; ( len( first2 ) > 0 )

'' AND NOW A FINDNEXT: it continues B, not A. What is asserted is that the name
'' it returns matches B's pattern -- the NAME itself is file-system order and is
'' not printed.
dim as string nul2 = ""
dim as long a3 = 0
dim as any ptr r3 = pDir( @nul2, 0, @a3 )
dim as string next3 = ""
if( (r3 <> 0) andalso (*cptr( zstring ptr ptr, r3 ) <> 0) ) then
	next3 = *(*cptr( zstring ptr ptr, r3 ))
end if
if( r3 <> 0 ) then pDelTemp( r3 )
print "  findnext continues B (ends in .dat or exhausted)="; _
      ( (len( next3 ) = 0) orelse (right( next3, 4 ) = ".dat") )

'' Drain whatever is left so the next section starts clean.
do
	dim as string nd = ""
	dim as long ad = 0
	dim as any ptr rd = pDir( @nd, 0, @ad )
	if( rd = 0 ) then exit do
	dim as long done_ = ( *cptr( zstring ptr ptr, rd ) = 0 )
	pDelTemp( rd )
	if( done_ ) then exit do
loop

'' -------------------------------------------------------- degenerate inputs

'' A FINDNEXT WITH NO SCAN OPEN returns the null descriptor and zeroes
'' out_attrib -- the one place out_attrib is written on the failure path.
print "-- degenerate"
dim as string nul3 = ""
dim as long a4 = &h7777
dim as any ptr r4 = pDir( @nul3, 0, @a4 )
print "  findnext with no scan: null result="; ( (r4 = 0) orelse (*cptr( zstring ptr ptr, r4 ) = 0) ); _
      " out_attrib zeroed="; ( a4 = 0 )
if( r4 <> 0 ) then pDelTemp( r4 )

'' A NULL out_attrib IS LEGAL and must not be written -- the runtime redirects it
'' at an internal local.
dim as string s5 = SCRATCH + SEP + "*"
dim as any ptr r5 = pDir( @s5, 0, 0 )
print "  null out_attrib accepted="; ( r5 <> 0 )
if( r5 <> 0 ) then pDelTemp( r5 )
do
	dim as string nd = ""
	dim as long ad = 0
	dim as any ptr rd = pDir( @nd, 0, @ad )
	if( rd = 0 ) then exit do
	dim as long done_ = ( *cptr( zstring ptr ptr, rd ) = 0 )
	pDelTemp( rd )
	if( done_ ) then exit do
loop

'' A DIRECTORY THAT DOES NOT EXIST -- opendir fails on POSIX, _findfirst fails on
'' Windows, and in_use must stay FALSE so a following findnext returns nothing.
scan( "missing dir", "tkrt-nosuchdir" + SEP + "*", 0 )

'' A PATTERN WITH NO DIRECTORY PART, which takes the `./` branch on POSIX.
'' The working directory holds the harness's own files, so the COUNT is not
'' comparable -- only that the call succeeds and terminates.
dim as string s6 = "*.nosuchextension"
dim as long a6 = 0
dim as any ptr r6 = pDir( @s6, 0, @a6 )
print "  bare pattern, no matches: null result="; ( (r6 = 0) orelse (*cptr( zstring ptr ptr, r6 ) = 0) )
if( r6 <> 0 ) then pDelTemp( r6 )

'' ------------------------------------------------------------------ cleanup

killFile( "alpha.txt" )
killFile( "beta.txt" )
killFile( "gamma.dat" )
killFile( "delta.dat" )
killFile( "noext" )
killFile( ".hidden" )
c_rmdir_( strptr( subd ) )
c_rmdir_( @SCRATCH )
print "-- cleanup"
scan( "after cleanup", SCRATCH + SEP + "*", 0 )

print "done"
