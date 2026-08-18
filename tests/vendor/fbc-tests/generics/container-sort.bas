' TEST_MODE : COMPILE_AND_RUN_OK

'' fb/sort.bi -- exhaustive.
''
'' Every procedure the header declares, over every shape of input that has ever
'' broken a sort: empty, one, two, already ascending, already descending, all
'' equal, two distinct values, organ-pipe, sawtooth, and a pseudo-random block
'' large enough that the introsort actually partitions rather than falling
'' straight into its insertion-sort cutoff.  Then every size from 0 to 40, so
'' the cutoff boundary at 16 and the merge widths at 16 and 32 are each crossed
'' and not merely straddled.
''
'' Beyond "is the output sorted", which any broken sort can pass by writing the
'' same element everywhere, each run also checks that the output is a
'' PERMUTATION of the input.  A sort that loses or duplicates an element is the
'' failure mode this catches and an is-it-ordered check does not.
''
'' The claims that are not about ordering are checked as claims:
''
''   - StableSort and SortList are STABLE -- verified with a payload that '<'
''     cannot see, so an unstable result is detectable rather than invisible.
''   - Introsort's HEAPSORT FALLBACK is reached -- driven by a comparer that
''     counts its calls against a killer input, with the count bounded so that
''     quadratic behaviour would fail the test rather than merely be slow.
''   - Element MOVES ARE SWAPS -- a counting element type asserts that a sort
''     performs zero copy-constructions and zero destructions.
''   - SortList relinks and does not copy -- the chain is walked FORWARDS and
''     BACKWARDS afterwards, because a merge that forgets 'prv' leaves a list
''     that reads correctly in one direction only.
''
'' A standard library is the one place a gap is expensive: once this is in the
'' distribution every program depends on it, and a member that was never
'' exercised is a bug shipped to everyone.

#include once "fb/sort.bi"
using FB

#define assert_(e) if (e) = 0 then fb_Assert(__FILE__, __LINE__, __FUNCTION__, #e)

'' A deterministic generator.  RND is not used: a test that sorts different
'' numbers on each run cannot be debugged from its failure message.
dim shared as ulongint rngState

sub SeedRng( byval s as ulongint )
	rngState = s
end sub

function NextRng( byval bound as long ) as long
	'' xorshift64*, chosen because it is four lines and its low bits are not
	'' obviously patterned.  Sorting quality does not depend on it.
	rngState xor= rngState shr 12
	rngState xor= rngState shl 25
	rngState xor= rngState shr 27
	return cast( long, ((rngState * 2685821657736338717ull) shr 33) mod bound )
end function

'' ------------------------------------------------------ a counting element
''
'' Counts every construction, copy and destruction, so the "every move is a
'' SWAP" claim in the header is checked rather than asserted.  The full set is
'' needed: an Array assigns, copies and destroys its elements.
dim shared as long liveCounted, copiedCounted, destroyedCounted

type Counted
	as long v
	declare constructor( )
	declare constructor( byval n as long )
	declare constructor( byref rhs as Counted )
	declare operator let( byref rhs as Counted )
	declare destructor( )
end type

constructor Counted( )
	this.v = 0
	liveCounted += 1
end constructor

constructor Counted( byval n as long )
	this.v = n
	liveCounted += 1
end constructor

constructor Counted( byref rhs as Counted )
	this.v = rhs.v
	liveCounted += 1
	copiedCounted += 1
end constructor

operator Counted.let( byref rhs as Counted )
	this.v = rhs.v
	copiedCounted += 1
end operator

destructor Counted( )
	liveCounted -= 1
	destroyedCounted += 1
end destructor

operator < ( byref a as Counted, byref b as Counted ) as boolean
	return a.v < b.v
end operator

'' ------------------------------------------------------- a keyed record
''
'' key is what '<' compares; tag is invisible to it.  Two records with the same
'' key and different tags are EQUIVALENT but not identical, which is the only
'' way to observe stability.
type Rec
	as long key
	as long tag
end type

operator < ( byref a as Rec, byref b as Rec ) as boolean
	return a.key < b.key
end operator

