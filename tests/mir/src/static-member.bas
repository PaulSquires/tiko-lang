'' A STATIC MEMBER is one object for the whole program, named after its TYPE.
type T
    as long pad
    static as integer counter
    declare sub Bump( )
end type

dim shared as integer T.counter = 2

sub T.Bump( )
    T.counter += 1
end sub

'' ...and one inside a NAMESPACE is reached the same way, which needs the qualified
'' TYPE NAME to have a type of its own before the member access above it can look
'' anything up in it.
namespace NS
    type U
        as long pad
        static as integer val
    end type
end namespace

dim shared as integer NS.U.val = 5

dim tv as T
tv.Bump( )
T.counter += 2
NS.U.val += 1
print T.counter, NS.U.val
