' TEST_MODE : COMPILE_AND_RUN_OK

'' FB.ComPtr( of T ) -- exhaustive.
''
'' Every declared member, both global operators, every transition between empty
'' and owning in both directions, and refcount balance under scope exit,
'' reassignment, self-assignment, early return and container growth.
''
'' A standard library is the one place a gap is expensive: once this is in the
'' distribution every program depends on it, and a member that was never
'' exercised is a bug shipped to everyone.
''
'' MOST ASSERTIONS RUN AGAINST A FAKE COM OBJECT declared in this file, not
'' against a real server.  That is deliberate: the fake counts its own
'' references and records its own destruction, so the tests can assert EXACT
'' counts and assert that the object died -- neither of which is observable on
'' a real object, whose count is its own business.  One section at the end
'' repeats the core claims against a live CLSID_ShellLink, so the fake cannot
'' quietly diverge from what COM actually does.
''
'' NOT here, because each aborts the process and cannot share a binary:
''   - Ref( ) on an empty ComPtr        -> comptr-null-ref.bas
''   - PutRef( ) on an owning ComPtr    -> comptr-putref-owning.bas
''   - 'p->' where T is not a UDT       -> fail-comptr-scalar-arrow.bas
''
'' NOT here, because it needs two modules -> multimodule/

#include once "win/objbase.bi"
#include once "fb/comptr.bi"
#include once "fb/array.bi"
using FB

#define assert_(e) if (e) = 0 then fb_Assert(__FILE__, __LINE__, __FUNCTION__, #e)

'' ---------------------------------------------------------------- fixtures
''
'' A COM object built by hand: a vtable of three cdecl functions and a refcount
'' we can read.  Laid out COM-style, methods from slot 0, which is what
'' ComUnknown's abstract declaration expects (RFC-0001 section 8).

dim shared as long g_destroyed          '' how many fakes have been destroyed

type FakeVtbl
	as any ptr QueryInterface
	as any ptr AddRef
	as any ptr Release
	as any ptr Poke
end type

type Fake
	as FakeVtbl ptr lpVtbl
	as long         refs
	as long         poked
end type

'' The interface as the USER declares it -- abstract, so 'p->Poke( )' works.
type IFake extends ComUnknown
	declare abstract function Poke( ) as long
end type

dim shared as FakeVtbl g_vtbl

private function FakeQI cdecl ( byval self_ as Fake ptr, byval riid as const GUID ptr, byval ppv as any ptr ptr ) as HRESULT
	'' Every IID answers with the same pointer, which is what a single-interface
	'' object does and is what makes the identity test in section 9 meaningful.
	if( ppv = 0 ) then return E_POINTER
	*ppv = self_
	self_->refs += 1
	return S_OK
end function

private function FakeAddRef cdecl ( byval self_ as Fake ptr ) as ULONG
	self_->refs += 1
	return self_->refs
end function

'' Fired when a fake is destroyed, so a test can make destruction re-entrant --
'' which is the only way to reach the AddRef-before-Release ordering rule (see
'' section 4b).
dim shared as sub( ) g_onDestroy

private function FakeRelease cdecl ( byval self_ as Fake ptr ) as ULONG
	self_->refs -= 1
	dim as long n = self_->refs
	if( n = 0 ) then
		g_destroyed += 1
		deallocate( self_ )
		if( g_onDestroy <> 0 ) then
			dim as sub( ) hook = g_onDestroy
			g_onDestroy = 0                   '' fire once
			hook( )
		end if
	end if
	return n
end function

private function FakePoke cdecl ( byval self_ as Fake ptr ) as long
	self_->poked += 1
	return self_->poked
end function

'' A fresh object with refcount 1, exactly as a COM creation function returns.
private function NewFake( ) as IFake ptr
	dim as Fake ptr f = callocate( sizeof( Fake ) )
	f->lpVtbl = @g_vtbl
	f->refs   = 1
	return cptr( IFake ptr, cast( any ptr, f ) )
end function

private function RefsOf( byval p as any ptr ) as long
	if( p = 0 ) then return -1
	return cptr( Fake ptr, p )->refs
end function

g_vtbl.QueryInterface = cast( any ptr, @FakeQI )
g_vtbl.AddRef         = cast( any ptr, @FakeAddRef )
g_vtbl.Release        = cast( any ptr, @FakeRelease )
g_vtbl.Poke           = cast( any ptr, @FakePoke )

