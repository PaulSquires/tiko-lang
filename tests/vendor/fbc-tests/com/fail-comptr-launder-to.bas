' TEST_MODE : COMPILE_ONLY_FAIL

'' The mirror of fail-comptr-launder-from: casting an interface pointer back to
'' a concrete implementation type is error 303, "Casting derived UDT pointer to
'' unrelated UDT pointer type".
''
'' Test code hits this constantly -- a fake COM object is a plain UDT, and
'' reading its refcount means getting from the interface pointer back to it.
'' The fix is the same: launder through ANY PTR.

#include once "fb/comptr.bi"
using FB

type IThing extends ComUnknown
	declare abstract function Poke( ) as long
end type

type Impl
	as any ptr lpVtbl
	as long    refs
end type

dim as IThing ptr q
dim as Impl ptr i = cptr( Impl ptr, q )
