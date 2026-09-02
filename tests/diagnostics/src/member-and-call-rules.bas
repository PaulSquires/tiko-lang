'' FOUR RULES MEASURED AGAINST FBC.
''   CONST and STATIC on a definition must agree with the declaration: one the
''   declaration lacked is error 217 / 218; one it had may be repeated or left off.
''   'let', 'cast', '[]' and the compound assignments are members or nothing (152);
''   a binary '+' is the ordinary free operator.
''   A field of a CONST variable cannot be written (119); reading it is fine.
''   At a CALL, 'byval p as D ptr' given a B pointer is 24 and 'byref x as D' given a B
''   is 58 -- the same downcasts the assignment refuses -- while the upcasts are fine.
''   And 'type U extends object' inside a SUB is 263 even with no method declared.
type T
    as integer dummy
    declare sub normal( )
    declare sub normal2( )
    declare static sub st( )
    declare const sub cn( )
end type
static sub T.st( )
end sub
sub T.cn( )
end sub

type B extends object
    v as integer
end type
type D extends B
    w as integer
end type
type Foo
    x as integer
end type
operator + ( byref lhs as Foo, byref rhs as Foo ) as Foo
    operator = lhs
end operator

sub wantsDptr( byval p as D ptr )
end sub
sub wantsBptr( byval p as B ptr )
end sub
sub wantsD( byref x as D )
end sub
sub wantsB( byref x as B )
end sub
dim pb as B ptr, pd as D ptr, vb as B, vd as D
wantsBptr( pd )
wantsB( vd )
dim as const Foo cf = ( 3 )
print cf.x
sub okPlainType( )
    type Local_
        i as integer
    end type
end sub

static sub T.normal( )
end sub
const sub T.normal2( )
end sub
operator let ( byref a as integer )
end operator
operator += ( byref lhs as Foo, byref rhs as Foo )
end operator
cf.x = 4
wantsDptr( pb )
wantsD( vb )
sub badType( )
    type Local2 extends object
        i as integer
    end type
end sub
