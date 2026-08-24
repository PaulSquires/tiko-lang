'' check.bas -- expression typing. See check.bi for the measured promotion rules and
'' for why each of them is not what a C programmer would guess.

#include once "symbols/check.bi"


namespace Tko.Check

type Ctx
    as Tko.AstArena ptr         ast
    as Tko.SymbolTable ptr      syms
    as Tko.TypeContext ptr      types
    as Tko.Interner ptr         names
    as Tko.DiagnosticEngine ptr diags
    as Tko.SemanticInfo ptr     info
    as Stats ptr                st
    '' How deep the CONST-initialiser chain is. 'const A = B' takes its type from B,
    '' so a circular pair would recurse until the stack ran out; a compiler must not
    '' fall over on input fbc merely rejects.
    as long                     constDepth
end type

const CONST_DEPTH_MAX as long = 64

'' ------------------------------------------------------------------- classes

declare function ExprIntrinsicType_ _
    ( byref c as Ctx, byref nm as string, byval cp as Tko.ListPayload ptr ) as Tko.TypeId
declare sub NoteUntypedName_( byref c as Ctx, byval id as Tko.NodeId )
declare function UntypedLeaf_ _
    ( byref c as Ctx, byval id as Tko.NodeId ) as Tko.NodeId
declare function IsUnsignedInt_( byval b as Tko.BuiltinType ) as boolean
declare function IsPointerSized_ _
    ( byval b as Tko.BuiltinType, byref types as Tko.TypeContext ) as boolean
declare function PointerCost_ _
    ( byval from_ as Tko.TypeId, byval to_ as Tko.TypeId, _
      byval srcP as boolean, byval dstP as boolean, _
      byref types as Tko.TypeContext, byval overloaded as boolean ) as long

private function IsFloat_( byval b as Tko.BuiltinType ) as boolean
    return (b = Tko.TY_SINGLE) orelse (b = Tko.TY_DOUBLE)
end function

private function IsInt_( byval b as Tko.BuiltinType ) as boolean
    select case b
    case Tko.TY_BYTE, Tko.TY_UBYTE, Tko.TY_SHORT, Tko.TY_USHORT, _
         Tko.TY_LONG, Tko.TY_ULONG, Tko.TY_INTEGER, Tko.TY_UINTEGER, _
         Tko.TY_LONGINT, Tko.TY_ULONGINT
        return true
    end select
    return false
end function

'' The 64-bit UNSIGNED types, and only those, make an integer result UINTEGER.
'' 'ulong + ulong' is INTEGER: signed 64 holds every unsigned 32 value, so nothing
'' forces the result unsigned.
private function IsUnsigned64_( byval b as Tko.BuiltinType ) as boolean
    return (b = Tko.TY_UINTEGER) orelse (b = Tko.TY_ULONGINT)
end function

private function IsStringy_( byval b as Tko.BuiltinType ) as boolean
    select case b
    case Tko.TY_STRING, Tko.TY_ZSTRING, Tko.TY_WSTRING, Tko.TY_USTRING
        return true
    end select
    return false
end function

'' 'zstring * N' IS AN ARRAY of TY_ZSTRING rather than a builtin of its own, and so are
'' 'wstring * N', 'string * N' (TY_FIXSTR) and 'ustring * N' (TY_FIXUSTR). Every one of
'' them fell out at BinaryResult's builtin-only guard, so 'z + z' and 'w + w' had no
'' type at all and every use of one declined -- 36 corpus declines were a single macro
'' putting a fixed-string concatenation in a SELECT CASE subject.
private function StrFlavourOf_ _
    ( byref types as Tko.TypeContext, byval t as Tko.TypeId ) as Tko.TypeId
    dim as Tko.TypeId el = FixedStringElem( t, types )
    if el = Tko.TYPE_NONE then return t
    select case types.BuiltinOf( el )
    case Tko.TY_FIXSTR  : return types.Builtin( Tko.TY_STRING )
    case Tko.TY_FIXUSTR : return types.Builtin( Tko.TY_USTRING )
    end select
    return el
end function

'' THE RESULT OF A CONCATENATION IS WIDE WHEN EITHER OPERAND IS. Measured with fbc:
'' 'z + z', 'f + f' and 'z & z' are STRING, while 'w + w', 'w & w', '*pw + *pw' and
'' even 'w & 5' are WSTRING. The narrow answer was returned for all of them, which put
'' a wide value through the narrow runtime.
''
'' Mixing the two WIDE flavours -- a wstring with a ustring -- is not measured against
'' anything, so it has no answer here rather than a guessed one.
private function ConcatResult_ _
    ( byref types as Tko.TypeContext, byval lb as Tko.BuiltinType, _
      byval rb as Tko.BuiltinType ) as Tko.TypeId
    dim as boolean lw = (lb = Tko.TY_WSTRING)
    dim as boolean rw = (rb = Tko.TY_WSTRING)
    dim as boolean lu = (lb = Tko.TY_USTRING)
    dim as boolean ru = (rb = Tko.TY_USTRING)
    if (lu orelse ru) andalso (lw orelse rw) then return Tko.TYPE_NONE
    if lu orelse ru then return types.Builtin( Tko.TY_USTRING )
    if lw orelse rw then return types.Builtin( Tko.TY_WSTRING )
    return types.Builtin( Tko.TY_STRING )
end function

'' ------------------------------------------------------------ operator classes

private function IsComparison_( byval op as Tko.TokenKind ) as boolean
    select case op
    case Tko.TK_EQ, Tko.TK_NE, Tko.TK_LT, Tko.TK_GT, Tko.TK_LE, Tko.TK_GE
        return true
    end select
    return false
end function

'' AND, OR, XOR, EQV, IMP: bitwise on integers, logical on booleans.
private function IsBitwise_( byval op as Tko.TokenKind ) as boolean
    select case op
    case Tko.KW_AND, Tko.KW_OR, Tko.KW_XOR, Tko.KW_EQV, Tko.KW_IMP
        return true
    end select
    return false
end function

'' ANDALSO and ORELSE are NOT the bitwise operators with short-circuiting bolted on.
'' They are BOOLEAN when both sides are and INTEGER in every other case -- never
'' UINTEGER, even for 'uinteger andalso uinteger', where AND would give UINTEGER.
'' They also reject nothing except a string operand.
private function IsShortCircuit_( byval op as Tko.TokenKind ) as boolean
    return (op = Tko.KW_ANDALSO) orelse (op = Tko.KW_ORELSE)
end function

'' The operators whose result is an INTEGER even when handed floats: '\', MOD, SHL,
'' SHR. They convert first and are not the same operator as '/'.
private function IsIntegerOp_( byval op as Tko.TokenKind ) as boolean
    select case op
    case Tko.TK_BACKSLASH, Tko.KW_MOD, Tko.KW_SHL, Tko.KW_SHR
        return true
    end select
    return false
end function

private function IsArith_( byval op as Tko.TokenKind ) as boolean
    select case op
    case Tko.TK_PLUS, Tko.TK_MINUS, Tko.TK_STAR
        return true
    end select
    return false
end function

'' ------------------------------------------------------------------ promotion

'' The integer result of a numeric pair: UINTEGER when either side is 64-bit
'' unsigned, INTEGER otherwise. Nothing narrower is ever produced.
'' Integer arithmetic promotes to at least INTEGER and then takes the WIDEST operand,
'' with the result unsigned only when an operand OF THAT WIDTH is unsigned.
''
'' On win64 that collapses to "INTEGER, or UINTEGER if either side is an 8-byte
'' unsigned", because INTEGER is already the widest integer there -- which is why the
'' rule read that way for as long as win64 was the only target. On win32 INTEGER is four
'' bytes and the difference shows in 726 of the gate's 3,596 rows: 'byte + longint' is
'' LONGINT there and INTEGER here.
'' The width an operand contributes. A FLOAT contributes nothing: '\' and 'mod' convert
'' it to the default integer type rather than to one its size suggests, so
'' 'byte \ double' is INTEGER and not LONGINT -- measured, and the difference only
'' shows on win32 where those two are not the same type.
private function IntWidth_ _
    ( byval b as Tko.BuiltinType, byref types as Tko.TypeContext ) as long
    if IsInt_( b ) = false then return 0
    return types.Layout( types.Builtin( b ) ).size
end function

private function IntResult_ _
    ( byval lb as Tko.BuiltinType, byval rb as Tko.BuiltinType, _
      byref types as Tko.TypeContext ) as Tko.TypeId

    dim as long iw = IntWidth_( Tko.TY_INTEGER, types )
    dim as long lw = IntWidth_( lb, types )
    dim as long rw = IntWidth_( rb, types )
    dim as long w = iw
    if lw > w then w = lw
    if rw > w then w = rw

    dim as boolean uns = false
    if (lw = w) andalso IsUnsignedInt_( lb ) then uns = true
    if (rw = w) andalso IsUnsignedInt_( rb ) then uns = true

    if w = iw then
        return types.Builtin( iif( uns, Tko.TY_UINTEGER, Tko.TY_INTEGER ) )
    end if
    return types.Builtin( iif( uns, Tko.TY_ULONGINT, Tko.TY_LONGINT ) )
