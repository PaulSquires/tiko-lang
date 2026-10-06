type foo
	bar as integer
	declare constructor()
	declare constructor( v as integer )
end type
constructor foo()
	bar = 1234
end constructor
constructor foo( v as integer )
	bar = v
end constructor
var f1 = foo
print f1.bar
