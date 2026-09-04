'' fsdir-parity.bas -- directory enumeration, whole-file text, advisory locking,
'' volumes and change notification. 15 entry points across five fbc members.
''
'' NEEDS-GEN-LLVM
''
'' THE ENUMERATION IS REDUCED TO ORDER-INDEPENDENT FACTS. Directory order is not
'' specified by either platform and differs between them and between runs, so
'' printing the names in the order they arrive would make this fail for the
'' wrong reason. What is printed is the COUNT, whether each expected name was
'' seen, and whether "." and ".." were seen -- all of which a broken enumerator
'' gets wrong and none of which depend on order.
''
'' THE WATCHER IS EXERCISED FOR REAL, not just started and stopped: a file is
'' created inside the watched directory and Poll is expected to report it. Poll
'' is given a real timeout so a watcher that never fires ends the test rather
'' than hanging it, and the timeout path is itself checked -- an idle watcher
'' must report EXHAUSTED, not an error.
''
'' WHAT HAS A PLAUSIBLE WRONG ANSWER:
''   - "." and ".." are dropped by the ENUMERATOR, not by the caller
''   - an EMPTY directory opens successfully and reads EXHAUSTED immediately;
''     a MISSING one fails to open. On Windows both look like
''     ERROR_FILE_NOT_FOUND from FindFirstFileW unless the two are separated
''   - has_info is 1 on Windows and 0 on POSIX, deliberately
''   - a BOM is consumed and decides the encoding; no BOM means UTF-8
''   - WriteAllText writes UTF-8 with NO BOM, so a round trip is shorter than
''     what a BOM-writing version would produce
''   - a second lock attempt with timeout 0 is IN_USE, not a hang
''   - DiskSpace on a MISSING path is an error on both platforms, even though
''     GetVolumePathNameW would happily answer

extern "rtlib"
	declare function pDirOpen  alias "fb_UStrFsDirOpen"  ( byval p as any ptr, byval o as any ptr ptr ) as long
	declare function pDirRead  alias "fb_FsDirRead"      ( byval d as any ptr, byval e as any ptr ) as long
	declare sub      pDirClose alias "fb_FsDirClose"     ( byval d as any ptr )
	declare function pDirEntName alias "fb_UStrFsDirEntName" ( byval e as any ptr ) as any ptr
	declare function pSizeofDirEnt alias "fb_FsSizeofDirEnt" ( ) as long
	declare function pSizeofVolume alias "fb_FsSizeofVolume" ( ) as long
	declare function pSizeofChange alias "fb_FsSizeofChange" ( ) as long

	declare function pReadAllText  alias "fb_UStrFsReadAllText"  ( byval p as any ptr, byval st as long ptr ) as any ptr
	declare function pWriteAllText alias "fb_UStrFsWriteAllText" ( byval p as any ptr, byval s as any ptr, byval ap as long ) as long

	declare function pLockAcquire alias "fb_UStrFsLockAcquire" ( byval p as any ptr, byval ex as long, byval ms as long, byval o as any ptr ptr ) as long
	declare sub      pLockRelease alias "fb_FsLockRelease"     ( byval l as any ptr )

	declare function pDiskSpace  alias "fb_UStrFsDiskSpace"  ( byval p as any ptr, byval o as any ptr ) as long
	declare function pVolumeInfo alias "fb_UStrFsVolumeInfo" ( byval p as any ptr, byval o as any ptr ) as long
	declare function pVolumeEnum alias "fb_FsVolumeEnum"     ( byval i as long, byval o as any ptr ) as long
	declare function pVolumeRoot alias "fb_UStrFsVolumeRoot" ( byval v as any ptr ) as any ptr

	declare function pWatchStart alias "fb_UStrFsWatchStart" ( byval p as any ptr, byval rec as long, byval o as any ptr ptr ) as long
	declare function pWatchPoll  alias "fb_FsWatchPoll"      ( byval w as any ptr, byval ms as long ) as long
	declare function pWatchNext  alias "fb_FsWatchNext"      ( byval w as any ptr, byval o as any ptr ) as long
	declare sub      pWatchStop  alias "fb_FsWatchStop"      ( byval w as any ptr )
	declare function pChangePath alias "fb_UStrFsChangePath" ( byval c as any ptr ) as any ptr

	declare function pCreateDir  alias "fb_UStrFsCreateDir"  ( byval p as any ptr ) as long
	declare function pRemoveDir  alias "fb_UStrFsRemoveDir"  ( byval p as any ptr ) as long
	declare function pRemoveFile alias "fb_UStrFsRemoveFile" ( byval p as any ptr ) as long
	declare function pWriteWhole alias "fb_UStrFsWriteWhole" ( byval p as any ptr, byval d as ubyte ptr, byval n as longint, byval ap as long ) as long
end extern

const TKORT_USLOTS = 8
dim shared as ustring upool( 0 to TKORT_USLOTS - 1 )
dim shared as integer uslot
function U( byref s as string ) as any ptr
	uslot = (uslot + 1) mod TKORT_USLOTS
	upool(uslot) = s
	return @upool(uslot)
