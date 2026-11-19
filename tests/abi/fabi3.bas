'' fabi3.bas -- tiko's int128 / uint128 against C's __int128 (cabi3.c). Values are printed as
'' their two 64-bit halves in hex, so this program needs nothing from the runtime that an older
'' tiko-rt lacks.

type S3
    c as byte
    v as int128
end type

extern "C"
declare function c3_mul( byval a as int128, byval b as int128, byval k as long ) as int128
declare function c3_shr( byval x as uint128, byval n as long ) as uint128
declare function c3_mix( byval a as long, byval b as int128, byval d as double, byval c as int128, byval e as longint ) as int128
declare function c3_many( byval a as int128, byval b as int128, byval c as int128, byval d as int128, byval e as int128 ) as int128
declare function c3_field( byval p as S3 ptr ) as int128
declare function c3_make( byval v as int128 ) as S3
declare function c3_take( byval s as S3 ) as int128
declare function c3_calls( byval v as int128 ) as int128
declare function c3_sizeof( ) as long
declare function c3_offsetof( ) as long
end extern

function t3_twice cdecl alias "T3_TWICE" ( byval v as int128 ) as int128
    return v * 2
end function

sub show( byref label as string, byval v as int128 )
    print label; " "; hex( culngint( v shr 64 ), 16 ); " "; hex( culngint( v and &hFFFFFFFFFFFFFFFFull ), 16 )
end sub

dim as int128 big = (cast( int128, 1 ) shl 80) + 3
show "mul", c3_mul( big, -2, 5 )
show "shr", c3_shr( cast( uint128, big ) shl 40, 100 )
show "mix", c3_mix( 1, big, 2.0, -big, 7 )
show "many", c3_many( big, 1, 2, 3, big )
dim as S3 s
s.c = 4
s.v = -big
show "field", c3_field( @s )
dim as S3 m = c3_make( big )
print "make.c"; m.c
show "make.v", m.v
show "take", c3_take( s )
show "calls", c3_calls( big )
print "sizeof"; c3_sizeof( ); sizeof( S3 )
print "offsetof"; c3_offsetof( ); offsetof( S3, v )
dim fp as function cdecl ( byval as int128, byval as int128, byval as long ) as int128 = @c3_mul
show "ptr", fp( 3, 4, 1 )
