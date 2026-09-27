'' 'dim as T x = a( k )' copy-constructs x from the element. See
'' tests/mir/copy-init-from-element.test.

type pt
    as single x, y, z
end type

type Craft
    as pt p( any )
    as pt ctr
    declare constructor( )
    declare constructor( byval n as long )
end type

constructor Craft( )
end constructor

constructor Craft( byval n as long )
    redim p( n )
    ctr.z = n
end constructor

sub fromParam( array( ) as Craft, byval k as long )
    dim as Craft px = array( k )
    print ubound( px.p )
end sub

dim as Craft a( 1 to 2 )
a( 1 ) = Craft( 3 )
dim as long k = 1

scope
    dim as Craft cx = a( 1 )
    print ubound( cx.p )
end scope
scope
    dim as Craft vx = a( k )
    print ubound( vx.p )
end scope
fromParam( a( ), 1 )
erase a
