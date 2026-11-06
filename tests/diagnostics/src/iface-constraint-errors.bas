interface IShow
    function Show( ) as string
end interface
interface IComparable( of T )
    function CompareTo( byref o as T ) as long
end interface
type Rock
    as long w
    declare function Show( ) as string
end type
function Rock.Show( ) as string : return "rock" : end function
function ShowIt( of T as IShow )( byref x as T ) as string
    return x.Show( )
end function
type Holder( of T as { IShow, Rock } )
    as T v
end type
type Sorted( of K as IComparable( of K ), V )
    as K k
    as V v
end type
dim as Rock r
print ShowIt( r )
dim as Holder( of Rock ) h
dim as Holder( of IShow ) h2
dim as Sorted( of long, Rock ) s
