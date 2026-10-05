type UL
    as long v
    declare operator cast( ) as long
    declare operator cast( ) as string
end type
operator UL.cast( ) as long : return v : end operator
operator UL.cast( ) as string : return "s" & v : end operator
type UD
    as long v
    declare operator cast( ) as double
    declare operator cast( ) as string
end type
operator UD.cast( ) as double : return v : end operator
operator UD.cast( ) as string : return "d" & v : end operator
sub u overload( byval x as long ) : print "u long"; x : end sub
sub u overload( byref s as string ) : print "u string "; s : end sub
sub w overload( byval x as long ) : print "w long"; x : end sub
sub w overload( byval s as string ) : print "w string "; s : end sub
sub y overload( byval x as double ) : print "y double"; x : end sub
sub y overload( byval s as string ) : print "y string "; s : end sub
sub z overload( byval x as integer ) : print "z integer"; x : end sub
sub z overload( byval s as string ) : print "z string "; s : end sub
sub q overload( byval x as long ) : print "q long"; x : end sub
sub q overload( byval x as double ) : print "q double"; x : end sub
dim as UL a = ( 3 )
dim as UD b = ( 4 )
u( a ) : w( a ) : y( b ) : z( a )
