'' INFERENCE THROUGH AN IMPLEMENTED GENERIC INTERFACE (docs/tiko-interfaces §11.5). A parameter
'' 'byval cmp as IComparer( of T )' given a ByLength that IMPLEMENTS IComparer( of string ) infers
'' T = string from that instance -- by value, through '@obj' and through a pointer variable --
'' and an interface that INHERITS the instance counts too.
interface IComparer( of T )
    function Compare( byval a as T, byval b as T ) as long
end interface

class ByLength
    implements IComparer( of string )
    declare function Compare( byval a as string, byval b as string ) as long _
        implements IComparer( of string ).Compare
end class
function ByLength.Compare( byval a as string, byval b as string ) as long
    return len( a ) - len( b )
end function

class Descending
    implements IComparer( of double )
    declare function Compare( byval a as double, byval b as double ) as long _
        implements IComparer( of double ).Compare
end class
function Descending.Compare( byval a as double, byval b as double ) as long
    return sgn( b - a )
end function

'' One sort, any element type, any order.
sub SortWith( of T )( a( ) as T, byval cmp as IComparer( of T ) )
    for i as integer = lbound( a ) + 1 to ubound( a )
        dim as T v = a( i )
        dim as integer j = i - 1
        do while j >= lbound( a )
            if cmp.Compare( a( j ), v ) <= 0 then exit do
            a( j + 1 ) = a( j )
            j -= 1
        loop
        a( j + 1 ) = v
    next
end sub

dim as string words( 0 to 3 ) = { "banana", "fig", "kiwi", "apple" }
dim as ByLength bl
SortWith( words( ), bl )
for i as integer = 0 to 3 : print " "; words( i ); : next : print

dim as double sizes( 0 to 3 ) = { 2.5, 9, 0.5, 4 }
dim as Descending dsc
SortWith( sizes( ), dsc )
for i as integer = 0 to 3 : print sizes( i ); : next : print

interface IStrictComparer( of T )
    inherits IComparer( of T )
end interface
class Strict
    implements IStrictComparer( of long )
    declare function Compare( byval a as long, byval b as long ) as long _
        implements IComparer( of long ).Compare
end class
function Strict.Compare( byval a as long, byval b as long ) as long
    return a - b
end function
dim as long nums( 0 to 2 ) = { 3, 1, 2 }
dim as Strict st
dim as Strict ptr sp = @st
SortWith( nums( ), @st )
print nums( 0 ); nums( 1 ); nums( 2 )
SortWith( nums( ), sp )
dim as IStrictComparer( of long ) isc = st
SortWith( nums( ), isc )
print nums( 0 ); nums( 1 ); nums( 2 )
