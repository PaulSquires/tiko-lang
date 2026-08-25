'' A LEADING '.' WITH NO OPEN 'with' IS THE ENCLOSING SCOPE'S, the same thing '..'
'' names.
dim shared x as integer = 1

type T extends object
    static x as integer
    declare static sub s1( )
end type

dim shared T.x as integer = 2

private sub T.s1( )
    print x        '' the STATIC MEMBER
    print T.x      '' the same one, named
    print .x       '' the SHARED one
    print ..x      '' and so is this
end sub

T.s1( )
