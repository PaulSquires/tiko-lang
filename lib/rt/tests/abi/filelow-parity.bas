'' filelow-parity.bas -- the low-level file helpers. Seven entry points across
'' six fbc members.
''
'' NEEDS-GEN-LLVM
''
'' TWO OF THE SEVEN ARE PURE AND ARE DRIVEN COMPLETELY -- fb_hConvertPath and
'' fb_hMakeInkeyStr take a value and give one back. The other five touch a real
'' file, so each is driven against a scratch file in the current directory and
'' the OBSERVABLE EFFECT is printed rather than just the return code: the file's
'' length after a truncate, the bytes on disk after a flush.
''
'' A FLUSH IS NOT OBSERVABLE IN-PROCESS, AND THIS FILE SAYS SO RATHER THAN
'' PRETENDING. An earlier version called fb_hFileFlushEx and then read the file's
'' length through a SECOND handle, expecting 16; it read 0 and still passed,
'' because both runtimes read 0. MEASURED, on win64: after fwrite of 16 bytes and
'' a successful FlushFileBuffers, a second handle opened on the same file reports
'' size 0, and only after the first handle is CLOSED does it report 16 --
'' FlushFileBuffers commits the DATA without publishing the new end-of-file to
'' the directory entry. SetEndOfFile does publish it, which is why the truncate
'' section below reads back real numbers and the flush section could not.
''
'' So the flush is checked for its RETURN CODE and for the bytes surviving a
'' close, and the claim is limited to that: nothing short of killing the process
'' distinguishes a real fsync from a no-op, and this harness cannot.
''
'' fb_hFileResetEx IS NOT CALLED. It reopens stdin/stdout on the terminal by
'' name, and under the differential harness stdout IS A PIPE -- so calling it
'' would either fail (no tty) or, worse, SUCCEED and detach the process's output
'' from the pipe the harness is reading, which loses every line printed after it
'' and looks exactly like a hang. It is proved by ADDRESS only, and that
'' limitation is stated here rather than left as a silent gap.
''
'' THE LOCK TEST DOES NOT TAKE A CONFLICTING LOCK, for the same class of reason:
'' the POSIX side uses F_SETLKW, which BLOCKS until the conflict clears, and a
'' second process holding the range would hang the differential forever rather
'' than fail it. What is tested is lock-then-unlock on a file this process owns,
'' which is the path every LOCK/UNLOCK statement actually takes.
''
'' AND THE LOCK RESULT IS EXPECTED TO DIFFER BETWEEN PLATFORMS, not between
'' runtimes. POSIX fcntl locks are advisory and per-process; Windows LockFile is
'' mandatory. Both runtimes are compared on the SAME platform, so the difference
'' never appears in the diff -- but a reader of the output should not mistake the
'' Windows answers for the POSIX ones.

#include once "fbc-int/string.bi"

extern "c"
	declare sub      pConv     alias "fb_hConvertPath" ( byval p as zstring ptr )
	declare function pFlushEx  alias "fb_hFileFlushEx"  ( byval f as any ptr ) as long
	declare function pSetEof   alias "fb_hFileSetEofEx" ( byval f as any ptr ) as long
	declare function pLock     alias "fb_hFileLock"     ( byval f as any ptr, byval o as longint, byval n as longint ) as long
	declare function pUnlock   alias "fb_hFileUnlock"   ( byval f as any ptr, byval o as longint, byval n as longint ) as long
	declare function pResetEx  alias "fb_hFileResetEx"  ( byval s as long ) as long
	declare function pInkey    alias "fb_hMakeInkeyStr" ( byval k as long ) as any ptr
	declare function pDelTemp  alias "fb_hStrDelTemp"   ( byval s as any ptr ) as long

	declare function c_fopen   alias "fopen"   ( byval p as zstring ptr, byval m as zstring ptr ) as any ptr
	declare function c_fclose  alias "fclose"  ( byval f as any ptr ) as long
	declare function c_fwrite  alias "fwrite"  ( byval b as any ptr, byval sz as uinteger, byval n as uinteger, byval f as any ptr ) as uinteger
	declare function c_fseek   alias "fseek"   ( byval f as any ptr, byval o as long, byval w as long ) as long
	declare function c_ftell   alias "ftell"   ( byval f as any ptr ) as long
	declare function c_fread   alias "fread"   ( byval b as any ptr, byval sz as uinteger, byval n as uinteger, byval f as any ptr ) as uinteger
	declare function c_remove  alias "remove"  ( byval p as zstring ptr ) as long
end extern

'' ------------------------------------------------------- every one resolves

