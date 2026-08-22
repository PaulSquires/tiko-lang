'' Four typing gaps, each of which left a variable with a VOID SLOT and a store into
'' it that the MIR verifier then reported three passes away from the cause.

'' 1. AN ENUM DECAYS TO ITS UNDERLYING INTEGER for arithmetic -- measured,
'' 'typeof( e + 69 )' is INTEGER. The enum itself typed fine, which is what made this
'' puzzling: it was the BINARY that fell out, at the builtin-only guard.
enum thing explicit
    one
    two
end enum

dim as thing a_thing
var res = a_thing + 69

'' 2. A PROCEDURE has no type of its own on its symbol -- that slot holds its RETURN
'' type -- so '@mysub' came back untyped. Measured: fbc says 'typeof( @mysub )' is
'' 'SUB()', the procedure type itself, which is already a pointer in FreeBASIC and so
'' is NOT wrapped again.
sub mysub( )
end sub

var f = @mysub

'' 3. A KEYWORD COMPONENT of a qualified type name takes its SPELLING, not its
'' literal: a keyword token's 'literal' is not the name, so this produced a type
'' reference with no name at all. Unqualified 'dim as line m' inside the namespace
'' always worked, because the base-name path already made that distinction.
namespace ns_a
    type line
        x as integer
    end type
end namespace

dim as ns_a.line l

res = 1
f = 0
l.x = 2
