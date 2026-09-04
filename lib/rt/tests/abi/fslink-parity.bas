'' fslink-parity.bas -- links and permissions: seven entry points, split by
'' platform.
''
'' NEEDS-GEN-LLVM
''
'' ARGUMENT ORDER IS THE POINT OF THE FIRST BLOCK. Symlink and HardLink both
'' take (target, link), and a reversed implementation would still return
'' SUCCESS -- it would simply create the link under the other name. So the two
'' paths are DISTINGUISHABLE, and the test reads the target back and checks
'' which of the two names now exists. A swapped implementation cannot pass it.
''
'' SYMLINK CREATION MAY LEGITIMATELY FAIL with ACCESS_DENIED on Windows:
'' SeCreateSymbolicLink is not held by a normal user unless Developer Mode is
'' on. That is not a defect and the test does not treat it as one -- both
'' runtimes are asked the same question on the same machine, so whichever
'' answer this machine gives, they must give the SAME one. The blocks that
'' follow are guarded on the creation having worked.
''
'' HARD LINKS NEED NO PRIVILEGE, so the LinkCount block always runs for real:
'' 1 before, 2 after, 1 again after the link is removed.
''
'' WHAT HAS A PLAUSIBLE WRONG ANSWER:
''   - ReadLink on something that is NOT a link is FS_INVALID_PATH on both
''     platforms -- POSIX through readlink's EINVAL, Windows through
''     ERROR_NOT_A_REPARSE_POINT, which the generic mapper does not know
''   - ReadLink returns the target AS STORED, so a relative target stays
''     relative and is NOT canonicalized
''   - the "\??\" device prefix must never appear in a result
''   - SetHidden is FS_UNSUPPORTED on POSIX, not a rename
''   - a NULL/empty path must produce an error, not a crash
''   - status is written even on the success path, so a caller that only reads
''     it on failure still sees FS_OK

extern "rtlib"
	declare function pSymlink  alias "fb_UStrFsCreateSymlink"  ( byval t as any ptr, byval l as any ptr, byval isdir as long ) as long
	declare function pHardLink alias "fb_UStrFsCreateHardLink" ( byval t as any ptr, byval l as any ptr ) as long
	declare function pReadLink alias "fb_UStrFsReadLink"       ( byval l as any ptr, byval st as long ptr ) as any ptr
	declare function pLinkCount alias "fb_UStrFsLinkCount"     ( byval p as any ptr, byval o as ulong ptr ) as long
	declare function pGetPerm  alias "fb_UStrFsGetPerm"        ( byval p as any ptr, byval o as ulong ptr ) as long
	declare function pSetPerm  alias "fb_UStrFsSetPerm"        ( byval p as any ptr, byval v as ulong ) as long
	declare function pSetHidden alias "fb_UStrFsSetHidden"     ( byval p as any ptr, byval v as long ) as long
end extern

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

'' The returned descriptor is a TEMP the caller owns; assigning it into a
'' ustring copies it and lets the runtime free it, which is also what makes a
'' leak here show up as a count divergence rather than as silence.
function S( byval d as any ptr ) as string
	dim as ustring ptr ud = d
	if( ud = 0 ) then return "<null>"
	return str( *ud )
end function

dim as long rc = any, st = any
dim as ulong v = any, perm0 = any
dim as string tmp = environ("TEMP")

#if defined( __FB_WIN32__ ) or defined( __FB_WIN64__ )
	dim as string sep = "\"
#else
	dim as string sep = "/"
#endif

dim as string tgt  = tmp & sep & "tkort-link-TARGET.txt"
dim as string lnk  = tmp & sep & "tkort-link-LINK.txt"
dim as string hard = tmp & sep & "tkort-link-HARD.txt"
dim as long f = any

'' A real file to point at.
f = freefile : open tgt for output as #f : print #f, "payload" : close #f

'' Nothing left over from a previous run: a stale link would make the
'' "already exists" answers depend on run order.
if( len( dir( lnk ) ) ) then kill lnk
if( len( dir( hard ) ) ) then kill hard

