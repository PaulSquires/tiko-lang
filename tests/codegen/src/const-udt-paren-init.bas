type T1
	i as integer
end type
type T2 extends T1
end type
function f overload( byval x1 as const T1 ) as string : function = "1" : end function
function f overload( byval x2 as const T2 ) as string : function = "2" : end function
dim cx1 as const T1 = (1)
dim cx2 as const T2 = ((2))
print f( cx1 ), f( cx2 ), cx1.i, cx2.i
dim y1 as T1 = (5)
print y1.i
