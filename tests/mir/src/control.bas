'' SELECT CASE in all four of its forms, and GOTO across a scope that owns a cleanup.

sub Sel( byval n as long )
    dim as long r
    select case n
        case 1
            r = 1
        case 2, 3
            r = 2
        case 4 to 6
            r = 3
        case is > 10
            r = 4
        case else
            r = 5
    end select
end sub

sub Jump( byval n as long )
    dim as long r
    if n = 1 then goto done
    scope
        dim as string s = "x"
        if n = 2 then goto done
        r = 1
    end scope
    r = 2
done:
    r = 3
end sub
