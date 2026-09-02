'' THREE RULES MEASURED AGAINST FBC.
''   A const value cannot bind to a non-const byref parameter (error 181): 'byref x as T'
''   given a 'const T' is refused, while 'byref x as const T' takes it and so does byval.
''   A number to a byref string parameter is error 58; a string literal is the ordinary
''   argument, and 'byval p as zstring ptr' given 0 is a null pointer.
''   '[ ]' indexes a pointer (error 28): an integer or a UDT with no 'operator []' cannot
''   be indexed; a pointer and a string can.
type T
    i as integer
end type
dim cv as const T = ( 1 )
dim mv as T
dim ci as const integer = 1
dim n as integer
dim s as string
dim p as integer ptr

sub takesT( byref x as T )
end sub
sub takesConstT( byref x as const T )
end sub
sub takesTval( byval x as T )
end sub
sub takesInt( byref x as integer )
end sub
sub takesZ( byref z as zstring )
end sub
sub takesS( byref z as string )
end sub
sub takesZptr( byval z as zstring ptr )
end sub

takesConstT( cv )
takesTval( cv )
takesT( mv )
takesInt( 1 )
takesZ( "x" )
takesZptr( 0 )
print p[0]
print s[0]

takesT( cv )
takesInt( ci )
takesZ( 0 )
takesS( 0 )
print n[0]
print mv[0]