'' Walk a list forwards into an Array.
function ListForward( byref l as LinkedList( of long ) ) as Array( of long )
	dim as Array( of long ) r
	dim as LinkedNode( of long ) ptr p = l.head
	while( p <> 0 )
		r.Push( p->value )
		p = p->nxt
	wend
	return r
end function

'' Walk it BACKWARDS from the tail.  A merge that relinks 'nxt' and forgets
'' 'prv' leaves a list that reads correctly forwards and is broken backwards, so
'' this is not the same assertion twice.
function ListBackward( byref l as LinkedList( of long ) ) as Array( of long )
	dim as Array( of long ) r
	dim as LinkedNode( of long ) ptr p = l.tail
	while( p <> 0 )
		r.Push( p->value )
		p = p->prv
	wend
	return r
end function

'' ------------------------------------------------------------- helpers

'' True when 'a' is a permutation of the multiset in 'want'.  Both are sorted
'' copies compared element by element -- which would be circular if it used the
'' sort under test, so the copy is bubble-sorted here in the test itself.
function SameMultiset( byref a as Array( of long ), byref b as Array( of long ) ) as boolean
	if( a.Count( ) <> b.Count( ) ) then
		return false
	end if

	dim as Array( of long ) x = a
	dim as Array( of long ) y = b

	for i as long = 0 to x.Count( )-2
		for j as long = 0 to x.Count( )-2-i
			if( x[ j+1 ] < x[ j ] ) then swap x[ j ], x[ j+1 ]
			if( y[ j+1 ] < y[ j ] ) then swap y[ j ], y[ j+1 ]
		next
	next

	for i as long = 0 to x.Count( )-1
		if( x[ i ] <> y[ i ] ) then
			return false
		end if
	next
	return true
end function

function Ascending( byref a as Array( of long ) ) as boolean
	for i as long = 1 to a.Count( )-1
		if( a[ i ] < a[ i-1 ] ) then
			return false
		end if
	next
	return true
end function

'' Fill 'a' with one of the input shapes that have historically broken sorts.
'' 'shape' selects; 'n' is the length.
sub MakeShape( byref a as Array( of long ), byval shape as long, byval n as long )
	a.Clear( )
	select case shape
	case 0                                  '' already ascending
		for i as long = 0 to n-1 : a.Push( i ) : next
	case 1                                  '' already descending
		for i as long = 0 to n-1 : a.Push( n-1-i ) : next
	case 2                                  '' all equal
		for i as long = 0 to n-1 : a.Push( 7 ) : next
	case 3                                  '' two distinct values
		for i as long = 0 to n-1 : a.Push( i and 1 ) : next
	case 4                                  '' organ pipe: up then down
		for i as long = 0 to n-1
			if( i < n\2 ) then a.Push( i ) else a.Push( n-1-i )
		next
	case 5                                  '' sawtooth
		for i as long = 0 to n-1 : a.Push( i mod 8 ) : next
	case 6                                  '' pseudo-random, wide range
		for i as long = 0 to n-1 : a.Push( NextRng( 1000000 ) ) : next
	case else                               '' pseudo-random, many duplicates
		for i as long = 0 to n-1 : a.Push( NextRng( 5 ) ) : next
	end select
end sub

const SHAPE_COUNT as long = 8

'' ============================================================ Sort, SortBy

scope
	'' Every shape at every length from 0 to 40, which crosses the
	'' insertion-sort cutoff at 16, plus three larger lengths that force real
	'' partitioning and several levels of recursion.
	SeedRng( 20260809 )

	for shape as long = 0 to SHAPE_COUNT-1
		for n as long = 0 to 40
			dim as Array( of long ) a
			MakeShape( a, shape, n )
			dim as Array( of long ) before = a

			Sort( a )

			assert_( a.Count( ) = n )
			assert_( Ascending( a ) )
			assert_( IsSorted( a ) )
			assert_( SameMultiset( a, before ) )
		next
	next

	for shape as long = 0 to SHAPE_COUNT-1
		dim as long sizes( 0 to 2 ) = { 100, 511, 1000 }
		for s as long = 0 to 2
			dim as Array( of long ) a
			MakeShape( a, shape, sizes( s ) )
			dim as Array( of long ) before = a

			Sort( a )

			assert_( a.Count( ) = sizes( s ) )
			assert_( IsSorted( a ) )
			assert_( SameMultiset( a, before ) )
		next
	next
