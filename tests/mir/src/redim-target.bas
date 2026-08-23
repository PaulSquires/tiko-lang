'' A REDIM NAMES ITS ARRAY THROUGH AN EXPRESSION, not only by a bare name.
''
'' The parser kept only the LAST name of a dotted target, so 'redim x.array( 0 to 9 )'
'' reached lowering as 'array' -- it declined when nothing of that name was in scope,
'' and would have re-dimensioned THE WRONG ARRAY when something was. The chain is
'' recorded as an expression now, in the same slot the parenthesised form already used,
'' so all three spellings reach lowering the same way. 202 corpus lines write one.
type T
    as integer arr( any )
    as integer other( any )
end type

namespace ns
    dim shared narr( ) as integer
end namespace

dim x as T
dim a( ) as integer
dim as integer arr( )       '' the decoy: a bare 'arr' in the enclosing scope

redim x.arr( 0 to 9 )
redim preserve x.other( 0 to 4 )
redim ( a )( 0 to 1 )
redim ns.narr( 0 to 2 )
redim arr( 0 to 3 )

x.arr( 1 ) = 5
