' TEST_MODE : COMPILE_AND_RUN_OK

'' memory.SharedPtr( of T ) and memory.WeakPtr( of T ) -- exhaustive.
''
'' Every declared member of both types, both free constructors, SpCast, both
'' global operators, every transition between null and non-null in both
'' directions, destructor balance under scope exit / reassignment / early return
'' / container growth, and the cycle that WeakPtr exists to break.
''
'' A standard library is the one place a gap is expensive: once this is in the
'' distribution every program depends on it, and a member that was never
'' exercised is a bug shipped to everyone.
''
'' NOT here, because each aborts the process and cannot share a binary:
''   - Ref( ) on a null SharedPtr        -> sharedptr-null-ref.bas
''   - 'sp->' where T is not a UDT       -> fail-sharedptr-scalar-arrow.bas
''
'' NOT here, because log-tests do not build with -mt: the atomic side of the
'' __FB_MT__ gate.  This file therefore exercises the PLAIN counter path.  The
'' atomic path is tests/threads/sharedptr-mt.bas.
#import "std/memory"
#include once "fb/array.bi"
#include once "fb/map.bi"
#include once "fberror.bi"
#include once "fbatomic.bi"
using memory
using FB
#define assert_(e) if (e) = 0 then fb_Assert(__FILE__, __LINE__, __FUNCTION__, #e)

'' ---------------------------------------------------------------- fixtures

'' Counts its own construction and destruction, which is how every ownership
'' claim below is actually checked: a refcount that is right but destroys twice,
'' or never, shows up here and nowhere else.
dim shared as long liveProbe, madeProbe

type Probe
	as long v
	declare constructor( )
	declare constructor( byval x as long )
	declare constructor( byref rhs as Probe )
	declare destructor( )
end type

constructor Probe( )
	this.v = 0
	liveProbe += 1 : madeProbe += 1
end constructor

constructor Probe( byval x as long )
	this.v = x
	liveProbe += 1 : madeProbe += 1
end constructor

constructor Probe( byref rhs as Probe )
	this.v = rhs.v
	liveProbe += 1 : madeProbe += 1
end constructor

destructor Probe( )
	liveProbe -= 1
end destructor

'' A base with a VIRTUAL destructor and a derived, for SpCast.  Without the
'' virtual the cast would still compile and would silently run the wrong
'' destructor -- which is exactly why the count is checked afterwards.
dim shared as long liveShape

type Shape extends object
	as long tag
	declare constructor( )
	declare virtual destructor( )
	declare virtual function Area( ) as long
end type

constructor Shape( )
	this.tag = 1
	liveShape += 1
end constructor

virtual destructor Shape( )
	liveShape -= 1
end destructor

virtual function Shape.Area( ) as long
	return 0
end function

type Circle extends Shape
	as long r
	declare constructor( )
	declare destructor( ) override
	declare function Area( ) as long override
end type

constructor Circle( )
	this.tag = 2
	this.r = 3
end constructor

destructor Circle( )
	'' Shape's destructor runs after this one and does the decrement
end destructor

function Circle.Area( ) as long
	return this.r * this.r
end function

'' For the cycle section.  Parent holds its children strongly; a child points
'' back at its parent WEAKLY, which is the whole point.
type Node_
	as long id
	as Array( of SharedPtr( of Node_ ) ) kids
	as WeakPtr( of Node_ ) parent
	declare constructor( )
	declare destructor( )
end type

dim shared as long liveNode

constructor Node_( )
	this.id = 0
	liveNode += 1
end constructor

destructor Node_( )
	liveNode -= 1
end destructor

'' A type with NO default constructor, to pin that SharedPtr itself never
'' requires one -- only MakeShared does, and only where it is called.
type NoDefault
	as long v
	declare constructor( byval x as long )
end type

constructor NoDefault( byval x as long )
	this.v = x
end constructor

'' Used by the early-return section.
function EarlyReturn( byval takeIt as boolean ) as long
	dim as SharedPtr( of Probe ) p = MakeShared( of Probe )( )
	p->v = 77
	if( takeIt = FALSE ) then
		'' leaves scope without reaching the end -- the destructor still runs
		return 0
	end if
	return p->v