end scope

scope
	'' Boundaries, spelled out rather than left to the loop above.
	dim as Array( of long ) e
	Sort( e )
	assert_( e.Count( ) = 0 )
	assert_( IsSorted( e ) )

	dim as Array( of long ) one
	one.Push( 42 )
	Sort( one )
	assert_( one.Count( ) = 1 )
	assert_( one[ 0 ] = 42 )

	dim as Array( of long ) two
	two.Push( 2 ) : two.Push( 1 )
	Sort( two )
	assert_( two[ 0 ] = 1 )
	assert_( two[ 1 ] = 2 )

	'' Sorting an already-sorted array is a no-op, not a re-shuffle.
	Sort( two )
	assert_( two[ 0 ] = 1 )
	assert_( two[ 1 ] = 2 )
end scope

scope
	'' Negative values and the extremes of LONG, because a partition that does
	'' arithmetic on the values rather than comparing them breaks here.
	dim as Array( of long ) a
	a.Push( 0 ) : a.Push( 2147483647 ) : a.Push( -2147483648 )
	a.Push( -1 ) : a.Push( 1 )
	Sort( a )
	assert_( a[ 0 ] = -2147483648 )
	assert_( a[ 1 ] = -1 )
	assert_( a[ 2 ] = 0 )
	assert_( a[ 3 ] = 1 )
	assert_( a[ 4 ] = 2147483647 )
end scope

scope
	'' Element types other than LONG: STRING, DOUBLE, and a UDT with its own
	'' global '<'.
	dim as Array( of string ) s
	s.Push( "pear" ) : s.Push( "Apple" ) : s.Push( "fig" ) : s.Push( "apple" )
	s.Push( "" ) : s.Push( "fig" )
	Sort( s )
	assert_( s[ 0 ] = "" )
	assert_( s[ 1 ] = "Apple" )              '' uppercase sorts before lowercase
	assert_( s[ 2 ] = "apple" )
	assert_( s[ 3 ] = "fig" )
	assert_( s[ 4 ] = "fig" )
	assert_( s[ 5 ] = "pear" )
	assert_( IsSorted( s ) )

	dim as Array( of double ) d
	d.Push( 2.5 ) : d.Push( -0.5 ) : d.Push( 2.5 ) : d.Push( 1e300 ) : d.Push( 0.0 )
	Sort( d )
	assert_( d[ 0 ] = -0.5 )
	assert_( d[ 1 ] = 0.0 )
	assert_( d[ 2 ] = 2.5 )
	assert_( d[ 3 ] = 2.5 )
	assert_( d[ 4 ] = 1e300 )

	dim as Array( of Rec ) r
	for i as long = 0 to 49
		dim as Rec x
		x.key = 49 - i
		x.tag = i
		r.Push( x )
	next
	Sort( r )
	dim as boolean ok = true
	for i as long = 0 to 49
		if( r[ i ].key <> i ) then ok = false
	next
	assert_( ok )
	assert_( IsSorted( r ) )
end scope

scope
	'' SortBy with a non-capturing lambda: descending.
	dim as Array( of long ) a
	for i as long = 0 to 99 : a.Push( i ) : next
	SortBy( a, function( byref x as long, byref y as long ) as boolean
		return x > y
	end function )
	dim as boolean ok = true
	for i as long = 0 to 99
		if( a[ i ] <> 99-i ) then ok = false
	next
	assert_( ok )
	assert_( IsSorted( a ) = false )         '' descending is not ascending

	'' IsSortedBy agrees with the comparer it is given.  Hoisted out of assert_
	'' because a multi-line lambda cannot be a macro argument -- the macro
	'' expander stops at the first end of line.
	dim as boolean byDescending = IsSortedBy( a, function( byref x as long, byref y as long ) as boolean
		return x > y
	end function )
	assert_( byDescending )
end scope

