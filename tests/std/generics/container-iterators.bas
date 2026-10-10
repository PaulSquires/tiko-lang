' TEST_MODE : COMPILE_AND_RUN_OK

'' The container ITERATOR TYPES, named and driven by hand.
''
'' Every container suite next to this one iterates with FOR EACH, which is the
'' spelling ordinary code should use -- and which means none of them ever names
'' the iterator type. That leaves a real gap: a container whose GetIterator( )
'' returned the wrong type, or whose iterator broke the RFC-0002 protocol in a
'' way the FOR EACH lowering happens to tolerate, would pass every one of them.
''
'' So this file DECLARES each iterator by name and drives IsValid / Value /
'' MoveNext directly:
''
''     ArrayIterator          SetIterator            MapIterator
''     LinkedListIterator     OrderedSetIterator     OrderedMapIterator
''     MapPairIter / MapPairView
''     OrderedMapPairIter / OrderedMapPairView
''
'' and asserts, for each, that the hand-driven walk agrees element for element
'' with the FOR EACH over the same container, and that ONE STEP PAST THE END
'' leaves the iterator invalid rather than crashing -- which is where the
'' node-based containers used to dereference a null node.
''
'' THE PAIR VIEWS are a second view over the same slots, yielding a (TK, TV)
'' TUPLE rather than a KeyValuePair, so that 'for each (k, v) in m.Pairs( )'
'' has something to destructure. They are views rather than a change to
'' MapIterator.Value( ) because FreeBASIC cannot overload on the return type
'' alone.
#import "std/containers"
using containers
#define assert_(e) if (e) = 0 then fb_Assert(__FILE__, __LINE__, __FUNCTION__, #e)

'' ---------------------------------------------------------------- Array

scope
	dim a as Array( of long )
	for i as long = 1 to 6
		a.Push( i * 3 )
	next

	dim it as ArrayIterator( of long ) = a.GetIterator( )
	dim as long n = 0, sum = 0
	while it.IsValid( )
		'' Array's order IS specified, so position can be asserted too
		assert_( it.Value( ) = ( n + 1 ) * 3 )
		n += 1
		sum += it.Value( )
		it.MoveNext( )
	wend
	assert_( n = 6 )
	assert_( sum = 3 + 6 + 9 + 12 + 15 + 18 )

	'' exhausted stays exhausted
	it.MoveNext( )
	assert_( it.IsValid( ) = FALSE )

	'' Value( ) is BYREF, so the iterator writes through to the container
	dim w as ArrayIterator( of long ) = a.GetIterator( )
	while w.IsValid( )
		w.Value( ) += 1
		w.MoveNext( )
	wend
	assert_( a[0] = 4 )
	assert_( a[5] = 19 )

	'' and FOR EACH agrees with the hand-driven walk
	dim as long m = 0, msum = 0
	for each x in a
		m += 1
		msum += x
	next
	assert_( m = 6 )
	assert_( msum = sum + 6 )

	'' an EMPTY container yields an iterator that is invalid from the start --
	'' not one that has to be stepped once before it admits it
	dim e as Array( of long )
	dim eit as ArrayIterator( of long ) = e.GetIterator( )
	assert_( eit.IsValid( ) = FALSE )
end scope

'' ------------------------------------------------------------------ Set

scope
	dim s as Set( of long )
	for i as long = 1 to 20
		s.Add( i )
	next
	s.Remove( 7 )                       '' leave a tombstone in the probe path

	dim it as SetIterator( of long ) = s.GetIterator( )
	dim as long n = 0, sum = 0
	while it.IsValid( )
		n += 1
		sum += it.Value( )
		it.MoveNext( )
	wend

	'' the ORDER is unspecified, so only the multiset of values is asserted
	assert_( n = 19 )
	assert_( sum = ( 20 * 21 \ 2 ) - 7 )
	assert_( n = s.Count( ) )

	it.MoveNext( )
	assert_( it.IsValid( ) = FALSE )

	dim as long m = 0, msum = 0
	for each x in s
		m += 1
		msum += x
	next
	assert_( m = n )
	assert_( msum = sum )

	dim e as Set( of long )
	dim eit as SetIterator( of long ) = e.GetIterator( )
	assert_( eit.IsValid( ) = FALSE )

	'' a set emptied by REMOVAL is all tombstones, and must still iterate to
	'' nothing rather than yielding the dead slots
	dim t as Set( of long )
	t.Add( 1 ) : t.Add( 2 )
	t.Remove( 1 ) : t.Remove( 2 )
	dim tit as SetIterator( of long ) = t.GetIterator( )
	assert_( tit.IsValid( ) = FALSE )
