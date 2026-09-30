'' A global 'operator ->' whose result is not a UDT -- fbc's error 141 on the refused lines.
type U1
    i as integer
end type
type U2
    i as integer
end type
type U3
    i as integer
end type
operator ->( byref x as U1 ) as integer        '' 141
    return x.i
end operator
operator ->( byref x as U2 ) as U2 ptr         '' 141
    return @x
end operator
operator ->( byref x as U3 ) byref as U3       '' fine
    return x
end operator
