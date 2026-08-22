'' AN ENUM CONVERTS AS ITS UNDERLYING INTEGER when an overload is scored.
''
'' It did not, so every enum argument scored "no conversion" against every numeric
'' parameter and a call like 'Mk( A0 )' matched NO overload at all.
''
'' THE EFFECT WAS NOT A DIAGNOSTIC. The callee still bound -- there is only one Mk --
'' so the call was emitted with a VOID RESULT, and whatever consumed it declined:
''
''     call void _ZN1N2MKEh(%2)      <- the result went nowhere
''     %3 = load @$tmp0              <- and the return read an uninitialised slot
''
'' 'return Something( SOME_ENUM_MEMBER )' out of a UDT-returning function is how the tui
'' headers write nearly everything, which is why one missing tier in the cost table was
'' worth several hundred statements.
''
'' The binary-operator path two hundred lines above ConversionCost already made exactly
'' this substitution; the two now agree.

namespace N

enum K
    A0 = 0
    A1
end enum

type C
    as ubyte kind
    as ubyte r, g, b
    declare constructor( )
end type

private constructor C( )
    kind = A0
end constructor

private function Mk( byval idx as ubyte ) as C
    dim as C c
    c.kind = A1
    c.r = idx and 15
    return c
end function

'' The call below must come out 'call agg', not 'call void'.
private function Blk( ) as C
    return Mk( A0 )
end function

end namespace
