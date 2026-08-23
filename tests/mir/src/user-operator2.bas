'' The rest of the user-operator surface, and two shapes around it.
namespace NS
type D
    v as long
end type

'' ONE PARAMETER MEANS TWO DIFFERENT THINGS. Inside a TYPE it is a binary operator
'' whose left operand is the receiver; OUTSIDE one it is UNARY. Costing a global unary
'' operator as if it were the member form let 'operator -( byref a as D )' win the
'' BINARY '-' and be called with one operand.
private operator - ( byref a as D, byref b as D ) as D
    dim r as D
    return r
end operator
private operator / ( byref a as D, byref b as D ) as D
    dim r as D
    return r
end operator
private operator - ( byref a as D ) as D
    dim r as D
    return r
end operator
end namespace
using NS

sub G( )
    dim as D r, q
    '' A SINGLE ELEMENT OF THE TYPE ITSELF IS NOT A FIELD LIST. This has to be written
    '' with the outer parentheses -- fbc cannot parse the operator otherwise, and
    '' fb/fintvm.bi says so in a comment beside every one -- so reading them as an
    '' initialiser stored a whole D into its first FIELD.
    dim as D a = ( ( r - r ) / r )
    dim as D b = -r
    q = ( r - r ) / r
end sub
