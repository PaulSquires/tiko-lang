dim as long l = 3
dim as typeof( l * 1000000000 ) y = 3000000000
print y
print iif( 1, "a", "b" ); iif( 0, 1, 2.5 ); iif( 1, 1ll, 2 )
dim as integer q = iif( 1, cbyte(1), 300 )
print q
dim as typeof( (l) ) z = 5
print z
