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

'' Not yet: the initialiser of a shared or namespace variable runs in the module
'' initialiser, not at the declaration.
dim shared sh as FB.Array( of integer ) = { 1 }
namespace NS
    dim nv as FB.Array( of integer ) = { 1 }
end namespace

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
