'' EXIT, CONTINUE and GOTO with nowhere to go (T95).
exit for
sub S1( )
    do
        exit for
    loop
end sub
sub S2( )
    exit function
end sub
function F1( ) as long
    exit sub
end function
sub S3( )
    for i as long = 1 to 2
        exit for, for
    next
end sub
sub S4( )
    goto nowhere
end sub
sub S5( )
here:
end sub
goto here
sub S6( )
    for i as long = 1 to 2
        for j as long = 1 to 2
            if j = 2 then exit for, for
            continue for
        next
    next
    select case 1
    case 1
        exit select
    end select
again:
    if 0 then goto again
end sub
exit operator
