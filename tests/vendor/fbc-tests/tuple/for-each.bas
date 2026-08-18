' TEST_MODE : COMPILE_AND_RUN_OK

'' 'for each (k, v) in c' -- destructuring the element.
''
'' This is the spelling that makes a map iterable the way every other language's
'' map is, instead of reaching through 'kv.key' / 'kv.value'. It is defined
'' entirely in terms of the existing lowering: the element is bound once, and
'' each name is declared from one field of it.
''
'' The collection here yields a tuple from Value(), which is the shape a real
'' map has and the shape that found the TYPE-body crash this feature was blocked
'' on -- a tuple with a STRING element used as a method return type.
''
'' See fb-rfcs/rfcs/0003-for-each.md section 6a.

#define assert_(e) if (e) = 0 then fb_Assert(__FILE__, __LINE__, __FUNCTION__, #e)

	dim shared as long ctors, dtors

	type Counted
		as long v
		declare constructor( )
		declare constructor( byval n as long )
		declare constructor( byref rhs as Counted )
		declare destructor( )
		declare operator let( byref rhs as Counted )
	end type

	constructor Counted( )                      : this.v = 0     : ctors += 1 : end constructor
	constructor Counted( byval n as long )      : this.v = n     : ctors += 1 : end constructor
	constructor Counted( byref rhs as Counted ) : this.v = rhs.v : ctors += 1 : end constructor
	destructor Counted( )                       : dtors += 1     : end destructor
	operator Counted.let( byref rhs as Counted ): this.v = rhs.v : end operator

	'' a map-like collection: Value() yields a (key, value) pair
	type PairIter
		as long i
		declare function IsValid( ) as boolean
		declare function Value( ) as (long, string)
		declare sub MoveNext( )
	end type

	type PairColl
		as long n
		declare function GetIterator( ) as PairIter
	end type

	function PairIter.IsValid( ) as boolean
		return this.i < 3
	end function

	function PairIter.Value( ) as (long, string)
		return ( this.i, "v" & this.i )
	end function

	sub PairIter.MoveNext( )
		this.i += 1
	end sub

	function PairColl.GetIterator( ) as PairIter
		dim it as PairIter
		it.i = 0
		return it
	end function

	'' a 3-element yield, to show arity two is not special
	type TripleIter
		as long i
		declare function IsValid( ) as boolean
		declare function Value( ) as (long, long, long)
		declare sub MoveNext( )
	end type

	type TripleColl
		as long n
		declare function GetIterator( ) as TripleIter
	end type

	function TripleIter.IsValid( ) as boolean
		return this.i < 2
	end function
	function TripleIter.Value( ) as (long, long, long)
		return ( this.i, this.i * 10, this.i * 100 )
	end function
	sub TripleIter.MoveNext( )
		this.i += 1
	end sub
	function TripleColl.GetIterator( ) as TripleIter
		dim it as TripleIter
		it.i = 0
		return it
	end function

	'' an element whose destruction has to balance per iteration
	type CountedIter
		as long i
		declare function IsValid( ) as boolean
		declare function Value( ) as (Counted, long)
		declare sub MoveNext( )
	end type

	type CountedColl
		as long n
		declare function GetIterator( ) as CountedIter
	end type

	function CountedIter.IsValid( ) as boolean
		return this.i < 4
	end function
	function CountedIter.Value( ) as (Counted, long)
		return ( Counted( this.i ), this.i )
	end function
	sub CountedIter.MoveNext( )
		this.i += 1
	end sub
	function CountedColl.GetIterator( ) as CountedIter
		dim it as CountedIter
		it.i = 0
		return it
	end function

	'' ---- the basic form ----
	scope
		dim c as PairColl
		dim keys as long = 0
		dim vals as string = ""

		for each (k, v) in c
			keys += k
			vals &= v & ";"
		next

		assert_( keys = 0 + 1 + 2 )
		assert_( vals = "v0;v1;v2;" )
	end scope

	'' ---- each name has its OWN element's type ----
	scope
		dim c as PairColl
		for each (k, v) in c
			'' k is a long and v is a STRING, not a tuple and not each other
			k += 100
			v &= "!"
			assert_( k >= 100 )
			assert_( right( v, 1 ) = "!" )
		next
	end scope

	'' ---- the whole-element binding still works, unchanged ----
	scope
		dim c as PairColl
		dim total as long = 0
		for each e in c
			total += e._1
			assert_( e._2 = "v" & e._1 )
		next
		assert_( total = 3 )
	end scope

	'' ---- arity two is not special ----
	scope
		dim c as TripleColl
		dim sum as long = 0
		for each (a, b, d) in c
			sum += a + b + d
		next
		assert_( sum = (0 + 0 + 0) + (1 + 10 + 100) )
	end scope

	'' ---- EXIT FOR and CONTINUE FOR ----
	scope
		dim c as PairColl
		dim seen as string = ""

		for each (k, v) in c
			if( k = 0 ) then continue for
			if( k = 2 ) then exit for
			seen &= v
		next
		assert_( seen = "v1" )

		'' ...and the loop is re-enterable afterwards
		seen = ""
		for each (k, v) in c
			seen &= k
		next
		assert_( seen = "012" )
	end scope

	'' ---- nesting ----
	scope
		dim c as PairColl
		dim n as long = 0
		for each (k1, v1) in c
			for each (k2, v2) in c
				n += 1
				assert_( v1 = "v" & k1 )
				assert_( v2 = "v" & k2 )
			next
		next
		assert_( n = 9 )
	end scope

	'' ---- the names are per-iteration, and destruction balances ----
	scope
		dim c as CountedColl
		dim total as long = 0

		ctors = 0 : dtors = 0
		for each (cv, i) in c
			total += cv.v + i
		next
		assert_( total = 2 * (0 + 1 + 2 + 3) )
		assert_( ctors = dtors )
	end scope

	'' ---- over an ARRAY of tuples ----
	scope
		dim arr(0 to 2) as (long, string)
		for i as long = 0 to 2
			arr(i)._1 = i
			arr(i)._2 = "a" & i
		next

		dim keys as long = 0
		dim vals as string = ""
		for each (k, v) in arr
			keys += k
			vals &= v
		next
		assert_( keys = 3 )
		assert_( vals = "a0a1a2" )
	end scope

	end
