type Counter
    n as long
    declare function Id( ) as long
    declare const function Peek( ) as long
    declare sub Reset( )
    declare property Val( ) as long
    declare const property CVal( ) as long
end type
function Counter.Id( ) as long
    n += 1
    return n
end function
const function Counter.Peek( ) as long
    return n
end function
sub Counter.Reset( )
    n = 0
end sub
property Counter.Val( ) as long
    return n
end property
const property Counter.CVal( ) as long
    return n
end property
sub UseT( byref t as const Counter )
    print t.Id( )
    print t.Peek( )
end sub
dim as const Counter k = ( 0 )
print k.Id( )
print k.Peek( )
k.Reset( )
print k.Val
print k.CVal
dim as Counter m
print m.Id( )
dim as const Counter ptr pk = @m
print pk->Id( )
UseT( m )
