' TEST_MODE : COMPILE_AND_RUN_OK

'' WHAT HAPPENS TO A ComPtr WHEN error( ) IS RAISED -- and the answer is: it
'' LEAKS.  FreeBASIC's error path does not unwind scopes.
''
'' This test asserts the CURRENT, MEASURED behaviour rather than the desirable
'' one, deliberately.  RFC-0001 section 5 claims a ComPtr is released "on every
'' path out"; that claim is true for falling off the end, EXIT SUB, RETURN,
'' EXIT FOR/WHILE/DO and GOTO out of nested scopes -- and FALSE for the error
'' path.  If fbc ever gains unwinding, this test fails, and whoever changes it
'' must update RFC-0001 section 5, RFC-0005 section 12 and the header comment
'' in fb/comptr.bi in the same commit.
''
'' The same is true of DEFER, which is asserted here too so the two findings
'' stay together.  Neither is a defect of ComPtr; both are properties of the
'' language that a lifetime type has to be honest about.

#include once "fb/comptr.bi"
using FB

#define assert_(e) if (e) = 0 then fb_Assert(__FILE__, __LINE__, __FUNCTION__, #e)

type IFake extends ComUnknown
	declare abstract function Poke( ) as long
end type

type FakeVtbl
	as any ptr QueryInterface, AddRef, Release, Poke
end type
type Fake
	as FakeVtbl ptr lpVtbl
	as long         refs
end type

dim shared as FakeVtbl g_vtbl
dim shared as long     g_released
dim shared as long     g_deferred

private function FakeAddRef cdecl ( byval self_ as Fake ptr ) as ULONG
	self_->refs += 1 : return self_->refs
end function
private function FakeRelease cdecl ( byval self_ as Fake ptr ) as ULONG
	self_->refs -= 1 : g_released += 1 : return self_->refs
end function

dim shared as Fake g_obj

private function Obj( ) as IFake ptr
	return cptr( IFake ptr, cast( any ptr, @g_obj ) )
end function

'' A ComPtr and a DEFER in a scope that raises.
private sub Raiser( )
	dim as ComPtr( of IFake ) p
	p.Attach( Obj( ) )
	defer g_deferred += 1
	error( FB.FB_RTERROR_ILLEGALFUNCTIONCALL )
end sub

'' The control: the same scope, exiting normally.
private sub Normal_( )
	dim as ComPtr( of IFake ) p
	p.Attach( Obj( ) )
	defer g_deferred += 1
end sub

g_vtbl.AddRef  = cast( any ptr, @FakeAddRef )
g_vtbl.Release = cast( any ptr, @FakeRelease )
g_obj.lpVtbl   = @g_vtbl

'' ---- control: normal exit releases, and runs the defer
g_obj.refs = 1 : g_released = 0 : g_deferred = 0
Normal_( )
assert_( g_released = 1 )
assert_( g_deferred = 1 )
assert_( g_obj.refs = 0 )

'' ---- the error path: NEITHER runs
g_obj.refs = 1 : g_released = 0 : g_deferred = 0
on error goto caught
Raiser( )
assert_( FALSE )                  '' unreachable: Raiser always raises
caught:
assert_( g_released = 0 )         '' the ComPtr LEAKED
assert_( g_deferred = 0 )         '' and the DEFER was skipped
assert_( g_obj.refs = 1 )         '' the reference is still outstanding

print "comptr-error-path: ok (destructors and defers do NOT run on the error path)"
