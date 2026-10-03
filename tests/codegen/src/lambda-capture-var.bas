'' T74: a lambda may capture a variable declared with 'var' -- byref and byval, an
'' integer, a string, a call's result, and a UDT, at module level and in a SUB. Resolve
'' builds the closure before Check has typed a 'var'; it did not compile at all.
type Point
    x as long
    y as long
end type
function Start( ) as double
    return 1.5
end function
var total = 0
var add = sub[ byref total ]( byval n as long )
    total += n
end sub
add( 3 ) : add( 4 )
print total
var greeting = "hello"
dim as string tmpw = "tiko"
var who = tmpw
var say = sub[ byval greeting, byref who ]( )
    print greeting; ", "; who
end sub
who = "world"
say( )
var acc = Start( )
var bump = sub[ byref acc ]( byval d as double )
    acc += d
end sub
bump( 2.25 )
print acc
sub Inner( )
    var count = 10
    var p = type<Point>( 1, 2 )
    var go = sub[ byref count, byval p ]( )
        count += p.x + p.y
    end sub
    go( ) : go( )
    print count
end sub
Inner( )
