' TEST_MODE : COMPILE_AND_RUN_OK

'' containers.OrderedSet( of T ) -- exhaustive.
''
'' Every declared member, every state, deep copy and assignment independence in
'' both directions, destructor balance, four element types, both FOR EACH
'' binding forms, and the three set-algebra operations including the
'' self-argument cases that would otherwise walk a tree while mutating it.
''
'' As in container-orderedmap.bas, the RED-BLACK INVARIANTS are asserted after
'' every destructive phase: a tree that has lost its balance still answers
'' correctly and still iterates in order, so nothing else can see the failure.
'' The removal rebalance is reached by a differential stress against containers.Set.
#import "std/containers"
using containers
#define assert_(e) if (e) = 0 then fb_Assert(__FILE__, __LINE__, __FUNCTION__, #e)

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

operator < ( byref a as Counted, byref b as Counted ) as boolean
	return a.v < b.v
end operator

'' An element with '<' and no hash and no '=' -- impossible as an containers.Set
'' element, fine here.
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
	dim s as OrderedSet( of long )

	assert_( s.Count( ) = 0 )
	assert_( s.IsEmpty( ) )
	assert_( s.Contains( 1 ) = false )
	assert_( s.Remove( 1 ) = false )
	assert_( s.BlackHeight( ) >= 0 )
	assert_( s.Items( ).Count( ) = 0 )

	dim as long r
	assert_( s.TryFirst( r ) = false )
	assert_( s.TryLast( r ) = false )
	assert_( s.TryFloor( 5, r ) = false )
	assert_( s.TryCeiling( 5, r ) = false )

	dim as long walked = 0
	for each x in s
		walked += 1
	next
	assert_( walked = 0 )

	s.Clear( )
	assert_( s.Count( ) = 0 )
end scope

'' ================================================================ Add semantics

scope
	dim s as OrderedSet( of long )

	assert_( s.Add( 42 ) )                       '' TRUE: new
	assert_( s.Add( 42 ) = false )               '' FALSE: already there
	assert_( s.Count( ) = 1 )
	assert_( s.Contains( 42 ) )
	assert_( s.BlackHeight( ) >= 0 )

	assert_( s.Remove( 42 ) )
	assert_( s.Remove( 42 ) = false )
	assert_( s.Count( ) = 0 )
	assert_( s.IsEmpty( ) )
end scope

'' ======================================================== order and the walk

scope
	dim s as OrderedSet( of long )
	dim as long ins( 0 to 11 ) = { 50, 10, 90, 30, 70, 20, 80, 40, 60, 5, 95, 55 }
	for i as long = 0 to 11
		assert_( s.Add( ins( i ) ) )
	next
	assert_( s.Count( ) = 12 )
	assert_( s.BlackHeight( ) >= 0 )

	dim as long prev = -1, n = 0
	for each x in s
		assert_( x > prev )
		prev = x
		n += 1
	next
	assert_( n = 12 )

	'' the byref binding form compiles and reads the same values
	prev = -1
	n = 0
	for each byref x in s
		assert_( x > prev )
		prev = x
		n += 1
	next
	assert_( n = 12 )

	'' Items( ) is the same walk, and unlike containers.Set.Items( ) it is sorted
	dim it as Array( of long ) = s.Items( )
	assert_( it.Count( ) = 12 )
	assert_( it[ 0 ] = 5 )
	assert_( it[ 11 ] = 95 )
	for i as long = 1 to 11
		assert_( it[ i ] > it[ i-1 ] )
	next

	'' sorted and reverse-sorted input, the cases a naive BST degenerates on
	dim asc_ as OrderedSet( of long )
	for i as long = 0 to 999
		asc_.Add( i )
	next
	assert_( asc_.Count( ) = 1000 )
	assert_( asc_.BlackHeight( ) >= 0 )
	assert_( asc_.BlackHeight( ) <= 20 )

	dim desc as OrderedSet( of long )
	for i as long = 999 to 0 step -1
		desc.Add( i )
	next
	assert_( desc.Count( ) = 1000 )
	assert_( desc.BlackHeight( ) <= 20 )

	dim as long r
	assert_( desc.TryFirst( r ) andalso (r = 0) )
	assert_( desc.TryLast( r ) andalso (r = 999) )
