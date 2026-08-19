'' check.bas -- expression typing. See check.bi for the measured promotion rules and
'' for why each of them is not what a C programmer would guess.

#include once "symbols/check.bi"

namespace Fbx.Check

type Ctx
    as Fbx.AstArena ptr         ast
    as Fbx.SymbolTable ptr      syms
    as Fbx.TypeContext ptr      types
    as Fbx.Interner ptr         names
    as Fbx.DiagnosticEngine ptr diags
    as Fbx.SemanticInfo ptr     info
    as Stats ptr                st
    '' How deep the CONST-initialiser chain is. 'const A = B' takes its type from B,
    '' so a circular pair would recurse until the stack ran out; a compiler must not
    '' fall over on input fbc merely rejects.
    as long                     constDepth
end type

const CONST_DEPTH_MAX as long = 64

'' ------------------------------------------------------------------- classes

declare function IsPointerSized_ _
    ( byval b as Fbx.BuiltinType, byref types as Fbx.TypeContext ) as boolean
declare function PointerCost_ _
    ( byval from_ as Fbx.TypeId, byval to_ as Fbx.TypeId, _
      byval srcP as boolean, byval dstP as boolean, _
      byref types as Fbx.TypeContext, byval overloaded as boolean ) as long

private function IsFloat_( byval b as Fbx.BuiltinType ) as boolean
    return (b = Fbx.TY_SINGLE) orelse (b = Fbx.TY_DOUBLE)
end function

private function IsInt_( byval b as Fbx.BuiltinType ) as boolean
    select case b
    case Fbx.TY_BYTE, Fbx.TY_UBYTE, Fbx.TY_SHORT, Fbx.TY_USHORT, _
         Fbx.TY_LONG, Fbx.TY_ULONG, Fbx.TY_INTEGER, Fbx.TY_UINTEGER, _
         Fbx.TY_LONGINT, Fbx.TY_ULONGINT
        return true
    end select
    return false
end function

'' The 64-bit UNSIGNED types, and only those, make an integer result UINTEGER.
'' 'ulong + ulong' is INTEGER: signed 64 holds every unsigned 32 value, so nothing
'' forces the result unsigned.
private function IsUnsigned64_( byval b as Fbx.BuiltinType ) as boolean
    return (b = Fbx.TY_UINTEGER) orelse (b = Fbx.TY_ULONGINT)
end function

private function IsStringy_( byval b as Fbx.BuiltinType ) as boolean
    select case b
    case Fbx.TY_STRING, Fbx.TY_ZSTRING, Fbx.TY_WSTRING, Fbx.TY_USTRING
        return true
    end select
    return false
end function

'' ------------------------------------------------------------ operator classes

private function IsComparison_( byval op as Fbx.TokenKind ) as boolean
    select case op
    case Fbx.TK_EQ, Fbx.TK_NE, Fbx.TK_LT, Fbx.TK_GT, Fbx.TK_LE, Fbx.TK_GE
        return true
    end select
    return false
end function

'' AND, OR, XOR, EQV, IMP: bitwise on integers, logical on booleans.
private function IsBitwise_( byval op as Fbx.TokenKind ) as boolean
    select case op
    case Fbx.KW_AND, Fbx.KW_OR, Fbx.KW_XOR, Fbx.KW_EQV, Fbx.KW_IMP
        return true
    end select
    return false
end function

'' ANDALSO and ORELSE are NOT the bitwise operators with short-circuiting bolted on.
'' They are BOOLEAN when both sides are and INTEGER in every other case -- never
'' UINTEGER, even for 'uinteger andalso uinteger', where AND would give UINTEGER.
'' They also reject nothing except a string operand.
private function IsShortCircuit_( byval op as Fbx.TokenKind ) as boolean
    return (op = Fbx.KW_ANDALSO) orelse (op = Fbx.KW_ORELSE)
end function

'' The operators whose result is an INTEGER even when handed floats: '\', MOD, SHL,
'' SHR. They convert first and are not the same operator as '/'.
private function IsIntegerOp_( byval op as Fbx.TokenKind ) as boolean
    select case op
    case Fbx.TK_BACKSLASH, Fbx.KW_MOD, Fbx.KW_SHL, Fbx.KW_SHR
        return true
    end select
    return false
end function

private function IsArith_( byval op as Fbx.TokenKind ) as boolean
    select case op
    case Fbx.TK_PLUS, Fbx.TK_MINUS, Fbx.TK_STAR
        return true
    end select
    return false
end function

'' ------------------------------------------------------------------ promotion

'' The integer result of a numeric pair: UINTEGER when either side is 64-bit
'' unsigned, INTEGER otherwise. Nothing narrower is ever produced.
private function IntResult_ _
    ( byval lb as Fbx.BuiltinType, byval rb as Fbx.BuiltinType, _
      byref types as Fbx.TypeContext ) as Fbx.TypeId

    if IsUnsigned64_( lb ) orelse IsUnsigned64_( rb ) then
        return types.Builtin( Fbx.TY_UINTEGER )
    end if
    return types.Builtin( Fbx.TY_INTEGER )
end function

function BinaryResult _
    ( byval op as Fbx.TokenKind, byval lhs as Fbx.TypeId, byval rhs as Fbx.TypeId, _
      byref types as Fbx.TypeContext ) as Fbx.TypeId

    if (lhs = Fbx.TYPE_NONE) orelse (rhs = Fbx.TYPE_NONE) then return Fbx.TYPE_NONE

    '' '&' is FreeBASIC's concatenation operator and is ALWAYS a string, whatever it
    '' is handed -- 'long & long' is STRING. It converts rather than rejecting, so it
    '' is decided before any of the numeric rules and before the builtin-only guard:
    '' concatenating a UDT with a CAST operator is still a string.
    if op = Fbx.TK_AMP then return types.Builtin( Fbx.TY_STRING )
    '' Only builtin operands are decided here. A UDT operand means an overloaded
    '' operator, which is overload resolution's business, not this table's.
    if types.Kind( lhs ) <> Fbx.TK_BUILTIN then return Fbx.TYPE_NONE
    if types.Kind( rhs ) <> Fbx.TK_BUILTIN then return Fbx.TYPE_NONE

    dim as Fbx.BuiltinType lb = types.BuiltinOf( lhs )
    dim as Fbx.BuiltinType rb = types.BuiltinOf( rhs )
    dim as boolean lStr = IsStringy_( lb )
    dim as boolean rStr = IsStringy_( rb )
    dim as boolean lNum = IsInt_( lb ) orelse IsFloat_( lb )
    dim as boolean rNum = IsInt_( rb ) orelse IsFloat_( rb )
    dim as boolean lBool = (lb = Fbx.TY_BOOLEAN)
    dim as boolean rBool = (rb = Fbx.TY_BOOLEAN)

    '' Strings concatenate with '+' and compare with anything; every other operator
    '' rejects them, and mixing a string with a number rejects too.
    if lStr orelse rStr then
        if (lStr = false) orelse (rStr = false) then return Fbx.TYPE_NONE
        if IsComparison_( op ) then return types.Builtin( Fbx.TY_INTEGER )
        if op = Fbx.TK_PLUS then return types.Builtin( Fbx.TY_STRING )
        return Fbx.TYPE_NONE
    end if

    '' Equality and ordering differ on BOOLEAN, which is the sort of distinction only
    '' a measurement finds: '=' and '<>' accept a boolean against anything -- BOOLEAN
    '' when both sides are, INTEGER otherwise -- while '<', '>', '<=' and '>=' reject
    '' BOOLEAN outright, including 'boolean < boolean'.
    if IsComparison_( op ) then
        if (op = Fbx.TK_EQ) orelse (op = Fbx.TK_NE) then
            if lBool andalso rBool then return types.Builtin( Fbx.TY_BOOLEAN )
            return types.Builtin( Fbx.TY_INTEGER )
        end if
        if lBool orelse rBool then return Fbx.TYPE_NONE
        return types.Builtin( Fbx.TY_INTEGER )
    end if

    if IsShortCircuit_( op ) then
        if lBool andalso rBool then return types.Builtin( Fbx.TY_BOOLEAN )
        if (lBool orelse lNum) andalso (rBool orelse rNum) then
            return types.Builtin( Fbx.TY_INTEGER )
        end if
        return Fbx.TYPE_NONE
    end if

    if IsBitwise_( op ) then
        if lBool andalso rBool then return types.Builtin( Fbx.TY_BOOLEAN )
        if (lBool orelse lNum) andalso (rBool orelse rNum) then
            return IntResult_( lb, rb, types )
        end if
        return Fbx.TYPE_NONE
    end if

    '' Arithmetic rejects BOOLEAN outright: 'boolean + boolean' is an error, unlike
    '' 'boolean and long', which is not.
    if lBool orelse rBool then return Fbx.TYPE_NONE
    if (lNum = false) orelse (rNum = false) then return Fbx.TYPE_NONE

    if IsIntegerOp_( op ) then return IntResult_( lb, rb, types )
    if op = Fbx.TK_CARET then return types.Builtin( Fbx.TY_DOUBLE )

    '' '/' is always floating point, and SINGLE only when BOTH sides are single --
    '' unlike '+', where a single against an integer stays single. 'long / single'
    '' is DOUBLE.
    if op = Fbx.TK_SLASH then
        if (lb = Fbx.TY_SINGLE) andalso (rb = Fbx.TY_SINGLE) then
            return types.Builtin( Fbx.TY_SINGLE )
        end if
        return types.Builtin( Fbx.TY_DOUBLE )
    end if

    if IsArith_( op ) = false then return Fbx.TYPE_NONE

    if (lb = Fbx.TY_DOUBLE) orelse (rb = Fbx.TY_DOUBLE) then
        return types.Builtin( Fbx.TY_DOUBLE )
    end if
    if (lb = Fbx.TY_SINGLE) orelse (rb = Fbx.TY_SINGLE) then
        return types.Builtin( Fbx.TY_SINGLE )
    end if
    return IntResult_( lb, rb, types )
