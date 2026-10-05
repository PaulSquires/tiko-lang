'' STRPTR AND SADD OVER A PLAIN UDT. Measured on fbc-modern: over a type casting to string and one
'' with 'byref as zstring', lines 14-16 are error 24; over a literal (17) it compiles.
type S1
    as long q
    declare operator cast( ) as string
end type
operator S1.cast( ) as string : return "ab" : end operator
type Z1
    as zstring * 8 z
    declare operator cast( ) byref as zstring
end type
operator Z1.cast( ) byref as zstring : return this.z : end operator
dim as S1 sv : dim as Z1 zv
print strptr( sv ) <> 0
print sadd( sv ) <> 0
print *strptr( zv )
print strptr( "x" ) <> 0
