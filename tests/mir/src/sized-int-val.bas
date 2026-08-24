'' 'integer<N>' and 'uinteger<N>' are ALIASES for the fixed-width types, and the VAL
'' family has a wide half.
dim as integer<8>   b1
dim as integer<16>  s1
dim as integer<32>  l1
dim as integer<64>  q1
dim as uinteger<8>  b2
dim as uinteger<16> s2
dim as uinteger<32> l2
dim as uinteger<64> q2
print sizeof( integer<8> ), sizeof( integer<16> ), sizeof( integer<32> ), sizeof( integer<64> )
print b1, s1, l1, q1, b2, s2, l2, q2

dim w as wstring * 256
w = wstr( "123" )
dim as longint  v1 = vallng( w )
dim as ulongint v2 = valulng( w )
dim as integer  v3 = valint( w )
dim as uinteger v4 = valuint( w )
dim as double   v5 = val( w )
print v1, v2, v3, v4, v5

'' ...and PRINT of one, which had nothing to print: the VAL family was not in the
'' frontend's type table at all.
print val( w ), vallng( w ), valint( w )
dim as string ns = "42"
print val( ns ), valint( ns ), asc( ns )
