'' '@f' and 'procptr( f )' over an overload set take the overload the target's type names:
'' a store, an initialiser, an argument, a field and a typedef'd target.
sub f overload( byval a as long )
    print "f long"; a
end sub
sub f overload( byval a as double )
    print "f double"; a
end sub
function g overload( byval a as long ) as string
    return "g long" & a
end function
function g overload( byref s as string ) as string
    return "g string " & s
end function
type FD as sub( byval as double )
sub take( byval cb as FD )
    cb( 2.5 )
end sub
type Holder
    cb as FD
end type
dim p1 as sub( byval as double )
p1 = @f
p1( 1.5 )
take( @f )
dim p5 as FD = @f
p5( 3.5 )
dim h as Holder
h.cb = @f
h.cb( 4.5 )
dim p6 as sub( byval as double ) = procptr( f )
p6( 5.5 )
dim p7 as sub( byval as long ) = @f
p7( 7 )
dim q as function( byref as string ) as string = @g
print q( "x" )
dim q2 as function( byval as long ) as string = @g
print q2( 9 )
