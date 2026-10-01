'' T46: text passed through 'base( ... )' arrives intact -- byref and byval, string and
'' wstring, a variable, a literal, an expression, and with a parameter left to its default.
'' And a byref UDT still passes its address.
type Pt
    as long x, y
end type

type Base1
    declare constructor( )
    declare constructor( byref s as string, byval n as long = 7 )
    declare constructor( byval w as wstring ptr )
    declare constructor( byref p as Pt )
    s_ as string
    n_ as long
end type
constructor Base1( )
    s_ = "none"
end constructor
constructor Base1( byref s as string, byval n as long )
    s_ = s : n_ = n
end constructor
constructor Base1( byval w as wstring ptr )
    s_ = "wide " & *w
end constructor
constructor Base1( byref p as Pt )
    s_ = "pt " & p.x & "," & p.y
end constructor

type FromVar extends Base1
    declare constructor( byref t as string )
end type
constructor FromVar( byref t as string )
    base( t )
end constructor

type FromLit extends Base1
    declare constructor( )
end type
constructor FromLit( )
    base( "literal", 3 )
end constructor

type FromExpr extends Base1
    declare constructor( byref t as string )
end type
constructor FromExpr( byref t as string )
    base( t & "!" )
end constructor

type FromWide extends Base1
    declare constructor( )
end type
constructor FromWide( )
    base( wstr( "text" ) )
end constructor

type FromPt extends Base1
    declare constructor( byref p as Pt )
end type
constructor FromPt( byref p as Pt )
    base( p )
end constructor

type ByvalBase
    declare constructor( byval s as string = "dflt" )
    s_ as string
end type
constructor ByvalBase( byval s as string )
    s_ = s
end constructor
type FromByval extends ByvalBase
    declare constructor( )
end type
constructor FromByval( )
    base( "by value" )
end constructor

dim as FromVar a = FromVar( "variable" )
print a.s_; a.n_
dim as FromLit b
print b.s_; b.n_
dim as FromExpr c = FromExpr( "expression" )
print c.s_; c.n_
dim as FromWide d
print d.s_
dim as Pt pp = ( 3, 4 )
dim as FromPt e = FromPt( pp )
print e.s_
dim as FromByval f
print f.s_
