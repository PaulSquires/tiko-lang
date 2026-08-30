'' FRAC HAD NO RESULT TYPE, and PRINT classifies an item by its type. So
'' 'print frac( d )' declined the WHOLE statement while 'dim as double r = frac( d )'
'' lowered -- that one is typed by its DESTINATION, so the missing row never showed.
'' The lowering itself was there all along.
''
'' Measured: '#print typeof( frac( x ) )' is INTEGER for every integer width, SINGLE for
'' a single and DOUBLE for a double -- the same row abs, int and fix are in.
dim as double d = -2.7
dim as single s = -2.7
dim as long l = -5
dim as integer i = 3

print fix( d ); fix( s )
print frac( d ); frac( s ); frac( i )
print sgn( d ); sgn( s ); sgn( l )

dim as double r = frac( d )
print r
