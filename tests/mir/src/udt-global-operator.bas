'' A GLOBAL OPERATOR OVER A UDT, declared with CONST OPERANDS.
''
'' 'byref lhs as const U' is the natural way to declare an operand a procedure will not
'' write -- it is how fbc's own headers and cpp/bop-fbc.bas declare every one of them --
'' and 'U' and 'const U' are distinct TypeIds. So the parameter scored CONV_NONE against
'' its own type, the overload was never found, and 'r = a + b' declined with the operator
'' sitting right there.
''
'' Whether a CONST argument may bind to a NON-const byref parameter is a separate
'' question that nothing models either way yet; this only stops const from hiding an
'' exact match.
type U
	value as long
end type

declare operator + ( byref lhs as const U, byref rhs as const U ) as U
declare operator - ( byref lhs as const U, byref rhs as const U ) as U

operator + ( byref lhs as const U, byref rhs as const U ) as U
	dim as U t
	t.value = lhs.value + rhs.value
	return t
end operator

operator - ( byref lhs as const U, byref rhs as const U ) as U
	dim as U t
	t.value = lhs.value - rhs.value
	return t
end operator

dim as U a, b, r
a.value = 7
b.value = 2
r = a + b
print r.value
r = a - b
print r.value

'' ...and with a CONST operand on the left, which is what the declaration says it takes.
dim as const U ca = a
r = ca + b
print r.value
