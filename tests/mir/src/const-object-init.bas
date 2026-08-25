'' 'dim as const T c = T( )' -- a CONST object built by its SYNTHESISED constructor.
type T1 extends object
    as long a
end type

type T2
    as string s
end type

type P
    as long x, y
end type

dim as const T1 c1 = T1( )
dim as const T2 c2 = T2( )
dim as T1 n1 = T1( )

'' ...and a type LITERAL with values is still a field list.
dim as P p1 = type<P>( 5, 6 )

print c1.a, c2.s, n1.a, p1.x, p1.y
