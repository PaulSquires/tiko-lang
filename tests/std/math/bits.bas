'' The bit family -- C:\dev\docs\math\RFC-0002-integer.md section 5.
''
'' The gate that matters here is that the PORTABLE path is the contract.  These
'' tests are written against independently-computed references rather than
'' against the header's own helpers, so a shared bug cannot agree with itself.

#import "std/numeric"
#include once "fbcunit.bi"

#include once "fb/optional.bi"

#include once "fblimits.bi"

using numeric

using FB
'' References: the naive bit-at-a-time loops, which are obviously correct and
'' obviously not what the header does.
private function popcount_ref( byval v as ulongint, byval wid as long ) as long
	dim as long n = 0
	for i as long = 0 to wid - 1
		if( ( ( v shr i ) and 1ull ) <> 0 ) then n += 1
	next
	function = n
end function

private function clz_ref( byval v as ulongint, byval wid as long ) as long
	for i as long = wid - 1 to 0 step -1
		if( ( ( v shr i ) and 1ull ) <> 0 ) then return wid - 1 - i
	next
	function = wid
end function

private function ctz_ref( byval v as ulongint, byval wid as long ) as long
	for i as long = 0 to wid - 1
		if( ( ( v shr i ) and 1ull ) <> 0 ) then return i
	next
	function = wid
end function

