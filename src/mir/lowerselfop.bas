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
'' THE ELEMENT TYPE OF A BARE ARRAY REFERENCE -- 'a' or 'a( )' -- or TYPE_NONE for
'' anything else. A self-operator can take an ARRAY parameter, 'operator +=( array( )
'' as integer )', and the argument written for it is the array's NAME: it has no value
'' and no scalar type, so scoring it against the parameter answered CONV_NONE and every
'' 'x += a( )' declined with the operator declared right there.
private function ArrayArgElem_ _
    ( byref c as Ctx, byval argNode as Tko.NodeId ) as Tko.TypeId

    if argNode = Tko.NODE_NONE then return Tko.TYPE_NONE
    dim as Tko.NodeId nameNode = argNode
    if c.ast->Kind( argNode ) = Tko.N_CALL then
        dim as Tko.ListPayload ptr lp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, argNode )].data )]
        if lp->count <> 0 then return Tko.TYPE_NONE
        if lp->target = Tko.NODE_NONE then return Tko.TYPE_NONE
        nameNode = lp->target
    end if
    dim as Tko.TypeId at = c.info->TypeOf_( nameNode )
    if at = Tko.TYPE_NONE then return Tko.TYPE_NONE
    if c.types->Kind( at ) <> Tko.TK_ARRAY then return Tko.TYPE_NONE
    return c.types->Unqualify( c.types->Inner( at ) )
end function

'' 'm += 1' OVER A TYPE WITH A NUMERIC 'operator cast' AND AN 'operator let' -- no
'' self-operator and no binary one. Measured, fbc-modern 1.20: the cast, the arithmetic in
'' the type 'cast( m ) op value' has, and the 'let' that takes the result:
''
''     int32 vr$3 = _ZN1McviEv( &M1$0 );
''     _ZN1MaSEi( &M1$0, (int32)((int64)vr$3 + 1ll) );
''
'' and 'm -= 2.6' works in double and rounds into the let's long ('fb_D2I'). tiko dropped
'' the statement in silence. The target is addressed once, for the cast and the let both.
'' A UDT value, a byref 'let' parameter and '&=' are left alone.
declare function LowerCompoundViaCast_ _
    ( byref c as Ctx, byval target as Tko.NodeId, byval value as Tko.NodeId, _
      byval op as Tko.TokenKind, byval ut as Tko.TypeId ) as boolean

'' Does the operand reach the chosen member's parameter only by a USER conversion -- the
'' parameter a UDT the operand is not, nor derived from?
private function SelfOpNeedsUserConv_ _
    ( byref c as Ctx, byval want as Tko.SymbolId, byval vt as Tko.TypeId ) as boolean
    if vt = Tko.TYPE_NONE then return false
    dim as Tko.TypeId pu = ParamTypeAt( c, want, 0 )
    if pu = Tko.TYPE_NONE then return false
    pu = c.types->Unqualify( pu )
    if c.types->Kind( pu ) = Tko.TK_REFERENCE then pu = c.types->Unqualify( c.types->Inner( pu ) )
    if c.types->Kind( pu ) <> Tko.TK_UDT then return false
    if vt = pu then return false
    if c.types->BaseDistance( vt, pu ) >= 0 then return false
    return true
end function

