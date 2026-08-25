type B
    as long v
    as ubyte d(0 to 3)
end type
type T extends B
    as long id
    declare sub S( )
    declare operator cast( ) byref as wstring
end type
sub T.S( )
    v = 5
    print v
    d(0) = 1
    print d(0)
    dim as any ptr p = @v
    dim as any ptr q = @d(0)
    print p <> 0, q <> 0
end sub
operator T.cast( ) byref as wstring
    operator = *cast( wstring ptr, @d(0) )
end operator
dim t1 as T
t1.S( )