end function


'' ----------------------------------------------------------- overload resolution

'' fbc's own preference order among the builtin types, which is NOT size order:
'' INTEGER sits before LONGINT even though both are 64-bit, and an argument of type
'' LONG offered 'integer' and 'longint' picks INTEGER. Rank is used only to break
'' ties within a conversion class, and to tell widening from narrowing.
private function Rank_( byval b as Fbx.BuiltinType ) as long
    select case b
    case Fbx.TY_BYTE     : return 1
    case Fbx.TY_UBYTE    : return 2
    case Fbx.TY_SHORT    : return 3
    case Fbx.TY_USHORT   : return 4
    case Fbx.TY_LONG     : return 5
    case Fbx.TY_ULONG    : return 6
    case Fbx.TY_INTEGER  : return 7
    case Fbx.TY_UINTEGER : return 8
    case Fbx.TY_LONGINT  : return 9
    case Fbx.TY_ULONGINT : return 10
    case Fbx.TY_SINGLE   : return 11
    case Fbx.TY_DOUBLE   : return 12
    end select
    return 0
end function

private function IsUnsignedInt_( byval b as Fbx.BuiltinType ) as boolean
    select case b
    case Fbx.TY_UBYTE, Fbx.TY_USHORT, Fbx.TY_ULONG, Fbx.TY_UINTEGER, Fbx.TY_ULONGINT
        return true
    end select
    return false
end function

'' What a pointer costs on one side of a conversion or the other. Split out of
'' ConversionCost only because the pointer rules share none of its machinery: no rank,
'' no width distance, no signedness of the POINTER -- only of what it points at.
private function PointeeNear_ _
    ( byval a as Fbx.TypeId, byval b as Fbx.TypeId, _
      byref types as Fbx.TypeContext ) as boolean

    '' Two pointees are near enough that fbc passes one for the other in silence when
    '' they are the same WIDTH and the same CLASS. Both halves are needed: 'ulong ptr'
    '' passes for 'long ptr' without a word, while 'single ptr' -- the same four bytes
    '' -- warns. WSTRING counts as an integer of its target width, which is what makes
    '' 'wstring ptr' and 'short ptr' interchangeable on Windows and not on Linux.
    if types.Kind( a ) <> Fbx.TK_BUILTIN then return false
    if types.Kind( b ) <> Fbx.TK_BUILTIN then return false
    dim as Fbx.BuiltinType ab = types.BuiltinOf( a )
    dim as Fbx.BuiltinType bb = types.BuiltinOf( b )
    if (ab = Fbx.TY_ANY) orelse (bb = Fbx.TY_ANY) then return false
    if IsFloat_( ab ) <> IsFloat_( bb ) then return false
    if types.Layout( a ).size <> types.Layout( b ).size then return false
    return types.Layout( a ).size > 0
end function

private function PointerCost_ _
    ( byval from_ as Fbx.TypeId, byval to_ as Fbx.TypeId, _
      byval srcP as boolean, byval dstP as boolean, _
      byref types as Fbx.TypeContext, byval overloaded as boolean ) as long

    if srcP andalso dstP then
        '' Identical pointer types were already answered CONV_EXACT by the caller, so
        '' what is left is a mismatch.
        dim as Fbx.TypeId di = types.Inner( to_ )
        if types.Kind( di ) = Fbx.TK_BUILTIN then
            if types.BuiltinOf( di ) = Fbx.TY_ANY then return CONV_PTR_ANY
        end if
        dim as Fbx.TypeId si = types.Inner( from_ )
        if types.Kind( si ) = Fbx.TK_BUILTIN then
            if types.BuiltinOf( si ) = Fbx.TY_ANY then return CONV_PTR_NEAR
        end if
        if PointeeNear_( si, di, types ) then return CONV_PTR_NEAR
        '' The warning-3 tier. Accepted on its own; gone the moment there is a choice.
        if overloaded then return CONV_NONE
        return CONV_PTR_OTHER
    end if

    if srcP then
        '' A pointer reaches an integer of POINTER WIDTH and nothing else -- not
        '' 'long', not 'double', not 'boolean', and not 'string'. It reaches none of
        '' them at all once the procedure is overloaded: offered 'string' and
        '' 'integer', a pointer argument makes fbc refuse rather than take integer.
        if overloaded then return CONV_NONE
        if types.Kind( to_ ) <> Fbx.TK_BUILTIN then return CONV_NONE
        if IsPointerSized_( types.BuiltinOf( to_ ), types ) = false then return CONV_NONE
        return CONV_PTR_CLASS
    end if

    '' A non-pointer reaching a pointer. The string family reaches ONLY a pointer to a
    '' string, which is the conversion fbcunit's CU_ASSERT_ is built out of.
    if types.Kind( from_ ) <> Fbx.TK_BUILTIN then return CONV_NONE
    dim as Fbx.BuiltinType srcB = types.BuiltinOf( from_ )
    dim as Fbx.TypeId pointee = types.Inner( to_ )
    dim as Fbx.BuiltinType dstB = Fbx.TY_NONE
    if types.Kind( pointee ) = Fbx.TK_BUILTIN then dstB = types.BuiltinOf( pointee )

    if IsStringy_( srcB ) then
        if (dstB <> Fbx.TY_ZSTRING) andalso (dstB <> Fbx.TY_WSTRING) then return CONV_NONE
        '' A ZSTRING * n -- which is what a string LITERAL is -- prefers 'zstring ptr';
        '' a WSTRING * n prefers 'wstring ptr'. A var-len STRING is neither, and takes
        '' zstring before wstring.
        if srcB = dstB then return CONV_STRPTR_SAME
        if srcB = Fbx.TY_STRING then
            if dstB = Fbx.TY_ZSTRING then return CONV_STRPTR_OTHER
            return CONV_STRPTR_OTHER + 10
        end if
        return CONV_STRPTR_OTHER
    end if

    '' An integer of pointer width. This one stays viable when overloaded -- it is
    '' warning 1, 'Passing scalar as pointer', and fbc treats the two warnings
    '' differently: offered 'any ptr' and 'string', the argument 1 takes any ptr.
    if IsPointerSized_( srcB, types ) = false then return CONV_NONE
    return CONV_PTR_CLASS
end function

'' 'zstring * 8' as the string type it IS, or TYPE_NONE.
''
'' A fixed-length string is modelled as an ARRAY of the string element, which is what
'' it is and which makes its layout fall out of the array rule. Nothing else is: fbc
'' REFUSES a bare 'zstring' array -- "Expected pointer" -- so an array whose element is
'' the zstring or wstring builtin can only be a fixed-length string, never an array of
'' them. 'zstring * 4 z(0 to 7)' nests, and it is the INNER array that is the string.
function FixedStringElem _
    ( byval t as Fbx.TypeId, byref types as Fbx.TypeContext ) as Fbx.TypeId

    if t = Fbx.TYPE_NONE then return Fbx.TYPE_NONE
    if types.Kind( t ) <> Fbx.TK_ARRAY then return Fbx.TYPE_NONE
    dim as Fbx.TypeId e = types.Inner( t )
    if types.Kind( e ) <> Fbx.TK_BUILTIN then return Fbx.TYPE_NONE
    select case types.BuiltinOf( e )
    case Fbx.TY_ZSTRING, Fbx.TY_WSTRING, Fbx.TY_USTRING
        return e
    end select
    return Fbx.TYPE_NONE
