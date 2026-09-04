'' swap-case-mid-parity.bas -- fb_StrSwap, fb_StrUcase2, fb_StrLcase2,
'' fb_StrAssignMid.
''
'' NEEDS-GEN-LLVM -- fb_StrDelete and fb_StrUcase2 are reserved names.
#include once "fbc-int/string.bi"

extern "rtlib"
    declare sub p_Swap  alias "fb_StrSwap" ( byval a as any ptr, byval sa as integer, byval fa as long, byval b as any ptr, byval sb as integer, byval fb_ as long )
    declare function p_Uc alias "fb_StrUcase2" ( byval s as FBC.FBSTRING ptr, byval m as long ) as FBC.FBSTRING ptr
    declare function p_Lc alias "fb_StrLcase2" ( byval s as FBC.FBSTRING ptr, byval m as long ) as FBC.FBSTRING ptr
    declare sub p_Mid   alias "fb_StrAssignMid" ( byval d as FBC.FBSTRING ptr, byval st as integer, byval ln as integer, byval s as FBC.FBSTRING ptr )
    declare function p_AllocTemp alias "fb_hStrAllocTemp" ( byval s as FBC.FBSTRING ptr, byval n as integer ) as FBC.FBSTRING ptr
end extern

#define LN(p) cint( (p)->len and &h7fffffffffffffff )
#define D(v) cptr( FBC.FBSTRING ptr, @v )
#define VARLEN (-1)

#if sizeof(integer) = 8
    const ISFIXED as integer = cast( integer, &h8000000000000000ull )
#else
    const ISFIXED as integer = cast( integer, &h80000000ul )
#endif

sub showstr( byref tag as string, byval r as FBC.FBSTRING ptr )
    if( r = 0 ) then print tag; " NULL" : exit sub
    dim as integer n = LN(r)
    '' HEX, not characters: the high-byte cases differ in ways a terminal
    '' hides, and the first version of this test printed two different
    '' answers as the same row of replacement glyphs.
    dim as string v = ""
    for i as integer = 0 to n - 1 : v += right( "0" + hex$( cptr( ubyte ptr, r->data )[i] ), 2 ) + " " : next
    print tag; " len="; n; " temp="; iif(r->len<0,1,0); " ["; v; "]"
end sub

sub showbuf( byref tag as string, byval p as ubyte ptr, byval n as integer )
    dim as string o = ""
    for i as integer = 0 to n : o += right( "0" + hex$( p[i] ), 2 ) + " " : next
    print tag; " ["; o; "]"
end sub

'' ---- UCASE2 / LCASE2, both modes
dim as string mixed = "AbCdEf 123 xyz!@"
showstr( "Uc mode0 ", p_Uc( D(mixed), 0 ) )
showstr( "Uc mode1 ", p_Uc( D(mixed), 1 ) )
showstr( "Uc mode2 ", p_Uc( D(mixed), 2 ) )
showstr( "Lc mode0 ", p_Lc( D(mixed), 0 ) )
showstr( "Lc mode1 ", p_Lc( D(mixed), 1 ) )
showstr( "Lc mode2 ", p_Lc( D(mixed), 2 ) )
'' bytes above 127, where the two modes can genuinely differ
dim as string hi = chr(200) + chr(224) + chr(255) + "Az"
showstr( "Uc hi m0 ", p_Uc( D(hi), 0 ) )
showstr( "Uc hi m1 ", p_Uc( D(hi), 1 ) )
showstr( "Lc hi m0 ", p_Lc( D(hi), 0 ) )
showstr( "Lc hi m1 ", p_Lc( D(hi), 1 ) )
dim as string emp = ""
showstr( "Uc ''    ", p_Uc( D(emp), 0 ) )
showstr( "Uc NULL  ", p_Uc( 0, 0 ) )
showstr( "Lc NULL  ", p_Lc( 0, 0 ) )

'' ---- MID statement
sub resetdst( byref t as string )
    t = "0123456789"
