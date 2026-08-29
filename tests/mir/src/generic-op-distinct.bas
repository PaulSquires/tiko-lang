'' TWO GENERIC GLOBAL OPERATORS OF ONE SPELLING over different generics. The
'' instantiation cache was keyed on the operator's NAME plus its type arguments, and at
'' the same T both of these spell "+<1234>" -- so whichever instantiated first claimed
'' the key and the other was handed back the WRONG operator. fb/comptr.bi declares that
'' pair for '->', one over ComPtr and one over ComQIPtr, and 'b->PokeB( )' over a
'' ComQIPtr then had no arrow of its own, the member access stayed untyped, and the
'' statement declined. fbc emits both bodies.
type Holder( of T )
	as T v
end type

type Other( of T )
	as T v
end type

operator + ( of T )( byref a as Holder( of T ), byref b as Holder( of T ) ) as integer
	return 100
end operator

operator + ( of T )( byref a as Other( of T ), byref b as Other( of T ) ) as integer
	return 200
end operator

'' ...AND A GENERIC 'operator ='. 'operator = ( of T )( ... )' was read as a RESULT
'' ASSIGNMENT of the parenthesised expression '( of T )' and failed to parse outright,
'' so the operator was lost -- TKO0401 at the T. Only '=' can begin a result
'' assignment, which is why the '<>' below had always worked.
type Box( of T )
	as T v
end type

operator = ( of T )( byref x as Box( of T ), byref y as Box( of T ) ) as integer
	return x.v = y.v
end operator

operator <> ( of T )( byref x as Box( of T ), byref y as Box( of T ) ) as integer
	return x.v <> y.v
end operator

dim as Holder( of integer ) h1, h2
dim as Other( of integer ) o1, o2
print (h1 + h2), (o1 + o2)

dim as Box( of integer ) b1, b2
b1.v = 3 : b2.v = 3
print (b1 = b2), (b1 <> b2)
