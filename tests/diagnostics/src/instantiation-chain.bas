'' TKO0903: an error inside an instantiated generic body names the instantiation, and
'' every instantiation that asked for it, out to the line in the program. Each shape
'' below reports TKO0720 in a generic body; the notes are what is under test.
type Opaque_
    as long x
end type

'' A TYPE's member, instantiated by a field of another generic TYPE.
type Inner( of T )
    declare function Bigger( byval a as T, byval b as T ) as boolean
    as T v
end type
function Inner( of T ).Bigger( byval a as T, byval b as T ) as boolean
    return a > b
end function
type Outer( of T )
    as Inner( of T ) inner_
end type
dim o as Outer( of Opaque_ )

'' A generic PROCEDURE, instantiated from inside a generic type's member body.
function Larger( of T )( byval a as T, byval b as T ) as T
    if a > b then return a
    return b
end function
type Holder( of T )
    declare sub Pick( byval a as T, byval b as T )
    as T keep
end type
sub Holder( of T ).Pick( byval a as T, byval b as T )
    keep = Larger( of T )( a, b )
end sub
dim h as Holder( of Opaque_ )

'' The same generic at a type that is fine reports nothing.
dim ok_ as Holder( of long )
