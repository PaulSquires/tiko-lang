'' A UDT-returning call passed to a byref UDT constructor parameter is evaluated once.
dim shared as long gCalls
type Inner
    as long v
end type
type HolderRU
    as long n
    declare constructor( byref u as Inner )
end type
constructor HolderRU( byref u as Inner )
    this.n = u.v
end constructor
function FromInner( ) as Inner
    gCalls += 1
    dim as Inner i
    i.v = 9
    return i
end function
sub ByrefUdt( )
    dim as HolderRU h = HolderRU( FromInner( ) )
end sub
ByrefUdt( )
print gCalls
