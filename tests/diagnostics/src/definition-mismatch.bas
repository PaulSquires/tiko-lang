'' A definition held to its declaration: result, then count, then each parameter.
type L as long
type U
    x as long
end type

declare function r1( byval a as long ) as long
function r1( byval a as long ) as double
    return 0
end function
declare function r2( ) as long
sub r2( )
end sub
declare sub c1( byval a as long )
sub c1( )
end sub
declare sub c2( byval a as long )
sub c2( byval a as long, byval b as long = 1 )
end sub
declare sub p1( byval a as long )
sub p1( byval a as double )
end sub
declare sub p2( byval a as long )
sub p2( byref a as long )
end sub
declare sub p3( byval a as const long )
sub p3( byval a as long )
end sub
declare sub p4( a( ) as long )
sub p4( byval a as long )
end sub
declare sub p5( byval a as long ptr )
sub p5( byval a as integer ptr )
end sub
declare sub p6( byval a as long, byval b as long )
sub p6( byval a as long, byval b as double )
end sub
declare function o1( byval a as long ) as long
function o1( ) as double
    return 0
end function
declare sub p7( u as U )
sub p7( byval u as U )
end sub
declare sub v1 overload( byval a as long )
sub v1( byref a as long )
end sub
extern "C"
declare sub x1( byval a as long )
end extern
sub x1( byval a as double )
end sub
declare sub va cdecl( byval a as long, ... )
sub va cdecl( byval a as double, ... )
end sub

'' accepted: a default or a name that differs, an alias, the implicit byref, a new overload
declare sub k1( byval a as long = 5 )
sub k1( byval b as long = 6 )
end sub
declare sub k2( byval a as L )
sub k2( byval a as long )
end sub
declare sub k3( s as string )
sub k3( s as string )
end sub
declare sub k4( s as string )
sub k4( byref s as string )
end sub
declare sub k5 overload( byval a as long )
sub k5( byval a as double )
end sub
declare sub k6( u as U )
sub k6( u as U )
end sub
declare function k7( byval a as U ptr ) as U ptr
function k7( byval b as U ptr ) as U ptr
    return b
end function

namespace N
    declare sub h( byval a as long )
    declare sub h2 overload( byval a as long )
end namespace
sub N.h( byval a as double )
end sub
sub N.h2( byval a as double )
end sub

type T
    x as long
    declare sub f( byval a as long )
    declare function g( ) as long
    declare sub m( byval a as long )
    declare operator cast( ) as long
    declare constructor( byval a as long )
    declare property p( ) as long
    declare sub ok( byval a as long, s as string )
    declare property q( byval i as long ) as long
    declare property q( byval v as long )
    declare property w( ) as long
    declare property w( byval v as long )
end type
sub T.f( byval a as double )
end sub
sub T.g( )
end sub
sub T.m( byref a as long )
end sub
operator T.cast( ) as double
    return 0
end operator
constructor T( byval a as double )
end constructor
property T.p( ) as double
    return 0
end property
sub T.ok( byval a as long, s as string )
end sub
property T.q( byval i as long ) as long
    return 0
end property
property T.q( byval v as long )
end property
property T.w( ) as long
    return 0
end property
property T.w( byval v as double )
end property

'' 'byref as any' in the declaration takes any type -- but not any mode
declare sub k8( byref p as any )
sub k8( byref p as long )
end sub
declare sub p8( byref p as any )
sub p8( byval p as long )
end sub
