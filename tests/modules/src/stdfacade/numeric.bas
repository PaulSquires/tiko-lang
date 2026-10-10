'' std/numeric, a real module: a type, procedures, a generic-backed overload, a const and a
'' macro-made vector type, qualified and through 'using'.
#import "std/numeric"
private function Size( byref z as numeric.Complex ) as double
    return numeric.CAbs( z )
end function
dim as numeric.Complex z = numeric.CSet( 3, 4 )
print Size( z ); numeric.CAbs( z ); numeric.Clamp( 12.0, 0.0, 10.0 ); numeric.GCD( 12ull, 18ull )
dim as numeric.Vec2f v = numeric.Vec2f_( 3, 4 )
print numeric.Length( v ); " "; numeric.PI > 3.14; " "; numeric.IsNaN( numeric.NaN( ) )
scope
    using numeric
    dim as Vec3d w = Vec3d_( 1, 2, 2 )
    print Length( w ); " "; AddChecked( 2l, 3l ).Value( )
end scope
