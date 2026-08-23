'' A statement whose head is a KEYWORD-led expression rather than a name. tiko-lang's
'' dispatcher only started a statement at an identifier; fbc allows any assignable
'' expression, and parses several it then rejects semantically.
''
'' Measured against fbc:
''
''   let (a, b) = f( )      legal in -lang fb
''   let a = 5              fbc error 146 -- ONLY the parenthesised form exists here
''   let (a) = 5            PARSES, then fbc error 24
''   cast( U, x ).i = 5     legal
''   cptr( short ptr, p ) += 1   legal
''   cuint( g( ) )          legal, a bare discard
''   mid( s, 1, 1 ) = "H"   legal, and the 2-argument form too
''   strptr( s ) = 0        PARSES, then fbc error 119
''
'' The two that fbc rejects still have to PARSE, or the rejection happens in the wrong
'' pass and those corpus goldens can never match.

type U
	i as long
end type

type P
	x as long
	y as long
end type

function GetP( ) as P
	dim r as P
	r.x = 1
	r.y = 2
	return r
end function

function One( ) as long
	return 1
end function

dim as long a, b
dim x as U
dim s as string = "abc"
dim p as short ptr

let (a, b) = GetP( )
cast( U, x ).i = 5
cptr( short ptr, p ) += 1
cuint( One( ) )
mid( s, 1, 1 ) = "H"
mid( s, 2 ) = "ZZ"
strptr( s ) = 0
