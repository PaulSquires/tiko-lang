enum TE
    e1 = -4
    e2 = 7
end enum
dim as TE ve = e1
print abs( ve ); int( ve ); fix( ve ); frac( ve ); sgn( ve ); sqr( e2 ); abs( e2 )
dim as integer r = abs( ve ) + int( e2 )
print r
print "end"
