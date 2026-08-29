'' A PROPERTY SETTER IS NOT CALLABLE AS AN EXPRESSION, and an INDEXED getter has exactly
'' the arity a PLAIN setter does. So 'print f.bar( 3 )' over a type declaring all four
'' accessors scored both, tied, and came out UNTYPED -- the PRINT declined -- while
'' 'f.bar( 3 ) = 7' beside it lowered, because the assignment path asks for a setter by
'' name.
''
'' Measured: fbc mangles all four distinctly and reads 'f.bar( 3 )' as
'' '_ZN3FOO10BAR__get__Eu7INTEGER( &F$0, 3ll )'.
type foo
	as long v(0 to 7)
	declare property bar( ) as integer
	declare property bar( byval x as integer )
	declare property bar( byval i as integer ) as integer
	declare property bar( byval i as integer, byval x as integer )
end type
property foo.bar( ) as integer
	return this.v(0)
end property
property foo.bar( byval x as integer )
	this.v(0) = x
end property
property foo.bar( byval i as integer ) as integer
	return this.v(i)
end property
property foo.bar( byval i as integer, byval x as integer )
	this.v(i) = x
end property
dim as foo f
f.bar = 5
f.bar(3) = 7
print f.bar, f.bar(3)