end function

function ConversionCost _
    ( byval from_ as Fbx.TypeId, byval to_ as Fbx.TypeId, _
      byref types as Fbx.TypeContext, _
      byval overloaded as boolean = false ) as long

    if (from_ = Fbx.TYPE_NONE) orelse (to_ = Fbx.TYPE_NONE) then return CONV_NONE
    if from_ = to_ then return CONV_EXACT

    '' A fixed-length string converts as the string type it is. Its LENGTH plays no
    '' part, and cannot: fbc refuses 'byval x as zstring * 4' outright -- error 59,
    '' "Illegal specification" -- so no parameter ever has one of these types and no
    '' length-to-length question arises.
    dim as Fbx.TypeId fsrc = FixedStringElem( from_, types )
    if fsrc <> Fbx.TYPE_NONE then from_ = fsrc
    dim as Fbx.TypeId fdst = FixedStringElem( to_, types )
    if fdst <> Fbx.TYPE_NONE then to_ = fdst
    if from_ = to_ then return CONV_EXACT

    '' POINTERS, before the builtin-only tiers below. Everything here is measured in
    '' tests/types/expected/fbc-ptr.txt; the shape a cost model would guess -- pointee
    '' compatibility, a distance between pointee types -- is not the shape fbc has.
    dim as boolean srcP = (types.Kind( from_ ) = Fbx.TK_POINTER)
    dim as boolean dstP = (types.Kind( to_ ) = Fbx.TK_POINTER)
    if srcP orelse dstP then
        return PointerCost_( from_, to_, srcP, dstP, types, overloaded )
    end if

    if types.Kind( from_ ) <> Fbx.TK_BUILTIN then return CONV_NONE
    if types.Kind( to_ ) <> Fbx.TK_BUILTIN then return CONV_NONE

    '' Named srcB / dstB, not fb / tb: 'fb' is the FB namespace, and FreeBASIC is
    '' case-insensitive, so a local called fb shadows it.
    dim as Fbx.BuiltinType srcB = types.BuiltinOf( from_ )
    dim as Fbx.BuiltinType dstB = types.BuiltinOf( to_ )
    if srcB = dstB then return CONV_EXACT

    '' A string converts to a string and to nothing else, in either direction.
    if IsStringy_( srcB ) orelse IsStringy_( dstB ) then
        if IsStringy_( srcB ) andalso IsStringy_( dstB ) then return CONV_WIDEN
        return CONV_NONE
    end if

    dim as long sr = Rank_( srcB )
    dim as long dr = Rank_( dstB )

    '' BOOLEAN on either side is its own tier, dearer than any numeric conversion
    '' however lossy: offered 'byte' and 'boolean' for a DOUBLE argument, fbc takes
    '' byte. Within the tier a SIGNED parameter is preferred, then the lower rank --
    '' a boolean argument offered 'uinteger' and 'longint' takes longint.
    if (srcB = Fbx.TY_BOOLEAN) orelse (dstB = Fbx.TY_BOOLEAN) then
        dim as long b = CONV_BOOL
        if dr = 0 then return b + 1
        '' Within the tier, in order: the integer class beats the float class, then
        '' the nearest WIDTH, then SIGNED before unsigned, then rank. That last pair
        '' is what makes a boolean argument offered 'uinteger' and 'longint' take
        '' longint -- the only case in the table where the higher rank wins.
        if IsFloat_( dstB ) then b += 1000
        dim as long bs = types.Layout( to_ ).size - 1
        if bs < 0 then bs = -bs
        b += bs * 16
        if IsUnsignedInt_( dstB ) then b += 8
        return b + dr
    end if
    if (sr = 0) orelse (dr = 0) then return CONV_NONE

    '' Staying in the class beats changing it OUTRIGHT, even when staying means
    '' narrowing: offered 'short' and 'double' for a LONG argument, fbc takes short.
    dim as long cost = 0
    if IsFloat_( srcB ) <> IsFloat_( dstB ) then cost += CONV_CLASS

    '' Then SIZE: the same width beats a widening, and a widening beats a narrowing.
    '' 'byte' beats 'short' for a UBYTE argument (same width), while 'longint' beats
    '' 'short' for a LONG argument (widening rather than narrowing).
    dim as long ss = types.Layout( from_ ).size
    dim as long ds = types.Layout( to_ ).size
    '' Width dominates every later tiebreak: a LONG argument offered 'byte' and
    '' 'ushort' takes ushort, the nearer width, even though byte matches its
    '' signedness and ushort does not.
    if ds > ss then
        cost += CONV_WIDEN + (ds - ss) * 64
    elseif ds < ss then
        cost += CONV_NARROW + (ss - ds) * 64
    end if

    '' The remaining tiebreaks, strongest first.
    ''
    '' FAMILY: byte/ubyte, short/ushort, long/ulong, integer/uinteger and
    '' longint/ulongint are signed/unsigned partners. An argument prefers a candidate
    '' from its own pair -- which is the only thing that explains a LONGINT argument
    '' offered 'uinteger' and 'ulongint' taking ulongint, since both are unsigned,
    '' 8 bytes wide, and one rank step away.
    if (sr + 1) \ 2 <> (dr + 1) \ 2 then cost += 16

    '' SIGNEDNESS, which outranks BOTH family and rank distance. The four 8-byte
    '' cross pairs are what pin this down: a UINTEGER argument offered 'integer' and
    '' 'ulongint' takes ulongint -- matching signedness -- although integer is its
    '' own family partner and one rank step away.
    if IsUnsignedInt_( srcB ) <> IsUnsignedInt_( dstB ) then cost += 32

    '' Rank distance, but only WITHIN a class. Across the integer/float boundary it
    '' does not apply: a SINGLE argument offered 'integer' and 'longint' takes
    '' integer, though longint is nearer in rank.
    if IsFloat_( srcB ) = IsFloat_( dstB ) then
        dim as long rd = dr - sr
        if rd < 0 then rd = -rd
        cost += rd * 2
    end if

    return cost + dr
end function



'' -------------------------------------------------------- constant evaluation

'' Everything below matches fbc exactly, and most of it would be wrong if guessed:
''
''   - A true comparison is -1, not 1.
''   - '\' truncates TOWARD ZERO, so -7 \ 2 is -3, and MOD takes the sign of the
''     DIVIDEND: -7 mod 2 is -1 while 7 mod -2 is 1.
''   - SHR on a signed value is ARITHMETIC: -1 shr 1 stays -1.
''   - Shifts are done at 64 bits: 1 shl 32 is 4294967296, not 0.
''   - NOT is a bitwise complement, so 'not 0' is -1.

private function CV_( byval v as longint ) as ConstVal
    dim as ConstVal r
    r.known = true
    r.value = v
    r.bits = 64
    return r
end function

'' A value folded at a WIDTH. Anything narrower than 64 bits is sign-extended back, so
'' the stored value is always the one a 64-bit register would hold -- '1 shl 31' at 32
'' bits is -2147483648, not 2147483648.
private function CVW_( byval v as longint, byval bits as long ) as ConstVal
    dim as ConstVal r
    r.known = true
    r.bits = iif( bits <= 32, 32, 64 )
    if r.bits = 32 then
        r.value = cast( longint, cast( long, v ) )
    else
        r.value = v
    end if
    return r
end function

'' The width a binary operator folds at: the WIDER of its operands.
private function WiderOf_( byref a as ConstVal, byref b as ConstVal ) as long
    dim as long wa = iif( a.bits = 0, 64, a.bits )
    dim as long wb = iif( b.bits = 0, 64, b.bits )
    return iif( wa > wb, wa, wb )
end function

