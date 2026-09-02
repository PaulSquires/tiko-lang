'' THREE THINGS AN ARRAY DECLARATION MAY NOT SAY, and one thing base( ) may not.
'' MEASURED against fbc:
''     a dynamic array FIELD with a const element     error 275
''     an array VARIABLE with a const element         error 237, fixed or dynamic
''     an ellipsis bound on an array FIELD            error 77  (fine on a variable)
''     base( ) given MORE values than the parent has fields   error 67 (fewer is accepted)
type Parent
    as integer a, b, c
end type

type Good
    plain(any) as integer
end type
dim okEllipsis(0 to ...) as integer = { 1, 2 }

type Child extends Parent
    declare constructor( )
end type
constructor Child( )
    base( 1, 2 )
end constructor

type Child2 extends Parent
    declare constructor( )
end type

type Bad
    dynConst(any) as const integer
    ell(0 to ...) as integer
end type
dim badFixed(0 to 3) as const integer
dim badDyn(any) as const integer
constructor Child2( )
    base( 1, 2, 3, 4 )
end constructor
