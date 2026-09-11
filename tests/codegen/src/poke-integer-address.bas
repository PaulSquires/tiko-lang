#lang "fb"

'' POKE's destination is an INTEGER address, not a pointer.
dim as ubyte buf(0 to 7)
dim as integer a = cast( integer, cast( any ptr, @buf(0) ) )
poke a, 65
poke ubyte, a + 1, 66
poke byte, @buf(2), 67
print peek( a ); peek( a + 1 ); peek( byte, a + 2 )
