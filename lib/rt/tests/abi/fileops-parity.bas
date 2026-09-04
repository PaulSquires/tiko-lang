'' fileops-parity.bas -- TELL, SEEK, SIZE, FLUSH, SETEOF and the file locks:
'' seventeen entry points.
''
'' NEEDS-GEN-LLVM -- fb_FileSeek and friends are reserved names.
''
'' THE TWO ADJUSTMENTS ARE WHAT THIS PINS, and they do not commute:
''
''     SEEK  subtract 1, THEN multiply by the record length
''     TELL  divide by the record length, THEN add 1
''
'' So on a RANDOM file with a 16-byte record, SEEK to 3 lands on byte 32 and TELL
'' turns it back into 3. Getting the order wrong is off by one RECORD, not one
'' byte -- a plausible position, never an error.
''
'' The entry points are called DIRECTLY rather than through BASIC statements, so
'' the arithmetic is observed where it happens rather than through whatever the
'' compiler chooses to emit.

extern "rtlib"
    declare function pTell   alias "fb_FileTell"    ( byval f as long ) as longint
    declare function pSize   alias "fb_FileSize"    ( byval f as long ) as longint
    declare function pSeek   alias "fb_FileSeek"    ( byval f as long, byval n as long ) as long
    declare function pSeekL  alias "fb_FileSeekLarge" ( byval f as long, byval n as longint ) as long
    declare function pFlush  alias "fb_FileFlush"   ( byval f as long, byval sysbuf as long ) as long
    declare function pSetEof alias "fb_FileSetEof"  ( byval f as long ) as long
    declare function pLock   alias "fb_FileLock"    ( byval f as long, byval a as ulong, byval b as ulong ) as long
    declare function pUnlock alias "fb_FileUnlock"  ( byval f as long, byval a as ulong, byval b as ulong ) as long
    declare function pLockL  alias "fb_FileLockLarge" ( byval f as long, byval a as longint, byval b as longint ) as long
end extern

dim as string p = environ( "TEMP" ) + "\tkort_fileops.tmp"

'' ---- BINARY: 1-based positions, no record scaling.
dim as long f = freefile
open p for binary as #f
put #f, , string( 200, "z" )
print "-- binary --"
print "size        = "; pSize( f )
print "seek to 1   = "; pSeek( f, 1 ); "  tell = "; pTell( f )
print "seek to 51  = "; pSeek( f, 51 ); "  tell = "; pTell( f )
print "seekL to 99 = "; pSeekL( f, 99 ); "  tell = "; pTell( f )
'' The round trip over the whole file: every byte position must come back.
dim as long bad = 0
for i as long = 1 to 200
    pSeek( f, i )
    if( pTell( f ) <> i ) then bad += 1
next
print "binary roundtrip bad = "; bad
close #f
kill p

'' ---- RANDOM: positions are RECORDS, scaled by the record length.
f = freefile
open p for random as #f len = 16
dim as string rec = string( 16, "a" )
put #f, 1, rec
put #f, 2, rec
put #f, 5, rec
print "-- random len=16 --"
print "size        = "; pSize( f )
print "seek to 1   = "; pSeek( f, 1 ); "  tell = "; pTell( f )
print "seek to 3   = "; pSeek( f, 3 ); "  tell = "; pTell( f )
print "seek to 5   = "; pSeek( f, 5 ); "  tell = "; pTell( f )
bad = 0
for r as long = 1 to 5
    pSeek( f, r )
    if( pTell( f ) <> r ) then bad += 1
next
print "random roundtrip bad = "; bad
close #f
kill p

'' ---- FLUSH and SETEOF: the mode rule, and truncation at the position.
f = freefile
open p for binary as #f
put #f, , string( 100, "x" )
print "-- flush / seteof --"
print "flush 0     = "; pFlush( f, 0 )
print "flush 1     = "; pFlush( f, 1 )
pSeek( f, 41 )
print "seteof rc   = "; pSetEof( f )
print "size after  = "; pSize( f )
close #f

'' An INPUT handle is read-only: both are rejected on the MODE, before any hook.
f = freefile
open p for input as #f
print "input flush = "; pFlush( f, 0 )
print "input seteof= "; pSetEof( f )
close #f
kill p

'' ---- a CLOSED handle. Every dispatcher validates it -- except fb_FileUnlockEx,
'' which fbc leaves unchecked, so it is deliberately NOT called here.
print "-- closed handle --"
print "tell closed = "; pTell( 7 )
print "size closed = "; pSize( 7 )
print "seek closed = "; pSeek( 7, 1 )
print "flush closed= "; pFlush( 7, 0 )
print "seteof clsd = "; pSetEof( 7 )
print "lock closed = "; pLock( 7, 1, 4 )

'' ---- LOCK argument validation, which happens BEFORE the handle is examined.
f = freefile
open p for binary as #f
put #f, , string( 64, "q" )
print "-- lock --"
print "lock 2,8    = "; pLock( f, 2, 8 )
print "unlock 2,8  = "; pUnlock( f, 2, 8 )
print "lockL 2,8   = "; pLockL( f, 2, 8 )
print "unlock 2,8  = "; pUnlock( f, 2, 8 )
'' inipos < 1, and endpos <= inipos, are both rejected up front.
print "lock 0,8    = "; pLock( f, 0, 8 )
print "lock 8,8    = "; pLock( f, 8, 8 )
print "lock 8,2    = "; pLock( f, 8, 2 )
close #f
kill p
