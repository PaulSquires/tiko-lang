'' A LAMBDA WRITTEN INSIDE A GENERIC BODY.
''
'' A lambda is hoisted to module level as an ordinary procedure with a generated name,
'' and that is right everywhere except here: this one's body names T, which stands for
'' nothing at module level, so it lowered to no code at all and the comparator every
'' call used was empty.
''
'' fb/sort.bi writes exactly this in all four of Sort, SortDesc, IsSorted and
'' IsSortedDesc, so it was not an exotic corner -- every file that included the header
'' carried four dead comparators.
''
'' Two halves, and both are needed:
''
''   the TEMPLATE copy is marked PF_GENERIC_PROC like the body around it, so lowering
''   leaves it alone rather than emitting a function whose T is unbound;
''
''   each INSTANTIATION re-parses the body, and the re-parse hoists a lambda of its own
''   -- into the re-parse's ParserState, which is a local, so it used to be built and
''   then dropped. It is harvested here, its sequence number seeded from the outer
''   parser so two instantiations cannot produce the same name.

#define assert_(e) if (e) = 0 then fb_Assert(__FILE__, __LINE__, __FUNCTION__, #e)

function Apply( of T )( byval x as T ) as T
	dim as function( byval as T ) as T f = _
		function( byval v as T ) as T
			return v + v
		end function
	return f( x )
end function

'' TWO instantiations, which is what makes the sequence number matter: one name for
'' both would be two definitions of one symbol.
assert_( Apply( 21 ) = 42 )
assert_( Apply( 1.5 ) = 3.0 )
