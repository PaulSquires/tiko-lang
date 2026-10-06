'' a constructor/destructor declared 'alias' a method's name is that method
dim shared as integer inits, cleanups
type UDT
	i as integer
	declare sub init cdecl alias "init"( )
	declare constructor cdecl alias "init"( )
	declare sub cleanup cdecl alias "cleanup"( )
	declare destructor cdecl alias "cleanup"( )
end type
sub UDT.init cdecl alias "init"( )
	inits += 1
end sub
sub UDT.cleanup cdecl alias "cleanup"( )
	cleanups += 1
end sub
scope
	dim x as UDT
	print inits, cleanups
end scope
print inits, cleanups
