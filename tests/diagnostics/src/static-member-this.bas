type TN
    n as long
    declare operator new( byval sz as uinteger ) as any ptr
    declare operator delete( byval p as any ptr )
    declare operator new[]( byval sz as uinteger ) as any ptr
    declare sub M( )
end type
operator TN.new( byval sz as uinteger ) as any ptr
    print this.n
    return allocate( sz )
end operator
operator TN.delete( byval p as any ptr )
    print n
    deallocate( p )
end operator
operator TN.new[]( byval sz as uinteger ) as any ptr
    dim as TN ptr q = @this
    return allocate( sz )
end operator
sub TN.M( )
    print this.n; n
end sub
type TS
    n as long
    declare static sub S( )
    declare sub Normal( )
end type
sub TS.S( )
    print this.n
    print n
end sub
sub TS.Normal( )
    print this.n; n
end sub
