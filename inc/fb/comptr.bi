'' comptr.bi -- ATL-style smart pointers for COM interface pointers
''
'' ComPtr( of T ) owns one reference to a COM interface and releases it when it
'' goes away -- at scope exit, on reassignment, or when a container holding it
'' is destroyed -- with no Release at the call site and no ownership convention
'' to document.
''
''     dim as ComPtr( of IShellLinkW ) link
''     hr = CoCreateInstance( @CLSID_ShellLink, 0, CLSCTX_INPROC_SERVER, _
''                            @IID_IShellLinkW, cptr( any ptr ptr, link.PutRef( ) ) )
''     if( failed( hr ) ) then exit function      '' link releases itself
''     link->SetDescription( "hello" )
''
'' Design docset: C:\dev\docs\com\.  This file implements RFC-0001 (the owning
'' pointer), RFC-0002 (the IidOf trait), RFC-0003 (ComQIPtr and the query and
'' creation procedures) and RFC-0004 (ComInit, ComHeapPtr, and the connection
'' and site helpers).
''
'' -------------------------------------------------------------- the layout
''
'' One field, a T ptr.  There is no control block, because a COM object counts
'' its own references -- which is the whole reason this is a library and not a
'' compiler feature, unlike docs/BSTR.
''
'' A ComPtr is either EMPTY (p = 0) or OWNING (p <> 0 and it holds exactly one
'' reference it must release).  There is no third state, which is what makes
'' the destructor unconditional.
''
'' ---------------------------------------------------------- how it dispatches
''
'' Lifetime calls go through ComUnknown, an abstract declaration of IUnknown.
'' Two facts behind that, both measured rather than assumed (docs/com,
'' RFC-0001 section 8):
''
''   - The cast MUST launder through ANY PTR.  A direct cptr( ComUnknown ptr,
''     this.p ) is error 301, because T is not declared as deriving from OUR
''     ComUnknown.  hAsUnk does the laundering.
''
''   - Abstract dispatch lands on COM slot indices.  Reading symb-comp.bas
''     alone suggests otherwise -- hSetMinimumVtableSize puts a null at slot 0
''     and RTTI at slot 1, with virtuals from index 2, while COM wants
''     QueryInterface at 0.  It was measured both against a hand-built vtable
''     and against a live CLSID_ShellLink.  AfxNova has relied on this for
''     years, but production use is not a measurement.
''
'' ------------------------------------------------------ what is NOT provided
''
'' NO IMPLICIT CONVERSION TO T PTR.  ATL's 'operator T*' is what makes CComPtr
'' a drop-in for a raw pointer and is also what makes ATL code leak: every
'' function taking a T* silently accepts the wrapper, including the ones that
'' store it.  Get( ) is explicit and greppable.
''
'' NO COMPARISON OPERATORS.  Two pointers to one COM object may differ, so
'' pointer equality is not object identity.  IsEqualObject( ) is the defined
'' test -- it queries both sides for IID_IUnknown and compares.
''
'' NO DERIVED-TO-BASE CONVERSION.  Unlike SharedPtr's SpCast, which may
'' reinterpret because FreeBASIC is single-inheritance, two interfaces on one
'' COM object need not share an address -- tear-offs, aggregation and every
'' out-of-process proxy hand back a different pointer.  Conversion is always a
'' real QueryInterface -- see ComCast.
''
'' EVERY COPY IS A REAL REFCOUNT OPERATION, and here that is worse than it is
'' for SharedPtr.  There is no move constructor and no return-value
'' optimisation, so returning a ComPtr by value costs an AddRef and a Release
'' -- and on a proxy those are MARSHALLED CALLS, not increments.  Pass BYREF
'' unless the callee genuinely stores the handle.
''
'' NO THREAD SAFETY, AND NO CLAIM OF ANY.  The count belongs to the object.
'' Note this differs from SharedPtr, which does guarantee its control block
'' under -mt.  The real cross-thread hazard in COM is not the count anyway --
'' it is apartment affinity, which nothing here addresses: a ComPtr copied to
'' another thread refcounts perfectly and is still wrong.
''
'' T IS UNCONSTRAINED, AND CANNOT BE.  ComPtr( of SomePlainUdt ) compiles,
'' instantiates and links; the first Release then jumps through whatever the
'' first eight bytes of that type happen to be.  There are no constraints on
'' type parameters, and typeof( ) does not see through one, so this cannot be
'' checked.  It is a contract, and breaking it is silent -- the same footing as
'' SpCast's requirement that the base have a virtual destructor.
''
'' ------------------------------------------------------------- raising traps
''
'' Ref( ) on an empty pointer and PutRef( ) on an owning one both raise
'' FB_RTERROR_ILLEGALFUNCTIONCALL.  These are FATAL PROGRAMMING-ERROR TRAPS,
'' not recoverable conditions.  Unhandled they abort with
''
''     Aborting due to runtime error 1 (illegal function call) at line N
''
'' naming the line, and under -exx the procedure too.  DO NOT install
'' 'on error goto' and continue past one: FreeBASIC's error path does NOT
'' unwind scopes -- measured -- so every ComPtr and every DEFER in the
'' abandoned scopes is skipped, and recovering from a leak trap by leaking is
'' not an improvement.