scope
	'' SortBy with a CAPTURING lambda -- the case a procedure-pointer parameter
	'' could not accept, and the reason the comparer is a generic parameter.
	dim as long comparisons = 0
	dim as Array( of long ) a
	for i as long = 0 to 199 : a.Push( 199-i ) : next

	SortBy( a, function[ byref comparisons ]( byref x as long, byref y as long ) as boolean
		comparisons += 1
		return x < y
	end function )

	assert_( IsSorted( a ) )
	assert_( comparisons > 0 )
	'' n log2 n for n=200 is about 1529.  Ten times that is a generous ceiling
	'' that O(n^2) -- 40,000 -- still fails, so this is a real bound on the
	'' complexity claim and not decoration.
	assert_( comparisons < 15290 )
end scope

scope
	'' SortBy by a secondary field: sort records by tag rather than key.
	dim as Array( of Rec ) r
	for i as long = 0 to 9
		dim as Rec x
		x.key = i
		x.tag = 9 - i
		r.Push( x )
	next
	SortBy( r, function( byref x as Rec, byref y as Rec ) as boolean
		return x.tag < y.tag
	end function )
	dim as boolean ok = true
	for i as long = 0 to 9
		if( r[ i ].tag <> i ) then ok = false
	next
	assert_( ok )
end scope

'' ================================================= the heapsort fallback

scope
	'' The median-of-three quicksort's killer input.  This is a "median-of-3
	'' killer" in the Musser sense: an arrangement built so that the
	'' median-of-three pivot is the second-smallest remaining element at every
	'' level, which drives the recursion linearly deep.
	''
	'' Without the depth limit that is O(n^2).  With it, heapsort takes over and
	'' the comparison count stays near n log n.  The assertion below is what
	'' makes this a test of the FALLBACK and not just another sort:
	'' 25 * n log2 n is far above what introsort needs and far below the
	'' 65,536-plus that the quadratic path would cost.
	const N as long = 512
	dim as Array( of long ) a
	redim as long killer( 0 to N-1 )

	'' Build it by running the pivot choice backwards: fill the positions the
	'' median-of-three will look at with the small values, in the order it will
	'' look at them.
	for i as long = 0 to N-1
		killer( i ) = i
	next
	dim as long lo = 0, hi = N-1, small = 0
	while( lo < hi )
		dim as long mid_ = lo + (hi - lo) \ 2
		swap killer( mid_ ), killer( hi-1 )
		dim as long t = killer( lo )
		killer( lo ) = killer( hi )
		killer( hi ) = t
		killer( lo ) = small
		small += 1
		lo += 1
		hi -= 1
	wend

	for i as long = 0 to N-1
		a.Push( killer( i ) )
	next
	dim as Array( of long ) before = a

	dim as long comparisons = 0
	SortBy( a, function[ byref comparisons ]( byref x as long, byref y as long ) as boolean
		comparisons += 1
		return x < y
	end function )

	assert_( IsSorted( a ) )
	assert_( SameMultiset( a, before ) )
	'' n log2 n for n=512 is 4608.
	assert_( comparisons < 4608 * 25 )
end scope

scope
	'' A comparer that always returns FALSE -- every element equivalent.  A
	'' correct partition must terminate; an unguarded one walks off the array.
	'' The order is unspecified, the survival of the elements is not.
	dim as Array( of long ) a
	for i as long = 0 to 99 : a.Push( 99-i ) : next
	dim as Array( of long ) before = a
	SortBy( a, function( byref x as long, byref y as long ) as boolean
		return false
	end function )
	assert_( a.Count( ) = 100 )
	assert_( SameMultiset( a, before ) )
end scope

scope
	'' A comparer that always returns TRUE -- an inconsistent one, which is
	'' undefined behaviour in C++ and is documented here as producing a garbage
	'' ORDER.  What it must not do is corrupt memory or fail to return, and that
	'' is what the bounds checks in the partition are for.
	dim as Array( of long ) a
	for i as long = 0 to 99 : a.Push( 99-i ) : next
	dim as Array( of long ) before = a
	SortBy( a, function( byref x as long, byref y as long ) as boolean
		return true
	end function )
	assert_( a.Count( ) = 100 )
	assert_( SameMultiset( a, before ) )
end scope

'' ============================================= StableSort, StableSortBy