end sub
dim as string dst, src = "abc"
resetdst(dst) : p_Mid( D(dst), 1, 3, D(src) )  : print "mid 1,3   ["; dst; "]"
resetdst(dst) : p_Mid( D(dst), 5, 3, D(src) )  : print "mid 5,3   ["; dst; "]"
resetdst(dst) : p_Mid( D(dst), 9, 3, D(src) )  : print "mid 9,3   ["; dst; "]"
resetdst(dst) : p_Mid( D(dst), 10, 3, D(src) ) : print "mid 10,3  ["; dst; "]"
resetdst(dst) : p_Mid( D(dst), 11, 3, D(src) ) : print "mid 11,3  ["; dst; "]"
resetdst(dst) : p_Mid( D(dst), 0, 3, D(src) )  : print "mid 0,3   ["; dst; "]"
resetdst(dst) : p_Mid( D(dst), -1, 3, D(src) ) : print "mid -1,3  ["; dst; "]"
resetdst(dst) : p_Mid( D(dst), 3, -1, D(src) ) : print "mid 3,-1  ["; dst; "]"
resetdst(dst) : p_Mid( D(dst), 3, 0, D(src) )  : print "mid 3,0   ["; dst; "]"
resetdst(dst) : p_Mid( D(dst), 3, 99, D(src) ) : print "mid 3,99  ["; dst; "]"
resetdst(dst) : p_Mid( D(dst), 3, 2, D(emp) )  : print "mid 3,2 ''["; dst; "]"
resetdst(dst) : p_Mid( D(dst), 3, 2, 0 )       : print "mid 3,2 N ["; dst; "]"
p_Mid( 0, 1, 1, D(src) ) : print "mid NULL dst survived"

'' ---- SWAP: both var-len (descriptor swap, temp bits included)
dim as string a1 = "aaaa", b1 = "bb"
p_Swap( D(a1), VARLEN, 0, D(b1), VARLEN, 0 )
print "swap varlen: a=["; a1; "] b=["; b1; "]"

'' ---- SWAP: equal-length fixed zstrings
dim shared as ubyte z1(0 to 15), z2(0 to 15)
sub setz( byval p as ubyte ptr, byref v as string, byval cap as integer )
    for i as integer = 0 to cap - 1 : p[i] = 0 : next
    for i as integer = 0 to len(v) - 1 : p[i] = v[i] : next
end sub
setz( @z1(0), "abc", 8 ) : setz( @z2(0), "xyz", 8 )
p_Swap( @z1(0), 8, 0, @z2(0), 8, 0 )
showbuf( "swap z=z  z1", @z1(0), 7 ) : showbuf( "swap z=z  z2", @z2(0), 7 )

'' unequal fixed zstrings -- the abandon-rather-than-truncate rule
setz( @z1(0), "ab", 4 ) : setz( @z2(0), "wxyz12", 8 )
p_Swap( @z1(0), 4, 0, @z2(0), 8, 0 )
showbuf( "swap z4/z8 z1", @z1(0), 7 ) : showbuf( "swap z4/z8 z2", @z2(0), 8 )

'' fixed STRING * N pair -- space padding
setz( @z1(0), "ab", 6 ) : setz( @z2(0), "vwxyz", 6 )
p_Swap( @z1(0), 6 or ISFIXED, 0, @z2(0), 6 or ISFIXED, 0 )
showbuf( "swap s6/s6 z1", @z1(0), 6 ) : showbuf( "swap s6/s6 z2", @z2(0), 6 )

'' one var-len, one fixed -- routed through fb_StrAssign
dim as string v1 = "hello"
setz( @z2(0), "xy", 8 )
p_Swap( D(v1), VARLEN, 0, @z2(0), 8, 0 )
print "swap varlen/z8: v=["; v1; "]" : showbuf( "               z2", @z2(0), 8 )

p_Swap( 0, VARLEN, 0, D(v1), VARLEN, 0 )
print "swap NULL survived"

'' ---- operand consumption
function mkTemp( byref v as string ) as FBC.FBSTRING ptr
    dim as FBC.FBSTRING ptr tp = p_AllocTemp( 0, len(v) )
    for i as integer = 0 to len(v) - 1 : tp->data[i] = v[i] : next
    tp->data[len(v)] = 0
    return tp
end function
dim as FBC.FBSTRING ptr u1 = mkTemp( "abc" )
p_Uc( u1, 0 )
dim as integer c1 = LN(u1), c2 = iif(u1->data=0,0,1)
print "Ucase temp: after len="; c1; " data="; c2
dim as FBC.FBSTRING ptr m1 = mkTemp( "0123456789" ), m2 = mkTemp( "XY" )
p_Mid( m1, 2, 2, m2 )
dim as integer c3 = LN(m1), c4 = iif(m1->data=0,0,1), c5 = LN(m2), c6 = iif(m2->data=0,0,1)
print "Mid temp temp: dst len="; c3; " data="; c4; " src len="; c5; " data="; c6
