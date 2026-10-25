'' 'Largest( nums( ) ) = 0' is re-read as the call 'Largest( nums( ) = 0 )' (TKO0931, line 8),
'' and the whole-array comparison has no value: TKO0649 at 8,14. fbc says 58 there. The
'' parenthesised form assigns (line 9).
function Largest( a( ) as long ) byref as long
    return a( 0 )
end function
dim nums( 0 to 2 ) as long = { 1, 2, 3 }
Largest( nums( ) ) = 0
( Largest( nums( ) ) ) = 0
