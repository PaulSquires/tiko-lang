declare function Api( ) as long
function Helper( ) as long
    return 5
end function
function Other( ) as long
    return Helper( ) + Api( )
end function