#pragma once

'' For GUID, HRESULT and ULONG.  Every program that has a COM interface pointer
'' to wrap has already included this; win/guiddef.bi alone supplies GUID and
'' ULONG but not HRESULT.
#include once "windows.bi"

'' For CoCreateInstance, CLSIDFromProgID and the CLSCTX_ constants, used by
'' ComCreate / ComCreateFromProgID.
#include once "win/objbase.bi"

'' For FB_RTERROR_ILLEGALFUNCTIONCALL, as sharedptr.bi and optional.bi do.
#include once "fberror.bi"

namespace FB

'' --------------------------------------------------------------- IUnknown
''
'' Declared here rather than taken from win/unknwnbase.bi because that one is
'' the C-style vtbl form, whose call shape is p->lpVtbl->M( p, ... ).  This
'' form dispatches directly, so a user's T declared the same way gives
'' 'ptr->Method( a, b )' through the arrow operator below.
type ComUnknown extends object
	declare abstract function QueryInterface( byval riid as const GUID ptr, byval ppv as any ptr ptr ) as HRESULT
	declare abstract function AddRef( ) as ULONG
	declare abstract function Release( ) as ULONG
end type

'' Spelled in concrete types rather than in DISPID / LCID / LPOLESTR, which
'' windows.bi alone does not supply -- they arrive with oaidl.bi.  The layout is
'' identical; only the names differ.
type ComDispatch extends ComUnknown
	declare abstract function GetTypeInfoCount( byval pctinfo as ulong ptr ) as HRESULT
	declare abstract function GetTypeInfo( byval iTInfo as ulong, byval lcid as ulong, byval ppTInfo as any ptr ptr ) as HRESULT
	declare abstract function GetIDsOfNames( byval riid as const GUID ptr, byval rgszNames as wstring ptr ptr, _
	                                         byval cNames as ulong, byval lcid as ulong, byval rgDispId as long ptr ) as HRESULT
	declare abstract function Invoke( byval dispIdMember as long, byval riid as const GUID ptr, byval lcid as ulong, _
	                                  byval wFlags as ushort, byval pDispParams as any ptr, byval pVarResult as any ptr, _
	                                  byval pExcepInfo as any ptr, byval puArgErr as ulong ptr ) as HRESULT
end type

'' ------------------------------------------------------------ the IID trait
''
'' There is no __uuidof.  A generic body cannot ask what T is bound to, because
'' typeof( ) does not see through a type parameter -- so the IID is supplied by
'' an OVERLOADED FREE FUNCTION resolved at the instantiation site, dispatched on
'' a generic marker that is never read.  This is not invented here: FB.Map
'' needs a hash for an arbitrary key type and solves it the same way (see
'' HashOf in fb/hash.bi).
''
'' Declare one per interface, at file scope, next to the interface itself:
''
''     COM_IID( IShellLinkW, IID_IShellLinkW )
''
'' THE TAG IS A GENERIC MARKER, NOT A T PTR, and that is not cosmetic.  The
'' obvious spelling -- dispatching on a 'T ptr' the way the C++ tag idiom does --
'' is silently wrong here, because an interface pointer converts to its BASE
'' interface pointer in overload resolution.  With 'IidOf( byval as ComUnknown
'' ptr )' in scope, an interface that had NO COM_IID line of its own would bind
'' to it and query for IID_IUnknown, handing back a wrongly-typed pointer with
'' no diagnostic.  Annotating one base would silently capture every interface
'' derived from it.
''
'' IidTag( of T ) has no inheritance relationships, so IidTag( of IDerived ) does
'' not convert to IidTag( of IBase ), and a missing annotation is a COMPILE
'' ERROR naming the interface instead of a wrong answer at run time.
''
'' Three further details, each of which failed before it was right:
''
''   - THE DUMMY PARAMETER MUST BE NAMED.  'byval as ...' is error 59;
''     FreeBASIC has no unnamed-parameter form, unlike the C++ tag-dispatch
''     idiom this is modelled on.
''   - IT MUST BE PRIVATE.  A procedure body in a header is a duplicate symbol
''     in every module that includes it, and COM_IID lines live in interface
''     headers that get included widely.
''   - THE IID MUST BE AN OBJECT WITH AN ADDRESS.  The Windows bindings declare
''     them as 'extern IID_Xxx as const GUID' satisfied from uuid.lib.  There is
''     no DEFINE_GUID macro in the FB bindings, so an interface whose IID no
''     header declares needs one written out as a GUID initialiser.
''
'' IidOf is OPT-IN.  ComPtr and ComQI never need it -- owning calls only AddRef
'' and Release, which live on IUnknown.  Only the querying half names a target
'' interface, so only ComQIAs, ComCast, ComQIPtr and the two creation
'' procedures require a COM_IID line.
#define COM_IID( iface, iidname ) _
	private function IidOf overload ( byval tag as FB.IidTag( of iface ) ) as const GUID ptr : _
		return @iidname : end function

'' The marker COM_IID dispatches on.  Empty but for one field, because a TYPE
'' cannot be empty; the field is never read.
type IidTag( of T )
	as long unused
end type

