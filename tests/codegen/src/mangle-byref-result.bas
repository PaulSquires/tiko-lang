namespace ns
type Q
    as long v
end type
sub a1( byval f as function( byref as Q ) byref as Q )
end sub
sub a2( byval f as function( byref as long ) byref as long )
end sub
sub a3( byval f as function( ) byref as Q, byref q as Q )
end sub
sub a4( byval f as function( byref as string ) byref as string )
end sub
end namespace