end function

function BinaryResult _
    ( byval op as Tko.TokenKind, byval lhs as Tko.TypeId, byval rhs as Tko.TypeId, _
      byref types as Tko.TypeContext ) as Tko.TypeId

    if (lhs = Tko.TYPE_NONE) orelse (rhs = Tko.TYPE_NONE) then return Tko.TYPE_NONE

    '' '&' is FreeBASIC's concatenation operator and is ALWAYS a string, whatever it
    '' is handed -- 'long & long' is STRING. It converts rather than rejecting, so it
    '' is decided before any of the numeric rules and before the builtin-only guard:
    '' concatenating a UDT with a CAST operator is still a string.
    '' '&' STAYS NARROW HERE whatever it is handed, and that is not the same answer
    '' fbc's own 'typeof( w & w )' gives -- WSTRING. Its LOWERING decides the width
    '' per term instead, measured shape by shape in tests/mir/concat-mixed: only a
    '' genuinely wide term is wide, a literal and a number are not, and a narrow prefix
    '' folds before the chain goes wide. Handing it a wide RESULT type instead made
    '' 'r = s & w' assign narrowly and drop the wide term altogether.
    if op = Tko.TK_AMP then return types.Builtin( Tko.TY_STRING )
    '' AN ENUM DECAYS TO ITS UNDERLYING INTEGER for arithmetic. Measured:
    '' 'typeof( e + 69 )' is INTEGER. Without this an enum operand fell out at the
    '' builtin-only guard below, so 'var res = a_thing + 69' inferred nothing and got
    '' a VOID slot -- and the enum itself typed fine, which is what made it puzzling.
    dim as Tko.TypeId lhs2 = StrFlavourOf_( types, lhs )
    dim as Tko.TypeId rhs2 = StrFlavourOf_( types, rhs )
    if types.Kind( lhs2 ) = Tko.TK_ENUM then lhs2 = types.Builtin( Tko.TY_INTEGER )
    if types.Kind( rhs2 ) = Tko.TK_ENUM then rhs2 = types.Builtin( Tko.TY_INTEGER )

    '' Only builtin operands are decided here. A UDT operand means an overloaded
    '' operator, which is overload resolution's business, not this table's.
    if types.Kind( lhs2 ) <> Tko.TK_BUILTIN then return Tko.TYPE_NONE
    if types.Kind( rhs2 ) <> Tko.TK_BUILTIN then return Tko.TYPE_NONE

    dim as Tko.BuiltinType lb = types.BuiltinOf( lhs2 )
    dim as Tko.BuiltinType rb = types.BuiltinOf( rhs2 )
    dim as boolean lStr = IsStringy_( lb )
    dim as boolean rStr = IsStringy_( rb )
    dim as boolean lNum = IsInt_( lb ) orelse IsFloat_( lb )
    dim as boolean rNum = IsInt_( rb ) orelse IsFloat_( rb )
    dim as boolean lBool = (lb = Tko.TY_BOOLEAN)
    dim as boolean rBool = (rb = Tko.TY_BOOLEAN)

    '' Strings concatenate with '+' and compare with anything; every other operator
    '' rejects them, and mixing a string with a number rejects too.
    if lStr orelse rStr then
        if (lStr = false) orelse (rStr = false) then return Tko.TYPE_NONE
        if IsComparison_( op ) then return types.Builtin( Tko.TY_INTEGER )
        if op = Tko.TK_PLUS then return ConcatResult_( types, lb, rb )
        return Tko.TYPE_NONE
    end if

    '' Equality and ordering differ on BOOLEAN, which is the sort of distinction only
    '' a measurement finds: '=' and '<>' accept a boolean against anything -- BOOLEAN
    '' when both sides are, INTEGER otherwise -- while '<', '>', '<=' and '>=' reject
    '' BOOLEAN outright, including 'boolean < boolean'.
    if IsComparison_( op ) then
        if (op = Tko.TK_EQ) orelse (op = Tko.TK_NE) then
            if lBool andalso rBool then return types.Builtin( Tko.TY_BOOLEAN )
            return types.Builtin( Tko.TY_INTEGER )
        end if
        if lBool orelse rBool then return Tko.TYPE_NONE
        return types.Builtin( Tko.TY_INTEGER )
    end if

    if IsShortCircuit_( op ) then
        if lBool andalso rBool then return types.Builtin( Tko.TY_BOOLEAN )
        if (lBool orelse lNum) andalso (rBool orelse rNum) then
            return types.Builtin( Tko.TY_INTEGER )
        end if
        return Tko.TYPE_NONE
    end if

    if IsBitwise_( op ) then
        if lBool andalso rBool then return types.Builtin( Tko.TY_BOOLEAN )
        if (lBool orelse lNum) andalso (rBool orelse rNum) then
            return IntResult_( lb, rb, types )
        end if
        return Tko.TYPE_NONE
    end if

    '' Arithmetic rejects BOOLEAN outright: 'boolean + boolean' is an error, unlike
    '' 'boolean and long', which is not.
    if lBool orelse rBool then return Tko.TYPE_NONE
    if (lNum = false) orelse (rNum = false) then return Tko.TYPE_NONE

    if IsIntegerOp_( op ) then return IntResult_( lb, rb, types )
    if op = Tko.TK_CARET then return types.Builtin( Tko.TY_DOUBLE )

    '' '/' is always floating point, and SINGLE only when BOTH sides are single --
    '' unlike '+', where a single against an integer stays single. 'long / single'
    '' is DOUBLE.
    if op = Tko.TK_SLASH then
        if (lb = Tko.TY_SINGLE) andalso (rb = Tko.TY_SINGLE) then
            return types.Builtin( Tko.TY_SINGLE )
        end if
        return types.Builtin( Tko.TY_DOUBLE )
    end if

    if IsArith_( op ) = false then return Tko.TYPE_NONE

    if (lb = Tko.TY_DOUBLE) orelse (rb = Tko.TY_DOUBLE) then
        return types.Builtin( Tko.TY_DOUBLE )
    end if
    if (lb = Tko.TY_SINGLE) orelse (rb = Tko.TY_SINGLE) then
        return types.Builtin( Tko.TY_SINGLE )
    end if
    return IntResult_( lb, rb, types )
end function


'' ----------------------------------------------------------- overload resolution

'' fbc's own preference order among the builtin types, which is NOT size order:
'' INTEGER sits before LONGINT even though both are 64-bit, and an argument of type
'' LONG offered 'integer' and 'longint' picks INTEGER. Rank is used only to break
'' ties within a conversion class, and to tell widening from narrowing.
private function Rank_( byval b as Tko.BuiltinType ) as long
    select case b
    case Tko.TY_BYTE     : return 1
    case Tko.TY_UBYTE    : return 2
    case Tko.TY_SHORT    : return 3
    case Tko.TY_USHORT   : return 4
    case Tko.TY_LONG     : return 5
    case Tko.TY_ULONG    : return 6
    case Tko.TY_INTEGER  : return 7
    case Tko.TY_UINTEGER : return 8
    case Tko.TY_LONGINT  : return 9
    case Tko.TY_ULONGINT : return 10
    case Tko.TY_SINGLE   : return 11
    case Tko.TY_DOUBLE   : return 12
    end select
    return 0
end function

private function IsUnsignedInt_( byval b as Tko.BuiltinType ) as boolean
    select case b
    case Tko.TY_UBYTE, Tko.TY_USHORT, Tko.TY_ULONG, Tko.TY_UINTEGER, Tko.TY_ULONGINT
        return true
    end select
    return false
end function

'' The pointer half of conversion costing, in its own file at the 1500-line cap.
#include once "symbols/convcost.bas"

'' 'zstring * 8' as the string type it IS, or TYPE_NONE.
''
'' A fixed-length string is modelled as an ARRAY of the string element, which is what
'' it is and which makes its layout fall out of the array rule. Nothing else is: fbc
'' REFUSES a bare 'zstring' array -- "Expected pointer" -- so an array whose element is
'' the zstring or wstring builtin can only be a fixed-length string, never an array of
'' them. 'zstring * 4 z(0 to 7)' nests, and it is the INNER array that is the string.
function FixedStringElem _
    ( byval t as Tko.TypeId, byref types as Tko.TypeContext ) as Tko.TypeId

    if t = Tko.TYPE_NONE then return Tko.TYPE_NONE
    if types.Kind( t ) <> Tko.TK_ARRAY then return Tko.TYPE_NONE
    dim as Tko.TypeId e = types.Inner( t )
    if types.Kind( e ) <> Tko.TK_BUILTIN then return Tko.TYPE_NONE
    select case types.BuiltinOf( e )
    case Tko.TY_ZSTRING, Tko.TY_WSTRING, Tko.TY_USTRING, Tko.TY_FIXSTR
        return e
    end select
    return Tko.TYPE_NONE