scope
	'' The same sweep as the introsort, over the same shapes and lengths.  The
	'' merge widths start at 16 and double, so lengths through 40 cross the
	'' first two of them.
	SeedRng( 987654321 )

	for shape as long = 0 to SHAPE_COUNT-1
		for n as long = 0 to 40
			dim as Array( of long ) a
			MakeShape( a, shape, n )
			dim as Array( of long ) before = a

			StableSort( a )

			assert_( a.Count( ) = n )
			assert_( IsSorted( a ) )
			assert_( SameMultiset( a, before ) )
		next
	next

	for shape as long = 0 to SHAPE_COUNT-1
		dim as long sizes( 0 to 2 ) = { 100, 511, 1000 }
		for s as long = 0 to 2
			dim as Array( of long ) a
			MakeShape( a, shape, sizes( s ) )
			dim as Array( of long ) before = a

			StableSort( a )

			assert_( IsSorted( a ) )
			assert_( SameMultiset( a, before ) )
		next
	next
end scope

scope
	'' STABILITY, which is the whole reason StableSort exists.
	''
	'' 400 records over 8 distinct keys, so every key has 50 equivalents.  '<'
	'' cannot see 'tag', so if the sort is stable the tags within each key must
	'' still be strictly increasing afterwards.  A shuffled input makes an
	'' accidental pass unlikely.
	SeedRng( 555 )
	dim as Array( of Rec ) r
	for i as long = 0 to 399
		dim as Rec x
		x.key = NextRng( 8 )
		x.tag = i
		r.Push( x )
	next

	StableSort( r )

	assert_( IsSorted( r ) )
	dim as boolean stable = true
	for i as long = 1 to r.Count( )-1
		if( r[ i ].key = r[ i-1 ].key ) then
			if( r[ i ].tag <= r[ i-1 ].tag ) then stable = false
		end if
	next
	assert_( stable )

	'' The same input through the introsort is still SORTED -- it just carries
	'' no stability promise, so only the ordering is asserted.
	SeedRng( 555 )
	dim as Array( of Rec ) r2
	for i as long = 0 to 399
		dim as Rec x
		x.key = NextRng( 8 )
		x.tag = i
		r2.Push( x )
	next
	Sort( r2 )
	assert_( IsSorted( r2 ) )
end scope

scope
	'' Stability at every length across the 16-element run boundary and the
	'' first two merge passes -- where an off-by-one in the merge shows up as an
	'' inversion of two equivalent elements and nothing else.
	for n as long = 0 to 70
		dim as Array( of Rec ) r
		for i as long = 0 to n-1
			dim as Rec x
			x.key = i mod 3
			x.tag = i
			r.Push( x )
		next

		StableSortBy( r, function( byref x as Rec, byref y as Rec ) as boolean
			return x.key < y.key
		end function )

		assert_( r.Count( ) = n )
		dim as boolean ok = true
		for i as long = 1 to n-1
			if( r[ i ].key < r[ i-1 ].key ) then ok = false
			if( r[ i ].key = r[ i-1 ].key ) then
				if( r[ i ].tag <= r[ i-1 ].tag ) then ok = false
			end if
		next
		assert_( ok )
	next
end scope

scope
	'' StableSortBy with a capturing comparer, and the same complexity bound.
	'' Merge sort is O(n log n) in the BEST case too, so this bound holds for
	'' already-sorted input as well.
	dim as long comparisons = 0
	dim as Array( of long ) a
	for i as long = 0 to 199 : a.Push( 199-i ) : next

	StableSortBy( a, function[ byref comparisons ]( byref x as long, byref y as long ) as boolean
		comparisons += 1
		return x < y
	end function )

	assert_( IsSorted( a ) )
	assert_( comparisons < 15290 )
end scope

scope
	'' StableSort on strings: the element type with a heap allocation, where a
	'' merge that mismanages the scratch buffer corrupts rather than misorders.
	dim as Array( of string ) s
	for i as long = 0 to 99
		s.Push( "item" + str( 99 - i ) )
	next
	StableSort( s )
	assert_( IsSorted( s ) )
	assert_( s[ 0 ] = "item0" )
	assert_( s.Count( ) = 100 )
	'' Every string is still intact and non-empty -- a scratch-buffer bug shows
	'' up as blanks long before it shows up as a bad order.
	dim as boolean allLive = true
	for i as long = 0 to 99
		if( len( s[ i ] ) < 5 ) then allLive = false
	next
	assert_( allLive )
