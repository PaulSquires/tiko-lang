'' A DERIVED value passed where a type with a constructor taking its BASE is wanted: the
'' constructor builds the temporary, through a byref const, a byref and a byval parameter.

type Shape extends object
    declare abstract function Describe( byref spec as const string ) as string
end type
type Circle extends Shape
    as long r
    declare function Describe( byref spec as const string ) as string override
end type
function Circle.Describe( byref spec as const string ) as string
    return "circle r=" & r & " spec=" & spec
end function

type Plain
    as long v
end type
type PlainKid extends Plain
    as long extra
end type

type Holder
    as long kind
    as const Shape ptr ps
    as long pv
    declare constructor( byval v as long )
    declare constructor( byref v as const Shape )
    declare constructor( byref v as const Plain )
end type
constructor Holder( byval v as long ) : kind = 1 : end constructor
constructor Holder( byref v as const Shape ) : kind = 2 : ps = @v : end constructor
constructor Holder( byref v as const Plain ) : kind = 3 : pv = v.v : end constructor

function Text( byref h as const Holder ) as string
    if h.kind = 2 then return "shape:" & cast( Shape ptr, h.ps )->Describe( "x" )
    if h.kind = 3 then return "plain:" & h.pv
    return "kind " & h.kind
end function
function ByConst( byref h as const Holder ) as string
    return "C " & Text( h )
end function
function ByRef_( byref h as Holder ) as string
    return "R " & Text( h )
end function
function ByVal_( byval h as Holder ) as string
    return "V " & Text( h )
end function

dim as Circle c
c.r = 5
dim as PlainKid pk
pk.v = 8
print ByConst( c )
print ByConst( pk )
print ByRef_( c )
print ByRef_( pk )
print ByVal_( c )
print ByVal_( pk )
print ByConst( 3 )
