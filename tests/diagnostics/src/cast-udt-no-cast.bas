'' cast-udt-no-cast.bas -- 'cast( T, x )' over a UDT with NO 'operator cast' at all: fbc-modern 1.20's
'' error 20 on lines 7-10 (28 on 11, a pointer). Check left it to lowering, which declined (TKO0994).

type T : a as integer : end type
dim as T t

print cast( integer, t )
print cint( t )
dim as integer i = cast( integer, t )
print cast( double, t )
print cast( any ptr, t )
