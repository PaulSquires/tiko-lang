'' Unsigned subscripts narrower than the index, on static arrays. See the .test.
dim as integer tbl( 0 to 255 )
tbl( 158 ) = 7
dim as ubyte buf( 0 to 0 ) = { &h9E }
dim as ubyte ptr q = @buf( 0 )
dim as ubyte b = q[0]
print "ubyte"; tbl( b ); tbl( q[0] ); tbl( buf( 0 ) )
dim as integer big( 0 to 65535 )
big( 40000 ) = 5
dim as ushort us = 40000
print "ushort"; big( us )
dim as integer grid( 0 to 255, 0 to 1 )
grid( 200, 1 ) = 9
dim as ubyte r = 200
print "2-d"; grid( r, 1 )