end function

'' Used by the return-by-value section.
function MakeAt( byval x as long ) as SharedPtr( of Probe )
	dim as SharedPtr( of Probe ) p = MakeShared( of Probe )( )
	p->v = x
	return p
end function

	''=====================================================================
	'' construction and the null state
	''=====================================================================

	scope
		'' default-constructed is null, and every query is defined on it
		dim as SharedPtr( of Probe ) n
		assert_( n.IsNull( ) = TRUE )
		assert_( n.Get( ) = 0 )
		assert_( n.UseCount( ) = 0 )

		'' Reset on a null handle is a no-op, not a crash
		n.Reset( )
		assert_( n.IsNull( ) = TRUE )

		'' copying a null handle yields a null handle
		dim as SharedPtr( of Probe ) n2 = n
		assert_( n2.IsNull( ) = TRUE )
		assert_( n2.UseCount( ) = 0 )

		'' assigning null over null
		n2 = n
		assert_( n2.IsNull( ) = TRUE )
	end scope

	assert_( liveProbe = 0 )

	''=====================================================================
	'' MakeShared, MakeSharedFrom, and adopting a raw pointer
	''=====================================================================

	scope
		liveProbe = 0 : madeProbe = 0

		dim as SharedPtr( of Probe ) a = MakeShared( of Probe )( )
		assert_( a.IsNull( ) = FALSE )
		assert_( a.UseCount( ) = 1 )
		assert_( liveProbe = 1 )
		assert_( madeProbe = 1 )
		assert_( a->v = 0 )
		assert_( a.Get( ) <> 0 )

		'' MakeSharedFrom copy-constructs, so one more object exists
		dim as Probe seed = Probe( 12 )
		assert_( liveProbe = 2 )
		dim as SharedPtr( of Probe ) b = MakeSharedFrom( of Probe )( seed )
		assert_( liveProbe = 3 )
		assert_( b->v = 12 )
		assert_( b.UseCount( ) = 1 )

		'' the copy is independent of the seed
		seed.v = 99
		assert_( b->v = 12 )

		'' adopting a raw pointer: the handle owns it from here
		dim as Probe ptr raw = new Probe( 5 )
		assert_( liveProbe = 4 )
		dim as SharedPtr( of Probe ) c = SharedPtr( of Probe )( raw )
		assert_( c.UseCount( ) = 1 )
		assert_( c->v = 5 )
		assert_( c.Get( ) = raw )

		'' adopting a NULL raw pointer gives a null handle and allocates nothing
		dim as SharedPtr( of Probe ) d = SharedPtr( of Probe )( cptr( Probe ptr, 0 ) )
		assert_( d.IsNull( ) = TRUE )
		assert_( d.UseCount( ) = 0 )
	end scope

	'' everything above is destroyed exactly once
	assert_( liveProbe = 0 )

	''=====================================================================
	'' copying, assignment, self-assignment, Reset
	''=====================================================================

	scope
		liveProbe = 0

		dim as SharedPtr( of Probe ) a = MakeShared( of Probe )( )
		a->v = 1
		assert_( a.UseCount( ) = 1 )

		'' copy construction shares
		dim as SharedPtr( of Probe ) b = a
		assert_( a.UseCount( ) = 2 )
		assert_( b.UseCount( ) = 2 )
		assert_( a.Get( ) = b.Get( ) )
		assert_( liveProbe = 1 )

		'' and it really is the same object
		b->v = 2
		assert_( a->v = 2 )

		'' a third handle
		dim as SharedPtr( of Probe ) c
		c = a
		assert_( a.UseCount( ) = 3 )

		'' SELF-ASSIGNMENT must not destroy.  Without the early-out in
		'' operator let this releases the last reference and then re-takes a
		'' dead block.
		a = a
		assert_( a.UseCount( ) = 3 )
		assert_( a->v = 2 )
		assert_( liveProbe = 1 )

		'' assigning a DIFFERENT object over a handle releases the old one
		dim as SharedPtr( of Probe ) other = MakeShared( of Probe )( )
		other->v = 50
		assert_( liveProbe = 2 )

		c = other
		assert_( c->v = 50 )
		assert_( a.UseCount( ) = 2 )        '' c left the first group
		assert_( other.UseCount( ) = 2 )
		assert_( liveProbe = 2 )            '' nothing destroyed yet

		'' Reset drops one reference
		b.Reset( )
		assert_( b.IsNull( ) = TRUE )
		assert_( a.UseCount( ) = 1 )
		assert_( liveProbe = 2 )

		'' the last Reset on a group destroys the object
		a.Reset( )
		assert_( liveProbe = 1 )

		'' assigning null over a live handle also releases
		dim as SharedPtr( of Probe ) nullh
		c = nullh
		assert_( c.IsNull( ) = TRUE )
		assert_( other.UseCount( ) = 1 )
		other.Reset( )
		assert_( liveProbe = 0 )
	end scope

	assert_( liveProbe = 0 )

	''=====================================================================
	'' scope exit, early return, return by value
	''=====================================================================

	scope
		liveProbe = 0

		'' nested scope exit
		dim as SharedPtr( of Probe ) outer = MakeShared( of Probe )( )
		outer->v = 3
		scope
			dim as SharedPtr( of Probe ) inner = outer
			assert_( outer.UseCount( ) = 2 )
			inner->v = 4
		end scope
		assert_( outer.UseCount( ) = 1 )
		assert_( outer->v = 4 )
		assert_( liveProbe = 1 )
	end scope
	assert_( liveProbe = 0 )

	'' a handle destroyed on an early return
	liveProbe = 0
	assert_( EarlyReturn( FALSE ) = 0 )
	assert_( liveProbe = 0 )
	assert_( EarlyReturn( TRUE ) = 77 )
	assert_( liveProbe = 0 )

	'' returned by value: the count must settle at exactly 1
	scope
		liveProbe = 0
		dim as SharedPtr( of Probe ) r = MakeAt( 21 )
		assert_( r->v = 21 )
		assert_( r.UseCount( ) = 1 )
		assert_( liveProbe = 1 )
	end scope
	assert_( liveProbe = 0 )

	''=====================================================================
	'' the operators
	''=====================================================================

	scope
		liveProbe = 0
		dim as SharedPtr( of Probe ) a = MakeShared( of Probe )( )

		'' '->' reads and writes
		a->v = 8
		assert_( a->v = 8 )

		'' '*' reads and writes, and is the same object
		assert_( (*a).v = 8 )
		(*a).v = 9
		assert_( a->v = 9 )

		'' Ref( ) is the checked spelling of the same thing
		assert_( a.Ref( ).v = 9 )
		a.Ref( ).v = 10
		assert_( a->v = 10 )

		'' Get( ) is the raw pointer
		assert_( a.Get( )->v = 10 )

		'' through a second handle
		dim as SharedPtr( of Probe ) b = a
		b->v = 11
		assert_( a->v = 11 )
		assert_( (*a).v = 11 )
	end scope
	assert_( liveProbe = 0 )

	''=====================================================================
	'' scalar and non-default-constructible element types
	''=====================================================================

	scope
		'' a scalar T: no '->', but '*' and Ref( ) work
		dim as SharedPtr( of integer ) si = MakeShared( of integer )( )
		assert_( *si = 0 )
		*si = 42
		assert_( *si = 42 )
		assert_( si.Ref( ) = 42 )
		assert_( si.UseCount( ) = 1 )

		dim as SharedPtr( of integer ) sj = MakeSharedFrom( of integer )( 7 )
		assert_( *sj = 7 )

		dim as SharedPtr( of integer ) sk = si
		assert_( si.UseCount( ) = 2 )
		*sk = 43
		assert_( *si = 43 )

		'' a UDT with NO default constructor.  MakeShared( ) could not be
		'' instantiated for this T, but SharedPtr( of T ) itself is fine --
		'' which is the point of keeping the control block non-generic.
		dim as SharedPtr( of NoDefault ) nd = SharedPtr( of NoDefault )( new NoDefault( 4 ) )
		assert_( nd->v = 4 )
		assert_( nd.UseCount( ) = 1 )
		dim as SharedPtr( of NoDefault ) nd2 = nd
		assert_( nd.UseCount( ) = 2 )
	end scope

	''=====================================================================
	'' WeakPtr
	''=====================================================================

	scope
		liveProbe = 0

		'' default-constructed weak is expired and locks to null
		dim as WeakPtr( of Probe ) w0
		assert_( w0.Expired( ) = TRUE )
		assert_( w0.UseCount( ) = 0 )
		scope
			dim as SharedPtr( of Probe ) l = w0.Lock( )
			assert_( l.IsNull( ) = TRUE )
		end scope
		w0.Reset( )
		assert_( w0.Expired( ) = TRUE )

		dim as SharedPtr( of Probe ) a = MakeShared( of Probe )( )
		a->v = 6

		'' a weak handle does NOT raise the strong count
		dim as WeakPtr( of Probe ) w = a
		assert_( a.UseCount( ) = 1 )
		assert_( w.UseCount( ) = 1 )
		assert_( w.Expired( ) = FALSE )

		'' Lock while alive yields a real handle and raises the count
		scope
			dim as SharedPtr( of Probe ) l = w.Lock( )
			assert_( l.IsNull( ) = FALSE )
			assert_( l->v = 6 )
			assert_( a.UseCount( ) = 2 )
		end scope
		assert_( a.UseCount( ) = 1 )

		'' weak copy construction and assignment
		dim as WeakPtr( of Probe ) w2 = w
		assert_( w2.Expired( ) = FALSE )
		dim as WeakPtr( of Probe ) w3
		w3 = w
		assert_( w3.Expired( ) = FALSE )

		'' weak self-assignment
		w3 = w3
		assert_( w3.Expired( ) = FALSE )

		'' assigning a SharedPtr into a WeakPtr
		dim as SharedPtr( of Probe ) b = MakeShared( of Probe )( )
		b->v = 13
		w3 = b
		assert_( w3.Expired( ) = FALSE )
		scope
			dim as SharedPtr( of Probe ) l = w3.Lock( )
			assert_( l->v = 13 )
		end scope

		'' the object dies while weak handles still exist
		assert_( liveProbe = 2 )
		a.Reset( )
		assert_( liveProbe = 1 )

		'' every weak handle to it now reports expired and locks to null
		assert_( w.Expired( ) = TRUE )
		assert_( w2.Expired( ) = TRUE )
		assert_( w.UseCount( ) = 0 )
		scope
			dim as SharedPtr( of Probe ) l = w.Lock( )
			assert_( l.IsNull( ) = TRUE )
		end scope

		'' Reset on an expired weak handle
		w2.Reset( )
		assert_( w2.Expired( ) = TRUE )

		b.Reset( )
		assert_( liveProbe = 0 )
	end scope

	assert_( liveProbe = 0 )

	''=====================================================================
	'' the cycle WeakPtr exists to break
	''=====================================================================

	scope
		liveNode = 0

		'' parent -> child is strong, child -> parent is weak
		scope
			dim as SharedPtr( of Node_ ) root = MakeShared( of Node_ )( )
			root->id = 1

			dim as SharedPtr( of Node_ ) kid = MakeShared( of Node_ )( )
			kid->id = 2

			root->kids.Push( kid )
			kid->parent = root

			assert_( liveNode = 2 )
			assert_( root.UseCount( ) = 1 )     '' the child's back-link is weak
			assert_( kid.UseCount( ) = 2 )      '' root's array holds one

			'' the back-link resolves while the parent is alive
			scope
				dim as SharedPtr( of Node_ ) up = kid->parent.Lock( )
				assert_( up.IsNull( ) = FALSE )
				assert_( up->id = 1 )
			end scope
		end scope

		'' both are gone.  With a strong back-link this would be 2.
		assert_( liveNode = 0 )
	end scope

	''=====================================================================
	'' SpCast
	''=====================================================================

	scope
		liveShape = 0

		dim as SharedPtr( of Circle ) c = MakeShared( of Circle )( )
		assert_( liveShape = 1 )
		assert_( c->r = 3 )
		assert_( c->Area( ) = 9 )

		dim as SharedPtr( of Shape ) s = SpCast( of Circle, Shape )( c )
		assert_( s.IsNull( ) = FALSE )
		assert_( c.UseCount( ) = 2 )        '' both handles share one block
		assert_( s.UseCount( ) = 2 )
		assert_( s.Get( ) = cptr( Shape ptr, c.Get( ) ) )

		'' virtual dispatch through the base handle reaches the derived override
		assert_( s->Area( ) = 9 )
		assert_( s->tag = 2 )

		'' dropping the derived handle leaves the object alive
		c.Reset( )
		assert_( s.UseCount( ) = 1 )
		assert_( liveShape = 1 )

		'' and the base handle destroys it correctly -- Shape's destructor is
		'' virtual, so Circle's runs first and the count reaches zero
		s.Reset( )
		assert_( liveShape = 0 )

		'' casting a null handle yields a null handle
		dim as SharedPtr( of Circle ) nc
		dim as SharedPtr( of Shape ) ns = SpCast( of Circle, Shape )( nc )
		assert_( ns.IsNull( ) = TRUE )
	end scope

	assert_( liveShape = 0 )

	''=====================================================================
	'' inside containers
	''=====================================================================

	scope
		liveProbe = 0

		'' Array growth must not lose or duplicate a reference.  The push
		'' count is chosen to force several reallocations.
		scope
			dim as Array( of SharedPtr( of Probe ) ) v
			dim as SharedPtr( of Probe ) keep = MakeShared( of Probe )( )
			keep->v = 31

			for i as integer = 1 to 64
				v.Push( keep )
			next

			assert_( v.Count( ) = 64 )
			assert_( keep.UseCount( ) = 65 )
			assert_( liveProbe = 1 )

			'' every slot names the same object
			assert_( v[ 0 ]->v = 31 )
			assert_( v[ 63 ]->v = 31 )
			v[ 10 ]->v = 32
			assert_( keep->v = 32 )
		end scope
		assert_( liveProbe = 0 )

		'' distinct objects in an array, all released on destruction
		scope
			dim as Array( of SharedPtr( of Probe ) ) v
			for i as integer = 1 to 10
				dim as SharedPtr( of Probe ) p = MakeShared( of Probe )( )
				p->v = i
				v.Push( p )
			next
			assert_( liveProbe = 10 )
			assert_( v[ 4 ]->v = 5 )
			assert_( v[ 4 ].UseCount( ) = 1 )
		end scope
		assert_( liveProbe = 0 )

		'' in a Map
		scope
			dim as Map( of long, SharedPtr( of Probe ) ) m
			'' LONG, not INTEGER: the key type is LONG and Map's '[]' takes it
			'' BYREF, so an INTEGER index is a type mismatch rather than a
			'' silent promotion -- and INTEGER is 64-bit on win64.
			for i as long = 1 to 20
				dim as SharedPtr( of Probe ) p = MakeShared( of Probe )( )
				p->v = i * 100
				m[ i ] = p
			next
			assert_( liveProbe = 20 )
			assert_( m[ 7 ]->v = 700 )

			'' overwriting a slot releases the old object
			dim as SharedPtr( of Probe ) rep = MakeShared( of Probe )( )
			rep->v = -1
			assert_( liveProbe = 21 )
			m[ 7 ] = rep
			assert_( liveProbe = 20 )
			assert_( m[ 7 ]->v = -1 )
		end scope
		assert_( liveProbe = 0 )
	end scope

	assert_( liveProbe = 0 )
	assert_( liveShape = 0 )
	assert_( liveNode = 0 )