end function

function ConversionCost _
    ( byval from_ as Tko.TypeId, byval to_ as Tko.TypeId, _
      byref types as Tko.TypeContext, _
      byval overloaded as boolean = false ) as long

    if (from_ = Tko.TYPE_NONE) orelse (to_ = Tko.TYPE_NONE) then return CONV_NONE
    if from_ = to_ then return CONV_EXACT

    '' A fixed-length string converts as the string type it is. Its LENGTH plays no
    '' part, and cannot: fbc refuses 'byval x as zstring * 4' outright -- error 59,
    '' "Illegal specification" -- so no parameter ever has one of these types and no
    '' length-to-length question arises.
    dim as Tko.TypeId fsrc = FixedStringElem( from_, types )
    if fsrc <> Tko.TYPE_NONE then from_ = fsrc
    dim as Tko.TypeId fdst = FixedStringElem( to_, types )
    if fdst <> Tko.TYPE_NONE then to_ = fdst
    if from_ = to_ then return CONV_EXACT

    '' POINTERS, before the builtin-only tiers below. Everything here is measured in
    '' tests/types/expected/fbc-ptr.txt; the shape a cost model would guess -- pointee
    '' compatibility, a distance between pointee types -- is not the shape fbc has.
    dim as boolean srcP = (types.Kind( from_ ) = Tko.TK_POINTER)
    dim as boolean dstP = (types.Kind( to_ ) = Tko.TK_POINTER)
    if srcP orelse dstP then
        return PointerCost_( from_, to_, srcP, dstP, types, overloaded )
    end if

    '' AN ENUM CONVERTS AS ITS UNDERLYING INTEGER, which is what the binary-operator
    '' path two hundred lines above already assumes. Without it every enum argument
    '' scored CONV_NONE against every numeric parameter, so a call like
    '' 'TuiAnsi( TUIC_BLACK )' matched NO overload -- and the effect was not a
    '' diagnostic but an UNTYPED CALL: the callee still bound, so the call was emitted
    '' with a VOID result and whatever consumed it declined. 'return TuiAnsi( ... )'
    '' out of a UDT-returning function is how the tui headers write nearly everything.
    if types.Kind( from_ ) = Tko.TK_ENUM then from_ = types.Builtin( Tko.TY_INTEGER )
    if types.Kind( to_ ) = Tko.TK_ENUM then to_ = types.Builtin( Tko.TY_INTEGER )
    if from_ = to_ then return CONV_EXACT

    if types.Kind( from_ ) <> Tko.TK_BUILTIN then return CONV_NONE
    if types.Kind( to_ ) <> Tko.TK_BUILTIN then return CONV_NONE

    '' Named srcB / dstB, not fb / tb: 'fb' is the FB namespace, and FreeBASIC is
    '' case-insensitive, so a local called fb shadows it.
    dim as Tko.BuiltinType srcB = types.BuiltinOf( from_ )
    dim as Tko.BuiltinType dstB = types.BuiltinOf( to_ )
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
    if (srcB = Tko.TY_BOOLEAN) orelse (dstB = Tko.TY_BOOLEAN) then
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
        '' The same pointer-sized preference as the integer path below, but bounded by
        '' the SIGNEDNESS step of 8 rather than by the width step of 16 -- and that bound
        '' is load-bearing. A boolean offered 'uinteger' and 'longint' takes longint on
        '' win64, the one row in the whole table where a higher rank wins, and it wins
        '' only because uinteger pays the unsigned penalty. A bonus of 8 here erased that
        '' and broke the win64 gate; 3 clears the rank gap of 2 and nothing else.
        if (dstB = Tko.TY_INTEGER) orelse (dstB = Tko.TY_UINTEGER) then
            return b + dr - 3
        end if
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

    '' The LAST tiebreak, and it only ever fires when two candidates are otherwise
    '' identical: prefer INTEGER / UINTEGER, the pointer-sized pair. On win64 nothing
    '' reaches this -- 'long' and 'integer' are four and eight bytes, so the width tier
    '' has already decided. On win32 they are the same width, the same signedness and one
    '' rank apart, and fbc takes integer: 14 rows of the overload gate say so.
    ''
    '' EIGHT is fitted, not derived, and the bound it sits inside is: bigger than the two
    '' rank tiers it has to beat -- rank DISTANCE contributes 4 here and rank itself 2 --
    '' and smaller than the family tier at 16, so it can never override family or
    '' signedness. Read it as "the type an operand would promote to wins a tie", which is
    '' what INTEGER is.
    if (dstB = Tko.TY_INTEGER) orelse (dstB = Tko.TY_UINTEGER) then
        return cost + dr - 8
    end if
    return cost + dr
end function

'' ------------------------------------------------------------------ assignment

'' A pointer converts to and from an integer of POINTER WIDTH, with a warning, and to
'' nothing narrower. Written against the target layout rather than against 64, so it
'' stays right on a target where a pointer is not 8 bytes.
private function IsPointerSized_ _
    ( byval b as Tko.BuiltinType, byref types as Tko.TypeContext ) as boolean

    if IsInt_( b ) = false then return false
    return types.Layout( types.Builtin( b ) ).size = (types.target.pointerBits \ 8)
end function

