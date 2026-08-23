'' 'Box( of long )' is a GENERIC INSTANTIATION, not a call with two arguments named
'' 'of' and 'long'. Taking it as a call parsed 'of' as an expression and then wanted a
'' ')' where the type argument was.
''
'' 'of' is CONTEXTUAL -- not a keyword -- so it is recognised by spelling, exactly as
'' 'each' and 'defer' are.
''
'' The DECLARATION and the type position already worked; only the EXPRESSION position
'' failed, which is where the corpus writes 'None( of Currency )( )',
'' 'Fail( of T, FsError )( ... )' and 'sizeof( Box( of long ) )'.
''
'' The arguments are consumed and DISCARDED, which is what TypeRef already does with the
'' same construct: every instantiation of one generic is the same type to tiko-lang. That
'' limitation is pre-existing -- this makes the expression side agree with the type side.

type Box( of U )
	as U v
end type

type Pair( of A, B )
	as A x
	as B y
end type

dim b as Box( of long )
dim p as Pair( of long, string )

print sizeof( Box( of long ) )
print sizeof( Pair( of long, string ) )