print "-- symlink (target, link): the link is the SECOND argument"
rc = pSymlink( U(tgt), U(lnk), 0 )
print "  create rc="; rc
print "  link exists="; iif( len( dir( lnk ) ) > 0, 1, 0 ); _
      " target still exists="; iif( len( dir( tgt ) ) > 0, 1, 0 )

if( rc = 0 ) then
	st = -1
	'' S( ) CONSUMES THE DESCRIPTOR: it is a TEMP, and assigning it into a
	'' ustring is what frees it. Reading the same pointer twice reads freed
	'' memory -- and both runtimes read the same freed memory, so the
	'' differential would pass while the second check measured nothing.
	dim as string got = S( pReadLink( U(lnk), @st ) )
	print "  readlink st="; st; " target='"; got; "'"
	print "  matches what was asked for="; iif( got = tgt, 1, 0 )

	'' A RELATIVE target stays relative -- ReadLink does not canonicalize.
	dim as string rel = tmp & sep & "tkort-link-REL.txt"
	if( len( dir( rel ) ) ) then kill rel
	if( pSymlink( U("tkort-link-TARGET.txt"), U(rel), 0 ) = 0 ) then
		st = -1
		print "  relative target='"; S( pReadLink( U(rel), @st ) ); "' st="; st
		kill rel
	else
		print "  relative target: not created"
	end if

	kill lnk
else
	print "  readlink: skipped, no link was created"
end if

print "-- readlink on things that are not links"
st = -1
print "  plain file  target='"; S( pReadLink( U(tgt), @st ) ); "' st="; st
st = -1
print "  missing     target='"; S( pReadLink( U(tmp & sep & "tkort-link-NOPE"), @st ) ); "' st="; st
st = -1
print "  empty path  target='"; S( pReadLink( U(""), @st ) ); "' st="; st
print "  NULL status pointer survived="; iif( pReadLink( U(tgt), 0 ) <> 0, 1, 0 )

print "-- hard links and the link count"
v = 999 : rc = pLinkCount( U(tgt), @v )
print "  before rc="; rc; " count="; v
rc = pHardLink( U(tgt), U(hard) )
print "  create rc="; rc; " hard exists="; iif( len( dir( hard ) ) > 0, 1, 0 )
v = 999 : print "  after  rc="; pLinkCount( U(tgt), @v ); " count="; v
if( len( dir( hard ) ) ) then kill hard
v = 999 : print "  freed  rc="; pLinkCount( U(tgt), @v ); " count="; v

print "-- the link-count refusals"
v = 999 : print "  missing rc="; pLinkCount( U(tmp & sep & "tkort-link-NOPE"), @v ); " count="; v
v = 999 : print "  empty   rc="; pLinkCount( U(""), @v ); " count="; v

print "-- permissions round trip"
perm0 = 999 : rc = pGetPerm( U(tgt), @perm0 )
print "  get rc="; rc; " nonzero="; iif( perm0 <> 0, 1, 0 )
print "  set same rc="; pSetPerm( U(tgt), perm0 )
v = 999 : print "  get again rc="; pGetPerm( U(tgt), @v ); " unchanged="; iif( v = perm0, 1, 0 )
v = 999 : print "  get missing rc="; pGetPerm( U(tmp & sep & "tkort-link-NOPE"), @v ); " out="; v
print "  set missing rc="; pSetPerm( U(tmp & sep & "tkort-link-NOPE"), perm0 )
v = 999 : print "  get empty rc="; pGetPerm( U(""), @v ); " out="; v

print "-- hidden"
print "  set   rc="; pSetHidden( U(tgt), 1 )
v = 999 : rc = pGetPerm( U(tgt), @v )
print "  changed by set="; iif( v <> perm0, 1, 0 )
print "  clear rc="; pSetHidden( U(tgt), 0 )
v = 999 : rc = pGetPerm( U(tgt), @v )
print "  restored="; iif( v = perm0, 1, 0 )
print "  missing rc="; pSetHidden( U(tmp & sep & "tkort-link-NOPE"), 1 )
print "  empty   rc="; pSetHidden( U(""), 1 )

kill tgt
print "done"
