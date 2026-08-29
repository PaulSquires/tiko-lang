'' set-base-parity.bas -- fb_StrLset/Rset/LsetANA/RsetANA, fb_HEX/OCT/BIN,
'' fb_StrInstrRev.
#include once "fbc-int/string.bi"

extern "rtlib"
    declare sub p_Lset    alias "fb_StrLset"    ( byval d as FBC.FBSTRING ptr, byval s as FBC.FBSTRING ptr )
    declare sub p_Rset    alias "fb_StrRset"    ( byval d as FBC.FBSTRING ptr, byval s as FBC.FBSTRING ptr )
    declare sub p_LsetANA alias "fb_StrLsetANA" ( byval d as any ptr, byval dn as integer, byval s as FBC.FBSTRING ptr )
    declare sub p_RsetANA alias "fb_StrRsetANA" ( byval d as any ptr, byval dn as integer, byval s as FBC.FBSTRING ptr )
    declare function p_Hex alias "fb_HEX" ( byval n as long ) as FBC.FBSTRING ptr
    declare function p_Oct alias "fb_OCT" ( byval n as long ) as FBC.FBSTRING ptr
    declare function p_Bin alias "fb_BIN" ( byval n as long ) as FBC.FBSTRING ptr
    declare function p_InstrRev alias "fb_StrInstrRev" ( byval s as FBC.FBSTRING ptr, byval p as FBC.FBSTRING ptr, byval st as integer ) as integer
    declare function p_AllocTemp alias "fb_hStrAllocTemp" ( byval s as FBC.FBSTRING ptr, byval n as integer ) as FBC.FBSTRING ptr
end extern

#define LN(p) cint( (p)->len and &h7fffffffffffffff )
#define D(v) cptr( FBC.FBSTRING ptr, @v )

'' Dumps the whole fixed-width destination INCLUDING one byte past it, because
'' LSET writes a terminator there and RSET does not -- the difference is
'' invisible in the visible characters.
sub dumpz( byref tag as string, byval p as ubyte ptr, byval n as integer )
    dim as string o = ""
    for i as integer = 0 to n
        o += right( "0" + hex$( p[i] ), 2 ) + " "
    next
    print tag; " ["; o; "]"
end sub

'' ---- LSET / RSET on a var-len destination
dim as string src3 = "ab", src6 = "abcdef", src9 = "abcdefghi", emp = ""
sub mkdst( byref target as string, byval n as integer )
    target = string( n, "." )
end sub

dim as string d1
mkdst( d1, 6 ) : p_Lset( D(d1), D(src3) ) : dumpz( "Lset  6 <- ab    ", cptr( ubyte ptr, strptr(d1) ), 6 )
mkdst( d1, 6 ) : p_Lset( D(d1), D(src6) ) : dumpz( "Lset  6 <- abcdef", cptr( ubyte ptr, strptr(d1) ), 6 )
mkdst( d1, 6 ) : p_Lset( D(d1), D(src9) ) : dumpz( "Lset  6 <- 9 chr ", cptr( ubyte ptr, strptr(d1) ), 6 )
mkdst( d1, 6 ) : p_Lset( D(d1), D(emp)  ) : dumpz( "Lset  6 <- ''    ", cptr( ubyte ptr, strptr(d1) ), 6 )
mkdst( d1, 6 ) : p_Rset( D(d1), D(src3) ) : dumpz( "Rset  6 <- ab    ", cptr( ubyte ptr, strptr(d1) ), 6 )
mkdst( d1, 6 ) : p_Rset( D(d1), D(src6) ) : dumpz( "Rset  6 <- abcdef", cptr( ubyte ptr, strptr(d1) ), 6 )
mkdst( d1, 6 ) : p_Rset( D(d1), D(src9) ) : dumpz( "Rset  6 <- 9 chr ", cptr( ubyte ptr, strptr(d1) ), 6 )
mkdst( d1, 6 ) : p_Rset( D(d1), D(emp)  ) : dumpz( "Rset  6 <- ''    ", cptr( ubyte ptr, strptr(d1) ), 6 )

'' NULL handling
p_Lset( 0, D(src3) )
p_Rset( 0, D(src3) )
mkdst( d1, 4 ) : p_Lset( D(d1), 0 ) : dumpz( "Lset  4 <- NULL  ", cptr( ubyte ptr, strptr(d1) ), 4 )
print "Lset/Rset NULL survived"

