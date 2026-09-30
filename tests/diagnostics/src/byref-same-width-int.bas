'' INTEGER and LONGINT are one type to a BYREF parameter on 64-bit; LONG is not.
sub f( byref a as integer )
end sub
sub g( byref a as longint )
end sub
sub k overload( byref a as long )
end sub
sub k overload( byref a as longint )
end sub
dim as longint l
dim as integer i
dim as long n
f( l )                                          '' fine
g( i )                                          '' fine
k( i )                                          '' fine: the longint overload
dim as ulongint ul
dim as uinteger u
sub h overload( byref a as ulong )
end sub
sub h overload( byref a as ulongint )
end sub
h( u )                                          '' fine: the ulongint overload
g( n )                                          '' refused: another width
