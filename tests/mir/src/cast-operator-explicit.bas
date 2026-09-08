'' EXPLICIT 'cast( T, u )' OVER A UDT WITH 'operator cast'.
''
'' The IMPLICIT direction -- 'dim as integer r = x' -- already called the operator.
'' The explicit spelling reached the conversion intrinsic instead, which asked a UDT
'' for a value it has not got: 'emit: ICE: an aggregate value with no size'.
''
'' Measured from what fbc emits, and the two overloads are chosen by the type the cast
'' NAMES, not by rank:
''
''     cast( integer, x )   int64  vr$2 = _ZN1Vcvu7INTEGEREv( &X$0 )
''     dim as integer r = x int64  vr$4 = _ZN1Vcvu7INTEGEREv( &X$0 )
''     cast( integer, p )   int64  vr$7 = _ZN4PAIRcvu7INTEGEREv( &P$0 )
''     cast( double,  p )   double vr$9 = _ZN4PAIRcvdEv( &P$0 )
''
'' fbc REJECTS a cast to a type no overload yields -- 'cast( double, x )' over a type
'' declaring only the integer conversion is 'error 20: Type mismatch' -- so the exact
'' overload is the only one an accepted cast can mean. Run under fbc: 50 50 8 7.5.
type V
    as integer a
    declare operator cast ( ) as integer
end type

operator V.cast ( ) as integer
    operator = this.a * 10
end operator

'' TWO CONVERSIONS ON ONE TYPE. Ranking alone -- which is right for the implicit
'' promotion 'l + r' and is what UserCastToNum_ does -- called the DOUBLE operator for
'' both spellings and then rounded its result back.
type Pair
    as integer a
    declare operator cast ( ) as integer
    declare operator cast ( ) as double
end type

operator Pair.cast ( ) as integer
    operator = this.a + 1
end operator

operator Pair.cast ( ) as double
    operator = this.a + 0.5
end operator

dim as V x
x.a = 5
print cast( integer, x )

dim as integer r = x
print r

dim as Pair p
p.a = 7
print cast( integer, p )
print cast( double, p )
