type K
    as integer dummy
    declare constructor( byref s as string )
end type
constructor K( byref s as string )
    s = "changed"
end constructor
sub SetIt( byref s as string )
    s = "subbed"
end sub
dim as zstring * 16 z = "orig"
dim as string * 10 f = "orig"
dim as K k1 = K( z )
print "[" & z & "]"
dim as K k2 = K( f )
print "[" & rtrim( f ) & "]"
SetIt( z )
print "[" & z & "]"
SetIt( f )
print "[" & rtrim( f ) & "]"
dim as K k3 = z
print "[" & z & "]"
