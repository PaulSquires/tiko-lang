sub t1( )
    const as integer<8> MIN= cint<8>( -1 ) shl ((8)-1)
    const MAX as integer<8>= cint<8>( not MIN )
    print MIN, MAX
    print sizeof( unsigned integer ), sizeof( unsigned byte )
    print len( unsigned integer<16> ), sizeof( uinteger<16> )
end sub
sub t2( byref x as byte )
    dim as uinteger addrof_x = cuint( @(@x) )
    print (@(@x)) = cptr( byte ptr ptr, addrof_x )
end sub
