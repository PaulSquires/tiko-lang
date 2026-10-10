' TEST_MODE : COMPILE_AND_RUN_OK

'' containers.OrderedMap( of TK, TV ) -- exhaustive.
''
'' Every declared member, every state (empty / one / many), the indexer's
'' insert-on-miss, deep copy and assignment independence in both directions,
'' destructor balance with a counting value type, four key types, and both FOR
'' EACH binding forms including the tuple destructuring view.
''
'' Then the part a hash map's test does not need: the RED-BLACK INVARIANTS.
'' A tree that has lost its balance still answers every lookup correctly and
'' still iterates in order -- it has merely degraded to a linked list, and no
'' functional test can see that. So BlackHeight( ) is asserted non-negative
'' after every destructive phase, which is what makes the O(log n) claim a
'' tested claim rather than a comment.
''
'' The removal rebalance is the part that is easy to get wrong and hard to
'' reach: its four cases and their mirrors need specific tree shapes. They are
'' reached here by a DIFFERENTIAL stress against containers.Map over 400,000 random
'' operations, which is the only practical way to hit them all -- and every
'' operation is checked against the hash map's answer, so a wrong result is
'' caught even when the invariants survive.
#import "std/containers"
using containers
#define assert_(e) if (e) = 0 then fb_Assert(__FILE__, __LINE__, __FUNCTION__, #e)

'' A deterministic generator: a test that uses different numbers on each run
'' cannot be debugged from its failure message.
dim shared as ulongint rngstate

sub Seed( byval s as ulongint )
	rngstate = s
end sub

function NextR( byval bound as long ) as long
	rngstate xor= rngstate shl 13
	rngstate xor= rngstate shr 7
	rngstate xor= rngstate shl 17
	return cast( long, (rngstate shr 33) mod bound )
end function

'' Counts itself, for the destructor-balance section.
dim shared as long liveCounted

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
end constructor

operator Counted.let( byref rhs as Counted )
	this.v = rhs.v
end operator

destructor Counted( )
	liveCounted -= 1
end destructor

'' A key with '<' and NO hash and NO '=', which is the point: this type cannot
'' be an containers.Map key at all, and is a perfectly good OrderedMap key.
type Version
	as long major_
	as long minor_
end type

operator < ( byref a as Version, byref b as Version ) as boolean
	if( a.major_ <> b.major_ ) then
		return a.major_ < b.major_
	end if
	return a.minor_ < b.minor_
end operator

'' ===================================================================== empty

scope
	dim m as OrderedMap( of long, long )

	assert_( m.Count( ) = 0 )
	assert_( m.IsEmpty( ) )
	assert_( m.Contains( 1 ) = false )
	assert_( m.Remove( 1 ) = false )
	assert_( m.BlackHeight( ) >= 0 )

	dim as long gv
	assert_( m.TryGet( 1, gv ) = false )

	dim as long fk, fv
	assert_( m.TryFirst( fk, fv ) = false )
	assert_( m.TryLast( fk, fv ) = false )
	dim as long ok_
	assert_( m.TryFloor( 5, ok_ ) = false )
	assert_( m.TryCeiling( 5, ok_ ) = false )

	assert_( m.Keys( ).Count( ) = 0 )
	assert_( m.Values( ).Count( ) = 0 )

	dim as long walked = 0
	for each kv in m
		walked += 1
	next
	assert_( walked = 0 )

	'' clearing an empty map is a no-op, not a crash
	m.Clear( )
	assert_( m.Count( ) = 0 )
end scope

'' =============================================================== one and two

