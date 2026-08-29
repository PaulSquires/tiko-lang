'' A UDT CARRYING A DYNAMIC ARRAY, COPIED. The descriptor must not be copied bitwise:
'' that leaves two objects over one buffer and BOTH destructors erase it. fbc's
'' generated LET resizes the destination out of the source's own descriptor with
'' fb_ArrayRedimTo and then copies the elements.
type Box
    dim as double arr( any )
end type

sub FromVariable()
    dim as Box a
    redim a.arr( 0 to 3 )
    a.arr(0) = 7
    dim as Box b = a
    print b.arr(0)
end sub

function Make() as Box
    dim as Box r
    redim r.arr( 0 to 1 )
    r.arr(0) = 5
    return r
end function

'' A FUNCTION RESULT IS ALREADY A TEMPORARY and is MOVED, not copied -- one buffer,
'' one erase. Copying here would leak the returned descriptor's buffer.
sub FromCall()
    dim as Box c = Make()
    print c.arr(0)
end sub

FromVariable()
FromCall()
