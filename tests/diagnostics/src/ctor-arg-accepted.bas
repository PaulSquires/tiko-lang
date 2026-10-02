'' The neighbours of ctor-arg-mismatch.bas that fbc accepts -- see ctor-arg-accepted.test.
type B
    declare constructor ( byval a as long, byref w as long, byref s as string, byval z as zstring ptr, byval d as double = 0 )
    v as long
end type
constructor B ( byval a as long, byref w as long, byref s as string, byval z as zstring ptr, byval d as double = 0 )
    v = a + w + len( s ) + len( *z ) + d
end constructor
type C
    declare constructor ( byval a as long )
    v as long
    s as string
end type
constructor C ( byval a as long )
    v = a
end constructor
type W
    declare constructor ( byref w as wstring, byval u as ubyte = 0 )
    v as long
end type
constructor W ( byref w as wstring, byval u as ubyte = 0 )
    v = len( w ) + u
end constructor
type O
    declare constructor ( byval a as double )
    declare constructor ( byval s as string )
    v as long
end type
constructor O ( byval a as double )
    v = a
end constructor
constructor O ( byval s as string )
    v = len( s )
end constructor
enum E : e1 = 1 : end enum
dim l as long = 1, s as string = "x", zs as zstring * 8 = "q", sh as short = 2, ee as E = e1
dim ul as ulong = 4
dim b1 as B = B( 1, l, s, @zs )
dim b2 as B = B( 1.5, 3, "lit", @zs, 7 )
dim b3 as B = B( sh, l + 1, zs, @zs, l )
dim b4 as B = B( ee, ul, "x" & s, @zs )
dim c1 as C = C( 1 )
dim c2 as C = C( c1 )
dim w1 as W = W( "abc" )
dim w2 as W = W( wstr( "abc" ), 30 )
dim w3 as W = W( s )
dim o1 as O = O( 1 )
dim o2 as O = O( "s" )
dim pc as C ptr = new C( 2.5 )
dim pb as B ptr = new B( 1, l, s, @zs )
print b1.v; b2.v; b3.v; b4.v; c2.v; w1.v; w2.v; w3.v; o1.v; o2.v; pc->v; pb->v
delete pc
delete pb
