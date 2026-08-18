type T
    dim as string nm
    declare constructor( byref n as string )
    declare destructor( )
end type
constructor T( byref n as string )
    nm = n : print "ctor " & nm
end constructor
destructor T( )
    print "dtor " & nm
end destructor

function Make( byref n as string ) as T
    dim as T r = T(n)
    return r
end function

sub GotoOut( )
    print "-- goto"
    dim as T a = T("a")
    scope
        dim as T b = T("b")
        scope
            dim as T c = T("c")
            goto done_
        end scope
    end scope
    done_:
    print "at label"
end sub

sub ExitLoop( )
    print "-- exitfor"
    for i as integer = 1 to 3
        dim as T l = T("l" & str(i))
        if i = 2 then exit for
    next
end sub

sub Temporary( )
    print "-- temp"
    print "before"
    dim as T tv = Make("m")
    print "after"
end sub

sub Deferred( )
    print "-- defer"
    dim as T a = T("a")
    defer print "deferred-1"
    defer print "deferred-2"
    print "body"
end sub

GotoOut( )
ExitLoop( )
Temporary( )
Deferred( )
