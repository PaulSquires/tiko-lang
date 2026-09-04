'' fsops-parity.bas -- the single-object filesystem operations and the metadata
'' layer: 21 entry points across two fbc members, split by platform.
''
'' NEEDS-GEN-LLVM
''
'' EVERYTHING HERE TOUCHES THE REAL FILESYSTEM. A test that only checked return
'' codes would not notice a WriteWhole that wrote nothing or a CopyFile that
'' produced an empty file, so every write is read back and every removal is
'' confirmed with DIR.
''
'' THE NON-DETERMINISTIC RESULTS ARE REDUCED, NOT PRINTED. A temp path, a file
'' index, a volume serial and a timestamp all differ from run to run, so the
'' test prints properties of them -- lengths, prefixes, equal/not-equal,
'' round-trip agreement -- which are exactly as capable of failing and are
'' stable. Printing a raw handle or an mtime would make the differential fail
'' for the wrong reason and get "fixed" by deleting the check.
''
'' WHAT HAS A PLAUSIBLE WRONG ANSWER:
''   - a DIRECTORY passed to ReadWhole is FS_IS_A_DIRECTORY on both platforms:
''     POSIX open( ) on a directory SUCCEEDS, so the check has to be explicit
''   - RemoveFile on a directory is FS_IS_A_DIRECTORY, and on a read-only file
''     FS_READ_ONLY -- Windows reports plain ACCESS_DENIED for both
''   - RemoveDir on a NON-EMPTY directory is FS_DIR_NOT_EMPTY, which on POSIX
''     arrives as EEXIST and would otherwise map to ALREADY_EXISTS
''   - CopyFile and MoveFile REFUSE to overwrite by default
''   - AbsolutePath does NOT require the path to exist; CanonicalPath does
''   - Identity agrees for two paths naming the same file and differs for two
''     different files
''   - SetTimes with one tick 0 leaves that timestamp alone
''   - a zero-length WriteWhole still creates the file

extern "rtlib"
	declare sub      pFreeBuf   alias "fb_FsFreeBuf"   ( byval b as any ptr )
	declare function pReadWhole alias "fb_UStrFsReadWhole"  ( byval p as any ptr, byval o as ubyte ptr ptr, byval n as longint ptr ) as long
	declare function pWriteWhole alias "fb_UStrFsWriteWhole" ( byval p as any ptr, byval d as ubyte ptr, byval n as longint, byval ap as long ) as long
	declare function pCreateDir alias "fb_UStrFsCreateDir" ( byval p as any ptr ) as long
	declare function pRemoveDir alias "fb_UStrFsRemoveDir" ( byval p as any ptr ) as long
	declare function pRemoveFile alias "fb_UStrFsRemoveFile" ( byval p as any ptr ) as long
	declare function pCopyFile  alias "fb_UStrFsCopyFile"  ( byval s as any ptr, byval d as any ptr, byval ow as long ) as long
	declare function pMoveFile  alias "fb_UStrFsMoveFile"  ( byval s as any ptr, byval d as any ptr, byval ow as long ) as long
	declare function pReplaceFile alias "fb_UStrFsReplaceFile" ( byval t as any ptr, byval r as any ptr ) as long
	declare function pRandomBytes alias "fb_FsRandomBytes" ( byval b as ubyte ptr, byval n as long ) as long
	declare function pTempDir   alias "fb_UStrFsTempDir"   ( byval st as long ptr ) as any ptr
	declare function pTempFile  alias "fb_UStrFsCreateTempFile" ( byval pre as any ptr, byval st as long ptr ) as any ptr
	declare function pTempDirNew alias "fb_UStrFsCreateTempDir" ( byval pre as any ptr, byval st as long ptr ) as any ptr
	declare function pSetReadOnly alias "fb_UStrFsSetReadOnly" ( byval p as any ptr, byval v as long ) as long

	declare function pStat      alias "fb_UStrFsStat"      ( byval p as any ptr, byval f as long, byval o as any ptr ) as long
	declare function pAbsolute  alias "fb_UStrFsAbsolutePath" ( byval p as any ptr, byval st as long ptr ) as any ptr
	declare function pCanonical alias "fb_UStrFsCanonicalPath" ( byval p as any ptr, byval st as long ptr ) as any ptr
	declare function pCurrentDir alias "fb_UStrFsCurrentDir" ( byval st as long ptr ) as any ptr
	declare function pSetCurrentDir alias "fb_UStrFsSetCurrentDir" ( byval p as any ptr ) as long
	declare function pIdentity  alias "fb_UStrFsIdentity"  ( byval p as any ptr, byval v as ulongint ptr, byval i as ulongint ptr ) as long
	declare function pSetTimes  alias "fb_UStrFsSetTimes"  ( byval p as any ptr, byval m as longint, byval a as longint ) as long
