'' The mangling probe corpus. Every shape whose symbol name fbx must reproduce
'' byte for byte; the expected names are extracted from fbc, never written by hand.
type UDT
    as long q
end type

enum ENM
    E1
end enum

'' ---- unmangled: module level, no OVERLOAD, default linkage. Uppercased only.
sub Plain( )
end sub
function Ret( byval a as long ) as integer
    return 0
end function
private sub Hidden( )
end sub
sub Aliased alias "my_alias" ( )
end sub

'' ---- OVERLOAD alone forces mangling, even with a single overload.
sub Solo overload ( byval a as long )
end sub
sub Ovl overload ( byval a as long )
end sub
sub Ovl overload ( byval a as double )
end sub
sub Ovl overload ( byref s as string )
end sub
sub AliasMangled overload alias "lower_case" ( byval a as long )
end sub

'' ---- foreign linkage: verbatim, case preserved, OVERLOAD ignored.
extern "C"
    sub CFunc overload ( byval a as long )
    end sub
end extern
extern "Windows"
    sub WFunc( byval a as long )
    end sub
end extern

'' ---- the builtin type codes, one namespace each so the names stay distinct.
namespace TB
    sub B01 ( byval a as byte )
    end sub
    sub B02 ( byval a as ubyte )
    end sub
    sub B03 ( byval a as short )
    end sub
    sub B04 ( byval a as ushort )
    end sub
    sub B05 ( byval a as long )
    end sub
    sub B06 ( byval a as ulong )
    end sub
    sub B07 ( byval a as integer )
    end sub
    sub B08 ( byval a as uinteger )
    end sub
    sub B09 ( byval a as longint )
    end sub
    sub B10 ( byval a as ulongint )
    end sub
    sub B11 ( byval a as single )
    end sub
    sub B12 ( byval a as double )
    end sub
    sub B13 ( byval a as string )
    end sub
    sub B14 ( byval a as boolean )
    end sub
    sub B15 ( byval a as zstring ptr )
    end sub
    sub B16 ( byval a as wstring ptr )
    end sub
    sub B17 ( byval a as any ptr )
    end sub
    sub B18 ( byval a as long ptr )
    end sub
    sub B19 ( byval a as long ptr ptr )
    end sub
    sub B20 ( byval a as const long ptr )
    end sub
    sub B21 ( byval a as UDT )
    end sub
    sub B22 ( byval a as UDT ptr )
    end sub
    sub B23 ( byval a as ENM )
    end sub
    sub B24 ( byval a as sub ( ) ptr )
    end sub
    sub B25 ( byval a as function ( ) as long ptr )
    end sub
    sub B26 ( byref a as long )
    end sub
    sub B27 ( byref a as const long )
    end sub
    sub B28 ( byref a as string )
    end sub
    sub B29 ( byref a as UDT )
    end sub
    sub B30 ( )
    end sub
end namespace

'' ---- substitutions: a repeated component is a back-reference, never re-encoded.
namespace SUBST
    sub S2 ( byval a as UDT, byval b as UDT )
    end sub
    sub S3 ( byval a as UDT ptr, byval b as UDT ptr, byval c as UDT ptr )
    end sub
    sub S4 ( byval a as string, byval b as string )
    end sub
    sub S5 ( byval a as long ptr, byval b as long ptr )
    end sub
    sub S6 ( byval a as integer, byval b as integer )
    end sub
    sub S7 ( byval a as UDT, byval b as UDT ptr, byval c as UDT )
    end sub
end namespace

'' ---- nesting.
namespace A
    namespace B
        namespace C
            sub Deep( byval x as long )
            end sub
        end namespace
    end namespace
end namespace

namespace ns_low
    sub NsAlias alias "ns_lower" ( byval a as long )
    end sub
end namespace

'' ---- members: methods, ctor/dtor, properties, operators, const and static.
type W
    as long v
    declare constructor( )
    declare constructor( byval n as long )
    declare destructor( )
    declare sub M( byval a as long )
    declare function G( ) as long
    declare property Size( )as long
    declare property Size( byval n as long )
    declare operator let ( byref rhs as W )
    declare operator cast ( ) as long
    declare operator cast ( ) as string
    declare static sub St( )
    declare const function CF( ) as long