'' ------------------------------------------------------------------ helpers
''
'' PRIVATE, so that a header included by two modules does not define the symbol
'' twice -- the same reason sharedptr.bi's hRefInc and channel.bi's queue
'' helpers are private.

'' The cast has to go through ANY PTR: a direct cptr( ComUnknown ptr, someT )
'' is error 301, "Casting derived UDT pointer from unrelated UDT pointer type".
private function hAsUnk( byval p as any ptr ) as ComUnknown ptr
	return cptr( ComUnknown ptr, p )
end function

'' {00000000-0000-0000-C000-000000000046}.  Held in a function-static rather
'' than a shared constant because a header cannot define a shared symbol twice,
'' and taken from here rather than from uuid.lib so that comptr.bi links
'' without #inclib "uuid".
private function hIidUnknown( ) as const GUID ptr
	static as GUID g = type<GUID>( &h00000000, &h0000, &h0000, _
	                               { &hC0, &h00, &h00, &h00, &h00, &h00, &h00, &h46 } )
	return @g
end function

'' The canonical COM identity probe: QI for IUnknown and hand back the result.
'' Returns 0 if the pointer is null or the query fails, which cannot happen on
'' a conforming object but is not worth crashing over.
private function hCanonical( byval p as ComUnknown ptr ) as any ptr
	if( p = 0 ) then return 0
	dim as any ptr out_ = 0
	if( failed( p->QueryInterface( hIidUnknown( ), @out_ ) ) ) then return 0
	return out_
end function

'' ----------------------------------------------------------------- ComPtr

type ComPtr( of T )
	as T ptr p

	declare constructor( )
	declare constructor( byval raw as T ptr )
	declare constructor( byref rhs as ComPtr( of T ) )
	declare destructor( )
	declare operator let( byref rhs as ComPtr( of T ) )

	declare function Get( ) as T ptr
	declare function Ref( ) byref as T
	declare function IsNull( ) as boolean

	declare sub Attach( byval raw as T ptr )
	declare function Detach( ) as T ptr
	declare sub Release( )
	declare function CopyTo( byval pp as T ptr ptr ) as HRESULT
	declare function PutRef( ) as T ptr ptr

	declare function Unknown( ) as ComUnknown ptr
	declare function IsEqualObject( byval other as any ptr ) as boolean
end type

constructor ComPtr( of T )( )
	this.p = 0
end constructor

'' AddRefs, matching ATL's CComPtr(T* lp).  This is the SHARING constructor.
'' A pointer that already carries a reference for you -- which is most [out]
'' results -- wants Attach( ) instead, or it leaks.
constructor ComPtr( of T )( byval raw as T ptr )
	this.p = raw
	if( this.p <> 0 ) then hAsUnk( this.p )->AddRef( )
end constructor

constructor ComPtr( of T )( byref rhs as ComPtr( of T ) )
	this.p = rhs.p
	if( this.p <> 0 ) then hAsUnk( this.p )->AddRef( )
end constructor

destructor ComPtr( of T )( )
	this.Release( )
end destructor

'' Two rules, both load-bearing, both invisible to anyone tidying this up:
''
''   - the self-assign guard.  'a = a' without it releases the object and then
''     AddRefs a corpse.
''   - AddRef the NEW before releasing the OLD.  If both handles reach the same
''     object, the obvious order -- release, assign, AddRef -- drops the count
''     to zero mid-assignment and destroys it.
''
'' this.p is also set before the old pointer is released, so a re-entrant
'' Release that reads this handle sees the new state rather than a dangling one.
operator ComPtr( of T ).let( byref rhs as ComPtr( of T ) )
	if( this.p = rhs.p ) then exit operator
	dim as T ptr old = this.p
	this.p = rhs.p
	if( this.p <> 0 ) then hAsUnk( this.p )->AddRef( )
	if( old <> 0 ) then hAsUnk( old )->Release( )
end operator

function ComPtr( of T ).Get( ) as T ptr
	return this.p
end function

'' The checked dereference.  '*p' and 'p->' are not checked -- see the arrow
'' operators below.
function ComPtr( of T ).Ref( ) byref as T
	if( this.p = 0 ) then
		'' QUALIFIED, and it has to be: a generic body is replayed and
		'' resolved at the INSTANTIATION site, so the unqualified spelling
		'' works only from a scope that already said 'using FB'.  Exactly the
		'' defect sharedptr.bi records at its own Ref( ), and result.bi had.
		error( FB.FB_RTERROR_ILLEGALFUNCTIONCALL )
	end if
	return *this.p
end function

function ComPtr( of T ).IsNull( ) as boolean
	return ( this.p = 0 )
end function

'' Takes ownership WITHOUT AddRef, releasing whatever was held.
sub ComPtr( of T ).Attach( byval raw as T ptr )
	this.Release( )
	this.p = raw
end sub

'' Hands the reference to the caller and goes empty.
function ComPtr( of T ).Detach( ) as T ptr
	dim as T ptr r = this.p
	this.p = 0
	return r
end function

'' Idempotent.  Nulls the field BEFORE calling out, because the final Release
'' runs the object's destructor, which may run arbitrary code, which may reach
'' this handle.
sub ComPtr( of T ).Release( )
	if( this.p <> 0 ) then
		dim as ComUnknown ptr u = hAsUnk( this.p )
		this.p = 0
		u->Release( )
	end if
