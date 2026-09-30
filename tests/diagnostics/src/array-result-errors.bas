function a1( ) as integer( 3 )
    return { 1 }
end function

dim cb as function( ) as integer( )

function a2( ) as integer( )
    return 5
end function

function a3( ) as integer( )
    return { { 1, 2 }, { 3, 4 } }
end function

function a4( a( ) as integer ) as integer( )
    return a
end function

function a5( ) as integer( )
    function = "text"
end function

dim shared g( ) as integer
function a6( ) as integer( )
    return g
end function

function a7( ) as long( )
    dim r( ) as integer
    return r
end function

dim d( ) as integer = a2( )

dim x as integer = a2( )
var b = a2
dim as long z
z = a2( )

function a8( ) as integer
    return a2( )
end function

declare function a10( ) as integer( )
function a10( ) as integer
    return 1
end function