function SelfOpMemberCall_ _
    ( byref c as Ctx, byval target as Tko.NodeId, byval value as Tko.NodeId, _
      byval op as Tko.TokenKind, byval tt as Tko.TypeId ) as boolean

    '' ...OR, WITH NO SELF-OPERATOR, THE BINARY ONE Check bound -- see LowerCompoundUserOp_.
    if LowerCompoundUserOp_( c, target, value ) then return true

    dim as Tko.TypeId ut = c.types->Unqualify( tt )
    if c.types->Kind( ut ) <> Tko.TK_UDT then return false
    dim as string opn = SelfOpName_( op )
    if len( opn ) = 0 then return false

    '' An ARRAY argument has an ELEMENT type, not a value type, and it is the element
    '' the parameter is declared with.
    dim as Tko.TypeId aet = ArrayArgElem_( c, value )
    dim as Tko.TypeId vt = c.types->Unqualify( c.info->TypeOf_( value ) )
    if Tko.Check.FixedStringElem( vt, *c.types ) <> Tko.TYPE_NONE then aet = Tko.TYPE_NONE   '' a 'zstring * 4' is a STRING, not an array
    '' A WIDE VALUE may have no Check type at all -- see WideCharOverload_ below.
    dim as boolean wideVal = WideValueForCharMember_( c, value )
    dim as boolean noType = (vt = Tko.TYPE_NONE) andalso (aet = Tko.TYPE_NONE)
    '' ...AND SO MAY A NARROW ONE. A concatenation or an intrinsic's result has no Check
    '' type, and 'dws += "- Leg #" + str( i ) & vbcrlf' declined right here. It is scored
    '' as the STRING it is: fbc calls DWSTRING's '+=( byref ansiStr as string )' for it.
    if noType andalso (wideVal = false) andalso NarrowStrArg_( c, value ) then
        vt = c.types->Builtin( Tko.TY_STRING )
        noType = false
    end if
    if noType andalso (wideVal = false) then return false

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
            '' AN ARRAY PARAMETER TAKES AN ARRAY AND NOTHING ELSE, and its declared
            '' type IS the element's -- so the two are compared element to element
            '' and a mismatch on either side removes the candidate outright.
            dim as boolean pIsArr = ParamIsArray( c, cur, 0 )
            if pIsArr orelse (aet <> Tko.TYPE_NONE) then
                dim as long acost = Tko.Check.CONV_NONE
                if pIsArr andalso (aet <> Tko.TYPE_NONE) andalso _
                   (pt <> Tko.TYPE_NONE) then
                    if c.types->Unqualify( pt ) = aet then
                        acost = Tko.Check.CONV_EXACT
                    end if
                end if
                if acost < best then
                    best = acost
                    want = cur
                    ties = 0
                elseif (acost = best) andalso (acost < Tko.Check.CONV_NONE) then
                    ties += 1
                end if
                cur = os->nextOverload
                continue while
            end if
            if pt <> Tko.TYPE_NONE then
                dim as Tko.TypeId pu = c.types->Unqualify( pt )
                if c.types->Kind( pu ) = Tko.TK_REFERENCE then
                    pu = c.types->Unqualify( c.types->Inner( pu ) )
                end if
                dim as long cost = Tko.Check.CONV_NONE
                if pu = vt then
                    cost = Tko.Check.CONV_EXACT
                elseif vt <> Tko.TYPE_NONE then
                    cost = Tko.Check.ConversionCost( vt, pu, *c.types )
                    '' A FIXED-LENGTH STRING IS COSTED AS THE STRING IT HOLDS: 'a += z' over a 'zstring * 4'
                    '' reaches '+=( byref s as string )', measured -- the array type converted to
                    '' nothing and the statement was not compiled (TKO0994).
                    if cost >= Tko.Check.CONV_NONE then
                        dim as Tko.TypeId fse = Tko.Check.FixedStringElem( vt, *c.types )
                        if fse <> Tko.TYPE_NONE then cost = Tko.Check.ConversionCost( fse, pu, *c.types )
                    end if
                    '' ...AND A UDT PARAMETER THE OPERAND CONVERTS TO BY A USER CONVERSION -- its
                    '' constructor, or the operand's cast. 'n += 123' over CInt96's only
                    '' '+=( byref as CInt96 )' found no candidate at all: the built-in cost has
                    '' no route from an integer to a UDT. Measured, fbc builds a temporary with
                    '' the converting constructor and passes it.
                    if (cost >= Tko.Check.CONV_NONE) andalso (c.types->Kind( pu ) = Tko.TK_UDT) then
                        cost = Tko.Check.StructorUserConvCost( *c.ast, *c.syms, *c.types, *c.names, *c.info, vt, pu )
                    end if
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
    '' A WIDE VALUE takes the wide-character member when the type has one, as fbc does: 'v += " ("
    '' & wstr( n ) & "%)"' over DWSTRING is '_ZN7AFXNOVA8DWSTRINGpLEPw' with the fb_WstrConcatWA
    '' result, where the scoring above can prefer '+=( byref as string )' and then has no
    '' argument to build. PsChart's tooltip percentages were dropped.
    dim as boolean wideChosen = false
    if wideVal then
        dim as Tko.SymbolId wcur = WideCharOverload_( c, UdtMemberNamed_( c, ut, opn ) )
        if wcur <> Tko.SYMBOL_NONE then
            want = wcur
            ties = 0
            wideChosen = true
        end if
    end if
    if want = Tko.SYMBOL_NONE then return LowerCompoundViaCast_( c, target, value, op, ut )
    if ties > 0 then return false

    dim as MirValue self_ = LowerAddr( c, target )
    if self_.kind = cast( ubyte, MV_NONE ) then return false

    dim as MirValue av
    if wideChosen then
        '' The wide characters, for a 'byref as wstring' and a 'wstring ptr' parameter alike.
        if WideOperand_( c, value, av ) = false then return false
    '' A BYDESC ARRAY ARGUMENT travels as a DESCRIPTOR POINTER, whichever way the
    '' parameter was spelled -- the same answer an ordinary call's arguments get.
    elseif ArrayDescArg_( c, value, ParamIsArray( c, want, 0 ), av ) then
    elseif SelfOpNeedsUserConv_( c, want, vt ) then
        '' THE TEMPORARY THE COST ABOVE PROMISED, built as a binary operator's operand is
        '' (UserConvOperand_), and destroyed at the end of the statement.
        dim as long ucSlot = -1
        dim as Tko.TypeId ucType = Tko.TYPE_NONE
        if UserConvOperand_( c, value, ParamTypeAt( c, want, 0 ), av, ucSlot, ucType ) = false then return false
        if ucSlot >= 0 then
            c.udtTemps.Push( cast( ulong, ucSlot ) )
            c.udtTempTypes.Push( cast( ulong, ucType ) )
        end if
        '' A BYVAL parameter takes the object, not its address.
        if ParamIsByref( c, want, 0 ) = false then av = LowerExprLoad( c, av, MT_AGG )
    elseif ParamIsByref( c, want, 0 ) then
        '' A STRING RVALUE HAS NO ADDRESS. 'dws += "- Missing Ticker Symbol." & vbcrlf' over
        '' DWSTRING's '+=( byref ansiStr as string )' asked a literal and a concatenation for
        '' one, and the statement was DROPPED -- tracks' validation messages, AfxNova's
        '' CTextStream error texts. Measured, fbc copies the value into a temporary first:
        ''
        ''     fb_StrAssign( &TMP, -1, "lit", 4, 0 );  _ZN1TpLER8FBSTRING( &V, &TMP )
        ''
        '' -- the arms an ordinary constructor argument takes in lowercallarg.bas.
        dim as Tko.TypeId bpt = ParamTypeAt( c, want, 0 )
        if UStrParamArgTemp_( c, value, bpt, av ) = false then
            '' A FIXED STRING'S TEMPORARY IS COPIED BACK (LOW-13): measured, an operator that writes its
            '' 'byref s as string' changes the 'zstring * 8' it was given -- NarrowRefStrArg_.
            if NarrowParamArgTemp_( c, value, bpt, av ) = false then av = LowerAddr( c, value )
        end if
    else
        av = LowerExpr( c, value )
        '' TO THE PARAMETER'S WIDTH, not the operand's -- the same rule an ordinary
        '' call's arguments follow.
        if av.kind <> cast( ubyte, MV_NONE ) then
            dim as MirType pmt = LowerType( ParamTypeAt( c, want, 0 ), *c.types )
            if (pmt <> MT_VOID) andalso (pmt <> MT_AGG) then
                av = CoerceTy( c, av, pmt, vt)
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



