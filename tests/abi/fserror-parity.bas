'' fserror-parity.bas -- the native error mapping: two entry points, split by
'' platform.
''
'' NEEDS-GEN-LLVM
''
'' THE MAPPING IS DRIVEN BY PERFORMING REAL FAILING OPERATIONS, not by setting
'' the native error directly: what matters is that a given failure produces a
'' given FB_FS_* code, and the only honest way to establish that is to make the
'' failure happen. Each case below is a distinct cause with a distinct code.
''
'' fb_FsOsError is compared too, and its value is the RAW native code -- which
'' differs between Windows and Unix by design. Both sides of the differential
'' run on the same platform, so the comparison is still exact.

extern "rtlib"
	declare function pOsError alias "fb_FsOsError" ( ) as long
	declare function pMapError alias "fb_FsMapOsError" ( ) as long
	declare function pStat alias "fb_UStrFsStat" ( byval p as any ptr, byval follow as long, byval out_ as any ptr ) as long
end extern

dim shared as ustring up
function U( byref s as string ) as any ptr
	up = s
	return @up
end function

dim as long i = any
dim shared as ubyte info(0 to 255)

print "-- with no failure pending, the map is OK and the raw code is 0"
'' A successful call first, so the state is known.
dim as string tmpf = environ("TEMP") & "\tkort-fserr.tmp"
dim as long f = freefile
open tmpf for output as #f
print #f, "x"
close #f
print "  stat existing rc="; pStat( U(tmpf), 1, @info(0) )

print "-- a missing file"
kill tmpf
print "  stat missing rc="; pStat( U(tmpf), 1, @info(0) )
print "  map="; pMapError( ); " raw<>0="; iif( pOsError( ) <> 0, 1, 0 )

print "-- a path whose parent is not a directory"
open tmpf for output as #f
print #f, "x"
close #f
print "  stat through-a-file rc="; pStat( U(tmpf & "\sub\x"), 1, @info(0) )
print "  map="; pMapError( )
kill tmpf

print "-- an empty path"
print "  stat empty rc="; pStat( U(""), 1, @info(0) )
print "  map="; pMapError( )

print "-- a name that cannot exist"
print "  stat bad rc="; pStat( U("\?\nonexistent-volume\x"), 1, @info(0) )
print "  map="; pMapError( )

print "-- the map is stable when called twice with no intervening call"
dim as long m1 = pMapError( ), m2 = pMapError( )
print "  stable="; iif( m1 = m2, 1, 0 )
print "  in range="; iif( (m1 >= 0) andalso (m1 <= 16), 1, 0 )
print "done"