end extern

type FSINFO
	as ulongint size_
	as longint  mtime, ctime, atime
	as ulong    native_attrs
	as long     kind, flags
end type

'' A ROTATING POOL, NOT ONE SHARED DESCRIPTOR.
''
'' Every argument of `f( U(a), U(b) )` is evaluated before the call, so a single
'' shared `up` makes BOTH arguments point at the SECOND string. That turned
'' CreateSymlink(target, link) into CreateSymlink(link, link) and CopyFile(a, b)
'' into CopyFile(b, b): every two-path call reported ALREADY_EXISTS, and the
'' differential still PASSED, because the wrong call is equally wrong on both
'' runtimes. A test that compares two implementations cannot notice that it is
'' asking them both the wrong question.
const TKORT_USLOTS = 8
dim shared as ustring upool( 0 to TKORT_USLOTS - 1 )
dim shared as integer uslot
function U( byref s as string ) as any ptr
	uslot = (uslot + 1) mod TKORT_USLOTS
	upool(uslot) = s
	return @upool(uslot)
end function

'' DIR's fbDirectory flag lives in dir.bi, which this test deliberately does not
'' include; Stat answers the same question and is itself one of the entry points
'' under test, so the check is not weaker for being written this way.
function isDir( byref p as string ) as long
	dim as FSINFO fi = any
	if( pStat( U(p), 1, @fi ) <> 0 ) then return 0
	return iif( fi.kind = 2, 1, 0 )
end function

function S( byval d as any ptr ) as string
	dim as ustring ptr ud = d
	if( ud = 0 ) then return "<null>"
	return str( *ud )
end function

dim as long rc = any, st = any
dim as longint n = any
dim as ubyte ptr blob = any
dim as string tmp = environ("TEMP")

#if defined( __FB_WIN32__ ) or defined( __FB_WIN64__ )
	dim as string sep = "\"
#else
	dim as string sep = "/"
#endif

dim as string base_ = tmp & sep & "tkort-fsops"
dim as string fa   = base_ & "-a.txt"
dim as string fb_  = base_ & "-b.txt"
dim as string fc   = base_ & "-c.txt"
dim as string dira = base_ & "-dir"
dim as string dirb = dira & sep & "inner"

'' Nothing left over: a stale object would make the "already exists" answers
'' depend on run order.
pRemoveFile( U(fa) ) : pRemoveFile( U(fb_) ) : pRemoveFile( U(fc) )
pRemoveDir( U(dirb) ) : pRemoveDir( U(dira) )

print "-- WriteWhole / ReadWhole round trip"
dim as string payload = "hello, filesystem" & chr(10) & "second line"
rc = pWriteWhole( U(fa), cptr( ubyte ptr, strptr( payload ) ), len( payload ), 0 )
print "  write rc="; rc
blob = 0 : n = -1
rc = pReadWhole( U(fa), @blob, @n )
print "  read rc="; rc; " len="; n; " matches="; _
      iif( (n = len( payload )) andalso (blob <> 0), _
           iif( *cptr( zstring ptr, blob ) = payload, 1, 0 ), 0 )
pFreeBuf( blob )

print "-- append"
rc = pWriteWhole( U(fa), cptr( ubyte ptr, strptr( "!" ) ), 1, 1 )
blob = 0 : n = -1
pReadWhole( U(fa), @blob, @n )
print "  append rc="; rc; " len now="; n
pFreeBuf( blob )

print "-- a zero-length write still creates the file"
rc = pWriteWhole( U(fc), 0, 0, 0 )
blob = 0 : n = -1
print "  write rc="; rc; " read rc="; pReadWhole( U(fc), @blob, @n ); " len="; n
pFreeBuf( blob )

