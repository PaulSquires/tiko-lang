'' 'cast( T, x )' OVER A UDT NEEDS A CAST YIELDING EXACTLY T. Measured on fbc-modern over M1
'' casting to long and M2 to long and double: lines 18, 19 and 21 are error 20; 17 and 20
'' compile.
type M1
    as long q
    declare operator cast( ) as long
end type
operator M1.cast( ) as long : return q : end operator
type M2
    as long q
    declare operator cast( ) as long
    declare operator cast( ) as double
end type
operator M2.cast( ) as long : return q : end operator
operator M2.cast( ) as double : return q : end operator
dim as M1 a : dim as M2 b
print cast( long, a )
print cast( integer, a )
print cast( double, a )
print cast( double, b )
print cast( single, b )
