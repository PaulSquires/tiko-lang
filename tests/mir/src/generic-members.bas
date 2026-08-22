'' INSTANTIATING A GENERIC'S MEMBERS.
''
'' The type half alone was not enough: a method call on an instantiation fell back to
'' the GENERIC's single member -- one body, whose parameter was an unsubstituted 'T'
'' and so was VOID, shared by every argument list. Two instantiations at different
'' types called the same wrong function.
''
'' Bodies cannot be shared, because SemanticInfo is keyed by NodeId and two
'' instantiations walking one body would fight over the same node's type. So each
'' instantiation RE-PARSES the definition from the token range the parser recorded,
'' getting nodes of its own, and resolves them with the type parameters bound.
''
'' What to read below: PUT and GET appear TWICE, once per argument list, with
'' different mangled names, different parameter types and different return types --
'' and the GENERIC'S OWN bodies appear NOT AT ALL, which is also what fbc emits.

type Box( of T )
    v as T
    declare sub Put( byval x as T )
    declare function Get( ) as T
end type

sub Box.Put( byval x as T )
    this.v = x
end sub

function Box.Get( ) as T
    return this.v
end function

sub P( )
    dim as Box( of long ) a
    dim as Box( of double ) b
    a.Put( 7 )
    b.Put( 2.5 )
    '' The RESULT TYPES differ, which is the whole point: one returns i32 and the
    '' other f64 out of what was one line of source.
    dim as long r = a.Get( )
    dim as double s = b.Get( )
end sub
