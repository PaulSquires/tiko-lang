'' A UDT argument no overload takes and nothing converts -- fbc's error 99 on the refused line.
sub g overload( byval a as long )
end sub
sub g overload( byval a as double )
end sub
type U
    i as integer
end type
type C
    i as integer
    declare operator cast( ) as long
end type
operator C.cast( ) as long
    return i
end operator
dim u as U
dim cv as C
g( u )                                              '' 99
g( cv )                                             '' fine: its cast reaches long