dim shared as any ptr addrs( 0 to 6 )
addrs(0) = cast( any ptr, @pConv )
addrs(1) = cast( any ptr, @pFlushEx )
addrs(2) = cast( any ptr, @pSetEof )
addrs(3) = cast( any ptr, @pLock )
addrs(4) = cast( any ptr, @pUnlock )
addrs(5) = cast( any ptr, @pResetEx )
addrs(6) = cast( any ptr, @pInkey )

dim as long n = 0, distinct = 1
for i as integer = 0 to 6
	if( addrs(i) <> 0 ) then n += 1
	for j as integer = 0 to i - 1
		if( addrs(i) = addrs(j) ) then distinct = 0
	next
next
print "-- all seven resolve"
print "  count="; n; " distinct="; distinct

'' ------------------------------------------------------ fb_hConvertPath

'' IN PLACE, so the buffer is a fixed zstring and not a FreeBASIC string -- and
'' the direction is the HOST's, so the same input gives different output on
'' Windows and Linux by design. Both runtimes see the same host, so it compares.
print "-- fb_hConvertPath"
sub tryConv( byref s as string )
	dim as zstring * 128 b = any
	dim as integer l = len( s )
	for i as integer = 0 to l - 1
		b[i] = s[i]
	next
	b[l] = 0
	pConv( @b )
	print "  ["; s; "] -> ["; b; "] len="; len( b )
end sub

