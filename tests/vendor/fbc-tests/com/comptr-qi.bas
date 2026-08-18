' TEST_MODE : COMPILE_AND_RUN_OK

'' The querying half: IidOf/COM_IID, ComQI, ComQIAs, ComCast, ComQIPtr, and the
'' two creation procedures.  Exhaustive.
''
'' THE FAKE OBJECT HERE EXPOSES TWO INTERFACES AT DIFFERENT ADDRESSES, the way a
'' real C++ multiple-inheritance COM object does: IFakeB's pointer is the address
'' of an embedded sub-object, not the address of the whole thing.  That is the
'' point of it.  ComCast is specified to perform a real QueryInterface rather
'' than a reinterpret, and against an object whose interfaces happen to share an
'' address -- which is most single-interface objects, including the fake in
'' comptr.bas -- a reinterpreting implementation would pass every assertion.
'' Section 8 is the one that can tell the difference.
''
'' NOT here:
''   - a module that never says 'using FB'   -> comptr-noimport.bas
''   - the missing-COM_IID diagnostic        -> fail-comptr-no-iid.bas
''   - ComCast with one type argument        -> fail-comptr-comcast-arity.bas

#include once "fb/comptr.bi"
using FB

#define assert_(e) if (e) = 0 then fb_Assert(__FILE__, __LINE__, __FUNCTION__, #e)

'' ---------------------------------------------------------------- fixtures

type IFakeA extends ComUnknown
	declare abstract function PokeA( ) as long
end type

type IFakeB extends ComUnknown
	declare abstract function PokeB( ) as long
end type

'' An interface the object does NOT support, for the E_NOINTERFACE path.
type IUnsupported extends ComUnknown
	declare abstract function Nope( ) as long
end type

'' An interface with NO COM_IID line, to prove ComQI needs none.
type INoTrait extends ComUnknown
	declare abstract function PokeA( ) as long
end type

dim shared as GUID IID_FakeA = type<GUID>( &h11110000, &h0001, &h0002, { 1,2,3,4,5,6,7,8 } )
dim shared as GUID IID_FakeB = type<GUID>( &h22220000, &h0001, &h0002, { 1,2,3,4,5,6,7,8 } )
dim shared as GUID IID_Unsup = type<GUID>( &h33330000, &h0001, &h0002, { 1,2,3,4,5,6,7,8 } )

COM_IID( IFakeA, IID_FakeA )
COM_IID( IFakeB, IID_FakeB )
COM_IID( IUnsupported, IID_Unsup )
'' deliberately no COM_IID for INoTrait

type VtblA
	as any ptr QueryInterface, AddRef, Release, PokeA
end type
type VtblB
	as any ptr QueryInterface, AddRef, Release, PokeB
end type

type Obj_ as Obj
type SubB
	as VtblB ptr lpVtbl
	as Obj_ ptr owner
end type
type Obj
	as VtblA ptr lpVtbl        '' offset 0 -- the IFakeA view
	as long    refs
	as long    pokedA, pokedB
	as SubB    b               '' a DIFFERENT address -- the IFakeB view
end type

dim shared as VtblA g_vtblA
dim shared as VtblB g_vtblB
dim shared as long  g_destroyed

declare function ObjQI cdecl ( byval self_ as Obj ptr, byval riid as const GUID ptr, byval ppv as any ptr ptr ) as HRESULT
declare function ObjAddRef cdecl ( byval self_ as Obj ptr ) as ULONG
declare function ObjRelease cdecl ( byval self_ as Obj ptr ) as ULONG
declare function hIidUnknownForTest( ) as const GUID ptr

'' Casting an interface pointer back to the concrete object needs ANY PTR in the
'' middle: cptr( Obj ptr, someIFakeAPtr ) is error 303, the mirror of the 301
'' that comptr.bi's hAsUnk exists to avoid.
declare function AsObj( byval p as any ptr ) as Obj ptr

'' --- the IFakeA view: 'this' is the object itself
private function ObjQI cdecl ( byval self_ as Obj ptr, byval riid as const GUID ptr, byval ppv as any ptr ptr ) as HRESULT
	if( ppv = 0 ) then return E_POINTER
	*ppv = 0
	if( IsEqualGUID( riid, @IID_FakeA ) orelse IsEqualGUID( riid, hIidUnknownForTest( ) ) ) then
		*ppv = self_                                  '' the object's address
	elseif( IsEqualGUID( riid, @IID_FakeB ) ) then
		*ppv = @self_->b                              '' a DIFFERENT address
	else
		return E_NOINTERFACE
	end if
	ObjAddRef( self_ )
	return S_OK