function AssignableTo _
    ( byval src as Tko.TypeId, byval dst as Tko.TypeId, _
      byref types as Tko.TypeContext ) as AssignKind

    if (src = Tko.TYPE_NONE) orelse (dst = Tko.TYPE_NONE) then return ASSIGN_OK
    if src = dst then return ASSIGN_OK

    dim as boolean srcPtr = (types.Kind( src ) = Tko.TK_POINTER)
    dim as boolean dstPtr = (types.Kind( dst ) = Tko.TK_POINTER)

    '' Pointer to pointer: silent when the pointees agree, or when either side is
    '' ANY PTR, which is the universal one. Between two DIFFERENT concrete pointees
    '' fbc allows it but warns -- 'long ptr = zstring ptr' is accepted with a
    '' complaint, and treating that as clean would hide a real behaviour difference.
    if srcPtr andalso dstPtr then
        dim as Tko.TypeId sp2 = types.Inner( src )
        dim as Tko.TypeId dp2 = types.Inner( dst )
        if sp2 = dp2 then return ASSIGN_OK
        if (types.Kind( sp2 ) = Tko.TK_BUILTIN) andalso _
           (types.BuiltinOf( sp2 ) = Tko.TY_ANY) then return ASSIGN_OK
        if (types.Kind( dp2 ) = Tko.TK_BUILTIN) andalso _
           (types.BuiltinOf( dp2 ) = Tko.TY_ANY) then return ASSIGN_OK
        return ASSIGN_WARN
    end if

    if srcPtr orelse dstPtr then
        dim as Tko.TypeId other = iif( srcPtr, dst, src )
        if types.Kind( other ) <> Tko.TK_BUILTIN then return ASSIGN_REJECT
        if IsPointerSized_( types.BuiltinOf( other ), types ) then return ASSIGN_WARN
        return ASSIGN_REJECT
    end if

    if (types.Kind( src ) <> Tko.TK_BUILTIN) orelse _
       (types.Kind( dst ) <> Tko.TK_BUILTIN) then
        return ASSIGN_OK        '' UDTs need overloaded LET; not decided here
    end if

    dim as Tko.BuiltinType sb = types.BuiltinOf( src )
    dim as Tko.BuiltinType db = types.BuiltinOf( dst )

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
    ( byref c as Ctx, byval t as Tko.TypeId, byval nm as Tko.InternId ) as Tko.SymbolId

    if (t = Tko.TYPE_NONE) orelse (nm = 0) then return Tko.SYMBOL_NONE
    '' CONST IS TRANSPARENT TO A FIELD LOOKUP. 'byref x as const T' gives x a QUALIFIED
    '' type, which failed the kind test outright -- so 'x.n' over a const reference was
    '' untyped and every read through one declined, while the same line without the
    '' const worked. That is the signature of every copy constructor in the corpus.
    t = c.types->Unqualify( t )
    select case c.types->Kind( t )
    case Tko.TK_UDT, Tko.TK_FORWARD
    case else
        return Tko.SYMBOL_NONE
    end select
    dim as Tko.InternId tn = c.types->NameOf( t )
    if tn = 0 then return Tko.SYMBOL_NONE
    dim as Tko.ScopeId ds = cast( Tko.ScopeId, c.types->DeclScopeOf( t ) )
    '' The UDT whose scope holds the field, so the TYPE-name class.
    dim as Tko.SymbolId ts = c.syms->LookupLocalTyped( ds, tn, true )
    if ts = Tko.SYMBOL_NONE then ts = c.syms->LookupTyped( ds, tn, true )
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( ts )
    if s = 0 then return Tko.SYMBOL_NONE
    if s->inner = Tko.SCOPE_NONE then return Tko.SYMBOL_NONE
    dim as Tko.SymbolId found = c.syms->LookupLocal( s->inner, nm )
    if found <> Tko.SYMBOL_NONE then return found

    '' AN INHERITED MEMBER. 'extends T' is a field named 'base' at offset 0 -- see the
    '' parser -- so a name this type does not hold is looked for in that field's type,
    '' and so on up the chain. Single inheritance, so there is one chain and no
    '' ambiguity to resolve.
    ''
    '' 'base' itself is not looked through, or a type would find its own base field by
    '' searching for it, which terminates but says the wrong thing.
    dim as Tko.InternId baseNm = c.names->GetString( "base" )
    if nm <> baseNm then
        dim as Tko.SymbolId bf = c.syms->LookupLocal( s->inner, baseNm )
        if bf <> Tko.SYMBOL_NONE then
            dim as Tko.Symbol ptr b = c.syms->SymbolAt( bf )
            if (b <> 0) andalso (b->type_ <> Tko.TYPE_NONE) andalso (b->type_ <> t) then
                dim as Tko.SymbolId up = FieldOf_( c, b->type_, nm )
                if up <> Tko.SYMBOL_NONE then return up
            end if
        end if
    end if

    '' AN INSTANTIATION FALLS BACK TO ITS GENERIC for anything its own scope does not
    '' hold. Instantiating a generic gives each argument list its own type with its own
    '' FIELDS -- which is the whole point, and what makes 'a.value' work at all -- but
    '' the MEMBERS are not instantiated yet: a member body needs its own AST nodes per
    '' instantiation, because SemanticInfo is keyed by NodeId and two instantiations
    '' sharing a body would fight over the same node's type.
    ''
    '' Without this fallback, giving instantiations real types made 'a.Push( v )' stop
    '' binding where it used to bind -- 72 calls in one corpus file. It bound to the
    '' GENERIC's single member before and it binds to the same one now: no more wrong
    '' than it was, and the fields are right where they were not. Stated plainly
    '' because it IS wrong for two instantiations at different types, and the fix is
    '' instantiating the bodies, not widening this.
    dim as Tko.NodeId gnode = cast( Tko.NodeId, s->payload )
    if gnode = Tko.NODE_NONE then return Tko.SYMBOL_NONE
    if c.ast->Kind( gnode ) <> Tko.N_TYPE then return Tko.SYMBOL_NONE
    dim as Tko.StmtPayload ptr gp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, gnode )].data )]
    if gp->b = Tko.NODE_NONE then return Tko.SYMBOL_NONE      '' not a generic
    if gp->name = 0 then return Tko.SYMBOL_NONE
    if gp->name = tn then return Tko.SYMBOL_NONE              '' it IS the generic
    '' By the SYMBOL recorded on the node, not by name: the instantiation lives in the
    '' GLOBAL scope while its generic sits in a module or namespace scope below it, so
    '' a name lookup from here walks the wrong way and finds nothing.
    dim as Tko.Symbol ptr gsym = c.syms->SymbolAt( c.info->RefOf( gnode ) )
    if gsym = 0 then return Tko.SYMBOL_NONE
    if gsym->inner = Tko.SCOPE_NONE then return Tko.SYMBOL_NONE
    return c.syms->LookupLocal( gsym->inner, nm )
end function

private function StmtOf _
    ( byref c as Ctx, byval id as Tko.NodeId ) as Tko.StmtPayload ptr
    return @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
end function

'' A var-length STRING or USTRING -- the two builtins that carry a descriptor. Not the
'' fixed flavours, which are arrays and are handled beside them.
private function IsVarLenStrBuiltin_ _
    ( byref c as Ctx, byval t as Tko.TypeId ) as boolean

    if t = Tko.TYPE_NONE then return false
    dim as Tko.TypeId u = c.types->Unqualify( t )
    if c.types->Kind( u ) <> Tko.TK_BUILTIN then return false
    dim as Tko.BuiltinType b = c.types->BuiltinOf( u )
    return (b = Tko.TY_STRING) orelse (b = Tko.TY_USTRING)
end function

declare function TypeOf_ _
    ( byref c as Ctx, byval id as Tko.NodeId ) as Tko.TypeId

'' An integer literal is the narrowest of INTEGER / LONGINT that holds it, matching
'' fbc: small literals are INTEGER, which is pointer-sized, not LONG.
private function LiteralType_ _
    ( byref c as Ctx, byval id as Tko.NodeId ) as Tko.TypeId

    select case c.ast->Kind( id )
    case Tko.N_INT_LIT
        return c.types->Builtin( Tko.TY_INTEGER )
    case Tko.N_FLOAT_LIT
        return c.types->Builtin( Tko.TY_DOUBLE )
    case Tko.N_STRING_LIT, Tko.N_STRCAT
        return c.types->Builtin( Tko.TY_STRING )
    end select
    return Tko.TYPE_NONE
end function






'' OVERLOAD RESOLUTION lives in its own file: choosing between candidates is one
'' subject and a long one, and check.bas reached the 1500-line cap. Included HERE for
'' the same reason the intrinsic tables are -- it reads Ctx and calls TypeOf_, both of
'' which have to exist first. Nothing in it changed in the move.
#include once "symbols/overload.bas"

'' The intrinsic tables live in their own file: one subject, and a long one. It is
'' included HERE rather than at the top because it reads Ctx and calls TypeOf_, both
'' of which have to exist first.
'' Defined below and used by the intrinsic tables included here: a UDT member by name,
'' folded, procedures included.
declare function UdtMemberSym_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byref nm as string ) as Tko.SymbolId

#include once "symbols/intrinsics.bas"

