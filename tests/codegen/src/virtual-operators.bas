'' virtual operators -- let, cast as string, cast as integer, @ -- dispatch through the vtable
type UDT1 : i as integer : end type
type A extends object
	declare virtual operator let( as UDT1 )
	declare virtual operator cast( ) as string
	declare virtual operator cast( ) as integer
	declare virtual operator @( ) as any ptr
end type
type B extends A
	declare operator let( as UDT1 ) override
	declare operator cast( ) as string override
	declare operator cast( ) as integer override
	declare operator @( ) as any ptr override
end type
operator A.let( rhs as UDT1 ) : end operator
operator B.let( rhs as UDT1 ) : end operator
operator A.cast( ) as string : operator = "A" : end operator
operator B.cast( ) as string : operator = "B" : end operator
operator A.cast( ) as integer : operator = &hA : end operator
operator B.cast( ) as integer : operator = &hB : end operator
operator A.@( ) as any ptr : operator = cptr( any ptr, &hA ) : end operator
operator B.@( ) as any ptr : operator = cptr( any ptr, &hB ) : end operator
dim pa as A ptr = new B
dim s as string
s = *pa
print s
dim i as integer = *pa
print hex(i)
print hex(cint(@*pa))