'' The width an INTEGER LITERAL has. Its suffix decides when it has one; otherwise it is
'' INTEGER -- pointer-width -- unless the value does not fit, when fbc promotes it to
'' LONGINT. Measured: on win32 'typeof( 5000000000 )' is LONGINT while
'' 'typeof( &hFFFFFFFF )' is INTEGER, and the second folds to -1.
private function LitBits_ _
    ( byval suffix as ubyte, byval v as longint, byval intBits as long ) as long

    select case cast( Fbx.NumSuffix, suffix )
    case Fbx.NSUF_LONG, Fbx.NSUF_ULONG, Fbx.NSUF_INTEGER, Fbx.NSUF_UINTEGER
        '' '%' and 'U' are INTEGER and UINTEGER, which are pointer-width; 'L' and 'UL'
        '' are LONG and ULONG, which are 32 everywhere.
        select case cast( Fbx.NumSuffix, suffix )
        case Fbx.NSUF_LONG, Fbx.NSUF_ULONG : return 32
        end select
        return intBits
    case Fbx.NSUF_LONGINT, Fbx.NSUF_ULONGINT
        return 64
    end select
    if intBits >= 64 then return 64
    if (v >= -2147483648ll) andalso (v <= 4294967295ll) then return 32
    return 64
end function

private function CVNone_( ) as ConstVal
    dim as ConstVal r
    return r
end function

'' A FreeBASIC truth value is -1, never 1.
private function CVBool_( byval b as boolean ) as ConstVal
    return CV_( iif( b, cast( longint, -1 ), cast( longint, 0 ) ) )
end function

private function IPow_( byval b as longint, byval e as longint ) as longint
    if e < 0 then return 0
    dim as longint r = 1
    for i as longint = 1 to e
        r *= b
    next
    return r
end function


'' The numeric value of a literal argument, as a double, so the rounding intrinsics
'' can see 2.5 rather than an integer. Returns false when it is not a literal.
private function LitNum_ _
    ( byref ast as Fbx.AstArena, byval id as Fbx.NodeId, byref d as double ) as boolean

    if id = Fbx.NODE_NONE then return false
    dim as Fbx.NodeKind k = ast.Kind( id )
    if k = Fbx.N_PAREN then
        dim as Fbx.ListPayload ptr pp = _
            @ast.lists[cast( long, ast.nodes[cast( long, id )].data )]
        if pp->count <> 1 then return false
        return LitNum_( ast, cast( Fbx.NodeId, ast.children[pp->first] ), d )
    end if
    if k = Fbx.N_UNARY then
        dim as Fbx.UnaryPayload ptr up = _
            @ast.unaries[cast( long, ast.nodes[cast( long, id )].data )]
        if LitNum_( ast, up->operand, d ) = false then return false
        if cast( Fbx.TokenKind, up->op ) = Fbx.TK_MINUS then d = -d
        return true
    end if
    dim as Fbx.LiteralPayload ptr lp = 0
    if (k = Fbx.N_FLOAT_LIT) orelse (k = Fbx.N_INT_LIT) then
        lp = @ast.literals[cast( long, ast.nodes[cast( long, id )].data )]
    end if
    if lp = 0 then return false
    if k = Fbx.N_FLOAT_LIT then
        d = lp->fltValue
    else
        d = cast( double, cast( longint, lp->intValue ) )
    end if
    return true
end function

'' CINT rounds HALF TO EVEN -- cint(2.5) is 2 and cint(3.5) is 4 -- which is the one
'' rule here nobody guesses right. INT floors, FIX truncates toward zero.
private function RoundHalfEven_( byval d as double ) as longint
    dim as double f = int( d )
    dim as double diff = d - f
    if diff > 0.5 then return cast( longint, f ) + 1
    if diff < 0.5 then return cast( longint, f )
    dim as longint fi = cast( longint, f )
    if (fi mod 2) = 0 then return fi
    return fi + 1
end function

'' The intrinsics fbc folds at compile time. Anything not listed simply does not fold,
'' which is an absence rather than an error.
private function ConstCall_ _
    ( byref ast as Fbx.AstArena, byval id as Fbx.NodeId, _
      byref src as Fbx.SourceManager, byref names as Fbx.Interner ) as ConstVal

    dim as Fbx.ListPayload ptr cp = _
        @ast.lists[cast( long, ast.nodes[cast( long, id )].data )]
    if cp->target = Fbx.NODE_NONE then return CVNone_( )
    if ast.Kind( cp->target ) <> Fbx.N_IDENT then return CVNone_( )
    dim as Fbx.IdentPayload ptr ip = _
        @ast.idents[cast( long, ast.nodes[cast( long, cp->target )].data )]
    dim as string nm = Fbx.Text.LowerAscii( names.Spelling( ip->name ) )

    if (nm = "iif") andalso (cp->count = 3) then
        dim as ConstVal c = ConstOf( ast, cast( Fbx.NodeId, ast.children[cp->first] ), _
                                     src, names )
        if c.known = false then return CVNone_( )
        dim as long pick = iif( c.value <> 0, 1, 2 )
        return ConstOf( ast, cast( Fbx.NodeId, ast.children[cp->first + pick] ), _
                        src, names )
    end if

    if cp->count <> 1 then return CVNone_( )
    dim as Fbx.NodeId a0 = cast( Fbx.NodeId, ast.children[cp->first] )

    '' LEN and ASC read the literal's SPAN out of the source buffer: the parser keeps
    '' the extent, not the decoded text.
    if (nm = "len") orelse (nm = "asc") then
        if ast.Kind( a0 ) <> Fbx.N_STRING_LIT then return CVNone_( )
        dim as Fbx.LiteralPayload ptr lp = _
            @ast.literals[cast( long, ast.nodes[cast( long, a0 )].data )]
        if nm = "len" then return CV_( lp->strLength )
        if lp->strLength <= 0 then return CVNone_( )
        dim as Fbx.DecodedLoc dl = src.Decode( ast.Loc( a0 ) )
        dim as Fbx.SourceFile ptr f = src.FileAt( dl.file )
        if f = 0 then return CVNone_( )
        if lp->strOffset >= f->text.Count then return CVNone_( )
        return CV_( f->text[lp->strOffset] )
    end if

    dim as double d = 0
    dim as boolean isNum = LitNum_( ast, a0, d )
    dim as ConstVal iv = ConstOf( ast, a0, src, names )

    select case nm
    case "abs"
        if iv.known then return CV_( abs( iv.value ) )
    case "sgn"
        if iv.known then return CV_( sgn( iv.value ) )
    case "cint", "clngint"
        if isNum then
            dim as longint r = RoundHalfEven_( d )
            if nm = "cint" then return CV_( r )
            return CV_( r )
        end if
    case "clng"
        '' CLNG targets 32 bits, and an out-of-range float does NOT wrap: fbc yields
        '' the x86 "indefinite" value, &h80000000, and warns about the overflow.
        '' Wrapping instead gives 1410065408 for clng(1e10) -- a plausible number and
        '' the wrong one. CINT is exempt because it targets 64-bit INTEGER, so
        '' cint(1e10) does not overflow at all.
        if isNum then
            dim as longint r = RoundHalfEven_( d )
            if (r > 2147483647ll) orelse (r < -2147483648ll) then
                return CV_( -2147483648ll )
            end if
            return CV_( r )
        end if
    case "int"
        if isNum then return CV_( cast( longint, int( d ) ) )
    case "fix"
        if isNum then return CV_( cast( longint, fix( d ) ) )
    end select
    return CVNone_( )
end function

