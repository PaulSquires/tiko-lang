'' A CALL THROUGH A PROCEDURE POINTER TAKES THE POINTER'S PARAMETERS. fbc refuses one
'' argument too many and an omitted one with no default -- error 1, or 7 when the
'' pointer takes none -- and takes a default from the pointer's own declaration.
function g( byval i as integer ) as integer
    return i
end function
function g2( byval i as integer, byval j as integer = 7 ) as integer
    return i + j
end function
function g0( ) as integer
    return 1
end function
sub sb( byval i as integer )
end sub
type FP as function( byval as integer ) as integer
type FP2 as function( byval as integer, byval as integer = 7 ) as integer
function h( byval i as integer ) as FP
    return @g
end function
type T
    f as FP
    s as sub( byval c as long, byval v as long = 123 )
end type

'' -- refused ------------------------------------------------------------------
sub refused( byval pf as FP )
    dim as FP fp = @g
    dim as FP ptr pfp = @fp
    dim as FP fa(1)
    dim as FP2 fp2 = @g2
    dim as function( ) as integer fp0 = @g0
    dim as sub( byval as integer ) sp = @sb
    dim as T t1
    dim as integer x
    x = fp( )
    x = fp( 1, 2 )
    x = (fp)( )
    x = (*pfp)( )
    x = fa(0)( )
    x = h( 1 )( )
    x = t1.f( )
    x = pf( )
    x = fp2( )
    x = fp2( 1, 2, 3 )
    x = fp0( 1 )
    x = fp( , )
    sp( )
    sp( 1, 2 )
end sub

'' -- accepted -----------------------------------------------------------------
sub accepted( byval pf as function( byval a as long = 4 ) as long )
    dim as FP2 fp2 = @g2
    dim as FP2 ptr pfp2 = @fp2
    dim as function( ) as integer fp0 = @g0
    dim as T t1
    var pg2 = procptr( g2 )
    dim as integer x
    x = fp2( 1 )
    x = fp2( 1, 2 )
    x = (*pfp2)( 1 )
    x = pfp2[0]( 1 )
    x = fp0( )
    x = pg2( 1 )
    x = pf( )
    t1.s( 5 )
end sub
