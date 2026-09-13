'' AN ARGUMENT TO A PROCEDURE POINTER CONVERTS TO ITS PARAMETER, OR THE CALL IS REFUSED --
'' fbc's error 58, "Type mismatch", on every line of 'refused', each measured on its own.
'' A string does not become a number, an enum or a non-character pointer; a number or a
'' pointer does not become a string; a UDT with no constructor is built from nothing but
'' itself, and one with no CAST does not become a number; and a BYREF number binds only a
'' named number of its own width and kind -- a literal or an expression is a temporary.
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
end type
enum E
    E1
end enum

'' -- refused ------------------------------------------------------------------
sub refused( )
    dim fi as function( byval as integer ) as integer
    dim fsg as function( byval as single ) as integer
    dim fe as function( byval as E ) as integer
    dim fip as function( byval as integer ptr ) as integer
    dim fanyp as function( byval as any ptr ) as integer
    dim fstr as function( byval as string ) as integer
    dim frs as function( byref as string ) as integer
    dim fzr as function( byref as zstring ) as integer
    dim fr as function( byref as integer ) as integer
    dim frd as function( byref as double ) as integer
    dim fu as function( byval as U ) as integer
    dim as integer x, la(2)
    dim as long l, lb(2)
    dim as long ptr pl
    dim as byte b
    dim as boolean bo
    dim as double d
    dim as single sg
    dim as string s
    dim as string * 5 fs5
    dim as zstring ptr pz
    dim as wstring * 8 ws
    dim as TL t1
    dim as U u1
    x = fi( "x" )
    x = fi( s )
    x = fi( fs5 )
    x = fi( *pz )
    x = fi( ws )
    x = fsg( "x" )
    x = fe( "x" )
    x = fip( s )
    x = fanyp( ws )
    x = fstr( 1 )
    x = fstr( d )
    x = fstr( pz )
    x = fstr( @x )
    x = frs( 1 )
    x = frs( pz )
    x = fzr( 1 )
    x = fr( d )
    x = fr( sg )
    x = fr( l )
    x = fr( b )
    x = fr( bo )
    x = fr( t1.f )
    x = fr( lb(0) )
    x = fr( *pl )
    x = frd( x )
    x = fr( s )
    x = fu( 1 )
    x = fi( u1 )
end sub

'' -- accepted -----------------------------------------------------------------
sub accepted( )
    dim fi as function( byval as integer ) as integer
    dim fstr as function( byval as string ) as integer
    dim fr as function( byref as integer ) as integer
    dim fwp as function( byval as wstring ptr ) as integer
    dim fz as function( byval as zstring ptr ) as integer
    dim fzr as function( byref as zstring ) as integer
    dim fanyp as function( byval as any ptr ) as integer
    dim fu as function( byval as U ) as integer
    dim fuc as function( byval as UC ) as integer
    dim as integer x
    dim as uinteger ui
    dim as boolean bo
    dim as E e1
    dim as double d
    dim as string s
    dim as string * 5 fs5
    dim as zstring * 8 zz
    dim as zstring ptr pz
    dim as wstring * 8 ws
    dim as U u1
    dim as UK k1
    const ci as integer = 3
    x = fi( d )
    x = fr( 1 )
    x = fr( ui )
    x = fr( x + 1 )
    x = fr( d + 1 )
    x = fr( e1 )
    x = fr( ci )
    x = fi( bo )
    x = fi( e1 )
    x = fi( len( "x" ) )
    x = fstr( ws )
    x = fstr( fs5 )
    x = fstr( zz )
    x = fwp( s )
    x = fz( s )
    x = fz( "abc" )
    x = fzr( s )
    x = fanyp( pz )
    x = fuc( 1 )
    x = fi( k1 )
    x = fu( u1 )
end sub
