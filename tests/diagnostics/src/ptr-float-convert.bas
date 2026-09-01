'' A POINTER AND A FLOATING-POINT VALUE DO NOT CONVERT INTO EACH OTHER, in either
'' direction -- fbc error 181. An INTEGER does, which is what makes this a rule about the
'' FLOAT rather than about the pointer, and an explicit cast chain is always allowed.
dim p as byte ptr
dim f as single
dim d as double
dim n as integer

n = p
p = 1
f = cast( single, cast( integer, p ) )
dim okp as byte ptr = 0

f = p
d = p
p = f
p = 1.0
dim badp as byte ptr = 2.5