function TypeOf_ _
    ( byref c as Ctx, byval id as Tko.NodeId ) as Tko.TypeId

    if id = Tko.NODE_NONE then return Tko.TYPE_NONE
    dim as Tko.TypeId known = c.info->TypeOf_( id )
    if known <> Tko.TYPE_NONE then return known

    dim as Tko.NodeKind k = c.ast->Kind( id )
    dim as Tko.TypeId t = Tko.TYPE_NONE

    select case k
    case Tko.N_INT_LIT, Tko.N_FLOAT_LIT, Tko.N_STRING_LIT, Tko.N_STRCAT
        t = LiteralType_( c, id )

    case Tko.N_IDENT
        dim as Tko.SymbolId sid = c.info->RefOf( id )
        dim as Tko.Symbol ptr s = c.syms->SymbolAt( sid )
        if s <> 0 then t = s->type_

        '' A REFERENCE IS TRANSPARENT IN AN EXPRESSION. 'byref n as integer' makes the
        '' SYMBOL a reference-to-integer, because the slot has to hold an address, but
        '' 'n' in an expression is an INTEGER: fbc types 'k = n' as an integer
        '' assignment and so must this, or every use of a byref parameter converts
        '' through a pointer on its way to a value.
        if t <> Tko.TYPE_NONE then
            if c.types->Kind( t ) = Tko.TK_REFERENCE then t = c.types->Inner( t )
        end if
        '' 'const K = 7' declares no type of its own, so the symbol carries none and
        '' every use of K was untyped -- which made the whole enclosing statement
        '' decline. Its type is its INITIALISER's, measured: K is INTEGER, 'const D =
        '' 2.5' is DOUBLE, and 'const S = "hi"' is ZSTRING * 3.
        ''
        '' Computed on DEMAND rather than when the declaration is walked, because a use
        '' can be typed before the declaration is reached and TypeOf_ memoises: an
        '' early use would cache TYPE_NONE and never look again.
        if (t = Tko.TYPE_NONE) andalso (s <> 0) then
            if (s->kind = cast( ubyte, Tko.SYM_CONSTANT )) andalso (s->payload <> 0) then
                dim as Tko.NodeId item = cast( Tko.NodeId, s->payload )
                if c.ast->Kind( item ) = Tko.N_VAR_ITEM then
                    if c.constDepth < CONST_DEPTH_MAX then
                        c.constDepth += 1
                        dim as Tko.StmtPayload ptr ip = StmtOf( c, item )
                        t = TypeOf_( c, ip->b )
                        c.constDepth -= 1
                        if t <> Tko.TYPE_NONE then s->type_ = t
                    end if
                end if
            end if
        end if

        '' 'var v = expr' -- an INFERRED variable, and its type is its INITIALISER's.
        '' There was no inference path at all: ResolveTypeRef on a 'var' item sees
        '' NODE_NONE, returns TYPE_NONE, and BindDeclType bails, so the symbol stayed
        '' untyped for ever. 937 corpus stores landed in a slot MIR could only type as
        '' 'void', which is the largest single verifier failure in the tree.
        ''
        '' Measured against fbc, the rule is exactly "the expression's type", with no
        '' decay of its own: 5 is INTEGER, 1.5 DOUBLE, false BOOLEAN, '@i' INTEGER PTR,
        '' a UDT value its UDT, and 'var v = ci' over a CONST INTEGER keeps the CONST.
        '' The one exception is a string LITERAL, whose own type is ZSTRING * N and
        '' which makes a STRING here.
        ''
        '' Lazily and on demand, for the same reason the constant above is: a use can
        '' be typed before the declaration is walked, and TypeOf_ memoises, so binding
        '' this eagerly would cache TYPE_NONE against the early use and never revisit.
        if (t = Tko.TYPE_NONE) andalso (s <> 0) then
            if (s->kind = cast( ubyte, Tko.SYM_VARIABLE )) andalso (s->payload <> 0) then
                dim as Tko.NodeId item = cast( Tko.NodeId, s->payload )
                if c.ast->Kind( item ) = Tko.N_VAR_ITEM then
                    dim as Tko.StmtPayload ptr ip = StmtOf( c, item )
                    '' ONLY an inferred one. A 'dim as T x' whose T did not resolve
                    '' must stay untyped: taking the initialiser's type there would
                    '' paper over an unresolved type name with a plausible answer.
                    if (ip->a = Tko.NODE_NONE) andalso (ip->b <> Tko.NODE_NONE) then
                        if c.constDepth < CONST_DEPTH_MAX then
                            c.constDepth += 1
                            dim as Tko.TypeId vt = TypeOf_( c, ip->b )
                            c.constDepth -= 1
                            if c.ast->Kind( ip->b ) = Tko.N_STRING_LIT then
                                vt = c.types->Builtin( Tko.TY_STRING )
                            end if
                            if vt <> Tko.TYPE_NONE then
                                t = vt
                                s->type_ = vt
                            end if
                        end if
                    end if
                end if
            end if
        end if

    case Tko.N_TUPLE
        '' 'type<P>( 5, 6 )' -- THE ANONYMOUS UDT LITERAL. The parser puts the written
        '' type in the list's TARGET, and that IS the expression's type; an ordinary
        '' tuple has no target and is left alone here, so the tuple feature is
        '' untouched.
        dim as Tko.ListPayload ptr tl = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
        if tl->target <> Tko.NODE_NONE then
            if c.ast->Kind( tl->target ) = Tko.N_TYPEREF then
                t = c.info->TypeOf_( tl->target )
            end if
        end if

    case Tko.N_PAREN
        '' A parenthesised expression is a LIST node, not a statement node: its
        '' single child is in the shared child pool. Reading it through the stmt
        '' pool indexes a different array entirely, which is a segfault, not a
        '' wrong answer.
        dim as Tko.ListPayload ptr lp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
        if lp->count > 0 then
            t = TypeOf_( c, cast( Tko.NodeId, c.ast->children[lp->first] ) )
        end if

    case Tko.N_UNARY
        dim as Tko.UnaryPayload ptr up = _
            @c.ast->unaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        dim as Tko.TypeId inner = TypeOf_( c, up->operand )
        dim as Tko.TokenKind op = cast( Tko.TokenKind, up->op )

        '' A USER-DEFINED UNARY OPERATOR, for the same reason the binary one comes
        '' first: '-d' over a UDT is a call, and the fallback below hands back the
        '' operand's own type as if the minus were free.
        dim as Tko.SymbolId uuop = UserUnaryOp_( c, op, inner )
        if uuop <> Tko.SYMBOL_NONE then
            dim as Tko.Symbol ptr uus = c.syms->SymbolAt( uuop )
            if uus <> 0 then
                c.info->SetRef( id, uuop )
                t = uus->type_
                exit select
            end if
        end if

        if inner <> Tko.TYPE_NONE then
            if op = Tko.KW_NOT then
                '' NOT keeps BOOLEAN boolean and widens everything else, exactly as
                '' the binary bitwise operators do.
                if c.types->BuiltinOf( inner ) = Tko.TY_BOOLEAN then
                    t = inner
                else
                    t = BinaryResult( Tko.KW_AND, inner, inner, *c.types )
                end if
            elseif (op = Tko.TK_MINUS) orelse (op = Tko.TK_PLUS) then
                t = BinaryResult( Tko.TK_PLUS, inner, inner, *c.types )
            else
                t = inner
            end if
        end if

    case Tko.N_BINARY
        dim as Tko.BinaryPayload ptr bp = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        dim as Tko.TypeId lt = TypeOf_( c, bp->lhs )
        dim as Tko.TypeId rt = TypeOf_( c, bp->rhs )
        dim as Tko.TokenKind op = cast( Tko.TokenKind, bp->op )

        '' A USER-DEFINED OPERATOR COMES FIRST WHEN AN OPERAND IS A UDT. Without it
        '' 'x - y' over two UDTs went down the builtin path -- and a UDT with an
        '' 'operator cast' to a number then SUBTRACTED THE RAW AGGREGATES as integers,
        '' emitting code, verifying, and never calling the operator that was written.
        dim as Tko.SymbolId uop = Tko.SYMBOL_NONE
        if IsUdtOperand_( c, lt ) orelse IsUdtOperand_( c, rt ) then
            uop = UserBinaryOp_( c, op, lt, rt )
            if uop <> Tko.SYMBOL_NONE then
                dim as Tko.Symbol ptr us = c.syms->SymbolAt( uop )
                if us <> 0 then
                    t = us->type_
                    c.info->SetRef( id, uop )
                end if
            end if
        end if
        if uop <> Tko.SYMBOL_NONE then exit select

        t = BinaryResult( op, lt, rt, *c.types )
        if (t = Tko.TYPE_NONE) andalso (lt <> Tko.TYPE_NONE) andalso _
           (rt <> Tko.TYPE_NONE) then
            '' Both operands are known and the combination is still not allowed --
            '' that is a real operand-type error rather than a gap in this pass.
            if (c.types->Kind( lt ) = Tko.TK_BUILTIN) andalso _
               (c.types->Kind( rt ) = Tko.TK_BUILTIN) then
                c.st->badOperands += 1
            end if
        end if

    case Tko.N_MEMBER
        '' 'x.f' needs the BASE's type before the field means anything, which is why
        '' Resolve deliberately left member names alone: it runs before any expression
        '' has a type. With the base typed, the field is an ordinary lookup in the
        '' UDT's own scope.
        '' EXCEPT a QUALIFIED NAME -- 'ns.counter', '..x'. Resolve bound those to the
        '' symbol itself, because a namespace is not a value and has no type to wait
        '' for. Its type is the symbol's, and without this the member came back
        '' untyped: LowerAddr already had the same shortcut, so 'ns.v = 3' STORED
        '' correctly while 'print ns.v' declined -- a write that worked and a read
        '' that did not, from one missing case.
        dim as Tko.SymbolId qsid = c.info->RefOf( id )
        if qsid <> Tko.SYMBOL_NONE then
            dim as Tko.Symbol ptr qs = c.syms->SymbolAt( qsid )
            if qs <> 0 then
                '' A CONSTANT OR ENUM MEMBER counts too, and only the VARIABLE case
                '' was here. 'NS.SOME_ENUM_MEMBER' got a REFERENCE and no TYPE, so
                '' every use of one was untyped -- 'error( FB.FB_RTERROR_... )' and
                '' 'dim as long n = FB.X' alike, which is how the runtime headers name
                '' every constant they export.
                select case cast( Tko.SymbolKind, qs->kind )
                case Tko.SYM_VARIABLE, Tko.SYM_CONSTANT, Tko.SYM_ENUMCONST
                    t = qs->type_
                    '' AN ENUM MEMBER WITH NO TYPE OF ITS OWN is an INTEGER, which is
                    '' what fbc gives one: the members carry values, and only the enum
                    '' TYPE carries a name.
                    if (t = Tko.TYPE_NONE) andalso _
                       (qs->kind = cast( ubyte, Tko.SYM_ENUMCONST )) then
                        t = c.types->Builtin( Tko.TY_INTEGER )
                    end if
                    exit select
                end select
            end if
        end if

        dim as Tko.BinaryPayload ptr mp = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        dim as Tko.TypeId bt = TypeOf_( c, mp->lhs )
        '' 'p->f' and 'p.f' on a pointer both reach through it, and CONST is
        '' transparent on the way: 'byref x as const T' and 'byval p as const T ptr'
        '' both wrap the UDT in a qualifier that the kind test refuses outright, so
        '' 'x.n' over one was UNTYPED and every read through it declined. That is the
        '' signature of every copy constructor in the corpus.
        if bt <> Tko.TYPE_NONE then
            bt = c.types->Unqualify( bt )
            if c.types->Kind( bt ) = Tko.TK_REFERENCE then
                bt = c.types->Unqualify( c.types->Inner( bt ) )
            end if
            if c.types->Kind( bt ) = Tko.TK_POINTER then
                bt = c.types->Unqualify( c.types->Inner( bt ) )
            end if
        end if
        '' 'p->v' OVER A UDT IS A CALL to that UDT's global 'operator ->', and the
        '' field is then looked up in WHAT IT RETURNS. fb/sharedptr.bi and
        '' fb/comptr.bi both declare one; without this every arrow on a smart pointer
        '' was an untyped member access, and an untyped member access is a statement
        '' that lowers to nothing.
        ''
        '' Only when the base has no field of that name itself: a UDT may declare both.
        if (bt <> Tko.TYPE_NONE) andalso _
           ((c.ast->nodes[cast( long, id )].flags and Tko.NF_ARROW) <> 0) then
            if c.types->Kind( bt ) = Tko.TK_UDT then
                dim as boolean haveOwn = false
                if c.ast->Kind( mp->rhs ) = Tko.N_IDENT then
                    dim as Tko.IdentPayload ptr ap0 = _
                        @c.ast->idents[cast( long, c.ast->nodes[cast( long, mp->rhs )].data )]
                    haveOwn = (FieldOf_( c, bt, ap0->name ) <> Tko.SYMBOL_NONE)
                end if
                if haveOwn = false then
                    dim as Tko.SymbolId aop = ArrowOperatorFor( _
                        *c.types, *c.syms, *c.names, *c.ast, *c.info, bt )
                    if aop <> Tko.SYMBOL_NONE then
                        dim as Tko.TypeId art = ArrowResultType( *c.types, *c.syms, aop )
                        if art <> Tko.TYPE_NONE then bt = art
                    end if
                end if
            end if
        end if

        if (bt <> Tko.TYPE_NONE) andalso (c.ast->Kind( mp->rhs ) = Tko.N_IDENT) then
            dim as Tko.IdentPayload ptr ip = _
                @c.ast->idents[cast( long, c.ast->nodes[cast( long, mp->rhs )].data )]
            dim as Tko.SymbolId fs = FieldOf_( c, bt, ip->name )
            if fs <> Tko.SYMBOL_NONE then
                dim as Tko.Symbol ptr f = c.syms->SymbolAt( fs )
                if f <> 0 then
                    '' Recorded on the MEMBER node so lowering can find the field
                    '' without repeating the lookup.
                    c.info->SetRef( id, fs )
                    c.info->SetRef( mp->rhs, fs )
                    t = f->type_
                end if
            end if
        end if

    case Tko.N_CALL
        '' The callee's symbol was bound by Resolve; the overloads hang off it in a
        '' chain. Score every candidate against the arguments and take the unique
        '' cheapest -- a tie is an ambiguous call, not a silent pick.
        dim as Tko.ListPayload ptr cp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
        '' Indexing and calling share a spelling, so the callee's TYPE decides which
        '' this is. An array subscript yields the ELEMENT type; without this the whole
        '' expression is untyped and every use of a(i) falls back to nothing.
        dim as Tko.TypeId ct = TypeOf_( c, cp->target )
        if (ct <> Tko.TYPE_NONE) andalso (c.types->Kind( ct ) = Tko.TK_ARRAY) then
            t = c.types->Inner( ct )
        else
            '' A conversion intrinsic is a KEYWORD, so nothing was ever bound and the
            '' callee lookup below finds nothing. Its result is a measured table.
            t = IntrinsicCallType_( c, cp )
            if t = Tko.TYPE_NONE then
                dim as Tko.SymbolId callee = c.info->RefOf( cp->target )
                '' 'P( 3 )' IS AN OBJECT OF TYPE P. The callee is bound to the UDT
                '' rather than to a procedure, so overload resolution had nothing to
                '' work with and the expression came out UNTYPED -- which is what made
                '' 'P( 3 ).v' decline while the same member on a FUNCTION's returned
                '' temporary worked. fb/chrono.bi writes most of its assertions this
                '' way: 'DateTime( 2025, 1, 31 ).AddMonths( 0 ).Ticks'.
                dim as Tko.Symbol ptr cs2 = c.syms->SymbolAt( callee )
                if cs2 <> 0 then
                    if cs2->kind = cast( ubyte, Tko.SYM_UDT ) then
                        t = cs2->type_
                    end if
                end if
                if (t = Tko.TYPE_NONE) andalso (callee <> Tko.SYMBOL_NONE) then
                    t = ResolveCall_( c, id, callee, cp->first, cp->count )
                end if
            end if
        end if

    case Tko.N_NEW
        '' 'new T' IS A POINTER TO T, whatever else it is. Resolve typed the target as
        '' a type reference; this turns it into the pointer the expression yields.
        dim as Tko.ListPayload ptr np = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
        if np->target <> Tko.NODE_NONE then
            dim as Tko.TypeId nt = c.info->TypeOf_( np->target )
            if nt <> Tko.TYPE_NONE then t = c.types->Pointer_( nt )
        end if

    case Tko.N_INDEX
        '' 'p[i]' -- A POINTER SUBSCRIPT, which had no case at all, so it was untyped
        '' and everything built on it was too. LowerSwap grew a private workaround for
        '' exactly this; with assignment now declining rather than storing into a void
        '' slot, 'p[i] = 5' declined outright -- 432 statements in one corpus file.
        ''
        '' In -lang fb '[ ]' is only ever pointer indexing, so the type is the pointee.
        dim as Tko.ListPayload ptr xp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
        if xp->target <> Tko.NODE_NONE then
            dim as Tko.TypeId pt = TypeOf_( c, xp->target )
            if pt <> Tko.TYPE_NONE then
                if c.types->Kind( pt ) = Tko.TK_POINTER then
                    t = c.types->Inner( pt )
                elseif IsVarLenStrBuiltin_( c, pt ) then
                    '' A VAR-LENGTH STRING SUBSCRIPTED IS ITS CHARACTER, exactly as a
                    '' fixed one is, and UNSIGNED for the same reason: a sign
                    '' extension would turn a wide character above 0x7FFF negative.
                    '' Measured, fbc writes '(int32)*(uint8*)(...)' for a string and
                    '' '(int32)*(uint16*)(...)' for a ustring.
                    ''
                    '' Only the ARRAY spelling had a case, so 's[i]' over a plain
                    '' string was UNTYPED -- and an untyped target is what makes an
                    '' assignment decline rather than store somewhere wrong.
                    if c.types->BuiltinOf( c.types->Unqualify( pt ) ) = Tko.TY_USTRING then
                        t = c.types->Builtin( Tko.TY_USHORT )
                    else
                        t = c.types->Builtin( Tko.TY_UBYTE )
                    end if
                elseif c.types->Kind( pt ) = Tko.TK_ARRAY then
                    '' A FIXED-LENGTH STRING SUBSCRIPTED IS ITS CHARACTER, and an
                    '' UNSIGNED one: fbc writes '(int32)*(uint16*)(...)' for a wstring
                    '' and '(int32)*(uint8*)(...)' for a zstring. Signedness is the
                    '' point -- a sign extension would turn a wide character above
                    '' 0x7FFF negative.
                    dim as Tko.TypeId el = c.types->Inner( pt )
                    if el <> Tko.TYPE_NONE then
                        if c.types->Kind( el ) = Tko.TK_BUILTIN then
                            select case c.types->BuiltinOf( el )
                            case Tko.TY_ZSTRING : t = c.types->Builtin( Tko.TY_UBYTE )
                            case Tko.TY_WSTRING, Tko.TY_FIXUSTR
                                t = c.types->Builtin( Tko.TY_USHORT )
                            case else           : t = el
                            end select
                        else
                            t = el
                        end if
                    end if
                elseif c.types->Kind( pt ) = Tko.TK_UDT then
                    '' 'a[ i ]' OVER A UDT IS ITS 'operator []', which is how every
                    '' container in the runtime headers is read and written. Untyped,
                    '' the assignment through one declined -- 'a[ 1 ] = 99' is what a
                    '' container is FOR -- and so did every expression built on it.
                    ''
                    '' A BYREF result is a REFERENCE to the element; the element's own
                    '' type is what the expression has, exactly as a byref parameter's
                    '' use does.
                    dim as Tko.SymbolId ixs = UdtOperatorNamed_( c, pt, "[]" )
                    if ixs <> Tko.SYMBOL_NONE then
                        dim as Tko.Symbol ptr ixsym = c.syms->SymbolAt( ixs )
                        if ixsym <> 0 then
                            t = ixsym->type_
                            if t <> Tko.TYPE_NONE then
                                if c.types->Kind( t ) = Tko.TK_REFERENCE then
                                    t = c.types->Inner( t )
                                end if
                            end if
                            c.info->SetRef( id, ixs )
                        end if
                    end if
                end if
            end if
        end if

    case Tko.N_DEREF
        '' Built by MakeUnary, so the payload is a UNARY, not a statement.
        dim as Tko.UnaryPayload ptr dp = _
            @c.ast->unaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        dim as Tko.TypeId inner = TypeOf_( c, dp->operand )
        if inner <> Tko.TYPE_NONE then
            if c.types->Kind( inner ) = Tko.TK_POINTER then t = c.types->Inner( inner )
        end if

    case Tko.N_ADDROF
        dim as Tko.UnaryPayload ptr ap = _
            @c.ast->unaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        dim as Tko.TypeId inner = TypeOf_( c, ap->operand )
        if inner <> Tko.TYPE_NONE then
            t = c.types->Pointer_( inner )
        else
            '' '@mysub' -- A PROCEDURE has no type of its own on its symbol (that slot
            '' holds its RETURN type), so the operand came back untyped and 'var f =
            '' @mysub' inferred nothing. Measured: fbc says 'typeof( @mysub )' is
            '' 'SUB()' -- the procedure type itself, which is already a pointer in
            '' FreeBASIC and so is NOT wrapped again.
            dim as Tko.SymbolId psid = c.info->RefOf( ap->operand )
            dim as Tko.Symbol ptr psym = c.syms->SymbolAt( psid )
            if psym <> 0 then
                if psym->kind = cast( ubyte, Tko.SYM_PROC ) then
                    t = ProcTypeOfSymbol_( c, psid )
                end if
            end if
        end if
    end select

    if t <> Tko.TYPE_NONE then
        c.info->SetType( id, t )
        c.st->typed += 1
    else
        c.st->untyped += 1
    end if
    return t
