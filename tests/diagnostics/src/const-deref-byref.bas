private function OpenP( byref s as string, byval n as long ) as any ptr
    return cast( any ptr, len( s ) + n )
end function
private function OpenL( byref s as string, byval n as long ) as long
    return len( s ) + n
end function
private function TakeZ( byref z as zstring ) as long
    return len( z )
end function
private function TakeI( byref v as integer ) as integer
    return v
end function
private function TakeC( byref s as const string ) as long
    return len( s )
end function
private function TakeV( byval s as string ) as long
    return len( s )
end function
private function RetP( byval p as const zstring ptr ) as any ptr
    return OpenP( *p, 1 )
end function
private function RetIif( byval p as const zstring ptr ) as long
    return iif( OpenL( *p, 0 ) > 2, 1, 0 )
end function
private function RetZ( byval p as const zstring ptr ) as long
    return TakeZ( *p )
end function
private function Assign( byval p as const zstring ptr ) as long
    function = OpenL( *p, 10 )
end function
private sub Uses( byval p as const zstring ptr, byval pc as const integer ptr )
    print OpenL( *p, 100 )
    dim as long v = OpenL( *p, 7 )
    print TakeI( *pc )
end sub
'' accepted: the pointee is not const, the parameter is const or byval, or a literal
private sub Fine( byval q as zstring ptr, byval p as const zstring ptr )
    print OpenL( *q, 1 ), TakeC( *p ), TakeV( *p ), OpenL( "lit", 1 )
end sub
