'' THE HIDDEN RESULT OBJECT of a call returning a UDT by value, and where it dies.
type S
    as string s
    declare destructor( )
end type

destructor S( )
end destructor

declare function make_( ) as S

sub p( )
    '' A simple statement: one destructor, immediately after the use.
    print make_( ).s
    '' A CONDITION: the temporary dies before the branch, once.
    if make_( ).s = "" then
        print "a"
    end if
    '' A LOOP HEAD: it dies inside the head, because the head runs again.
    while make_( ).s = "x"
        print "b"
    wend
    '' A declaration copy-constructs, and the temporary still dies.
    dim as S q = make_( )
end sub

'' ...and 'return' out of a UDT function COPY-CONSTRUCTS the caller's storage rather
'' than storing the aggregate whole, or the result and the local would own one buffer
'' and the local's destructor would free it.
function g( ) as S
    dim as S t
    return t
end function

function make_( ) as S
    dim as S r
    return r
end function

p( )
