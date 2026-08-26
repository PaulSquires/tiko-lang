'' A '#macro' EXPANDED INSIDE AN EXPRESSION.
''
'' The body capture pushed every token between the '#macro NAME( params )' line and the
'' '#endmacro' line -- and that run BEGINS with the header line's own end-of-line and
'' ENDS with the last body line's. Neither exists in fbc's model, and the leading one is
'' fatal: 's = m( 5 )' came out as 's =' with nothing after it and a separate statement
'' holding the body, so the assignment had no value and declined. A '#define' with the
'' same body was right all along, which is what made this look like an expansion problem
'' rather than a capture one.
''
'' Measured with 'fbc -pp'. Both ends trim a RUN, not one token -- a body with two
'' leading and three trailing blank lines loses all five -- and an EOL strictly INSIDE
'' the body stays.

#define assert_(e) if (e) = 0 then fb_Assert(__FILE__, __LINE__, __FUNCTION__, #e)

#macro m( a )
	a + 1
#endmacro

dim s as integer
s = m( 5 )
assert_( s = 6 )

'' Leading and trailing blank lines inside the body are trimmed with the EOLs.
#macro blanks( a )

	a * 2

#endmacro

s = blanks( 5 )
assert_( s = 10 )

'' NESTED IS STILL BROKEN, and deliberately so. 'outer( 5 )' over a body of
'' 'm( b ) * 2' is 7 under fbc -- token substitution, nothing parenthesised, so
'' the '^'-free expression is 5 + 1 * 2. It needs the TRAILING end-of-line trimmed
'' as well as the leading one, and trimming that cost 830 corpus declines against
'' the 4 this file buys: __FB_ARG_LISTEXPAND__ synthesises 'M( 1 ) : M( 2 )' as
'' text and relies on each expansion ending where it does. Recorded here rather
'' than hidden; see the capture in src/pp/macro.bas.

'' A body of two statements still works as a statement, with its interior EOL intact.
#macro two( a )
	s = a
	s += 1
#endmacro

two( 41 )
assert_( s = 42 )