end function

private function ObjAddRef cdecl ( byval self_ as Obj ptr ) as ULONG
	self_->refs += 1 : return self_->refs
end function

private function ObjRelease cdecl ( byval self_ as Obj ptr ) as ULONG
	self_->refs -= 1
	dim as long n = self_->refs
	if( n = 0 ) then g_destroyed += 1 : deallocate( self_ )
	return n
end function

private function ObjPokeA cdecl ( byval self_ as Obj ptr ) as long
	self_->pokedA += 1 : return self_->pokedA
end function

'' --- the IFakeB view: 'this' is @obj.b, so every method hops to the owner
private function SubQI cdecl ( byval self_ as SubB ptr, byval riid as const GUID ptr, byval ppv as any ptr ptr ) as HRESULT
	return ObjQI( self_->owner, riid, ppv )
end function
private function SubAddRef cdecl ( byval self_ as SubB ptr ) as ULONG
	return ObjAddRef( self_->owner )
end function
private function SubRelease cdecl ( byval self_ as SubB ptr ) as ULONG
	return ObjRelease( self_->owner )
end function
private function SubPokeB cdecl ( byval self_ as SubB ptr ) as long
	self_->owner->pokedB += 1 : return self_->owner->pokedB
end function

'' IID_IUnknown, spelled out so the test does not depend on uuid.lib.
private function hIidUnknownForTest( ) as const GUID ptr
	static as GUID g = type<GUID>( &h00000000, &h0000, &h0000, _
	                               { &hC0, &h00, &h00, &h00, &h00, &h00, &h00, &h46 } )
	return @g
end function

function AsObj( byval p as any ptr ) as Obj ptr
	return cptr( Obj ptr, p )
end function

private function NewObj( ) as IFakeA ptr
	dim as Obj ptr o = callocate( sizeof( Obj ) )
	o->lpVtbl   = @g_vtblA
	o->refs     = 1
	o->b.lpVtbl = @g_vtblB
	o->b.owner  = o
	return cptr( IFakeA ptr, cast( any ptr, o ) )
end function

private function RefsOf( byval p as any ptr ) as long
	if( p = 0 ) then return -1
	return AsObj( p )->refs
end function

g_vtblA.QueryInterface = cast( any ptr, @ObjQI )
g_vtblA.AddRef         = cast( any ptr, @ObjAddRef )
g_vtblA.Release        = cast( any ptr, @ObjRelease )
g_vtblA.PokeA          = cast( any ptr, @ObjPokeA )

g_vtblB.QueryInterface = cast( any ptr, @SubQI )
g_vtblB.AddRef         = cast( any ptr, @SubAddRef )
g_vtblB.Release        = cast( any ptr, @SubRelease )
g_vtblB.PokeB          = cast( any ptr, @SubPokeB )

'' ------------------------------------------------------- 1. the IID trait

scope
	'' The tag is a generic MARKER, not a T ptr.  That is what stops an
	'' unannotated interface from silently binding to a base interface's
	'' overload: IidTag( of IDerived ) does not convert to IidTag( of IBase ),
	'' whereas IDerived ptr converts to IBase ptr and would have.
	dim as IidTag( of IFakeA ) tagA
	dim as IidTag( of IFakeB ) tagB
	assert_( IidOf( tagA ) = @IID_FakeA )         '' resolves to the right overload
	assert_( IidOf( tagB ) = @IID_FakeB )
	assert_( IsEqualGUID( IidOf( tagA ), @IID_FakeA ) <> 0 )   '' byte-for-byte
	assert_( IsEqualGUID( IidOf( tagA ), @IID_FakeB ) = 0 )

	'' the built-in lines the library ships
	dim as IidTag( of ComUnknown ) tagU
	dim as GUID iidUnknown = type<GUID>( &h00000000, &h0000, &h0000, _
	                                     { &hC0, &h00, &h00, &h00, &h00, &h00, &h00, &h46 } )
	assert_( IsEqualGUID( IidOf( tagU ), @iidUnknown ) <> 0 )
end scope

'' ------------------------------------- 2. ComQI -- explicit IID, no trait

