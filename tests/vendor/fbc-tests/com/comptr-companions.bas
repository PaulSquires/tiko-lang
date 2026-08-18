' TEST_MODE : COMPILE_AND_RUN_OK

'' RFC-0004: ComInit, ComHeapPtr( of T ), and the connection/site helpers.
''
'' The section that matters most is 2, which asserts the ORDERING RULE -- that a
'' ComPtr declared after a ComInit is released while the apartment is still
'' alive.  RFC-0004 admitted the rule might not be expressible as a test.  It is,
'' by making the object's Release ASK whether COM is still initialised:
'' CoCreateInstance returns CO_E_NOTINITIALIZED once CoUninitialize has run, so
'' the object can record what it saw and the test can assert on it.  Section 2b
'' then declares the two the wrong way round and asserts the OPPOSITE, which is
'' what makes the rule's importance measurable rather than merely stated.
''
'' NOT here, because each is a compile error:
''   - copying a ComInit      -> fail-cominit-copy.bas
''   - copying a ComHeapPtr   -> fail-comheapptr-copy.bas

#include once "fb/comptr.bi"
using FB

#define assert_(e) if (e) = 0 then fb_Assert(__FILE__, __LINE__, __FUNCTION__, #e)

'' CAST IS REQUIRED.  On x64 a bare &h8xxxxxxx literal is a POSITIVE 64-bit
'' INTEGER (&h80010106 = 2147549446), while an HRESULT is a signed LONG holding
'' -2147417850 -- so 'hr = &h80010106' is silently FALSE for every failure code.
'' The named constants in windows.bi are already cast correctly; only
'' hand-written literals are affected, and this test wrote two of them.
#define CO_E_NOTINITIALIZED_ cast( HRESULT, &h800401F0 )
#define RPC_E_CHANGED_MODE_  cast( HRESULT, &h80010106 )

dim shared as GUID CLSID_ShellLink_ = type<GUID>( &h00021401, &h0000, &h0000, _
                                                  { &hC0, &h00, &h00, &h00, &h00, &h00, &h00, &h46 } )
dim shared as GUID IID_IUnknown_ = type<GUID>( &h00000000, &h0000, &h0000, _
                                               { &hC0, &h00, &h00, &h00, &h00, &h00, &h00, &h46 } )

'' Is COM initialised on this thread right now?
private function ComIsAlive( ) as HRESULT
	dim as any ptr tmp = 0
	dim as HRESULT hr = CoCreateInstance( @CLSID_ShellLink_, 0, CLSCTX_INPROC_SERVER, @IID_IUnknown_, @tmp )
	if( tmp <> 0 ) then cptr( ComUnknown ptr, tmp )->Release( )
	return hr
end function

'' ---------------------------------------------------------------- fixtures

type IFake extends ComUnknown
	declare abstract function Poke( ) as long
end type

type FakeVtbl
	as any ptr QueryInterface, AddRef, Release, Poke
end type
type Fake
	as FakeVtbl ptr lpVtbl
	as long        refs
end type

dim shared as FakeVtbl g_vtbl
dim shared as long     g_destroyed
dim shared as HRESULT  g_hrSeenByRelease

private function FQI cdecl ( byval s as Fake ptr, byval riid as const GUID ptr, byval ppv as any ptr ptr ) as HRESULT
	if( ppv = 0 ) then return E_POINTER
	*ppv = s : s->refs += 1 : return S_OK
end function
private function FAddRef cdecl ( byval s as Fake ptr ) as ULONG
	s->refs += 1 : return s->refs
end function
private function FRelease cdecl ( byval s as Fake ptr ) as ULONG
	s->refs -= 1
	dim as long n = s->refs
	if( n = 0 ) then
		'' The whole point of section 2: record whether the apartment was still
		'' alive at the moment this object was released.
		g_hrSeenByRelease = ComIsAlive( )
		g_destroyed += 1
		deallocate( s )
	end if
	return n
