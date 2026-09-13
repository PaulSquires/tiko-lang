'' EIGHT USER CONVERSIONS IN ONE CALL. fbsqlite's test_params writes
'' 'Args( 1LL, 2LL, 3LL, 4LL, 5LL, 6LL, 7LL, 8LL )' against eight 'byval as DbValue'
'' parameters, DbValue having a longint constructor. Each conversion costs CONV_USERDEF
'' (200000) and the best cost STARTED at CONV_NONE (999999), so from the fifth argument on
'' the only viable candidate totalled too much to be kept: TKO0632, no overload matches.
''
'' fbc prints: 28 / 36 / -1
type DbValue
	as longint i
	declare constructor( )
	declare constructor( byval intValue as longint )
	declare constructor( byval realValue as double )
	declare constructor( byval flag as boolean )
	declare constructor( byref textValue as ustring )
end type
constructor DbValue( )
end constructor
constructor DbValue( byval v as longint )
	i = v
end constructor
constructor DbValue( byval v as double )
	i = -1
end constructor
constructor DbValue( byval v as boolean )
	i = -2
end constructor
constructor DbValue( byref v as ustring )
	i = -3
end constructor
function Args overload ( byval a1 as DbValue ) as longint
	return a1.i
end function
function Args ( byval a1 as DbValue, byval a2 as DbValue ) as longint
	return a1.i + a2.i
end function
function Args ( byval a1 as DbValue, byval a2 as DbValue, byval a3 as DbValue ) as longint
	return a1.i + a2.i + a3.i
end function
function Args ( byval a1 as DbValue, byval a2 as DbValue, byval a3 as DbValue, byval a4 as DbValue ) as longint
	return a1.i + a2.i + a3.i + a4.i
end function
function Args ( byval a1 as DbValue, byval a2 as DbValue, byval a3 as DbValue, byval a4 as DbValue, byval a5 as DbValue ) as longint
	return a1.i + a2.i + a3.i + a4.i + a5.i
end function
function Args ( byval a1 as DbValue, byval a2 as DbValue, byval a3 as DbValue, byval a4 as DbValue, byval a5 as DbValue, byval a6 as DbValue ) as longint
	return a1.i + a2.i + a3.i + a4.i + a5.i + a6.i
end function
function Args ( byval a1 as DbValue, byval a2 as DbValue, byval a3 as DbValue, byval a4 as DbValue, byval a5 as DbValue, byval a6 as DbValue, byval a7 as DbValue ) as longint
	return a1.i + a2.i + a3.i + a4.i + a5.i + a6.i + a7.i
end function
function Args ( byval a1 as DbValue, byval a2 as DbValue, byval a3 as DbValue, byval a4 as DbValue, byval a5 as DbValue, byval a6 as DbValue, byval a7 as DbValue, byval a8 as DbValue ) as longint
	return a1.i + a2.i + a3.i + a4.i + a5.i + a6.i + a7.i + a8.i
end function
print Args( 1LL, 2LL, 3LL, 4LL, 5LL, 6LL, 7LL )
print Args( 1LL, 2LL, 3LL, 4LL, 5LL, 6LL, 7LL, 8LL )
print Args( "one", 2LL )
