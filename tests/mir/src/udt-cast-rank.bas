'' WHICH 'operator cast' A UDT OPERAND USES, when it declares several. Taking the FIRST
'' in the chain is a silent miscompile: over a type declaring both 'cast( ) as byte' and
'' 'cast( ) as double', 'show( l + r )' with both operands 100.0 called the BYTE cast and
'' added in i8, so 200 came out as -56. fbc calls the double one and prints 200.
''
'' The order is MEASURED, order-independent, pairwise, with two casts returning 1 and 2
'' so the sum says which ran:
''
''   boolean < byte < ubyte < short < ushort < integer < uinteger
''           < long < ulong < longint < ulongint < single < double
''
'' and it is NOT width. LONG is four bytes and INTEGER eight, and long/integer picks LONG
'' from either declaration order; longint then beats long.
type foo
	as double bar
	declare operator cast ( ) as byte
	declare operator cast ( ) as double
end type

operator foo.cast ( ) as byte
	return cbyte( this.bar )
end operator

operator foo.cast ( ) as double
	return this.bar
end operator

sub show( byval d as double )
	print d
end sub

dim as foo l, r
l.bar = 100.0 : r.bar = 100.0
show( l + r )

'' ...AND THE NODE HAS TO BE TYPED FOR IT. The MIR had done the substitution since it
'' was written, but Check handed BinaryResult the UDT type -- which answers TYPE_NONE --
'' so the node and every call over it were UNTYPED: the call above lowered because the
'' parameter's type supplied the context, and this one declined.
print l + r

type bar2
	as integer v
	declare operator cast ( ) as byte
	declare operator cast ( ) as short
end type

operator bar2.cast ( ) as byte
	return 1
end operator

operator bar2.cast ( ) as short
	return 2
end operator

dim as bar2 p, q
print p + q
