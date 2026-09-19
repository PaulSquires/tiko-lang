'' A member written ABOVE a local of the same name that the method declares later.
type Counter
    total as long
    declare function Report( ) as long
end type
function Counter.Report( ) as long
    total = 5
    dim as long total = 100
    return total
end function
dim as Counter c
print c.Report( ); c.total
