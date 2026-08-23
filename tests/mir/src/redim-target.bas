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

'' A REDIM NAMES AN ARRAY DECLARED IN AN OUTER SCOPE. The lookup searched ONE scope, so
'' a redim inside an IF, a FOR or a SCOPE never found the array and declined -- which is
'' how fb/map.bi and fb/set.bi grow their tables:
''
''     dim oldkeys( any ) as TK
''     if( oldcap > 0 ) then
''         redim oldkeys( 0 to oldcap-1 )
''
'' THE WALK TAKES ONLY VARIABLES. It reaches the enclosing TYPE's scope too, and
'' 'redim items( ... )' inside a method names the FIELD -- accepting the field symbol
'' here made a FRESH LOCAL for it and re-dimensioned that, leaving the object's own
'' array alone.
sub GrowsInABlock( byval want as long )
    dim outer_( any ) as integer
    if want > 0 then
        redim outer_( 0 to want - 1 )
        for i as long = 0 to want - 1
            redim preserve outer_( 0 to i )
        next
    end if
end sub
