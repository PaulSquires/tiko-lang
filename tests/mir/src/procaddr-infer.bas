'' '@f' IS THE PROCEDURE'S TYPE, not a pointer to its RESULT. Measured -- fbc says
'' 'typeof( @f )' is 'FUNCTION(AS LONG) AS LONG' and 'typeof( @s )' is 'SUB()'.
function f( byval x as long ) as long
	return x * 4
end function

var v = @f
print v( 5 )

'' ...which is what makes a VAR-inferred lambda callable.
var lam = function( byval x as long ) as long : return x + 1 : end function
print lam( 5 )

'' A RUNTIME PROCEDURE SPELLED AS AN ORDINARY IDENTIFIER has no keyword and no symbol.
dim as string libname = "x"
dim d as any ptr = dylibload( libname )
dim p as any ptr = dylibsymbol( d, "sym" )
dylibfree( d )
dim as string cmd = "c"
dim as long rc = chain( cmd )
print rc