g_destroyed = 0
scope
	dim as ComPtr( of IFakeA ) src
	src.Attach( NewObj( ) )

	'' INoTrait has no COM_IID line at all; ComQI must still work.
	dim as ComPtr( of INoTrait ) nt
	assert_( ComQI( src.Get( ), @IID_FakeA, nt ) = S_OK )
	assert_( nt.IsNull( ) = FALSE )
	assert_( RefsOf( src.Get( ) ) = 2 )           '' the query's reference, adopted
	nt.Release( )
	assert_( RefsOf( src.Get( ) ) = 1 )

	'' bad arguments
	dim as ComPtr( of INoTrait ) nt2
	assert_( ComQI( cast( any ptr, 0 ), @IID_FakeA, nt2 ) = E_POINTER )
	assert_( nt2.IsNull( ) = TRUE )
	assert_( ComQI( src.Get( ), 0, nt2 ) = E_POINTER )
	assert_( nt2.IsNull( ) = TRUE )
end scope
assert_( g_destroyed = 1 )

'' ------------------------------------------ 3. ComQIAs agrees with ComQI

g_destroyed = 0
scope
	dim as ComPtr( of IFakeA ) src
	src.Attach( NewObj( ) )

	dim as ComPtr( of IFakeB ) viaExplicit, viaTrait
	assert_( ComQI( src.Get( ), @IID_FakeB, viaExplicit ) = S_OK )
	assert_( ComQIAs( src.Get( ), viaTrait ) = S_OK )
	assert_( viaExplicit.Get( ) = viaTrait.Get( ) )   '' same answer
	assert_( RefsOf( src.Get( ) ) = 3 )
end scope
assert_( g_destroyed = 1 )

'' -------------------------------------------- 4. the E_NOINTERFACE path

g_destroyed = 0
scope
	dim as ComPtr( of IFakeA ) src
	src.Attach( NewObj( ) )

	dim as ComPtr( of IUnsupported ) u
	assert_( ComQIAs( src.Get( ), u ) = E_NOINTERFACE )
	assert_( u.IsNull( ) = TRUE )                 '' left empty
	assert_( RefsOf( src.Get( ) ) = 1 )           '' and nothing was counted

	'' a failing query must also release whatever dst held
	dim as ComPtr( of IFakeB ) held
	assert_( ComQIAs( src.Get( ), held ) = S_OK )
	assert_( RefsOf( src.Get( ) ) = 2 )
	dim as ComPtr( of IFakeB ) reused
	assert_( ComQIAs( src.Get( ), reused ) = S_OK )
	assert_( RefsOf( src.Get( ) ) = 3 )
	assert_( ComQI( src.Get( ), @IID_Unsup, reused ) = E_NOINTERFACE )
	assert_( reused.IsNull( ) = TRUE )
	assert_( RefsOf( src.Get( ) ) = 2 )           '' reused's old reference went

	'' A FAILING ComQIAs must also empty a dst that was already owning.  This is
	'' the only path on which the dst.Release( ) at the top of ComQIAs is load-
	'' bearing -- on the success path Attach( ) would have released the old
	'' pointer anyway, so removing it passes every other assertion here.
	dim as ComPtr( of IUnsupported ) preloaded
	assert_( ComQI( src.Get( ), @IID_FakeA, preloaded ) = S_OK )   '' wrongly typed, but owning
	assert_( preloaded.IsNull( ) = FALSE )
	assert_( RefsOf( src.Get( ) ) = 3 )
	assert_( ComQIAs( src.Get( ), preloaded ) = E_NOINTERFACE )
	assert_( preloaded.IsNull( ) = TRUE )         '' emptied by the failure
	assert_( RefsOf( src.Get( ) ) = 2 )           '' and its reference released
end scope
assert_( g_destroyed = 1 )

'' ------------------------------------------------ 5. ComQIPtr construction

g_destroyed = 0
scope
	dim as ComPtr( of IFakeA ) src
	src.Attach( NewObj( ) )

	scope
		dim as ComQIPtr( of IFakeB ) b = src.Get( )   '' queries on construction
		assert_( b.IsNull( ) = FALSE )
		assert_( RefsOf( src.Get( ) ) = 2 )
		assert_( b->PokeB( ) = 1 )                    '' inherited arrow works

		dim as ComQIPtr( of IUnsupported ) u = src.Get( )
		assert_( u.IsNull( ) = TRUE )                 '' empty, and NOT raised
		assert_( RefsOf( src.Get( ) ) = 2 )

		dim as ComQIPtr( of IFakeB ) empty_ = cast( any ptr, 0 )
		assert_( empty_.IsNull( ) = TRUE )

		dim as ComQIPtr( of IFakeB ) copy_ = b        '' copy: no re-query
		assert_( copy_.Get( ) = b.Get( ) )
		assert_( RefsOf( src.Get( ) ) = 3 )
	end scope
	assert_( RefsOf( src.Get( ) ) = 1 )
end scope
assert_( g_destroyed = 1 )

