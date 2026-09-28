'' std/numeric (RFC-0009): a type, procedures, a generic-backed overload, a const and a
'' macro-made vector type through the facade, beside fb/complex.bi included directly.
#import "std/numeric"
#include once "fb/complex.bi"
private function Size( byref z as FB.Complex ) as double
    return FB.CAbs( z )
end function
dim as numeric.Complex z = numeric.CSet( 3, 4 )
print Size( z ); numeric.CAbs( z ); numeric.Clamp( 12.0, 0.0, 10.0 ); numeric.GCD( 12ull, 18ull )
dim as numeric.Vec2f v = numeric.Vec2f_( 3, 4 )
print numeric.Length( v ); " "; numeric.PI > 3.14; " "; numeric.IsNaN( numeric.NaN( ) )
