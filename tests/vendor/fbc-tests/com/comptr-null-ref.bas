' TEST_MODE : COMPILE_AND_RUN_FAIL

'' Ref( ) on an empty ComPtr raises FB_RTERROR_ILLEGALFUNCTIONCALL.
''
'' Its own module because the raise aborts the process, so it cannot share a
'' binary with comptr.bas.  Same arrangement as sharedptr-null-ref.bas.
''
'' The raise is a FATAL PROGRAMMING-ERROR TRAP, not a recoverable condition:
'' FreeBASIC's error path does not unwind scopes (see comptr-error-path.bas),
'' so catching it with ON ERROR GOTO and continuing leaks every ComPtr in the
'' abandoned scopes.  The supported outcome is the abort this test asserts.

#include once "fb/comptr.bi"
using FB

type IFake extends ComUnknown
	declare abstract function Poke( ) as long
end type

dim as ComPtr( of IFake ) empty_
print "before"
empty_.Ref( ).Poke( )
print "unreachable"
