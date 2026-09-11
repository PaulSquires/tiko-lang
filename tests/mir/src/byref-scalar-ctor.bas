'' BYREF BELONGS TO THE PARAMETER, NOT TO THE TYPE IT REFERS TO.
''
'' The converting-constructor path took an address only for a UDT, so
'' 'constructor UDT( byref rhs as const long )' -- which is how an 'extern "C++"' class
'' spells one -- was handed the VALUE, and clang refused
'' 'call void @_ZN3UDTC1ERKi(ptr %s4, ptr %t11)' against a %t11 defined as i32.
''
'' AND AN RVALUE GETS A TEMPORARY. 'dim c as UDT = 2' has no address to take, and fbc
'' materialises one: measured, 'TMP$ = 2; _ZN3UDTC1ERKi( &C, &TMP$ )'. Without it the
'' lvalue case built and the literal beside it did not.
type UDT
	as long value
	declare constructor( )
	declare constructor( byref rhs as const long )
	declare constructor( byref rhs as const UDT )
end type

constructor UDT( )
	this.value = -1
end constructor

constructor UDT( byref rhs as const long )
	this.value = rhs
end constructor

constructor UDT( byref rhs as const UDT )
	this.value = rhs.value + 100
end constructor

dim as long a = 1

'' an LVALUE for a byref scalar parameter
dim as UDT b = a
print b.value

'' ...and an RVALUE, which needs a temporary
dim as UDT c = 2
print c.value

'' the UDT overload still picks the UDT
dim as UDT d = b
print d.value

dim as UDT e
print e.value
