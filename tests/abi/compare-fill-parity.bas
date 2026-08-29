'' compare-fill-parity.bas -- fb_StrCompare, fb_StrDelete, fb_StrFill1/2.
'' Every case restates something PROBE-37 or PROBE-38 measured against fbc.
''
'' NEEDS-GEN-LLVM -- fb_StrDelete is one of the names fbc reserves in its
'' rtlLookupTB table, so aliasing it makes fbc emit two declarations of it in the
'' generated C with different parameter types, and gcc rejects the file:
''     error: conflicting types for 'fb_StrDelete'
'' The llvm backend has no C layer to disagree with. build/diff.sh reads this
'' marker and compiles BOTH sides that way.
#include once "fbc-int/string.bi"

type TKCTXHEAD
    argc     as long
    argv     as zstring ptr ptr
    nulldesc as FBC.FBSTRING
end type
extern "C"
    extern __fb_ctx alias "__fb_ctx" as TKCTXHEAD
end extern

extern "rtlib"
    declare function p_Cmp   alias "fb_StrCompare" ( byval a as any ptr, byval na as integer, byval b as any ptr, byval nb as integer ) as long
    declare sub      p_Del   alias "fb_StrDelete"  ( byval s as FBC.FBSTRING ptr )
    declare function p_Fill1 alias "fb_StrFill1"   ( byval cnt as integer, byval fchar as long ) as FBC.FBSTRING ptr
    declare function p_Fill2 alias "fb_StrFill2"   ( byval cnt as integer, byval src as FBC.FBSTRING ptr ) as FBC.FBSTRING ptr
    declare function p_AllocTemp alias "fb_hStrAllocTemp" ( byval s as FBC.FBSTRING ptr, byval n as integer ) as FBC.FBSTRING ptr
end extern

#define LN(p) cint( (p)->len and &h7fffffffffffffff )
const VARLEN = -1

sub showr( byref tag as string, byval r as FBC.FBSTRING ptr )
    if( r = 0 ) then print tag; " NULL" : exit sub
    dim as integer n = LN(r), t = iif( r->len < 0, 1, 0 )
    dim as integer sh = iif( r = @__fb_ctx.nulldesc, 1, 0 )
    dim as string b = ""
    if( r->data <> 0 ) then
        for i as integer = 0 to n - 1
            b += right( "0" + hex$( cptr( ubyte ptr, r->data )[i] ), 2 ) + " "
        next
    end if
    print tag; " len="; n; " temp="; t; " shared="; sh; " ["; b; "]"
end sub

'' ---- ordering, NULL-as-empty, prefixes, embedded NULs
dim as string a = "abc", b2 = "abd", eq = "abc", emp = "", ab = "ab"
print "cmp abc abd  "; p_Cmp( @a, VARLEN, @b2, VARLEN )
print "cmp abd abc  "; p_Cmp( @b2, VARLEN, @a, VARLEN )
print "cmp abc abc  "; p_Cmp( @a, VARLEN, @eq, VARLEN )
print "cmp 0   abc  "; p_Cmp( 0, VARLEN, @a, VARLEN )
print "cmp abc 0    "; p_Cmp( @a, VARLEN, 0, VARLEN )
print "cmp 0   0    "; p_Cmp( 0, VARLEN, 0, VARLEN )
print "cmp ''  abc  "; p_Cmp( @emp, VARLEN, @a, VARLEN )
print "cmp abc ''   "; p_Cmp( @a, VARLEN, @emp, VARLEN )
print "cmp ''  ''   "; p_Cmp( @emp, VARLEN, @emp, VARLEN )
print "cmp ab  abc  "; p_Cmp( @ab, VARLEN, @a, VARLEN )
dim as string n1 = "a" + chr(0) + "b", n2 = "a" + chr(0) + "c"
print "cmp a0b a0c  "; p_Cmp( @n1, VARLEN, @n2, VARLEN )
print "cmp a0c a0b  "; p_Cmp( @n2, VARLEN, @n1, VARLEN )

