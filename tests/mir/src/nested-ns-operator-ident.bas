'' AN OPERATOR DECLARED ONE NAMESPACE DEEPER THAN THE TYPE IT IS OVER. The candidate
'' heads come from the operand type's DECLARING SCOPE, and Lookup walks OUTWARD -- so an
'' operator nested inside that scope was invisible and 'x + y' declined. fbc finds it
'' with no 'using' at all: measured, it compiles and prints 3, and
'' namespace/mangling-nested-namespace-abbreviation.bas is written exactly this way.
namespace aaa
	type UDT
		as integer v
	end type

	namespace bbb
		operator + ( byref l as aaa.UDT, byref r as aaa.UDT ) as integer
			return l.v + r.v
		end operator
	end namespace
end namespace

dim as aaa.UDT x, y
x.v = 1 : y.v = 2
print (x + y)

'' AN IDENTIFIER IS TRUNCATED AT 128 CHARACTERS, which is fbc's limit and not a
'' formatting nicety: two names that differ only past the boundary ARE THE SAME SYMBOL.
'' Measured, fbc warns 'Identifier's name too big, truncated' at each, assigns through
'' the second spelling and prints 9 through the first. tiko-lang kept them distinct, so
'' the second was an undeclared variable and the assignment declined.
''
'' The warning is NOT emitted -- the lexer has no diagnostic channel for one -- so this
'' accepts silently what fbc accepts noisily.
dim as long aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaX = 7
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaY = 9
print aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaX
