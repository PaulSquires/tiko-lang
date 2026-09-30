'' an array result through the hidden pointer -- see tests/driver/array-result.test for
'' the run; this pins the IR shape.
function foo( ) as integer( )
    return { 10, 20, 30 }
end function

function local_( ) as long( )
    dim r( ) as long
    redim r( 0 to 1 )
    r( 0 ) = 5
    return r
end function

var i = foo( )
print i( 1 )
foo( )
