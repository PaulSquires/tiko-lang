'' T71: 'for each byref' over a collection declared with 'var' binds the element,
'' as it does over one declared with 'dim'. It bound a copy, and the loop changed
'' nothing. A var-declared array and a string keep their behaviour.
type BoxIter
    p as long ptr
    left as long
    declare function IsValid( ) as boolean
    declare function Value( ) byref as long
    declare sub MoveNext( )
end type
function BoxIter.IsValid( ) as boolean
    return left > 0
end function
function BoxIter.Value( ) byref as long
    return *p
end function
sub BoxIter.MoveNext( )
    p += 1 : left -= 1
end sub
type Box
    declare constructor( byval v0 as long )
    declare function GetIterator( ) as BoxIter
    v( 0 to 1 ) as long
end type
constructor Box( byval v0 as long )
    v( 0 ) = v0 : v( 1 ) = v0 + 1
end constructor
function Box.GetIterator( ) as BoxIter
    return type( @v( 0 ), 2 )
end function

var a = Box( 1 )
for each byref x in a
    x *= 100
next
print a.v( 0 ); a.v( 1 )
dim b as Box = Box( 2 )
var d = b
for each byref x in d
    x *= 100
next
print d.v( 0 ); d.v( 1 ); b.v( 0 )
dim arr( 0 to 1 ) as long = { 5, 6 }
for each byref x in arr
    x += 1
next
print arr( 0 ); arr( 1 )