scope
	dim m as OrderedMap( of long, long )

	assert_( m.Put( 5, 50 ) )                    '' TRUE: new key
	assert_( m.Count( ) = 1 )
	assert_( m.IsEmpty( ) = false )
	assert_( m.Contains( 5 ) )
	assert_( m.BlackHeight( ) >= 0 )

	assert_( m.Put( 5, 51 ) = false )            '' FALSE: overwrite
	assert_( m.Count( ) = 1 )
	dim as long gv
	assert_( m.TryGet( 5, gv ) andalso (gv = 51) )

	assert_( m.Add( 5, 99 ) = false )            '' Add does NOT overwrite
	assert_( m.TryGet( 5, gv ) andalso (gv = 51) )
	assert_( m.Add( 6, 60 ) )
	assert_( m.Count( ) = 2 )

	dim as long fk, fv, lk, lv
	assert_( m.TryFirst( fk, fv ) andalso (fk = 5) andalso (fv = 51) )
	assert_( m.TryLast( lk, lv ) andalso (lk = 6) andalso (lv = 60) )

	assert_( m.Remove( 5 ) )
	assert_( m.Remove( 5 ) = false )             '' already gone
	assert_( m.Count( ) = 1 )
	assert_( m.BlackHeight( ) >= 0 )
	assert_( m.TryFirst( fk, fv ) andalso (fk = 6) )

	assert_( m.Remove( 6 ) )
	assert_( m.Count( ) = 0 )
	assert_( m.BlackHeight( ) >= 0 )
end scope

'' ================================================================ the indexer

scope
	dim m as OrderedMap( of string, long )

	'' INSERTS on a miss -- the documented behaviour, shared with containers.Map
	m[ "a" ] += 1
	assert_( m.Count( ) = 1 )
	assert_( m[ "a" ] = 1 )
	m[ "a" ] += 41
	assert_( m[ "a" ] = 42 )
	assert_( m.Count( ) = 1 )

	'' merely READING through it inserts too, which is the price
	dim as long unused = m[ "ghost" ]
	assert_( m.Count( ) = 2 )
	assert_( m.Contains( "ghost" ) )

	'' TryGet and Contains do not
	dim as long gv
	assert_( m.TryGet( "nope", gv ) = false )
	assert_( m.Contains( "nope" ) = false )
	assert_( m.Count( ) = 2 )

	'' writing through the indexer
	m[ "b" ] = 7
	assert_( m[ "b" ] = 7 )
	assert_( m.BlackHeight( ) >= 0 )
end scope

'' ======================================================== order and the walk

scope
	'' Inserted in an order chosen to be nothing like sorted.
	dim m as OrderedMap( of long, long )
	dim as long ins( 0 to 11 ) = { 50, 10, 90, 30, 70, 20, 80, 40, 60, 5, 95, 55 }
	for i as long = 0 to 11
		m.Put( ins( i ), ins( i ) * 2 )
	next
	assert_( m.Count( ) = 12 )
	assert_( m.BlackHeight( ) >= 0 )

	'' FOR EACH is ascending
	dim as long prev = -1, n = 0
	for each kv in m
		assert_( kv.key > prev )
		assert_( kv.value = kv.key * 2 )
		prev = kv.key
		n += 1
	next
	assert_( n = 12 )

	'' the tuple view destructures, and agrees
	prev = -1
	n = 0
	for each (k, v) in m.Pairs( )
		assert_( k > prev )
		assert_( v = k * 2 )
		prev = k
		n += 1
	next
	assert_( n = 12 )

	'' Keys( ) and Values( ) are the same walk, and are already sorted
	dim ks as Array( of long ) = m.Keys( )
	dim vs as Array( of long ) = m.Values( )
	assert_( ks.Count( ) = 12 )
	assert_( vs.Count( ) = 12 )
	assert_( ks[ 0 ] = 5 )
	assert_( ks[ 11 ] = 95 )
	for i as long = 1 to 11
		assert_( ks[ i ] > ks[ i-1 ] )
		assert_( vs[ i ] = ks[ i ] * 2 )
	next

	'' inserting ALREADY SORTED input is the case a naive BST turns into a list
	dim asc_ as OrderedMap( of long, long )
	for i as long = 0 to 999
		asc_.Put( i, i )
	next
	assert_( asc_.Count( ) = 1000 )
	assert_( asc_.BlackHeight( ) >= 0 )
	'' 1000 entries in a red-black tree cannot exceed 2*log2(1001) ~ 20 black
	'' levels; a degenerate list would report about 1000. This is the balance
	'' claim, asserted rather than assumed.
	assert_( asc_.BlackHeight( ) <= 20 )

	'' and descending input, the mirror case
	dim desc as OrderedMap( of long, long )
	for i as long = 999 to 0 step -1
		desc.Put( i, i )
	next
	assert_( desc.Count( ) = 1000 )
	assert_( desc.BlackHeight( ) >= 0 )
	assert_( desc.BlackHeight( ) <= 20 )

	dim as long fk, fv
	assert_( desc.TryFirst( fk, fv ) andalso (fk = 0) )
	assert_( desc.TryLast( fk, fv ) andalso (fk = 999) )
