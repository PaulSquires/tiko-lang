' TEST_MODE : COMPILE_AND_RUN_OK
#cmdline "-z optabstract"

'' ComPtr( of T ) under -z optabstract.
''
'' That switch preserves only USED pure-abstract types. An interface reached
'' only through a ComPtr instantiation -- never named in a DIM of its own, only
'' as a type argument -- is a reachability shape the option had not been
'' exercised against, and a silently stripped interface would be a link error at
'' best and a wrong vtable at worst.
''
'' The interface below is deliberately used in NO other way: it appears as a
'' type argument and is reached only through the arrow operator.

#include once "fb/comptr.bi"
using FB

#define assert_(e) if (e) = 0 then fb_Assert(__FILE__, __LINE__, __FUNCTION__, #e)

type IOnlyViaComPtr extends ComUnknown
	declare abstract function Poke( ) as long
end type

type FakeVtbl
	as any ptr QueryInterface, AddRef, Release, Poke
end type
type Fake
	as FakeVtbl ptr lpVtbl
	as long         refs, poked
end type

dim shared as FakeVtbl g_vtbl
dim shared as long     g_destroyed

private function FakeAddRef cdecl ( byval self_ as Fake ptr ) as ULONG
	self_->refs += 1 : return self_->refs
end function
private function FakeRelease cdecl ( byval self_ as Fake ptr ) as ULONG
	self_->refs -= 1
	dim as long n = self_->refs
	if( n = 0 ) then g_destroyed += 1 : deallocate( self_ )
	return n
end function
private function FakePoke cdecl ( byval self_ as Fake ptr ) as long
	self_->poked += 1 : return self_->poked
end function

g_vtbl.AddRef  = cast( any ptr, @FakeAddRef )
g_vtbl.Release = cast( any ptr, @FakeRelease )
g_vtbl.Poke    = cast( any ptr, @FakePoke )

scope
	dim as Fake ptr f = callocate( sizeof( Fake ) )
	f->lpVtbl = @g_vtbl : f->refs = 1

	dim as ComPtr( of IOnlyViaComPtr ) p
	p.Attach( cptr( IOnlyViaComPtr ptr, cast( any ptr, f ) ) )
	assert_( p->Poke( ) = 1 )                 '' dispatch still lands correctly
	assert_( (*p).Poke( ) = 2 )
end scope
assert_( g_destroyed = 1 )

print "comptr-optabstract: ok"
