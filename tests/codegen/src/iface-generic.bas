'' GENERIC INTERFACES (docs/tiko-interfaces §11.5). Each instance is an interface of its own:
'' IBox( of long ) inherits IGet( of long ), a non-generic class implements two instances of
'' one generic, and a generic class gets one mapping -- and one itable -- per instance.
interface IGet( of T )
    function Get( ) as T
end interface
interface IBox( of T )
    inherits IGet( of T )
    sub Put( byval v as T )
    property Size( ) as long
end interface
interface IShow
    function Show( ) as string
end interface

class Cell
    implements IBox( of long ), IGet( of string )
    dim as long v
    declare function GetL( ) as long implements IGet( of long ).Get
    declare sub PutL( byval x as long ) implements IBox( of long ).Put
    declare property Sz( ) as long implements IBox( of long ).Size
    declare function GetS( ) as string implements IGet( of string ).Get
end class
function Cell.GetL( ) as long : return v : end function
sub Cell.PutL( byval x as long ) : v = x : end sub
property Cell.Sz( ) as long : return 1 : end property
function Cell.GetS( ) as string : return "cell" & v : end function

class Box( of T )
    implements IShow, IGet( of T )
    dim as T v
    declare function Show( ) as string implements IShow.Show
    declare function Get( ) as T implements IGet( of T ).Get
end class
function Box( of T ).Show( ) as string
    return "Box(" & v & ")"
end function
function Box( of T ).Get( ) as T
    return v
end function

sub ShowGet( byval g as IGet( of long ) )
    print "get"; g.Get( )
end sub

dim as Cell ce
dim as IBox( of long ) b = @ce
b.Put( 42 )
print b.Get( ), b.Size
ShowGet( b )
dim as IGet( of string ) gs = @ce
print gs.Get( )
dim as Cell ptr cp = trycast( Cell ptr, gs )
print cp->v, sizeof( IGet( of long ) )

dim as Box( of long ) bl
bl.v = 7
dim as Box( of string ) bs
bs.v = "hi"
dim as IShow s1 = @bl, s2 = @bs
print s1.Show( ), s2.Show( )
dim as IGet( of long ) gl = @bl
dim as IGet( of string ) gt = @bs
print gl.Get( ), gt.Get( )
print ( s1 is Box( of long ) ), ( s2 is Box( of long ) )
