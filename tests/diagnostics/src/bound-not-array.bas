'' LBOUND / UBOUND OF SOMETHING THAT IS NOT AN ARRAY -- fbc's error 63 ("Expected array"),
'' 58 or 24, on each refused line. Each was TKO0994. The arrays below them are fine.
type U
    as integer a
    as integer arr( 2 to 5 )
end type
dim shared uu as U
dim shared pu as U ptr
dim shared x as integer
dim shared s as string
dim shared z as zstring * 10
dim shared p as integer ptr
dim shared fs( 1 to 3 ) as string * 5
print lbound( x )                                   '' 63
print ubound( uu.a )                                '' 63: a field
dim as integer y = lbound( s )                      '' 63
print lbound( z )                                   '' 63: a fixed string is not an array
print ubound( p )                                   '' 63
print lbound( uu )                                  '' 63
print ubound( fs( 1 ) )                             '' 58: an element
print lbound( cast( integer, 1 ) )                  '' 24
const K = ubound( uu.a )                            '' 63, though K is never used
sub q( a( ) as integer )
    print lbound( a ), ubound( a )
end sub
const KA = lbound( uu.arr ) + ubound( uu.arr, 1 )
print KA, lbound( fs ), ubound( fs ), lbound( pu->arr )