end scope

'' ==================================================== floor and ceiling

scope
	dim s as OrderedSet( of long )
	for i as long = 1 to 5
		s.Add( i * 10 )
	next

	dim as long r
	assert_( s.TryFloor( 30, r ) andalso (r = 30) )
	assert_( s.TryCeiling( 30, r ) andalso (r = 30) )
	assert_( s.TryFloor( 35, r ) andalso (r = 30) )
	assert_( s.TryCeiling( 35, r ) andalso (r = 40) )
	assert_( s.TryFloor( 9, r ) = false )
	assert_( s.TryCeiling( 51, r ) = false )
	assert_( s.TryFloor( 1000, r ) andalso (r = 50) )
	assert_( s.TryCeiling( -1000, r ) andalso (r = 10) )

	r = -777
	assert_( s.TryCeiling( 51, r ) = false )
	assert_( r = -777 )
end scope

'' ============================================================== set algebra

scope
	'' a = {1..6}, b = {4..9}
	dim a as OrderedSet( of long )
	dim b as OrderedSet( of long )
	for i as long = 1 to 6
		a.Add( i )
	next
	for i as long = 4 to 9
		b.Add( i )
	next

	dim u as OrderedSet( of long ) = a
	u.UnionWith( b )
	assert_( u.Count( ) = 9 )
	assert_( u.BlackHeight( ) >= 0 )
	dim ui as Array( of long ) = u.Items( )
	for i as long = 0 to 8
		assert_( ui[ i ] = i + 1 )               '' still sorted afterwards
	next

	dim n as OrderedSet( of long ) = a
	n.IntersectWith( b )
	assert_( n.Count( ) = 3 )
	assert_( n.BlackHeight( ) >= 0 )
	dim ni as Array( of long ) = n.Items( )
	assert_( ni[ 0 ] = 4 andalso ni[ 1 ] = 5 andalso ni[ 2 ] = 6 )

	dim e as OrderedSet( of long ) = a
	e.ExceptWith( b )
	assert_( e.Count( ) = 3 )
	assert_( e.BlackHeight( ) >= 0 )
	dim ei as Array( of long ) = e.Items( )
	assert_( ei[ 0 ] = 1 andalso ei[ 1 ] = 2 andalso ei[ 2 ] = 3 )

	'' the operand is not disturbed
	assert_( b.Count( ) = 6 )

	'' against an EMPTY set
	dim z as OrderedSet( of long )
	dim t1 as OrderedSet( of long ) = a
	t1.UnionWith( z )
	assert_( t1.Count( ) = 6 )
	dim t2 as OrderedSet( of long ) = a
	t2.IntersectWith( z )
	assert_( t2.Count( ) = 0 )
	assert_( t2.BlackHeight( ) >= 0 )
	dim t3 as OrderedSet( of long ) = a
	t3.ExceptWith( z )
	assert_( t3.Count( ) = 6 )

	'' and an empty set as the RECEIVER
	dim t4 as OrderedSet( of long )
	t4.UnionWith( a )
	assert_( t4.Count( ) = 6 )
	dim t5 as OrderedSet( of long )
	t5.IntersectWith( a )
	assert_( t5.Count( ) = 0 )
	dim t6 as OrderedSet( of long )
	t6.ExceptWith( a )
	assert_( t6.Count( ) = 0 )

	'' disjoint sets
	dim d1 as OrderedSet( of long )
	d1.Add( 100 ) : d1.Add( 200 )
	dim t7 as OrderedSet( of long ) = a
	t7.IntersectWith( d1 )
	assert_( t7.Count( ) = 0 )

	'' SELF as the argument: each of these would otherwise walk a tree while
	'' inserting into or removing from it
	dim s1 as OrderedSet( of long ) = a
	s1.UnionWith( s1 )
	assert_( s1.Count( ) = 6 )
	assert_( s1.BlackHeight( ) >= 0 )

	dim s2 as OrderedSet( of long ) = a
	s2.IntersectWith( s2 )
	assert_( s2.Count( ) = 6 )
	assert_( s2.BlackHeight( ) >= 0 )

	dim s3 as OrderedSet( of long ) = a
	s3.ExceptWith( s3 )
	assert_( s3.Count( ) = 0 )
	assert_( s3.BlackHeight( ) >= 0 )
