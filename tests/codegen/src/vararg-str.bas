'' A narrow string in a C variadic tail is its data pointer, as fbc passes it
#include "crt/stdio.bi"
function rs( ) as string
    return "fromfn"
end function
type T
    as string nm
end type
dim as string s = "abc"
dim as zstring * 10 z = "fixed"
dim as string * 6 f = "fstr"
dim as T t
t.nm = "field"
dim as string a( 1 ) = { "e0", "e1" }
printf( !"1[%s]\n", s )
printf( !"2[%s]\n", s & "x" )
printf( !"3[%s]\n", z )
printf( !"4[%.6s]\n", f )
printf( !"5[%s]\n", rs( ) )
printf( !"6[%s]\n", t.nm )
printf( !"7[%s]\n", a( 1 ) )
printf( !"8[%s %d]\n", "lit", len( s ) )