'' -------------------------------------------------- 6. ComQIPtr assignment

g_destroyed = 0
scope
	dim as ComPtr( of IFakeA ) src
	src.Attach( NewObj( ) )

	dim as ComQIPtr( of IFakeB ) b
	b = src.Get( )                                '' assignment queries
	assert_( b.IsNull( ) = FALSE )
	assert_( RefsOf( src.Get( ) ) = 2 )

	b = src.Get( )                                '' re-query releases the old
	assert_( b.IsNull( ) = FALSE )
	assert_( RefsOf( src.Get( ) ) = 2 )

	dim as ComQIPtr( of IFakeB ) c
	c = b                                         '' handle copy, no query
	assert_( c.Get( ) = b.Get( ) )
	assert_( RefsOf( src.Get( ) ) = 3 )
	c = c                                         '' self-assign is a no-op
	assert_( RefsOf( src.Get( ) ) = 3 )

	'' assigning a source that does not support T empties the pointer
	dim as ComQIPtr( of IUnsupported ) u
	u = src.Get( )
	assert_( u.IsNull( ) = TRUE )

	'' assigning null empties it, releasing what was held
	b = cast( any ptr, 0 )
	assert_( b.IsNull( ) = TRUE )
	assert_( RefsOf( src.Get( ) ) = 2 )
end scope
assert_( g_destroyed = 1 )

'' ------------------- 6b. re-querying when the pointer is the SOLE owner
''
'' ComQIPtr.let must run the query BEFORE releasing what it holds.  The reverse
'' order is invisible unless the pointer is the object's last owner: then the
'' release destroys the object and the query runs on freed memory.  Every
'' assignment in section 6 has src holding a second reference, so none of them
'' can tell the two orders apart.

g_destroyed = 0
scope
	'' NOTE: refcounts are read through the IFakeA view.  solo.Get( ) is the
	'' IFakeB view -- the address of the embedded sub-object -- so RefsOf( ) on
	'' it would read the wrong offset.  Same object, different address, which is
	'' the whole point of this fixture.
	dim as any ptr rawA
	dim as ComQIPtr( of IFakeB ) solo
	scope
		dim as ComPtr( of IFakeA ) tmp
		tmp.Attach( NewObj( ) )
		rawA = tmp.Get( )
		solo = tmp.Get( )                         '' query: refs 2
		assert_( solo.IsNull( ) = FALSE )
	end scope                                     '' tmp released: refs 1
	assert_( g_destroyed = 0 )
	assert_( RefsOf( rawA ) = 1 )                 '' solo is now the ONLY owner
	assert_( cast( any ptr, solo.Get( ) ) <> rawA )

	solo = solo.Get( )                            '' re-query from itself
	assert_( g_destroyed = 0 )                    '' must NOT have been destroyed
	assert_( solo.IsNull( ) = FALSE )
	assert_( RefsOf( rawA ) = 1 )
	assert_( solo->PokeB( ) > 0 )                 '' and is still callable
end scope
assert_( g_destroyed = 1 )

'' ------------------------------------- 7. the inherited surface on a ComQIPtr

g_destroyed = 0
scope
	dim as ComPtr( of IFakeA ) src
	src.Attach( NewObj( ) )

	dim as ComQIPtr( of IFakeB ) b = src.Get( )
	assert_( b.Get( ) <> 0 )
	assert_( b.Unknown( ) <> 0 )
	assert_( b.IsNull( ) = FALSE )
	assert_( b.Ref( ).PokeB( ) > 0 )
	assert_( b->PokeB( ) > 0 )
	assert_( (*b).PokeB( ) > 0 )
	assert_( b.IsEqualObject( src.Get( ) ) = TRUE )   '' same object, two addresses

	dim as IFakeB ptr out_
	assert_( b.CopyTo( @out_ ) = S_OK )
	assert_( RefsOf( src.Get( ) ) = 3 )
	cptr( ComUnknown ptr, cast( any ptr, out_ ) )->Release( )

	dim as IFakeB ptr det = b.Detach( )
	assert_( b.IsNull( ) = TRUE )
	dim as ComPtr( of IFakeB ) adopt
	adopt.Attach( det )
	assert_( RefsOf( src.Get( ) ) = 2 )
end scope
assert_( g_destroyed = 1 )

'' ------------------- 8. ComCast is a REAL QUERY -- the reinterpret test

