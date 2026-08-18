type T
    as long id
    declare destructor( )
end type
destructor T( )
    print "dtor " & this.id
end destructor

sub F( byval n as long )
    dim as T a = type<T>( 1 )
    scope
        dim as T b = type<T>( 2 )
        scope
            dim as T c = type<T>( 3 )
            print "jumping"
            if n = 1 then goto done
            print "not reached"
        end scope
    end scope
    print "not reached either"
done:
    print "at label"
end sub

F( 1 )
print "---"
