'' BYVAL or BYREF written on an array parameter: fbc's 59 at every line below, in a
'' definition, a DECLARE and a procedure type (fbc-modern 1.20, 2026-10-25). The plain
'' forms at the end are fine.
sub S1( byval a( ) as long )
end sub
declare sub S2( byref a( ) as long )
type PT as sub( byval a( ) as long )
sub S3( a( ) as long, byval n as long )
end sub
declare sub S4( ( ) as long )
