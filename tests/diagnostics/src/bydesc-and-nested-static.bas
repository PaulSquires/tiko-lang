'' A BYDESC PARAMETER TAKES AN ARRAY OF EXACTLY ITS ELEMENT TYPE -- fbc error 58. Measured:
'' 'a() as P1' given a P2 array is refused, and so is 'a() as Base' given a DERIVED array;
'' there is no slicing through a descriptor. The same element type is the accepted case.
''
'' A STATIC MEMBER VARIABLE BELONGS TO A TOPLEVEL TYPE -- fbc error 264. Measured: a type
'' declared inside a SCOPE block or a SUB is refused; inside a NAMESPACE, or nested in
'' another TYPE, it is accepted.
type P1
    i as integer
end type
type P2
    i as integer
end type
type Rt
    i as integer
end type
type Lf extends Rt
    j as integer
end type

sub takesP1( a() as P1 )
end sub
sub takesRt( a() as Rt )
end sub

dim ap1(1 to 3) as P1, ap2(1 to 3) as P2, alf(1 to 3) as Lf
takesP1( ap1() )

namespace ns
    type OkInNamespace
        dummy as integer
        static s as integer
    end type
end namespace

takesP1( ap2() )
takesRt( alf() )

scope
    type InScope
        dummy as integer
        static s as integer
    end type
end scope

sub proc( )
    type InProc
        dummy as integer
        static s as integer
    end type
end sub