end function
private function FPoke cdecl ( byval s as Fake ptr ) as long
	return 1
end function

private function NewFake( ) as IFake ptr
	dim as Fake ptr f = callocate( sizeof( Fake ) )
	f->lpVtbl = @g_vtbl : f->refs = 1
	return cptr( IFake ptr, cast( any ptr, f ) )
end function

g_vtbl.QueryInterface = cast( any ptr, @FQI )
g_vtbl.AddRef         = cast( any ptr, @FAddRef )
g_vtbl.Release        = cast( any ptr, @FRelease )
g_vtbl.Poke           = cast( any ptr, @FPoke )

'' -------------------------------------------------------- 1. ComInit basics

scope
	dim as ComInit co
	assert_( co.Ok( ) = TRUE )
	assert_( co.IsFailed( ) = FALSE )
	assert_( co.hr = S_OK )
	assert_( ComIsAlive( ) = S_OK )

	'' A NESTED init on the same thread and mode returns S_FALSE, which is
	'' SUCCESS -- treating it as failure is the classic bug with this API, and
	'' it must still uninitialise, because the calls are counted.
	scope
		dim as ComInit inner
		assert_( inner.hr = S_FALSE )
		assert_( inner.Ok( ) = TRUE )        '' S_FALSE is Ok
		assert_( inner.IsFailed( ) = FALSE )
	end scope
	assert_( ComIsAlive( ) = S_OK )          '' inner's uninitialise did not kill it

	'' A FAILED init must not uninitialise: this thread's apartment belongs to
	'' the outer ComInit, and taking it down would break it.
	scope
		dim as ComInit wrong = ComInit( COINIT_MULTITHREADED )
		assert_( wrong.hr = RPC_E_CHANGED_MODE_ )
		assert_( wrong.Ok( ) = FALSE )
		assert_( wrong.IsFailed( ) = TRUE )
	end scope
	assert_( ComIsAlive( ) = S_OK )          '' still alive
end scope

'' outermost ComInit gone -- the apartment is now down
assert_( ComIsAlive( ) = CO_E_NOTINITIALIZED_ )

'' ------------------------------- 2. THE ORDERING RULE, asserted

g_destroyed = 0
g_hrSeenByRelease = &hFFFFFFFF
scope
	dim as ComInit co                        '' declared FIRST -- correct
	assert_( co.Ok( ) )
	dim as ComPtr( of IFake ) p
	p.Attach( NewFake( ) )
	assert_( p->Poke( ) = 1 )
end scope                                    '' p released, THEN CoUninitialize
assert_( g_destroyed = 1 )
assert_( g_hrSeenByRelease = S_OK )          '' the apartment was still alive

'' ------------------- 2b. and the same thing written the WRONG way round
''
'' This is what the rule protects against, demonstrated rather than asserted in
'' prose.  The ComPtr is declared FIRST, so it is destroyed LAST -- after
'' CoUninitialize has already run.  On a real interface pointer that is
'' undefined behaviour; the fake survives it and reports what it saw.

g_destroyed = 0
g_hrSeenByRelease = &hFFFFFFFF
scope
	dim as ComPtr( of IFake ) p              '' declared FIRST -- WRONG
	p.Attach( NewFake( ) )
	scope
		dim as ComInit co
		assert_( co.Ok( ) )
		assert_( ComIsAlive( ) = S_OK )
	end scope                                '' CoUninitialize runs HERE
end scope                                    '' ...and p is released after it
assert_( g_destroyed = 1 )
assert_( g_hrSeenByRelease = CO_E_NOTINITIALIZED_ )   '' released into a dead apartment


'' ------------------- 3b. ComHeapPtr, with every alloc and free COUNTED
''
'' CoRegisterMallocSpy is the only way to observe CoTaskMemAlloc/CoTaskMemFree
'' from outside, and without it the central claim of this type -- that a block is
'' freed exactly once -- is not assertable at all.  Rank 7's done-criterion says
'' "frees exactly once", so it is worth the fifteen-slot vtable.
''
'' Without this section, an Alloc( ) that forgot to free the block it was
'' replacing passed every other assertion here.

