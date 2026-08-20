'' 'a##b##c' pastes LEFT TO RIGHT.
''
'' '##' is TWO tokens, so after the first paste the cursor landed ON the second '##'
'' rather than on the result -- where nothing recognised it and both hashes were emitted
'' literally. fbcunit writes
''
''     procptr( tests.##suite_name##.init )
''
'' and got 'tests.mysuite##.init'. Seven corpus files, all through SUITE_INIT.
''
'' The spellings accumulate and are re-lexed ONCE at the end, which is what fbc does: it
'' cannot make '.mysuite' a single token either, and does not try -- the result is the
'' three tokens '.', 'mysuite', '.'.

namespace tests
	namespace mysuite
		declare sub init( )
	end namespace
end namespace

sub tests.mysuite.init( )
end sub

#macro REG( nm )
	dim as sub( ) p = procptr( tests.##nm##.init )
	print p <> 0
#endmacro

REG( mysuite )

'' Three operands, the middle one a parameter, pasting to the name of a #define.
#macro J3( a, b, c )
	print a##b##c
#endmacro
#define X1 7
J3( X, 1, )