end sub

'' The outbound counterpart of PutRef: hands a reference OUT, so it AddRefs.
function ComPtr( of T ).CopyTo( byval pp as T ptr ptr ) as HRESULT
	if( pp = 0 ) then return E_POINTER
	*pp = this.p
	if( this.p <> 0 ) then hAsUnk( this.p )->AddRef( )
	return S_OK
end function

'' The [out]-parameter slot.  ATL spells this 'T** operator&' and asserts in
'' debug builds only; here it is a hard trap, because handing out the address
'' of a slot that already owns a reference is a SILENT LEAK -- the exact
'' failure this type exists to remove -- and ATL lets it through in release.
''
'' 'operator @' would have reproduced ATL's spelling; it is overloadable in
'' FreeBASIC.  It was rejected because overloading it forfeits ever taking the
'' wrapper's own address, which is too high a price for one call shape.
function ComPtr( of T ).PutRef( ) as T ptr ptr
	if( this.p <> 0 ) then error( FB.FB_RTERROR_ILLEGALFUNCTIONCALL )
	return @this.p
end function

'' The borrowed IUnknown view, for the COM APIs that take one -- and the
'' laundering the caller would otherwise have to write, since cptr( ComUnknown
'' ptr, someTPtr ) is error 301 at the CALL SITE too, not just inside here.
'' Borrowed: this does not AddRef.
function ComPtr( of T ).Unknown( ) as ComUnknown ptr
	return hAsUnk( this.p )
end function

'' The only correct identity test in COM.  Takes ANY PTR rather than T ptr
'' deliberately -- every member of a generic is instantiated whether it is
'' called or not, so no member may require anything of T beyond being a UDT --
'' and rather than ComUnknown ptr, which would force every caller holding a
'' plain interface pointer to launder it through any ptr first.
function ComPtr( of T ).IsEqualObject( byval other as any ptr ) as boolean
	if( this.p = 0 andalso other = 0 ) then return TRUE
	if( this.p = 0 orelse other = 0 ) then return FALSE

	dim as any ptr a = hCanonical( hAsUnk( this.p ) )
	dim as any ptr b = hCanonical( hAsUnk( other ) )
	dim as boolean same = ( a <> 0 andalso a = b )

	if( a <> 0 ) then hAsUnk( a )->Release( )
	if( b <> 0 ) then hAsUnk( b )->Release( )
	return same
end function

'' -------------------------------------------------------- global operators
''
'' MUST be global: '->' and '*' cannot be members in FreeBASIC.  T is inferred
'' through the nested ComPtr( of T ) operand position.
''
'' That these are reachable at all is the one compiler change a smart pointer
'' needed in this tree, and it landed with SharedPtr: before it, no generic
'' global UNARY operator was instantiated at its use site.
''
'' NEITHER CHECKS FOR NULL.  They compile to the same dereference the raw
'' pointer would, following SharedPtr exactly -- a branch on every method call,
'' to catch a bug the call site already has, is the wrong trade.  Ref( ) is the
'' checked spelling.

operator * ( of T )( byref h as ComPtr( of T ) ) byref as T
	return *h.p
end operator

operator -> ( of T )( byref h as ComPtr( of T ) ) byref as T
	return *h.p
end operator

'' ------------------------------------------------- the query procedures
''
'' Free procedures, each SEPARATELY NAMED: generic procedures cannot be
'' overloaded -- a second one is error 4 whether it differs in arity, in
'' type-parameter count or in parameter type -- which is the same reason the
'' sort library spells its variants SortBy, StableSort and SortList.
''
'' All three take the source as ANY PTR rather than ComUnknown ptr, for the
'' reason IsEqualObject does: cptr( ComUnknown ptr, someIFooPtr ) is error 301
'' at the CALL SITE too, so demanding a ComUnknown ptr would put a laundering
'' cast in front of every use.
''
'' All three write through Attach, so the reference the query returned is
'' ADOPTED rather than re-counted, and whatever dst held is released first.
'' All three leave dst EMPTY on failure.

'' Explicit IID.  Needs no COM_IID line, so it works with every interface in the
'' Windows headers exactly as they ship.
function ComQI( of T )( byval src as any ptr, byval iid as const GUID ptr, _
                        byref dst as ComPtr( of T ) ) as HRESULT
	dst.Release( )
	if( src = 0 orelse iid = 0 ) then return E_POINTER
	dim as any ptr out_ = 0
	dim as HRESULT hr = hAsUnk( src )->QueryInterface( iid, @out_ )
	if( succeeded( hr ) andalso out_ <> 0 ) then
		dst.Attach( cptr( T ptr, out_ ) )
	end if
	return hr
end function

'' The same, with the IID taken from the trait.  Requires a COM_IID line for T.
function ComQIAs( of T )( byval src as any ptr, byref dst as ComPtr( of T ) ) as HRESULT
	dst.Release( )
	if( src = 0 ) then return E_POINTER
	dim as IidTag( of T ) tag                     '' a marker, never read
	dim as any ptr out_ = 0
	dim as HRESULT hr = hAsUnk( src )->QueryInterface( IidOf( tag ), @out_ )
	if( succeeded( hr ) andalso out_ <> 0 ) then
		dst.Attach( cptr( T ptr, out_ ) )
	end if
	return hr
