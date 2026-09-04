'' fileops2-parity.bas -- FILEATTR, FILEEXISTS, FILEDATETIME, KILL, the CRT file
'' copy and the three DIR wrappers. Eight entry points across eight fbc members.
''
'' NEEDS-GEN-LLVM
''
'' FILEATTR(n, 2) RETURNS AN OS HANDLE, so its VALUE cannot be compared -- the
'' two runtimes are two processes and a FILE* is an address. What is compared is
'' whether it is non-zero, which is the only part of it that is a contract.
''
'' FILEDATETIME IS COMPARED AGAINST ITSELF, not against a literal: the test
'' creates a file, reads its stamp, and checks that the stamp is TODAY according
'' to the same runtime's DATESERIAL. Comparing the serial itself would fail
'' whenever the two processes straddle a second boundary.
''
'' THE DIR WRAPPERS ARE DRIVEN OVER A DIRECTORY THIS TEST BUILDS, so the listing
'' is deterministic -- and it is SORTED before printing, because readdir order is
'' the filesystem's and not the runtime's.

#include once "fbc-int/string.bi"
#include once "vbcompat.bi"

extern "rtlib"
	declare function pFileAttr  alias "fb_FileAttr" ( byval h as long, byval rt as long ) as integer
	declare function pFileExists alias "fb_FileExists" ( byval f as zstring ptr ) as long
	declare function pFileDT    alias "fb_FileDateTime" ( byval f as zstring ptr ) as double
	declare function pFileKill  alias "fb_FileKill" ( byval s as any ptr ) as long
	declare function pCrtCopy   alias "fb_CrtFileCopy" _
		( byval s as zstring ptr, byval d as zstring ptr ) as long
	declare function pDir64     alias "fb_Dir64" _
		( byval fs as any ptr, byval a as long, byval o as longint ptr ) as any ptr
	declare function pDirNext   alias "fb_DirNext" ( byval a as long ptr ) as any ptr
	declare function pDirNext64 alias "fb_DirNext64" ( byval o as longint ptr ) as any ptr
end extern

dim shared as any ptr addrs( 0 to 7 )
addrs(0) = cast( any ptr, @pFileAttr )
addrs(1) = cast( any ptr, @pFileExists )
addrs(2) = cast( any ptr, @pFileDT )
addrs(3) = cast( any ptr, @pFileKill )
addrs(4) = cast( any ptr, @pCrtCopy )
addrs(5) = cast( any ptr, @pDir64 )
addrs(6) = cast( any ptr, @pDirNext )
addrs(7) = cast( any ptr, @pDirNext64 )

dim as long n = 0, distinct = 1
for i as integer = 0 to 7
	if( addrs(i) <> 0 ) then n += 1
	for j as integer = 0 to i - 1
		if( addrs(i) = addrs(j) ) then distinct = 0
	next
next
print "-- every file-op entry point resolves"
print "  count="; n; " distinct="; distinct

const base_ = "tkort-fileops2"

'' ------------------------------------------------------------------ FILEEXISTS

'' fopen + fclose, NOT stat -- so a DIRECTORY is not a file that exists, on
'' Windows at least, and that asymmetry is worth pinning down.
print "-- FILEEXISTS"
dim as string f1 = base_ + "-a.tmp"
kill f1
print "  before creating -> "; pFileExists( strptr( f1 ) )
open f1 for output as #1
print #1, "hello"
close #1
print "  after creating  -> "; pFileExists( strptr( f1 ) )
print "  a directory     -> "; pFileExists( @"." )
print "  empty name      -> "; pFileExists( @"" )

'' ------------------------------------------------------------------ FILEATTR

'' MODE IS A BITMASK IN A DIFFERENT ORDER FROM FB_FILE_MODE_*, so this table is
'' the check: 32 for BINARY, 1 for INPUT, 2 for OUTPUT, 8 for APPEND, 4 for
'' RANDOM. Returning the mode itself would give 0..4 and look plausible.
print "-- FILEATTR mode, one open per mode"
open f1 for input as #1
print "  INPUT : mode="; pFileAttr( 1, 1 ); " encoding="; pFileAttr( 1, 3 ); _
      " handle non-zero="; ( pFileAttr( 1, 2 ) <> 0 )
close #1
open f1 for output as #1
print "  OUTPUT: mode="; pFileAttr( 1, 1 )
close #1
open f1 for append as #1
print "  APPEND: mode="; pFileAttr( 1, 1 )
close #1
open f1 for binary as #1
print "  BINARY: mode="; pFileAttr( 1, 1 )
close #1
open f1 for random as #1 len = 16
print "  RANDOM: mode="; pFileAttr( 1, 1 )
close #1

'' ENCODING comes back as the FB_FILE_ENCOD_* number, so an encoded channel is
'' distinguishable from an ASCII one.
kill f1
open f1 for output encoding "utf16" as #1
print "  utf16 channel: encoding="; pFileAttr( 1, 3 )
close #1

