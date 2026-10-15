' bitfield-c-signed.bas -- a SIGNED bit-field of an 'extern "c"' record reads as C reads it:
' sign-extended, so -1 in 'x : 3 as long' is -1, not fbc's 7. Every field is written, read
' back, used in arithmetic and a comparison, and stepped by a compound operator; the expected
' output is a C twin's, compiled by clang for x86_64-pc-windows-msvc. The last record is NOT
' 'extern "c"' and keeps fbc's zero extension (fbc 1.20: -1 in 'a : 3 as byte' reads 7).

type s_mixed extern "c"
    a : 3 as byte
    b : 5 as long
end type
type s_wide extern "c"
    q : 40 as longint
    r : 10 as long
end type
type s_one extern "c"
    f : 1 as long
    g : 31 as long
end type
type s_sign_mix extern "c"
    u : 3 as ulong
    s : 3 as long
    h : 6 as short
end type
type s_pack1 field = 1 extern "c"
    p as ubyte
    a : 20 as long
    b : 14 as short
end type
union s_union extern "c"
    a : 3 as byte
    b : 7 as long
end union
type s_fbc
    a : 3 as byte
    b : 5 as long
end type

sub show( byref nm as string, byval v as longint )
    print nm & " " & str( v )
end sub

dim as s_mixed m
m.a = -1 : m.b = -16
show( "s_mixed a", m.a ) : show( "s_mixed b", m.b )
m.a = 3 : m.b = 15
show( "s_mixed a", m.a ) : show( "s_mixed b", m.b )
m.a = 5 : m.b = 17
show( "s_mixed a", m.a ) : show( "s_mixed b", m.b )
m.a = -4
show( "s_mixed a-1", m.a - 1 )
show( "s_mixed a<0", iif( m.a < 0, 1, 0 ) )
m.a -= 1
show( "s_mixed a-=1", m.a )
m.b = -1 : m.b += 1
show( "s_mixed b+=1", m.b )
dim as long lv = m.a
show( "s_mixed long", lv )
dim as double dv = m.b - 0.5
show( "s_mixed double*2", clngint( dv * 2 ) )

dim as s_wide w
w.q = -1 : w.r = -512
show( "s_wide q", w.q ) : show( "s_wide r", w.r )
w.q = -549755813888 : w.r = 511
show( "s_wide q", w.q ) : show( "s_wide r", w.r )
w.q = -123456789012
show( "s_wide q", w.q )

dim as s_one o
o.f = 1 : o.g = -1073741824
show( "s_one f", o.f ) : show( "s_one g", o.g )
o.f = 0 : o.g = 1073741823
show( "s_one f", o.f ) : show( "s_one g", o.g )

dim as s_sign_mix sm
sm.u = 7 : sm.s = 7 : sm.h = -32
show( "s_sign_mix u", sm.u ) : show( "s_sign_mix s", sm.s ) : show( "s_sign_mix h", sm.h )
sm.u = -1 : sm.s = -1 : sm.h = 31
show( "s_sign_mix u", sm.u ) : show( "s_sign_mix s", sm.s ) : show( "s_sign_mix h", sm.h )

dim as s_pack1 pk
pk.p = 255 : pk.a = -524288 : pk.b = -8192
show( "s_pack1 a", pk.a ) : show( "s_pack1 b", pk.b ) : show( "s_pack1 p", pk.p )
pk.a = 524287 : pk.b = -1
show( "s_pack1 a", pk.a ) : show( "s_pack1 b", pk.b )
dim as s_pack1 ptr pp = @pk
show( "s_pack1 ptr b", pp->b )

dim as s_union un
un.b = 92
show( "s_union a", un.a ) : show( "s_union b", un.b )
un.b = -1
show( "s_union a", un.a ) : show( "s_union b", un.b )

dim as s_fbc fb
fb.a = -1 : fb.b = -1
show( "s_fbc a", fb.a ) : show( "s_fbc b", fb.b )