'' ---------------------------- 0. HAZARD 1, pinned as COMPILING
''
'' RFC-0005 hazard 1: there are no constraints on type parameters, so nothing
'' stops ComPtr being instantiated over a type that is not an interface at all.
'' The first lifetime operation then jumps through whatever the first eight bytes
'' of that type happen to be.
''
'' This is asserted to COMPILE, not to work.  The point is that the day
'' constraints arrive, this instantiation is one of the cases they must reject --
'' and until then the test records that the hole is known and deliberate rather
'' than unnoticed.  Nothing is called on it, because calling anything would jump
'' to a wild address.

type NotAnInterface
	as long x
end type

scope
	dim as ComPtr( of NotAnInterface ) bad
	assert_( bad.IsNull( ) = TRUE )       '' constructing and destroying is safe;
end scope                                 '' it is only USE that is not

'' ------------------------------------------------- 1. the empty state

scope
	dim as ComPtr( of IFake ) e
	assert_( e.IsNull( ) = TRUE )
	assert_( e.Get( ) = 0 )
	assert_( e.Unknown( ) = 0 )
	assert_( e.Detach( ) = 0 )
	e.Release( )                              '' idempotent on an empty pointer
	assert_( e.IsNull( ) = TRUE )
	assert_( e.IsEqualObject( 0 ) = TRUE )    '' empty equals empty
end scope

'' ------------------------------------- 2. the sharing constructor AddRefs

scope
	dim as IFake ptr raw = NewFake( )
	assert_( RefsOf( raw ) = 1 )
	scope
		dim as ComPtr( of IFake ) a = raw     '' ctor( T ptr ) AddRefs
		assert_( RefsOf( raw ) = 2 )
		assert_( a.IsNull( ) = FALSE )
		assert_( a.Get( ) = raw )
	end scope
	assert_( RefsOf( raw ) = 1 )              '' released on scope exit
	cptr( ComUnknown ptr, cast( any ptr, raw ) )->Release( )
end scope
assert_( g_destroyed = 1 )

'' ------------------------------------------- 3. Attach does NOT AddRef

g_destroyed = 0
scope
	scope
		dim as ComPtr( of IFake ) a
		a.Attach( NewFake( ) )                '' adopts the creation reference
		assert_( RefsOf( a.Get( ) ) = 1 )
	end scope
	assert_( g_destroyed = 1 )                '' died at scope exit
end scope

'' Attach over an owning pointer releases what was there first.
g_destroyed = 0
scope
	dim as ComPtr( of IFake ) a
	a.Attach( NewFake( ) )
	a.Attach( NewFake( ) )
	assert_( g_destroyed = 1 )                '' the first one went
	assert_( RefsOf( a.Get( ) ) = 1 )
end scope
assert_( g_destroyed = 2 )

'' ------------------------------------------------------ 4. copy and assign

g_destroyed = 0
scope
	dim as ComPtr( of IFake ) a
	a.Attach( NewFake( ) )
	assert_( RefsOf( a.Get( ) ) = 1 )

	scope
		dim as ComPtr( of IFake ) b = a       '' copy ctor
		assert_( RefsOf( a.Get( ) ) = 2 )

		dim as ComPtr( of IFake ) c
		c = b                                 '' operator let
		assert_( RefsOf( a.Get( ) ) = 3 )

		c = c                                 '' SELF-ASSIGN: must be a no-op
		assert_( RefsOf( a.Get( ) ) = 3 )
		assert_( c.IsNull( ) = FALSE )

		b = b                                 '' and again, on a copy
		assert_( RefsOf( a.Get( ) ) = 3 )
	end scope

	'' SELF-ASSIGN AS THE SOLE OWNER.  This is the case that actually pins the
	'' ordering rule: at refcount 1, releasing the old pointer before AddRefing
	'' the new one destroys the object and then AddRefs a corpse.  Self-assign
	'' at a higher count cannot catch it, because the transient dip is harmless.
	assert_( RefsOf( a.Get( ) ) = 1 )
	a = a
	assert_( g_destroyed = 0 )                '' NOT destroyed mid-assignment
	assert_( a.IsNull( ) = FALSE )
	assert_( RefsOf( a.Get( ) ) = 1 )
	assert_( a->Poke( ) > 0 )                 '' and still callable

	assert_( RefsOf( a.Get( ) ) = 1 )         '' both inner handles released
	assert_( g_destroyed = 0 )                '' but the object is still alive
