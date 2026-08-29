'' AN ELEMENT OF A BRACE INITIALISER IS A CONSTRUCTOR CALL TOO, even when it is not
'' spelt out as one. This fell past both the copy branch and the spelled-ctor branch to
'' the POD aggregate copy and STORED 7 AND 8 RAW -- no constructor, no decline, and it
'' verified. fbc emits _ZN3FOOC1Eu7INTEGER at each element's offset; run, it prints
'' ' 70  80' where tiko-lang's elements held 7 and 8. The scalar 'dim as foo a = 7' had
'' taken the converting constructor since it was written; only the ELEMENT had not.
type foo
	as integer n
	declare constructor( byval v as integer )
end type

constructor foo( byval v as integer )
	this.n = v * 10
end constructor

dim tb(0 to 1) as foo = { 7, 8 }
print tb(0).n, tb(1).n

'' The spelled form beside it, which always worked, and the scalar.
dim tc(0 to 1) as foo = { foo( 1 ), foo( 2 ) }
print tc(0).n, tc(1).n
dim as foo a = 3
print a.n
