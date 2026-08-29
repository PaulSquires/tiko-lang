'' trim-mid-parity.bas -- fb_TRIM / fb_LTRIM / fb_RTRIM / fb_StrMid.
''
'' Run against fbc's runtime and again against tiko-rt's; the two outputs must be
'' byte-identical. Every line here restates something PROBE-30/31/32 MEASURED,
'' so a divergence names the contract it broke rather than just failing.
''
'' Captures into locals before printing: PRINT allocates temporaries, and one of
'' them will reclaim a just-freed pool slot before a later check can read it.
'' That instrument perturbed its subject twice already in this project.
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
    declare function p_AllocTemp alias "fb_hStrAllocTemp" ( byval s as FBC.FBSTRING ptr, byval n as integer ) as FBC.FBSTRING ptr
    declare function p_Trim  alias "fb_TRIM"   ( byval s as FBC.FBSTRING ptr ) as FBC.FBSTRING ptr
    declare function p_LTrim alias "fb_LTRIM"  ( byval s as FBC.FBSTRING ptr ) as FBC.FBSTRING ptr
    declare function p_RTrim alias "fb_RTRIM"  ( byval s as FBC.FBSTRING ptr ) as FBC.FBSTRING ptr
    declare function p_Mid   alias "fb_StrMid" ( byval s as FBC.FBSTRING ptr, byval st as integer, byval ln as integer ) as FBC.FBSTRING ptr
end extern

#define LN(p) cint( (p)->len and &h7fffffffffffffff )

sub show( byref tag as string, byval r as FBC.FBSTRING ptr )
    if( r = 0 ) then print tag; " NULL" : exit sub
    dim as integer n = LN(r)
    dim as integer t = iif( r->len < 0, 1, 0 )
    dim as integer shared_ = iif( r = @__fb_ctx.nulldesc, 1, 0 )
    dim as string b = ""
    if( r->data <> 0 ) then
        for i as integer = 0 to n - 1
            b += right( "0" + hex$( cptr( ubyte ptr, r->data )[i] ), 2 ) + " "
        next
    end if
    print tag; " len="; n; " temp="; t; " shared="; shared_; " ["; b; "]"
end sub

'' ---- only 0x20 is trimmed (PROBE-30); nothing else in the whitespace family
dim as string ws = chr(32,9,10,11,12,13) + "X" + chr(13,12,11,10,9,32)
show( "TRIM  ws ", p_Trim ( cptr( FBC.FBSTRING ptr, @ws ) ) )
show( "LTRIM ws ", p_LTrim( cptr( FBC.FBSTRING ptr, @ws ) ) )
show( "RTRIM ws ", p_RTrim( cptr( FBC.FBSTRING ptr, @ws ) ) )

'' ---- NUL. fbc's own string/trim.bas says it outright:
''       "default is to trim chr(32) from left and right and chr(0) ONLY FROM RIGHT"
'' PROBE-30 asked about the whitespace family -- tab, LF, VT, FF, CR -- and never
'' about chr(0), because a NUL in a printed string is invisible. The dump below is
'' hex for exactly that reason.
dim as string zt  = chr(0) + "abc" + chr(0)
dim as string zzt = chr(0,0) + "abc" + chr(0,0)
dim as string szs = chr(32,0) + "abc" + chr(0,32)
show( "TRIM  0t0", p_Trim ( cptr( FBC.FBSTRING ptr, @zt  ) ) )
show( "TRIM 00t00", p_Trim ( cptr( FBC.FBSTRING ptr, @zzt ) ) )
show( "TRIM s0t0s", p_Trim ( cptr( FBC.FBSTRING ptr, @szs ) ) )
show( "RTRIM 0t0 ", p_RTrim( cptr( FBC.FBSTRING ptr, @zt  ) ) )
show( "LTRIM 0t0 ", p_LTrim( cptr( FBC.FBSTRING ptr, @zt  ) ) )

