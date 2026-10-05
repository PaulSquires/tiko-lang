type U
    as long v
    declare operator += ( byref s as string )
end type
operator U.+= ( byref s as string ) : s = "MOD" : end operator
dim as U a
dim as zstring * 8 z = "zz"
a += z
print "[" & z & "]"
dim as string * 6 f = "ff"
a += f
print "[" & rtrim( f ) & "]"