type SpyVtbl
	as any ptr QueryInterface, AddRef, Release
	as any ptr PreAlloc, PostAlloc, PreFree, PostFree
	as any ptr PreRealloc, PostRealloc, PreGetSize, PostGetSize
	as any ptr PreDidAlloc, PostDidAlloc, PreHeapMinimize, PostHeapMinimize
end type
type SpyObj
	as SpyVtbl ptr lpVtbl
end type

dim shared as SpyVtbl g_spyVtbl
dim shared as SpyObj  g_spy
dim shared as long    g_allocs, g_frees

private function SpyQI cdecl ( byval s as SpyObj ptr, byval riid as const GUID ptr, byval ppv as any ptr ptr ) as HRESULT
	if( ppv = 0 ) then return E_POINTER
	*ppv = s : return S_OK
end function
private function SpyAddRef cdecl ( byval s as SpyObj ptr ) as ULONG : return 2 : end function
private function SpyRelease cdecl ( byval s as SpyObj ptr ) as ULONG : return 1 : end function
private function SpyPreAlloc cdecl ( byval s as SpyObj ptr, byval cb as uinteger ) as uinteger
	return cb
end function
private function SpyPostAlloc cdecl ( byval s as SpyObj ptr, byval p as any ptr ) as any ptr
	if( p <> 0 ) then g_allocs += 1
	return p
end function
private function SpyPreFree cdecl ( byval s as SpyObj ptr, byval p as any ptr, byval spyed as long ) as any ptr
	if( p <> 0 ) then g_frees += 1
	return p
end function
private sub SpyPostFree cdecl ( byval s as SpyObj ptr, byval spyed as long ) : end sub
private function SpyPreRealloc cdecl ( byval s as SpyObj ptr, byval p as any ptr, byval cb as uinteger, byval ppNew as any ptr ptr, byval spyed as long ) as uinteger
	*ppNew = p : return cb
end function
private function SpyPostRealloc cdecl ( byval s as SpyObj ptr, byval p as any ptr, byval spyed as long ) as any ptr
	return p
end function
private function SpyPreGetSize cdecl ( byval s as SpyObj ptr, byval p as any ptr, byval spyed as long ) as any ptr
	return p
end function
private function SpyPostGetSize cdecl ( byval s as SpyObj ptr, byval cb as uinteger, byval spyed as long ) as uinteger
	return cb
end function
private function SpyPreDidAlloc cdecl ( byval s as SpyObj ptr, byval p as any ptr, byval spyed as long ) as any ptr
	return p
end function
private function SpyPostDidAlloc cdecl ( byval s as SpyObj ptr, byval p as any ptr, byval spyed as long, byval act as long ) as long
	return act
end function
private sub SpyPreHeapMinimize cdecl ( byval s as SpyObj ptr ) : end sub
private sub SpyPostHeapMinimize cdecl ( byval s as SpyObj ptr ) : end sub

g_spyVtbl.QueryInterface   = cast( any ptr, @SpyQI )
g_spyVtbl.AddRef           = cast( any ptr, @SpyAddRef )
g_spyVtbl.Release          = cast( any ptr, @SpyRelease )
g_spyVtbl.PreAlloc         = cast( any ptr, @SpyPreAlloc )
g_spyVtbl.PostAlloc        = cast( any ptr, @SpyPostAlloc )
g_spyVtbl.PreFree          = cast( any ptr, @SpyPreFree )
g_spyVtbl.PostFree         = cast( any ptr, @SpyPostFree )
g_spyVtbl.PreRealloc       = cast( any ptr, @SpyPreRealloc )
g_spyVtbl.PostRealloc      = cast( any ptr, @SpyPostRealloc )
g_spyVtbl.PreGetSize       = cast( any ptr, @SpyPreGetSize )
g_spyVtbl.PostGetSize      = cast( any ptr, @SpyPostGetSize )
g_spyVtbl.PreDidAlloc      = cast( any ptr, @SpyPreDidAlloc )
g_spyVtbl.PostDidAlloc     = cast( any ptr, @SpyPostDidAlloc )
g_spyVtbl.PreHeapMinimize  = cast( any ptr, @SpyPreHeapMinimize )
g_spyVtbl.PostHeapMinimize = cast( any ptr, @SpyPostHeapMinimize )
g_spy.lpVtbl = @g_spyVtbl

