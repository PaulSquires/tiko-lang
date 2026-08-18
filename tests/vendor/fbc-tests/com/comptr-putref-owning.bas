' TEST_MODE : COMPILE_AND_RUN_FAIL

'' PutRef( ) on an OWNING ComPtr raises.
''
'' ATL asserts this in debug builds only and lets it through in release; here it
'' is unconditional, because handing out the address of a slot that already owns
'' a reference is a silent leak -- the exact failure this type exists to remove.
''
'' Its own module: the raise aborts.

#include once "fb/comptr.bi"
using FB

type IFake extends ComUnknown
	declare abstract function Poke( ) as long
end type

'' A minimal object, enough to be owned.  Never actually called.
type FakeVtbl
	as any ptr QueryInterface, AddRef, Release, Poke
end type
type Fake
	as FakeVtbl ptr lpVtbl
	as long refs
end type

private function FakeAddRef cdecl ( byval self_ as Fake ptr ) as ULONG
	self_->refs += 1 : return self_->refs
end function
private function FakeRelease cdecl ( byval self_ as Fake ptr ) as ULONG
	self_->refs -= 1 : return self_->refs
end function

dim shared as FakeVtbl g_vtbl
dim shared as Fake     g_obj

g_vtbl.AddRef  = cast( any ptr, @FakeAddRef )
g_vtbl.Release = cast( any ptr, @FakeRelease )
g_obj.lpVtbl   = @g_vtbl
g_obj.refs     = 1

dim as ComPtr( of IFake ) p
p.Attach( cptr( IFake ptr, cast( any ptr, @g_obj ) ) )
print "before"
dim as IFake ptr ptr slot = p.PutRef( )
print "unreachable"
