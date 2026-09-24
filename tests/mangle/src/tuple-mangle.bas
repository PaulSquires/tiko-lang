'' A TUPLE MANGLES AS fbc's 'FBTUPLE<N>' INSTANTIATION -- see tuple-mangle.test.
type Counted
	as long v
	declare constructor( )
	declare constructor( byref rhs as Counted )
	declare destructor( )
end type
constructor Counted( ) : end constructor
constructor Counted( byref rhs as Counted ) : v = rhs.v : end constructor
destructor Counted( ) : end destructor
namespace NS
	function Sum2( byval t as (long, long) ) as long
		return t._1 + t._2
	end function
	sub TakeStr( byval t as (long, string) )
		print t._1; t._2
	end sub
	sub TakeNest( byval t as ((long, string), long) )
		print t._1._1; t._2
	end sub
	sub TakeCounted( byval t as (Counted, long) )
		print t._2
	end sub
	sub TakeInt( byval t as (integer, integer) )
		print t._1
	end sub
	function MinMax( ) as (lo as long, hi as long)
		return (1, 9)
	end function
end namespace
print NS.Sum2( (3, 4) )