'' ---- an empty result is the SHARED descriptor, not NULL and not a fresh one
dim as string sp = "     ", emp = "", plain = "abcdef"
show( "TRIM  sp ", p_Trim ( cptr( FBC.FBSTRING ptr, @sp  ) ) )
show( "TRIM  '' ", p_Trim ( cptr( FBC.FBSTRING ptr, @emp ) ) )
show( "TRIM  0  ", p_Trim ( 0 ) )
show( "LTRIM 0  ", p_LTrim( 0 ) )
show( "RTRIM 0  ", p_RTrim( 0 ) )
'' a no-op trim still COPIES -- never the source descriptor back
show( "TRIM  ab ", p_Trim ( cptr( FBC.FBSTRING ptr, @plain ) ) )

'' ---- fb_StrMid: 1-based, any negative length means "to the end", clamped
#macro M( a, b )
    show( "MID " + str(a) + "," + str(b) + " ", p_Mid( cptr( FBC.FBSTRING ptr, @plain ), a, b ) )
#endmacro
M(  1,  3 )
M(  3,  2 )
M(  6, 99 )
M(  1, 99 )
M(  2, -1 )
M(  2, -5 )
M(  0,  3 )
M( -1,  3 )
M(  7,  3 )
M(  2,  0 )
show( "MID NULL ", p_Mid( 0, 1, 1 ) )

'' ---- operand consumption, on every one of the four entry points
function mkTemp( ) as FBC.FBSTRING ptr
    dim as FBC.FBSTRING ptr t = p_AllocTemp( 0, 8 )
    dim as zstring ptr d = t->data
    d[0]=32 : d[1]=32 : d[2]=97 : d[3]=98 : d[4]=99 : d[5]=32 : d[6]=32 : d[7]=32 : d[8]=0
    return t
end function

dim as integer l(0 to 3), h(0 to 3), tb(0 to 3)
dim as FBC.FBSTRING ptr t = any

t = mkTemp( ) : p_Trim ( t ) : l(0)=LN(t) : h(0)=iif(t->data=0,0,1) : tb(0)=iif(t->len<0,1,0)
t = mkTemp( ) : p_LTrim( t ) : l(1)=LN(t) : h(1)=iif(t->data=0,0,1) : tb(1)=iif(t->len<0,1,0)
t = mkTemp( ) : p_RTrim( t ) : l(2)=LN(t) : h(2)=iif(t->data=0,0,1) : tb(2)=iif(t->len<0,1,0)
t = mkTemp( ) : p_Mid  ( t, 3, 3 ) : l(3)=LN(t) : h(3)=iif(t->data=0,0,1) : tb(3)=iif(t->len<0,1,0)

for i as integer = 0 to 3
    print "operand after ["; i; "] len="; l(i); " data="; h(i); " temp="; tb(i)
next

'' a degenerate call must release the operand too -- this is where bugs 12-15 hid
'' CAPTURE BEFORE PRINTING -- the rule this file states at the top, and this
'' line originally broke it. PRINT allocates temporaries, one of which reclaims
'' the slot MID just released, so reading t inside the PRINT sees a RECYCLED
'' descriptor: len=32, data non-NULL, and a released operand looks like a leaked
'' one. build/diff.sh reported it as a runtime difference until the read moved
'' out of the PRINT. Third time in this project that the instrument perturbed
'' its subject.
t = mkTemp( ) : p_Mid( t, 0, 3 )
dim as integer dl = LN(t), dh = iif( t->data = 0, 0, 1 )
print "operand after MID(temp,0,3) len="; dl; " data="; dh
t = mkTemp( ) : p_Trim( p_Trim( t ) )
print "nested TRIM survives"

'' a non-temporary must be left alone by all four
dim as string keep = "  xy  "
p_Trim ( cptr( FBC.FBSTRING ptr, @keep ) )
p_LTrim( cptr( FBC.FBSTRING ptr, @keep ) )
p_RTrim( cptr( FBC.FBSTRING ptr, @keep ) )
p_Mid  ( cptr( FBC.FBSTRING ptr, @keep ), 1, 2 )
print "non-temp survives: len="; len( keep ); " ["; keep; "]"