print "-- the ReadWhole refusals"
blob = 0 : n = -1
print "  missing rc="; pReadWhole( U(base_ & "-nope"), @blob, @n ); " len="; n; " ptr<>0="; iif( blob <> 0, 1, 0 )
blob = 0 : n = -1
print "  dir     rc="; pReadWhole( U(tmp), @blob, @n ); " len="; n; " ptr<>0="; iif( blob <> 0, 1, 0 )

print "-- directories"
print "  create rc="; pCreateDir( U(dira) ); " exists="; isDir( dira )
print "  again  rc="; pCreateDir( U(dira) )
print "  inner  rc="; pCreateDir( U(dirb) )
print "  remove non-empty rc="; pRemoveDir( U(dira) )
print "  remove inner rc="; pRemoveDir( U(dirb) )
print "  remove rc="; pRemoveDir( U(dira) ); " gone="; iif( isDir( dira ) = 0, 1, 0 )
print "  remove missing rc="; pRemoveDir( U(dira) )

print "-- RemoveFile knows better than the OS code"
pCreateDir( U(dira) )
print "  on a directory rc="; pRemoveFile( U(dira) )
pRemoveDir( U(dira) )
print "  read-only set rc="; pSetReadOnly( U(fc), 1 )
print "  on a read-only rc="; pRemoveFile( U(fc) )
print "  read-only clear rc="; pSetReadOnly( U(fc), 0 )
print "  now rc="; pRemoveFile( U(fc) ); " gone="; iif( len( dir( fc ) ) = 0, 1, 0 )
print "  missing rc="; pRemoveFile( U(fc) )

print "-- copy refuses to overwrite by default"
print "  copy rc="; pCopyFile( U(fa), U(fb_), 0 ); " exists="; iif( len( dir( fb_ ) ) > 0, 1, 0 )
print "  again rc="; pCopyFile( U(fa), U(fb_), 0 )
print "  overwrite rc="; pCopyFile( U(fa), U(fb_), 1 )
print "  missing source rc="; pCopyFile( U(base_ & "-nope"), U(fc), 0 )
blob = 0 : n = -1
pReadWhole( U(fb_), @blob, @n )
print "  copy has the same length="; n
pFreeBuf( blob )

print "-- move refuses to overwrite by default"
print "  move onto existing rc="; pMoveFile( U(fb_), U(fa), 0 )
print "  move rc="; pMoveFile( U(fb_), U(fc), 0 ); _
      " src gone="; iif( len( dir( fb_ ) ) = 0, 1, 0 ); _
      " dst there="; iif( len( dir( fc ) ) > 0, 1, 0 )
print "  move missing rc="; pMoveFile( U(fb_), U(fc), 0 )

print "-- replace"
print "  replace rc="; pReplaceFile( U(fa), U(fc) ); _
      " replacement gone="; iif( len( dir( fc ) ) = 0, 1, 0 ); _
      " target there="; iif( len( dir( fa ) ) > 0, 1, 0 )

print "-- random bytes"
dim as ubyte r1( 0 to 31 ) = any, r2( 0 to 31 ) = any
dim as long same = 0
print "  rc="; pRandomBytes( @r1(0), 32 ); " "; pRandomBytes( @r2(0), 32 )
for i as integer = 0 to 31
	if( r1(i) = r2(i) ) then same += 1
next
'' 32 identical bytes from two draws is 2^-256; anything else is a broken CSPRNG.
print "  two draws differ="; iif( same < 32, 1, 0 )
print "  zero length rc="; pRandomBytes( @r1(0), 0 )

print "-- temp directory and temp objects"
st = -1
dim as string td = S( pTempDir( @st ) )
print "  tempdir st="; st; " nonempty="; iif( len( td ) > 0, 1, 0 ); _
      " no trailing separator="; iif( right( td, 1 ) <> sep, 1, 0 )
st = -1
dim as string tf = S( pTempFile( U("tkort-"), @st ) )
print "  tempfile st="; st; " exists="; iif( len( dir( tf ) ) > 0, 1, 0 ); _
      " under tempdir="; iif( left( tf, len( td ) ) = td, 1, 0 ); _
      " 16 hex tail="; iif( len( tf ) = len( td ) + 1 + 6 + 16, 1, 0 )
