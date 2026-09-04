'' fileput-parity.bas -- the PUT data path, and the two rules in it.
''
'' NEEDS-GEN-LLVM -- reserved names.
''
'' THE RANDOM RECORD SKIP. After writing `bytes` the file advances to the end of
'' the current record: skip = (reclen - (bytes mod reclen)) mod reclen. The OUTER
'' mod is what makes a FULL-RECORD write skip nothing; drop it and every RANDOM
'' PUT leaves a record-sized hole. Both a short write and an exact one are asked
'' below, because only the exact one distinguishes the two formulas.
''
'' THE LINE-LENGTH RULE. checknewline makes PUT update the field PRINT's comma
'' padding reads, scanning BACKWARDS for the last CR or LF. Text with and without
'' a newline take different arms, and both are exercised through the position
'' that PRINT then pads to.

extern "rtlib"
    declare function pPut   alias "fb_FilePut"  ( byval f as long, byval p as long, byval v as any ptr, byval n as uinteger ) as long
    declare function pPutL  alias "fb_FilePutLarge" ( byval f as long, byval p as longint, byval v as any ptr, byval n as uinteger ) as long
    declare function pTell  alias "fb_FileTell" ( byval f as long ) as longint
    declare function pSize  alias "fb_FileSize" ( byval f as long ) as longint
    declare function pSeek  alias "fb_FileSeek" ( byval f as long, byval n as long ) as long
end extern
extern "c"
    declare function pPutData alias "fb_FilePutData" _
        ( byval f as long, byval p as longint, byval v as any ptr, byval n as uinteger, _
          byval adj as long, byval chk as long ) as long
end extern

dim as string p = environ( "TEMP" ) + "\tkort_fileput.tmp"
dim as string buf = string( 40, "x" )

'' ---- BINARY: no record adjustment, position advances by the byte count.
dim as long f = freefile
open p for binary as #f
print "-- binary --"
print "put 10 rc   = "; pPut( f, 0, strptr( buf ), 10 ); "  tell = "; pTell( f )
print "put 10 rc   = "; pPut( f, 0, strptr( buf ), 10 ); "  tell = "; pTell( f )
print "put at 5    = "; pPut( f, 5, strptr( buf ), 4 );  "  tell = "; pTell( f )
print "putL at 21  = "; pPutL( f, 21, strptr( buf ), 4 ); "  tell = "; pTell( f )
print "size        = "; pSize( f )
'' A negative position is rejected before anything happens.
print "put at -1   = "; pPutData( f, -1, strptr( buf ), 4, -1, 0 )
close #f
kill p

'' ---- RANDOM with a 16-byte record. A SHORT write is padded to the boundary;
'' an EXACT one is not padded at all.
f = freefile
open p for random as #f len = 16
print "-- random len=16 --"
print "put rec1 x16= "; pPut( f, 1, strptr( buf ), 16 ); "  tell = "; pTell( f )
print "put rec2 x10= "; pPut( f, 2, strptr( buf ), 10 ); "  tell = "; pTell( f )
print "put rec3 x16= "; pPut( f, 3, strptr( buf ), 16 ); "  tell = "; pTell( f )
print "size        = "; pSize( f )
'' Without the record adjustment the position does NOT round up.
pSeek( f, 1 )
print "noadj x10   = "; pPutData( f, 0, strptr( buf ), 10, 0, 0 ); "  tell = "; pTell( f )
close #f
kill p

'' ---- the line-length bookkeeping, observed through PRINT's comma padding.
'' A PUT with checknewline set changes where the next PRINT , lands.
f = freefile
open p for output as #f
dim as string noeol = "abcdefgh"
dim as string witheol = "abc" + chr(10) + "de"
print "-- line length --"
pPutData( f, 0, strptr( noeol ), 8, 0, -1 )
print #f, "A", "B"
pPutData( f, 0, strptr( witheol ), 6, 0, -1 )
print #f, "C", "D"
close #f
'' The file's bytes are what the padding produced.
f = freefile
open p for binary as #f
dim as string got = space( pSize( f ) )
get #f, , got
close #f
dim as string o = ""
for i as integer = 1 to len( got )
    o += right( "0" + hex$( asc( got, i ) ), 2 ) + " "
next
print "bytes = ["; o; "]"
kill p
