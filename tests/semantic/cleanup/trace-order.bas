type T
    dim as string nm
    declare constructor( byref n as string )
    declare destructor( )
end type
constructor T( byref n as string )
    nm = n
    print "ctor " & nm
end constructor
destructor T( )
    print "dtor " & nm
end destructor

sub Simple( )
    print "-- simple"
    dim as T a = T("a")
    dim as T b = T("b")
    dim as T c = T("c")
end sub

sub Nested( )
    print "-- nested"
    dim as T a = T("a")
    scope
        dim as T inner1 = T("i1")
        dim as T inner2 = T("i2")
    end scope
    dim as T z = T("z")
end sub

sub EarlyReturn( byval flag as long )
    print "-- early"
    dim as T a = T("a")
    if flag then
        dim as T b = T("b")
        return
    end if
    dim as T c = T("c")
end sub

sub LoopBody( )
    print "-- loop"
    for i as integer = 1 to 2
        dim as T l = T("l" & str(i))
    next
end sub

Simple( )
Nested( )
EarlyReturn( 1 )
LoopBody( )
