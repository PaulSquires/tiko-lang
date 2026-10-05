type A
    as long v
end type
type B
    as long x, y, z
end type
operator len( byref a as A ) as long
    return 77
end operator
dim as A a1
dim as B b1
print len( a1 ), len( b1 ), sizeof( b1 )