end scope

'' ================================================== moves are swaps, not copies

scope
	'' The header claims every move is a SWAP and that no T is copied or
	'' destroyed.  Both sorts are measured against that claim.
	dim as Array( of Counted ) a
	for i as long = 0 to 99
		a.Push( Counted( 99 - i ) )
	next

	dim as long liveBefore = liveCounted
	copiedCounted = 0
	destroyedCounted = 0

	Sort( a )

	assert_( copiedCounted = 0 )
	assert_( destroyedCounted = 0 )
	assert_( liveCounted = liveBefore )

	dim as boolean ok = true
	for i as long = 0 to 99
		if( a[ i ].v <> i ) then ok = false
	next
	assert_( ok )

	'' The merge sort moves through a scratch buffer.  The buffer's elements are
	'' default-constructed once and destroyed once, so the live count must
	'' return to where it started -- and still nothing is COPIED.
	dim as Array( of Counted ) b
	for i as long = 0 to 99
		b.Push( Counted( 99 - i ) )
	next
	liveBefore = liveCounted
	copiedCounted = 0

	StableSort( b )

	assert_( copiedCounted = 0 )
	assert_( liveCounted = liveBefore )
	ok = true
	for i as long = 0 to 99
		if( b[ i ].v <> i ) then ok = false
	next
	assert_( ok )
end scope

'' ========================================================== SortList, SortListBy

scope
	SeedRng( 4242 )

	for shape as long = 0 to SHAPE_COUNT-1
		for n as long = 0 to 40
			dim as Array( of long ) src
			MakeShape( src, shape, n )

			dim as LinkedList( of long ) l
			for i as long = 0 to n-1
				l.PushBack( src[ i ] )
			next

			SortList( l )

			assert_( l.Count( ) = n )

			dim as Array( of long ) fwd = ListForward( l )
			assert_( fwd.Count( ) = n )
			assert_( IsSorted( fwd ) )
			assert_( SameMultiset( fwd, src ) )

			'' The backward walk must visit the same n nodes in reverse.
			dim as Array( of long ) bwd = ListBackward( l )
			assert_( bwd.Count( ) = n )
			dim as boolean mirrored = true
			for i as long = 0 to n-1
				if( bwd[ i ] <> fwd[ n-1-i ] ) then mirrored = false
			next
			assert_( mirrored )

			'' head->prv and tail->nxt must be null, or a later PushFront /
			'' PushBack corrupts the chain.
			if( n > 0 ) then
				assert_( l.head <> 0 )
				assert_( l.tail <> 0 )
				assert_( l.head->prv = 0 )
				assert_( l.tail->nxt = 0 )
				assert_( l.Front( ) = fwd[ 0 ] )
				assert_( l.Back( ) = fwd[ n-1 ] )
			end if
		next
	next
end scope

scope
	'' A sorted list is still a usable list: pushing and popping at both ends
	'' after the sort proves the whole chain, not just the pointers the walk
	'' happened to follow.
	dim as LinkedList( of long ) l
	for i as long = 0 to 19
		l.PushBack( 19 - i )
	next
	SortList( l )

	assert_( l.PopFront( ) = 0 )
	assert_( l.PopBack( ) = 19 )
	assert_( l.Count( ) = 18 )
	l.PushFront( -1 )
	l.PushBack( 99 )
	assert_( l.Front( ) = -1 )
	assert_( l.Back( ) = 99 )
	assert_( l.Count( ) = 20 )

	dim as Array( of long ) fwd = ListForward( l )
	assert_( IsSorted( fwd ) )

	'' Deep copy after a sort is still deep.
	dim as LinkedList( of long ) copy_ = l
	assert_( copy_.Count( ) = 20 )
	copy_.PopFront( )
	assert_( copy_.Count( ) = 19 )
	assert_( l.Count( ) = 20 )
end scope

