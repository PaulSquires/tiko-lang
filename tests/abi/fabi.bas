type S1 : a as byte : end type
type S2 : a as short : end type
type S3 : a as byte : b as byte : c as byte : end type
type S4f : f as single : end type
type S5 : a(0 to 4) as byte : end type
type S6 : a(0 to 2) as short : end type
type S8f : a as single : b as single : end type
type S8d : d as double : end type
type S8m : a as single : b as long : end type
type S9 : a(0 to 8) as byte : end type
type S12f : a as single : b as single : c as single : end type
type S12i : a as long : b as long : c as long : end type
type S13 : a(0 to 12) as byte : end type
type S16d : a as double : b as double : end type
type S16m : a as double : b as longint : end type
type S16ffd : a as single : b as single : c as double : end type
type S17 : a(0 to 16) as byte : end type
type S24 : a as double : b as double : c as double : end type
union U4 : i as long : f as single : end union
union U8 : d as double : q as longint : end union
type SArr : a(0 to 2) as single : b as long : end type

extern "C"
declare function mod_S1( byval k as long, byval x as S1 ) as S1
declare function mod_S2( byval k as long, byval x as S2 ) as S2
declare function mod_S3( byval k as long, byval x as S3 ) as S3
declare function mod_S4f( byval k as long, byval x as S4f ) as S4f
declare function mod_S5( byval k as long, byval x as S5 ) as S5
declare function mod_S6( byval k as long, byval x as S6 ) as S6
declare function mod_S8f( byval k as long, byval x as S8f ) as S8f
declare function mod_S8d( byval k as long, byval x as S8d ) as S8d
declare function mod_S8m( byval k as long, byval x as S8m ) as S8m
declare function mod_S9( byval k as long, byval x as S9 ) as S9
declare function mod_S12f( byval k as long, byval x as S12f ) as S12f
declare function mod_S12i( byval k as long, byval x as S12i ) as S12i
declare function mod_S13( byval k as long, byval x as S13 ) as S13
declare function mod_S16d( byval k as long, byval x as S16d ) as S16d
declare function mod_S16m( byval k as long, byval x as S16m ) as S16m
declare function mod_S16ffd( byval k as long, byval x as S16ffd ) as S16ffd
declare function mod_S17( byval k as long, byval x as S17 ) as S17
declare function mod_S24( byval k as long, byval x as S24 ) as S24
declare function mod_U4( byval k as long, byval x as U4 ) as U4
declare function mod_U8( byval k as long, byval x as U8 ) as U8
declare function mod_SArr( byval k as long, byval x as SArr ) as SArr
declare function fmix( byval a as single, byval b as double, byval c as long, byval d as single, _
    byval e as byte, byval f as short, byval g as single, byval h as double, byval i as single ) as double
declare function vsum( byval n as long, ... ) as double
declare function vsumi( byval n as long, ... ) as longint
declare function call_cb( byval f as function cdecl ( byval as S12f, byval as single, byval as S3 ) as S12f ) as double
declare function call_cb16( byval f as function cdecl ( byval as long, byval as S16d, byval as S5 ) as S16d ) as double
declare function many( byval a as S16d, byval b as S16d, byval c as S16d, byval d as S16d, _
    byval e as S16d, byval f as S12f, byval g as S8f, byval h as long ) as double
end extern

function cbA cdecl ( byval x as S12f, byval s as single, byval y as S3 ) as S12f
    dim r as S12f
    r.a = x.a + s + y.a
    r.b = x.b + s + y.b
    r.c = x.c + s + y.c
    return r
end function

function cbB cdecl ( byval k as long, byval x as S16d, byval y as S5 ) as S16d
    dim r as S16d
    r.a = x.a + k + y.a(0) + y.a(4)
    r.b = x.b + k + y.a(2)
    return r
end function

