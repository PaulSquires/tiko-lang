' TEST_MODE : COMPILE_ONLY_FAIL

'' An interface with no COM_IID line, used where the IID is required.
''
'' The diagnostic lands inside comptr.bi rather than at the mistake, which is
'' honest but unfriendly -- the instantiation chain is what names the interface.
'' Nothing can do better without constraints on type parameters.
''
'' It matters that this is an ERROR: with the trait dispatched on a 'T ptr'
'' instead of IidTag( of T ), this would have COMPILED and silently queried for
'' the base interface's IID.

#include once "fb/comptr.bi"
using FB

type IAnnotated extends ComUnknown
	declare abstract function A( ) as long
end type
type IUnannotated extends ComUnknown
	declare abstract function B( ) as long
end type

dim shared as GUID IID_Annotated = type<GUID>( &h55550000, &h0001, &h0002, { 1,2,3,4,5,6,7,8 } )
COM_IID( IAnnotated, IID_Annotated )
'' IUnannotated deliberately has none, and inherits from an interface that DOES.

dim as ComPtr( of IUnannotated ) dst
dim as HRESULT hr = ComQIAs( cast( any ptr, 0 ), dst )
