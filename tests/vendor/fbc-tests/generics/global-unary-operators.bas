' TEST_MODE : COMPILE_AND_RUN_OK

'' Generic global UNARY operators.
''
''     operator -  ( of T )( byref b as Box( of T ) ) as Box( of T )
''     operator *  ( of T )( byref h as Handle( of T ) ) byref as T
''     operator -> ( of T )( byref h as Handle( of T ) ) byref as T
''
'' The companion to global-operators.bas, which covers only the binary form.
''
'' A generic global operator registers nothing in symb.globOpOvlTb until it is
'' instantiated, and it cannot be instantiated until the operand type is known.
'' That is what genTryInstantiateGlobalOp does at the use site -- but it used to
'' be called from exactly one place, the BOP path (ast-node-bop.bas).  Every
'' unary dispatch site tested globOpOvlTb( op ).head against NULL, found the
'' table empty and reported "Expected pointer" or fell through to the built-in
'' operator, so NO generic global unary operator worked.  Three sites now call
'' it: astNewUOP (ast-node-uop.bas), astBuildMultiDeref (ast-helper.bas) and the
'' '->' branch of cUdtMemberDeref (parser-expr-variable.bas).
''
'' The second half of this test is the arity ambiguity.  '*', '-' and '+' are
'' spelled the same unary and binary.  cGenericOpDecl records the op from the
'' TOKEN, before a parameter list exists, so a generic 'operator *' is filed
'' under AST_OP_MUL even when it is a deref -- unlike the concrete path, which
'' rewrites by arity in cProcHeader once the params are known.  So the lookup
'' offers the alias and lets the arity test in hTryOneGlobalOp decide.  Both
'' forms of '*' and '-' are declared below, over the same type, to pin that a
'' unary use never picks the binary operator or the reverse.

#define assert_(e) if (e) = 0 then fb_Assert(__FILE__, __LINE__, __FUNCTION__, #e)

type Payload
	as long v
end type

type Box( of T )
	as T v
end type

type Handle( of T )
	as T ptr p
end type

'' ---------------------------------------------------- the ordinary unary path
''
'' astNewUOP.  AST_OP_NEG, reached through the AST_OP_SUB alias.

operator - ( of T )( byref b as Box( of T ) ) as Box( of T )
	dim as Box( of T ) r
	r.v = 100 - b.v
	return r
end operator

'' the BINARY '-' over the same type, to prove arity picks them apart
operator - ( of T )( byref x as Box( of T ), byref y as Box( of T ) ) as Box( of T )
	dim as Box( of T ) r
	r.v = x.v - y.v
	return r
end operator

'' NOT has no binary spelling, so it is the unambiguous control
operator not ( of T )( byref b as Box( of T ) ) as Box( of T )
	dim as Box( of T ) r
	r.v = -b.v
	return r
end operator

'' ------------------------------------------------------------- the deref path
''
'' astBuildMultiDeref.  AST_OP_DEREF, reached through the AST_OP_MUL alias.
'' BYREF so that '*h' is an lvalue and a write through it lands in the pointee.

operator * ( of T )( byref h as Handle( of T ) ) byref as T
	return *h.p
end operator

'' the BINARY '*' over the same type
operator * ( of T )( byref x as Box( of T ), byref y as Box( of T ) ) as Box( of T )
	dim as Box( of T ) r
	r.v = x.v * y.v
	return r
end operator

'' ---------------------------------------------------------------- the -> path
''
'' cUdtMemberDeref.  AST_OP_FLDDEREF is a single token, so there is no alias to
'' resolve; the return type must be a STRUCT (parser-proc.bas:881), which is why
'' this one is instantiated over Payload and not over a scalar.

operator -> ( of T )( byref h as Handle( of T ) ) byref as T
	return *h.p
end operator

	'' ------------------------------------------------------------ unary minus

	dim as Box( of integer ) b1
	b1.v = 40
	assert_( (-b1).v = 60 )

	'' binary minus, same operator name, same operand type
	dim as Box( of integer ) b2
	b2.v = 15
	assert_( (b1 - b2).v = 25 )

	'' and unary applied to the result of the binary
	assert_( (-(b1 - b2)).v = 75 )

	'' ------------------------------------------------------------------- NOT

	assert_( (not b1).v = -40 )

	'' -------------------------------------------------------- unary deref '*'

	dim as Payload pl
	pl.v = 7
	dim as Handle( of Payload ) h
	h.p = @pl

	assert_( (*h).v = 7 )

	'' BYREF return: a write through the deref must reach the pointee
	(*h).v = 9
	assert_( pl.v = 9 )

	'' binary '*', same operator name, different operand type
	dim as Box( of integer ) b3, b4
	b3.v = 6 : b4.v = 7
	assert_( (b3 * b4).v = 42 )

	'' ---------------------------------------------------------------- '->'

	assert_( h->v = 9 )

	h->v = 11
	assert_( pl.v = 11 )

	'' ------------------------------------------------- a second, distinct T

	dim as Box( of double ) d1
	d1.v = 25.0
	assert_( (-d1).v = 75.0 )

	'' ------------------------------------------------------ cache, not new
	''
	'' the second identical use must reach the SAME instantiation; a second
	'' one would be a duplicate definition at link time
	assert_( (-b1).v = 60 )
	assert_( (*h).v = 11 )
	assert_( h->v = 11 )