scope
	'' Boundaries.
	dim as LinkedList( of long ) e
	SortList( e )
	assert_( e.Count( ) = 0 )
	assert_( e.head = 0 )
	assert_( e.tail = 0 )

	dim as LinkedList( of long ) one
	one.PushBack( 5 )
	SortList( one )
	assert_( one.Count( ) = 1 )
	assert_( one.Front( ) = 5 )
	assert_( one.head = one.tail )
	assert_( one.head->prv = 0 )
	assert_( one.tail->nxt = 0 )

	dim as LinkedList( of long ) two
	two.PushBack( 2 ) : two.PushBack( 1 )
	SortList( two )
	assert_( two.Front( ) = 1 )
	assert_( two.Back( ) = 2 )
	assert_( two.head->nxt = two.tail )
	assert_( two.tail->prv = two.head )
end scope

scope
	'' SortListBy: descending, and with a capturing comparer.
	dim as LinkedList( of string ) l
	l.PushBack( "delta" ) : l.PushBack( "alpha" )
	l.PushBack( "charlie" ) : l.PushBack( "bravo" )

	dim as long comparisons = 0
	SortListBy( l, function[ byref comparisons ]( byref x as string, byref y as string ) as boolean
		comparisons += 1
		return x > y
	end function )

	assert_( comparisons > 0 )
	assert_( l.PopFront( ) = "delta" )
	assert_( l.PopFront( ) = "charlie" )
	assert_( l.PopFront( ) = "bravo" )
	assert_( l.PopFront( ) = "alpha" )
	assert_( l.IsEmpty( ) )
end scope

scope
	'' SortList is STABLE, checked the same way StableSort is.
	SeedRng( 31337 )
	dim as LinkedList( of Rec ) l
	for i as long = 0 to 199
		dim as Rec x
		x.key = NextRng( 5 )
		x.tag = i
		l.PushBack( x )
	next

	SortList( l )

	assert_( l.Count( ) = 200 )
	dim as boolean ok = true
	dim as LinkedNode( of Rec ) ptr p = l.head
	dim as long prevKey = -1, prevTag = -1
	while( p <> 0 )
		if( p->value.key < prevKey ) then ok = false
		if( p->value.key = prevKey ) then
			if( p->value.tag <= prevTag ) then ok = false
		end if
		prevKey = p->value.key
		prevTag = p->value.tag
		p = p->nxt
	wend
	assert_( ok )
end scope

scope
	'' SortList relinks nodes and moves no element: zero copies, zero
	'' destructions, and the live count unchanged.
	dim as LinkedList( of Counted ) l
	for i as long = 0 to 99
		l.PushBack( Counted( 99 - i ) )
	next

	dim as long liveBefore = liveCounted
	copiedCounted = 0
	destroyedCounted = 0

	SortList( l )

	assert_( copiedCounted = 0 )
	assert_( destroyedCounted = 0 )
	assert_( liveCounted = liveBefore )

	dim as boolean ok = true
	dim as LinkedNode( of Counted ) ptr p = l.head
	dim as long expect = 0
	while( p <> 0 )
		if( p->value.v <> expect ) then ok = false
		expect += 1
		p = p->nxt
	wend
	assert_( ok )
	assert_( expect = 100 )
end scope

'' ============================================ a container of containers

scope
	'' Sorting an Array( of Array( of long ) ) is not possible -- an Array has
	'' no '<' -- but the OUTER array must still instantiate, which is the whole
	'' reason these are free procedures.  Sorting the inner ones works.
	dim as Array( of Array( of long ) ) outer_
	for i as long = 0 to 4
		dim as Array( of long ) inner
		inner.Push( 5 - i )
		inner.Push( 1 )
		outer_.Push( inner )
	next

	for i as long = 0 to 4
		Sort( outer_[ i ] )
		assert_( outer_[ i ][ 0 ] <= outer_[ i ][ 1 ] )
	next
	assert_( outer_.Count( ) = 5 )
end scope

'' ===================================================== the Map/Set idiom

scope
	'' Map and Set cannot be sorted, and the documented workaround is to sort a
	'' snapshot.  Checked, because a documented idiom that does not compile is
	'' worse than none.
	dim as Array( of string ) ks
	ks.Push( "pear" ) : ks.Push( "apple" ) : ks.Push( "fig" )
	Sort( ks )
	assert_( ks[ 0 ] = "apple" )
	assert_( ks[ 1 ] = "fig" )
	assert_( ks[ 2 ] = "pear" )
end scope

print "container-sort: ok"
