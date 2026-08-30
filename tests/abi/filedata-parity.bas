'' filedata-parity.bas -- the GET/PUT data path: raw, string, wide and array.
''
'' NEEDS-GEN-LLVM -- reserved names.
''
'' THE CASES THAT SEPARATE A CORRECT IMPLEMENTATION FROM A PLAUSIBLE ONE:
''
''   THE PUT-BACK MERGE. A GET is satisfied from the put-back buffer first and
''   only the shortfall reaches the device, so a read that straddles the two must
''   return the pushed-back byte FOLLOWED BY the file's -- in that order, with
''   the right total.
''
''   THE IOB BYTE COUNT. A short read is not an error, so the only way to tell
''   one from a full read is the reported count. Read past EOF and check it.
''
''   THE WIDE ROUND-UP. GET on a wstring reads raw bytes and rounds UP to a whole
''   character before terminating, so a file whose length is not a multiple of
''   the character width still yields a terminated wstring.

extern "rtlib"
    declare function pPut    alias "fb_FilePut"     ( byval f as long, byval p as long, byval v as any ptr, byval n as uinteger ) as long
    declare function pGet    alias "fb_FileGet"     ( byval f as long, byval p as long, byval d as any ptr, byval n as uinteger ) as long
    declare function pGetIOB alias "fb_FileGetIOB"  ( byval f as long, byval p as long, byval d as any ptr, byval n as uinteger, byval br as uinteger ptr ) as long
    declare function pPutStr alias "fb_FilePutStr"  ( byval f as long, byval p as long, byval s as any ptr, byval n as integer ) as long
    declare function pGetStr alias "fb_FileGetStr"  ( byval f as long, byval p as long, byval s as any ptr, byval n as integer ) as long
    declare function pGetStrIOB alias "fb_FileGetStrIOB" ( byval f as long, byval p as long, byval s as any ptr, byval n as integer, byval br as uinteger ptr ) as long
    declare function pPutBack alias "fb_FilePutBack" ( byval f as long, byval s as any ptr, byval n as uinteger ) as long
    declare function pGetWstr alias "fb_FileGetWstr" ( byval f as long, byval p as long, byval d as wstring ptr, byval n as integer ) as long
    declare function pPutWstr alias "fb_FilePutWstr" ( byval f as long, byval p as long, byval s as wstring ptr, byval n as integer ) as long
    declare function pSize   alias "fb_FileSize"    ( byval f as long ) as longint
    declare function pTell   alias "fb_FileTell"    ( byval f as long ) as longint
end extern

dim as string p = environ( "TEMP" ) + "\tkort_filedata.tmp"
#define VARLEN -1

'' ---- raw PUT then GET, and a short read reported through IOB.
dim as long f = freefile
open p for binary as #f
dim as string src = "ABCDEFGHIJ"
print "-- raw --"
print "put 10      = "; pPut( f, 1, strptr( src ), 10 )
dim as string dst = space( 10 )
print "get 10 at 1 = "; pGet( f, 1, strptr( dst ), 10 ); "  ["; dst; "]"
dst = space( 4 )
print "get 4 at 3  = "; pGet( f, 3, strptr( dst ), 4 ); "  ["; dst; "]"
'' Past the end: not an error, but the COUNT is short.
dim as uinteger got = 0
dst = space( 8 )
print "get 8 at 6  = "; pGetIOB( f, 6, strptr( dst ), 8, @got ); "  read="; got
close #f
kill p

'' ---- the PUT-BACK MERGE: one pushed byte, then the file's.
f = freefile
open p for binary as #f
pPut( f, 1, strptr( src ), 10 )
pGet( f, 1, strptr( dst ), 1 )        '' position now 2
print "-- putback merge --"
dim as ubyte c = asc( "Z" )
print "putback     = "; pPutBack( f, @c, 1 )
dst = space( 4 )
print "get 4       = "; pGetIOB( f, 0, strptr( dst ), 4, @got ); "  ["; dst; "] read="; got
print "tell after  = "; pTell( f )
close #f
kill p

'' ---- the STRING forms. PUT of an empty string succeeds and writes nothing;
'' GET into an empty destination is an ERROR. Same test, opposite verdicts.
f = freefile
open p for binary as #f
dim as string s1 = "hello"
print "-- strings --"
print "putstr rc   = "; pPutStr( f, 1, @s1, VARLEN ); "  size="; pSize( f )
dim as string empty_ = ""
print "putstr ''   = "; pPutStr( f, 0, @empty_, VARLEN ); "  size="; pSize( f )
dim as string g1 = space( 5 )
print "getstr rc   = "; pGetStr( f, 1, @g1, VARLEN ); "  ["; g1; "]"
print "getstr ''   = "; pGetStr( f, 1, @empty_, VARLEN )
dim as string g2 = space( 8 )
print "getstr IOB  = "; pGetStrIOB( f, 1, @g2, VARLEN, @got ); "  read="; got
close #f
kill p

'' ---- the WIDE forms, including a file whose length is NOT a multiple of the
'' character width.
f = freefile
open p for binary as #f
dim as wstring * 8 w1 = "abc"
print "-- wide --"
print "putwstr rc  = "; pPutWstr( f, 1, @w1, 3 ); "  size="; pSize( f )
dim as wstring * 16 wg
print "getwstr rc  = "; pGetWstr( f, 1, @wg, 8 )
dim as string o = ""
dim as ubyte ptr b = cptr( ubyte ptr, @wg )
for i as integer = 0 to 7
    o += right( "0" + hex$( b[i] ), 2 ) + " "
next
print "  bytes = ["; o; "]"
'' A one-character destination is rejected outright.
print "getwstr n=1 = "; pGetWstr( f, 1, @wg, 1 )
print "getwstr NULL= "; pGetWstr( f, 1, 0, 8 )
close #f
kill p

'' ---- odd-length file: the round-up must still terminate.
f = freefile
open p for binary as #f
dim as string odd_ = "abcde"
pPut( f, 1, strptr( odd_ ), 5 )
close #f
f = freefile
open p for binary as #f
for i as integer = 0 to 15 : cptr( ubyte ptr, @wg )[i] = &hEE : next
print "-- odd length --"
print "getwstr rc  = "; pGetWstr( f, 1, @wg, 8 )
o = ""
for i as integer = 0 to 9
    o += right( "0" + hex$( cptr( ubyte ptr, @wg )[i] ), 2 ) + " "
next
print "  bytes = ["; o; "]"
close #f
kill p