g_destroyed = 0
scope
	dim as ComPtr( of IFakeA ) a
	a.Attach( NewObj( ) )

	'' The two interface pointers are at DIFFERENT addresses by construction.
	dim as ComPtr( of IFakeB ) b
	assert_( ComCast( of IFakeA, IFakeB )( a, b ) = S_OK )
	assert_( b.IsNull( ) = FALSE )

	'' THIS is the assertion a reinterpreting ComCast would fail: it would have
	'' produced b.Get( ) = a.Get( ), and then b->PokeB( ) would have dispatched
	'' through IFakeA's vtable and called PokeA -- or worse.
	assert_( cast( any ptr, b.Get( ) ) <> cast( any ptr, a.Get( ) ) )
	assert_( b->PokeB( ) = 1 )
	assert_( AsObj( a.Get( ) )->pokedB = 1 )
	assert_( AsObj( a.Get( ) )->pokedA = 0 )   '' PokeA was NOT called

	'' and back again
	dim as ComPtr( of IFakeA ) a2
	assert_( ComCast( of IFakeB, IFakeA )( b, a2 ) = S_OK )
	assert_( a2.Get( ) = a.Get( ) )
	assert_( a2->PokeA( ) = 1 )

	'' identity holds across both views despite the different addresses
	assert_( a.IsEqualObject( b.Get( ) ) = TRUE )
	assert_( b.IsEqualObject( a.Get( ) ) = TRUE )

	'' a cast the object does not support leaves dst empty
	dim as ComPtr( of IUnsupported ) u
	assert_( ComCast( of IFakeA, IUnsupported )( a, u ) = E_NOINTERFACE )
	assert_( u.IsNull( ) = TRUE )

	'' casting from an empty source
	dim as ComPtr( of IFakeA ) none_
	dim as ComPtr( of IFakeB ) dst2
	assert_( ComCast( of IFakeA, IFakeB )( none_, dst2 ) = E_POINTER )
	assert_( dst2.IsNull( ) = TRUE )
end scope
assert_( g_destroyed = 1 )

'' ----------------------------- 9. creation, against a real COM server

scope
	assert_( succeeded( CoInitializeEx( 0, COINIT_APARTMENTTHREADED ) ) )

	'' EVERY ComPtr BELOW LIVES IN AN INNER SCOPE, and that is not tidiness.
	'' Destructors run at the END of the enclosing scope -- after the
	'' CoUninitialize( ) statement, not before it -- so declaring them alongside
	'' it releases interface pointers into a dead apartment.  Written the obvious
	'' way, this section segfaulted.  It is exactly the ordering rule RFC-0004
	'' section 1 states for ComInit, demonstrated here by getting it wrong first.
	scope

	dim as GUID CLSID_ShellLink_ = type<GUID>( &h00021401, &h0000, &h0000, _
	                                           { &hC0, &h00, &h00, &h00, &h00, &h00, &h00, &h46 } )
	dim as ComPtr( of ComUnknown ) byClsid = ComCreate( of ComUnknown )( @CLSID_ShellLink_, CLSCTX_INPROC_SERVER )
	assert_( byClsid.IsNull( ) = FALSE )

	dim as ComPtr( of ComUnknown ) byProgid = ComCreateFromProgID( of ComUnknown )( "Shell.Application" )
	assert_( byProgid.IsNull( ) = FALSE )

	'' a CLSID that is not registered yields an EMPTY pointer, not a crash
	dim as GUID bogus = type<GUID>( &hDEADBEEF, &h1234, &h5678, { 1,2,3,4,5,6,7,8 } )
	dim as ComPtr( of ComUnknown ) bad = ComCreate( of ComUnknown )( @bogus )
	assert_( bad.IsNull( ) = TRUE )

	dim as ComPtr( of ComUnknown ) badProgid = ComCreateFromProgID( of ComUnknown )( "No.Such.ProgID.Here" )
	assert_( badProgid.IsNull( ) = TRUE )

	'' a real QI across two genuinely different interfaces of a real object
	dim as GUID IID_IPersistFile_ = type<GUID>( &h0000010B, &h0000, &h0000, _
	                                            { &hC0, &h00, &h00, &h00, &h00, &h00, &h00, &h46 } )
	dim as ComPtr( of ComUnknown ) persist
	assert_( ComQI( byClsid.Get( ), @IID_IPersistFile_, persist ) = S_OK )
	assert_( persist.IsNull( ) = FALSE )
	'' same object, and IsEqualObject says so whatever the addresses are
	assert_( byClsid.IsEqualObject( persist.Get( ) ) = TRUE )
	end scope                             '' every ComPtr released HERE...

	CoUninitialize( )                     '' ...and only then is the apartment gone
end scope

print "comptr-qi: ok"
