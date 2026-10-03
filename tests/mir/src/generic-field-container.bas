'' A REAL CONTAINER AS A FIELD: FB.Array( of T ) written inline, name-first, with the
'' members used from the owning type's own methods.
''
'' The pieces this needs are all instantiation-time: the field's type has to be the
'' INSTANTIATION (or Push resolves against the generic's bodiless member and the call
'' is dropped), its dynamic-array descriptor has to be constructed and destroyed with
'' the owner, and GetIterator has to come back typed or 'for each' declines.
''
'' Runtime behaviour was checked against fbc on the all-'dim' spelling: two pushes then
'' Count = 2, a deep copy on assignment, and a balanced ctor/dtor count (9/9 over an
'' element type that counts its own).

#include once "fb/array.bi"

type Buf
    bytes_ as FB.Array( of ubyte )
    names as FB.Array( of string )
    declare sub Add( byval b as ubyte, byref n as string )
    declare function Total( ) as long
end type

sub Buf.Add( byval b as ubyte, byref n as string )
    this.bytes_.Push( b )
    this.names.Push( n )
end sub

function Buf.Total( ) as long
    dim as long t
    for each v in this.bytes_
        t += v
    next
    return t
end function

'' A CONTAINER OF A TYPE THAT ITSELF HOLDS CONTAINERS -- the instantiation of the outer
'' one walks a field type that is being instantiated on the way in.
type Pool
    items as FB.Array( of Buf )
end type

sub P( )
    dim as Buf b
    b.Add( 65, "a" )
    b.Add( 66, "b" )

    dim as Pool q
    q.items.Push( b )

    '' DEEP COPY: assigning the owner copies the container, storage and all.
    dim as Buf b2 = b
    b2.Add( 67, "c" )
end sub
