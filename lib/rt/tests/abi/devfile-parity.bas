'' devfile-parity.bas -- the FILE* device. Twenty entry points across sixteen
'' fbc members, driven through OPEN/GET/PUT/LINE INPUT on a real temporary file.
''
'' NEEDS-GEN-LLVM
''
'' THIS ONE CAN BE DRIVEN, unlike the SCREEN and LPRINT devices: a file is a
'' terminal that never blocks. So almost everything here is behaviour rather than
'' address-taking -- the four hooks that cannot be reached from FreeBASIC source
'' (fb_hSetFileBufSize, fb_hDevFileSeekStart, fb_DevFileGetSize,
'' fb_DevFileReadLineDumb) are proved by address, and the rest by result.
''
'' THE FILE IS WRITTEN AND READ BACK IN THE SAME RUN, because the two sides of
'' the differential are separate processes with separate temporary files: any
'' test that compared file CONTENT across the two would be comparing two files
'' that no single process ever sees together. What is compared is this program's
'' printed output, so every fact has to be read back and PRINTed.
''
'' EVERY PATH PRINTS ERR AS WELL AS THE VALUE. A wrong error number with the
'' right data is the failure mode this device actually has -- fb_DevFileOpen has
'' five distinct error returns and three of them produce a usable handle on the
'' way to failing.

#include once "fbc-int/string.bi"

'' The four that generated code never calls directly.
extern "c"
	declare sub      hSetBuf   alias "fb_hSetFileBufSize" ( byval fp as any ptr )
	declare function hSeekStart alias "fb_hDevFileSeekStart" _
		( byval fp as any ptr, byval m as long, byval e as long, byval z as long ) as long
	declare function hGetSize  alias "fb_DevFileGetSize" _
		( byval fp as any ptr, byval m as long, byval e as long, byval b as long ) as longint
	declare function hReadDumb alias "fb_DevFileReadLineDumb" _
		( byval fp as any ptr, byval d as any ptr, byval f as any ptr ) as long
end extern

dim shared as any ptr addrs( 0 to 3 )
addrs(0) = cast( any ptr, @hSetBuf )
addrs(1) = cast( any ptr, @hSeekStart )
addrs(2) = cast( any ptr, @hGetSize )
addrs(3) = cast( any ptr, @hReadDumb )

dim as long n = 0, distinct = 1
for i as integer = 0 to 3
	if( addrs(i) <> 0 ) then n += 1
	for j as integer = 0 to i - 1
		if( addrs(i) = addrs(j) ) then distinct = 0
	next
next
print "-- the four unreachable-from-BASIC helpers resolve"
print "  count="; n; " distinct="; distinct

'' The name is fixed rather than from a temp-name call, so both sides use the
'' same one and neither can differ because of a counter.
const fname = "tkort-devfile-parity.tmp"
kill fname

'' ------------------------------------------------------------------ output

print "-- OPEN FOR OUTPUT, PRINT #, CLOSE"
open fname for output as #1
print "  open err="; err
print #1, "alpha"
print #1, "beta"
print #1, ""
print #1, "delta with trailing spaces   "
print "  after prints err="; err
close #1
print "  after close err="; err

'' ------------------------------------------------------------------ input

'' LINE INPUT is fb_DevFileReadLine, which is fb_DevFileReadLineDumb: the CR/LF
'' filtering and the empty-line case both live there.
print "-- OPEN FOR INPUT, LINE INPUT, EOF"
dim as string ln
dim as long count = 0
open fname for input as #1
print "  open err="; err
print "  lof="; lof( 1 )
while( not eof( 1 ) )
	line input #1, ln
	count += 1
	print "  line"; count; " len="; len( ln ); " ["; ln; "]"
wend
print "  lines="; count; " err="; err
close #1

'' READING PAST THE END returns error 17 and leaves the destination alone on the
'' first failed read only if the first read is the failing one -- so this reads
'' one line too many DELIBERATELY.
print "-- LINE INPUT past the end"
open fname for input as #1
for i as integer = 1 to 6
	ln = "sentinel"
	line input #1, ln
	print "  read"; i; " err="; err; " len="; len( ln )