end scope

'' ============================================ copy, assignment, destruction

scope
	dim a as OrderedSet( of string )
	for i as long = 0 to 49
		a.Add( "v" + str( i ) )
	next

	dim b as OrderedSet( of string ) = a
	assert_( b.Count( ) = 50 )
	assert_( b.BlackHeight( ) = a.BlackHeight( ) )

	b.Remove( "v10" )
	b.Add( "zzz" )
	assert_( a.Count( ) = 50 )
	assert_( a.Contains( "v10" ) )
	assert_( a.Contains( "zzz" ) = false )

	a.Add( "yyy" )
	assert_( b.Contains( "yyy" ) = false )

	dim c as OrderedSet( of string )
	c.Add( "doomed" )
	c = a
	assert_( c.Contains( "doomed" ) = false )
	assert_( c.Count( ) = a.Count( ) )

	dim as long before = a.Count( )
	a = a                                        '' self-assignment
	assert_( a.Count( ) = before )
	assert_( a.BlackHeight( ) >= 0 )

	dim empty_ as OrderedSet( of string )
	a = empty_
	assert_( a.Count( ) = 0 )
end scope

scope
	liveCounted = 0

	scope
		dim s as OrderedSet( of Counted )
		for i as long = 0 to 199
			s.Add( Counted( i ) )
		next
		assert_( s.Count( ) = 200 )

		dim copy_ as OrderedSet( of Counted ) = s
		assert_( copy_.Count( ) = 200 )
		copy_.Clear( )

		for i as long = 0 to 199 step 2
			assert_( s.Remove( Counted( i ) ) )
		next
		assert_( s.Count( ) = 100 )
		assert_( s.BlackHeight( ) >= 0 )
	end scope

	assert_( liveCounted = 0 )
end scope

'' ============================================= element types other than LONG

scope
	dim s as OrderedSet( of string )
	s.Add( "pear" ) : s.Add( "Apple" ) : s.Add( "apple" ) : s.Add( "" )
	dim it as Array( of string ) = s.Items( )
	assert_( it.Count( ) = 4 )
	assert_( it[ 0 ] = "" )
	assert_( it[ 1 ] = "Apple" )
	assert_( it[ 2 ] = "apple" )
	assert_( it[ 3 ] = "pear" )

	dim d as OrderedSet( of double )
	d.Add( 2.5 ) : d.Add( -0.5 ) : d.Add( 0.0 ) : d.Add( 2.5 )
	assert_( d.Count( ) = 3 )
	dim di as Array( of double ) = d.Items( )
	assert_( di[ 0 ] = -0.5 andalso di[ 1 ] = 0.0 andalso di[ 2 ] = 2.5 )

	dim v as OrderedSet( of Version )
	dim as Version a1, a2, b1
	a1.major_ = 1 : a1.minor_ = 0
	a2.major_ = 1 : a2.minor_ = 5
	b1.major_ = 2 : b1.minor_ = 0
	v.Add( b1 ) : v.Add( a2 ) : v.Add( a1 )
	assert_( v.Count( ) = 3 )
	assert_( v.Add( a1 ) = false )               '' equivalence is "neither less"
	dim vi as Array( of Version ) = v.Items( )
	assert_( vi[ 0 ].major_ = 1 andalso vi[ 0 ].minor_ = 0 )
	assert_( vi[ 2 ].major_ = 2 )
end scope

'' ========================================== removal in every shape that matters

