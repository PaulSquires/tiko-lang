'' WHAT EVERY REDIM MUST HAVE -- fbc errors 147 and 63. A redim needs a TYPE unless it is
'' re-dimensioning an array something else already declared, AND it must write bounds.
'' Every line was measured against fbc; the accepted ones sit beside the refused ones.
dim declared( ) as integer
extern ext( ) as integer
extern scalar as integer
sub takesBydesc( a( ) as integer )
    '' Accepted: the parameter declared it.
    redim a( 0 to 2 )
end sub
'' Accepted: a type is written, or the array was already declared WITH bounds given here.
redim first( 1 to 2 ) as integer
redim first( 0 to 3 )
redim declared( 0 to 2 )
redim ext( 0 to 2 )
redim fresh( ) as integer
'' Refused (147): no type, and nothing else declared it.
redim undeclared( 1 to 2 )
redim shared alsoUndeclared( 0 to 1 )
redim suffixed$( 0 to 1 )
'' Refused (147): no type, and EMPTY parens re-dimension nothing.
redim declared( )
redim ext( )
'' Refused (63): no parentheses at all.
redim noParens as integer
redim suffixOnly$
