'' Every access here is in range, under -exx: the checks must not fire.
dim as long a( ), m( )
redim a( -2 to 2 )
for i as long = -2 to 2
    a( i ) = i * 10
next
redim m( 1 to 2, 1 to 3 )
m( 2, 3 ) = 99
redim preserve a( -2 to 0 )
print a( -2 ); a( 0 ); m( 2, 3 )
