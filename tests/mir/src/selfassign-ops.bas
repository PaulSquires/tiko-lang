'' THE COMPOUND ASSIGNMENTS THAT WERE MISSING: '^=', 'andalso=' and 'orelse=', and the
'' '=>' spelling every one of them also has.
declare function side_( ) as long

sub p( byval q as long )
    dim as integer i = 3
    i ^= 2
    i andalso= side_( )
    i orelse= side_( )
    '' The same three written the other way, plus one of the ordinary ones.
    i ^=> 2
    i andalso=> side_( )
    i orelse=> side_( )
    i +=> 1
    i and=> 1
    print i
end sub

function side_( ) as long
    return 7
end function

p( 1 )
