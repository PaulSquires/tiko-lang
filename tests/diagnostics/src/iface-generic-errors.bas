interface IGet( of T )
    function Get( ) as T
end interface
class Bad( of T )
    implements IGet( of T )
    dim as T v
    declare function Get( ) as long implements IGet( of T ).Get
end class
function Bad( of T ).Get( ) as long
    return 1
end function
class Miss( of T )
    implements IGet( of T )
end class
dim as Bad( of long ) b1
dim as Bad( of string ) b2
dim as Miss( of double ) m
dim as IGet( of long, string ) w
dim as IGet z
type Plain
    implements IGet( of long )
    as long pad
    declare function Get( ) as string implements IGet( of long ).Get
end type