end scope
assert_( g_destroyed = 1 )

'' Reassignment releases the old object and takes the new one.
g_destroyed = 0
scope
	dim as ComPtr( of IFake ) a, b
	a.Attach( NewFake( ) )
	b.Attach( NewFake( ) )
	dim as IFake ptr first = a.Get( )
	a = b                                     '' a's old object must die
	assert_( g_destroyed = 1 )
	assert_( a.Get( ) = b.Get( ) )
	assert_( RefsOf( a.Get( ) ) = 2 )
end scope
assert_( g_destroyed = 2 )

'' Assigning an empty pointer over an owning one releases it.
g_destroyed = 0
scope
	dim as ComPtr( of IFake ) a, e
	a.Attach( NewFake( ) )
	a = e
	assert_( g_destroyed = 1 )
	assert_( a.IsNull( ) = TRUE )
end scope

'' ------------------------------- 4b. re-entrancy: the ordering rule
''
'' RFC-0001 section 4 requires the NEW pointer to be AddRefed before the OLD one
'' is released.  The self-assign guard hides that rule in every simple case --
'' if old and new are the same pointer the operator exits early, so releasing
'' old can never touch new.  The rule is reachable only when releasing the old
'' object RE-ENTRANTLY drops the new object's last other reference.
''
'' Here: g2 owns X alone, g owns Y alone.  Destroying X releases g.  Assigning
'' 'g2 = g' must survive, because with the wrong order Y hits zero and is freed
'' before it is AddRefed -- a use-after-free that the correct order prevents.

dim shared as ComPtr( of IFake ) g_y

private sub DropY( )
	g_y.Release( )
end sub

g_destroyed = 0
scope
	dim as ComPtr( of IFake ) g2
	g2.Attach( NewFake( ) )                   '' X, sole owner
	g_y.Attach( NewFake( ) )                  '' Y, sole owner
	assert_( RefsOf( g2.Get( ) ) = 1 )
	assert_( RefsOf( g_y.Get( ) ) = 1 )

	g_onDestroy = @DropY                      '' destroying X releases g_y

	dim as IFake ptr y = g_y.Get( )
	g2 = g_y                                  '' the assignment under test

	assert_( g_destroyed = 1 )                '' X died...
	assert_( g2.IsNull( ) = FALSE )
	assert_( g2.Get( ) = y )                  '' ...and Y survived it
	assert_( RefsOf( g2.Get( ) ) = 1 )        '' g2 is now Y's sole owner
	assert_( g2->Poke( ) > 0 )                '' and Y is still callable
end scope
assert_( g_destroyed = 2 )
g_onDestroy = 0

'' --------------------- 4c. Release( ) nulls the field BEFORE calling out
''
'' The final Release runs the object's destructor, which may run arbitrary code,
'' which may reach back into this very handle.  It must find the handle already
'' empty rather than holding a pointer that is being freed.

dim shared as ComPtr( of IFake ) g_z
dim shared as long g_zWasNullInHook

private sub InspectZ( )
	g_zWasNullInHook = iif( g_z.IsNull( ), 1, 0 )
end sub

g_destroyed = 0
g_zWasNullInHook = -1
scope
	g_z.Attach( NewFake( ) )
	g_onDestroy = @InspectZ
	g_z.Release( )                            '' fires the hook mid-Release
	assert_( g_destroyed = 1 )
	assert_( g_zWasNullInHook = 1 )           '' the handle was already empty
	assert_( g_z.IsNull( ) = TRUE )
end scope
g_onDestroy = 0

'' ------------------------------------------------- 5. Detach and Release

g_destroyed = 0
scope
	dim as ComPtr( of IFake ) a
	a.Attach( NewFake( ) )
	dim as IFake ptr raw = a.Detach( )
	assert_( a.IsNull( ) = TRUE )
	assert_( RefsOf( raw ) = 1 )              '' the reference moved, not copied
	assert_( g_destroyed = 0 )

	'' Nothing released it -- the caller owns it now, which is the point of
	'' Detach.  Hand it to a fresh ComPtr and let that one finish the job.
	scope
		dim as ComPtr( of IFake ) b
		b.Attach( raw )
		assert_( RefsOf( b.Get( ) ) = 1 )
	end scope
	assert_( g_destroyed = 1 )
