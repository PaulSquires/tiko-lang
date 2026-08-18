' TEST_MODE : COMPILE_ONLY_OK

'' Everything '(' already meant, asserted to still mean it.
''
'' This is the file that gates the tuple LITERAL. '(' introduces a grouped
'' expression, a call argument list and an array subscript list, and a comma is
'' already legal inside one of them -- so a fourth meaning is only safe if every
'' line below still compiles and still means what it meant.
''
'' The whole separation rests on one condition in cParentExpression()
'' (parser-expr-atom.bas): a comma is a tuple only when 'is_opt' is FALSE.
'' 'is_opt' is TRUE exactly for the paren-less SUB call, where the parens belong
'' to the CALL. Line 's2 (1, 2)' below is that case, and it must stay two
'' arguments rather than becoming one tuple.
''
'' See docs/tuples/RFC-0002-tuple-values.md section 2.

declare sub s1( byref x as long )
declare sub s2( byval x as long, byval y as long )

type T
	as long f
end type

	dim a as long
	dim b as long
	dim p as long ptr
	dim arr(1 to 3, 1 to 3) as long
	dim x as T
	dim pfn as sub( byref as long ) = @s1

	p = @a

	'' a parenthesised lvalue -- legal in every dialect, and the reason there
	'' is no 1-tuple
	(a) = 5
	(*p) = 5
	(arr(1,1)) = 5
	(x).f = 1

	'' the byval-override idiom: arity 1, still a grouped expression
	s1( (a) )

	'' a parenthesised NON-lvalue used as a function-pointer call. A statement
	'' starting with '(' is claimed by the tuple parser, which therefore has to
	'' parse the first item as an expression rather than an lvalue and hand it
	'' straight back. Parsing it as an lvalue broke tests/expressions/iif.bas.
	(iif( a, @s1, @s1 ))( b )
	(pfn)( b )

	'' the paren-less SUB call: TWO arguments, not one tuple
	s2 (1, 2)
	s2( 1, 2 )

	'' grouped expressions in quirk statements
	print (a)
	print (a) + (b)
	print sizeof( (a) )
	print arr(1, 2)

	'' graphics quirks match their own '(' and never reach the expression
	'' parser's paren handler
	screenres 320, 200
	pset (10, 20)
	line (0, 0)-(10, 10)
	circle (10, 10), 5

	end

sub s1( byref x as long )
end sub

sub s2( byval x as long, byval y as long )
end sub
