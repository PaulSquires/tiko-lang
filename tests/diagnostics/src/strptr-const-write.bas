'' Writes through strptr( ), and into a const string's characters -- fbc's error 119 on
'' each of the refused lines, the others compile clean. Measured on fbc-modern 1.20.
sub f( byref cs as const string )
    dim b as ubyte = strptr( cs )[0]         '' reading is fine
    (*strptr( cs ))[0] = 1                   '' 119
end sub

dim s as string = "ab"
dim k as const string = "a"
dim z as const zstring * 4 = "a"
strptr( s )[0] = 65                          '' fine: s is not const
dim p as const zstring ptr = strptr( k )     '' fine
strptr( s ) = 0                              '' 119: strptr's result is a const pointer
sadd( k ) = 0                                '' 119
strptr( k )[0] = 65                          '' 119
k[0] = 1                                     '' 119
z[0] = 1                                     '' 119
dim q as zstring ptr = strptr( k )           '' 181: drops the pointee's const
