type T
    as long id
    declare constructor( byval n as long )
    declare constructor( byref rhs as T )
    declare destructor( )
end type
constructor T( byval n as long )
    id = n : print "  ctor " & str(id)
end constructor
constructor T( byref rhs as T )
    id = rhs.id + 100 : print "  COPYctor " & str(id) & " from " & str(rhs.id)
end constructor
destructor T( )
    print "  dtor " & str(id)
end destructor

function Make( byval n as long ) as T
    dim as T r = T(n)
    return r
end function

print "-- dim from function"
scope
    dim as T a = Make(1)
    print "  (body)"
end scope

print "-- assign from function"
scope
    dim as T b = T(2)
    b = Make(3)
    print "  (body)"
end scope

print "-- pass byval"
sub Take( byval v as T )
    print "  (in Take)"
end sub
scope
    dim as T c = T(4)
    Take(c)
    print "  (after call)"
end scope