function ConstOf _
    ( byref ast as Fbx.AstArena, byval id as Fbx.NodeId, _
      byref src as Fbx.SourceManager, byref names as Fbx.Interner, _
      byval intBits as long = 64 ) as ConstVal

    if id = Fbx.NODE_NONE then return CVNone_( )

    select case ast.Kind( id )
    case Fbx.N_INT_LIT
        dim as Fbx.LiteralPayload ptr lp = _
            @ast.literals[cast( long, ast.nodes[cast( long, id )].data )]
        dim as longint iv = cast( longint, lp->intValue )
        return CVW_( iv, LitBits_( lp->suffix, iv, intBits ) )

    case Fbx.N_PAREN
        dim as Fbx.ListPayload ptr pp = _
            @ast.lists[cast( long, ast.nodes[cast( long, id )].data )]
        if pp->count <> 1 then return CVNone_( )
        return ConstOf( ast, cast( Fbx.NodeId, ast.children[pp->first] ), src, names, intBits )

    case Fbx.N_UNARY
        dim as Fbx.UnaryPayload ptr up = _
            @ast.unaries[cast( long, ast.nodes[cast( long, id )].data )]
        dim as ConstVal v = ConstOf( ast, up->operand, src, names, intBits )
        if v.known = false then return CVNone_( )
        '' A unary operator folds at its OPERAND's width: 'not 0' is -1 either way, but
        '' '-(1 shl 31)' at 32 bits is 2147483648 rather than -2147483648.
        select case cast( Fbx.TokenKind, up->op )
        case Fbx.TK_MINUS : return CVW_( -v.value, v.bits )
        case Fbx.TK_PLUS  : return CVW_( v.value, v.bits )
        case Fbx.KW_NOT   : return CVW_( not v.value, v.bits )
        end select
        return CVNone_( )

    case Fbx.N_BINARY
        dim as Fbx.BinaryPayload ptr bp = _
            @ast.binaries[cast( long, ast.nodes[cast( long, id )].data )]
        dim as ConstVal l = ConstOf( ast, bp->lhs, src, names, intBits )
        if l.known = false then return CVNone_( )
        dim as ConstVal r = ConstOf( ast, bp->rhs, src, names, intBits )
        if r.known = false then return CVNone_( )
        dim as longint a = l.value
        dim as longint b = r.value
        '' The operator folds at the WIDER operand's width, and the result is narrowed
        '' back to it. A COMPARISON is not arithmetic: its result is INTEGER, so it takes
        '' the target's width whatever the operands were.
        dim as long w = WiderOf_( l, r )

        '' SHIFTS are done at the operand width, so '1 shl 31' is -2147483648 on win32
        '' and 2147483648 on win64, and '1 shl 32' is 1 there and 4294967296 here. That
        '' is a wrap, not an error: fbc warns and carries on.
        dim as longint sb = b
        if (w = 32) andalso (sb >= 0) then sb = sb and 31

        select case cast( Fbx.TokenKind, bp->op )
        case Fbx.TK_PLUS      : return CVW_( a + b, w )
        case Fbx.TK_MINUS     : return CVW_( a - b, w )
        case Fbx.TK_STAR      : return CVW_( a * b, w )
        case Fbx.TK_BACKSLASH
            if b = 0 then return CVNone_( )
            return CVW_( a \ b, w )
        case Fbx.KW_MOD
            if b = 0 then return CVNone_( )
            return CVW_( a mod b, w )
        case Fbx.TK_CARET     : return CVW_( IPow_( a, b ), w )
        case Fbx.KW_SHL       : return CVW_( a shl sb, w )
        case Fbx.KW_SHR
            '' SHR is ARITHMETIC, and at 32 bits it must shift the 32-bit value rather
            '' than the sign-extended one: '&hFFFFFFFF shr 4' is -1 shr 4 = -1.
            if w = 32 then return CVW_( cast( longint, cast( long, a ) ) shr sb, w )
            return CVW_( a shr sb, w )
        case Fbx.KW_AND       : return CVW_( a and b, w )
        case Fbx.KW_OR        : return CVW_( a or b, w )
        case Fbx.KW_XOR       : return CVW_( a xor b, w )
        case Fbx.KW_EQV       : return CVW_( a eqv b, w )
        case Fbx.KW_IMP       : return CVW_( a imp b, w )
        case Fbx.TK_EQ        : return CVBool_( a = b )
        case Fbx.TK_NE        : return CVBool_( a <> b )
        case Fbx.TK_LT        : return CVBool_( a < b )
        case Fbx.TK_GT        : return CVBool_( a > b )
        case Fbx.TK_LE        : return CVBool_( a <= b )
        case Fbx.TK_GE        : return CVBool_( a >= b )
        case Fbx.KW_ANDALSO   : return CVBool_( (a <> 0) andalso (b <> 0) )
        case Fbx.KW_ORELSE    : return CVBool_( (a <> 0) orelse (b <> 0) )
        end select
        return CVNone_( )

    case Fbx.N_CALL
        return ConstCall_( ast, id, src, names )
    end select

    return CVNone_( )
end function

'' ------------------------------------------------------------------ assignment

'' A pointer converts to and from an integer of POINTER WIDTH, with a warning, and to
'' nothing narrower. Written against the target layout rather than against 64, so it
'' stays right on a target where a pointer is not 8 bytes.
private function IsPointerSized_ _
    ( byval b as Fbx.BuiltinType, byref types as Fbx.TypeContext ) as boolean

    if IsInt_( b ) = false then return false
    return types.Layout( types.Builtin( b ) ).size = (types.target.pointerBits \ 8)
end function

function AssignableTo _
    ( byval src as Fbx.TypeId, byval dst as Fbx.TypeId, _
      byref types as Fbx.TypeContext ) as AssignKind

    if (src = Fbx.TYPE_NONE) orelse (dst = Fbx.TYPE_NONE) then return ASSIGN_OK
    if src = dst then return ASSIGN_OK

    dim as boolean srcPtr = (types.Kind( src ) = Fbx.TK_POINTER)
    dim as boolean dstPtr = (types.Kind( dst ) = Fbx.TK_POINTER)

    '' Pointer to pointer: silent when the pointees agree, or when either side is
    '' ANY PTR, which is the universal one. Between two DIFFERENT concrete pointees
    '' fbc allows it but warns -- 'long ptr = zstring ptr' is accepted with a
    '' complaint, and treating that as clean would hide a real behaviour difference.
    if srcPtr andalso dstPtr then
        dim as Fbx.TypeId sp2 = types.Inner( src )
        dim as Fbx.TypeId dp2 = types.Inner( dst )
        if sp2 = dp2 then return ASSIGN_OK
        if (types.Kind( sp2 ) = Fbx.TK_BUILTIN) andalso _
           (types.BuiltinOf( sp2 ) = Fbx.TY_ANY) then return ASSIGN_OK
        if (types.Kind( dp2 ) = Fbx.TK_BUILTIN) andalso _
           (types.BuiltinOf( dp2 ) = Fbx.TY_ANY) then return ASSIGN_OK
        return ASSIGN_WARN
    end if

    if srcPtr orelse dstPtr then
        dim as Fbx.TypeId other = iif( srcPtr, dst, src )
        if types.Kind( other ) <> Fbx.TK_BUILTIN then return ASSIGN_REJECT
        if IsPointerSized_( types.BuiltinOf( other ), types ) then return ASSIGN_WARN
        return ASSIGN_REJECT
    end if

    if (types.Kind( src ) <> Fbx.TK_BUILTIN) orelse _
       (types.Kind( dst ) <> Fbx.TK_BUILTIN) then
        return ASSIGN_OK        '' UDTs need overloaded LET; not decided here
    end if

    dim as Fbx.BuiltinType sb = types.BuiltinOf( src )
    dim as Fbx.BuiltinType db = types.BuiltinOf( dst )

    '' A string assigns to a string and to nothing else, in either direction.
    if IsStringy_( sb ) orelse IsStringy_( db ) then
        if IsStringy_( sb ) andalso IsStringy_( db ) then return ASSIGN_OK
        return ASSIGN_REJECT
    end if

    '' Everything numeric, BOOLEAN included, assigns to everything numeric. Narrowing
    '' is accepted silently -- there is no truncation warning to reproduce.
    return ASSIGN_OK
end function

'' --------------------------------------------------------------------- typing

'' The symbol of a field of a UDT, by name. The UDT's members live in the scope its
'' declaring symbol opened, which is reached from the type through the scope the type
'' was declared in -- the same pair that makes two namespaces' 'Vec' distinct types.
private function FieldOf_ _
    ( byref c as Ctx, byval t as Fbx.TypeId, byval nm as Fbx.InternId ) as Fbx.SymbolId

    if (t = Fbx.TYPE_NONE) orelse (nm = 0) then return Fbx.SYMBOL_NONE
    select case c.types->Kind( t )
    case Fbx.TK_UDT, Fbx.TK_FORWARD
    case else
        return Fbx.SYMBOL_NONE
    end select
    dim as Fbx.InternId tn = c.types->NameOf( t )
    if tn = 0 then return Fbx.SYMBOL_NONE
    dim as Fbx.ScopeId ds = cast( Fbx.ScopeId, c.types->DeclScopeOf( t ) )
    dim as Fbx.SymbolId ts = c.syms->LookupLocal( ds, tn )
    if ts = Fbx.SYMBOL_NONE then ts = c.syms->Lookup( ds, tn )
    dim as Fbx.Symbol ptr s = c.syms->SymbolAt( ts )
    if s = 0 then return Fbx.SYMBOL_NONE
    if s->inner = Fbx.SCOPE_NONE then return Fbx.SYMBOL_NONE
    return c.syms->LookupLocal( s->inner, nm )
end function

private function StmtOf _
    ( byref c as Ctx, byval id as Fbx.NodeId ) as Fbx.StmtPayload ptr
    return @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
end function

