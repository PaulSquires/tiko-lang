' TEST_MODE : COMPILE_ONLY_FAIL

'' ComCast needs BOTH type arguments written out.  Inference reads parameter
'' positions only, so it would bind F from src but has nothing to bind T from --
'' the same reason SpCast( of D, B ) in sharedptr.bi spells both out.

#include once "fb/comptr.bi"
using FB

type IA extends ComUnknown
	declare abstract function A( ) as long
end type
type IB extends ComUnknown
	declare abstract function B( ) as long
end type

dim shared as GUID IID_A = type<GUID>( &h77770000, &h0001, &h0002, { 1,2,3,4,5,6,7,8 } )
dim shared as GUID IID_B = type<GUID>( &h88880000, &h0001, &h0002, { 1,2,3,4,5,6,7,8 } )
COM_IID( IA, IID_A )
COM_IID( IB, IID_B )

dim as ComPtr( of IA ) a
dim as ComPtr( of IB ) b
dim as HRESULT hr = ComCast( of IA )( a, b )