'' ---- the ANA forms, on a raw buffer
dim shared as ubyte buf(0 to 15)
sub fillbuf( )
    for i as integer = 0 to 15 : buf(i) = &hCC : next
end sub
fillbuf() : p_LsetANA( @buf(0), 6, D(src3) ) : dumpz( "LsetANA 6 <- ab  ", @buf(0), 6 )
fillbuf() : p_LsetANA( @buf(0), 6, D(src9) ) : dumpz( "LsetANA 6 <- 9chr", @buf(0), 6 )
fillbuf() : p_RsetANA( @buf(0), 6, D(src3) ) : dumpz( "RsetANA 6 <- ab  ", @buf(0), 6 )
fillbuf() : p_RsetANA( @buf(0), 6, D(src9) ) : dumpz( "RsetANA 6 <- 9chr", @buf(0), 6 )
fillbuf() : p_LsetANA( @buf(0), 0, D(src3) ) : dumpz( "LsetANA 0 <- ab  ", @buf(0), 3 )
fillbuf() : p_LsetANA( 0, 6, D(src3) ) : print "LsetANA NULL survived"

'' ---- HEX / OCT / BIN
sub shown( byref tag as string, byval r as FBC.FBSTRING ptr )
    if( r = 0 ) then print tag; " NULL" : exit sub
    dim as integer n = LN(r)
    dim as string v = ""
    for i as integer = 0 to n - 1 : v += chr( cptr( ubyte ptr, r->data )[i] ) : next
    print tag; " len="; n; " ["; v; "]"
end sub
shown( "HEX 255   ", p_Hex( 255 ) )
shown( "HEX 0     ", p_Hex( 0 ) )
shown( "HEX -1    ", p_Hex( -1 ) )
shown( "OCT 8     ", p_Oct( 8 ) )
shown( "OCT 0     ", p_Oct( 0 ) )
shown( "BIN 5     ", p_Bin( 5 ) )
shown( "BIN 0     ", p_Bin( 0 ) )
shown( "BIN -1    ", p_Bin( -1 ) )

'' ---- fb_StrInstrRev: the clamp, which is not fb_StrInstr's rejection
dim as string hay = "abcabcabc", pat = "abc", nomatch = "zz"
for st as integer = -3 to 12
    print "instrrev abcabcabc abc start="; st; " -> "; p_InstrRev( D(hay), D(pat), st )
next
print "instrrev nomatch  = "; p_InstrRev( D(hay), D(nomatch), 9 )
print "instrrev '' abc   = "; p_InstrRev( D(emp), D(pat), 1 )
print "instrrev hay ''   = "; p_InstrRev( D(hay), D(emp), 1 )
print "instrrev NULL abc = "; p_InstrRev( 0, D(pat), 1 )
print "instrrev hay NULL = "; p_InstrRev( D(hay), 0, 1 )
dim as string longer = "abcdefghijkl"
print "instrrev short long = "; p_InstrRev( D(pat), D(longer), 1 )

'' ---- operand consumption
function mkTemp( byref v as string ) as FBC.FBSTRING ptr
    dim as FBC.FBSTRING ptr tp = p_AllocTemp( 0, len(v) )
    for i as integer = 0 to len(v) - 1 : tp->data[i] = v[i] : next
    tp->data[len(v)] = 0
    return tp
end function

dim as FBC.FBSTRING ptr a1 = mkTemp( "abcabc" ), b1 = mkTemp( "bc" )
dim as integer rr = p_InstrRev( a1, b1, -1 )
dim as integer c1 = LN(a1), c2 = iif(a1->data=0,0,1), c3 = LN(b1), c4 = iif(b1->data=0,0,1)
print "instrrev temp temp = "; rr; " src len="; c1; " data="; c2; " patt len="; c3; " data="; c4

'' Lset consumes BOTH; LsetANA consumes only src
dim as FBC.FBSTRING ptr s1 = mkTemp( "xy" )
dim as FBC.FBSTRING ptr d2 = mkTemp( "......" )
p_Lset( d2, s1 )
dim as integer e1 = LN(s1), e2 = iif(s1->data=0,0,1), e3 = LN(d2), e4 = iif(d2->data=0,0,1)
print "Lset temp temp: src len="; e1; " data="; e2; " dst len="; e3; " data="; e4

dim as FBC.FBSTRING ptr s2 = mkTemp( "xy" )
fillbuf() : p_LsetANA( @buf(0), 6, s2 )
dim as integer f1 = LN(s2), f2 = iif(s2->data=0,0,1)
print "LsetANA temp src: len="; f1; " data="; f2
