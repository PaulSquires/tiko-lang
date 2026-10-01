'' Collection initialisers: what is refused.
#include once "containers.bi"

'' Needs construction, has none of Add, PushBack, Push -- the list was dropped in silence.
type NoAdd
    as long n
    declare constructor( )
end type
constructor NoAdd( )
end constructor
dim z as NoAdd = { 1 }

'' A shared or namespace collection is filled in the module initializer, before main's
'' frame exists, so an element may not name a variable of it (fbc's error 272 for any
'' shared initializer). Not yet: a static member's definition.
dim frameVar as integer = 1
dim shared sh as FB.Array( of integer ) = { frameVar }
type Holder
    as long unused
    static as FB.Array( of integer ) m
end type
dim shared Holder.m as FB.Array( of integer ) = { 1 }

'' The elements are real calls, so their errors are the ordinary ones.
dim w as FB.Array( of integer ) = { {1, 2} }
dim v as FB.Array( of integer ) = { 1, "x" }

'' Unchanged: no construction needed, so a type with Push is not a collection.
type Pod
    as long a, b
    declare sub Push( byval v as long )
end type
sub Pod.Push( byval v as long )
end sub
dim pd as Pod = ( 7, 8 )