'' A CLOSED CHANNEL is 0 with NO error for the handle query, and 0 with error 1
'' for an unknown query type -- two different zeros.
'' ERR IS READ INTO A LOCAL EACH TIME. Inside one PRINT list the read can
'' happen before the call that sets it, and the first version of this section
'' printed err=0 beside all three of these -- including two that set it to 1.
dim as integer h0 = pFileAttr( 1, 2 )
dim as long e0 = err
print "  closed channel, handle -> "; h0; " err="; e0
dim as integer bogus = pFileAttr( 1, 99 )
dim as long e1 = err
print "  unknown query type     -> "; bogus; " err="; e1
dim as integer badnum = pFileAttr( 999, 1 )
dim as long e2 = err
print "  out-of-range file num  -> "; badnum; " err="; e2

'' ------------------------------------------------------------- FILEDATETIME

'' COMPARED AGAINST THIS RUNTIME'S OWN NOW, never against a literal -- see the
'' file header.
print "-- FILEDATETIME"
kill f1
open f1 for output as #1
print #1, "stamped"
close #1
dim as double stamp = pFileDT( strptr( f1 ) )
print "  a file just written is dated today="; ( int( stamp ) = int( now ) )
print "  and its time part is in range="; ( (stamp - int( stamp ) >= 0.0) andalso (stamp - int( stamp ) < 1.0) )
print "  a missing file -> "; pFileDT( @"tkort-no-such-file-at-all.tmp" )

'' ------------------------------------------------------------------ COPY

print "-- fb_CrtFileCopy"
dim as string f2 = base_ + "-b.tmp"
kill f2

'' A file with an embedded NUL and a length that is not a multiple of the
'' 512-byte buffer, so the loop runs twice and the tail is partial.
open f1 for output as #1
print #1, string( 700, "C" );
print #1, chr( 0 );
print #1, string( 300, "D" );
close #1
dim as longint srcsize = 0
open f1 for binary as #1 : srcsize = lof( 1 ) : close #1

print "  copy -> "; pCrtCopy( strptr( f1 ), strptr( f2 ) )
dim as longint dstsize = 0
open f2 for binary as #1 : dstsize = lof( 1 ) : close #1
print "  sizes match="; ( srcsize = dstsize ); " size="; srcsize

'' The two failure paths: a missing source, and a destination that cannot be
'' created. Both are error 1, and both must still close whatever they opened.
print "  missing source      -> "; pCrtCopy( @"tkort-no-such-source.tmp", strptr( f2 ) )
print "  bad destination     -> "; pCrtCopy( strptr( f1 ), @"tkort-no-such-dir/x.tmp" )

'' ------------------------------------------------------------------ KILL

'' FOUR errno CODES MAP TO FOUR FB ONES. Only the missing-file case is reachable
'' portably; the others need a permission setup the test cannot make.
print "-- KILL"
dim as string gone = "tkort-no-such-file-to-kill.tmp"
print "  a missing file -> "; pFileKill( @gone )
print "  an existing one -> "; pFileKill( @f2 )
print "  and it is gone -> "; pFileExists( strptr( f2 ) )

'' ------------------------------------------------------------------ DIR

'' A DIRECTORY THIS TEST BUILDS, so the listing is deterministic. The names are
'' collected and SORTED before printing, because readdir order is the
'' filesystem's.
print "-- DIR, DIRNEXT and the 64-bit forms"
dim as string dirn = base_ + "-dir"
mkdir dirn
for i as integer = 1 to 3
	dim as string nm = dirn + "/f" + str( i ) + ".dat"
	open nm for output as #1
	print #1, "x"
	close #1
next

dim as string names(0 to 15)
dim as long count_ = 0
dim as long a32 = 0
dim as string spec = dirn + "/*.dat"
dim as string nm2 = dir( spec, 0, a32 )
while( (len( nm2 ) > 0) andalso (count_ < 16) )
	names(count_) = nm2
	count_ += 1
	nm2 = dir( a32 )
wend

'' Insertion sort -- three elements, and the point is determinism rather than
'' speed.
for i as integer = 1 to count_ - 1
	dim as string k = names(i)
	dim as long j = i - 1
	while( (j >= 0) andalso (names(j) > k) )
		names(j + 1) = names(j)
		j -= 1
	wend
	names(j + 1) = k
next

print "  found"; count_; " entries:"
for i as integer = 0 to count_ - 1
	print "    ["; names(i); "]"
next

'' THE 64-BIT FORMS WIDEN THE ATTRIBUTE. The top half must be zero, not stack
'' rubbish -- which is exactly what a direct four-byte write into an eight-byte
'' slot would leave.
dim as longint a64 = &h7FFFFFFFFFFFFFFFll
dim as string spec2 = dirn + "/*.dat"
dim as any ptr r64 = pDir64( @spec2, 0, @a64 )
print "  Dir64 attribute high half cleared="; ( (a64 shr 32) = 0 ); " low="; ( a64 and &hFFFFFFFF )

dim as longint b64 = &h7FFFFFFFFFFFFFFFll
pDirNext64( @b64 )
print "  DirNext64 high half cleared="; ( (b64 shr 32) = 0 )

'' Drain the search so the directory can be removed.
while( len( dir( a32 ) ) > 0 )
wend

for i as integer = 1 to 3
	kill dirn + "/f" + str( i ) + ".dat"
next
rmdir dirn
kill f1
kill f2

print "done"