end scope

g_destroyed = 0
scope
	dim as ComPtr( of IFake ) a
	a.Attach( NewFake( ) )
	a.Release( )
	assert_( g_destroyed = 1 )
	assert_( a.IsNull( ) = TRUE )
	a.Release( )                              '' idempotent
	assert_( g_destroyed = 1 )
end scope

'' --------------------------------------------------------------- 6. CopyTo

g_destroyed = 0
scope
	dim as ComPtr( of IFake ) a
	a.Attach( NewFake( ) )

	dim as IFake ptr out_
	assert_( a.CopyTo( @out_ ) = S_OK )
	assert_( out_ = a.Get( ) )
	assert_( RefsOf( a.Get( ) ) = 2 )         '' CopyTo AddRefs

	assert_( a.CopyTo( 0 ) = E_POINTER )      '' and rejects a null out-pointer
	assert_( RefsOf( a.Get( ) ) = 2 )         '' without touching the count

	cptr( ComUnknown ptr, cast( any ptr, out_ ) )->Release( )
	assert_( RefsOf( a.Get( ) ) = 1 )
end scope
assert_( g_destroyed = 1 )

'' --------------------------------------------------------------- 7. PutRef

g_destroyed = 0
scope
	dim as ComPtr( of IFake ) a
	dim as IFake ptr ptr slot = a.PutRef( )   '' legal: the pointer is empty
	assert_( slot = @a.p )
	*slot = NewFake( )                        '' as a COM [out] parameter would
	assert_( a.IsNull( ) = FALSE )
	assert_( RefsOf( a.Get( ) ) = 1 )
end scope
assert_( g_destroyed = 1 )                    '' and it is owned, so it dies

'' PutRef on an OWNING pointer raises -> comptr-putref-owning.bas

'' ------------------------------------------------------ 8. Get, Unknown, Ref

g_destroyed = 0
scope
	dim as ComPtr( of IFake ) a
	a.Attach( NewFake( ) )
	dim as long before = RefsOf( a.Get( ) )

	assert_( a.Get( ) <> 0 )
	assert_( a.Unknown( ) <> 0 )
	assert_( cast( any ptr, a.Unknown( ) ) = cast( any ptr, a.Get( ) ) )
	assert_( RefsOf( a.Get( ) ) = before )    '' both are BORROWED: no AddRef

	assert_( a.Ref( ).Poke( ) = 1 )           '' checked dereference works
	assert_( RefsOf( a.Get( ) ) = before )
end scope
assert_( g_destroyed = 1 )

'' Ref( ) on an empty ComPtr raises -> comptr-null-ref.bas

'' -------------------------------------------------------- 9. IsEqualObject

g_destroyed = 0
scope
	dim as ComPtr( of IFake ) a, b, c
	a.Attach( NewFake( ) )
	b = a                                     '' same object
	c.Attach( NewFake( ) )                    '' different object

	assert_( a.IsEqualObject( b.Get( ) ) = TRUE )
	assert_( a.IsEqualObject( c.Get( ) ) = FALSE )
	assert_( a.IsEqualObject( 0 ) = FALSE )   '' owning vs empty

	'' the probe must not leak the references its two QI calls took
	assert_( RefsOf( a.Get( ) ) = 2 )
	assert_( RefsOf( c.Get( ) ) = 1 )
end scope
assert_( g_destroyed = 2 )

'' ------------------------------------------------- 10. the global operators

g_destroyed = 0
scope
	dim as ComPtr( of IFake ) a
	a.Attach( NewFake( ) )

	assert_( a->Poke( ) = 1 )                 '' operator ->
	assert_( a->Poke( ) = 2 )
	assert_( (*a).Poke( ) = 3 )               '' operator *
	assert_( RefsOf( a.Get( ) ) = 1 )         '' neither touches the count
end scope
assert_( g_destroyed = 1 )

'' ------------------------------------------------------- 11. early return

private function EarlyReturn( byval bail as boolean ) as long
	dim as ComPtr( of IFake ) a
	a.Attach( NewFake( ) )
	if( bail ) then return 1                  '' released on this path...
	return 0                                  '' ...and on this one
