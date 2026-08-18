namespace demo
const MAX = 10
type Point
    as long x, y
    declare function Norm( ) as double
end type
enum Colour
    Red = 1
    Green
end enum
dim shared as long total
sub Run( byval n as long, byref s as string = "hi" )
    dim as long i
    for i = 0 to n - 1 step 2
        if i mod 2 = 0 then
            total += i
        elseif i > 5 then
            exit for
        else
            print "odd", i
        end if
    next
    do while total < 100
        total *= 2
    loop
    select case total
        case 0, 1 : print "small"
        case 2 to 9 : print "mid"
        case else : print "big"
    end select
end sub
end namespace

'' A LABEL needs the colon. A bare identifier on a line of its own is a CALL with the
'' parentheses left off, not a label -- ':' and a newline are both TK_EOL and both one
'' byte, so telling them apart by length made every zero-argument bare call a label on
'' LF input, and looked correct only on CRLF.
sub Bare( )
end sub
Bare
theLabel:
