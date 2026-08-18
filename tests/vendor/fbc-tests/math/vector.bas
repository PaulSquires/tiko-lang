'' Vectors, matrices, quaternions, complex -- RFC-0007-vectors.md.
''
'' IDENTITIES ARE ASSERTED; VALUES ARE NOT EYEBALLED.  This is the area where a
'' test that prints numbers and looks right is most tempting and least useful.

#include once "fbcunit.bi"
#include once "fb/vector.bi"
#include once "fb/random.bi"

using FB

SUITE( fbc_tests.math.vec )

	TEST( vector_identities_ )
		dim r as Rng = RngSeeded( 31337 )

		for k as long = 1 to 20000
			dim as Vec3d a = Vec3d_( r.NextDoubleRange( -10, 10 ), _
			                         r.NextDoubleRange( -10, 10 ), _
			                         r.NextDoubleRange( -10, 10 ) )
			dim as Vec3d b = Vec3d_( r.NextDoubleRange( -10, 10 ), _
			                         r.NextDoubleRange( -10, 10 ), _
			                         r.NextDoubleRange( -10, 10 ) )

			'' |normalize(v)| = 1
			dim as Vec3d n = Normalize( a )
			CU_ASSERT( abs( Length( n ) - 1.0 ) < 1e-12 )

			'' cross is orthogonal to both, and anticommutative
			dim as Vec3d c = Cross( a, b )
			CU_ASSERT( abs( Dot( c, a ) ) < 1e-8 )
			CU_ASSERT( abs( Dot( c, b ) ) < 1e-8 )
			dim as Vec3d c2 = Cross( b, a )
			CU_ASSERT( abs( c.x + c2.x ) < 1e-12 )

			'' triangle inequality
			CU_ASSERT( Length( a + b ) <= Length( a ) + Length( b ) + 1e-9 )

			'' dot = |a||b|cos(theta)
			dim as double lhs = Dot( a, b )
			dim as double rhs = Length( a ) * Length( b ) * cos( Angle( a, b ) )
			CU_ASSERT( abs( lhs - rhs ) < 1e-8 )

			'' LengthSquared agrees with Length, without the root
			CU_ASSERT( abs( LengthSquared( a ) - Length( a ) * Length( a ) ) < 1e-8 )
		next
	END_TEST

	'' The documented decision: a zero vector normalises to zero, not NaN.
	'' Propagating NaN through a render loop turns one degenerate triangle into
	'' a blank frame.
	TEST( zero_vector_ )
		dim as Vec3d z = Normalize( Vec3d_( 0, 0, 0 ) )
		CU_ASSERT( z.x = 0.0 )
		CU_ASSERT( z.y = 0.0 )
		CU_ASSERT( z.z = 0.0 )
		CU_ASSERT( ( z.x <> z.x ) = 0 )                '' not NaN

		dim as Vec3f zf = Normalize( Vec3f_( 0, 0, 0 ) )
		CU_ASSERT( zf.x = 0.0f )

		CU_ASSERT( Length( Vec3d_( 3, 4, 0 ) ) = 5.0 )
		CU_ASSERT( Length( Vec3d_( 0, 0, 0 ) ) = 0.0 )
	END_TEST

	TEST( matrix_identities_ )
		dim r as Rng = RngSeeded( 4242 )
		dim as Mat4d id = Mat4dIdentity( )

		for k as long = 1 to 3000
			dim as Mat4d m
			for i as long = 0 to 15
				m.m( i ) = r.NextDoubleRange( -3, 3 )
			next

			dim as Mat4d inv
			if( TryInverse( m, inv ) ) then
				'' M * M^-1 = I, to tolerance
				dim as Mat4d p = m * inv
				dim as double worst = 0.0
				for i as long = 0 to 15
					dim as double want = id.m( i )
					dim as double got = p.m( i )
					dim as double e = abs( got - want )
					if( e > worst ) then worst = e
				next
				CU_ASSERT( worst < 1e-6 )
			end if
		next

		'' Det(AB) = Det(A)Det(B)
		for k as long = 1 to 2000
			dim as Mat4d a, b
			for i as long = 0 to 15
				a.m( i ) = r.NextDoubleRange( -2, 2 )
				b.m( i ) = r.NextDoubleRange( -2, 2 )
			next
			dim as double lhs = Determinant( a * b )
			dim as double rhs = Determinant( a ) * Determinant( b )
			CU_ASSERT( abs( lhs - rhs ) <= 1e-6 * ( 1.0 + abs( rhs ) ) )
		next

		'' transpose is an involution; identity is a unit
		dim as Mat4d t = Mat4dTranslation( 1, 2, 3 )
		CU_ASSERT( Transpose( Transpose( t ) ) = t )
		CU_ASSERT( ( t * id ) = t )
		CU_ASSERT( ( id * t ) = t )
		CU_ASSERT( Determinant( id ) = 1.0 )

		'' a singular matrix has no inverse, and says so
		dim as Mat4d sing
		for i as long = 0 to 15
			sing.m( i ) = 0
		next
		dim as Mat4d junk
		CU_ASSERT( TryInverse( sing, junk ) = false )
	END_TEST

	'' The convention half of all matrix bugs: a point translates, a direction
	'' does not, and the two differ by exactly the translation column.
	TEST( point_versus_vector_ )
		dim as Mat4d t = Mat4dTranslation( 10, 20, 30 )
		dim as Vec3d v = Vec3d_( 1, 2, 3 )

		dim as Vec3d p = TransformPoint( t, v )
		CU_ASSERT( p.x = 11.0 )
		CU_ASSERT( p.y = 22.0 )
		CU_ASSERT( p.z = 33.0 )

		dim as Vec3d d = TransformVector( t, v )
		CU_ASSERT( d.x = 1.0 )
		CU_ASSERT( d.y = 2.0 )
		CU_ASSERT( d.z = 3.0 )

		'' COLUMN-VECTOR ORDER: 'a * b' applies b first.  Scaling then
		'' translating is not translating then scaling, and this pins which is
		'' which.
		dim as Mat4d s = Mat4dScaling( 2, 2, 2 )
		dim as Vec3d ts = TransformPoint( t * s, Vec3d_( 1, 1, 1 ) )
		dim as Vec3d st = TransformPoint( s * t, Vec3d_( 1, 1, 1 ) )
		CU_ASSERT( ts.x = 12.0 )                 '' scale first, then translate
		CU_ASSERT( st.x = 22.0 )                 '' translate first, then scale

		'' a rotation preserves length
		dim as Mat4d ry = Mat4dRotationY( 0.7 )
		dim as Vec3d rv = TransformVector( ry, Vec3d_( 1, 0, 0 ) )
		CU_ASSERT( abs( Length( rv ) - 1.0 ) < 1e-12 )
	END_TEST

	TEST( quaternion_identities_ )
		dim r as Rng = RngSeeded( 5150 )

		for k as long = 1 to 10000
			dim as Vec3d axis = Normalize( Vec3d_( r.NextDoubleRange( -1, 1 ), _
			                                       r.NextDoubleRange( -1, 1 ), _
			                                       r.NextDoubleRange( -1, 1 ) ) )
			if( Length( axis ) > 0.5 ) then
				dim as double ang = r.NextDoubleRange( -3.0, 3.0 )
				dim as Quatd q = QuatdFromAxisAngle( axis, ang )

				'' a rotation quaternion is a unit quaternion
				CU_ASSERT( abs( Length( q ) - 1.0 ) < 1e-12 )

				'' q * conj(q) = identity
				dim as Quatd e = q * Conjugate( q )
				CU_ASSERT( abs( e.w - 1.0 ) < 1e-12 )
				CU_ASSERT( abs( e.x ) < 1e-12 )

				'' rotation preserves length
				dim as Vec3d v = Vec3d_( 1, 2, 3 )
				dim as Vec3d rv = Rotate( q, v )
				CU_ASSERT( abs( Length( rv ) - Length( v ) ) < 1e-10 )

				'' Rotate and ToMatrix agree.  This nested form -- a large UDT
				'' returned by value and passed straight to a byref parameter --
				'' used to segfault under -gen gas64; it is a regression test for
				'' docs/gas64-byref-param-udt-return-bug.md.
				dim as Vec3d mv = TransformVector( ToMatrix( q ), v )
				CU_ASSERT( abs( mv.x - rv.x ) < 1e-9 )
				CU_ASSERT( abs( mv.y - rv.y ) < 1e-9 )
				CU_ASSERT( abs( mv.z - rv.z ) < 1e-9 )

				'' rotating about the axis leaves the axis alone
				dim as Vec3d ra = Rotate( q, axis )
				CU_ASSERT( abs( ra.x - axis.x ) < 1e-9 )
			end if
		next

		'' 90 degrees about Y takes +X to -Z
		dim as Quatd q90 = QuatdFromAxisAngle( Vec3d_( 0, 1, 0 ), 1.5707963267948966 )
		dim as Vec3d rx = Rotate( q90, Vec3d_( 1, 0, 0 ) )
		CU_ASSERT( abs( rx.x ) < 1e-9 )
		CU_ASSERT( abs( rx.z + 1.0 ) < 1e-9 )
	END_TEST

	'' SLERP is exact at both endpoints and takes the SHORT path.
	TEST( slerp_ )
		dim as Quatd a = QuatdFromAxisAngle( Vec3d_( 0, 1, 0 ), 0.0 )
		dim as Quatd b = QuatdFromAxisAngle( Vec3d_( 0, 1, 0 ), 1.0 )

		dim as Quatd s0 = Slerp( a, b, 0.0 )
		CU_ASSERT( abs( s0.w - a.w ) < 1e-12 )
		dim as Quatd s1 = Slerp( a, b, 1.0 )
		CU_ASSERT( abs( s1.w - b.w ) < 1e-12 )

		'' the interpolant stays a unit quaternion throughout
		for i as long = 0 to 100
			dim as Quatd s = Slerp( a, b, i / 100.0 )
			CU_ASSERT( abs( Length( s ) - 1.0 ) < 1e-9 )
		next

		'' THE SHORT PATH: slerping to -q (the same rotation) must not travel
		'' the long way.  The angle swept is asserted, not inspected.
		dim as Quatd nb = Quatd_( -b.x, -b.y, -b.z, -b.w )
		dim as Quatd mid_ = Slerp( a, nb, 0.5 )
		dim as double dotm = abs( Dot( a, mid_ ) )
		CU_ASSERT( dotm > 0.8 )                   '' close to a, not opposite it
	END_TEST

	TEST( complex_ )
		dim as Complexd z = Complexd_( 3, 4 )
		CU_ASSERT( AbsValue( z ) = 5.0 )
		CU_ASSERT( Norm( z ) = 25.0 )
		CU_ASSERT( Real( z ) = 3.0 )
		CU_ASSERT( Imag( z ) = 4.0 )

		'' z * conj(z) = |z|^2, and the imaginary part vanishes
		dim as Complexd p = z * Conjugate( z )
		CU_ASSERT( abs( p.re - 25.0 ) < 1e-12 )
		CU_ASSERT( abs( p.im ) < 1e-12 )

		'' i^2 = -1
		dim as Complexd i_ = Complexd_( 0, 1 )
		dim as Complexd i2 = i_ * i_
		CU_ASSERT( abs( i2.re + 1.0 ) < 1e-12 )
		CU_ASSERT( abs( i2.im ) < 1e-12 )

		dim r as Rng = RngSeeded( 8080 )
		for k as long = 1 to 5000
			dim as Complexd a = Complexd_( r.NextDoubleRange( -5, 5 ), r.NextDoubleRange( -5, 5 ) )
			dim as Complexd b = Complexd_( r.NextDoubleRange( -5, 5 ), r.NextDoubleRange( -5, 5 ) )

			if( Norm( b ) > 0.01 ) then
				'' (a/b)*b = a
				'' split rather than written as '( a / b ) * b': fbc will not
				'' chain two global UDT operators through a temporary here --
				'' error 3, Expected End-of-Line, found '*'
				dim as Complexd q = a / b
				dim as Complexd back = q * b
				CU_ASSERT( abs( back.re - a.re ) < 1e-9 )
				CU_ASSERT( abs( back.im - a.im ) < 1e-9 )
			end if

			'' |ab| = |a||b|
			CU_ASSERT( abs( AbsValue( a * b ) - AbsValue( a ) * AbsValue( b ) ) < 1e-9 )

			if( Norm( a ) > 0.01 ) then
				'' exp(log(z)) = z
				dim as Complexd e = CExp( CLog( a ) )
				CU_ASSERT( abs( e.re - a.re ) < 1e-8 )
				CU_ASSERT( abs( e.im - a.im ) < 1e-8 )

				'' sqrt(z)^2 = z
				dim as Complexd s = CSqrt( a )
				dim as Complexd s2 = s * s
				CU_ASSERT( abs( s2.re - a.re ) < 1e-8 )
				CU_ASSERT( abs( s2.im - a.im ) < 1e-8 )
			end if
		next

		'' AbsValue does not overflow where the naive sqr(x*x+y*y) does
		dim as Complexd big_ = Complexd_( 1e200, 1e200 )
		CU_ASSERT( AbsValue( big_ ) < 1e300 )
		CU_ASSERT( AbsValue( big_ ) > 1e200 )
	END_TEST

	TEST( layout_ )
		'' Vec4f is 16 bytes and naturally aligned, so a later SIMD path could
		'' adopt these types without changing them.
		CU_ASSERT( sizeof( Vec2f ) = 8 )
		CU_ASSERT( sizeof( Vec3f ) = 12 )
		CU_ASSERT( sizeof( Vec4f ) = 16 )
		CU_ASSERT( sizeof( Mat4f ) = 64 )
		CU_ASSERT( sizeof( Quatf ) = 16 )
		CU_ASSERT( sizeof( Vec3d ) = 24 )
		CU_ASSERT( sizeof( Complexd ) = 16 )
	END_TEST

	'' Component-wise product and the two distance forms.  Distance is the one
	'' that costs a square root, which is why DistanceSquared exists at all --
	'' a proximity test never needs the root, and asserting that here keeps the
	'' pair from drifting apart.
	TEST( distance_and_mul_ )
		dim as Vec3 a = type<Vec3>( 1, 2, 3 ), b = type<Vec3>( 4, 5, 6 )

		'' exact in binary: 9 + 9 + 9
		CU_ASSERT( DistanceSquared( a, b ) = 27.0f )
		CU_ASSERT( abs( Distance( a, b ) - sqr( 27.0 ) ) < 1e-5 )

		'' the range check without the root
		CU_ASSERT( DistanceSquared( a, b ) <= 6.0f * 6.0f )
		CU_ASSERT( DistanceSquared( a, b ) > 5.0f * 5.0f )

		'' a point is zero distance from itself, both ways round
		CU_ASSERT( DistanceSquared( a, a ) = 0.0f )
		CU_ASSERT( Distance( a, a ) = 0.0f )
		CU_ASSERT( Distance( a, b ) = Distance( b, a ) )

		'' Mul is COMPONENT-WISE and is not the dot product
		dim as Vec3 c = Mul( a, b )
		CU_ASSERT( c.x = 4.0f )
		CU_ASSERT( c.y = 10.0f )
		CU_ASSERT( c.z = 18.0f )
		CU_ASSERT( Dot( a, b ) = 32.0f )

		'' multiplying by one is the identity, by zero annihilates
		dim as Vec3 one_ = type<Vec3>( 1, 1, 1 ), zero_ = type<Vec3>( 0, 0, 0 )
		dim as Vec3 m1 = Mul( a, one_ ), m0 = Mul( a, zero_ )
		CU_ASSERT( m1.x = a.x andalso m1.y = a.y andalso m1.z = a.z )
		CU_ASSERT( m0.x = 0.0f andalso m0.y = 0.0f andalso m0.z = 0.0f )

		'' the double-precision family has the same members
		dim as Vec3d p = Vec3d_( 0, 0, 0 ), q = Vec3d_( 0, 3, 4 )
		CU_ASSERT( DistanceSquared( p, q ) = 25.0 )
		CU_ASSERT( Distance( p, q ) = 5.0 )
	END_TEST

	'' The polar constructor, which is the only way to build a complex number
	'' from an angle without writing cos/sin at the call site.
	TEST( complex_from_polar_ )
		const as double PI_ = 3.14159265358979323846

		'' theta = 0 is the positive real axis
		dim as Complex z = FromPolar( 2.0, 0.0 )
		CU_ASSERT( abs( z.re - 2.0 ) < 1e-12 )
		CU_ASSERT( abs( z.im ) < 1e-12 )

		'' theta = pi is a half turn, and the modulus survives it
		dim as Complex h = FromPolar( 3.0, PI_ )
		CU_ASSERT( abs( h.re + 3.0 ) < 1e-12 )
		CU_ASSERT( abs( h.im ) < 1e-12 )
		CU_ASSERT( abs( AbsValue( h ) - 3.0 ) < 1e-12 )

		'' theta = pi/2 is the positive imaginary axis
		dim as Complex i_ = FromPolar( 1.0, PI_ / 2.0 )
		CU_ASSERT( abs( i_.re ) < 1e-12 )
		CU_ASSERT( abs( i_.im - 1.0 ) < 1e-12 )

		'' r = 0 collapses to the origin whatever the angle
		dim as Complex o = FromPolar( 0.0, 1.234 )
		CU_ASSERT( o.re = 0.0 orelse abs( o.re ) < 1e-15 )
		CU_ASSERT( abs( AbsValue( o ) ) < 1e-15 )

		'' the modulus is r for every angle, and Arg recovers theta on (-pi,pi]
		for k as long = -7 to 7
			dim as double th = k * ( PI_ / 8.0 )
			dim as Complex t = FromPolar( 1.5, th )
			CU_ASSERT( abs( AbsValue( t ) - 1.5 ) < 1e-12 )
			CU_ASSERT( abs( Arg( t ) - th ) < 1e-12 )
		next
	END_TEST

END_SUITE
