'' One of each row of RFC-0002 §4 and §5: every kind of name a module declares, and the
'' linkage each gets.
#module "http"
'' module-private: external, hidden
function Send_( byval s as string ) as long
    return len( s )
end function
'' public: an ordinary external symbol
public function Fetch( ) as long
    return Send_( "x" )
end function
'' explicitly private: internal, as fbc's private is
private function Quiet_( ) as long
    return 3
end function
'' inside a namespace of the module: the chain, then the namespace
namespace Inner
    public sub X( )
    end sub
end namespace
'' a public generic: its instance keeps the chain, and is foldable
public type Box( of T )
    v as T
    declare sub Put( byval x as T )
end type
sub Box( of T ).Put( byval x as T )
    v = x
end sub
'' a public generic PROCEDURE: its instance keeps the chain too (fbc's form, no return type)
public function Twice( of T )( byval x as T ) as T
    return x + x
end function
'' a type with a virtual method: its RTTI name and vtable carry the chain, so 'is' tells
'' two modules' same-named types apart
public type Shape extends object
    declare virtual function Area( ) as long
end type
function Shape.Area( ) as long
    return Twice( 1 )
end function
'' extern "C": the name as written, for C
extern "C"
    public function tk_fetch( ) as long
        return 7
    end function
end extern
'' variables: public, module-private, private
public dim shared counter as long
dim shared helper as long
private dim shared quietVar as long
dim as Box( of long ) b
dim as Shape sh
b.Put( Quiet_( ) + counter + helper + quietVar + sh.Area( ) )
