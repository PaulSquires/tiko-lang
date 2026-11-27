'' FOR EACH over a PAREN-LESS method call: 'for each v in h.Items' is 'h.Items( )'.
'' List owns a dynamic array, so the call's result has a destructor -- the shape of
'' std Map.Keys, where the bug was found.
type ListIt
    p as long
    n as long
    ys( any ) as long
    declare function IsValid( ) as boolean
    declare function Value( ) as long
    declare sub MoveNext( )
end type

type List
    xs( any ) as long
    declare function GetIterator( ) as ListIt
end type

function ListIt.IsValid( ) as boolean
    return p < n
end function
function ListIt.Value( ) as long
    return ys( p )
end function
sub ListIt.MoveNext( )
    p += 1
end sub

function List.GetIterator( ) as ListIt
    dim it as ListIt
    it.n = ubound( xs ) + 1
    redim it.ys( ubound( xs ) )
    for i as long = 0 to ubound( xs )
        it.ys( i ) = xs( i )
    next
    return it
end function

type Holder
    base_ as long
    declare function Items( ) as List
end type
function Holder.Items( ) as List
    dim l as List
    redim l.xs( 2 )
    for i as long = 0 to 2
        l.xs( i ) = base_ + i * 10
    next
    return l
end function

dim h as Holder
h.base_ = 7
dim as long sum1 = 0, sum2 = 0
for each v in h.Items
    sum1 += v
next
for each v in h.Items( )
    sum2 += v
next
print sum1
print sum2