end function

'' ---------------------------------------------------------------- the walk

'' A 'var' whose variable is never USED afterwards still needs a type: the lazy path
'' in TypeOf_ above fires on a use, and an unused one has none. The slot is allocated
'' regardless, and an untyped slot is 'void' in MIR.
''
'' A pass over the SYMBOLS rather than the nodes, and after every expression has been
'' typed, so the initialiser's type is already known whatever order the declaration
'' appeared in.
'' 'var byref ri = i' IS AN ALIAS, and its type has to come out a REFERENCE the same
'' way 'dim byref ri as integer = i' does -- Resolve wraps that one, but an INFERRED
'' type is not known until here. Without this the slot was an i64 while the
'' declaration stored an ADDRESS into it: 'stores ptr into a i64 slot', thirteen of
'' them in one corpus file, and every later read of the alias read the address as the
'' value. A reference to a reference is still one reference, so an initialiser that is
'' itself an alias is unwrapped first.
private function RefWrapIfAlias_ _
    ( byref c as Ctx, byval s as Tko.Symbol ptr, byval t as Tko.TypeId ) as Tko.TypeId

    if (s->flags and Tko.SYMF_BYREF) = 0 then return t
    if t = Tko.TYPE_NONE then return t
    if c.types->Kind( t ) = Tko.TK_REFERENCE then return t
    return c.types->Reference( t )