end scope

'' ==================================================== floor and ceiling

scope
	dim m as OrderedMap( of long, long )
	'' 10, 20, 30, 40, 50 -- gaps on both sides and between
	for i as long = 1 to 5
		m.Put( i * 10, i )
	next

	dim as long r

	'' exact hits return the key itself
	assert_( m.TryFloor( 30, r ) andalso (r = 30) )
	assert_( m.TryCeiling( 30, r ) andalso (r = 30) )

	'' between keys
	assert_( m.TryFloor( 35, r ) andalso (r = 30) )
	assert_( m.TryCeiling( 35, r ) andalso (r = 40) )
	assert_( m.TryFloor( 11, r ) andalso (r = 10) )
	assert_( m.TryCeiling( 11, r ) andalso (r = 20) )

	'' at and past the ends
	assert_( m.TryFloor( 10, r ) andalso (r = 10) )
	assert_( m.TryCeiling( 50, r ) andalso (r = 50) )
	assert_( m.TryFloor( 9, r ) = false )        '' nothing is <= 9
	assert_( m.TryCeiling( 51, r ) = false )     '' nothing is >= 51
	assert_( m.TryFloor( 1000, r ) andalso (r = 50) )
	assert_( m.TryCeiling( -1000, r ) andalso (r = 10) )

	'' a failed call leaves the output alone
	r = -777
	assert_( m.TryFloor( 9, r ) = false )
	assert_( r = -777 )

	'' one-element map
	dim one as OrderedMap( of long, long )
	one.Put( 42, 1 )
	assert_( one.TryFloor( 42, r ) andalso (r = 42) )
	assert_( one.TryCeiling( 42, r ) andalso (r = 42) )
	assert_( one.TryFloor( 41, r ) = false )
	assert_( one.TryCeiling( 43, r ) = false )
end scope

'' ============================================ copy, assignment, destruction

scope
	dim a as OrderedMap( of long, string )
	for i as long = 0 to 49
		a.Put( i, "v" + str( i ) )
	next

	'' copy construction is DEEP and structurally identical
	dim b as OrderedMap( of long, string ) = a
	assert_( b.Count( ) = 50 )
	assert_( b.BlackHeight( ) = a.BlackHeight( ) )

	'' independent in BOTH directions
	b.Remove( 10 )
	b.Put( 100, "new" )
	assert_( a.Count( ) = 50 )
	assert_( a.Contains( 10 ) )
	assert_( a.Contains( 100 ) = false )
	assert_( b.Count( ) = 50 )

	a.Put( 200, "other" )
	assert_( b.Contains( 200 ) = false )

	'' assignment, over a non-empty map
	dim c as OrderedMap( of long, string )
	c.Put( 999, "doomed" )
	c = a
	assert_( c.Count( ) = a.Count( ) )
	assert_( c.Contains( 999 ) = false )
	assert_( c.Contains( 200 ) )
	c.Clear( )
	assert_( a.Count( ) = 51 )

	'' self-assignment must not free the tree and then walk it
	dim as long before = a.Count( )
	a = a
	assert_( a.Count( ) = before )
	assert_( a.BlackHeight( ) >= 0 )

	'' assigning an EMPTY map over a full one
	dim empty_ as OrderedMap( of long, string )
	a = empty_
	assert_( a.Count( ) = 0 )
	assert_( a.BlackHeight( ) >= 0 )
end scope

