'' 'Alias( ).a' where 'type Alias as T' -- A CONSTRUCTOR CALL THROUGH A TYPEDEF.
''
'' A typedef is a SYM_TYPEDEF whose own type is a TK_TYPEDEF placeholder, and both the
'' typing rule and the lowering asked for SYM_UDT with a TK_UDT type. So the call came
'' out untyped and the '.a' on it had nothing to offset from -- while 'T( ).a' and
'' 'type<Alias>( ).a' beside it both lowered, which is what made it look like a member
'' problem rather than a name one.
''
'' What says the name means an object is the type the NAME RESOLVES TO, which both places
'' already had in hand.
type CtorUdt
    as integer a, b
    declare constructor( )
end type

constructor CtorUdt( )
    a = 123
    b = 456
end constructor

type CtorUdtAlias as CtorUdt

sub sink( byval n as integer )
    print n
end sub

sub s1( )
    sink( CtorUdt( ).a )
    sink( CtorUdtAlias( ).a )
    sink( (CtorUdtAlias( )).b )
    sink( type<CtorUdtAlias>( ).a )
end sub

s1( )
