'' A COMPOUND ASSIGNMENT OVER A TYPE WITH A NUMERIC 'operator cast' AND AN 'operator let', and no
'' self-operator: the cast, the arithmetic in its own type, and the let. tiko dropped each in
'' silence. A member '+=' still wins where there is one (P), a double type works in double (D),
'' and the target is addressed once -- f runs once. Measured, fbc-modern prints PletP+=  201,
'' PcastPlet  200, 4.5, 1.125, f  15, 3, 9 and 0, one per line.
type P
    v as long
    declare operator let( byval x as long )
    declare operator cast( ) as long
    declare operator += ( byval x as long )
end type
operator P.let( byval x as long ) : print "Plet"; : v = x : end operator
operator P.cast( ) as long : print "Pcast"; : return v : end operator
operator P.+= ( byval x as long ) : print "P+="; : v += x * 100 : end operator
type D
    d as double
    declare operator let( byval x as double )
    declare operator cast( ) as double
end type
operator D.let( byval x as double ) : d = x : end operator
operator D.cast( ) as double : return d : end operator
type M
    v as long
    declare operator let( byval x as long )
    declare operator cast( ) as long
end type
operator M.let( byval x as long ) : v = x : end operator
operator M.cast( ) as long : return v : end operator
function f( ) as integer
    print "f";
    return 1
end function
dim as P p1 : p1 = 1 : p1 += 2 : print " "; p1.v
p1 -= 1 : print " "; p1.v
dim as D d1 : d1 = 1.5 : d1 *= 3 : print d1.d
d1 /= 4 : print d1.d
dim as M ma( 2 ) : ma( 1 ) = 5 : ma( f( ) ) += 10 : print " "; ma( 1 ).v
ma( 1 ) \= 4 : print ma( 1 ).v
ma( 1 ) ^= 2 : print ma( 1 ).v
ma( 1 ) mod= 3 : print ma( 1 ).v