declare function TypeOf_ _
    ( byref c as Ctx, byval id as Fbx.NodeId ) as Fbx.TypeId

'' An integer literal is the narrowest of INTEGER / LONGINT that holds it, matching
'' fbc: small literals are INTEGER, which is pointer-sized, not LONG.
private function LiteralType_ _
    ( byref c as Ctx, byval id as Fbx.NodeId ) as Fbx.TypeId

    select case c.ast->Kind( id )
    case Fbx.N_INT_LIT
        return c.types->Builtin( Fbx.TY_INTEGER )
    case Fbx.N_FLOAT_LIT
        return c.types->Builtin( Fbx.TY_DOUBLE )
    case Fbx.N_STRING_LIT, Fbx.N_STRCAT
        return c.types->Builtin( Fbx.TY_STRING )
    end select
    return Fbx.TYPE_NONE
end function


'' Pick the overload for one call. Returns the chosen procedure's RETURN type, or
'' TYPE_NONE when nothing is viable or two candidates tie.
private function ResolveCall_ _
    ( byref c as Ctx, byval id as Fbx.NodeId, byval callee as Fbx.SymbolId, _
      byval cp as Fbx.ListPayload ptr ) as Fbx.TypeId

    '' Argument types first; an untyped argument makes the whole call undecidable
    '' rather than wrong.
    dim as FB.Array( of ulong ) argT
    for i as long = 0 to cp->count - 1
        dim as Fbx.NodeId a = cast( Fbx.NodeId, c.ast->children[cp->first + i] )
        dim as Fbx.TypeId at = TypeOf_( c, a )
        if at = Fbx.TYPE_NONE then return Fbx.TYPE_NONE
        argT.Push( cast( ulong, at ) )
    next

    dim as Fbx.SymbolId best = Fbx.SYMBOL_NONE
    dim as long bestCost = CONV_NONE
    dim as long ties = 0

    '' How many candidates there are CHANGES WHAT IS VIABLE, so it has to be known
    '' before any of them is costed. fbc accepts a warning-3 pointer conversion for a
    '' procedure called on its own and refuses the identical conversion the moment a
    '' second overload exists, however unviable that second one is.
    dim as long ncand = 0
    dim as Fbx.SymbolId walk = callee
    while walk <> Fbx.SYMBOL_NONE
        dim as Fbx.Symbol ptr ws = c.syms->SymbolAt( walk )
        if ws = 0 then exit while
        if ws->kind <> cast( ubyte, Fbx.SYM_PROC ) then exit while
        ncand += 1
        walk = ws->nextOverload
    wend
    dim as boolean overloaded = (ncand > 1)

    dim as Fbx.SymbolId cur = callee

    while cur <> Fbx.SYMBOL_NONE
        dim as Fbx.Symbol ptr s = c.syms->SymbolAt( cur )
        if s = 0 then exit while
        if s->kind <> cast( ubyte, Fbx.SYM_PROC ) then exit while
        dim as Fbx.NodeId pn = cast( Fbx.NodeId, s->payload )
        if (pn <> Fbx.NODE_NONE) andalso (c.ast->Kind( pn ) = Fbx.N_PROC) then
            dim as Fbx.StmtPayload ptr pp = StmtOf( c, pn )
            '' Only same-arity candidates are viable. Optional and variadic
            '' parameters are not modelled yet, so those procedures simply never win.
            dim as long np = 0
            for i as long = 0 to pp->count - 1
                dim as Fbx.NodeId prm = cast( Fbx.NodeId, c.ast->children[pp->first + i] )
                if c.ast->Kind( prm ) = Fbx.N_PARAM then np += 1
            next
            if np = argT.Count then
                dim as long total = 0
                dim as long ai = 0
                dim as boolean viable = true
                for i as long = 0 to pp->count - 1
                    dim as Fbx.NodeId prm = cast( Fbx.NodeId, c.ast->children[pp->first + i] )
                    if c.ast->Kind( prm ) <> Fbx.N_PARAM then continue for
                    dim as Fbx.StmtPayload ptr sp2 = StmtOf( c, prm )
                    dim as Fbx.TypeId pt = c.info->TypeOf_( sp2->a )
                    dim as long cost = ConversionCost( cast( Fbx.TypeId, argT[ai] ), _
                                                       pt, *c.types, overloaded )
                    ai += 1
                    if cost >= CONV_NONE then
                        viable = false
                        exit for
                    end if
                    total += cost
                next
                if viable then
                    if total < bestCost then
                        bestCost = total
                        best = cur
                        ties = 0
                    elseif total = bestCost then
                        ties += 1
                    end if
                end if
            end if
        end if
        cur = s->nextOverload
    wend

    if best = Fbx.SYMBOL_NONE then return Fbx.TYPE_NONE
    if ties > 0 then
        c.st->callsAmbiguous += 1
        return Fbx.TYPE_NONE
    end if
    c.st->callsResolved += 1
    c.info->SetRef( id, best )
    dim as Fbx.Symbol ptr bs = c.syms->SymbolAt( best )
    if bs = 0 then return Fbx.TYPE_NONE
    return bs->type_
end function


'' ------------------------------------------------- the conversion intrinsics

'' CSIGN / CUNSG. Measured in tests/types/expected/fbc-conv.txt, and not guessable: the
'' result is the argument's signed or unsigned COUNTERPART, and the argument itself
'' where there is none -- with a fixed-length string an asymmetric case, since 'cunsg'
'' of a ZSTRING * n is that same type while 'csign' of it is BYTE.
private function SignedFlip_ _
    ( byval t as Fbx.TypeId, byval wantUnsigned as boolean, _
      byref types as Fbx.TypeContext ) as Fbx.TypeId

    if t = Fbx.TYPE_NONE then return Fbx.TYPE_NONE

    '' A POINTER becomes a pointer-width integer of the requested signedness.
    if types.Kind( t ) = Fbx.TK_POINTER then
        if wantUnsigned then return types.Builtin( Fbx.TY_ULONGINT )
        return types.Builtin( Fbx.TY_LONGINT )
    end if

    dim as Fbx.TypeId fs = FixedStringElem( t, types )
    if fs <> Fbx.TYPE_NONE then
        if wantUnsigned then return t
        select case types.BuiltinOf( fs )
        case Fbx.TY_ZSTRING : return types.Builtin( Fbx.TY_BYTE )
        case Fbx.TY_WSTRING : return types.Builtin( Fbx.TY_SHORT )
        end select
        return t
    end if

    if types.Kind( t ) <> Fbx.TK_BUILTIN then return t
    dim as Fbx.BuiltinType b = types.BuiltinOf( t )
    if wantUnsigned then
        select case b
        case Fbx.TY_BYTE,    Fbx.TY_UBYTE    : return types.Builtin( Fbx.TY_UBYTE )
        case Fbx.TY_SHORT,   Fbx.TY_USHORT   : return types.Builtin( Fbx.TY_USHORT )
        case Fbx.TY_LONG,    Fbx.TY_ULONG    : return types.Builtin( Fbx.TY_ULONG )
        case Fbx.TY_INTEGER, Fbx.TY_UINTEGER : return types.Builtin( Fbx.TY_UINTEGER )
        case Fbx.TY_LONGINT, Fbx.TY_ULONGINT : return types.Builtin( Fbx.TY_ULONGINT )
        end select
        return t
    end if
    select case b
    case Fbx.TY_BYTE,    Fbx.TY_UBYTE    : return types.Builtin( Fbx.TY_BYTE )
    case Fbx.TY_SHORT,   Fbx.TY_USHORT   : return types.Builtin( Fbx.TY_SHORT )
    case Fbx.TY_LONG,    Fbx.TY_ULONG    : return types.Builtin( Fbx.TY_LONG )
    case Fbx.TY_INTEGER, Fbx.TY_UINTEGER : return types.Builtin( Fbx.TY_INTEGER )
    case Fbx.TY_LONGINT, Fbx.TY_ULONGINT : return types.Builtin( Fbx.TY_LONGINT )
    end select
    return t
end function

