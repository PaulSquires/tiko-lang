'' 'offsetof( T, field )' -- A COMPILE-TIME INTEGER, folded from the measured layout.
''
'' Measured: over a type whose first two fields are INTEGERs, 'offsetof( E, i )' is 16
'' and 'typeof' of it is INTEGER. It takes a TYPE and a FIELD NAME rather than two
'' expressions -- neither argument has a type of its own, and the field name never
'' resolves to anything, which is why nothing else recognised the shape.
''
'' It was not implemented at all, so every use declined. structs/padding.bas is written
'' almost entirely in terms of it.
type E
	as integer a, b
	as long i
	as short s
	as byte t
end type

print offsetof( E, a )
print offsetof( E, b )
print offsetof( E, i )
print offsetof( E, s )
print offsetof( E, t )

dim as integer n = offsetof( E, i )
print n

if offsetof( E, i ) = sizeof( integer ) * 2 then print "ok"
