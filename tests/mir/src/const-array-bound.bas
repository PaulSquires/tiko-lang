'' A FIXED ARRAY WHOSE BOUND IS A NAMED CONSTANT. ConstOf answers "unknown" for every
'' identifier when it is handed no symbol table, and the array-bound folder passed none
'' -- so 'dim a(0 to N)' had an unknown bound and became a DYNAMIC array. That is not a
'' decline: the declaration reserved a 72-byte DESCRIPTOR THAT NOTHING EVER
'' INITIALISES, so every element access dereferenced a garbage data pointer, with 0
'' statements not lowered and verify ok. fbc writes 'static int32 T$[3];' and, run,
'' prints ' 0 2 10 20 30'.
const N = 2
dim shared as long t(0 to N)
t(0) = 10 : t(1) = 20 : t(2) = 30
print lbound(t); ubound(t); t(0); t(1); t(2)

'' An ENUM MEMBER is the same shape, and it is how the corpus spells the bound of a
'' table indexed by that enum.
enum Op
	OP_ADD
	OP_SUB
	OP__COUNT
end enum

dim shared as zstring * 4 optext(0 to OP__COUNT - 1) = { " + ", " - " }
print optext(0); optext(1)

'' A LOCAL one, whose bound is a const in an enclosing scope rather than at module level.
sub s( )
	const M = 3
	dim as long u(1 to M)
	u(3) = 9
	print ubound(u); u(3)
end sub
s( )
