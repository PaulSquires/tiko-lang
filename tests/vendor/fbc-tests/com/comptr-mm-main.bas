'' Main module of comptr-mm. See comptr-mm.bmk for what this proves.
#include once "comptr-mm-shared.bi"

#define assert_(e) if (e) = 0 then fb_Assert(__FILE__, __LINE__, __FUNCTION__, #e)

dim shared as FakeVtbl g_vtbl
dim shared g_destroyed as long
dim shared IID_Fake as GUID

private function FakeQI cdecl ( byval self_ as Fake ptr, byval riid as const GUID ptr, byval ppv as any ptr ptr ) as HRESULT
	if( ppv = 0 ) then return E_POINTER
	if( IsEqualGUID( riid, @IID_Fake ) = 0 ) then return E_NOINTERFACE
	*ppv = self_ : self_->refs += 1 : return S_OK
end function
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

function NewFake( ) as IFake ptr
	dim as Fake ptr f = callocate( sizeof( Fake ) )
	f->lpVtbl = @g_vtbl : f->refs = 1
	return cptr( IFake ptr, cast( any ptr, f ) )
end function

function RefsOf( byval p as any ptr ) as long
	if( p = 0 ) then return -1
	return cptr( Fake ptr, p )->refs
end function

IID_Fake = type<GUID>( &h66660000, &h0001, &h0002, { 1,2,3,4,5,6,7,8 } )

g_vtbl.QueryInterface = cast( any ptr, @FakeQI )
g_vtbl.AddRef         = cast( any ptr, @FakeAddRef )
g_vtbl.Release        = cast( any ptr, @FakeRelease )
g_vtbl.Poke           = cast( any ptr, @FakePoke )

'' This module's own instantiation of ComPtr( of IFake ).
g_destroyed = 0
scope
	dim as ComPtr( of IFake ) a
	a.Attach( NewFake( ) )
	assert_( RefsOf( a.Get( ) ) = 1 )

	'' Hand the reference to the other module, which owns and releases it.
	dim as long seenThere = AdoptAndCount( a.Detach( ) )
	assert_( a.IsNull( ) = TRUE )
	assert_( seenThere = 1 )         '' the count crossed intact
	assert_( g_destroyed = 1 )       '' and B's destructor ran
end scope

'' And the reverse: both modules' instantiations agree on the type.
g_destroyed = 0
scope
	dim as ComPtr( of IFake ) b
	b.Attach( NewFake( ) )
	assert_( AdoptAndCount( b.Detach( ) ) = 1 )
end scope
assert_( g_destroyed = 1 )

'' The trait, resolved independently in each module against one shared COM_IID
'' line.  Both instantiations must agree, and the link must not see two IidOf.
g_destroyed = 0
scope
	dim as ComPtr( of IFake ) c
	c.Attach( NewFake( ) )

	dim as ComPtr( of IFake ) here
	assert_( ComQIAs( c.Get( ), here ) = S_OK )   '' main's instantiation
	assert_( RefsOf( c.Get( ) ) = 2 )

	assert_( QueryInB( c.Get( ) ) = 3 )           '' B's instantiation, while B holds one
	assert_( RefsOf( c.Get( ) ) = 2 )             '' B released its own on return
end scope
assert_( g_destroyed = 1 )

print "comptr-mm: ok"
