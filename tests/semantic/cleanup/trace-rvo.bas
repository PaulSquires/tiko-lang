type T
    as long id
    declare constructor( byval n as long )
    declare destructor( )
end type
constructor T( byval n as long )
    id = n : print "  ctor " & str(id)
end constructor
destructor T( )
    print "  dtor " & str(id)
end destructor

function Make( byval n as long ) as T
    dim as T r = T(n)
    return r
end function

print "-- dim  (plan says the copy is ELIDED here)"
scope
    dim as T a = Make(1)
    print "  (body)"
end scope

print "-- static (plan says NOT elided)"
scope
    static as T s = Make(2)
    print "  (body)"
end scope
