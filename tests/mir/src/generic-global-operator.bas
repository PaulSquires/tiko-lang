'' A GENERIC GLOBAL OPERATOR, which was never instantiated at all.
''
''     operator +  ( of T )( byref a as Box( of T ), byref b as Box( of T ) ) as Box( of T )
''     operator *  ( of T )( byref p as Box( of T ) ) byref as T
''     operator -> ( of T )( byref p as Box( of T ) ) byref as T
''
'' are part of the type's interface and are declared beside it, but they are NOT members
'' -- fbc refuses a member arithmetic operator -- so the member instantiation never saw
'' them and nothing else ever did. Overload resolution then costed the UNINSTANTIATED
'' parameter, 'Box( of T )', against the concrete 'Box( of long )', found no candidate,
'' and left the expression untyped; lowering added the two objects as RAW INTEGERS.
'' 542 corpus statements were doing that.
''
'' The trigger is the TYPE's instantiation, because an operator has no call arguments to
'' infer from -- what it has is a parameter pattern naming the generic. The
'' instantiation is then chained under the OPERATOR'S OWN SPELLING as well as under its
'' structural key, because that is what overload resolution looks up.
''
'' '*p' AND 'p->f' ARE SPELLED WITH THE DEREFERENCE AND ARROW TOKENS, so they arrive at
'' the pointer cases rather than the unary one. Both are user operators over a UDT and
'' both are byref, which at the ABI is a POINTER.
type Payload
	as long v
	as long w
end type

type Box( of T )
	as T ptr p
end type

operator + ( of T )( byref a as Box( of T ), byref b as Box( of T ) ) as Box( of T )
	dim as Box( of T ) r
	r.p = a.p
	return r
end operator

operator * ( of T )( byref a as Box( of T ) ) byref as T
	return *a.p
end operator

operator -> ( of T )( byref a as Box( of T ) ) byref as T
	return *a.p
end operator

dim as Payload pay
dim as Box( of Payload ) x, y
x.p = @pay
y.p = @pay

dim as Box( of Payload ) z = x + y
print z.p <> 0

'' Through the dereference operator, and through the arrow.
dim as Payload px = *x
x->v = 11
x->w = 22
print x->v, x->w, px.v