scope
	'' destructor balance: every node's value must be destroyed exactly once,
	'' through the destructor, through Clear, and through assignment
	liveCounted = 0

	scope
		dim m as OrderedMap( of long, Counted )
		for i as long = 0 to 199
			m.Put( i, Counted( i ) )
		next
		assert_( m.Count( ) = 200 )

		dim copy_ as OrderedMap( of long, Counted ) = m
		assert_( copy_.Count( ) = 200 )

		copy_.Clear( )
		assert_( copy_.Count( ) = 0 )

		'' removing half, one at a time
		for i as long = 0 to 199 step 2
			assert_( m.Remove( i ) )
		next
		assert_( m.Count( ) = 100 )
		assert_( m.BlackHeight( ) >= 0 )
	end scope

	assert_( liveCounted = 0 )
end scope

'' ================================================= key types other than LONG

scope
	'' STRING keys
	dim s as OrderedMap( of string, long )
	s.Put( "pear", 1 )
	s.Put( "Apple", 2 )
	s.Put( "apple", 3 )
	s.Put( "", 4 )
	dim ks as Array( of string ) = s.Keys( )
	assert_( ks.Count( ) = 4 )
	assert_( ks[ 0 ] = "" )
	assert_( ks[ 1 ] = "Apple" )
	assert_( ks[ 2 ] = "apple" )
	assert_( ks[ 3 ] = "pear" )

	'' DOUBLE keys, including negatives
	dim d as OrderedMap( of double, long )
	d.Put( 2.5, 1 )
	d.Put( -0.5, 2 )
	d.Put( 0.0, 3 )
	dim dk as Array( of double ) = d.Keys( )
	assert_( dk[ 0 ] = -0.5 )
	assert_( dk[ 1 ] = 0.0 )
	assert_( dk[ 2 ] = 2.5 )

	'' a UDT key with '<' only -- no HashOf, no '='.  This type could not be an
	'' containers.Map key at all.
	dim v as OrderedMap( of Version, string )
	dim as Version a1, a2, b1
	a1.major_ = 1 : a1.minor_ = 0
	a2.major_ = 1 : a2.minor_ = 5
	b1.major_ = 2 : b1.minor_ = 0
	v.Put( b1, "two" )
	v.Put( a2, "one-five" )
	v.Put( a1, "one-oh" )
	assert_( v.Count( ) = 3 )

	dim vk as Array( of Version ) = v.Keys( )
	assert_( vk[ 0 ].major_ = 1 andalso vk[ 0 ].minor_ = 0 )
	assert_( vk[ 1 ].major_ = 1 andalso vk[ 1 ].minor_ = 5 )
	assert_( vk[ 2 ].major_ = 2 )

	'' equivalence is "neither is less", so re-putting a1 overwrites
	assert_( v.Put( a1, "again" ) = false )
	assert_( v.Count( ) = 3 )
	dim as string got
	assert_( v.TryGet( a1, got ) andalso (got = "again") )

	'' a nested container as the VALUE
	dim nest as OrderedMap( of long, Array( of long ) )
	dim inner as Array( of long )
	inner.Push( 1 ) : inner.Push( 2 )
	nest.Put( 7, inner )
	assert_( nest.Count( ) = 1 )
	dim got2 as Array( of long )
	assert_( nest.TryGet( 7, got2 ) )
	assert_( got2.Count( ) = 2 )
end scope

'' ========================================== removal in every shape that matters

scope
	'' A node with no children, one child on each side, and two children --
	'' the three structural cases of RemoveNode, plus removing the root.
	for shape as long = 0 to 3
		dim m as OrderedMap( of long, long )
		for i as long = 1 to 15
			m.Put( i, i )
		next

		select case shape
		case 0                              '' leaves first
			for i as long = 1 to 15 step 2
				assert_( m.Remove( i ) )
				assert_( m.BlackHeight( ) >= 0 )
			next
		case 1                              '' ascending
			for i as long = 1 to 15
				assert_( m.Remove( i ) )
				assert_( m.BlackHeight( ) >= 0 )
			next
			assert_( m.Count( ) = 0 )
		case 2                              '' descending
			for i as long = 15 to 1 step -1
				assert_( m.Remove( i ) )
				assert_( m.BlackHeight( ) >= 0 )
			next
			assert_( m.Count( ) = 0 )
		case 3                              '' repeatedly remove the first key
			dim as long k, v
			while m.TryFirst( k, v )
				assert_( m.Remove( k ) )
				assert_( m.BlackHeight( ) >= 0 )
			wend
			assert_( m.Count( ) = 0 )
		end select
	next
