'' A TUPLE COMPARES ONLY IF EVERY ELEMENT DOES, and a UDT element needs the operator
'' written for that comparison over two of itself -- fbc-modern 1.20, 2026-09-25. fbc
'' refuses lines 18, 19, 20 and 21 (error 20) and accepts 22 and 23. tiko emitted calls
'' to operators that do not exist, and clang refused the module.
type V
    as long x
    declare operator cast( ) as string
end type
operator V.cast( ) as string : return str( x ) : end operator
operator = ( byref l as V, byref r as V ) as integer : return l.x = r.x : end operator
type W
    as long x
end type
operator <> ( byref l as W, byref r as W ) as integer : return l.x <> r.x : end operator
dim as (V, long) v1, v2
dim as (W, long) w1, w2
dim as (long, (V, long)) n1, n2
print v1 <> v2
print w1 = w2
print n1 <> n2
if v1 <> v2 then print "x"
print v1 = v2
print w1 <> w2
