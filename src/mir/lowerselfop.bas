'' lowerselfop.bas -- 'u += v' over a UDT, which is a MEMBER CALL.
''
'' Split out of lowerintr.bas at the 1500-line cap. Nothing about it changed in the move.

#include once "mir/lowerctx.bi"

namespace Tko.Mir

using Tko

'' THE MEMBER NAME of a self-operator, as the parser interned it, or "" for a token
'' that is not one. The punctuation forms lex as ONE token and the word forms as two,
'' which the parser joins -- so 'operator and=' is a member called 'and='.
private function SelfOpName_( byval op as Tko.TokenKind ) as string
    select case op
    case Tko.TK_PLUSEQ   : return "+="
    case Tko.TK_MINUSEQ  : return "-="
    case Tko.TK_STAREQ   : return "*="
    case Tko.TK_SLASHEQ  : return "/="
    case Tko.TK_BSLASHEQ : return "\="
    case Tko.TK_CARETEQ  : return "^="
    case Tko.TK_AMPEQ    : return "&="
    case Tko.KW_AND      : return "and="
    case Tko.KW_OR       : return "or="
    case Tko.KW_XOR      : return "xor="
    case Tko.KW_IMP      : return "imp="
    case Tko.KW_EQV      : return "eqv="
    case Tko.KW_MOD      : return "mod="
    case Tko.KW_SHL      : return "shl="
    case Tko.KW_SHR      : return "shr="
    end select
    return ""
end function

'' How many parameters a procedure symbol was declared with.
private function ParamCountOf_ _
    ( byref c as Ctx, byval proc_ as Tko.SymbolId ) as long

    dim as Tko.Symbol ptr s = c.syms->SymbolAt( proc_ )
    if s = 0 then return -1
    dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
    if pn = Tko.NODE_NONE then return -1
    if c.ast->Kind( pn ) <> Tko.N_PROC then return -1
    dim as Tko.StmtPayload ptr pp = StmtOf( c, pn )
    dim as long np = 0
    for i as long = 0 to pp->count - 1
        dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp->first + i] )
        if c.ast->Kind( prm ) = Tko.N_PARAM then np += 1
    next
    return np
end function

'' 'u += v' over a UDT that declares 'operator +=' -- see the call site.
''
'' THE OVERLOAD IS CHOSEN BY THE PARAMETER'S TYPE, walked over the chain: a type may
'' declare '+=' for several right-hand types, and taking the head would take one at
'' random. An operand whose type matches nothing declines rather than being converted
'' on a guess.
function SelfOpMemberCall_ _
    ( byref c as Ctx, byval target as Tko.NodeId, byval value as Tko.NodeId, _
      byval op as Tko.TokenKind, byval tt as Tko.TypeId ) as boolean

    dim as Tko.TypeId ut = c.types->Unqualify( tt )
    if c.types->Kind( ut ) <> Tko.TK_UDT then return false
    dim as string opn = SelfOpName_( op )
    if len( opn ) = 0 then return false

    dim as Tko.TypeId vt = c.types->Unqualify( c.info->TypeOf_( value ) )
    if vt = Tko.TYPE_NONE then return false

    '' SCORED, NOT MATCHED EXACTLY. 'u += 10' over a type declaring both
    '' 'operator +=( byref as T )' and 'operator +=( byval as long )' has to reach the
    '' second one, and an integer LITERAL is not a 'long' -- so an equality test picked
    '' neither and the statement declined with the operator sitting right there.
    ''
    '' A TIE PICKS NOTHING. Two candidates the operand converts to equally well is
    '' exactly the case where guessing writes a call to the wrong one.
    dim as Tko.SymbolId cur = UdtMemberNamed_( c, ut, opn )
    dim as Tko.SymbolId want = Tko.SYMBOL_NONE
    dim as long best = Tko.Check.CONV_NONE
    dim as long ties = 0
    dim as long guard = 0
    while (cur <> Tko.SYMBOL_NONE) andalso (guard < 1000)
        guard += 1
        dim as Tko.Symbol ptr os = c.syms->SymbolAt( cur )
        if os = 0 then exit while
        if ParamCountOf_( c, cur ) = 1 then
            dim as Tko.TypeId pt = ParamTypeAt( c, cur, 0 )
            if pt <> Tko.TYPE_NONE then
                dim as Tko.TypeId pu = c.types->Unqualify( pt )
                if c.types->Kind( pu ) = Tko.TK_REFERENCE then
                    pu = c.types->Unqualify( c.types->Inner( pu ) )
                end if
                dim as long cost = Tko.Check.CONV_NONE
                if pu = vt then
                    cost = Tko.Check.CONV_EXACT
                else
                    cost = Tko.Check.ConversionCost( vt, pu, *c.types )
                end if
                if cost < best then
                    best = cost
                    want = cur
                    ties = 0
                elseif (cost = best) andalso (cost < Tko.Check.CONV_NONE) then
                    ties += 1
                end if
            end if
        end if
        cur = os->nextOverload
    wend
    if want = Tko.SYMBOL_NONE then return false
    if ties > 0 then return false

    dim as MirValue self_ = LowerAddr( c, target )
    if self_.kind = cast( ubyte, MV_NONE ) then return false

    dim as MirValue av
    if ParamIsByref( c, want, 0 ) then
        av = LowerAddr( c, value )
    else
        av = LowerExpr( c, value )
        '' TO THE PARAMETER'S WIDTH, not the operand's -- the same rule an ordinary
        '' call's arguments follow.
        if av.kind <> cast( ubyte, MV_NONE ) then
            dim as MirType pmt = LowerType( ParamTypeAt( c, want, 0 ), *c.types )
            if (pmt <> MT_VOID) andalso (pmt <> MT_AGG) then
                av = Coerce( c, av, pmt, IsUnsignedType( c, vt ) )
            end if
        end if
    end if
    if av.kind = cast( ubyte, MV_NONE ) then return false

    dim as FB.Array( of ulong ) oargs
    oargs.Push( cast( ulong, av.kind ) )
    oargs.Push( cast( ulong, av.id ) )
    EmitStructorCall( c, want, -1, @self_, @oargs )
    return true
