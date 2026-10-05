type U
    as double v
    declare operator += ( byval x as long )
    declare operator += ( byval x as double )
    declare operator += ( byref s as string )
    declare operator += ( byval x as single )
end type
operator U.+= ( byval x as long ) : print "long"; x : end operator
operator U.+= ( byval x as double ) : print "double"; x : end operator
operator U.+= ( byref s as string ) : print "string "; s : end operator
operator U.+= ( byval x as single ) : print "single"; x : end operator
dim as U a
dim as integer i = 2
dim as short sh = 3
dim as ulongint q = 4
dim as byte b = 5
a += 1
a += i
a += sh
a += q
a += b
a += 1.5
a += 1.5f
a += "x"
dim as string s = "yy"
a += s
dim as zstring * 4 z = "zz"
a += z
