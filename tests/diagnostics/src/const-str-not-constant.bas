'' A STRING CONSTANT INITIALISED FROM SOMETHING fbc DOES NOT FOLD -- its error 11, "Expected
'' constant", on each refused line. The folded forms below them are fine.
function f( ) as string
    return "q"
end function
dim shared s as string
const A = "ab" & string( 3, "0" )                   '' 11
const B = space( 2 )                                '' 11
const C = "x" + left( "abc", 2 )                    '' 11
const D = ( ucase( "ab" ) )                         '' 11: one argument
const E = hex( 255 ) & "h"                          '' 11
const G = "a" & f( )                                '' 11: the program's own function
const H = s & "a"                                   '' 11: a variable
const I = mkd( 1 )                                  '' 11
const J = "ab" & str( 1 ) & chr( 65, 66 ) & wchr( 67 ) & lcase( "Q", 1 ) & ucase( "r", 1 )
const K = J & wstr( "w" )
print J, K
