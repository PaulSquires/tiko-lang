'' A PROCEDURE CALLED BY NAME TAKES ITS PARAMETERS -- fbc's error 1 for the count, 7 for an
'' argument to a procedure that takes none, and 58 for a type, on every line of 'refused',
'' each measured on its own. tiko's overload resolution scored these unviable and bound
'' nothing, and reports that only for an OVERLOAD SET, so every one declined in silence.
type U
    v as integer
end type
type UC
    v as integer
    declare constructor( byval i as integer )
end type
constructor UC( byval i as integer )
    v = i
end constructor
type UK
    v as integer
    declare operator cast( ) as integer
end type
operator UK.cast( ) as integer
    return v
end operator
type TL
    f as long
    declare sub m( byval i as integer )
    declare static sub sm( byval i as integer, byval j as integer = 2 )
end type
sub TL.m( byval i as integer )
end sub
sub TL.sm( byval i as integer, byval j as integer = 2 )
end sub
enum E
    E1
end enum
function gi( byval i as integer ) as integer
    return i
end function
function gi2( byval i as integer, byval j as integer = 7 ) as integer
    return i + j
end function
function g0( ) as integer
    return 0
end function
function gsg( byval a as single ) as integer
    return 0
end function
function gen( byval a as E ) as integer
    return 0
end function
function gstr( byval a as string ) as integer
    return 0
end function
function gsu( a as string ) as integer
    return 0
end function
function gzr( byref a as zstring ) as integer
    return 0
end function
function gr( byref a as integer ) as integer
    return 0
end function
function grc( byref a as const integer ) as integer
    return 0
end function
function gu( byval a as U ) as integer
    return 0
end function
function guc( byval a as UC ) as integer
    return 0
end function
function gz( byval a as zstring ptr ) as integer
    return 0
end function
function gcv cdecl( byval a as integer, ... ) as integer
    return 0
end function

'' -- refused ------------------------------------------------------------------
sub refused( )
    dim as integer x
    dim as long l
    dim as double d
    dim as string s
    dim as zstring ptr pz
    dim as wstring * 8 ws
    dim as TL t1
    dim as U u1
    x = gi( )
    x = gi( 1, 2 )
    x = gi( , )
    x = gi2( , 1 )
    x = g0( 1 )
    x = gcv( )
    t1.m( )
    t1.m( 1, 2 )
    TL.sm( )
    t1.sm( 1, 2, 3 )
    x = gi( "x" )
    x = gi( s )
    x = gi( ws )
    x = gsg( "x" )
    x = gen( "x" )
    x = gstr( d )
    x = gstr( pz )
    x = gsu( 1 )
    x = gzr( 1 )
    x = gr( d )
    x = gr( l )
    x = grc( l )
    x = gu( 1 )
    x = gi( u1 )
    t1.m( "x" )
end sub

'' -- accepted -----------------------------------------------------------------
sub accepted( )
    dim as integer x
    dim as uinteger ui
    dim as double d
    dim as string s
    dim as wstring * 8 ws
    dim as TL t1
    dim as U u1
    dim as UK k1
    x = gi2( 1 )
    x = gi2( 1, )
    x = g0( )
    x = gcv( 1, 2, 3 )
    TL.sm( 1 )
    t1.m( 1 )
    x = gi( d )
    x = gr( 1 )
    x = gr( ui )
    x = gr( x + 1 )
    x = gstr( ws )
    x = gz( s )
    x = guc( 1 )
    x = gi( k1 )
    x = gu( u1 )
end sub
