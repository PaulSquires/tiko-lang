'' T59: '#pragma push( private, true )' makes Helper private, so b.bas may have one too.
declare function Other( ) as long
#pragma push( private, true )
function Helper( ) as long
    return 1
end function
#pragma pop( private )
function Api( ) as long
    return Helper( ) + 1
end function
print Api( ); Other( )
