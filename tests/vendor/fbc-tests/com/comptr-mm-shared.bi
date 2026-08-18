'' Shared by both modules of comptr-mm.
#pragma once
#include once "fb/comptr.bi"
using FB

type IFake extends ComUnknown
	declare abstract function Poke( ) as long
end type

'' A COM_IID line in a header included by BOTH modules.  This is the duplicate-
'' symbol claim: the macro emits a PRIVATE function, so each module gets its own
'' copy and the link succeeds.  Without 'private' this is a multiple-definition
'' error at link time, which no single-module test can catch.
extern IID_Fake as GUID
COM_IID( IFake, IID_Fake )

type FakeVtbl
	as any ptr QueryInterface, AddRef, Release, Poke
end type

type Fake
	as FakeVtbl ptr lpVtbl
	as long         refs
	as long         poked
end type

extern g_destroyed as long

declare function NewFake( ) as IFake ptr
declare function RefsOf( byval p as any ptr ) as long

'' Defined in module B: takes a detached reference and releases it there.
declare function AdoptAndCount( byval raw as IFake ptr ) as long

'' Defined in module B: queries through B's OWN instantiation of ComQIAs, which
'' resolves B's own copy of IidOf.
declare function QueryInB( byval src as any ptr ) as long
