'' The shapes this slice of lowering covers.
function Add( byval a as long, byval b as long ) as long
    dim as long r
    r = a + b
    return r
end function

sub Counted( )
    dim as long i
    dim as long total
    total = 0
    for i = 1 to 10
        total = total + i
    next
end sub

sub Branch( byval x as long )
    dim as long y
    if x > 0 then
        y = 1
    else
        y = 2
    end if
end sub

sub Looping( byval n as long )
    dim as long i
    i = 0
    while i < n
        i = i + 1
        if i = 5 then exit while
    wend
    do
        i = i - 1
    loop until i = 0
end sub
