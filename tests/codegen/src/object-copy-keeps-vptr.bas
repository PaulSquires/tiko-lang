type A extends object
	a as string
	declare virtual function f( ) as string
end type
function A.f( ) as string
	function = "A's f"
end function
function getvptr( byval p as any ptr ) as any ptr
	return *cptr( any ptr ptr, p )
end function
sub checkO( byval xo as object, byval v as any ptr )
	print "param", getvptr( @xo ) = v
end sub
dim as object xo
dim as A xa
dim as any ptr vo = getvptr( @xo ), va = getvptr( @xa )
xo = xa : print getvptr( @xo ) = vo
xo = type<A>( ) : print getvptr( @xo ) = vo
cast( object, xa ) = xo : print getvptr( @xa ) = va
checkO( xa, vo )
checkO( type<A>( ), vo )
scope
	dim as object n1 = xa : print "dim", getvptr( @n1 ) = vo
end scope