dim v1 as S1 : v1.a = 10 : v1 = mod_S1( 1, v1 ) : print "S1"; v1.a
dim v2 as S2 : v2.a = 1000 : v2 = mod_S2( 1, v2 ) : print "S2"; v2.a
dim v3 as S3 : v3.a = 1 : v3.b = 2 : v3.c = 3 : v3 = mod_S3( 10, v3 ) : print "S3"; v3.a; v3.b; v3.c
dim v4 as S4f : v4.f = 1.5 : v4 = mod_S4f( 2, v4 ) : print "S4f"; v4.f
dim v5 as S5 : for i as long = 0 to 4 : v5.a(i) = i : next : v5 = mod_S5( 20, v5 )
print "S5"; : for i as long = 0 to 4 : print v5.a(i); : next : print
dim v6 as S6 : for i as long = 0 to 2 : v6.a(i) = i * 100 : next : v6 = mod_S6( 7, v6 )
print "S6"; : for i as long = 0 to 2 : print v6.a(i); : next : print
dim v8f as S8f : v8f.a = 1.25 : v8f.b = 2.5 : v8f = mod_S8f( 3, v8f ) : print "S8f"; v8f.a; v8f.b
dim v8d as S8d : v8d.d = 0.5 : v8d = mod_S8d( 4, v8d ) : print "S8d"; v8d.d
dim v8m as S8m : v8m.a = 0.75 : v8m.b = 9 : v8m = mod_S8m( 5, v8m ) : print "S8m"; v8m.a; v8m.b
dim v9 as S9 : for i as long = 0 to 8 : v9.a(i) = i : next : v9 = mod_S9( 30, v9 )
print "S9"; : for i as long = 0 to 8 : print v9.a(i); : next : print
dim v12f as S12f : v12f.a = 1 : v12f.b = 2 : v12f.c = 3 : v12f = mod_S12f( 6, v12f ) : print "S12f"; v12f.a; v12f.b; v12f.c
dim v12i as S12i : v12i.a = 1 : v12i.b = 2 : v12i.c = 3 : v12i = mod_S12i( 7, v12i ) : print "S12i"; v12i.a; v12i.b; v12i.c
dim v13 as S13 : for i as long = 0 to 12 : v13.a(i) = i : next : v13 = mod_S13( 40, v13 )
print "S13"; : for i as long = 0 to 12 : print v13.a(i); : next : print
dim v16d as S16d : v16d.a = 1.5 : v16d.b = 2.5 : v16d = mod_S16d( 8, v16d ) : print "S16d"; v16d.a; v16d.b
dim v16m as S16m : v16m.a = 1.5 : v16m.b = 123456789012 : v16m = mod_S16m( 9, v16m ) : print "S16m"; v16m.a; v16m.b
dim v16x as S16ffd : v16x.a = 1 : v16x.b = 2 : v16x.c = 3 : v16x = mod_S16ffd( 10, v16x ) : print "S16ffd"; v16x.a; v16x.b; v16x.c
dim v17 as S17 : for i as long = 0 to 16 : v17.a(i) = i : next : v17 = mod_S17( 50, v17 )
print "S17"; : for i as long = 0 to 16 : print v17.a(i); : next : print
dim v24 as S24 : v24.a = 1 : v24.b = 2 : v24.c = 3 : v24 = mod_S24( 11, v24 ) : print "S24"; v24.a; v24.b; v24.c
dim u4 as U4 : u4.i = 100 : u4 = mod_U4( 12, u4 ) : print "U4"; u4.i
dim u8 as U8 : u8.q = 1000 : u8 = mod_U8( 13, u8 ) : print "U8"; u8.q
dim va as SArr : va.a(0) = 1 : va.a(1) = 2 : va.a(2) = 3 : va.b = 4 : va = mod_SArr( 14, va )
print "SArr"; va.a(0); va.a(1); va.a(2); va.b
print "fmix"; fmix( 1, 2, 3, 4, 5, 6, 7, 8, 9 )
dim fs as single = 1.5
dim fd as double = 2.25
print "vsum"; vsum( 3, 1.0, fd, cdbl( fs ) )
print "vsumS"; vsum( 1, fs )
dim bb as byte = 3
dim ss as short = 4
print "vsumi"; vsumi( 4, 1, 2, bb, ss )
print "cb"; call_cb( @cbA )
print "cb16"; call_cb16( @cbB )
dim m1 as S16d : m1.a = 1 : m1.b = 2
dim m2 as S12f : m2.c = 3
dim m3 as S8f : m3.b = 4
print "many"; many( m1, m1, m1, m1, m1, m2, m3, 5 )
