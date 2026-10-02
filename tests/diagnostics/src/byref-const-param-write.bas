type Pt
    x as long
end type
sub A( byref n as const long )
    n = 1
end sub
sub B( byref p as const Pt )
    p.x = 1
end sub
sub C( byref s as const string )
    s = "x"
end sub
sub D( byref p as const Pt )
    p = type<Pt>( 1 )
end sub
sub BadU( byref s as const ustring )
    s = "changed"
end sub
sub BadS( byref s as const string )
    s = "changed"
    s &= "x"
end sub
sub BadV( byval s as const string )
    s = "v"
end sub
sub OkU( byref s as const ustring )
    print s
end sub
sub MidW( byref s as const string )
    mid( s, 1 ) = "Z"
end sub
sub SwapW( byref s as const string, byref t as string )
    swap s, t
end sub
sub OkW( byref s as string, byref n as long )
    s = "fine" : n = 2
end sub
type Q
    v as long
    declare sub Bump( )
end type
sub Q.Bump( )
    v += 1
end sub
