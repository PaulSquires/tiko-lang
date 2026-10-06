type UDT
	i as integer
	declare operator for( byref stp as UDT )
	declare operator step( byref stp as UDT )
	declare operator next( byref cond as UDT, byref stp as UDT ) byref as integer
end type
operator UDT.for( byref stp as UDT )
	i = 0
end operator
operator UDT.step( byref stp as UDT )
	i += 1
end operator
operator UDT.next( byref cond as UDT, byref stp as UDT ) byref as integer
	static c as integer
	c = (i < 5)
	operator = c
end operator
dim as integer count
dim x as UDT = ( 123 )
for i as UDT = x to x step x
	count += 1
	if count > 20 then exit for
next
print count
