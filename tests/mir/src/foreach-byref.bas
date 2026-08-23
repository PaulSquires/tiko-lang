'' A BYREF PARAMETER IS A REFERENCE TO THE CONTAINER, not the container. Both the
'' element-type lookup and the member lookup behind it tested the reference's own kind,
'' found neither an array nor a UDT, and left the loop variable UNTYPED -- so every use
'' of it inside the body declined, while the same loop over a LOCAL container lowered.
''
'' fbc's own fb/stats.bi takes every container byref, which is what a container-taking
'' procedure does: 64 declines in that one header, and 432 across the corpus.
type Iter
    as any ptr src
    as long idx
    declare function IsValid( ) as boolean
    declare function Value( ) byref as long
    declare sub MoveNext( )
end type
type Bag
    as long items( any )
    as long num
    declare function GetIterator( ) as Iter
end type
function Iter.IsValid( ) as boolean
    return this.idx < 1
end function
function Iter.Value( ) byref as long
    dim as Bag ptr b = cptr( Bag ptr, this.src )
    return b->items( this.idx )
end function
sub Iter.MoveNext( )
    this.idx += 1
end sub
function Bag.GetIterator( ) as Iter
    dim as Iter it
    it.src = @this
    it.idx = 0
    return it
end function

function SumOf( byref a as Bag ) as long
    dim as long s
    for each e in a
        s += e
    next
    return s
end function

function SumOfVal( byval a as Bag ) as long
    dim as long s
    for each e in a
        s += e
    next
    return s
end function
