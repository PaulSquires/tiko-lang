type foo field = 1
	pad as integer
	f1(0 to 2) as ubyte
	f3(0 to 1) as uinteger
end type
type bar field = 1
	pad as integer
	f(0 to 1) as foo
end type
dim as foo a = ( 1, { 2, 3, 4 }, { 5, 6 } )
print a.pad; a.f1(2); a.f3(1)
dim as bar b = ( 7, { ( 8, { 9, 10, 11 }, { 12, 13 } ), ( 14, { 15, 16, 17 }, { 18, 19 } ) } )
print b.pad; b.f(0).f1(1); b.f(1).f3(1)
dim as bar c( 0 to 1 ) = { ( 7, { ( 8, { 9, 10, 11 }, { 12, 13 } ), ( 14, { 15, 16, 17 }, { 18, 19 } ) } ), ( 20, { ( 21, { 22, 23, 24 }, { 25, 26 } ), ( 27, { 28, 29, 30 }, { 31, 32 } ) } ) }
print c(1).f(1).f3(1)
type foobar field = 1
	pad as integer = 1234
	b( 0 to 1 ) as bar = { ( 7, { ( 8, { 9, 10, 11 }, { 12, 13 } ), ( 14, { 15, 16, 17 }, { 18, 19 } ) } ), ( 20, { ( 21, { 22, 23, 24 }, { 25, 26 } ), ( 27, { 28, 29, 30 }, { 31, 32 } ) } ) }
end type
dim as foobar fb
print fb.pad; fb.b(1).f(1).f3(1); fb.b(0).f(1).f1(2)