scope
	assert_( CoRegisterMallocSpy( cptr( IMallocSpy ptr, cast( any ptr, @g_spy ) ) ) = S_OK )

	'' one alloc, one free, at scope exit
	g_allocs = 0 : g_frees = 0
	scope
		dim as ComHeapPtr( of ushort ) h
		assert_( h.Alloc( 32 ) = TRUE )
		assert_( g_allocs = 1 )
		assert_( g_frees = 0 )
	end scope
	assert_( g_frees = 1 )                   '' freed exactly once by the destructor

	'' Alloc over a live block frees the old one FIRST
	g_allocs = 0 : g_frees = 0
	scope
		dim as ComHeapPtr( of ushort ) h
		h.Alloc( 32 )
		h.Alloc( 8 )
		assert_( g_allocs = 2 )
		assert_( g_frees = 1 )               '' the replaced block went
	end scope
	assert_( g_frees = 2 )

	'' Attach over a live block frees it too
	g_allocs = 0 : g_frees = 0
	scope
		dim as ComHeapPtr( of ushort ) h
		h.Alloc( 16 )
		h.Attach( cptr( ushort ptr, CoTaskMemAlloc( 8 ) ) )
		assert_( g_allocs = 2 )
		assert_( g_frees = 1 )
	end scope
	assert_( g_frees = 2 )

	'' Detach transfers OUT: the destructor must not free it
	g_allocs = 0 : g_frees = 0
	dim as ushort ptr detached
	scope
		dim as ComHeapPtr( of ushort ) h
		h.Alloc( 16 )
		detached = h.Detach( )
		assert_( g_frees = 0 )
	end scope
	assert_( g_frees = 0 )                   '' still nobody freed it -- we own it
	'' and we must, or CoRevokeMallocSpy below fails with outstanding allocations
	CoTaskMemFree( detached )
	assert_( g_frees = 1 )

	'' Free is idempotent: exactly one free, not two
	g_allocs = 0 : g_frees = 0
	scope
		dim as ComHeapPtr( of ushort ) h
		h.Alloc( 16 )
		h.Free( )
		h.Free( )
		assert_( g_frees = 1 )
	end scope
	assert_( g_frees = 1 )

	assert_( CoRevokeMallocSpy( ) = S_OK )
end scope

'' --------------------------------------------------- 3. ComHeapPtr basics

scope
	dim as ComHeapPtr( of ushort ) h
	assert_( h.IsNull( ) = TRUE )
	assert_( h.Get( ) = 0 )
	assert_( h.Detach( ) = 0 )
	h.Free( )                                '' idempotent when empty
	assert_( h.IsNull( ) = TRUE )

	assert_( h.Alloc( 32 ) = TRUE )
	assert_( h.IsNull( ) = FALSE )
	h.Get( )[0] = asc( "A" )
	h.Get( )[1] = 0
	assert_( h.Get( )[0] = asc( "A" ) )

	'' Alloc over an existing block frees it first
	assert_( h.Alloc( 8 ) = TRUE )
	assert_( h.IsNull( ) = FALSE )

	'' Detach transfers ownership out
	dim as ushort ptr raw = h.Detach( )
	assert_( h.IsNull( ) = TRUE )
	assert_( raw <> 0 )
	CoTaskMemFree( raw )

	'' Attach takes it back
	h.Attach( cptr( ushort ptr, CoTaskMemAlloc( 16 ) ) )
	assert_( h.IsNull( ) = FALSE )
	h.Free( )
	assert_( h.IsNull( ) = TRUE )
	h.Free( )                                '' idempotent
