'' A VALUE OF A TYPE WITH NO COPY INITIALISES ANOTHER THROUGH A CONSTRUCTOR: V has no copy
'' constructor and nothing an implicit one would be made for, so fbc resolves V's constructors
'' with the V value as the argument, and 'constructor( byval as integer )' wins through
'' 'operator cast as double' -- cast, then construct, where tiko copied. Every line expected by
'' tests/codegen/cast-ctor-init-run.test is fbc-modern 1.20's.
type V
    as integer x
    declare constructor( byval a as integer )
    declare operator cast( ) as double
end type
constructor V( byval a as integer )
    print "ctor"; a
    x = a
end constructor
operator V.cast( ) as double
    print "cast"
    return x + 0.5
end operator
operator + ( byref a as V, byref b as V ) as V
    return V( a.x + b.x )
end operator
function mk( byval n as integer ) as V
    return V( n )
end function
function retVar( byref src as V ) as V
    return src
end function

'' A default constructor beside it changes nothing: still cast, then construct.
type D
    as integer x
    declare constructor( )
    declare constructor( byval a as integer )
    declare operator cast( ) as double
end type
constructor D( )
    print "D()"
end constructor
constructor D( byval a as integer )
    print "D("; a; ")"
    x = a
end constructor
operator D.cast( ) as double
    return x + 0.5
end operator

'' A copy constructor, or a string field (an implicit one), makes it a COPY again.
type C
    as integer x
    declare constructor( byval a as integer )
    declare constructor( byref o as C )
    declare operator cast( ) as double
end type
constructor C( byval a as integer )
    x = a
end constructor
constructor C( byref o as C )
    print "C copy"
    x = o.x
end constructor
operator C.cast( ) as double
    return x + 0.5
end operator
type S
    as integer x
    as string s
    declare constructor( byval a as integer )
    declare operator cast( ) as double
end type
constructor S( byval a as integer )
    x = a
end constructor
operator S.cast( ) as double
    return x + 0.5
end operator

type W
    as V v = mk( 5 )
end type

dim shared as V gp = V( 1 )
dim shared as V gr = gp
print "shared"; gr.x
dim as V p = V( 1 ), q = V( 2 )
print "--"
dim as V r1 = p + q
print "r1"; r1.x
dim as V r2 = p
print "r2"; r2.x
dim as V r3 = mk( 7 )
print "r3"; r3.x
var r4 = p + q
print "r4"; r4.x
dim as V r5 = retVar( p )
print "r5"; r5.x
dim as V r6 = V( 5 )
print "r6"; r6.x
dim as W holder
print "w"; holder.v.x
dim as D d1 = D( 3 )
dim as D d2 = d1
print "d2"; d2.x
dim as C c1 = C( 3 )
dim as C c2 = c1
print "c2"; c2.x
dim as S s1 = S( 3 )
dim as S s2 = s1
print "s2"; s2.x