end function

function S( byval d as any ptr ) as string
	dim as ustring ptr ud = d
	if( ud = 0 ) then return "<null>"
	return str( *ud )
end function

dim as long rc = any, st = any
dim as string tmp = environ("TEMP")

#if defined( __FB_WIN32__ ) or defined( __FB_WIN64__ )
	dim as string sep = "\"
#else
	dim as string sep = "/"
#endif

dim as string root_ = tmp & sep & "tkort-fsdir"
dim as string sub_  = root_ & sep & "sub"
dim as string fa    = root_ & sep & "alpha.txt"
dim as string fb_   = root_ & sep & "beta.txt"
dim as string lk    = tmp & sep & "tkort-fsdir.lock"
dim as string txt   = tmp & sep & "tkort-fsdir-text.txt"
dim as string empt  = tmp & sep & "tkort-fsdir-empty"

'' Nothing left over from a previous run.
pRemoveFile( U(fa) ) : pRemoveFile( U(fb_) )
pRemoveDir( U(sub_) ) : pRemoveDir( U(root_) ) : pRemoveDir( U(empt) )

pCreateDir( U(root_) )
pCreateDir( U(sub_) )
dim as string payA = "alpha", payB = "beta", payG = "g"
pWriteWhole( U(fa), cptr( ubyte ptr, strptr( payA ) ), 5, 0 )
pWriteWhole( U(fb_), cptr( ubyte ptr, strptr( payB ) ), 4, 0 )

'' The descriptors are allocated by the size the runtime reports, exactly as the
'' FB layer does -- which is also what makes a sizeof drift show up here.
dim as long szEnt = pSizeofDirEnt( ), szVol = pSizeofVolume( ), szChg = pSizeofChange( )
print "-- ABI sizes are positive and plausible"
print "  dirent>0="; iif( szEnt > 0, 1, 0 ); " volume>0="; iif( szVol > 0, 1, 0 ); _
      " change>0="; iif( szChg > 0, 1, 0 )

dim as ubyte ptr entbuf = allocate( szEnt )
dim as ubyte ptr volbuf = allocate( szVol )
dim as ubyte ptr chgbuf = allocate( szChg )

print "-- enumeration, reduced to order-independent facts"
dim as any ptr d = 0
rc = pDirOpen( U(root_), @d )
print "  open rc="; rc; " handle<>0="; iif( d <> 0, 1, 0 )

dim as long n = 0, sawAlpha = 0, sawBeta = 0, sawSub = 0, sawDot = 0
if( d <> 0 ) then
	while( pDirRead( d, entbuf ) = 0 )
		dim as string nm = S( pDirEntName( entbuf ) )
		n += 1
		if( nm = "alpha.txt" ) then sawAlpha = 1
		if( nm = "beta.txt" ) then sawBeta = 1
		if( nm = "sub" ) then sawSub = 1
		if( (nm = ".") orelse (nm = "..") ) then sawDot = 1
		if( n > 64 ) then exit while
	wend
	pDirClose( d )
end if
print "  count="; n; " alpha="; sawAlpha; " beta="; sawBeta; " sub="; sawSub; " dots="; sawDot

print "-- an EMPTY directory opens and reads exhausted; a MISSING one does not open"
pCreateDir( U(empt) )
d = 0
rc = pDirOpen( U(empt), @d )
print "  empty open rc="; rc; " first read="; iif( d <> 0, pDirRead( d, entbuf ), 999 )
if( d <> 0 ) then pDirClose( d )
d = 0
print "  missing open rc="; pDirOpen( U(root_ & sep & "nope"), @d ); " handle<>0="; iif( d <> 0, 1, 0 )
d = 0
print "  empty path  rc="; pDirOpen( U(""), @d ); " handle<>0="; iif( d <> 0, 1, 0 )
print "  close(NULL) survived="; : pDirClose( 0 ) : print 1
print "  read(NULL)="; pDirRead( 0, entbuf )
pRemoveDir( U(empt) )

print "-- whole-file text"
print "  write rc="; pWriteAllText( U(txt), U("hello" & chr(10) & "wide"), 0 )
st = -1
print "  read st="; st; " -> '"; S( pReadAllText( U(txt), @st ) ); "'"
st = -1
dim as string back = S( pReadAllText( U(txt), @st ) )
print "  st="; st; " len="; len( back )

'' A UTF-8 BOM must be CONSUMED, not returned as a character.
dim as string bom8 = chr(&hEF) & chr(&hBB) & chr(&hBF) & "abc"
pWriteWhole( U(txt), cptr( ubyte ptr, strptr( bom8 ) ), 6, 0 )
st = -1
back = S( pReadAllText( U(txt), @st ) )
print "  utf8 bom  st="; st; " -> '"; back; "' len="; len( back )

'' UTF-16LE, likewise.
dim as string bomle = chr(&hFF) & chr(&hFE) & "a" & chr(0) & "b" & chr(0)
pWriteWhole( U(txt), cptr( ubyte ptr, strptr( bomle ) ), 6, 0 )
st = -1
back = S( pReadAllText( U(txt), @st ) )
print "  utf16le   st="; st; " -> '"; back; "' len="; len( back )