end function

private sub InferUnusedVarTypes_( byref c as Ctx )
    '' 'to Count( )', not 'to Count( ) - 1'. SymbolTable.Count already returns
    '' 'symbols.Count - 1', so the valid ids are 1..Count( ) -- subtracting again
    '' skipped THE LAST SYMBOL IN THE TABLE. If that symbol was an unused inferred
    '' 'var' it stayed untyped and its slot lowered to void, so 'var a = 1' alone in a
    '' file failed while the same line with any declaration after it passed. Five
    '' corpus files, and the whole difference was where the variable happened to sit.
    for sid as long = 1 to c.syms->Count( )
        dim as Tko.Symbol ptr s = c.syms->SymbolAt( cast( Tko.SymbolId, sid ) )
        if s = 0 then continue for
        '' A CONSTANT too: 'const n1c as typeof( n1 ) = ( n1 )' is the shape the
        '' corpus writes, and a constant's type is bound the same way.
        dim as boolean inferrable = _
            (s->kind = cast( ubyte, Tko.SYM_VARIABLE )) orelse _
            (s->kind = cast( ubyte, Tko.SYM_CONSTANT ))
        if inferrable = false then continue for
        if s->type_ <> Tko.TYPE_NONE then continue for
        if s->payload = 0 then continue for
        dim as Tko.NodeId item = cast( Tko.NodeId, s->payload )
        if c.ast->Kind( item ) <> Tko.N_VAR_ITEM then continue for
        dim as Tko.StmtPayload ptr ip = StmtOf( c, item )

        '' 'dim x as typeof( EXPR )'. The declared type IS an expression's type, which
        '' only Check can say -- Resolve handles the bare-name form and leaves this
        '' one, so the symbol arrives here untyped and its slot lowered to 'void'.
        '' 44 of the corpus's remaining verifier failures are one file writing
        '' 'const n1c as typeof( n1 ) = ( n1 )' inside a macro, where n1 expands to a
        '' conversion call.
        if ip->a <> Tko.NODE_NONE then
            if c.ast->Kind( ip->a ) = Tko.N_TYPEREF then
                dim as Tko.StmtPayload ptr tp = StmtOf( c, ip->a )
                if cast( Tko.TokenKind, tp->op ) = Tko.KW_TYPEOF then
                    if tp->b <> Tko.NODE_NONE then
                        dim as Tko.TypeId tt = TypeOf_( c, tp->b )
                        '' A REFERENCE is transparent, as it is in an expression.
                        if tt <> Tko.TYPE_NONE then
                            if c.types->Kind( tt ) = Tko.TK_REFERENCE then
                                tt = c.types->Inner( tt )
                            end if
                            s->type_ = RefWrapIfAlias_( c, s, tt )
                        end if
                    end if
                end if
            end if
            continue for
        end if

        '' Inferred only. A 'dim as T x' whose T did not resolve stays untyped.
        if ip->b = Tko.NODE_NONE then continue for
        dim as Tko.TypeId vt = TypeOf_( c, ip->b )
        if c.ast->Kind( ip->b ) = Tko.N_STRING_LIT then
            vt = c.types->Builtin( Tko.TY_STRING )
        end if
        if vt <> Tko.TYPE_NONE then s->type_ = RefWrapIfAlias_( c, s, vt )
    next
end sub

'' A member of a UDT by name, folded -- procedures included, which is what tells this
'' from FieldOf_.
function UdtMemberSym_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byref nm as string ) as Tko.SymbolId

    if t = Tko.TYPE_NONE then return Tko.SYMBOL_NONE
    dim as Tko.TypeId u = c.types->Unqualify( t )
    if c.types->Kind( u ) <> Tko.TK_UDT then return Tko.SYMBOL_NONE
    dim as Tko.InternId tn = c.types->NameOf( u )
    if tn = 0 then return Tko.SYMBOL_NONE
    dim as Tko.ScopeId ds = cast( Tko.ScopeId, c.types->DeclScopeOf( u ) )
    dim as Tko.SymbolId ts = c.syms->LookupLocalTyped( ds, tn, true )
    if ts = Tko.SYMBOL_NONE then ts = c.syms->LookupTyped( ds, tn, true )
    dim as Tko.Symbol ptr sy = c.syms->SymbolAt( ts )
    if sy = 0 then return Tko.SYMBOL_NONE
    if sy->inner = Tko.SCOPE_NONE then return Tko.SYMBOL_NONE
    return c.syms->LookupLocal( sy->inner, c.names->Fold( c.names->GetString( nm ) ) )
end function

