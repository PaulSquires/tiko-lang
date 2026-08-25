type Fn as function( byval as long ) as long
sub S1( )
    dim as function( byref as long, byref as long ) as boolean less = _
        function( byref x as long, byref y as long ) as boolean
            return x < y
        end function
    dim as long a = 1, b = 2
    print less( a, b )
    dim pick as function( byref p as long, byref q as long ) byref as long = _
        function( byref p as long, byref q as long ) byref as long
            if( p > q ) then return p
            return q
        end function
    print pick( a, b )
    dim as Fn one = function( byval x as long ) as long : return x + 100 : end function
    print one( 1 )
end sub
S1( )
