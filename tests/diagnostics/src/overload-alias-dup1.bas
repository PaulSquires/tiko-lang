type tdl as long
type Box(of T)
  as T v
end type
sub f overload( byref b as Box(of tdl) )
end sub
sub f overload( byref b as Box(of long) )
end sub