end scope

'' PutRef on an owning ComHeapPtr raises -> fail is a runtime abort, so it lives
'' in its own module alongside the ComPtr one.
scope
	dim as ComHeapPtr( of ushort ) h
	dim as ushort ptr ptr slot = h.PutRef( ) '' legal while empty
	assert_( slot = @h.p )
end scope

'' ------------------------ 4. ComHeapPtr against a real API that allocates
''
'' IShellItem.GetDisplayName hands back a CoTaskMemAlloc'd LPWSTR that the caller
'' must free -- exactly the shape this type exists for, and one of the commonest
'' leaks in shell code.

type IShellItem_ extends ComUnknown
	declare abstract function BindToHandler( byval pbc as any ptr, byval bhid as const GUID ptr, _
	                                         byval riid as const GUID ptr, byval ppv as any ptr ptr ) as HRESULT
	declare abstract function GetParent( byval ppsi as any ptr ptr ) as HRESULT
	declare abstract function GetDisplayName( byval sigdn as long, byval ppszName as ushort ptr ptr ) as HRESULT
	declare abstract function GetAttributes( byval sfgaoMask as ulong, byval psfgaoAttribs as ulong ptr ) as HRESULT
	declare abstract function Compare( byval psi as any ptr, byval hint as ulong, byval piOrder as long ptr ) as HRESULT
end type

dim shared as GUID IID_IShellItem_ = type<GUID>( &h43826D1E, &hE718, &h42EE, _
                                                 { &hBC, &h55, &hA1, &hE2, &h61, &hC3, &h7B, &hFE } )

extern "windows"
	declare function SHCreateItemFromParsingName lib "shell32" ( byval pszPath as const wstring ptr, _
	                                                             byval pbc as any ptr, _
	                                                             byval riid as const GUID ptr, _
	                                                             byval ppv as any ptr ptr ) as HRESULT
end extern

scope
	dim as ComInit co                        '' FIRST, per section 2
	assert_( co.Ok( ) )

	scope
		dim as ComPtr( of IShellItem_ ) item
		dim as HRESULT hr = SHCreateItemFromParsingName( @wstr( "C:\Windows" ), 0, _
		                                                 @IID_IShellItem_, _
		                                                 cptr( any ptr ptr, item.PutRef( ) ) )
		assert_( succeeded( hr ) )
		assert_( item.IsNull( ) = FALSE )

		'' NOTE: 'name' is a reserved word in FreeBASIC -- the NAME statement --
		'' so the obvious identifier here is error 4.
		dim as ComHeapPtr( of ushort ) dispName
		hr = item->GetDisplayName( &h80058000, dispName.PutRef( ) )   '' SIGDN_FILESYSPATH
		assert_( succeeded( hr ) )
		assert_( dispName.IsNull( ) = FALSE )
		assert_( len( *cptr( wstring ptr, dispName.Get( ) ) ) > 0 )
	end scope                                '' dispName freed, item released
end scope

'' -------------------------------- 5. connection points, against a fake
''
'' A fake object exposing IConnectionPointContainer and IConnectionPoint, so the
'' advise/unadvise round trip and the cookie can be asserted exactly.

type CpVtbl
	as any ptr QueryInterface, AddRef, Release
	as any ptr GetConnectionInterface, GetConnectionPointContainer, Advise, Unadvise, EnumConnections
end type
type CpcVtbl
	as any ptr QueryInterface, AddRef, Release
	as any ptr EnumConnectionPoints, FindConnectionPoint
end type