end function



'' THE INTRINSIC STATEMENTS. One keyword each, dispatched on the op the parser
'' recorded -- and three of those keywords are TWO statements sharing a spelling,
'' which is what the 'extra' bits are for. Split out of lower.bas when that file
'' reached the 1500-line cap; nothing about it changed in the move.
'' 'rgb( r, g, b )' AND 'rgba( r, g, b, a )'. Neither is a call: fbc folds each into
'' shifts and ors, and each component is TRUNCATED TO A BYTE first. Measured:
''
''   rgb( r, g, b )      ((r&255) << 16) | ((g&255) << 8) | (b&255) | 0xFF000000
''   rgba( r, g, b, a )  the same three, with ((a&255) << 24) in place of the constant
''
'' The opaque alpha in the three-argument form is why they are not one function with a
'' default: 0xFF000000 is a CONSTANT there and a shifted operand here.
''
'' They are PREDECLARED NAMES rather than procedures -- 'dim as long rgb' is fbc's
'' error 4 -- so they cannot be written in the prelude either.
function LowerRgbCall_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    if c.ast->Kind( id ) <> Tko.N_CALL then return false
    dim as Tko.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if cp->target = Tko.NODE_NONE then return false
    if c.ast->Kind( cp->target ) <> Tko.N_IDENT then return false
    dim as Tko.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, cp->target )].data )]
    dim as string nm = Tko.Text.LowerAscii( c.names->Spelling( ip->name ) )
    dim as long want = 0
    if nm = "rgb" then
        want = 3
    elseif nm = "rgba" then
        want = 4
    else
        return false
    end if
    if cp->count <> want then return false

    '' One component: masked to a byte and widened, which is what the casts in fbc's
    '' output amount to.
    dim as MirValue parts( 0 to 3 )
    for i as long = 0 to want - 1
        dim as Tko.NodeId an = cast( Tko.NodeId, c.ast->children[cp->first + i] )
        dim as MirValue v = LowerExpr( c, an )
        if v.kind = cast( ubyte, MV_NONE ) then return false
        v = Coerce( c, v, MT_I64, IsUnsignedType( c, c.info->TypeOf_( an ) ) )
        dim as MirInst m
        m.op = cast( ushort, M_AND )
        m.ty = cast( ubyte, MT_I64 )
        m.a = v
        m.b = ConstInt( c, 255, MT_I64 )
        parts( i ) = Emit( c, m )
        if parts( i ).kind = cast( ubyte, MV_NONE ) then return false
    next

    '' Shift each into place, then or them together.
    dim as long shifts( 0 to 3 ) = { 16, 8, 0, 24 }
    dim as MirValue acc
    for i as long = 0 to want - 1
        dim as MirValue term = parts( i )
        if shifts( i ) <> 0 then
            dim as MirInst sh
            sh.op = cast( ushort, M_SHL )
            sh.ty = cast( ubyte, MT_I64 )
            sh.a = term
            sh.b = ConstInt( c, shifts( i ), MT_I64 )
            term = Emit( c, sh )
            if term.kind = cast( ubyte, MV_NONE ) then return false
        end if
        if i = 0 then
            acc = term
        else
            dim as MirInst o
            o.op = cast( ushort, M_OR )
            o.ty = cast( ubyte, MT_I64 )
            o.a = acc
            o.b = term
            acc = Emit( c, o )
            if acc.kind = cast( ubyte, MV_NONE ) then return false
        end if
    next

    if want = 3 then
        '' The opaque alpha.
        dim as MirInst o2
        o2.op = cast( ushort, M_OR )
        o2.ty = cast( ubyte, MT_I64 )
        o2.a = acc
        o2.b = ConstInt( c, 4278190080, MT_I64 )
        acc = Emit( c, o2 )
        if acc.kind = cast( ubyte, MV_NONE ) then return false
    end if

    outv = Coerce( c, acc, MT_I32, true )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

end namespace
