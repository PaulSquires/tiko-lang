sub f( byref a as any )
    print 1
end sub
type T
    a as integer
    declare operator cast( ) as T ptr
end type
operator T.cast( ) as T ptr : return @this : end operator
