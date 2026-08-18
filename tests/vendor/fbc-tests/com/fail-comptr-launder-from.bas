' TEST_MODE : COMPILE_ONLY_FAIL

'' Casting an interface pointer to ComUnknown ptr is error 301 WHEN THE
'' INTERFACE IS NOT PART OF OUR HIERARCHY.
''
'' Measured, and the boundary is worth stating exactly:
''
''   type IFoo extends FB.ComUnknown      cptr( ComUnknown ptr, p )  is FINE
''   type IFoo extends Afx_IUnknown       error 301
''   type IFoo_ : lpVtbl as ... : end     error 301
''
'' The two that fail are the two idioms already in this tree -- AfxNova declares
'' its own IUnknown root, and the Windows bindings are C-style vtbl structs -- so
'' a library that demanded ComUnknown ptr would put a laundering cast in front of
'' every call for most users.  That is why IsEqualObject, ComQI, ComQIAs,
'' ComAdvise and the rest all take ANY PTR, and why ComPtr ships Unknown( ).
''
'' The fix is to launder through ANY PTR -- or to call Unknown( ).

#include once "fb/comptr.bi"
using FB

'' An AfxNova-shaped hierarchy: its own IUnknown root, unrelated to ours.
type AfxLikeUnknown extends object
	declare abstract function QueryInterface( byval riid as any ptr, byval ppv as any ptr ptr ) as HRESULT
	declare abstract function AddRef( ) as ULONG
	declare abstract function Release( ) as ULONG
end type

type IThing extends AfxLikeUnknown
	declare abstract function Poke( ) as long
end type

dim as IThing ptr q
dim as ComUnknown ptr u = cptr( ComUnknown ptr, q )
