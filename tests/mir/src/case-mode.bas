'' UCASE / LCASE take a CASE MODE, and it is written -- narrow and wide alike.
dim as string s = "AbC"
dim as string t
dim as wstring * 8 w
dim as wstring * 8 v
v = wstr( "AbC" )

t = ucase( s, 1 )
t = lcase( s, 1 )
t = ucase( s )
w = ucase( v, 1 )
w = lcase( v, 1 )
w = ucase( v )
print t, w

'' ...and 'string * N' is subscripted like a zstring: a byte, unsigned.
dim as string * 4 one
dim as string * 1 arr( 0 to 1 )
one[0] = 67
arr(1)[0] = 65
print one[0], arr(1)[0]