end type
constructor W( )
end constructor
constructor W( byval n as long )
end constructor
destructor W( )
end destructor
sub W.M( byval a as long )
end sub
function W.G( ) as long
    return 0
end function
property W.Size( ) as long
    return 0
end property
property W.Size( byval n as long )
end property
operator W.let ( byref rhs as W )
end operator
operator W.cast ( ) as long
    return 0
end operator
operator W.cast ( ) as string
    return ""
end operator
static sub W.St( )
end sub
const function W.CF( ) as long
    return 0
end function

'' A TYPEDEF IS TRANSPARENT in the ABI: 'as tdLong' must mangle exactly as 'as long'.
'' Measured -- fbc gives _Z1Fi for both -- so the alias leaves no trace at all, and a
'' compiler that encoded it as a named type would emit a symbol nothing links against.
type tdLong as long
type tdPtr as long ptr
sub TdA overload( byval tdx as tdLong )
end sub
sub TdB overload( byval tdx as long )
end sub
sub TdC overload( byval tdx as tdPtr )
end sub
sub TdD overload( byval tdx as unsigned tdLong )
end sub

'' OPERATORS. The Itanium two-character codes are not derivable from the spelling, and
'' '+' and '-' depend on ARITY -- binary is pl/mi, unary ps/ng. The two FreeBASIC has
'' that C++ does not are spelled by their KEYWORD name in the vendor-extended form:
'' '' is v24idiv and '^' is v23pow, not by their punctuation.
namespace mgops
    type OpD
        a as long
    end type
    operator =  ( byref a as OpD, byref b as OpD ) as boolean : operator = 0 : end operator
    operator <> ( byref a as OpD, byref b as OpD ) as boolean : operator = 0 : end operator
    operator <  ( byref a as OpD, byref b as OpD ) as boolean : operator = 0 : end operator
    operator <= ( byref a as OpD, byref b as OpD ) as boolean : operator = 0 : end operator
    operator >  ( byref a as OpD, byref b as OpD ) as boolean : operator = 0 : end operator
    operator >= ( byref a as OpD, byref b as OpD ) as boolean : operator = 0 : end operator
    operator +  ( byref a as OpD, byref b as OpD ) as OpD : dim as OpD r : operator = r : end operator
    operator -  ( byref a as OpD, byref b as OpD ) as OpD : dim as OpD r : operator = r : end operator
    operator *  ( byref a as OpD, byref b as OpD ) as OpD : dim as OpD r : operator = r : end operator
    operator /  ( byref a as OpD, byref b as OpD ) as OpD : dim as OpD r : operator = r : end operator
    operator \  ( byref a as OpD, byref b as OpD ) as OpD : dim as OpD r : operator = r : end operator
    operator mod( byref a as OpD, byref b as OpD ) as OpD : dim as OpD r : operator = r : end operator
    operator shl( byref a as OpD, byval n as long ) as OpD : dim as OpD r : operator = r : end operator
    operator shr( byref a as OpD, byval n as long ) as OpD : dim as OpD r : operator = r : end operator
    operator and( byref a as OpD, byref b as OpD ) as OpD : dim as OpD r : operator = r : end operator
    operator or ( byref a as OpD, byref b as OpD ) as OpD : dim as OpD r : operator = r : end operator
    operator xor( byref a as OpD, byref b as OpD ) as OpD : dim as OpD r : operator = r : end operator
    operator ^  ( byref a as OpD, byref b as OpD ) as OpD : dim as OpD r : operator = r : end operator
    operator -  ( byref a as OpD ) as OpD : dim as OpD r : operator = r : end operator
    operator +  ( byref a as OpD ) as OpD : dim as OpD r : operator = r : end operator
    operator not( byref a as OpD ) as OpD : dim as OpD r : operator = r : end operator

    '' 'operator []' IS TWO TOKENS AND ONE NAME, and its code is 'ix'. Taking only the
    '' '[' left the ']' where the parameter list was expected, so the list was lost too
    '' and the operator reached lowering with nothing but a receiver.
    type OpIx
        v as long
        declare operator [] ( byval i as long ) byref as long
    end type
    operator OpIx.[] ( byval i as long ) byref as long
        return this.v
    end operator
end namespace