type Src_ as Src
type CpObj
	as CpVtbl ptr lpVtbl
	as Src_ ptr  owner
end type
type Src
	as CpcVtbl ptr lpVtbl          '' the IConnectionPointContainer view
	as long        refs
	as DWORD       lastCookie
	as long        adviseCount, unadviseCount
	as any ptr     lastSink
	as CpObj       cp              '' the IConnectionPoint view, another address
end type

dim shared as CpcVtbl g_cpcVtbl
dim shared as CpVtbl  g_cpVtbl
dim shared as GUID    IID_Sink = type<GUID>( &h99990000, &h0001, &h0002, { 1,2,3,4,5,6,7,8 } )
dim shared as GUID    IID_Other = type<GUID>( &hAAAA0000, &h0001, &h0002, { 1,2,3,4,5,6,7,8 } )

declare function SrcAddRef cdecl ( byval s as Src ptr ) as ULONG
declare function SrcRelease cdecl ( byval s as Src ptr ) as ULONG

private function SrcQI cdecl ( byval s as Src ptr, byval riid as const GUID ptr, byval ppv as any ptr ptr ) as HRESULT
	if( ppv = 0 ) then return E_POINTER
	*ppv = 0
	'' IID_IConnectionPointContainer
	dim as GUID iidCpc = type<GUID>( &hB196B284, &hBAB4, &h101A, _
	                                 { &hB6, &h9C, &h00, &hAA, &h00, &h34, &h1D, &h07 } )
	if( IsEqualGUID( riid, @iidCpc ) orelse IsEqualGUID( riid, @IID_IUnknown_ ) ) then
		*ppv = s
		SrcAddRef( s )
		return S_OK
	end if
	return E_NOINTERFACE
end function
private function SrcAddRef cdecl ( byval s as Src ptr ) as ULONG
	s->refs += 1 : return s->refs
end function
private function SrcRelease cdecl ( byval s as Src ptr ) as ULONG
	s->refs -= 1 : return s->refs
end function
private function SrcFind cdecl ( byval s as Src ptr, byval riid as const GUID ptr, byval ppCP as any ptr ptr ) as HRESULT
	if( ppCP = 0 ) then return E_POINTER
	*ppCP = 0
	if( IsEqualGUID( riid, @IID_Sink ) = 0 ) then return &h80040200   '' CONNECT_E_NOCONNECTION
	*ppCP = @s->cp
	SrcAddRef( s )
	return S_OK
end function
private function SrcEnumCp cdecl ( byval s as Src ptr, byval pp as any ptr ptr ) as HRESULT
	return E_NOTIMPL
end function

private function CpQI cdecl ( byval c as CpObj ptr, byval riid as const GUID ptr, byval ppv as any ptr ptr ) as HRESULT
	return SrcQI( c->owner, riid, ppv )
end function
private function CpAddRef cdecl ( byval c as CpObj ptr ) as ULONG
	return SrcAddRef( c->owner )
end function
private function CpRelease cdecl ( byval c as CpObj ptr ) as ULONG
	return SrcRelease( c->owner )
end function
private function CpAdvise cdecl ( byval c as CpObj ptr, byval sink as any ptr, byval pdw as DWORD ptr ) as HRESULT
	if( sink = 0 orelse pdw = 0 ) then return E_POINTER
	'' A sink of &hDEAD makes Advise FAIL -- but write the out-parameter first,
	'' which real COM objects are entitled to do and some do.  That is what makes
	'' "the cookie is written only on success" an assertable claim rather than an
	'' accident of where the failure happens to occur.
	if( sink = cast( any ptr, &hDEAD ) ) then
		*pdw = &hBADC0DE
		return E_FAIL
	end if
	c->owner->adviseCount += 1
	c->owner->lastCookie += 1
	c->owner->lastSink = sink
	*pdw = c->owner->lastCookie
	return S_OK
