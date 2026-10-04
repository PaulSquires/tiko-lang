'' A header-only library meant for ONE unit, as fbsqlite.bi is: its member is defined
'' here and is not private, so a second unit that includes it defines it again.
type Counter
    as long n
    declare function Bump( ) as long
end type

function Counter.Bump( ) as long
    n += 1
    return n
end function
