'' REDIM of a BYDESC ARRAY PARAMETER inside an IF -- single-line and block alike.
'' PsListTree's drag source: 'if n > 0 then redim preserve srcRows( 0 to n - 1 )'.
private function Build( byval total as long, srcRows() as integer ) as integer
    dim as integer n = 0
    redim srcRows( 0 to total - 1 )
    for i as integer = 0 to total - 1
        if (i mod 2) = 0 then srcRows( n ) = i * 10 : n += 1
    next
    if n > 0 then redim preserve srcRows( 0 to n - 1 )
    if n > 100 then
        redim srcRows( 0 to 0 )
    end if
    return n
end function

dim as integer rows()
dim as integer n = Build( 7, rows() )
print n; ubound( rows ); rows( 0 ); rows( ubound( rows ) )
