#define ZZ( m ) (m)
namespace Locals
	declare sub q( byval ZZ as long )
	sub s( )
		scope
			const ZZ = 2
			print ZZ
		end scope
		dim as long ZZ = 3
		print ZZ
	end sub
	sub p( byval ZZ as long )
		print ZZ
	end sub
end namespace
namespace Member
	const ZZ = 1
	sub r( )
		print ZZ
	end sub
end namespace
sub Locals.q( byval ZZ as long )
	dim as long y = ZZ
	print y
end sub
type T
	as long ZZ
	declare sub m( byval ZZ as long )
	declare sub k( )
end type
sub T.m( byval ZZ as long )
	print ZZ
end sub
sub T.k( )
	dim as long ZZ = 4
	print ZZ
end sub