st = -1
dim as string tdd = S( pTempDirNew( U("tkort-"), @st ) )
print "  tempdir  st="; st; " exists="; isDir( tdd )
'' Two calls must not collide.
print "  distinct="; iif( S( pTempFile( U("tkort-"), 0 ) ) <> tf, 1, 0 )

print "-- stat"
dim as FSINFO fi = any
rc = pStat( U(fa), 1, @fi )
print "  file rc="; rc; " kind="; fi.kind; " size>0="; iif( fi.size_ > 0, 1, 0 ); _
      " mtime>0="; iif( fi.mtime > 0, 1, 0 ); " has_atime="; iif( (fi.flags and 8) <> 0, 1, 0 )
rc = pStat( U(tmp), 1, @fi )
print "  dir  rc="; rc; " kind="; fi.kind; " size="; fi.size_
rc = pStat( U(base_ & "-nope"), 1, @fi )
print "  missing rc="; rc; " kind="; fi.kind; " size="; fi.size_; " flags="; fi.flags
print "  empty   rc="; pStat( U(""), 1, @fi ); " kind="; fi.kind

print "-- absolute vs canonical"
st = -1
dim as string ab = S( pAbsolute( U(base_ & "-nope"), @st ) )
print "  absolute of a MISSING path st="; st; " nonempty="; iif( len( ab ) > 0, 1, 0 )
st = -1
dim as string cn = S( pCanonical( U(base_ & "-nope"), @st ) )
print "  canonical of a MISSING path st="; st; " empty="; iif( len( cn ) = 0, 1, 0 )
st = -1
cn = S( pCanonical( U(fa), @st ) )
print "  canonical of a real path st="; st; " nonempty="; iif( len( cn ) > 0, 1, 0 ); _
      " no device prefix="; iif( left( cn, 4 ) <> "\\?\", 1, 0 )

print "-- current directory"
st = -1
dim as string cd0 = S( pCurrentDir( @st ) )
print "  get st="; st; " nonempty="; iif( len( cd0 ) > 0, 1, 0 )
print "  set to tempdir rc="; pSetCurrentDir( U(td) )
print "  changed="; iif( S( pCurrentDir( 0 ) ) <> cd0, 1, 0 )
print "  set back rc="; pSetCurrentDir( U(cd0) )
print "  restored="; iif( S( pCurrentDir( 0 ) ) = cd0, 1, 0 )
print "  set missing rc="; pSetCurrentDir( U(base_ & "-nope") )

print "-- identity"
dim as ulongint v1 = any, i1 = any, v2 = any, i2 = any
pCopyFile( U(fa), U(fb_), 1 )
print "  a rc="; pIdentity( U(fa), @v1, @i1 ); " nonzero="; iif( i1 <> 0, 1, 0 )
print "  b rc="; pIdentity( U(fb_), @v2, @i2 ); " differs from a="; iif( i1 <> i2, 1, 0 )
print "  a again same="; _
      iif( (pIdentity( U(fa), @v2, @i2 ) = 0) andalso (v1 = v2) andalso (i1 = i2), 1, 0 )
v1 = 9 : i1 = 9
print "  missing rc="; pIdentity( U(base_ & "-nope"), @v1, @i1 ); " vol="; v1; " id="; i1

print "-- set times"
pStat( U(fa), 1, @fi )
dim as longint m0 = fi.mtime, a0 = fi.atime
'' 2001-01-01T00:00:00 in ticks since 0001-01-01.
dim as longint newm = 631139040000000000ll
print "  set mtime only rc="; pSetTimes( U(fa), newm, 0 )
pStat( U(fa), 1, @fi )
print "  mtime took="; iif( fi.mtime = newm, 1, 0 ); " atime left alone="; iif( fi.atime = a0, 1, 0 )
print "  set neither rc="; pSetTimes( U(fa), 0, 0 )
pStat( U(fa), 1, @fi )
print "  still="; iif( fi.mtime = newm, 1, 0 )
print "  missing rc="; pSetTimes( U(base_ & "-nope"), newm, 0 )

pRemoveFile( U(fa) ) : pRemoveFile( U(fb_) ) : pRemoveFile( U(fc) )
pRemoveFile( U(tf) ) : pRemoveDir( U(tdd) )
print "done"