'' The result type of a conversion intrinsic, or TYPE_NONE when this is not one.
''
'' These are KEYWORDS in expression position, so no symbol is ever bound and the callee
'' lookup finds nothing: the whole answer is a table, measured in
'' tests/types/expected/fbc-conv.txt. Their acceptance is WIDER than assignment's --
'' 'cbyte( a_string )' is a BYTE to fbc while 'dim as byte b = a_string' is refused --
'' so ConversionCost is not the viability test here and is not used as one.
private function IntrinsicCallType_ _
    ( byref c as Ctx, byval cp as Fbx.ListPayload ptr ) as Fbx.TypeId

    if cp->target = Fbx.NODE_NONE then return Fbx.TYPE_NONE
    if c.ast->Kind( cp->target ) <> Fbx.N_IDENT then return Fbx.TYPE_NONE
    dim as Fbx.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, cp->target )].data )]
    dim as string nm = Fbx.Text.LowerAscii( c.names->Spelling( ip->name ) )

    '' CAST and CPTR name their result outright, as a TYPE argument.
    if ((nm = "cast") orelse (nm = "cptr")) andalso (cp->count = 2) then
        dim as Fbx.NodeId ta = cast( Fbx.NodeId, c.ast->children[cp->first] )
        if c.ast->Kind( ta ) <> Fbx.N_TYPEREF then return Fbx.TYPE_NONE
        dim as Fbx.TypeId rt = c.info->TypeOf_( ta )
        if rt = Fbx.TYPE_NONE then return Fbx.TYPE_NONE
        dim as Fbx.TypeId st = TypeOf_( c, cast( Fbx.NodeId, c.ast->children[cp->first + 1] ) )
        if st = Fbx.TYPE_NONE then return rt
        '' Measured acceptance. CPTR reaches a pointer only FROM one, or from a
        '' pointer-width integer; CAST follows the destination's class -- a pointer
        '' destination takes the same two, a numeric one takes anything but a pointer,
        '' and a STRING destination takes a var-length string and nothing else, not even
        '' a ZSTRING * n.
        dim as boolean srcPtr = (c.types->Kind( st ) = Fbx.TK_POINTER)
        dim as boolean srcPtrInt = false
        if c.types->Kind( st ) = Fbx.TK_BUILTIN then
            srcPtrInt = IsPointerSized_( c.types->BuiltinOf( st ), *c.types )
        end if
        if c.types->Kind( rt ) = Fbx.TK_POINTER then
            if (srcPtr orelse srcPtrInt) = false then return Fbx.TYPE_NONE
            return rt
        end if
        if nm = "cptr" then return Fbx.TYPE_NONE
        if c.types->Kind( rt ) = Fbx.TK_BUILTIN then
            if IsStringy_( c.types->BuiltinOf( rt ) ) then
                if st <> rt then return Fbx.TYPE_NONE
                return rt
            end if
        end if
        if srcPtr then return Fbx.TYPE_NONE
        return rt
    end if

    if cp->count <> 1 then return Fbx.TYPE_NONE
    dim as Fbx.BuiltinType b = Fbx.TY_NONE
    select case nm
    case "cbyte"    : b = Fbx.TY_BYTE
    case "cubyte"   : b = Fbx.TY_UBYTE
    case "cshort"   : b = Fbx.TY_SHORT
    case "cushort"  : b = Fbx.TY_USHORT
    case "clng"     : b = Fbx.TY_LONG
    case "culng"    : b = Fbx.TY_ULONG
    case "cint"     : b = Fbx.TY_INTEGER
    case "cuint"    : b = Fbx.TY_UINTEGER
    case "clngint"  : b = Fbx.TY_LONGINT
    case "culngint" : b = Fbx.TY_ULONGINT
    case "csng"     : b = Fbx.TY_SINGLE
    case "cdbl"     : b = Fbx.TY_DOUBLE
    case "cbool"    : b = Fbx.TY_BOOLEAN
    case "csign", "cunsg"
        return SignedFlip_( TypeOf_( c, cast( Fbx.NodeId, c.ast->children[cp->first] ) ), _
                            (nm = "cunsg"), *c.types )
    end select
    if b = Fbx.TY_NONE then return Fbx.TYPE_NONE

    '' A POINTER argument reaches only the pointer-width conversions. For every other
    '' one -- cbyte, csng, cbool -- fbc refuses a pointer outright.
    dim as Fbx.TypeId at = TypeOf_( c, cast( Fbx.NodeId, c.ast->children[cp->first] ) )
    if at <> Fbx.TYPE_NONE then
        if c.types->Kind( at ) = Fbx.TK_POINTER then
            if IsPointerSized_( b, *c.types ) = false then return Fbx.TYPE_NONE
        end if
    end if
    return c.types->Builtin( b )
end function


function TypeOf_ _
    ( byref c as Ctx, byval id as Fbx.NodeId ) as Fbx.TypeId

    if id = Fbx.NODE_NONE then return Fbx.TYPE_NONE
    dim as Fbx.TypeId known = c.info->TypeOf_( id )
    if known <> Fbx.TYPE_NONE then return known

    dim as Fbx.NodeKind k = c.ast->Kind( id )
    dim as Fbx.TypeId t = Fbx.TYPE_NONE

    select case k
    case Fbx.N_INT_LIT, Fbx.N_FLOAT_LIT, Fbx.N_STRING_LIT, Fbx.N_STRCAT
        t = LiteralType_( c, id )

    case Fbx.N_IDENT
        dim as Fbx.SymbolId sid = c.info->RefOf( id )
        dim as Fbx.Symbol ptr s = c.syms->SymbolAt( sid )
        if s <> 0 then t = s->type_
        '' 'const K = 7' declares no type of its own, so the symbol carries none and
        '' every use of K was untyped -- which made the whole enclosing statement
        '' decline. Its type is its INITIALISER's, measured: K is INTEGER, 'const D =
        '' 2.5' is DOUBLE, and 'const S = "hi"' is ZSTRING * 3.
        ''
        '' Computed on DEMAND rather than when the declaration is walked, because a use
        '' can be typed before the declaration is reached and TypeOf_ memoises: an
        '' early use would cache TYPE_NONE and never look again.
        if (t = Fbx.TYPE_NONE) andalso (s <> 0) then
            if (s->kind = cast( ubyte, Fbx.SYM_CONSTANT )) andalso (s->payload <> 0) then
                dim as Fbx.NodeId item = cast( Fbx.NodeId, s->payload )
                if c.ast->Kind( item ) = Fbx.N_VAR_ITEM then
                    if c.constDepth < CONST_DEPTH_MAX then
                        c.constDepth += 1
                        dim as Fbx.StmtPayload ptr ip = StmtOf( c, item )
                        t = TypeOf_( c, ip->b )
                        c.constDepth -= 1
                        if t <> Fbx.TYPE_NONE then s->type_ = t
                    end if
                end if
            end if
        end if

    case Fbx.N_PAREN
        '' A parenthesised expression is a LIST node, not a statement node: its
        '' single child is in the shared child pool. Reading it through the stmt
        '' pool indexes a different array entirely, which is a segfault, not a
        '' wrong answer.
        dim as Fbx.ListPayload ptr lp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
        if lp->count > 0 then
            t = TypeOf_( c, cast( Fbx.NodeId, c.ast->children[lp->first] ) )
        end if

    case Fbx.N_UNARY
        dim as Fbx.UnaryPayload ptr up = _
            @c.ast->unaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        dim as Fbx.TypeId inner = TypeOf_( c, up->operand )
        dim as Fbx.TokenKind op = cast( Fbx.TokenKind, up->op )
        if inner <> Fbx.TYPE_NONE then
            if op = Fbx.KW_NOT then
                '' NOT keeps BOOLEAN boolean and widens everything else, exactly as
                '' the binary bitwise operators do.
                if c.types->BuiltinOf( inner ) = Fbx.TY_BOOLEAN then
                    t = inner
                else
                    t = BinaryResult( Fbx.KW_AND, inner, inner, *c.types )
                end if
            elseif (op = Fbx.TK_MINUS) orelse (op = Fbx.TK_PLUS) then
                t = BinaryResult( Fbx.TK_PLUS, inner, inner, *c.types )
            else
                t = inner
            end if
        end if

    case Fbx.N_BINARY
        dim as Fbx.BinaryPayload ptr bp = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        dim as Fbx.TypeId lt = TypeOf_( c, bp->lhs )
        dim as Fbx.TypeId rt = TypeOf_( c, bp->rhs )
        dim as Fbx.TokenKind op = cast( Fbx.TokenKind, bp->op )
        t = BinaryResult( op, lt, rt, *c.types )
        if (t = Fbx.TYPE_NONE) andalso (lt <> Fbx.TYPE_NONE) andalso _
           (rt <> Fbx.TYPE_NONE) then
            '' Both operands are known and the combination is still not allowed --
            '' that is a real operand-type error rather than a gap in this pass.
            if (c.types->Kind( lt ) = Fbx.TK_BUILTIN) andalso _
               (c.types->Kind( rt ) = Fbx.TK_BUILTIN) then
                c.st->badOperands += 1
            end if
        end if

    case Fbx.N_MEMBER
        '' 'x.f' needs the BASE's type before the field means anything, which is why
        '' Resolve deliberately left member names alone: it runs before any expression
        '' has a type. With the base typed, the field is an ordinary lookup in the
        '' UDT's own scope.
        dim as Fbx.BinaryPayload ptr mp = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        dim as Fbx.TypeId bt = TypeOf_( c, mp->lhs )
        '' 'p->f' and 'p.f' on a pointer both reach through it.
        if bt <> Fbx.TYPE_NONE then
            if c.types->Kind( bt ) = Fbx.TK_POINTER then bt = c.types->Inner( bt )
        end if
        if (bt <> Fbx.TYPE_NONE) andalso (c.ast->Kind( mp->rhs ) = Fbx.N_IDENT) then
            dim as Fbx.IdentPayload ptr ip = _
                @c.ast->idents[cast( long, c.ast->nodes[cast( long, mp->rhs )].data )]
            dim as Fbx.SymbolId fs = FieldOf_( c, bt, ip->name )
            if fs <> Fbx.SYMBOL_NONE then
                dim as Fbx.Symbol ptr f = c.syms->SymbolAt( fs )
                if f <> 0 then
                    '' Recorded on the MEMBER node so lowering can find the field
                    '' without repeating the lookup.
                    c.info->SetRef( id, fs )
                    c.info->SetRef( mp->rhs, fs )
                    t = f->type_
                end if
            end if
        end if

    case Fbx.N_CALL
        '' The callee's symbol was bound by Resolve; the overloads hang off it in a
        '' chain. Score every candidate against the arguments and take the unique
        '' cheapest -- a tie is an ambiguous call, not a silent pick.
        dim as Fbx.ListPayload ptr cp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
        '' Indexing and calling share a spelling, so the callee's TYPE decides which
        '' this is. An array subscript yields the ELEMENT type; without this the whole
        '' expression is untyped and every use of a(i) falls back to nothing.
        dim as Fbx.TypeId ct = TypeOf_( c, cp->target )
        if (ct <> Fbx.TYPE_NONE) andalso (c.types->Kind( ct ) = Fbx.TK_ARRAY) then
            t = c.types->Inner( ct )
        else
            '' A conversion intrinsic is a KEYWORD, so nothing was ever bound and the
            '' callee lookup below finds nothing. Its result is a measured table.
            t = IntrinsicCallType_( c, cp )
            if t = Fbx.TYPE_NONE then
                dim as Fbx.SymbolId callee = c.info->RefOf( cp->target )
                if callee <> Fbx.SYMBOL_NONE then
                    t = ResolveCall_( c, id, callee, cp )
                end if
            end if
        end if

    case Fbx.N_DEREF
        '' Built by MakeUnary, so the payload is a UNARY, not a statement.
        dim as Fbx.UnaryPayload ptr dp = _
            @c.ast->unaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        dim as Fbx.TypeId inner = TypeOf_( c, dp->operand )
        if inner <> Fbx.TYPE_NONE then
            if c.types->Kind( inner ) = Fbx.TK_POINTER then t = c.types->Inner( inner )
        end if

    case Fbx.N_ADDROF
        dim as Fbx.UnaryPayload ptr ap = _
            @c.ast->unaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        dim as Fbx.TypeId inner = TypeOf_( c, ap->operand )
        if inner <> Fbx.TYPE_NONE then t = c.types->Pointer_( inner )
    end select

    if t <> Fbx.TYPE_NONE then
        c.info->SetType( id, t )
        c.st->typed += 1
    else
        c.st->untyped += 1
    end if
    return t
