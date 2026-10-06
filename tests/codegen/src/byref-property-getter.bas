type UDT
	i as integer
	declare property f( ) byref as integer
	declare property f( byval as integer )
end type
property UDT.f( ) byref as integer
	return this.i
end property
property UDT.f( byval j as integer )
	this.i = j
end property
dim x as UDT
x.i = 123
print x.f, @x.f = @x.i
x.f = 124
print x.i, x.f
