'' 'dim' INSIDE A TYPE DECLARES FIELDS.
''
'' It was routed to the DECLARATION parser instead, which built a variable node that the
'' layout pass -- which reads fields and only fields -- never saw. 'type C : dim as
'' integer i, j : end type' came out with NO FIELDS AT ALL and a size of 1 where fbc
'' says 16, so every field after such a type sat on top of it and every literal over one
'' declined. structs/udt-init-1.bas and -2.bas declare every member this way.
''
'' Measured over what a TYPE body accepts:
''
''     dim as T x            a field
''     dim x as T            a field
''     dim as T x(0 to 2)    an array field
''     dim shared as T x     fbc error 3, "Expected End-of-Line, found 'x'"
''     static ... / const ...  declare NO field -- a type holding only those is fbc
''                             error 256, "An ENUM, TYPE or UNION cannot be empty"
''
'' so only DIM is a field declarer here; STATIC and CONST keep going to the declaration
'' parser, which is where a static member belongs.

type A
	dim as integer i, j
end type

type B
	dim i as integer
	dim j as integer
end type

type C
	as byte a
	dim as integer arr(0 to 2)
	as byte b
end type

'' A static member and a constant are NOT fields; this type is 8 bytes, not 24.
type D
	dim as integer i
	const K = 5
	static s as integer
	declare static sub touch( )
end type
dim D.s as integer
sub D.touch( ) : end sub

dim va as A
dim vb as B
dim vc as C
dim vd as D

'' Measured with fbc: 16, 16, 40, 8.
