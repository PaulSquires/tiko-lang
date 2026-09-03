'' WHAT AN AGGREGATE INITIALIZER CANNOT FILL -- both fbc's error 24, and the two halves
'' differ in exactly one way, which was measured: a VAR-LEN STRING field is refused
'' wherever the variable lives, while a BITFIELD is refused only when the storage is
'' static. A local aggregate is filled by generated code rather than by the loader, and
'' fbc will do that for a bitfield but not for a string.
type HasString
    s as string
end type
type HasBitfield
    a : 1 as integer
    b : 1 as integer
end type
type Plain
    i as integer
end type
dim shared sv as string
'' Accepted: no initializer at all, and a plain UDT with one.
dim shared noInit as HasString
dim shared plainInit as Plain = ( 1 )
'' Accepted: a TUPLE, even though it is synthesised as a UDT holding a string.
dim as (long, string) tup = ( 1, "hello" )
'' Accepted: with a CONSTRUCTOR the parentheses are a call, and no field is filled by a
'' list at all -- so the string it holds is not this rule's business.
type HasStringAndCtor
    s as string
    declare constructor( byval n as integer )
end type
constructor HasStringAndCtor( byval n as integer )
end constructor
dim shared viaCtor as HasStringAndCtor = ( 5678 )
'' Refused: a var-len string field, from a literal or a variable, at any storage.
dim shared fromLiteral as HasString = ( "123" )
dim shared fromVar as HasString = ( sv )
'' Refused: a bitfield in static storage, written either way.
dim shared bitStatic as HasBitfield = ( 1, 0 )
var shared bitTypeIni = type<HasBitfield>( 1, 0 )
sub localScope( )
    '' Refused here too: the string does not care where the variable lives.
    dim localString as HasString = ( "123" )
    '' Accepted: a LOCAL bitfield is filled by generated code.
    dim localBits as HasBitfield = ( 1, 0 )
end sub
