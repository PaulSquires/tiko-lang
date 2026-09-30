'' Overloads that differ only in array rank are separate slots, each overridden by its own.
type A extends object
	declare virtual function f( array(any) as integer ) as integer
	declare virtual function f( array(any, any) as integer ) as integer
end type
function A.f( array(any) as integer ) as integer
	function = 1
end function
function A.f( array(any, any) as integer ) as integer
	function = 2
end function
type B extends A
	declare function f( array(any, any) as integer ) as integer override    '' fine
	declare function f( array(any) as integer ) as integer override         '' fine
end type
function B.f( array(any) as integer ) as integer
	function = 3
end function
function B.f( array(any, any) as integer ) as integer
	function = 4
end function
type C extends A
	declare function f( array(any, any, any) as integer ) as integer override
end type
