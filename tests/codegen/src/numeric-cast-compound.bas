type V
    as long raw = 200
    declare operator cast( ) as byte
    declare operator cast( ) as double
end type
operator V.cast( ) as byte : return 100 : end operator
operator V.cast( ) as double : return 2.75 : end operator
dim as V x
print x + 1
print x * 2
dim as double d = x
print d
dim as long k = x
print k
print abs( x )
print -x
dim as integer q = 5
q += x
print q
