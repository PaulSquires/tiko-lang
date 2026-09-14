'' A USER '&' CHAIN OVER A WIDE-CASTING UDT, the shape of AfxNova's DWSTRING. Terms mixing
'' the UDT's operators with narrow builtins ('left', 'mid') were flattened into one
'' string chain and the UDT operands read as narrow bytes; the statement declined or
'' printed garbage. Measured, fbc-modern prints [2026-09-20].
type DS
    as wstring * 64 w
    declare constructor( )
    declare constructor( byref s as string )
    declare operator cast( ) byref as wstring
end type
constructor DS( )
end constructor
constructor DS( byref s as string )
    this.w = s
end constructor
operator DS.cast( ) byref as wstring
    return this.w
end operator
operator & ( byref a as DS, byref b as DS ) as DS
    return DS( str( a ) & str( b ) )
end operator
operator & ( byref a as DS, byref b as string ) as DS
    return DS( str( a ) & b )
end operator
operator & ( byref a as string, byref b as DS ) as DS
    return DS( a & str( b ) )
end operator
function LeftDS( byref d as DS, byval n as integer ) as DS
    return DS( left( str( d ), n ) )
end function
function Hyph( byref d as DS ) as DS
    return LeftDS( d, 4 ) & "-" & mid( d, 5, 2 ) & "-" & LeftDS( d, 2 )
end function
dim as DS src = DS( "20260912" )
dim as DS h = Hyph( src )
print "[" & str( h ) & "]"
