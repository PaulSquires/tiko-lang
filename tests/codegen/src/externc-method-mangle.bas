namespace g1
	extern "c"
		type A extends object
			declare virtual function foo( byval i as integer ) as integer
		end type
		function A.foo( byval i as integer ) as integer
			function = &hA
		end function
	end extern
	type B extends A
		declare function foo cdecl( byval i as integer ) as integer override
	end type
	function B.foo cdecl( byval i as integer ) as integer
		function = &hB
	end function
end namespace
namespace g2
	extern "c"
		type A extends object
			declare virtual function foo( byval i as integer ) as integer
		end type
		function A.foo( byval i as integer ) as integer
			function = &hA1
		end function
	end extern
end namespace
dim p as g1.A ptr = new g1.B
print hex( p->foo( 1 ) )
dim q as g2.A ptr = new g2.A
print hex( q->foo( 1 ) )
