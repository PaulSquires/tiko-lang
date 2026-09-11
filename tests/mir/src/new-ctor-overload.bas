'' 'new T( v )' PICKS ITS CONSTRUCTOR BY ARGUMENT TYPE, NOT BY ARITY.
''
'' CtorOf_ took the first constructor in the overload chain with that arity, so a type
'' with both 'constructor( byval x as long )' and 'constructor( byref o as P )' was
'' decided by WHICH WAS DECLARED FIRST. With the copy constructor last, 'new P( v )'
'' loaded v as a value for the long parameter and then fell out of the lowering
'' entirely: no constructor call, no result, and 'ret void' in a 'func ptr'.
''
'' AND A BYREF UDT PARAMETER TAKES AN ADDRESS. A reference is transparent to TypeOf_,
'' so the parameter's typeref answers with the REFERENT and the copy was passed as a
'' loaded aggregate: clang's "defined with type [4 x i8] but expected ptr".
''
'' fb/sharedptr.bi's MakeSharedFrom is 'new T( v )' over exactly this shape.
type P
	as long v
	declare constructor( )
	declare constructor( byval x as long )
	declare constructor( byref o as P )
end type

constructor P( )
end constructor

constructor P( byval x as long )
	this.v = x
end constructor

constructor P( byref o as P )
	this.v = o.v
end constructor

function MkA( of T )( byref v as T ) as T ptr
	return new T( v )
end function

dim as P seed = P( 7 )
dim as P ptr a = MkA( of P )( seed )
print a->v
