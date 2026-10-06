type T
	myarray(any) as integer
	declare constructor( array() as integer )
	declare constructor()
end type
constructor T()
	print "T()"
end constructor
constructor T( array() as integer )
	print "T(array)"
end constructor
redim o(1 to 3) as T
print "ok"
dim d(1 to 2) as T
print "dim ok"
