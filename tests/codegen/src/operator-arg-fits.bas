'' Member operators given operands they DO take, through standard conversions -- the
'' neighbours of tests/diagnostics/src/operator-arg-nofit.bas, which must keep compiling.
type V
    as long a
end type
type W
    as long z
    declare operator [] ( byval i as long ) as V
    declare operator [] ( byref s as string ) as long
    declare operator let ( byval n as double )
    declare operator += ( byval n as long )
end type
operator W.[] ( byval i as long ) as V
    return type<V>( i * 2 )
end operator
operator W.[] ( byref s as string ) as long
    return len( s )
end operator
operator W.let ( byval n as double )
    z = n
end operator
operator W.+= ( byval n as long )
    z += n
end operator
type P
    as long a
end type
operator * ( byref p as P ) as long
    return p.a + 5
end operator
dim as W ww
print ww[3].a, ww["abcd"]
dim as zstring * 8 zz = "xy"
print ww[zz]
dim as short sh = 9
print ww[sh].a
ww = 5
ww += 2
print ww.z
ww = 2.5
ww += sh
print ww.z
dim as P pp
pp.a = 1
print *pp
