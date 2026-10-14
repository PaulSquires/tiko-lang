'' fbc's 98 for each: the cast reaches two of the parameter type's constructors equally.

type CS
    as long x
    declare operator cast( ) as string
end type
operator CS.cast( ) as string
    return "s"
end operator

type CU
    as long x
    declare operator cast( ) as ustring
end type
operator CU.cast( ) as ustring
    return "u"
end operator

type B1
    as long k
    declare constructor( byref s as const ustring )
    declare constructor( byref s as const wstring )
end type
constructor B1( byref s as const ustring ) : k = 1 : end constructor
constructor B1( byref s as const wstring ) : k = 2 : end constructor

type B2
    as long k
    declare constructor( byref s as const string )
    declare constructor( byref s as const wstring )
end type
constructor B2( byref s as const string ) : k = 1 : end constructor
constructor B2( byref s as const wstring ) : k = 2 : end constructor

sub P1( byref b as const B1 ) : end sub
sub P2( byref b as const B2 ) : end sub

dim as CS vs
dim as CU vu
P1( vs )
P2( vu )
P2( vs )
