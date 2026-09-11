'' 'Sort( outer_[ i ] )' -- AN ELEMENT IS AN ARGUMENT TOO.
''
'' InferArgType_ had no N_INDEX arm, so the type argument was never inferred, the
'' generic never instantiated, and the call went out to the TEMPLATE -- a name with no
'' body: 'lld-link: error: undefined symbol: FB::SORT(FB::ARRAY&)'. Every other call to
'' the same generic in the same file instantiated, which is what kept it looking like a
'' container problem.
type Box
	as long v
	declare operator [] ( byval i as long ) byref as long
end type

operator Box.[] ( byval i as long ) byref as long
	return this.v
end operator

function Doubled( of T )( byval x as T ) as T
	return x + x
end function

dim as Box b
b.v = 21
print Doubled( b[ 0 ] )

dim as long a( 0 to 3 )
a( 2 ) = 5
print Doubled( a( 2 ) )

dim as long ptr p = @a( 2 )
print Doubled( p[ 0 ] )
