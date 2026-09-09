'' '##_' AT THE END OF A MACRO BODY -- see tests/mir/line-join-body.test for the
'' measurements. Three shapes in one file: a two-line #macro body whose LAST line
'' ends in '##_', the same joined out of nested macros, and the static aggregate
'' initialiser that pp/token-pasting.bas builds out of both.

type ME
	id as integer
	pA as integer
end type

'' 1. A TWO-LINE BODY. The join eats the INVOCATION's end of line, never the body's
''    own separator between line one and line two.
#macro TWOLINE()
dim y as integer = 9
dim x as integer = 1 + ##_
#endmacro

sub s1( )
	TWOLINE()
	2 + 3
	print x, y
end sub

'' 2. THE SAME, INVOKED FROM INSIDE ANOTHER MACRO. What is eaten is the end of the
''    line the invocation sits on, which here is a line of OUTER's body.
#macro OUTER()
TWOLINE()
4 + 5
#endmacro

sub s2( )
	OUTER()
	print x, y
end sub

'' 3. pp/token-pasting.bas's own shape: a '#macro' body opening a brace list with
''    '##_', a '#define' contributing one element per invocation with '##_', and a
''    '#macro' closing it -- one STATIC declaration with an ELLIPSIS bound.
#macro BEGIN_ENTRIESMAP()
function GetMapEntries( ) as ME ptr
	static as ME _entries(0 to ...) = { ##_
#endmacro
#macro END_ENTRIESMAP()
	(0, 0)}
	return @_entries(0)
end function
#endmacro
#define ENTRY(x, y) (x, y), ##_

#macro GENMAP()
BEGIN_ENTRIESMAP()
ENTRY(1, 2)
ENTRY(3, 4)
ENTRY(5, 6)
END_ENTRIESMAP()
#endmacro

GENMAP()

'' 4. The neighbours of that declaration, all four measured against fbc and all four
''    already lowering before this change: the ellipsis bound on a NON-static local
''    and on a module-level 'dim shared', and an EXPLICIT bound either way.
dim shared as ME g(0 to ...) = { (7, 8), (9, 10) }

sub s4( )
	dim as ME a(0 to ...) = { (1, 2), (3, 4), (5, 6), (0, 0) }
	static as ME b(0 to 3) = { (1, 2), (3, 4), (5, 6), (0, 0) }
	dim as ME c(0 to 1) = { (11, 12), (13, 14) }
	print a(1).pA, b(2).id, c(1).id
end sub

s1( )
s2( )
dim p as ME ptr = GetMapEntries( )
print p[0].id, p[1].pA, p[3].id
print g(1).pA
s4( )