end function

'' From one owned pointer to another.  BOTH type arguments must be written out
'' -- ComCast( of IFoo, IBar )( a, b ) -- because inference reads parameter
'' positions only and would bind F from src but have nothing to bind T from.
'' Mirrors SpCast( of D, B ) in sharedptr.bi, which has the shape for the same
'' reason.
''
'' THIS IS A REAL QueryInterface, NEVER A REINTERPRET, and that is the one place
'' this library genuinely differs from SharedPtr.  SpCast may reinterpret because
'' FreeBASIC is single-inheritance, so a derived pointer and its base subobject
'' share an address.  Two interfaces on one COM object need not: a tear-off, an
'' aggregated inner object and every out-of-process proxy hand back a DIFFERENT
'' pointer.  A cast would be accidentally right in the easy cases and wrong
'' against a proxy, which is the worst possible failure profile.
function ComCast( of F, T )( byref src as ComPtr( of F ), byref dst as ComPtr( of T ) ) as HRESULT
	dst.Release( )
	if( src.IsNull( ) ) then return E_POINTER
	dim as IidTag( of T ) tag
	dim as any ptr out_ = 0
	dim as HRESULT hr = src.Unknown( )->QueryInterface( IidOf( tag ), @out_ )
	if( succeeded( hr ) andalso out_ <> 0 ) then
		dst.Attach( cptr( T ptr, out_ ) )
	end if
	return hr
end function

'' ----------------------------------------------------------------- creation
''
'' Two names rather than two overloads, for the reason above.  Both need a
'' COM_IID line for T, since CoCreateInstance takes the target IID.
''
'' Both return an EMPTY pointer on failure, which loses the HRESULT.  When the
'' HRESULT matters -- which is usually -- use PutRef directly:
''
''     dim as ComPtr( of IShellLinkW ) link
''     hr = CoCreateInstance( @CLSID_ShellLink, 0, CLSCTX_INPROC_SERVER, _
''                            @IID_IShellLinkW, cptr( any ptr ptr, link.PutRef( ) ) )
''
'' That spelling is the primary one; these exist for the case where the only
'' thing you would do with the HRESULT is test it.
''
'' RETURNING BY VALUE COSTS A REAL AddRef AND Release.  There is no move
'' constructor and no return-value optimisation, so these pay a refcount round
'' trip the PutRef spelling does not -- two virtual calls in-process, two
'' MARSHALLED calls on a proxy.
function ComCreate( of T )( byval rclsid as const GUID ptr, _
                            byval ctx as DWORD = CLSCTX_ALL, _
                            byval outer as any ptr = 0 ) as ComPtr( of T )
	dim as ComPtr( of T ) r
	if( rclsid = 0 ) then return r
	dim as IidTag( of T ) tag
	dim as any ptr out_ = 0
	if( succeeded( CoCreateInstance( rclsid, outer, ctx, IidOf( tag ), @out_ ) ) andalso out_ <> 0 ) then
		r.Attach( cptr( T ptr, out_ ) )
	end if
	return r
end function

function ComCreateFromProgID( of T )( byref progid as const wstring, _
                                      byval ctx as DWORD = CLSCTX_ALL, _
                                      byval outer as any ptr = 0 ) as ComPtr( of T )
	dim as ComPtr( of T ) r
	dim as GUID clsid_
	if( failed( CLSIDFromProgID( @progid, @clsid_ ) ) ) then return r
	dim as IidTag( of T ) tag
	dim as any ptr out_ = 0
	if( succeeded( CoCreateInstance( @clsid_, outer, ctx, IidOf( tag ), @out_ ) ) andalso out_ <> 0 ) then
		r.Attach( cptr( T ptr, out_ ) )
	end if
	return r
end function

'' ---------------------------------------------------------------- ComQIPtr
''
'' ComPtr that QUERIES on construction and on assignment.  This is the type
'' whose whole point is that the IID is implicit, so it is the one that requires
'' a COM_IID line for T.
''
'' ON FAILURE IT IS LEFT EMPTY AND NOTHING IS RAISED.  E_NOINTERFACE is not an
'' error condition in COM -- it is the documented way to ASK whether an object
'' supports something, and a great deal of correct code queries speculatively.
'' IsNull( ) is the test.  When the distinction between E_NOINTERFACE and a
'' genuine failure matters, use ComQIAs, which returns the HRESULT.
''
'' There is deliberately NO constructor taking a raw T ptr that skips the query:
'' if you already hold a T ptr you want ComPtr( of T ).  Constructors are not
'' inherited in FreeBASIC, so ComPtr's adopting constructor is not reachable
'' here by accident.
''
'' The global operator * and operator -> declared over ComPtr( of T ) accept a
'' ComQIPtr( of T ) operand -- a generic global operator declared over a base
'' instantiation binds against a derived one -- so the arrow and the whole of
'' ComPtr's surface come through unchanged.
type ComQIPtr( of T ) extends ComPtr( of T )
	declare constructor( )
	declare constructor( byval src as any ptr )
	declare constructor( byref rhs as ComQIPtr( of T ) )
	declare operator let( byval src as any ptr )
	declare operator let( byref rhs as ComQIPtr( of T ) )