tryConv( "" )
tryConv( "a" )
tryConv( "/" )
tryConv( "\" )
tryConv( "dir/file.txt" )
tryConv( "dir\file.txt" )
tryConv( "C:\dir/sub\file" )
tryConv( "//server//share" )
tryConv( "\\server\\share" )
tryConv( "no separators here" )
tryConv( "///" )
tryConv( "\\\" )
tryConv( "a/b\c/d\e" )

'' EMBEDDED HIGH BYTES ARE UNTOUCHED -- the loop compares against '/' and '\'
'' only, so a byte that happens to be part of a multi-byte character and equals
'' neither passes through. (A trail byte that DOES equal 0x5C would be rewritten,
'' which is a real Shift-JIS hazard in fbc and is reproduced, not fixed.)
dim as zstring * 16 hb = any
hb[0] = 200 : hb[1] = 92 : hb[2] = 201 : hb[3] = 47 : hb[4] = 0
pConv( @hb )
print "  high bytes -> "; hb[0]; " "; hb[1]; " "; hb[2]; " "; hb[3]

'' ---------------------------------------------------- fb_hMakeInkeyStr

'' ONE BYTE BELOW 0x100, TWO ABOVE, LOW BYTE FIRST. LEN() is how every caller
'' tells the two apart, so LEN and both bytes are printed for every case.
print "-- fb_hMakeInkeyStr"
sub tryInkey( byval k as long )
	dim as any ptr r = pInkey( k )
	if( r = 0 ) then
		print "  key="; k; " -> <null>"
		exit sub
	end if
	dim as zstring ptr d = *cptr( zstring ptr ptr, r )
	dim as integer l = *cptr( integer ptr, cptr( ubyte ptr, r ) + sizeof( any ptr ) )
	l = l and (not (cast( integer, 1 ) shl (sizeof( integer ) * 8 - 1)))
	print "  key="; k; " len="; l;
	for i as integer = 0 to l - 1
		print " "; cast( long, (*cptr( ubyte ptr, cptr( ubyte ptr, d ) + i )) );
	next
	print
	pDelTemp( r )
end sub

tryInkey( 0 )
tryInkey( 13 )
tryInkey( 27 )
tryInkey( 65 )
tryInkey( 255 )
tryInkey( 256 )
tryInkey( &h4800 )        '' up arrow
tryInkey( &h4B00 )        '' left
tryInkey( &h3B00 )        '' F1
tryInkey( &h6400 )
tryInkey( &hFF01 )
tryInkey( &h0141 )

'' ------------------------------------------------------- the file helpers

'' A SCRATCH FILE, WRITTEN THROUGH THE CRT so the FILE* the helpers are given is
'' the same kind of handle the runtime would hand them.
const SCRATCH = "tkrt-filelow.tmp"

'' Reads the file's length off the disk, which is what makes the truncate
'' observable -- the return code alone would not distinguish "truncated to 8"
'' from "did nothing and reported success".
function diskLen( byref path as string ) as long
	dim as any ptr f = c_fopen( strptr( path ), @"rb" )
	if( f = 0 ) then return -1
	c_fseek( f, 0, 2 )
	dim as long l = c_ftell( f )
	c_fclose( f )
	return l
end function

print "-- fb_hFileFlushEx"

'' A SCRATCH FILE OF ITS OWN, closed before it is read -- see the file header on
'' why a second handle cannot see the size while the first is open.
const FSCRATCH = "tkrt-fileflush.tmp"
dim as any ptr ff = c_fopen( @FSCRATCH, @"w+b" )
print "  scratch opened="; ( ff <> 0 )

dim as zstring * 32 payload = "0123456789ABCDEF"
print "  fwrite -> "; c_fwrite( @payload, 1, 16, ff ); " ftell="; c_ftell( ff )

'' THE RETURN CODE IS THE ONLY IN-PROCESS OBSERVABLE. Zero is FB_RTERROR_OK.
print "  flush -> "; pFlushEx( ff )

'' A SECOND FLUSH WITH NOTHING PENDING still succeeds -- fsync and
'' FlushFileBuffers are both idempotent, and a helper that only worked on a dirty
'' handle would be a real difference.
print "  flush again -> "; pFlushEx( ff )

'' AND WHILE THE HANDLE IS STILL OPEN, the size a second handle sees. Printed
'' because it is the thing that fooled the earlier version of this test: on
'' Windows it is 0 and on POSIX it is 16, and BOTH runtimes agree either way.
print "  size via a second handle, handle still open="; diskLen( FSCRATCH )

c_fclose( ff )
print "  size after close="; diskLen( FSCRATCH )

'' The bytes themselves, which is what proves the write path was intact.
dim as any ptr fr = c_fopen( @FSCRATCH, @"rb" )
dim as zstring * 32 back = any
for i as integer = 0 to 31
	back[i] = 0
next
print "  read back n="; c_fread( @back, 1, 16, fr ); " ["; back; "]"
c_fclose( fr )
c_remove( @FSCRATCH )

'' A FRESH HANDLE for the truncate and lock sections below.
dim as any ptr fh = c_fopen( @SCRATCH, @"w+b" )
c_fwrite( @payload, 1, 16, fh )
pFlushEx( fh )

print "-- fb_hFileSetEofEx"
'' TRUNCATES AT THE CURRENT POSITION, so the seek IS the argument. Three
'' positions: the middle, the very start, and past the end.
c_fseek( fh, 8, 0 )
print "  seek 8, seteof -> "; pSetEof( fh ); " disk length="; diskLen( SCRATCH )

c_fseek( fh, 0, 0 )
print "  seek 0, seteof -> "; pSetEof( fh ); " disk length="; diskLen( SCRATCH )

'' PAST THE END EXTENDS on both platforms, with the gap reading as zeroes.
c_fseek( fh, 12, 0 )
print "  seek 12, seteof -> "; pSetEof( fh ); " disk length="; diskLen( SCRATCH )

print "-- fb_hFileLock / fb_hFileUnlock"
'' LOCK THEN UNLOCK, on a file this process already owns -- see the file header
'' on why no conflicting lock is taken.
print "  lock 0,4   -> "; pLock( fh, 0, 4 )
print "  unlock 0,4 -> "; pUnlock( fh, 0, 4 )

'' A SECOND RANGE, non-overlapping, then both released in the other order.
print "  lock 4,4   -> "; pLock( fh, 4, 4 )
print "  lock 8,4   -> "; pLock( fh, 8, 4 )
print "  unlock 8,4 -> "; pUnlock( fh, 8, 4 )
print "  unlock 4,4 -> "; pUnlock( fh, 4, 4 )

'' A ZERO-LENGTH RANGE MEANS SOMETHING DIFFERENT ON EACH PLATFORM: POSIX reads
'' l_len == 0 as "to end of file", Windows locks nothing. Same platform both
'' runtimes, so it compares -- and it is here because it is the boundary.
print "  lock 0,0   -> "; pLock( fh, 0, 0 )
print "  unlock 0,0 -> "; pUnlock( fh, 0, 0 )

'' PAST THE END OF THE FILE is legal on both -- a lock is on a byte RANGE, not on
'' data that exists.
print "  lock 1000,16   -> "; pLock( fh, 1000, 16 )
print "  unlock 1000,16 -> "; pUnlock( fh, 1000, 16 )

'' UNLOCKING SOMETHING NEVER LOCKED. POSIX F_UNLCK on a clear range succeeds;
'' Windows UnlockFile fails. Printed because it is the one asymmetry a caller
'' can hit by accident.
print "  unlock 500,4 (never locked) -> "; pUnlock( fh, 500, 4 )

c_fclose( fh )
c_remove( @SCRATCH )
print "  scratch removed="; ( diskLen( SCRATCH ) = -1 )

'' ------------------------------------------------------ fb_hFileResetEx

'' ADDRESS ONLY. Calling it under the harness would reopen stdout on the terminal
'' and detach it from the pipe being compared -- see the file header.
print "-- fb_hFileResetEx (address only, NOT CALLED)"
print "  resolves="; ( cast( any ptr, @pResetEx ) <> 0 )

print "done"