end scope

'' ------------------------------------------------------------------ Map

scope
	dim m as Map( of long, long )
	for i as long = 1 to 20
		m[i] = i * 100
	next
	m.Remove( 7 )

	dim it as MapIterator( of long, long ) = m.GetIterator( )
	dim as long n = 0, ksum = 0, vsum = 0
	while it.IsValid( )
		'' Value( ) is a KeyValuePair, which is the form that NAMES its halves
		dim kv as KeyValuePair( of long, long ) = it.Value( )
		assert_( kv.value = kv.key * 100 )
		n += 1
		ksum += kv.key
		vsum += kv.value
		it.MoveNext( )
	wend

	assert_( n = 19 )
	assert_( n = m.Count( ) )
	assert_( ksum = ( 20 * 21 \ 2 ) - 7 )
	assert_( vsum = ksum * 100 )

	it.MoveNext( )
	assert_( it.IsValid( ) = FALSE )

	'' the PAIR VIEW is a second walk over the same slots, yielding a tuple
	dim pv as MapPairView( of long, long ) = m.Pairs( )
	dim pit as MapPairIter( of long, long ) = pv.GetIterator( )
	dim as long pn = 0, pksum = 0, pvsum = 0
	while pit.IsValid( )
		dim t as (long, long) = pit.Value( )
		pn += 1
		pksum += t._1
		pvsum += t._2
		pit.MoveNext( )
	wend

	'' it must agree with the KeyValuePair walk, entry for entry
	assert_( pn = n )
	assert_( pksum = ksum )
	assert_( pvsum = vsum )

	pit.MoveNext( )
	assert_( pit.IsValid( ) = FALSE )

	'' and that is what makes the destructuring FOR EACH work
	dim as long dn = 0, dksum = 0, dvsum = 0
	for each (k, v) in m.Pairs( )
		dn += 1
		dksum += k
		dvsum += v
	next
	assert_( dn = n )
	assert_( dksum = ksum )
	assert_( dvsum = vsum )

	dim e as Map( of long, long )
	dim eit as MapIterator( of long, long ) = e.GetIterator( )
	assert_( eit.IsValid( ) = FALSE )
	dim epit as MapPairIter( of long, long ) = e.Pairs( ).GetIterator( )
	assert_( epit.IsValid( ) = FALSE )
end scope

'' ----------------------------------------------------------- LinkedList

scope
	dim l as LinkedList( of long )
	for i as long = 1 to 5
		l.PushBack( i * 2 )
	next

	dim it as LinkedListIterator( of long ) = l.GetIterator( )
	dim as long n = 0
	while it.IsValid( )
		'' a list's order IS specified: insertion order, front to back
		assert_( it.Value( ) = ( n + 1 ) * 2 )
		n += 1
		it.MoveNext( )
	wend
	assert_( n = 5 )

	'' exhausted stays exhausted -- guaranteed for the NODE-BASED containers
	'' too since the null guard landed in MoveNext; before it, one step past
	'' the end here was a segfault rather than a false
	it.MoveNext( )
	assert_( it.IsValid( ) = FALSE )

	'' Value( ) is BYREF here too
	dim w as LinkedListIterator( of long ) = l.GetIterator( )
	while w.IsValid( )
		w.Value( ) *= 10
		w.MoveNext( )
	wend
	assert_( l.Front( ) = 20 )
	assert_( l.Back( ) = 100 )

	dim as long m = 0, msum = 0
	for each x in l
		m += 1
		msum += x
	next
	assert_( m = 5 )
	assert_( msum = 20 + 40 + 60 + 80 + 100 )

	dim e as LinkedList( of long )
	dim eit as LinkedListIterator( of long ) = e.GetIterator( )
	assert_( eit.IsValid( ) = FALSE )