end function

g_destroyed = 0
assert_( EarlyReturn( TRUE ) = 1 )
assert_( g_destroyed = 1 )
assert_( EarlyReturn( FALSE ) = 0 )
assert_( g_destroyed = 2 )

'' ------------------------------------------------------ 12. byref vs byval

private sub TakesByref( byref a as ComPtr( of IFake ), byref n as long )
	n = RefsOf( a.Get( ) )
end sub

private sub TakesByval( byval a as ComPtr( of IFake ), byref n as long )
	n = RefsOf( a.Get( ) )
end sub

g_destroyed = 0
scope
	dim as ComPtr( of IFake ) a
	a.Attach( NewFake( ) )
	dim as long seen

	TakesByref( a, seen )
	assert_( seen = 1 )                       '' byref: no refcount traffic
	assert_( RefsOf( a.Get( ) ) = 1 )

	TakesByval( a, seen )
	assert_( seen = 2 )                       '' byval: a real copy...
	assert_( RefsOf( a.Get( ) ) = 1 )         '' ...released when it returns
end scope
assert_( g_destroyed = 1 )

'' ------------------------------------------------- 13. container growth

g_destroyed = 0
scope
	dim as Array( of ComPtr( of IFake ) ) v
	dim as ComPtr( of IFake ) shared_
	shared_.Attach( NewFake( ) )

	for i as integer = 1 to 64                '' forces several reallocations
		v.Push( shared_ )
	next
	assert_( v.Count( ) = 64 )
	assert_( RefsOf( shared_.Get( ) ) = 65 )  '' one per element, plus shared_
	assert_( g_destroyed = 0 )
end scope
assert_( g_destroyed = 1 )                    '' the array released all 64

'' --------------------------------------- 14. as a field of another type

type Holder
	as ComPtr( of IFake ) inner
end type

g_destroyed = 0
scope
	dim as Holder h
	h.inner.Attach( NewFake( ) )
	assert_( RefsOf( h.inner.Get( ) ) = 1 )
end scope
assert_( g_destroyed = 1 )                    '' Holder's implicit dtor released it

'' ------------------------------- 15. against a real COM object, not the fake
''
'' The fake could quietly diverge from what COM does, so the core claims are
'' repeated here against a live in-process server.  CLSID_ShellLink is present
'' on every Windows and needs no registration.  Exact counts are NOT asserted:
'' a real object's refcount is its own business and other code may hold
'' references.  What is asserted is the DELTA and the identity rule.

scope
	dim as GUID clsid_ = type<GUID>( &h00021401, &h0000, &h0000, _
	                                 { &hC0, &h00, &h00, &h00, &h00, &h00, &h00, &h46 } )
	dim as GUID iid_   = type<GUID>( &h000214F9, &h0000, &h0000, _
	                                 { &hC0, &h00, &h00, &h00, &h00, &h00, &h00, &h46 } )

	assert_( succeeded( CoInitializeEx( 0, COINIT_APARTMENTTHREADED ) ) )

	dim as ComPtr( of ComUnknown ) link
	dim as HRESULT hr = CoCreateInstance( @clsid_, 0, CLSCTX_INPROC_SERVER, _
	                                      @iid_, cptr( any ptr ptr, link.PutRef( ) ) )
	assert_( succeeded( hr ) )
	assert_( link.IsNull( ) = FALSE )

	'' AddRef/Release through the wrapper move the count by exactly one
	dim as ULONG base_ = link.Unknown( )->AddRef( )
	link.Unknown( )->Release( )
	scope
		dim as ComPtr( of ComUnknown ) copy_ = link
		dim as ULONG withCopy = link.Unknown( )->AddRef( )
		link.Unknown( )->Release( )
		assert_( withCopy = base_ + 1 )
	end scope
	dim as ULONG after = link.Unknown( )->AddRef( )
	link.Unknown( )->Release( )
	assert_( after = base_ )                  '' the copy gave its reference back

	'' the COM identity rule, which the fake models
	dim as ComUnknown ptr raw
	assert_( link.CopyTo( @raw ) = S_OK )
	assert_( link.IsEqualObject( raw ) = TRUE )
	raw->Release( )

	link.Release( )
	CoUninitialize( )
end scope

print "comptr: ok"
