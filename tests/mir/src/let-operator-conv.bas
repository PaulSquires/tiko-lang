'' WHICH 'operator let' AN ASSIGNMENT PICKS.
''
'' Three shapes, and each one was wrong in a different direction.
''
'' A CONVERTING let -- 'x = 5' over a UDT -- was not reached at all: the assignment
'' path tested that both sides name ONE type, which a converting let can never
'' satisfy, so the statement fell through to the ordinary store and coerced the scalar
'' to the UDT's own type. '%t6 = trunc i64 5 to [0 x i8]' verified here and clang
'' rejected it -- 'invalid cast opcode for cast from i64 to [0 x i8]'.
''
'' A SAME-TYPE assignment took the CHAIN HEAD, which is whichever 'operator let' was
'' written first. Over a type declaring only converting ones, 'y = x' called the
'' DOUBLE operator and passed the source object's ADDRESS where a double belonged.
'' That lowered and verified too.
''
'' Measured, and the overload is chosen by the argument's type in every row:
''
''     x = 5     _ZN1VaSEu7INTEGER( &X$0, 5ll )
''     x = 1.5   _ZN1VaSEd( &X$0, 0x1.8p+0 )
''     y = x     __builtin_memcpy( &Y$0, &X$0, 8 )   -- V has no same-type let
''     q = p     _ZN2W2aSERS_( &Q$0, &P$0 )
''     q = 1.5   _ZN2W2aSEd( &Q$0, 0x1.8p+0 )
''
'' No same-type overload is NOT a decline: fbc copies the bytes, which is what a UDT
'' with no assignment operator at all already gets. Run under fbc: 5, 3, 3, 107, 3.
type V
    as integer a
    declare operator let ( byval i as integer )
    declare operator let ( byval d as double )
end type

operator V.let ( byval i as integer )
    this.a = i
end operator

operator V.let ( byval d as double )
    this.a = cast( integer, d * 2 )
end operator

'' The same type, WITH a same-type overload -- and it is not the one declared first,
'' so a chain-head choice would still get this one right by accident. W2's converting
'' overload is second here for exactly that reason: V above declares no same-type let
'' at all, and between them the two orders are both covered.
type W2
    as integer a
    declare operator let ( byref rhs as W2 )
    declare operator let ( byval d as double )
end type

operator W2.let ( byref rhs as W2 )
    this.a = rhs.a + 100
end operator

operator W2.let ( byval d as double )
    this.a = cast( integer, d * 2 )
end operator

dim as V x
x = 5
print x.a
x = 1.5
print x.a

'' V DECLARES NO SAME-TYPE let: the bitwise copy, not the double one.
dim as V y
y = x
print y.a

dim as W2 p
p.a = 7
dim as W2 q
q = p
print q.a
q = 1.5
print q.a
