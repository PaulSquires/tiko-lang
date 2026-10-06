function p overload( byref z as const wstring ) as string
	return "wstring"
end function
function p( byref s as const string ) as string
	return "string"
end function
type TW
	__ as integer
	declare operator cast() byref as wstring
end type
operator TW.cast() byref as wstring
	static w1 as wstring * 20 = "123"
	return w1
end operator
type TZ
	__ as integer
	declare operator cast() byref as zstring
end type
operator TZ.cast() byref as zstring
	static z1 as zstring * 20 = "123"
	return z1
end operator
dim w as TW, z as TZ
print p( w ), p( z )