end function
private function CpUnadvise cdecl ( byval c as CpObj ptr, byval dw as DWORD ) as HRESULT
	if( dw <> c->owner->lastCookie ) then return E_POINTER
	c->owner->unadviseCount += 1
	return S_OK
end function
private function CpGetIface cdecl ( byval c as CpObj ptr, byval piid as GUID ptr ) as HRESULT
	return E_NOTIMPL
end function
private function CpGetCpc cdecl ( byval c as CpObj ptr, byval pp as any ptr ptr ) as HRESULT
	return E_NOTIMPL
end function
private function CpEnum cdecl ( byval c as CpObj ptr, byval pp as any ptr ptr ) as HRESULT
	return E_NOTIMPL
end function

g_cpcVtbl.QueryInterface       = cast( any ptr, @SrcQI )
g_cpcVtbl.AddRef               = cast( any ptr, @SrcAddRef )
g_cpcVtbl.Release              = cast( any ptr, @SrcRelease )
g_cpcVtbl.EnumConnectionPoints = cast( any ptr, @SrcEnumCp )
g_cpcVtbl.FindConnectionPoint  = cast( any ptr, @SrcFind )

g_cpVtbl.QueryInterface              = cast( any ptr, @CpQI )
g_cpVtbl.AddRef                      = cast( any ptr, @CpAddRef )
g_cpVtbl.Release                     = cast( any ptr, @CpRelease )
g_cpVtbl.GetConnectionInterface      = cast( any ptr, @CpGetIface )
g_cpVtbl.GetConnectionPointContainer = cast( any ptr, @CpGetCpc )
g_cpVtbl.Advise                      = cast( any ptr, @CpAdvise )
g_cpVtbl.Unadvise                    = cast( any ptr, @CpUnadvise )
g_cpVtbl.EnumConnections             = cast( any ptr, @CpEnum )

scope
	dim as Src s
	s.lpVtbl    = @g_cpcVtbl
	s.refs      = 1
	s.cp.lpVtbl = @g_cpVtbl
	s.cp.owner  = @s

	dim as long sinkObj
	dim as any ptr sink = @sinkObj

	dim as DWORD cookie
	assert_( ComAdvise( @s, sink, @IID_Sink, cookie ) = S_OK )
	assert_( cookie = 1 )                    '' the cookie round-trips
	assert_( s.adviseCount = 1 )
	assert_( s.lastSink = sink )
	assert_( s.refs = 1 )                    '' every reference taken was released

	assert_( ComUnadvise( @s, @IID_Sink, cookie ) = S_OK )
	assert_( s.unadviseCount = 1 )
	assert_( s.refs = 1 )

	'' an interface the container has no connection point for
	dim as DWORD c2
	assert_( ComAdvise( @s, sink, @IID_Other, c2 ) = cast( HRESULT, &h80040200 ) )   '' CONNECT_E_NOCONNECTION
	assert_( c2 = 0 )                        '' cookie untouched on failure
	assert_( s.refs = 1 )

	'' Advise itself fails, having already written the out-parameter
	dim as DWORD c4 = 0
	assert_( ComAdvise( @s, cast( any ptr, &hDEAD ), @IID_Sink, c4 ) = E_FAIL )
	assert_( c4 = 0 )                        '' NOT the &hBADC0DE the callee wrote
	assert_( s.refs = 1 )

	'' bad arguments
	dim as DWORD c3
	assert_( ComAdvise( 0, sink, @IID_Sink, c3 ) = E_POINTER )
	assert_( ComAdvise( @s, 0, @IID_Sink, c3 ) = E_POINTER )
	assert_( ComUnadvise( 0, @IID_Sink, 1 ) = E_POINTER )

	'' the object does not implement IObjectWithSite
	assert_( ComSetSite( @s, 0 ) = E_NOINTERFACE )
	assert_( ComSetSite( 0, 0 ) = E_POINTER )
	assert_( s.refs = 1 )
end scope

print "comptr-companions: ok"
