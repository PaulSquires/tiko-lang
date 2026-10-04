'' A function's result set from the other side of the string/number line (T95).
function A( ) as long
    return "s"
end function
function B( ) as long
    function = "s"
end function
function C( ) as long
    C = "s"
end function
function D( ) as string
    return 5
end function
function E( ) as string
    return "fine"
end function
function G( ) as double
    G = 2.5
end function
print A( ), B( ), C( ), D( ), E( ), G( )