function LowerCompoundViaCast_ _
    ( byref c as Ctx, byval target as Tko.NodeId, byval value as Tko.NodeId, _
      byval op as Tko.TokenKind, byval ut as Tko.TypeId ) as boolean

    if c.types->Kind( ut ) <> Tko.TK_UDT then return false
    dim as Tko.TokenKind bop = Tko.TK_EOF
    select case op
    case Tko.TK_PLUSEQ   : bop = Tko.TK_PLUS
    case Tko.TK_MINUSEQ  : bop = Tko.TK_MINUS
    case Tko.TK_STAREQ   : bop = Tko.TK_STAR
    case Tko.TK_SLASHEQ  : bop = Tko.TK_SLASH
    case Tko.TK_BSLASHEQ : bop = Tko.TK_BACKSLASH
    case Tko.TK_CARETEQ  : bop = Tko.TK_CARET
    case Tko.KW_AND, Tko.KW_OR, Tko.KW_XOR, Tko.KW_IMP, Tko.KW_EQV, _
         Tko.KW_MOD, Tko.KW_SHL, Tko.KW_SHR
        bop = op
    case else
        return false
    end select

    '' EVERY QUESTION BEFORE THE FIRST INSTRUCTION.
    dim as Tko.TypeId vt = c.types->Unqualify( c.info->TypeOf_( value ) )
    if c.types->Kind( vt ) = Tko.TK_REFERENCE then vt = c.types->Unqualify( c.types->Inner( vt ) )
    dim as Tko.SymbolId cs = UserCastNumOverload_( c, ut, vt )   '' the cast closest to the value
    if cs = Tko.SYMBOL_NONE then return false
    dim as Tko.TypeId ct = c.types->Unqualify( c.syms->SymbolAt( cs )->type_ )
    if (vt = Tko.TYPE_NONE) orelse (c.types->Kind( vt ) = Tko.TK_UDT) then return false
    dim as Tko.TypeId rt = Tko.Check.BinaryResult( bop, ct, vt, *c.types )
    if rt = Tko.TYPE_NONE then return false
    dim as MirType wt = LowerType( rt, *c.types )
    if (wt = MT_VOID) orelse (wt = MT_AGG) orelse (wt = MT_PTR) then return false
    dim as FB.Array( of ulong ) letT
    letT.Push( cast( ulong, rt ) )
    dim as Tko.SymbolId ulet = PickCtor( c, StructorOf( c, ut, "let" ), letT )
    if ulet = Tko.SYMBOL_NONE then return false
    if ParamIsByref( c, ulet, 0 ) then return false
    dim as Tko.TypeId pt = ParamTypeAt( c, ulet, 0 )
    dim as MirType pmt = LowerType( pt, *c.types )
    if (pmt = MT_VOID) orelse (pmt = MT_AGG) then return false

    dim as MirValue self_ = LowerAddr( c, target )
    if self_.kind = cast( ubyte, MV_NONE ) then return false
    dim as MirValue cur = EmitMemberCall( c, cs, self_, LowerType( ct, *c.types ) )
    if cur.kind = cast( ubyte, MV_NONE ) then return false
    cur = CoerceTy( c, cur, wt, ct )
    dim as MirValue rhs = LowerExpr( c, value )
    if rhs.kind = cast( ubyte, MV_NONE ) then return false
    rhs = CoerceTy( c, rhs, wt, vt )

    dim as MirValue res
    if bop = Tko.TK_CARET then
        dim as FB.Array( of ulong ) pa
        pa.Push( cast( ulong, cur.kind ) ) : pa.Push( cast( ulong, cur.id ) )
        pa.Push( cast( ulong, rhs.kind ) ) : pa.Push( cast( ulong, rhs.id ) )
        res = EmitRtl( c, RTL_POW, pa )
    elseif (bop = Tko.KW_IMP) orelse (bop = Tko.KW_EQV) then
        res = EmitImpEqv_( c, bop, wt, cur, rhs )
    else
        dim as MirOp mop = BinOpFor( bop, wt, IsUnsignedType( c, rt ) )
        if mop = M_NONE then return false
        dim as MirInst bi
        bi.op = cast( ushort, mop )
        bi.ty = cast( ubyte, wt )
        bi.a = cur
        bi.b = rhs
        res = Emit( c, bi )
    end if
    if res.kind = cast( ubyte, MV_NONE ) then return false

    '' Into the let's parameter as an assignment converts -- rounded, as fbc's 'fb_D2I'.
    dim as MirValue av = CoerceTy( c, res, pmt, rt, pt )
    dim as FB.Array( of ulong ) largs
    largs.Push( cast( ulong, av.kind ) ) : largs.Push( cast( ulong, av.id ) )
    EmitStructorCall( c, ulet, -1, @self_, @largs )
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
        dim as MirValue v = LowerNumArg_( c, an, MT_I64 )
        if v.kind = cast( ubyte, MV_NONE ) then return false
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
