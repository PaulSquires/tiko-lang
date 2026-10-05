declare sub g( byval w as wstring )
declare function h( ) as wstring
function f( ) byref as zstring
    static as zstring * 4 z = "a"
    return z
end function
sub k( z as zstring, byref y as zstring, byval p as zstring ptr )
end sub
