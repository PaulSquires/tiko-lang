' TEST_MODE : COMPILE_AND_RUN_FAIL

'' memory.SharedPtr( of T ).Ref( ) on a NULL handle must raise.
''
'' A separate module because the raise aborts the process, so it cannot share a
'' binary with container-sharedptr.bas.  COMPILE_AND_RUN_FAIL means the harness
'' requires a clean compile and a NON-ZERO exit code, so the assertion is really
'' "control never reaches the end".
''
'' Unlike Optional.Value( ), there is nothing sane to return afterwards: a null
'' SharedPtr owns no object, so there is no T anywhere to hand back a reference
'' to.  The alternative -- a function-static blank -- would force T to be
'' default-constructible for EVERY use of SharedPtr and would leak one T for the
'' life of the program, because a function-static UDT is never destroyed.  So
'' the raise is the whole contract, and this file is what pins it.
#import "std/memory"
#include once "fberror.bi"
#include once "fbatomic.bi"
using memory
using FB
type Probe
	as long v
end type

dim as SharedPtr( of Probe ) p

'' Guard: the handle must actually be null, or this file would be testing
'' nothing.  Aborting here also fails the test, but for the wrong reason -- so
'' say so on the way out.
if( p.IsNull( ) = FALSE ) then
	print "FAILED: a default-constructed SharedPtr was not null"
	end 2
end if

'' Raises FB_RTERROR_ILLEGALFUNCTIONCALL.  With no 'on error' handler installed
'' the runtime prints 'Aborting due to runtime error 1 (illegal function call)'
'' naming the line in fb/sharedptr.bi, and exits 1.
dim as long v = p.Ref( ).v

'' Only reachable if the raise did not happen.
print "FAILED: Ref( ) on a null SharedPtr returned "; v; " without raising"
end 0
