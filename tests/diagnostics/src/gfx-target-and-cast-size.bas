'' TWO SHAPES fbc CALLS ILLEGAL INDIRECTION (error 28): a FIXED STRING as a graphics
'' target, and a cast to a string type with no size. Measured with the accepted twin of
'' each beside it.
dim buffer(0 to 99) as ubyte
dim z as zstring * 32
dim w as wstring * 32
dim s as string
dim p as any ptr
dim z4 as zstring * 4
'' Accepted: an array IS an image buffer, and so is a pointer or an element of one.
line buffer, (0, 0)-(31, 31), 0
line buffer(0), (0, 0)-(31, 31), 0
line p, (0, 0)-(31, 31), 0
'' Refused: a fixed string is an array of CHARACTERS, not a buffer -- and a var-len
'' string and a plain scalar are not buffers either.
line z, (0, 0)-(31, 31), 0
line w, (0, 0)-(31, 31), 0
line s, (0, 0)-(31, 31), 0
'' Accepted: a cast to a SIZED string type, or to a pointer.
print cast( zstring * 4, z4 )
print cast( zstring ptr, @z4 )
print cast( integer, 1.5 )
'' Refused: the type named has no storage to cast into.
print cast( zstring, "a" )
print cast( wstring, wstr( "a" ) )
