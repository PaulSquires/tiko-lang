'' EVERY DECLARATION KIND USED ABOVE ITS DECLARATION (RFC-0003 §5): in this file, or in b.bas,
'' which sorts after it -- a procedure, a type used by value and as a field, an enum and its
'' member, a const built from a later const, a typedef chain, a generic and its member body,
'' a generic typedef, a namespace and its member, a shared variable, a base type, and
'' out-of-line members written above their type.
#module "early"
public function Go( ) as long
    dim as Outer o
    o.inner_.x = 2
    o.Touch( )
    dim as TX t = 7
    dim as Box( of long ) bx
    bx.v = 5
    dim as IntBox ib
    ib.v = 4
    dim as Derived d
    d.base_v = 11
    dim as Colour col = Colour.blue
    shared_ += 1
    return o.inner_.x + t + bx.Get2( ) + ib.Get2( ) + Ns.Val( ) + A_C + d.Twice( ) _
        + col + shared_ + SizeOuter( o ) + Helper( )
end function
function SizeOuter( byref o as Outer ) as long
    return sizeof( Outer )
end function
sub Outer.Touch( )
    inner_.x += 1
end sub
function Derived.Twice( ) as long
    return base_v * 2
end function
function Box( of T ).Get2( ) as T
    return v * 2
end function
const A_C = B_C + 1
type Outer
    inner_ as Inner
    declare sub Touch( )
end type
type TX as TY
type TY as long
type IntBox as Box( of long )
type Box( of T )
    v as T
    declare function Get2( ) as T
end type
namespace Ns
    function Val( ) as long
        return Deeper( ) + 1
    end function
    function Deeper( ) as long
        return 999
    end function
end namespace
type Derived extends Base_
    declare function Twice( ) as long
end type
type Base_ extends object
    base_v as long
end type
enum Colour
    red
    blue
end enum
