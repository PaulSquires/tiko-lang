'' String values handed to a PROPERTY SETTER's byref string / ustring parameter: what the setter
'' sees, and whether its write reaches the caller's variable.
type T
    as string seen
    declare property PS( byref v as string )
    declare property PU( byref v as ustring )
end type
property T.PS( byref v as string )
    seen = "[" & v & "]" : v = "ps"
end property
property T.PU( byref v as ustring )
    seen = "[" & v & "]" : v = "pu"
end property
dim as T o
dim as string s = "s1"
dim as string * 6 f = "f1"
dim as zstring * 6 z = "z1"
dim as wstring * 6 w = wstr( "w1" )
dim as ustring u = "u1"
o.PS = s : print o.seen; " s="; s
o.PS = f : print o.seen; " f="; f
o.PS = z : print o.seen; " z="; z
o.PS = w : print o.seen
o.PS = "lit" : print o.seen
o.PS = s & "+" : print o.seen
o.PS = u : print o.seen; " u="; u
o.PU = s : print o.seen; " s="; s
o.PU = f : print o.seen; " f="; f
o.PU = u : print o.seen; " u="; u
o.PU = "lit" : print o.seen