end function

'' ---------------------------------------------------------------- the walk

private sub WalkAll( byref c as Ctx )
    '' Every expression node in the arena, in id order. Expressions are created
    '' bottom-up by the parser, so a child always has a LOWER id than its parent and
    '' one linear pass types the whole tree without recursion into statements.
    for i as long = 1 to c.ast->Count( )
        dim as Fbx.NodeId n = cast( Fbx.NodeId, i )
        select case c.ast->Kind( n )
        case Fbx.N_INT_LIT, Fbx.N_FLOAT_LIT, Fbx.N_STRING_LIT, Fbx.N_STRCAT, _
             Fbx.N_IDENT, Fbx.N_PAREN, Fbx.N_UNARY, Fbx.N_BINARY, _
             Fbx.N_DEREF, Fbx.N_ADDROF, Fbx.N_CALL, Fbx.N_MEMBER
            TypeOf_( c, n )
        end select
    next
end sub

function Run _
    ( byref ast as Fbx.AstArena, byval root as Fbx.NodeId, _
      byref syms as Fbx.SymbolTable, byref types as Fbx.TypeContext, _
      byref names as Fbx.Interner, byref diags as Fbx.DiagnosticEngine, _
      byref info as Fbx.SemanticInfo, byref st as Stats ) as long

    dim as Ctx c
    c.ast = @ast
    c.syms = @syms
    c.types = @types
    c.names = @names
    c.diags = @diags
    c.info = @info
    c.st = @st
    WalkAll( c )
    return st.badOperands
end function

'' ------------------------------------------------------------------------ dump

function Dump _
    ( byref ast as Fbx.AstArena, byref src as Fbx.SourceManager, _
      byref types as Fbx.TypeContext, byref names as Fbx.Interner, _
      byref info as Fbx.SemanticInfo, byref st as Stats ) as string

    dim as string outp = ""
    for i as long = 1 to ast.Count( )
        dim as Fbx.NodeId n = cast( Fbx.NodeId, i )

        '' An assignment reports its LEGALITY rather than a type, so
        '' tools/gen/check-assign.py can put the verdict beside fbc's.
        if ast.Kind( n ) = Fbx.N_AMBIGUOUS then
            if info.AmbiguousOf( n ) = Fbx.AMB_ASSIGN then
                '' N_AMBIGUOUS is a STATEMENT payload -- 'a' is the target and 'b'
                '' the value -- not a binary. Reading it as a binary indexes a
                '' different arena, which is the exact mistake phase-5-check.md warns
                '' about, made again while writing this.
                dim as Fbx.StmtPayload ptr ap = _
                    @ast.stmts[cast( long, ast.nodes[cast( long, n )].data )]
                dim as Fbx.TypeId dt = info.TypeOf_( ap->a )
                dim as Fbx.TypeId st2 = info.TypeOf_( ap->b )
                dim as string verdict = "assign:unknown"
                if (dt <> Fbx.TYPE_NONE) andalso (st2 <> Fbx.TYPE_NONE) then
                    select case AssignableTo( st2, dt, types )
                    case ASSIGN_OK     : verdict = "assign:ok"
                    case ASSIGN_WARN   : verdict = "assign:warn"
                    case else          : verdict = "assign:reject"
                    end select
                end if
                outp += str( src.Decode( ast.Loc( n ) ).lineNo ) & " " & _
                        verdict & chr( 10 )
            end if
            continue for
        end if

        if ast.Kind( n ) <> Fbx.N_INTRINSIC then continue for
        dim as Fbx.StmtPayload ptr sp = _
            @ast.stmts[cast( long, ast.nodes[cast( long, n )].data )]
        if sp->count <= 0 then continue for
        dim as Fbx.NodeId arg = cast( Fbx.NodeId, ast.children[sp->first] )
        if arg = Fbx.NODE_NONE then continue for
        dim as Fbx.TypeId t = info.TypeOf_( arg )
        dim as string nm = "?"
        if t <> Fbx.TYPE_NONE then nm = types.Name( t )
        outp += str( src.Decode( ast.Loc( n ) ).lineNo ) & " " & nm & chr( 10 )
        '' Constants get their own line with a NON-numeric prefix, so the promotion
        '' and overload gates -- which key on 'line type' -- cannot collide with it.
        dim as ConstVal cv = ConstOf( ast, arg, src, names, types.target.pointerBits )
        if cv.known then
            outp += "const " & str( src.Decode( ast.Loc( n ) ).lineNo ) & " " & _
                    str( cv.value ) & chr( 10 )
        end if
    next
    outp += "checked: " & st.typed & " typed, " & st.untyped & " untyped, " & _
            st.badOperands & " bad operand pairs, " & st.callsResolved & _
            " calls resolved, " & st.callsAmbiguous & " ambiguous" & chr( 10 )
    return outp
end function

end namespace
