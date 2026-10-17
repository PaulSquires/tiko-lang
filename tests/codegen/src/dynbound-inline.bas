'' LBOUND / UBOUND over every kind of array, every dimension form: a DYNAMIC array (a local,
'' 'any' or not, one and three dimensions), a BYREF array parameter, a FIXED array and fields
'' fixed and dynamic, through a pointer too; a constant dimension of 0, 1, past the rank and
'' negative, and one only known at run time (G); an array unallocated, allocated and erased.
'' Expected output is fbc-modern's.
type TF
    x(1 to 4) as long
    y(any) as long
    z(any, any) as long
end type

function G( byval n as integer ) as integer
    return n
end function

sub ShowP( a() as long, byref tag as string )
    print tag; " p:"; lbound(a); ubound(a); lbound(a,0); ubound(a,0); lbound(a,1); ubound(a,1); lbound(a,2); ubound(a,2); lbound(a,3); ubound(a,3); lbound(a,-1); ubound(a,-1); lbound(a,9); ubound(a,9); "|"
    for d as integer = -1 to 3
        print " v"; d; ":"; lbound(a, G(d)); ubound(a, G(d));
    next
    print "|"
end sub

dim d0() as long
print "d0 unalloc:"; lbound(d0); ubound(d0); lbound(d0,0); ubound(d0,0); lbound(d0,1); ubound(d0,1); lbound(d0,2); ubound(d0,2); lbound(d0,-1); ubound(d0,-1); "|"
ShowP d0(), "d0"
redim d0(3 to 9)
print "d0 3..9:"; lbound(d0); ubound(d0); lbound(d0,0); ubound(d0,0); lbound(d0,1); ubound(d0,1); lbound(d0,2); ubound(d0,2); lbound(d0,-1); ubound(d0,-1); "|"
ShowP d0(), "d0"
erase d0
print "d0 erased:"; lbound(d0); ubound(d0); lbound(d0,0); ubound(d0,0); "|"

dim d1(any) as long
print "d1 unalloc:"; lbound(d1); ubound(d1); lbound(d1,0); ubound(d1,0); lbound(d1,1); ubound(d1,1); lbound(d1,2); ubound(d1,2); "|"
redim d1(-5 to 5)
print "d1:"; lbound(d1); ubound(d1); lbound(d1,0); ubound(d1,0); lbound(d1,1); ubound(d1,1); lbound(d1,2); ubound(d1,2); lbound(d1,9); ubound(d1,9); "|"

dim m() as long
redim m(1 to 2, -3 to 3)
print "m:"; lbound(m); ubound(m); lbound(m,0); ubound(m,0); lbound(m,1); ubound(m,1); lbound(m,2); ubound(m,2); lbound(m,3); ubound(m,3); lbound(m,-1); ubound(m,-1); "|"
ShowP m(), "m"
dim m2(any, any, any) as long
print "m2 unalloc:"; lbound(m2); ubound(m2); lbound(m2,0); ubound(m2,0); lbound(m2,3); ubound(m2,3); lbound(m2,4); ubound(m2,4); "|"
redim m2(0 to 1, 2 to 3, 4 to 5)
print "m2:"; lbound(m2,0); ubound(m2,0); lbound(m2,3); ubound(m2,3); lbound(m2,4); ubound(m2,4); "|"

dim f(2 to 5) as long
print "f:"; lbound(f); ubound(f); lbound(f,0); ubound(f,0); lbound(f,1); ubound(f,1); lbound(f,2); ubound(f,2); lbound(f,-1); ubound(f,-1); "|"
dim f2(1 to 3, 4 to 6) as long
print "f2:"; lbound(f2); ubound(f2); lbound(f2,0); ubound(f2,0); lbound(f2,2); ubound(f2,2); lbound(f2,3); ubound(f2,3); lbound(f2,-1); ubound(f2,-1); "|"
for d as integer = -1 to 3
    print " fv"; d; ":"; lbound(f2, G(d)); ubound(f2, G(d));
next
print "|"
ShowP f(), "f"

dim t as TF
print "tf.x:"; lbound(t.x); ubound(t.x); lbound(t.x,0); ubound(t.x,0); lbound(t.x,2); ubound(t.x,2); "|"
print "tf.y unalloc:"; lbound(t.y); ubound(t.y); lbound(t.y,0); ubound(t.y,0); lbound(t.y,2); ubound(t.y,2); "|"
redim t.y(10 to 20)
print "tf.y:"; lbound(t.y); ubound(t.y); lbound(t.y,0); ubound(t.y,0); lbound(t.y,1); ubound(t.y,1); lbound(t.y,2); ubound(t.y,2); "|"
redim t.z(1 to 2, 3 to 4)
print "tf.z:"; lbound(t.z); ubound(t.z); lbound(t.z,0); ubound(t.z,0); lbound(t.z,2); ubound(t.z,2); lbound(t.z,3); ubound(t.z,3); "|"
dim pt as TF ptr = @t
print "pt->y:"; lbound(pt->y); ubound(pt->y); ubound(pt->y,0); ubound(pt->z,2); "|"
dim s as long = 0
for i as integer = lbound(t.y) to ubound(t.y)
    s += i
next
print "sum"; s; "|"
print "count:"; ubound(d1) - lbound(d1) + 1; "|"