next
close #1

'' ------------------------------------------------------------------ binary

'' GET/PUT reach fb_DevFileRead and fb_DevFileWrite, and the seek/tell hooks
'' through SEEK and LOC.
print "-- BINARY put/get/seek/tell"
kill fname
open fname for binary as #1
print "  open err="; err
dim as ulongint v = &hFEDCBA9876543210ull
put #1, , v
print "  after put err="; err; " loc="; loc( 1 ); " lof="; lof( 1 )

seek #1, 1
print "  after seek err="; err; " seek()="; seek( 1 )
dim as ulongint back = 0
get #1, , back
print "  read back match="; ( back = v ); " err="; err

'' A GET PAST THE END IS NOT AN ERROR and the tail is zeroed -- the record comes
'' back as zeros rather than as whatever was in the variable.
back = &hAAAAAAAAAAAAAAAAull
seek #1, 5
get #1, , back
print "  short get err="; err; " zeroed-tail value=&h"; hex( back, 16 )

close #1

'' ------------------------------------------------------------------ append

print "-- APPEND extends"
open fname for append as #1
print #1, "appended"
print "  append err="; err; " lof="; lof( 1 )
close #1
open fname for binary as #1
print "  size after append="; lof( 1 )
close #1

'' ------------------------------------------------------------------ errors

'' The five error returns fb_DevFileOpen can produce, as far as they can be
'' provoked portably.
print "-- error paths"

'' THE FUNCTION FORM, not the statement form. `open ... as #1` on a missing file
'' left ERR at zero on BOTH runtimes -- so the statement form was measuring
'' nothing and would have passed against any error return at all. Open() returns
'' the code fb_DevFileOpen produced, which is the thing under test.
kill "tkort-does-not-exist-at-all.tmp"
dim as long oe = open( "tkort-does-not-exist-at-all.tmp" for input as #1 )
print "  input on missing file returns="; oe
if( oe = 0 ) then close #1

'' BINARY on a missing file CREATES it -- the opposite answer to the line above,
'' from the same device, and the distinction is the access mode.
kill "tkort-devfile-created.tmp"
oe = open( "tkort-devfile-created.tmp" for binary as #1 )
print "  binary on missing file returns="; oe; " lof="; lof( 1 )
close #1
kill "tkort-devfile-created.tmp"

'' OUTPUT on a path whose DIRECTORY does not exist cannot be created either, and
'' that is a different branch of the same switch from the two above.
oe = open( "tkort-no-such-dir/x.tmp" for output as #1 )
print "  output into a missing directory returns="; oe
if( oe = 0 ) then close #1

'' ------------------------------------------------------------------ wide

'' PUT/GET on a wstring reach fb_DevFileWriteWstr and fb_DevFileReadWstr, which
'' are the narrow paths with a conversion on each end -- so a byte file round
'' trips ASCII exactly and nothing else.
print "-- wide put/get through the byte paths"
kill fname
dim as wstring * 32 w = wstr( "wide-round-trip" )
dim as wstring * 32 r = wstr( "" )
open fname for binary as #1
put #1, , w
print "  wide put err="; err; " lof="; lof( 1 )
seek #1, 1
get #1, , r
print "  wide get err="; err; " match="; ( r = w )
close #1

'' LINE INPUT into a wstring is fb_DevFileReadLineWstr.
kill fname
open fname for output as #1
print #1, "wide line one"
print #1, "wide line two"
close #1
open fname for input as #1
dim as wstring * 64 wl
line input #1, wl
print "  wide line input err="; err; " ["; wl; "]"
line input #1, wl
print "  wide line input err="; err; " ["; wl; "]"
close #1

'' ------------------------------------------------------------------ lock

'' LOCK/UNLOCK with a zero-length range is rejected BEFORE the handle is touched,
'' which is why it can be tested on a closed channel number without a crash.
print "-- lock"
kill fname
open fname for binary as #1
lock #1, 1 to 8
print "  lock err="; err
unlock #1, 1 to 8
print "  unlock err="; err
close #1

kill fname
print "done"