scope
	for shape as long = 0 to 3
		dim s as OrderedSet( of long )
		for i as long = 1 to 15
			s.Add( i )
		next

		select case shape
		case 0
			for i as long = 1 to 15 step 2
				assert_( s.Remove( i ) )
				assert_( s.BlackHeight( ) >= 0 )
			next
		case 1
			for i as long = 1 to 15
				assert_( s.Remove( i ) )
				assert_( s.BlackHeight( ) >= 0 )
			next
			assert_( s.Count( ) = 0 )
		case 2
			for i as long = 15 to 1 step -1
				assert_( s.Remove( i ) )
				assert_( s.BlackHeight( ) >= 0 )
			next
			assert_( s.Count( ) = 0 )
		case 3
			dim as long k
			while s.TryFirst( k )
				assert_( s.Remove( k ) )
				assert_( s.BlackHeight( ) >= 0 )
			wend
			assert_( s.Count( ) = 0 )
		end select
	next
end scope

'' ============================================= differential stress vs containers.Set

scope
	Seed( 987654321 )

	dim as long maxbh = 0, maxcount = 0

	for round as long = 1 to 120
		dim t as OrderedSet( of long )
		dim h as Set( of long )
		dim as long span = 1 + NextR( 300 )

		for op as long = 1 to 1500
			dim as long k = NextR( span )

			select case NextR( 10 )
			case 0, 1, 2, 3, 4, 5
				assert_( t.Add( k ) = h.Add( k ) )
			case 6, 7, 8
				assert_( t.Remove( k ) = h.Remove( k ) )
			case else
				assert_( t.Contains( k ) = h.Contains( k ) )
			end select

			assert_( t.Count( ) = h.Count( ) )
		next

		dim as long bh = t.BlackHeight( )
		assert_( bh >= 0 )
		if( bh > maxbh ) then
			maxbh = bh
		end if
		if( t.Count( ) > maxcount ) then
			maxcount = t.Count( )
		end if

		dim as long prev = -1, seen = 0
		dim as boolean first = true
		for each x in t
			if( first = false ) then
				assert_( x > prev )
			end if
			first = false
			prev = x
			seen += 1
			assert_( h.Contains( x ) )
		next
		assert_( seen = h.Count( ) )

		dim its as Array( of long ) = t.Items( )
		assert_( its.Count( ) = seen )

		'' floor and ceiling against a linear scan
		for probe as long = 1 to 20
			dim as long q = NextR( span + 10 ) - 5

			dim as long wf = 0, wc = 0
			dim as boolean hf = false, hc = false
			for i as long = 0 to its.Count( )-1
				if( its[ i ] <= q ) then
					if( (hf = false) orelse (its[ i ] > wf) ) then
						wf = its[ i ] : hf = true
					end if
				end if
				if( its[ i ] >= q ) then
					if( (hc = false) orelse (its[ i ] < wc) ) then
						wc = its[ i ] : hc = true
					end if
				end if
			next

			dim as long gf, gc
			assert_( t.TryFloor( q, gf ) = hf )
			if( hf ) then
				assert_( gf = wf )
			end if
			assert_( t.TryCeiling( q, gc ) = hc )
			if( hc ) then
				assert_( gc = wc )
			end if
		next

		'' set algebra against the hash set, on the same contents
		dim other as OrderedSet( of long )
		dim hother as Set( of long )
		for i as long = 1 to 60
			dim as long x = NextR( span )
			other.Add( x )
			hother.Add( x )
		next

		dim ta as OrderedSet( of long ) = t
		dim ha as Set( of long ) = h
		select case NextR( 3 )
		case 0
			ta.UnionWith( other )     : ha.UnionWith( hother )
		case 1
			ta.IntersectWith( other ) : ha.IntersectWith( hother )
		case else
			ta.ExceptWith( other )    : ha.ExceptWith( hother )
		end select

		assert_( ta.Count( ) = ha.Count( ) )
		assert_( ta.BlackHeight( ) >= 0 )
		for each x in ta
			assert_( ha.Contains( x ) )
		next

		'' the copy is structurally identical and independent
		dim c as OrderedSet( of long ) = t
		assert_( c.BlackHeight( ) = bh )
		c.Clear( )
		assert_( t.Count( ) = seen )
	next

	assert_( maxcount > 100 )
	assert_( maxbh <= 20 )
end scope

print "container-orderedset: ok"
