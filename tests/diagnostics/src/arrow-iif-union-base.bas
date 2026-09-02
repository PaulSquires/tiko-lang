'' FOUR RULES MEASURED AGAINST FBC.
''   '->' through a UDT VALUE is error 28 when the type has no 'operator ->': '(*p)->i'.
''   'iif( c, 0, 0 ) = 0' -- a call's result is a temporary -- is error 24.
''   'let( a, b ) = x' over a UNION is error 268: a union has one value, not a sequence.
''   'base.f( )' to an ABSTRACT method is error 307: it binds statically to no body.
type UDT
    i as integer
end type
union U
    a as integer
    b as integer
end union
type Parent extends object
    declare abstract sub f( )
    declare sub g( )
end type
sub Parent.g( )
end sub
type Child extends Parent
    declare sub f( ) override
    declare sub h( )
end type
sub Child.f( )
end sub
sub Child.h( )
    base.g( )
    base.f( )
end sub

dim x as UDT = ( 123 )
dim p as UDT ptr = @x
dim un as U
dim as integer a, b, cond
print p->i
print (*p).i

print (*p)->i
iif( cond, 0, 0 ) = 0
let( a, b ) = un
