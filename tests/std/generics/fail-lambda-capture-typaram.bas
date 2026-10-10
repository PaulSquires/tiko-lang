' TEST_MODE : COMPILE_ONLY_FAIL

'' A CAPTURING lambda cannot name the enclosing generic's type parameter in its
'' own parameter list.
''
'' A capturing lambda lowers to a closure STRUCT with an __FBINVOKE member, and
'' that member's parameter list is built outside the binding that gives T a
'' meaning, so the parameter comes out with no usable type:
''
''     error 59: Illegal specification, at parameter 1 (v) of __FBINVOKE( )
''
'' Non-capturing lambdas are unaffected -- they lower to a plain procedure, and
'' 'function( byref x as T, byref y as T ) as boolean' inside a generic is what
'' fb/sort.bi is built on.  So is a capturing lambda whose own parameters are
'' concrete; only T in the parameter list fails.  The workaround is to spell the
'' parameter concretely, or capture the value instead of taking it as an
'' argument.
''
'' This was NOT REACHABLE until the generic body capture was fixed: the body
'' used to terminate at the lambda's 'END SUB', so the closure was never built
'' and the failure was a different one.  Pinned here so the day it starts
'' working is a visible change and not a silent one.
#import "std/containers"
using containers
sub Apply( of T, F )( byval x as T, byref f as F )
	f( x )
end sub

sub Outer( of T )( byval x as T )
	dim as T total = 0
	Apply( x, sub[ byref total ]( byval v as T )
		total = v
	end sub )
end sub

dim as long n = 5
Outer( n )