SUITE( fbc_tests.math.bits )

	'' EXHAUSTIVE over the whole USHORT domain, against the naive references.
	'' RFC-0002 section 8 makes this the gate for the family.
	TEST( exhaustive_ushort_ )
		for i as long = 0 to 65535
			dim as ushort v = cushort( i )
			CU_ASSERT( PopCount( v ) = popcount_ref( v, 16 ) )
			CU_ASSERT( LeadingZeros( v ) = clz_ref( v, 16 ) )
			CU_ASSERT( TrailingZeros( v ) = ctz_ref( v, 16 ) )
			CU_ASSERT( BitWidth( v ) = 16 - clz_ref( v, 16 ) )
			CU_ASSERT( Parity( v ) = ( popcount_ref( v, 16 ) and 1 ) )
		next
	END_TEST

	'' EXHAUSTIVE over the whole UBYTE domain, including the round trips.
	TEST( exhaustive_ubyte_ )
		for i as long = 0 to 255
			dim as ubyte v = cubyte( i )
			CU_ASSERT( PopCount( v ) = popcount_ref( v, 8 ) )
			CU_ASSERT( LeadingZeros( v ) = clz_ref( v, 8 ) )
			CU_ASSERT( TrailingZeros( v ) = ctz_ref( v, 8 ) )
			CU_ASSERT( ByteSwap( v ) = v )                      '' one byte
			CU_ASSERT( BitReverse( BitReverse( v ) ) = v )
			CU_ASSERT( PopCount( BitReverse( v ) ) = PopCount( v ) )
			for n as long = 0 to 8
				CU_ASSERT( RotateRight( RotateLeft( v, n ), n ) = v )
				CU_ASSERT( PopCount( RotateLeft( v, n ) ) = PopCount( v ) )
			next
		next
	END_TEST

	'' THE ZERO CASE IS A DECISION, not a description: the x86 instructions are
	'' undefined at zero without BMI, so the portable path defines it and any
	'' intrinsic path has to match.
	TEST( zero_and_full_width_ )
		CU_ASSERT( LeadingZeros( cubyte( 0 ) ) = 8 )
		CU_ASSERT( LeadingZeros( cushort( 0 ) ) = 16 )
		CU_ASSERT( LeadingZeros( 0ul ) = 32 )
		CU_ASSERT( LeadingZeros( 0ull ) = 64 )
		CU_ASSERT( TrailingZeros( cubyte( 0 ) ) = 8 )
		CU_ASSERT( TrailingZeros( cushort( 0 ) ) = 16 )
		CU_ASSERT( TrailingZeros( 0ul ) = 32 )
		CU_ASSERT( TrailingZeros( 0ull ) = 64 )
		CU_ASSERT( PopCount( 0ull ) = 0 )
		CU_ASSERT( BitWidth( 0ull ) = 0 )

		'' width comes from the OPERAND'S OWN TYPE, not from 64
		CU_ASSERT( LeadingZeros( cubyte( 1 ) ) = 7 )
		CU_ASSERT( LeadingZeros( cushort( 1 ) ) = 15 )
		CU_ASSERT( LeadingZeros( 1ul ) = 31 )
		CU_ASSERT( LeadingZeros( 1ull ) = 63 )

		CU_ASSERT( PopCount( MAX_VALUE_ULONGINT ) = 64 )
		CU_ASSERT( PopCount( MAX_VALUE_ULONG ) = 32 )
		CU_ASSERT( LeadingZeros( MAX_VALUE_ULONGINT ) = 0 )
		CU_ASSERT( TrailingZeros( MAX_VALUE_ULONGINT ) = 0 )
	END_TEST

	'' Rotation MASKS the count.  The C idiom '(x<<n)|(x>>(64-n))' is undefined
	'' at n = 0 and produces garbage in exactly the case nobody tests.
	TEST( rotation_ )
		dim as ulongint v = &h0123456789ABCDEFull
		CU_ASSERT( RotateLeft( v, 0 ) = v )
		CU_ASSERT( RotateLeft( v, 64 ) = v )
		CU_ASSERT( RotateRight( v, 0 ) = v )
		CU_ASSERT( RotateRight( v, 64 ) = v )
		CU_ASSERT( RotateLeft( v, 4 ) = &h123456789ABCDEF0ull )
		CU_ASSERT( RotateRight( v, 4 ) = &hF0123456789ABCDEull )
		CU_ASSERT( RotateLeft( v, 1 ) = RotateRight( v, 63 ) )

		'' negative counts, and counts past the width, both normalise
		CU_ASSERT( RotateLeft( v, -1 ) = RotateRight( v, 1 ) )
		CU_ASSERT( RotateLeft( v, 68 ) = RotateLeft( v, 4 ) )

		'' rotation preserves population, at every width
		for n as long = 0 to 64
			CU_ASSERT( PopCount( RotateLeft( v, n ) ) = PopCount( v ) )
			CU_ASSERT( RotateRight( RotateLeft( v, n ), n ) = v )
		next

		CU_ASSERT( RotateLeft( &h80000001ul, 1 ) = 3ul )
		CU_ASSERT( RotateLeft( cubyte( &h80 ), 1 ) = cubyte( 1 ) )
	END_TEST

	TEST( byteswap_reverse_pow2_ )
		CU_ASSERT( ByteSwap( &h12345678ul ) = &h78563412ul )
		CU_ASSERT( ByteSwap( &h0123456789ABCDEFull ) = &hEFCDAB8967452301ull )
		CU_ASSERT( ByteSwap( cushort( &h1234 ) ) = cushort( &h3412 ) )
		CU_ASSERT( ByteSwap( ByteSwap( &h0123456789ABCDEFull ) ) = &h0123456789ABCDEFull )

		CU_ASSERT( BitReverse( 1ul ) = &h80000000ul )
		CU_ASSERT( BitReverse( &h80000000ul ) = 1ul )
		CU_ASSERT( BitReverse( BitReverse( &hDEADBEEFul ) ) = &hDEADBEEFul )

		'' IsPow2( 0 ) is FALSE -- zero is not a power of two
		CU_ASSERT( IsPow2( 0ul ) = false )
		CU_ASSERT( IsPow2( 1ul ) )
		CU_ASSERT( IsPow2( 2ul ) )
		CU_ASSERT( IsPow2( 3ul ) = false )
		CU_ASSERT( IsPow2( 64ul ) )
		CU_ASSERT( IsPow2( MAX_VALUE_ULONG ) = false )

		CU_ASSERT( NextPow2( 0ul ) = 1 )
		CU_ASSERT( NextPow2( 1ul ) = 1 )
		CU_ASSERT( NextPow2( 2ul ) = 2 )
		CU_ASSERT( NextPow2( 3ul ) = 4 )
		CU_ASSERT( NextPow2( 100ul ) = 128 )
		CU_ASSERT( NextPow2( 65536ul ) = 65536 )

		'' NextPow2 is a power of two and is >= its input, over the range
		for i as ulong = 0 to 5000
			dim as ulong p = NextPow2( i )
			CU_ASSERT( IsPow2( p ) )
			CU_ASSERT( p >= i )
			if( i > 1 ) then CU_ASSERT( ( p shr 1 ) < i )
		next
	END_TEST

	'' The signed overloads REINTERPRET rather than convert.  This is the
	'' documented surprise: LeadingZeros( -1 ) is 0 because the bit pattern is
	'' all ones, not because -1 is large.
	TEST( signed_reinterprets_ )
		'' These go through VARIABLES because fbc RETYPES a negated literal:
		'' typeof( 1L ) is LONG but typeof( -1L ) is INTEGER, so '-1L' would
		'' pick the 64-bit overload and PopCount would be 64.  Written the
		'' direct way this test accuses the header of something fbc did.
		dim as long   m1  = -1
		dim as long   m2  = -2
		dim as longint m1ll = -1
		CU_ASSERT( LeadingZeros( m1 ) = 0 )
		CU_ASSERT( PopCount( m1 ) = 32 )
		CU_ASSERT( PopCount( m1ll ) = 64 )
		CU_ASSERT( PopCount( cbyte( -1 ) ) = 8 )
		CU_ASSERT( TrailingZeros( m2 ) = 1 )
		CU_ASSERT( PopCount( 0L ) = 0 )
		CU_ASSERT( LeadingZeros( 1L ) = 31 )
		CU_ASSERT( ByteSwap( &h12345678L ) = &h78563412L )

		'' signed and unsigned agree on the same bit pattern
		for i as long = -200 to 200
			CU_ASSERT( PopCount( i ) = PopCount( cast( ulong, i ) ) )
			CU_ASSERT( LeadingZeros( i ) = LeadingZeros( cast( ulong, i ) ) )
		next
	END_TEST

END_SUITE
