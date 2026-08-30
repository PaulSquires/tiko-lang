'' TWO REDIMS OF THE SAME ARRAY IN ONE SCOPE, with no DIM ahead of them: the first
'' brings the array into existence and the second re-dimensions it. fbc accepts that
'' and rejects the pair when the ELEMENT TYPE differs (error 4) -- both measured.
''
'' The redeclaration allowance asked IsDynArrayItem_ whether the PREVIOUS declaration
'' was dynamic, and that reads the WRITTEN BOUNDS: 'redim a( 0 to 3 )' writes bounds in
'' full, so it looked fixed and the second redim was a duplicate. A redim's array is
'' dynamic however its bounds are spelled, which only the SYMBOL can record --
'' dim/redim.bas reports two of these and neither is a duplicate to fbc.
sub s1( )
    redim a( 0 to 3 ) as integer
    redim a( 0 to 7 ) as integer
    print ubound( a )
    '' PRESERVE makes no difference to the declaration rule.
    redim preserve a( 0 to 9 ) as integer
    print ubound( a )
end sub

s1
