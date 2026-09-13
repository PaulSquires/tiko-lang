'' LEN OVER A UDT WITH A USER 'OPERATOR LEN' IS TYPED BY THAT OPERATOR. Measured, fbc's
'' typeof( len( a ) ) is UINTEGER for 'operator len( byref x as A ) as uinteger', LONG for one
'' returning LONG, and INTEGER only for the builtin. tiko typed every LEN as INTEGER, so the
'' uinteger printed with a sign space fbc does not emit -- AfxNova's DWSTRING and BSTRING both
'' declare 'OPERATOR LEN ... AS UINT'.
''
'' fbc prints: 100-5 3
type A
	as long n
end type
type B
	as long n
end type
operator len ( byref x as A ) as uinteger
	return 100
end operator
operator len ( byref x as B ) as long
	return -5
end operator
dim as A a1
dim as B b1
dim as string s = "abc"
print len( a1 ); len( b1 ); len( s )
