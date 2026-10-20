' 'base( u )' in a derived copy constructor, u being the DERIVED type, over a base with no
' constructor of its own that holds a string and a dynamic array: copy-constructed.
type B
    dim as string s
    dim as integer a(any)
end type
type D extends B
    dim as integer extra
    declare constructor()
    declare constructor(byref u as D)
end type
constructor D()
end constructor
constructor D(byref u as D)
    base(u)
    extra = u.extra + 1
end constructor
scope
    dim as D d1
    d1.s = "hello"
    redim d1.a(2) : d1.a(2) = 9
    d1.extra = 1
    dim as D d2 = d1
    d1.s = "changed"
    print d2.s; ubound(d2.a); d2.a(2); d2.extra; " "; d1.s
end scope
print "ok"
