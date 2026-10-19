'' A string intrinsic over a MIXED ustring chain reads the fold's own temporary (TB-010).
dim as ustring u = "abc"
dim as string z = "xy"
dim as long i = 42
print len( u & str( i ) )
print right( u & str( i ), 3 )
print left( str( i ) & u, 3 )
print ucase( u & z )
print mid( u & i, 3, 2 )
print len( u & "-" & str( i ) & "-" & u )
if u & str( i ) = "abc42" then print "eq"
