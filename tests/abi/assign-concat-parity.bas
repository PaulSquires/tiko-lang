'' assign-concat-parity.bas -- fb_StrAssign, fb_StrInit, fb_StrConcat.
''
'' NEEDS-GEN-LLVM -- fb_StrDelete is reserved, and this file aliases it to build
'' the fixtures.
''
'' The three destination forms are constructed by hand, because nothing in
'' ordinary FreeBASIC source lets you choose which one fbc passes:
''
''   dst_size = -1                       var-len descriptor
''   dst_size = N or FB_STRISFIXED       fixed-length STRING * N
''   dst_size = N                        fixed-length ZSTRING * N
''   dst_size = 0                        zstring ptr, "assume it fits"
#include once "fbc-int/string.bi"

extern "rtlib"
    declare function p_Assign alias "fb_StrAssign" ( byval d as any ptr, byval dn as integer, byval s as any ptr, byval sn as integer, byval fr as long ) as any ptr
    declare function p_Init   alias "fb_StrInit"   ( byval d as any ptr, byval dn as integer, byval s as any ptr, byval sn as integer, byval fr as long ) as any ptr
    declare function p_Concat alias "fb_StrConcat" ( byval d as FBC.FBSTRING ptr, byval a as any ptr, byval an as integer, byval b as any ptr, byval bn as integer ) as FBC.FBSTRING ptr
    declare sub      p_Del    alias "fb_StrDelete" ( byval s as FBC.FBSTRING ptr )
    declare function p_AllocTemp alias "fb_hStrAllocTemp" ( byval s as FBC.FBSTRING ptr, byval n as integer ) as FBC.FBSTRING ptr
end extern

#define LN(p) cint( (p)->len and &h7fffffffffffffff )
#define VARLEN (-1)

'' FB_STRISFIXED is the temp bit reused as a flag on the SIZE argument.
#if sizeof(integer) = 8
    const ISFIXED as integer = cast( integer, &h8000000000000000ull )
#else
    const ISFIXED as integer = cast( integer, &h80000000ul )
#endif

sub showd( byref tag as string, byval r as FBC.FBSTRING ptr )
    if( r = 0 ) then print tag; " NULL" : exit sub
    dim as integer n = LN(r), t = iif( r->len < 0, 1, 0 ), sz = cint( r->size )
    dim as string b = ""
    if( r->data <> 0 ) then
        for i as integer = 0 to n - 1
            b += right( "0" + hex$( cptr( ubyte ptr, r->data )[i] ), 2 ) + " "
        next
    end if
    print tag; " len="; n; " size="; sz; " temp="; t; " data="; iif(r->data=0,0,1); " ["; b; "]"
end sub

sub showbuf( byref tag as string, byval p as ubyte ptr, byval n as integer )
    dim as string o = ""
    for i as integer = 0 to n : o += right( "0" + hex$( p[i] ), 2 ) + " " : next
    print tag; " ["; o; "]"
end sub

function mkTemp( byref v as string ) as FBC.FBSTRING ptr
    dim as FBC.FBSTRING ptr tp = p_AllocTemp( 0, len(v) )
    for i as integer = 0 to len(v) - 1 : tp->data[i] = v[i] : next
    tp->data[len(v)] = 0
    return tp
end function

'' ---- var-len destination, ordinary (non-temp) source
dim as FBC.FBSTRING d1
dim as string s1 = "hello"
p_Assign( @d1, VARLEN, @s1, VARLEN, 0 )
showd( "assign varlen <- hello ", @d1 )
'' assigning a shorter value: does it reallocate?
dim as string s2 = "hi"
p_Assign( @d1, VARLEN, @s2, VARLEN, 0 )
showd( "assign varlen <- hi    ", @d1 )
'' same length: fbc skips the realloc
dim as string s3 = "ho"
p_Assign( @d1, VARLEN, @s3, VARLEN, 0 )
showd( "assign varlen <- ho    ", @d1 )
'' empty source deletes
dim as string emp = ""
p_Assign( @d1, VARLEN, @emp, VARLEN, 0 )
showd( "assign varlen <- ''    ", @d1 )

'' ---- the steal path: a temporary source moves its block
dim as FBC.FBSTRING d2
d2.data = 0 : d2.len = 0 : d2.size = 0
dim as FBC.FBSTRING ptr t1 = mkTemp( "stolen" )
dim as any ptr t1data = t1->data
p_Assign( @d2, VARLEN, t1, VARLEN, 0 )
dim as integer moved = iif( d2.data = t1data, 1, 0 )
dim as integer srcl = LN(t1), srcd = iif( t1->data = 0, 0, 1 )
showd( "assign varlen <- temp  ", @d2 )
print "  pointer moved="; moved; "  source after: len="; srcl; " data="; srcd