end scope

'' ----------------------------------------------------------- OrderedSet

scope
	dim s as OrderedSet( of long )
	dim as long ins( 0 to 8 ) = { 50, 10, 90, 30, 70, 20, 80, 40, 60 }
	for i as long = lbound( ins ) to ubound( ins )
		s.Add( ins( i ) )
	next

	dim it as OrderedSetIterator( of long ) = s.GetIterator( )
	dim as long n = 0, prev = -1
	while it.IsValid( )
		'' the ORDER IS THE POINT: strictly ascending, whatever the insertion
		'' order was
		assert_( it.Value( ) > prev )
		prev = it.Value( )
		n += 1
		it.MoveNext( )
	wend
	assert_( n = 9 )
	assert_( prev = 90 )

	'' exhausted stays exhausted -- guaranteed for the NODE-BASED containers
	'' too since the null guard landed in MoveNext; before it, one step past
	'' the end here was a segfault rather than a false
	it.MoveNext( )
	assert_( it.IsValid( ) = FALSE )

	dim as long m = 0, mprev = -1
	for each x in s
		assert_( x > mprev )
		mprev = x
		m += 1
	next
	assert_( m = n )
	assert_( mprev = prev )

	dim e as OrderedSet( of long )
	dim eit as OrderedSetIterator( of long ) = e.GetIterator( )
	assert_( eit.IsValid( ) = FALSE )
end scope

'' ----------------------------------------------------------- OrderedMap

scope
	dim m as OrderedMap( of long, long )
	dim as long ins( 0 to 8 ) = { 5, 1, 9, 3, 7, 2, 8, 4, 6 }
	for i as long = lbound( ins ) to ubound( ins )
		m[ ins( i ) ] = ins( i ) * 100
	next

	dim it as OrderedMapIterator( of long, long ) = m.GetIterator( )
	dim as long n = 0, prev = -1, ksum = 0
	while it.IsValid( )
		dim p as OrderedPair( of long, long ) = it.Value( )
		assert_( p.key > prev )                  '' ascending by key
		assert_( p.value = p.key * 100 )
		prev = p.key
		ksum += p.key
		n += 1
		it.MoveNext( )
	wend
	assert_( n = 9 )
	assert_( prev = 9 )
	assert_( ksum = 45 )

	'' exhausted stays exhausted -- guaranteed for the NODE-BASED containers
	'' too since the null guard landed in MoveNext; before it, one step past
	'' the end here was a segfault rather than a false
	it.MoveNext( )
	assert_( it.IsValid( ) = FALSE )

	'' the pair view walks the same tree in the same order, as a tuple
	dim pv as OrderedMapPairView( of long, long ) = m.Pairs( )
	dim pit as OrderedMapPairIter( of long, long ) = pv.GetIterator( )
	dim as long pn = 0, pprev = -1, pksum = 0
	while pit.IsValid( )
		dim t as (long, long) = pit.Value( )
		assert_( t._1 > pprev )
		assert_( t._2 = t._1 * 100 )
		pprev = t._1
		pksum += t._1
		pn += 1
		pit.MoveNext( )
	wend
	assert_( pn = n )
	assert_( pprev = prev )
	assert_( pksum = ksum )

	pit.MoveNext( )
	assert_( pit.IsValid( ) = FALSE )

	dim as long dn = 0, dprev = -1
	for each (k, v) in m.Pairs( )
		assert_( k > dprev )
		assert_( v = k * 100 )
		dprev = k
		dn += 1
	next
	assert_( dn = n )

	dim e as OrderedMap( of long, long )
	dim eit as OrderedMapIterator( of long, long ) = e.GetIterator( )
	assert_( eit.IsValid( ) = FALSE )
	dim epit as OrderedMapPairIter( of long, long ) = e.Pairs( ).GetIterator( )
	assert_( epit.IsValid( ) = FALSE )
end scope

print "container-iterators: ok"
