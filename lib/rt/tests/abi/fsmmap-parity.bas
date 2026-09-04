'' fsmmap-parity.bas -- memory-mapped files: five entry points, split by
'' platform.
''
'' NEEDS-GEN-LLVM
''
'' THE MAPPING IS EXERCISED FOR REAL -- a file is written, mapped, read
'' through the raw pointer, modified through it, flushed, closed, and re-read
'' from disk. A test that only checked return codes would not notice a mapping
'' that was never actually attached to the file.
''
'' WHAT HAS A PLAUSIBLE WRONG ANSWER:
''   - a ZERO-LENGTH file must be refused with INVALID_PATH, the same code on
''     both platforms, rather than yielding an undereferenceable pointer
''   - a DIRECTORY must be refused -- open() succeeds on one under POSIX, so
''     the check has to be explicit there
''   - a missing file gives NOT_FOUND
''   - Flush on a READ-ONLY mapping is a no-op that returns OK, not an error
''   - Data/Size on a NULL handle give NULL and 0 rather than faulting
''   - writes through the pointer must survive Close and reach the file

extern "rtlib"
	declare function pOpen alias "fb_UStrFsMmapOpen" ( byval p as any ptr, byval w as long, byval o as any ptr ptr ) as long
	declare sub pClose alias "fb_FsMmapClose" ( byval m as any ptr )
	declare function pData alias "fb_FsMmapData" ( byval m as any ptr ) as ubyte ptr
	declare function pSize alias "fb_FsMmapSize" ( byval m as any ptr ) as ulongint
	declare function pFlush alias "fb_FsMmapFlush" ( byval m as any ptr ) as long
end extern

dim shared as ustring up
function U( byref s as string ) as any ptr
	up = s
	return @up
end function

dim as any ptr m = any
dim as long rc = any, i = any
dim as string base_ = environ("TEMP") & "\tkort-mmap"
dim as string f1 = base_ & "-a.bin"
dim as string f2 = base_ & "-empty.bin"
dim as long f = any

'' A known 16-byte payload.
f = freefile : open f1 for binary access write as #f
dim as string payload = "ABCDEFGHIJKLMNOP"
put #f, , payload
close #f

'' An empty file.
f = freefile : open f2 for output as #f
close #f

print "-- read-only mapping of a real file"
m = 0
rc = pOpen( U(f1), 0, @m )
print "  rc="; rc; " handle<>0="; iif( m <> 0, 1, 0 )
print "  size="; pSize( m )
if( m <> 0 ) then
	dim as ubyte ptr d = pData( m )
	print "  data<>0="; iif( d <> 0, 1, 0 )
	dim as string got = ""
	for i = 0 to 15
		got += chr( d[i] )
	next
	print "  contents='"; got; "'"
	'' A read-only mapping has nothing to write back and says so.
	print "  flush rc="; pFlush( m )
	pClose( m )
end if

print "-- writable mapping: a change through the pointer reaches the file"
m = 0
rc = pOpen( U(f1), 1, @m )
print "  rc="; rc
if( m <> 0 ) then
	dim as ubyte ptr d = pData( m )
	d[0] = asc("Z")
	d[15] = asc("z")
	print "  flush rc="; pFlush( m )
	pClose( m )
end if
f = freefile : open f1 for binary access read as #f
dim as string back = space(16)
get #f, , back
close #f
print "  after close='"; back; "'"

print "-- the refusals"
m = 0
print "  empty file rc="; pOpen( U(f2), 0, @m ); " handle<>0="; iif( m <> 0, 1, 0 )
m = 0
print "  missing rc="; pOpen( U(base_ & "-nope.bin"), 0, @m ); " handle<>0="; iif( m <> 0, 1, 0 )
m = 0
print "  directory rc="; pOpen( U(environ("TEMP")), 0, @m ); " handle<>0="; iif( m <> 0, 1, 0 )
m = 0
print "  empty path rc="; pOpen( U(""), 0, @m ); " handle<>0="; iif( m <> 0, 1, 0 )

print "-- NULL handles"
print "  data="; iif( pData( 0 ) <> 0, 1, 0 ); " size="; pSize( 0 ); " flush="; pFlush( 0 )
pClose( 0 )
print "  close(NULL) survived"

kill f1
kill f2
print "done"