'' ---- init versus assign on uninitialised memory
dim as FBC.FBSTRING d3
d3.data = cast( zstring ptr, 12345 ) : d3.len = 999 : d3.size = 999
p_Init( @d3, VARLEN, @emp, VARLEN, 0 )
showd( "init varlen <- ''      ", @d3 )
dim as FBC.FBSTRING d4
d4.data = cast( zstring ptr, 12345 ) : d4.len = 999 : d4.size = 999
p_Init( @d4, VARLEN, @s1, VARLEN, 0 )
showd( "init varlen <- hello   ", @d4 )

'' ---- NULL destination still consumes a temporary source
dim as FBC.FBSTRING ptr t2 = mkTemp( "gone" )
p_Assign( 0, VARLEN, t2, VARLEN, 0 )
dim as integer n2l = LN(t2), n2d = iif( t2->data = 0, 0, 1 )
print "assign NULL dst: source after len="; n2l; " data="; n2d

'' ---- fixed-length STRING destination: pads with SPACES
dim shared as ubyte fx(0 to 15)
sub fillfx( )
    for i as integer = 0 to 15 : fx(i) = &hCC : next
end sub
fillfx() : p_Assign( @fx(0), 6 or ISFIXED, @s2, VARLEN, 0 ) : showbuf( "assign STRING*6 <- hi   ", @fx(0), 6 )
fillfx() : p_Assign( @fx(0), 6 or ISFIXED, @s1, VARLEN, 0 ) : showbuf( "assign STRING*6 <- hello", @fx(0), 6 )
dim as string s9 = "abcdefghi"
fillfx() : p_Assign( @fx(0), 6 or ISFIXED, @s9, VARLEN, 0 ) : showbuf( "assign STRING*6 <- 9chr ", @fx(0), 6 )
fillfx() : p_Assign( @fx(0), 6 or ISFIXED, @emp, VARLEN, 0 ) : showbuf( "assign STRING*6 <- ''   ", @fx(0), 6 )

'' ---- fixed-length ZSTRING destination: truncates to N-1 and terminates
fillfx() : p_Assign( @fx(0), 6, @s2, VARLEN, 0 ) : showbuf( "assign ZSTRING*6 <- hi  ", @fx(0), 7 )
fillfx() : p_Assign( @fx(0), 6, @s9, VARLEN, 0 ) : showbuf( "assign ZSTRING*6 <- 9chr", @fx(0), 7 )
fillfx() : p_Assign( @fx(0), 6, @emp, VARLEN, 0 ) : showbuf( "assign ZSTRING*6 <- ''  ", @fx(0), 7 )
'' fill_rem pads the remainder with NULs -- this form only
fillfx() : p_Assign( @fx(0), 8, @s2, VARLEN, 1 ) : showbuf( "assign ZSTRING*8 fill hi", @fx(0), 8 )
fillfx() : p_Assign( @fx(0), 8, @s2, VARLEN, 0 ) : showbuf( "assign ZSTRING*8 nofill ", @fx(0), 8 )
'' zstring ptr: dst_size 0 means "assume it fits"
fillfx() : p_Assign( @fx(0), 0, @s1, VARLEN, 0 ) : showbuf( "assign zptr <- hello    ", @fx(0), 7 )

'' ---- fb_StrConcat
showd( "concat hi+hello        ", p_Concat( 0, @s2, VARLEN, @s1, VARLEN ) )
showd( "concat ''+hello        ", p_Concat( 0, @emp, VARLEN, @s1, VARLEN ) )
showd( "concat hello+''        ", p_Concat( 0, @s1, VARLEN, @emp, VARLEN ) )
'' both empty: fbc deletes dst and returns IT, not the shared empty
dim as FBC.FBSTRING d5
d5.data = 0 : d5.len = 0 : d5.size = 0
dim as FBC.FBSTRING ptr rc = p_Concat( @d5, @emp, VARLEN, @emp, VARLEN )
print "concat ''+'' returns dst? "; iif( rc = @d5, 1, 0 )
showd( "concat ''+''           ", rc )
'' a fixed zstring operand goes through FIX decoding
dim as zstring * 12 z12 = "abcdef"
showd( "concat z12+hi          ", p_Concat( 0, @z12, 12, @s2, VARLEN ) )
showd( "concat zptr+hi         ", p_Concat( 0, strptr(z12), 0, @s2, VARLEN ) )

'' ---- concat consumes both temporary operands
dim as FBC.FBSTRING ptr c1 = mkTemp( "aa" ), c2 = mkTemp( "bb" )
dim as FBC.FBSTRING ptr rr = p_Concat( 0, c1, VARLEN, c2, VARLEN )
dim as integer q1 = LN(c1), q2 = iif(c1->data=0,0,1), q3 = LN(c2), q4 = iif(c2->data=0,0,1)
showd( "concat temp+temp       ", rr )
print "  operands after: a len="; q1; " data="; q2; "  b len="; q3; " data="; q4