end type

constructor ComQIPtr( of T )( )
	this.p = 0
end constructor

constructor ComQIPtr( of T )( byval src as any ptr )
	this.p = 0
	if( src <> 0 ) then
		dim as IidTag( of T ) tag
		dim as any ptr out_ = 0
		if( succeeded( hAsUnk( src )->QueryInterface( IidOf( tag ), @out_ ) ) ) then
			this.p = cptr( T ptr, out_ )      '' adopt the query's reference
		end if
	end if
end constructor

'' A plain refcount copy, not a re-query: rhs is already of type T.
constructor ComQIPtr( of T )( byref rhs as ComQIPtr( of T ) )
	this.p = rhs.p
	if( this.p <> 0 ) then hAsUnk( this.p )->AddRef( )
end constructor

operator ComQIPtr( of T ).let( byval src as any ptr )
	dim as any ptr out_ = 0
	if( src <> 0 ) then
		dim as IidTag( of T ) tag
		if( failed( hAsUnk( src )->QueryInterface( IidOf( tag ), @out_ ) ) ) then out_ = 0
	end if
	'' Release AFTER the query, so that querying an object this pointer is the
	'' last owner of cannot destroy it before the query runs.
	dim as T ptr old = this.p
	this.p = cptr( T ptr, out_ )
	if( old <> 0 ) then hAsUnk( old )->Release( )
end operator

operator ComQIPtr( of T ).let( byref rhs as ComQIPtr( of T ) )
	if( this.p = rhs.p ) then exit operator
	dim as T ptr old = this.p
	this.p = rhs.p
	if( this.p <> 0 ) then hAsUnk( this.p )->AddRef( )
	if( old <> 0 ) then hAsUnk( old )->Release( )
end operator

'' ComQIPtr needs its OWN * and ->, declared over the derived instantiation.
''
'' Inheriting them does not work, and the way it fails is worth recording: a
'' generic global operator declared over ComPtr( of T ) infers T by matching the
'' operand's type against the pattern ComPtr( of T ), and ComQIPtr( of IFoo )
'' does not match that pattern -- the NAME differs.  It appears to work if some
'' earlier line in the same program used the arrow on a ComPtr( of IFoo ), because
'' that instantiates a concrete operator over the base which the derived operand
'' then binds to by ordinary derived-to-base conversion.  So the feature is there
'' or not depending on unrelated code elsewhere in the module.  Declaring them
'' explicitly makes it unconditional.
operator * ( of T )( byref h as ComQIPtr( of T ) ) byref as T
	return *h.p
end operator

operator -> ( of T )( byref h as ComQIPtr( of T ) ) byref as T
	return *h.p
end operator

'' =========================================================== RFC-0004
''
'' The three things COM code needs immediately after interface lifetime:
'' apartment initialisation, CoTaskMemAlloc blocks, and connection points.

'' ------------------------------------------------------------- ComInit
''
'' CoInitializeEx in the constructor, CoUninitialize in the destructor.
''
''     dim as ComInit co                     '' declared FIRST -- see below
''     if( co.IsFailed( ) ) then return co.hr
''
'' Ok( ) IS TRUE FOR S_FALSE.  CoInitializeEx returns S_FALSE when the apartment
'' was already initialised on this thread, and that is success -- treating it as
'' failure is the classic bug with this API.  IsFailed( ) is FAILED( hr ), not
'' hr <> S_OK.  It is spelled IsFailed rather than Failed because 'failed' is a
'' MACRO in windows.bi, and a member of that name is error 14 at its declaration.
''
'' CoUninitialize runs for S_OK and for S_FALSE alike, because the calls are
'' COUNTED and every successful one owes exactly one uninitialise.  It does NOT
'' run when the constructor failed -- including RPC_E_CHANGED_MODE, where this
'' thread's apartment belongs to somebody else.
''
'' IT MUST OUTLIVE EVERY ComPtr IN THE SCOPE, so DECLARE IT FIRST.  Destructors
'' run in reverse declaration order, so a ComPtr declared after it is released
'' before CoUninitialize runs.  Declared the other way round, the ComPtr calls
'' Release on a dead apartment -- which is undefined, and in practice a
'' segfault.  This is not hypothetical: comptr-qi.bas hit it by writing
'' CoUninitialize( ) in the same scope as the pointers, where the statement runs
'' BEFORE their destructors.
''
'' NON-COPYABLE, and enforced.  A copy would uninitialise once per copy.
type ComInit
	private:
		'' No bodies are ever generated for these; they exist to be rejected.
		declare constructor( byref rhs as ComInit )
		declare operator let( byref rhs as ComInit )
	public:
		as HRESULT hr
		declare constructor( byval mode as DWORD = COINIT_APARTMENTTHREADED )
		declare destructor( )
		declare function Ok( ) as boolean
		declare function IsFailed( ) as boolean
end type

private constructor ComInit( byval mode as DWORD )
	this.hr = CoInitializeEx( 0, mode )
end constructor

private constructor ComInit( byref rhs as ComInit )
	'' unreachable: declared private
end constructor

private operator ComInit.let( byref rhs as ComInit )
	'' unreachable: declared private
end operator

