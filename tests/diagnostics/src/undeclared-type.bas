'' TKO0808: a type name nothing declares -- fbc's error 14, 59 for a parameter, 3 for a
'' qualified or generic typedef target. The controls at the bottom are accepted by fbc.
type Cell
    dim as long k
end type
dim as Foo a1
dim as Foo ptr p1
type HasBad
    x as Bar
end type
sub TakesBad( byval q as Baz ptr )
end sub
type CellArray as FB.Array( of Cell )
dim as FB.Array( of long ) a2

'' Accepted by fbc: a typedef's plain target is a FORWARD type, opaque behind a pointer;
'' a generic type's base clause names its own parameter; and 'typeof' of a field is an
'' expression, not a type name.
type Opaque as NotYetDeclared ptr
dim as Opaque op
type GBase( of T )
    as T v
end type
type GDer( of T ) extends GBase( of T )
    as T w
end type
dim as GDer( of long ) gd
dim as Cell c1
dim as typeof( c1.k ) z
print z; gd.v; op = 0
