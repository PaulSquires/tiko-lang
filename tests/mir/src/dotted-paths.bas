'' FOUR SHAPES THAT ALL BEGIN WITH A DOT, plus PEEK and SWAP over things that have no
'' address of their own.
''
'' A LEADING '..' NAMES THE GLOBAL SCOPE. It works in an expression and did not work in a
'' TYPE NAME or as a REDIM target, because both of those read a NAME and demanded an
'' identifier -- so 'type<..a.b.T>( n )' and 'redim ..a.b.arr( 0 to 2 )' were syntax
'' errors and took their whole statements with them. The prefix is recorded as an EMPTY
'' FIRST COMPONENT of the dotted path, which is the one spelling a real identifier can
'' never produce, and Resolve reads it as "start at the file scope".
''
'' A REDIM TARGET'S CHAIN IS BUILT BY HAND, not through the postfix parser: that one
'' takes the '( 0 to 2 )' that follows as a CALL and swallows the bounds -- the same
'' reason the parenthesised form reads its group explicitly.
''
'' 'peek( T, p )' IS AN LVALUE -- it IS '*(T*)p', and fbc emits no load for it at all. The
'' lowering was written scalar-only, so a UDT type argument bailed before the pointer was
'' ever computed, and 'peek( T, p ).i' declined with it. That is what made it look like a
'' WITH problem: 'with *cptr( T ptr, p )' beside it lowered.
''
'' A BITFIELD HAS NO ADDRESS OF ITS OWN either -- it is bits inside a unit its neighbours
'' share -- so SWAP, which is address-first on every path, declined the whole statement.
'' Measured: fbc emits a temporary of the FIELD'S type and three read-modify-writes
'' through the container word. Both sides are read BEFORE either is written, because the
'' two may name bits in the same unit.
namespace na
    namespace nb
        type T
            as long v
        end type
        dim shared arr( ) as integer
    end namespace
end namespace

type Bits
    a : 1 as integer
    b : 1 as integer
    c : 6 as integer
end type

type Plain
    i as integer
end type

sub s1( )
    dim as ..na.nb.T q
    q.v = 5
    print q.v
    print type<..na.nb.T>( 7 ).v

    redim ..na.nb.arr( 0 to 2 )
    ..na.nb.arr( 1 ) = 9
    print ubound( ..na.nb.arr ), ..na.nb.arr( 1 )

    dim p1 as Plain
    p1.i = 42
    dim pany as any ptr = @p1
    dim as integer r
    with peek( Plain, pany )
        r = .i
    end with
    print r, peek( Plain, pany ).i

    dim x as Bits
    x.a = 1 : x.b = 0 : x.c = 3
    swap x.a, x.b
    print x.a, x.b, x.c
end sub

s1( )
