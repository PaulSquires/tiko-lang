'' Calling a returned procedure pointer in one expression: 'Pick( 1 )( 5 )'. fbc-modern 1.20
'' prints ' 7 6', 6, -6 and 12 (2026-10-25); tiko typed the call as Pick's result -- ' 76',
'' TKO0968 and TKO0820 (by-example BUG-procedures-1).
type Transform as function( byval x as long ) as long
function Inc( byval x as long ) as long
    return x + 1
end function
function Pick( byval w as long ) as Transform
    return @Inc
end function
print 7; Pick( 1 )( 5 )
dim r as long = Pick( 1 )( 5 )
print r
print -Pick( 1 )( 5 )
print Pick( 0 )( 5 ) + Pick( 0 )( 5 )
