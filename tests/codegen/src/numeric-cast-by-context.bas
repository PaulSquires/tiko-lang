type V
    as long raw = 200
    declare operator cast( ) as double
    declare operator cast( ) as byte
end type
operator V.cast( ) as byte : return 100 : end operator
operator V.cast( ) as double : return 2.75 : end operator
dim as V x
dim as double dd = 1.5
dim as single ss = 1.5
dim as longint ll = 1
print x + 1; x + dd; x + ss; x + ll; x * 2; x / 2; x \ 2
dim as long k = x
dim as double d = x
dim as single sg = x
dim as byte b = x
print k; d; sg; b; abs( x ); -x; sqr( x ); int( x )