private destructor ComInit( )
	if( succeeded( this.hr ) ) then CoUninitialize( )
end destructor

private function ComInit.Ok( ) as boolean
	return succeeded( this.hr )
end function

private function ComInit.IsFailed( ) as boolean
	return failed( this.hr )
end function

'' ------------------------------------------------------- ComHeapPtr( of T )
''
'' Owns a CoTaskMemAlloc'd block -- the [out] LPWSTR that IShellItem.GetDisplayName
'' and its many siblings hand back.  Neither ComPtr (wrong free) nor SharedPtr
'' (wrong allocator) fits.
''
''     dim as ComHeapPtr( of WCHAR ) name
''     hr = si->GetDisplayName( SIGDN_FILESYSPATH, cptr( any ptr ptr, name.PutRef( ) ) )
''
'' NON-COPYABLE, and enforced.  A heap block has exactly one owner and there is
'' no refcount to share it with.  Detach transfers; nothing copies.  Because it
'' cannot be copied it also cannot be RETURNED by value -- the language has no
'' move constructor, the same wall sharedptr.bi records for UniquePtr.  Detach
'' into a caller-supplied slot, or take it BYREF.
type ComHeapPtr( of T )
	private:
		declare constructor( byref rhs as ComHeapPtr( of T ) )
		declare operator let( byref rhs as ComHeapPtr( of T ) )
	public:
		as T ptr p
		declare constructor( )
		declare destructor( )
		declare function Get( ) as T ptr
		declare function IsNull( ) as boolean
		declare sub Attach( byval raw as T ptr )
		declare function Detach( ) as T ptr
		declare sub Free( )
		declare function PutRef( ) as T ptr ptr
		declare function Alloc( byval count as uinteger ) as boolean
end type

constructor ComHeapPtr( of T )( )
	this.p = 0
end constructor

constructor ComHeapPtr( of T )( byref rhs as ComHeapPtr( of T ) )
	'' unreachable: declared private
end constructor

operator ComHeapPtr( of T ).let( byref rhs as ComHeapPtr( of T ) )
	'' unreachable: declared private
end operator

destructor ComHeapPtr( of T )( )
	this.Free( )
end destructor

function ComHeapPtr( of T ).Get( ) as T ptr
	return this.p
end function

function ComHeapPtr( of T ).IsNull( ) as boolean
	return ( this.p = 0 )
end function

sub ComHeapPtr( of T ).Attach( byval raw as T ptr )
	this.Free( )
	this.p = raw
end sub

function ComHeapPtr( of T ).Detach( ) as T ptr
	dim as T ptr r = this.p
	this.p = 0
	return r
end function

'' Idempotent.  Nulls before freeing, for the same reason ComPtr.Release does.
sub ComHeapPtr( of T ).Free( )
	if( this.p <> 0 ) then
		dim as any ptr q = this.p
		this.p = 0
		CoTaskMemFree( q )
	end if
end sub

'' Same rule as ComPtr.PutRef: raises rather than leak the block already held.
function ComHeapPtr( of T ).PutRef( ) as T ptr ptr
	if( this.p <> 0 ) then error( FB.FB_RTERROR_ILLEGALFUNCTIONCALL )
	return @this.p
end function

function ComHeapPtr( of T ).Alloc( byval count as uinteger ) as boolean
	this.Free( )
	this.p = cptr( T ptr, CoTaskMemAlloc( count * sizeof( T ) ) )
	return ( this.p <> 0 )
end function

'' ------------------------------------------- connection points and sites
''
'' ATL puts Advise and SetSite on CComPtrBase.  Here they are free procedures,
'' and not for the usual reason -- they need nothing of T, so they COULD be
'' members.  They are free because they are not lifetime operations, and because
'' every member of a generic is instantiated whether it is called or not: a
'' member Advise would drag IConnectionPointContainer into every instantiation
'' of ComPtr in the program.
''
'' THE COOKIE IS NOT MANAGED.  A connection made with ComAdvise must be torn down
'' with ComUnadvise; nothing is automatic.  'defer ComUnadvise( ... )' covers the
'' scope-local case, which is the same answer sharedptr.bi gives for the absence
'' of UniquePtr.
''
'' These duplicate AfxNova's AfxAdvise/AfxUnadvise deliberately: AfxNova is a
'' separate project and is not a dependency of fbc-modern, so the toolchain
'' cannot ship a header that includes it.  The names differ so that a program
'' using both links cleanly.

type ComConnectionPoint extends ComUnknown
	declare abstract function GetConnectionInterface( byval piid as GUID ptr ) as HRESULT
	declare abstract function GetConnectionPointContainer( byval ppCPC as any ptr ptr ) as HRESULT
	declare abstract function Advise( byval pUnkSink as any ptr, byval pdwCookie as DWORD ptr ) as HRESULT
	declare abstract function Unadvise( byval dwCookie as DWORD ) as HRESULT
	declare abstract function EnumConnections( byval ppEnum as any ptr ptr ) as HRESULT
end type

type ComConnectionPointContainer extends ComUnknown
	declare abstract function EnumConnectionPoints( byval ppEnum as any ptr ptr ) as HRESULT
	declare abstract function FindConnectionPoint( byval riid as const GUID ptr, byval ppCP as any ptr ptr ) as HRESULT
