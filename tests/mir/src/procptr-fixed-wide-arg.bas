'' A FIXED WIDE STRING PASSED THROUGH A PROCEDURE POINTER IS AN ARGUMENT, NOT A SUBSCRIPT.
'' AfxPath.inc calls 'pPathCchRemoveBackslashEx( _wszPath, PATHCCH_MAX_CCH, NULL, NULL )', a
'' 'wstring * N' into a PCWSTR parameter through a FUNCTION pointer variable; tiko reported
'' fbc's error 73, 'an array is not a subscript', because the call has an index's shape.
''
'' And 'LEN( dws )' over a UDT with a user OPERATOR LEN, beside a second type's operator,
'' is not judged against the first operator's parameter (a false TKO0698).
''
'' fbc prints: 2 / 3 / 7
function CountW( byval pw as const wstring ptr ) as long
	return len( *pw )
end function
type AA
	as long n
end type
type BB
	as long n
end type
operator len ( byref x as BB ) as long
	return 3
end operator
operator len ( byref x as AA ) as long
	return 7
end operator
dim as function( byval pw as const wstring ptr ) as long fp = @CountW
dim as wstring * 16 buf = "ab"
print fp( buf )
dim as BB b1
dim as AA a1
print len( b1 )
print len( a1 )