'' UTF-16BE has to be byte-swapped, not copied.
dim as string bombe = chr(&hFE) & chr(&hFF) & chr(0) & "a" & chr(0) & "b"
pWriteWhole( U(txt), cptr( ubyte ptr, strptr( bombe ) ), 6, 0 )
st = -1
back = S( pReadAllText( U(txt), @st ) )
print "  utf16be   st="; st; " -> '"; back; "' len="; len( back )

print "  append rc="; pWriteAllText( U(txt), U("xy"), 0 )
print "  append rc="; pWriteAllText( U(txt), U("z"), 1 )
st = -1
print "  now='"; S( pReadAllText( U(txt), @st ) ); "'"
print "  empty write rc="; pWriteAllText( U(txt), U(""), 0 )
st = -1
back = S( pReadAllText( U(txt), @st ) )
print "  empty read st="; st; " len="; len( back )
st = -1
back = S( pReadAllText( U(tmp & sep & "tkort-nope"), @st ) )
print "  missing st="; st; " len="; len( back )
pRemoveFile( U(txt) )

print "-- advisory locking"
dim as any ptr l1 = 0, l2 = 0
print "  acquire rc="; pLockAcquire( U(lk), 1, 0, @l1 ); " handle<>0="; iif( l1 <> 0, 1, 0 )
print "  again   rc="; pLockAcquire( U(lk), 1, 0, @l2 ); " handle<>0="; iif( l2 <> 0, 1, 0 )
pLockRelease( l1 )
l1 = 0
print "  after release rc="; pLockAcquire( U(lk), 1, 0, @l1 ); " handle<>0="; iif( l1 <> 0, 1, 0 )
pLockRelease( l1 )
pLockRelease( 0 )
print "  release(NULL) survived"
l1 = 0
print "  bad path rc="; pLockAcquire( U(root_ & sep & "nope" & sep & "x"), 1, 0, @l1 )
pRemoveFile( U(lk) )

print "-- volumes"
rc = pDiskSpace( U(root_), volbuf )
print "  diskspace rc="; rc; " total>0="; iif( *cptr( ulongint ptr, volbuf ) > 0, 1, 0 ); _
      " avail<=total="; iif( *cptr( ulongint ptr, volbuf + 16 ) <= *cptr( ulongint ptr, volbuf ), 1, 0 )
print "  missing rc="; pDiskSpace( U(tmp & sep & "tkort-nope"), volbuf )
rc = pVolumeInfo( U(root_), volbuf )
print "  volinfo rc="; rc; " root nonempty="; iif( len( S( pVolumeRoot( volbuf ) ) ) > 0, 1, 0 )
print "  missing rc="; pVolumeInfo( U(tmp & sep & "tkort-nope"), volbuf )
dim as long nvol = 0
while( pVolumeEnum( nvol, volbuf ) = 0 )
	nvol += 1
	if( nvol > 64 ) then exit while
wend
print "  enumerated at least one="; iif( nvol > 0, 1, 0 ); " terminates="; iif( nvol <= 64, 1, 0 )

print "-- change notification"
dim as any ptr w = 0
rc = pWatchStart( U(root_), 0, @w )
print "  start rc="; rc; " handle<>0="; iif( w <> 0, 1, 0 )

if( (rc = 0) andalso (w <> 0) ) then
	'' An idle watcher must TIME OUT, not error.
	print "  idle poll="; pWatchPoll( w, 50 )

	pWriteWhole( U(root_ & sep & "gamma.txt"), cptr( ubyte ptr, strptr( payG ) ), 1, 0 )

	'' Bounded: a watcher that never fires ends the test rather than hanging it.
	dim as long got = 0, tries = 0
	while( (got = 0) andalso (tries < 20) )
		if( pWatchPoll( w, 200 ) = 0 ) then got = 1
		tries += 1
	wend
	print "  saw a change="; got

	dim as long ev = 0
	while( pWatchNext( w, chgbuf ) = 0 )
		ev += 1
		if( ev > 64 ) then exit while
	wend
	print "  drained at least one="; iif( ev > 0, 1, 0 )
	print "  drained again="; pWatchNext( w, chgbuf )

	pWatchStop( w )
	pRemoveFile( U(root_ & sep & "gamma.txt") )
end if

w = 0
print "  missing start rc="; pWatchStart( U(root_ & sep & "nope"), 0, @w ); " handle<>0="; iif( w <> 0, 1, 0 )
print "  poll(NULL)="; pWatchPoll( 0, 0 ); " next(NULL)="; pWatchNext( 0, chgbuf )
pWatchStop( 0 )
print "  stop(NULL) survived"

deallocate( entbuf ) : deallocate( volbuf ) : deallocate( chgbuf )
pRemoveFile( U(fa) ) : pRemoveFile( U(fb_) )
pRemoveDir( U(sub_) ) : pRemoveDir( U(root_) )
print "done"