'' ---- FIX decoding: a zstring*12 holding 6 characters equals "abcdef"
dim as zstring * 12 z12 = "abcdef"
dim as string six = "abcdef", five = "abcde"
print "cmp z12 abcdef "; p_Cmp( @z12, 12, @six, VARLEN )
print "cmp abcdef z12 "; p_Cmp( @six, VARLEN, @z12, 12 )
print "cmp z12 abcde  "; p_Cmp( @z12, 12, @five, VARLEN )
print "cmp zptr abcdef "; p_Cmp( strptr(z12), 0, @six, VARLEN )

'' ---- both operands consumed
function mkTemp( byval ch as integer, byval n as integer ) as FBC.FBSTRING ptr
    dim as FBC.FBSTRING ptr t = p_AllocTemp( 0, n )
    for i as integer = 0 to n - 1 : t->data[i] = ch : next
    t->data[n] = 0
    return t
end function

dim as FBC.FBSTRING ptr t1 = mkTemp( 97, 3 ), t2 = mkTemp( 97, 3 )
dim as long c1 = p_Cmp( t1, VARLEN, t2, VARLEN )
dim as integer l1 = LN(t1), h1 = iif(t1->data=0,0,1), l2 = LN(t2), h2 = iif(t2->data=0,0,1)
print "cmp temp temp "; c1; " left len="; l1; " data="; h1; " right len="; l2; " data="; h2

'' a non-temporary must survive
dim as string keep = "abc"
p_Cmp( cptr( FBC.FBSTRING ptr, @keep ), VARLEN, cptr( FBC.FBSTRING ptr, @keep ), VARLEN )
print "non-temp survives len="; len( keep ); " ["; keep; "]"

'' ---- STRING()
showr( "Fill1 5 x   ", p_Fill1( 5, asc("x") ) )
showr( "Fill1 0 x   ", p_Fill1( 0, asc("x") ) )
showr( "Fill1 -3 x  ", p_Fill1( -3, asc("x") ) )
showr( "Fill1 3 nul ", p_Fill1( 3, 0 ) )
showr( "Fill1 1 FF  ", p_Fill1( 1, 255 ) )
dim as string src = "xyz"
showr( "Fill2 4 xyz ", p_Fill2( 4, cptr( FBC.FBSTRING ptr, @src ) ) )
showr( "Fill2 0 xyz ", p_Fill2( 0, cptr( FBC.FBSTRING ptr, @src ) ) )
showr( "Fill2 3 ''  ", p_Fill2( 3, cptr( FBC.FBSTRING ptr, @emp ) ) )
showr( "Fill2 3 NULL", p_Fill2( 3, 0 ) )
showr( "Fill2 -1 xyz", p_Fill2( -1, cptr( FBC.FBSTRING ptr, @src ) ) )

dim as FBC.FBSTRING ptr t3 = mkTemp( 122, 3 )
dim as FBC.FBSTRING ptr f = p_Fill2( 2, t3 )
dim as integer l3 = LN(t3), h3 = iif(t3->data=0,0,1)
showr( "Fill2 2 temp", f )
print "  source after len="; l3; " data="; h3

'' Fill2 must release a temporary even when the count makes the result empty
dim as FBC.FBSTRING ptr t4 = mkTemp( 122, 3 )
p_Fill2( 0, t4 )
dim as integer l4 = LN(t4), h4 = iif(t4->data=0,0,1)
print "Fill2 0 temp: source after len="; l4; " data="; h4

'' ---- fb_StrDelete
dim as FBC.FBSTRING ptr t5 = mkTemp( 113, 4 )
p_Del( t5 )
print "Del temp     len="; LN(t5); " data="; iif(t5->data=0,0,1); " size="; cint(t5->size)
dim as FBC.FBSTRING ptr d = p_AllocTemp( 0, 4 )
d->len = LN(d)
p_Del( d )
print "Del non-temp len="; LN(d); " data="; iif(d->data=0,0,1); " size="; cint(d->size)
p_Del( 0 )
print "Del NULL survived"
