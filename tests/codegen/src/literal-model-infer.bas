'' A generic's T inferred from a literal follows the literal model (lexer/littype.bas): an
'' unsuffixed 3000000000 is UINTEGER, &hFFFFFFFF INTEGER, 2147483648& LONG, 1.5f SINGLE.
function Show( of T )( byval x as T ) as string
    return str( sizeof( T ) ) & ":" & str( x )
end function
print Show( 3000000000 )
print Show( 3000000000 \ -2 )
print Show( &hFFFFFFFF )
print Show( 2147483648& )
print Show( 1.5f )
print Show( 18446744073709551615 )
print Show( 4294967296 )
