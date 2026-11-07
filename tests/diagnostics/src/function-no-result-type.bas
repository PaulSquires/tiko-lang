'' A 'function' WITH NO RESULT TYPE -- fbc's error 147 at the header, a lambda's too. tiko
'' took it for a sub and said so at the 'return' (TKO0952).
function G( byval a as long )
    return a
end function
declare function H( byval a as long )
var f = function( byval a as long ) : return a * 2 : end function
sub S( )                                            '' fine: a sub has none
end sub
function K( byval a as long ) as long               '' fine
    return a
end function
