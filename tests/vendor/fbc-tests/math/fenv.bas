'' The floating-point environment -- RFC-0008-precision.md section 4.

#include once "fbcunit.bi"
#include once "fb/fenv.bi"

using FB

'' Computed through a non-inlinable call so the rounding mode in force at the
'' time of the division is the one being tested.
private function divide_( byval a as double, byval b as double ) as double
	function = a / b
end function

'' Out of line, so the RETURN really does leave the frame.
private function returns_early_( ) as long
	dim r as ScopedRounding = ScopedRounding( ROUND_TOWARD_POSITIVE )
	if( GetRoundingMode( ) = ROUND_TOWARD_POSITIVE ) then return 1
	function = 0
end function

SUITE( fbc_tests.math.fenv )

	'' A rounding-mode change must be OBSERVABLE, or the surface is decorative.
	TEST( rounding_modes_change_results_ )
		dim as long saved = GetRoundingMode( )
		CU_ASSERT( saved = ROUND_TO_NEAREST )

		'' 1/3 has no exact binary representation, so the directed modes must
		'' straddle the nearest one.
		CU_ASSERT( SetRoundingMode( ROUND_TOWARD_NEGATIVE ) )
		CU_ASSERT( GetRoundingMode( ) = ROUND_TOWARD_NEGATIVE )
		dim as double down_ = divide_( 1.0, 3.0 )

		CU_ASSERT( SetRoundingMode( ROUND_TOWARD_POSITIVE ) )
		CU_ASSERT( GetRoundingMode( ) = ROUND_TOWARD_POSITIVE )
		dim as double up_ = divide_( 1.0, 3.0 )

		CU_ASSERT( SetRoundingMode( ROUND_TO_NEAREST ) )
		dim as double near_ = divide_( 1.0, 3.0 )

		CU_ASSERT( SetRoundingMode( ROUND_TOWARD_ZERO ) )
		dim as double zero_ = divide_( 1.0, 3.0 )

		SetRoundingMode( saved )
		CU_ASSERT( GetRoundingMode( ) = ROUND_TO_NEAREST )

		'' the directed results bracket the nearest one, and differ from it
		CU_ASSERT( down_ < up_ )
		CU_ASSERT( down_ <= near_ )
		CU_ASSERT( near_ <= up_ )
		'' toward zero equals toward negative for a positive value
		CU_ASSERT( zero_ = down_ )
	END_TEST

	'' ScopedRounding restores on EVERY exit path -- the guarantee 'defer'
	'' gives, expressed as a type because the previous mode must be captured on
	'' the way in.
	TEST( scoped_restores_on_every_path_ )
		CU_ASSERT( GetRoundingMode( ) = ROUND_TO_NEAREST )

		'' fallthrough
		scope
			dim r as ScopedRounding = ScopedRounding( ROUND_TOWARD_POSITIVE )
			CU_ASSERT( GetRoundingMode( ) = ROUND_TOWARD_POSITIVE )
		end scope
		CU_ASSERT( GetRoundingMode( ) = ROUND_TO_NEAREST )

		'' EXIT out of a loop
		for i as long = 1 to 3
			dim r as ScopedRounding = ScopedRounding( ROUND_TOWARD_NEGATIVE )
			CU_ASSERT( GetRoundingMode( ) = ROUND_TOWARD_NEGATIVE )
			if( i = 2 ) then exit for
		next
		CU_ASSERT( GetRoundingMode( ) = ROUND_TO_NEAREST )

		'' every iteration of a loop body restores
		for i as long = 1 to 5
			scope
				dim r as ScopedRounding = ScopedRounding( ROUND_TOWARD_ZERO )
				CU_ASSERT( GetRoundingMode( ) = ROUND_TOWARD_ZERO )
			end scope
			CU_ASSERT( GetRoundingMode( ) = ROUND_TO_NEAREST )
		next

		'' nested scopes restore in reverse order
		scope
			dim a as ScopedRounding = ScopedRounding( ROUND_TOWARD_POSITIVE )
			scope
				dim b as ScopedRounding = ScopedRounding( ROUND_TOWARD_NEGATIVE )
				CU_ASSERT( GetRoundingMode( ) = ROUND_TOWARD_NEGATIVE )
			end scope
			CU_ASSERT( GetRoundingMode( ) = ROUND_TOWARD_POSITIVE )
		end scope
		CU_ASSERT( GetRoundingMode( ) = ROUND_TO_NEAREST )
	END_TEST

	'' A RETURN out of a procedure also restores, which needs its own case
	'' because the destructor runs on the way out of the frame.
	TEST( scoped_restores_on_return_ )
		CU_ASSERT( GetRoundingMode( ) = ROUND_TO_NEAREST )
		CU_ASSERT( returns_early_( ) = 1 )
		CU_ASSERT( GetRoundingMode( ) = ROUND_TO_NEAREST )
	END_TEST

	TEST( exception_flags_ )
		ClearFpExceptions( )
		CU_ASSERT( TestFpException( FP_DIVBYZERO ) = false )
		CU_ASSERT( TestFpException( FP_OVERFLOW ) = false )
		CU_ASSERT( TestFpException( FP_INVALID ) = false )

		'' division by zero raises its flag and not the others
		dim as double z = 0.0
		dim as double inf_ = divide_( 1.0, z )
		CU_ASSERT( TestFpException( FP_DIVBYZERO ) )
		CU_ASSERT( inf_ > 1e308 )

		ClearFpExceptions( )
		CU_ASSERT( TestFpException( FP_DIVBYZERO ) = false )

		'' 0/0 is invalid, not divide-by-zero
		dim as double nn = divide_( z, z )
		CU_ASSERT( TestFpException( FP_INVALID ) )
		CU_ASSERT( ( nn = nn ) = 0 )

		ClearFpExceptions( )

		'' overflow
		dim as double big_ = 1.7976931348623157e308
		dim as double ov = big_ * 2.0
		CU_ASSERT( TestFpException( FP_OVERFLOW ) )

		ClearFpExceptions( )
		CU_ASSERT( TestFpException( FP_ALL_EXCEPT ) = false )

		'' raising a flag explicitly, and clearing just one
		RaiseFpException( FP_INEXACT )
		CU_ASSERT( TestFpException( FP_INEXACT ) )
		ClearFpException( FP_INEXACT )
		CU_ASSERT( TestFpException( FP_INEXACT ) = false )
	END_TEST

END_SUITE
