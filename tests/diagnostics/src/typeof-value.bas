'' 'typeof( ... )' WHERE A VALUE IS WANTED is fbc's error 9 (3 inside a PRINT list), on lines
'' 8 to 11 (fbc-modern 1.20). tiko printed nothing for the first two and compared two types
'' for the third. Lines 13 to 17 are type positions, all accepted -- '#assert' included.
dim as long x = 5
dim as string s
dim as long ptr p

print typeof( x )
s = typeof( x )
if typeof( x ) = typeof( long ) then print "same"
x = typeof( long )

x = sizeof( typeof( x ) )
dim as typeof( x ) y = 3
x = cast( typeof( x ), 2.7 )
p = cptr( typeof( @x ), @y )
#assert typeof( x ) = typeof( long )