'' THE 'for each' LOOP VARIABLE, where Resolve could not work it out.
''
'' Resolve types it from the sequence's SYMBOL, which is all it can do -- an
'' expression's type is Check's to record and Check has not run yet. That covers a
'' variable and a parameter and nothing else: 'for each dd in d.Value( )' is a CALL,
'' whose symbol is the procedure, and the sequence type is its RETURN type. Which
'' Check knows and Resolve does not.
''
'' A PRE-PASS, before the walk, for the same reason InferUnusedVarTypes_ is: every
'' USE of the loop variable is inside the body, and the walk types those.
private sub InferForEachVarTypes_( byref c as Ctx )
    for i as long = 1 to c.ast->Count( )
        dim as Tko.NodeId n = cast( Tko.NodeId, i )
        if c.ast->Kind( n ) <> Tko.N_FOREACH then continue for
        dim as Tko.StmtPayload ptr sp = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, n )].data )]
        if sp->a = Tko.NODE_NONE then continue for
        if sp->count <> 1 then continue for
        dim as Tko.Symbol ptr vsym = c.syms->SymbolAt( c.info->RefOf( sp->a ) )
        if vsym = 0 then continue for
        if vsym->type_ <> Tko.TYPE_NONE then continue for

        dim as Tko.NodeId seqE = cast( Tko.NodeId, c.ast->children[sp->first] )
        dim as Tko.TypeId seqT = TypeOf_( c, seqE )
        if seqT = Tko.TYPE_NONE then continue for
        seqT = c.types->Unqualify( seqT )
        if c.types->Kind( seqT ) = Tko.TK_REFERENCE then
            seqT = c.types->Unqualify( c.types->Inner( seqT ) )
        end if
        if c.types->Kind( seqT ) = Tko.TK_ARRAY then
            vsym->type_ = c.types->Inner( seqT )
        elseif c.types->Kind( seqT ) = Tko.TK_UDT then
            '' The RFC-0002 protocol: GetIterator gives the iterator's type and its
            '' Value( ) gives the element's.
            dim as Tko.SymbolId gi = UdtMemberSym_( c, seqT, "getiterator" )
            dim as Tko.Symbol ptr gs = c.syms->SymbolAt( gi )
            if gs <> 0 then
                dim as Tko.SymbolId vo = UdtMemberSym_( c, gs->type_, "value" )
                dim as Tko.Symbol ptr vs2 = c.syms->SymbolAt( vo )
                if vs2 <> 0 then
                    dim as Tko.TypeId et = vs2->type_
                    if et <> Tko.TYPE_NONE then
                        if c.types->Kind( et ) = Tko.TK_REFERENCE then
                            et = c.types->Inner( et )
                        end if
                    end if
                    vsym->type_ = et
                end if
            end if
        end if
    next
end sub

private sub WalkAll( byref c as Ctx )
    '' Every expression node in the arena, in id order. Expressions are created
    '' bottom-up by the parser, so a child always has a LOWER id than its parent and
    '' one linear pass types the whole tree without recursion into statements.
    for i as long = 1 to c.ast->Count( )
        dim as Tko.NodeId n = cast( Tko.NodeId, i )
        select case c.ast->Kind( n )
        case Tko.N_INT_LIT, Tko.N_FLOAT_LIT, Tko.N_STRING_LIT, Tko.N_STRCAT, _
             Tko.N_IDENT, Tko.N_PAREN, Tko.N_UNARY, Tko.N_BINARY, _
             Tko.N_DEREF, Tko.N_ADDROF, Tko.N_CALL, Tko.N_MEMBER, _
             Tko.N_INDEX, Tko.N_NEW, Tko.N_TUPLE
            '' N_INDEX was missing from this list, so 'p[i]' was never typed however
            '' well the case for it was written -- the cache is what lowering reads,
            '' and nothing ever filled it. A missing case here is invisible: the type
            '' function has the answer and no one asks it.
            TypeOf_( c, n )

        case Tko.N_AMBIGUOUS
            '' A CALL WRITTEN AS A STATEMENT IS NOT AN N_CALL NODE. 'W 1, 2' is this
            '' statement's own callee and children, so nothing here ever costed its
            '' arguments -- and lowering then used whatever Resolve had bound, which is
            '' the HEAD of the overload chain. Every overloaded statement call went to
            '' the first candidate: 'screeninfo w, h' over INTEGERs called the 32-bit
            '' entry point with int64 pointers.
            ''
            '' The chosen symbol is recorded on the CALLEE IDENT, which is where
            '' LowerStmtCall reads it from.
            if c.info->AmbiguousOf( n ) = Tko.AMB_CALL then
                dim as Tko.StmtPayload ptr asp = _
                    @c.ast->stmts[cast( long, c.ast->nodes[cast( long, n )].data )]
                if asp->a <> Tko.NODE_NONE then
                    if c.ast->Kind( asp->a ) = Tko.N_IDENT then
                        dim as Tko.SymbolId ac = c.info->RefOf( asp->a )
                        dim as Tko.Symbol ptr acs = c.syms->SymbolAt( ac )
                        if acs <> 0 then
                            '' Only when there is a choice to make: a single candidate
                            '' is already bound, and re-costing it could only take a
                            '' binding away.
                            if (acs->kind = cast( ubyte, Tko.SYM_PROC )) andalso _
                               (acs->nextOverload <> Tko.SYMBOL_NONE) then
                                ResolveCall_( c, asp->a, ac, asp->first, asp->count )
                            end if
                        end if
                    end if
                end if
            end if
        end select
    next
end sub

function Run _
    ( byref ast as Tko.AstArena, byval root as Tko.NodeId, _
      byref syms as Tko.SymbolTable, byref types as Tko.TypeContext, _
      byref names as Tko.Interner, byref diags as Tko.DiagnosticEngine, _
      byref info as Tko.SemanticInfo, byref st as Stats ) as long

    dim as Ctx c
    c.ast = @ast
    c.syms = @syms
    c.types = @types
    c.names = @names
    c.diags = @diags
    c.info = @info
    c.st = @st
    '' TWICE, AND THE FIRST ONE IS THE POINT. A variable declared 'as typeof( EXPR )'
    '' gets its type here and nowhere else -- Resolve handles only the bare-name form --
    '' and every REFERENCE to that variable is typed by the walk, which caches. Running
    '' this only afterwards typed the symbol correctly and left every USE of it
    '' untyped, so 'str( n1v )' declined while 'str( n2v )' beside it worked. The
    '' second pass stays because a typeof whose operand needs the walk resolves then.
    InferUnusedVarTypes_( c )
    InferForEachVarTypes_( c )
    WalkAll( c )
    InferUnusedVarTypes_( c )
    return st.badOperands
end function

'' ------------------------------------------------------------------------ dump

function Dump _
    ( byref ast as Tko.AstArena, byref src as Tko.SourceManager, _
      byref types as Tko.TypeContext, byref names as Tko.Interner, _
      byref info as Tko.SemanticInfo, byref st as Stats ) as string

    dim as string outp = ""
    for i as long = 1 to ast.Count( )
        dim as Tko.NodeId n = cast( Tko.NodeId, i )

        '' An assignment reports its LEGALITY rather than a type, so
        '' tools/gen/check-assign.py can put the verdict beside fbc's.
        if ast.Kind( n ) = Tko.N_AMBIGUOUS then
            if info.AmbiguousOf( n ) = Tko.AMB_ASSIGN then
                '' N_AMBIGUOUS is a STATEMENT payload -- 'a' is the target and 'b'
                '' the value -- not a binary. Reading it as a binary indexes a
                '' different arena, which is the exact mistake phase-5-check.md warns
                '' about, made again while writing this.
                dim as Tko.StmtPayload ptr ap = _
                    @ast.stmts[cast( long, ast.nodes[cast( long, n )].data )]
                dim as Tko.TypeId dt = info.TypeOf_( ap->a )
                dim as Tko.TypeId st2 = info.TypeOf_( ap->b )
                dim as string verdict = "assign:unknown"
                if (dt <> Tko.TYPE_NONE) andalso (st2 <> Tko.TYPE_NONE) then
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

        if ast.Kind( n ) <> Tko.N_INTRINSIC then continue for
        dim as Tko.StmtPayload ptr sp = _
            @ast.stmts[cast( long, ast.nodes[cast( long, n )].data )]
        if sp->count <= 0 then continue for
        dim as Tko.NodeId arg = cast( Tko.NodeId, ast.children[sp->first] )
        if arg = Tko.NODE_NONE then continue for
        dim as Tko.TypeId t = info.TypeOf_( arg )
        dim as string nm = "?"
        if t <> Tko.TYPE_NONE then nm = types.Name( t )
        outp += str( src.Decode( ast.Loc( n ) ).lineNo ) & " " & nm & chr( 10 )
        '' Constants get their own line with a NON-numeric prefix, so the promotion
        '' and overload gates -- which key on 'line type' -- cannot collide with it.
        dim as ConstVal cv = ConstOf( ast, arg, src, names, types.target.pointerBits )
        if cv.known then
            outp += "const " & str( src.Decode( ast.Loc( n ) ).lineNo ) & " " & _
                    str( cv.value ) & chr( 10 )
        end if
    next
    for i as long = 0 to st.argUntypedNames.Count - 1
        outp += "arg-untyped-name " & _
                names.Spelling( cast( Tko.InternId, st.argUntypedNames[i] ) ) & chr( 10 )
    next
    '' The expression forms that came back untyped in ARGUMENT position, which is the
    '' list of things to implement next: one of these declines its whole statement.
    for i as long = 0 to st.argUntypedKind.Count - 1
        if st.argUntypedKind[i] = 0 then continue for
        outp += "arg-untyped " & Tko.NodeKindName( cast( Tko.NodeKind, i ) ) & " " & _
                str( st.argUntypedKind[i] ) & chr( 10 )
    next
    outp += "checked: " & st.typed & " typed, " & st.untyped & " untyped, " & _
            st.badOperands & " bad operand pairs, " & st.callsResolved & _
            " calls resolved, " & st.callsAmbiguous & " ambiguous" & chr( 10 )
    return outp
end function

end namespace
