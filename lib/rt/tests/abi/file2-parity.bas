'' file2-parity.bas -- EOF, LOC, LEN, FREEFILE, CLOSE and UNGET.
''
'' NEEDS-GEN-LLVM -- reserved names.
''
'' THE THREE RULES PINNED HERE ALL RETURN A PLAUSIBLE VALUE WHEN WRONG:
''   EOF says TRUE for anything it cannot answer, and TRUE is -1.
''   LOC divides by 128 in the SEQUENTIAL modes only.
''   CLOSE #0 is an error, where QBASIC returned success.

extern "rtlib"
    declare function pEof   alias "fb_FileEof"      ( byval f as long ) as long
    declare function pLoc   alias "fb_FileLocation" ( byval f as long ) as longint
    declare function pTell  alias "fb_FileTell"     ( byval f as long ) as longint
    declare function pSeek  alias "fb_FileSeek"     ( byval f as long, byval n as long ) as long
    declare function pClose alias "fb_FileClose"    ( byval f as long ) as long
    declare function pFree  alias "fb_FileFree"     ( ) as long
    declare function pLen   alias "fb_FileLen"      ( byval s as zstring ptr ) as longint
    declare function pPutBack alias "fb_FilePutBack" ( byval f as long, byval s as any ptr, byval n as uinteger ) as long
end extern

dim as string p = environ( "TEMP" ) + "\tkort_file2.tmp"

'' ---- FREEFILE before and after an open.
print "-- freefile --"
dim as long f1 = pFree( )
print "first free  = "; f1
open p for binary as #f1
dim as long f2 = pFree( )
print "next free   = "; f2
print "distinct    = "; iif( f1 <> f2, 1, 0 )

'' ---- EOF and LOC on a BINARY handle: LOC reports bytes, not blocks.
dim as string payload = string( 300, "z" )
put #f1, , payload
pSeek( f1, 1 )
print "-- binary --"
print "eof at start= "; pEof( f1 )
print "loc at 1    = "; pLoc( f1 )
pSeek( f1, 129 )
print "loc at 129  = "; pLoc( f1 )
pSeek( f1, 301 )
print "eof at end  = "; pEof( f1 )
print "close rc    = "; pClose( f1 )
'' After CLOSE the entry is zeroed, so EOF says TRUE and LOC says 0.
print "eof closed  = "; pEof( f1 )
print "loc closed  = "; pLoc( f1 )
print "close again = "; pClose( f1 )

'' ---- LOC in a SEQUENTIAL mode divides by 128.
dim as long f3 = freefile
open p for input as #f3
print "-- input (sequential) --"
dim as string line_
pSeek( f3, 1 )
print "loc at 1    = "; pLoc( f3 )
pSeek( f3, 129 )
print "loc at 129  = "; pLoc( f3 )
pSeek( f3, 257 )
print "loc at 257  = "; pLoc( f3 )
close #f3

'' ---- UNGET: a pending character makes EOF false and moves TELL back.
dim as long f4 = freefile
open p for binary as #f4
pSeek( f4, 301 )
print "-- unget --"
print "eof before  = "; pEof( f4 )
dim as ubyte c = asc( "Q" )
print "putback rc  = "; pPutBack( f4, @c, 1 )
print "eof after   = "; pEof( f4 )
print "tell after  = "; pTell( f4 )
'' The buffer is four bytes: pushing five characters must fail.
print "putback x3  = "; pPutBack( f4, @c, 3 )
print "putback x1  = "; pPutBack( f4, @c, 1 )
close #f4

'' ---- CLOSE #0 is an error, and LEN sets the error number both ways.
print "-- misc --"
print "close #0    = "; pClose( 0 )
print "len file    = "; pLen( p )
print "len missing = "; pLen( "no_such_file_zz.tmp" )
kill p
