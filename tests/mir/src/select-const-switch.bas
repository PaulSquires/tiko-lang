function CodeOf( byval c as ubyte ) as ulongint
    select case as const c
    case 65 : return 0
    case 67, 69 to 70 : return 1
    case 71 : return 2
    case else : return 3
    end select
end function

function Chained( byval c as ubyte ) as long
    select case as const c
    case 300 : return 1
    case else : return 2
    end select
end function

print CodeOf( 67 ), Chained( 44 )
