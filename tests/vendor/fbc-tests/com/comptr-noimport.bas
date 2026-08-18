' TEST_MODE : COMPILE_AND_RUN_OK

'' Everything, from a module that NEVER says 'using FB'.
''
'' A generic body is replayed and resolved at the INSTANTIATION site, not at the
'' header, so any name a generic body uses unqualified must be visible HERE.
'' That is what made SharedPtr.Ref( ) usable only from a scope that had already
'' said 'using FB' until it was fixed, and result.bi had the same defect.
''
'' Two things are being pinned:
''   - comptr.bi writes FB.FB_RTERROR_ILLEGALFUNCTIONCALL qualified
''   - the COM_IID macro and the built-in IidOf overloads resolve without the
''     import, which is why the built-in ones are declared at GLOBAL scope
''     rather than inside namespace FB

#include once "fb/comptr.bi"
'' deliberately NO 'using FB'

#define assert_(e) if (e) = 0 then fb_Assert(__FILE__, __LINE__, __FUNCTION__, #e)

type IThing extends FB.ComUnknown
	declare abstract function Poke( ) as long
end type

dim shared as GUID IID_Thing = type<GUID>( &h44440000, &h0001, &h0002, { 1,2,3,4,5,6,7,8 } )
COM_IID( IThing, IID_Thing )

type Vtbl_
	as any ptr QueryInterface, AddRef, Release, Poke
end type
type Obj_
	as Vtbl_ ptr lpVtbl
	as long      refs, poked
end type

dim shared as Vtbl_ g_vtbl
dim shared as long  g_destroyed

private function QI_ cdecl ( byval s as Obj_ ptr, byval riid as const GUID ptr, byval ppv as any ptr ptr ) as HRESULT
	if( ppv = 0 ) then return E_POINTER
	*ppv = s : s->refs += 1 : return S_OK
end function
private function AddRef_ cdecl ( byval s as Obj_ ptr ) as ULONG
	s->refs += 1 : return s->refs
end function
private function Release_ cdecl ( byval s as Obj_ ptr ) as ULONG
	s->refs -= 1
	dim as long n = s->refs
	if( n = 0 ) then g_destroyed += 1 : deallocate( s )
	return n
end function
private function Poke_ cdecl ( byval s as Obj_ ptr ) as long
	s->poked += 1 : return s->poked
end function

g_vtbl.QueryInterface = cast( any ptr, @QI_ )
g_vtbl.AddRef         = cast( any ptr, @AddRef_ )
g_vtbl.Release        = cast( any ptr, @Release_ )
g_vtbl.Poke           = cast( any ptr, @Poke_ )

private function NewObj_( ) as IThing ptr
	dim as Obj_ ptr o = callocate( sizeof( Obj_ ) )
	o->lpVtbl = @g_vtbl : o->refs = 1
	return cptr( IThing ptr, cast( any ptr, o ) )
end function

g_destroyed = 0
scope
	dim as FB.ComPtr( of IThing ) p
	p.Attach( NewObj_( ) )
	assert_( p.IsNull( ) = FALSE )
	assert_( p->Poke( ) = 1 )                 '' global operator, no import
	assert_( (*p).Poke( ) = 2 )
	assert_( p.Ref( ).Poke( ) = 3 )           '' the member whose raise is qualified

	dim as FB.ComPtr( of IThing ) q
	assert_( FB.ComQIAs( p.Get( ), q ) = S_OK )   '' the trait, no import
	assert_( q.IsNull( ) = FALSE )

	dim as FB.ComQIPtr( of IThing ) r = p.Get( )
	assert_( r.IsNull( ) = FALSE )
	assert_( r->Poke( ) > 0 )
end scope
assert_( g_destroyed = 1 )

print "comptr-noimport: ok"
