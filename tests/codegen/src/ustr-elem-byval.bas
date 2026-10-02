'' T65: a ustring array element passed byval to a ustring parameter -- a local array and a
'' parameter array. 'w( 1 )' is an N_CALL, and its descriptor was handed over by value.
function Shout( byval s as ustring ) as ustring
    return ucase( s )
end function
sub Each( a() as ustring )
    for i as long = lbound( a ) to ubound( a )
        print Shout( a( i ) );
    next
    print
end sub
dim words( 0 to 1 ) as ustring = { "ab", "cd" }
Each( words() )
print Shout( words( 1 ) )
