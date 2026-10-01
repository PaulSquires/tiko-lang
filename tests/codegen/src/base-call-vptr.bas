'' T48: a constructor that writes 'base( ... )' keeps its OWN vtable, and builds the
'' base, then its fields, then stores its vptr -- fbc's order.
type Part
    declare constructor( )
    id as long
end type
constructor Part( )
    print "  Part (a field) constructed"
end constructor

type Base1 extends Object
    declare constructor( byval n as long = 0 )
    declare virtual function Who( ) as string
    n as long
end type
constructor Base1( byval n as long )
    this.n = n
    print "  Base1 constructor, Who() = "; Who( )
end constructor
function Base1.Who( ) as string
    return "Base1"
end function

type Der1 extends Base1
    declare constructor( )
    declare function Who( ) as string override
    p as Part
    k as long = 42
end type
constructor Der1( )
    base( 7 )
    print "  Der1 body, Who() = "; Who( ); ", n ="; n; ", k ="; k
end constructor
function Der1.Who( ) as string
    return "Der1"
end function

'' Two levels, each with an explicit base( ), and 'virtual ... override' in the middle.
type Rect extends Object
    declare constructor( byval w as double = 1, byval h as double = 1 )
    declare virtual function Kind( ) as string
    w as double
    h as double
end type
constructor Rect( byval w as double, byval h as double )
    this.w = w : this.h = h
end constructor
function Rect.Kind( ) as string
    return "rect"
end function
type Square extends Rect
    declare constructor( byval s as double = 1 )
    declare virtual function Kind( ) as string override
end type
constructor Square( byval s as double )
    base( s, s )
end constructor
function Square.Kind( ) as string
    return "square"
end function
type Cube extends Square
    declare constructor( byval s as double )
    declare function Kind( ) as string override
end type
constructor Cube( byval s as double )
    base( s )
end constructor
function Cube.Kind( ) as string
    return "cube"
end function

dim as Der1 d1
dim as Base1 ptr bp = @d1
print "through Base1: "; bp->Who( )

dim as Square sq = Square( 2 )
dim as Cube cb = Cube( 3 )
dim as Rect ptr rs( 0 to 1 ) = { @sq, @cb }
print "through Rect: "; rs( 0 )->Kind( ); " "; rs( 1 )->Kind( ); rs( 1 )->w
dim as Rect ptr hp = new Cube( 4 )
print "new through Rect: "; hp->Kind( )
delete hp
