'' A bare type( ... ) with no single type to build -- fbc's error 71 on the refused lines.
type P
    i as integer
    j as integer
end type
declare sub f overload( as uinteger )
declare sub f overload( as ulongint )
sub s( byref a as P )
end sub
dim x as P = type( 1, 2 )                           '' fine: the declared type
f( type( 0 ) )                                      '' 71: overloaded
if type( 0 ) then                                   '' 71: no context
end if
print x.i = type( 1, 2 ).i                          '' 71
s( type( 3, 4 ) )                                   '' fine: the parameter