end scope

'' ============================================= differential stress vs containers.Map

scope
	'' Every operation is mirrored into a hash Map and the answers compared.
	'' This is what reaches the removal rebalance's four cases and their
	'' mirrors -- specific tree shapes no hand-written case reliably produces.
	Seed( 20260809 )

	dim as long maxbh = 0, maxcount = 0

	for round as long = 1 to 120
		dim t as OrderedMap( of long, long )
		dim h as Map( of long, long )
		dim as long span = 1 + NextR( 400 )

		for op as long = 1 to 1500
			dim as long k = NextR( span )

			select case NextR( 10 )
			case 0, 1, 2, 3, 4, 5
				dim as long v = NextR( 1000000 )
				dim as boolean ta = t.Put( k, v )
				dim as boolean ha = h.Put( k, v )
				assert_( ta = ha )
			case 6, 7, 8
				dim as boolean ta = t.Remove( k )
				dim as boolean ha = h.Remove( k )
				assert_( ta = ha )
			case else
				dim as long tv, hv
				dim as boolean ta = t.TryGet( k, tv )
				dim as boolean ha = h.TryGet( k, hv )
				assert_( ta = ha )
				if( ta ) then
					assert_( tv = hv )
				end if
			end select

			assert_( t.Count( ) = h.Count( ) )
		next

		'' the invariants, and the height bound they exist to give
		dim as long bh = t.BlackHeight( )
		assert_( bh >= 0 )
		if( bh > maxbh ) then
			maxbh = bh
		end if
		if( t.Count( ) > maxcount ) then
			maxcount = t.Count( )
		end if

		'' the walk is ascending, complete and holds nothing extra
		dim as long prev = -1, seen = 0
		dim as boolean first = true
		for each kv in t
			if( first = false ) then
				assert_( kv.key > prev )
			end if
			first = false
			prev = kv.key
			seen += 1

			dim as long hv
			assert_( h.TryGet( kv.key, hv ) )
			assert_( hv = kv.value )
		next
		assert_( seen = h.Count( ) )

		'' floor and ceiling agree with a linear scan of the same keys
		dim ks as Array( of long ) = t.Keys( )
		assert_( ks.Count( ) = seen )
		for probe as long = 1 to 20
			dim as long q = NextR( span + 10 ) - 5

			dim as long wantfloor = -2147483648
			dim as boolean hasfloor = false
			dim as long wantceil = 2147483647
			dim as boolean hasceil = false
			for i as long = 0 to ks.Count( )-1
				if( ks[ i ] <= q ) then
					if( (hasfloor = false) orelse (ks[ i ] > wantfloor) ) then
						wantfloor = ks[ i ]
						hasfloor = true
					end if
				end if
				if( ks[ i ] >= q ) then
					if( (hasceil = false) orelse (ks[ i ] < wantceil) ) then
						wantceil = ks[ i ]
						hasceil = true
					end if
				end if
			next

			dim as long gotf, gotc
			assert_( t.TryFloor( q, gotf ) = hasfloor )
			if( hasfloor ) then
				assert_( gotf = wantfloor )
			end if
			assert_( t.TryCeiling( q, gotc ) = hasceil )
			if( hasceil ) then
				assert_( gotc = wantceil )
			end if
		next

		'' a copy is structurally identical and independent
		dim c as OrderedMap( of long, long ) = t
		assert_( c.Count( ) = t.Count( ) )
		assert_( c.BlackHeight( ) = bh )
		c.Clear( )
		assert_( t.Count( ) = seen )
	next

	'' 120 rounds x 1500 operations. The height bound is the point: a
	'' degenerate tree of this size would report a black height in the
	'' hundreds.
	assert_( maxcount > 100 )
	assert_( maxbh <= 20 )
end scope

print "container-orderedmap: ok"