end type

type ComObjectWithSite extends ComUnknown
	declare abstract function SetSite( byval pUnkSite as any ptr ) as HRESULT
	declare abstract function GetSite( byval riid as const GUID ptr, byval ppvSite as any ptr ptr ) as HRESULT
end type

'' {B196B284-BAB4-101A-B69C-00AA00341D07}
private function hIidConnPointContainer( ) as const GUID ptr
	static as GUID g = type<GUID>( &hB196B284, &hBAB4, &h101A, _
	                               { &hB6, &h9C, &h00, &hAA, &h00, &h34, &h1D, &h07 } )
	return @g
end function

'' {FC4801A3-2BA9-11CF-A229-00AA003D7352}
private function hIidObjectWithSite( ) as const GUID ptr
	static as GUID g = type<GUID>( &hFC4801A3, &h2BA9, &h11CF, _
	                               { &hA2, &h29, &h00, &hAA, &h00, &h3D, &h73, &h52 } )
	return @g
end function

'' Queries src for IConnectionPointContainer, finds the connection point for iid,
'' and advises sink.  The cookie is written only on success.
private function ComAdvise( byval src as any ptr, byval sinkUnk as any ptr, _
                            byval iid as const GUID ptr, byref cookie as DWORD ) as HRESULT
	cookie = 0
	if( src = 0 orelse sinkUnk = 0 orelse iid = 0 ) then return E_POINTER

	dim as any ptr rawCpc = 0
	dim as HRESULT hr = hAsUnk( src )->QueryInterface( hIidConnPointContainer( ), @rawCpc )
	if( failed( hr ) ) then return hr
	dim as ComConnectionPointContainer ptr cpc = cptr( ComConnectionPointContainer ptr, rawCpc )

	dim as any ptr rawCp = 0
	hr = cpc->FindConnectionPoint( iid, @rawCp )
	cpc->Release( )
	if( failed( hr ) ) then return hr

	dim as ComConnectionPoint ptr cp = cptr( ComConnectionPoint ptr, rawCp )
	dim as DWORD c = 0
	hr = cp->Advise( sinkUnk, @c )
	cp->Release( )
	if( succeeded( hr ) ) then cookie = c
	return hr
end function

private function ComUnadvise( byval src as any ptr, byval iid as const GUID ptr, _
                              byval cookie as DWORD ) as HRESULT
	if( src = 0 orelse iid = 0 ) then return E_POINTER

	dim as any ptr rawCpc = 0
	dim as HRESULT hr = hAsUnk( src )->QueryInterface( hIidConnPointContainer( ), @rawCpc )
	if( failed( hr ) ) then return hr
	dim as ComConnectionPointContainer ptr cpc = cptr( ComConnectionPointContainer ptr, rawCpc )

	dim as any ptr rawCp = 0
	hr = cpc->FindConnectionPoint( iid, @rawCp )
	cpc->Release( )
	if( failed( hr ) ) then return hr

	dim as ComConnectionPoint ptr cp = cptr( ComConnectionPoint ptr, rawCp )
	hr = cp->Unadvise( cookie )
	cp->Release( )
	return hr
end function

'' site may be 0, which is how a site is CLEARED -- IObjectWithSite.SetSite( NULL )
'' is the documented way to break the back-reference, so a null site is not an
'' error here.
private function ComSetSite( byval obj as any ptr, byval site as any ptr ) as HRESULT
	if( obj = 0 ) then return E_POINTER
	dim as any ptr raw = 0
	dim as HRESULT hr = hAsUnk( obj )->QueryInterface( hIidObjectWithSite( ), @raw )
	if( failed( hr ) ) then return hr
	dim as ComObjectWithSite ptr ows = cptr( ComObjectWithSite ptr, raw )
	hr = ows->SetSite( site )
	ows->Release( )
	return hr
end function

end namespace

'' ------------------------------------------- the built-in COM_IID lines
''
'' At GLOBAL scope, not inside namespace FB, and deliberately.  A generic body is
'' replayed and resolved at the INSTANTIATION site, so an overload that lived
'' inside FB would be invisible to any module that had not said 'using FB' --
'' the same resolution rule that forces FB.FB_RTERROR_ILLEGALFUNCTIONCALL to be
'' written qualified.  User COM_IID lines land at global scope for the same
'' reason, so these sit alongside them.
''
'' These are safe to ship only because the tag is IidTag( of T ) rather than a
'' T ptr: an interface with no COM_IID line of its own cannot bind to them.

'' {00000000-0000-0000-C000-000000000046}
private function IidOf overload ( byval tag as FB.IidTag( of FB.ComUnknown ) ) as const GUID ptr
	static as GUID g = type<GUID>( &h00000000, &h0000, &h0000, _
	                               { &hC0, &h00, &h00, &h00, &h00, &h00, &h00, &h46 } )
	return @g
end function

'' {00020400-0000-0000-C000-000000000046}
private function IidOf overload ( byval tag as FB.IidTag( of FB.ComDispatch ) ) as const GUID ptr
	static as GUID g = type<GUID>( &h00020400, &h0000, &h0000, _
	                               { &hC0, &h00, &h00, &h00, &h00, &h00, &h00, &h46 } )
	return @g
end function
