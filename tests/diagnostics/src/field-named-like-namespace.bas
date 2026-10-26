'' tests/diagnostics/field-named-like-namespace.test
namespace enc
    enum Kind
        A = 0
        B = 1
    end enum
    function KindName( byval k as Kind ) as string
        if k = Kind.B then return "B"
        return "A"
    end function
end namespace

type W
    E2 as enc.Kind
    Enc as enc.Kind = enc.Kind.B
    declare sub Show( )
end type

sub W.Show( )
    print enc.KindName( Enc )
    print E2.A
end sub

dim as W x
x.Show( )
