'' lowerswap.bas -- SWAP.
''
'' Split out of lowerstr.bas, which is at its size limit. SWAP lives near the string
'' code because its string forms are most of its complexity, not because it is one.

#include once "lowerctx.bi"

namespace Tko.Mir

using Tko

declare function StrSwapKind_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byref n as longint ) as long

'' A SWAP operand's type.
''
'' Check does not type a POINTER SUBSCRIPT: TypeOf_( pa[i] ) is TYPE_NONE, so
'' 'swap pa[i], pb[i]' declined on its very first line while the array form beside it
'' lowered. The pointee is what the subscript yields, and asking the TARGET for it is
'' the same thing LowerPtrIndex already does to compute the element size.
private function SwapOperandType_ _
    ( byref c as Ctx, byval e as Tko.NodeId ) as Tko.TypeId

    dim as Tko.TypeId t = c.info->TypeOf_( e )
    if t <> Tko.TYPE_NONE then return t
    if e = Tko.NODE_NONE then return Tko.TYPE_NONE
    if c.ast->Kind( e ) <> Tko.N_INDEX then return Tko.TYPE_NONE

    dim as Tko.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, e )].data )]
    if lp->target = Tko.NODE_NONE then return Tko.TYPE_NONE
    dim as Tko.TypeId pt = c.info->TypeOf_( lp->target )
    if pt = Tko.TYPE_NONE then return Tko.TYPE_NONE
    if c.types->Kind( pt ) <> Tko.TK_POINTER then return Tko.TYPE_NONE
    return c.types->Inner( pt )
end function


function LowerSwap( byref c as Ctx, byval id as Tko.NodeId ) as boolean
    dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
    if (sp->a = Tko.NODE_NONE) orelse (sp->b = Tko.NODE_NONE) then return false

    dim as Tko.TypeId t = SwapOperandType_( c, sp->a )
    if t = Tko.TYPE_NONE then return false

    dim as MirValue la = LowerAddr( c, sp->a )
    dim as MirValue lb = LowerAddr( c, sp->b )
    if (la.kind = cast( ubyte, MV_NONE )) orelse (lb.kind = cast( ubyte, MV_NONE )) then
        return false
    end if

    '' THE LENGTH ARGUMENT IS NOT ALWAYS -1. Measured from fbc's own C:
    ''
    ''     fb_StrSwap( &S1, -1, 0, &S2, -1, 0 )        string  x string
    ''     fb_StrSwap( Z1,   5, 0, Z2,   5, 0 )        zstring * 5, both sides
    ''     fb_StrSwap( &S1, -1, 0, Z1,   5, 0 )        MIXED -- each side its own
    ''     fb_WstrSwap( W1, 5, W2, 5 )                 wstring, a DIFFERENT function
    ''
    '' Passing -1 for a fixed-length operand tells the runtime to read a descriptor out
    '' of character data. That was live for the mixed case: a var-length left operand
    '' took this branch and both sides went out as -1.
    dim as longint na, nb_
    dim as long ka = StrSwapKind_( c, t, na )
    dim as long kb = StrSwapKind_( c, SwapOperandType_( c, sp->b ), nb_ )
    if (ka >= 0) andalso (kb >= 0) then
        '' WSTRING has its own entry point and does not mix with the byte forms; fbc
        '' emits something else again for that pairing, so it is declined rather than
        '' guessed at.
        if (ka = 2) <> (kb = 2) then return false
        dim as FB.Array( of ulong ) args
        args.Push( cast( ulong, la.kind ) ) : args.Push( cast( ulong, la.id ) )
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, na ) )
        if ka = 2 then
            args.Push( cast( ulong, lb.kind ) ) : args.Push( cast( ulong, lb.id ) )
            args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, nb_ ) )
            EmitRtl( c, RTL_WSTR_SWAP, args )
            return true
        end if
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
        args.Push( cast( ulong, lb.kind ) ) : args.Push( cast( ulong, lb.id ) )
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, nb_ ) )
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
        EmitRtl( c, RTL_STR_SWAP, args )
        return true
    end if

    '' THE OPERANDS MAY DIFFER IN TYPE. fbc allows 'swap' between a long and a double
    '' and CONVERTS across the assignments -- the temporary is typed to the LEFT operand
    '' and each store converts into its destination:
    ''
    ''     int32 TMP = A;   A = fb_D2I( B );   B = (double)TMP;
    ''
    '' Loading both sides through one type instead reinterprets the bits, which lowers
    '' cleanly, verifies, and is wrong. This was exactly that bug for one commit.
    dim as Tko.TypeId rt = SwapOperandType_( c, sp->b )
    if rt = Tko.TYPE_NONE then return false
    dim as MirType mtl = LowerType( t, *c.types )
    dim as MirType mtr = LowerType( rt, *c.types )
    if (mtl = MT_VOID) orelse (mtr = MT_VOID) then return false
    '' An aggregate has no single load/store, so it is declined rather than
    '' half-swapped. Strings are the aggregate that matters and took the path above.
    '' TWO AGGREGATES of the same size swap as BYTES: fbc emits
    '' 'fb_MemSwap( &U1, &U2, 16 )' for a pair of 16-byte UDTs. Different sizes are
    '' not a swap fbc accepts, so they still decline.
    if (mtl = MT_AGG) andalso (mtr = MT_AGG) then
        '' A UDT's size lives in the LAYOUT TABLE, not in TypeContext.Layout -- the
        '' same two-step LocalFor makes when it sizes an aggregate slot. Asking the
        '' type alone gives 0 and the swap silently declined.
        dim as long sza = c.types->Layout( t ).size
        dim as long szb = c.types->Layout( rt ).size
        dim as long uia = c.udts->Find( t )
        if uia >= 0 then sza = c.udts->udts[uia].size
        dim as long uib = c.udts->Find( rt )
        if uib >= 0 then szb = c.udts->udts[uib].size
        if (sza > 0) andalso (sza = szb) then
            dim as FB.Array( of ulong ) margs
            margs.Push( cast( ulong, la.kind ) ) : margs.Push( cast( ulong, la.id ) )
            margs.Push( cast( ulong, lb.kind ) ) : margs.Push( cast( ulong, lb.id ) )
            margs.Push( cast( ulong, MV_CONST_INT ) ) : margs.Push( cast( ulong, sza ) )
            EmitRtl( c, RTL_MEM_SWAP, margs )
            return true
        end if
    end if
    if (mtl = MT_AGG) orelse (mtr = MT_AGG) then return false

    dim as long slot = NewTempLocal( c, mtl, c.types->Layout( t ).size )
    dim as MirValue tmp
    tmp.kind = cast( ubyte, MV_LOCAL )
    tmp.ty = cast( ubyte, MT_PTR )
    tmp.id = slot

    StoreThrough( c, tmp, LowerExprLoad( c, la, mtl ) )
    StoreThrough( c, la, Coerce( c, LowerExprLoad( c, lb, mtr ), mtl ) )
    StoreThrough( c, lb, Coerce( c, LowerExprLoad( c, tmp, mtl ), mtr ) )
    return true
end function

'' Zeroes a 24-byte string descriptor.
''
'' fbc emits '__builtin_memset( &A, 0, 24 )' for a string local with no initialiser.
'' MIR has no memset, so this is three i64 stores -- which mem2reg folds away for a
'' local that is written before it is read anyway.
''
'' This is NOT cosmetic. A string local always registers an fb_StrDelete for its scope
'' exit, so a descriptor that was never written would hand the runtime a wild pointer
'' to free.
sub ZeroStrDescriptor( byref c as Ctx, byref dst as MirValue )
    for off as long = 0 to 16 step 8
        dim as MirInst fa
        fa.op = cast( ushort, M_FIELD_ADDR )
        fa.ty = cast( ubyte, MT_PTR )
        fa.a = dst
        fa.imm = off
        dim as MirValue p = Emit( c, fa )
        dim as MirValue z
        z.kind = cast( ubyte, MV_CONST_INT )
        z.ty = cast( ubyte, MT_I64 )
        z.id = 0
        dim as MirInst st_
        st_.op = cast( ushort, M_STORE )
        st_.ty = cast( ubyte, MT_VOID )
        st_.a = p
        st_.b = z
        Emit( c, st_ )
    next
end sub

'' 'T( args )' -- A TYPE CONSTRUCTOR USED AS AN EXPRESSION.
''
'' 'return TimeSpan( this.m_ticks )' is how the chrono and finance headers build almost
'' every value they return, and there was no case for it: the callee is a TYPE, not a
'' procedure, so the ordinary call path found nothing to call.
''
'' A temporary is built and constructed, and its VALUE is what comes back -- an
'' aggregate value is first class in this IR, so nothing new is needed to carry it.
''
'' fbc constructs STRAIGHT INTO THE RESULT SLOT when the expression is the whole of a
'' 'return' -- '_ZN1TC1Ex( &fb$result$1, N$1 ); return fb$result$1;' -- which is one
'' copy fewer. Same value; the copy is recorded here rather than hidden.
function LowerTypeCtorExpr_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    dim as Tko.TypeId t = TypeCtorTypeOf_( c, id )
    if t = Tko.TYPE_NONE then return false
    dim as Tko.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]

    dim as long slot = NewTempLocal( c, MT_AGG, SizeOfType( c, t ) )
    if slot < 0 then return false
    if EmitTypeCtorInto_( c, t, slot, cp ) = false then return false

    dim as MirValue addr
    addr.kind = cast( ubyte, MV_LOCAL )
    addr.ty = cast( ubyte, MT_PTR )
    addr.id = slot
    outv = LowerExprLoad( c, addr, MT_AGG )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

'' 'T( args )' AS AN ADDRESSABLE TEMPORARY -- what 'P( 3 ).v' and 'DateTime( y, m, d
'' ).AddMonths( 0 )' need. The value form loads the aggregate; a member access needs the
'' storage it was built in.
''
'' Without this a member on a CONSTRUCTOR temporary declined while the same member on a
'' FUNCTION's returned temporary worked -- the call-result path above it asks for a
'' SYM_PROC, and a type-constructor call binds to the UDT instead. fb/chrono.bi writes
'' most of its assertions this way.
function LowerTypeCtorTempAddr_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    dim as Tko.TypeId t = TypeCtorTypeOf_( c, id )
    if t = Tko.TYPE_NONE then return false
    dim as Tko.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]

    dim as long slot = NewTempLocal( c, MT_AGG, SizeOfType( c, t ) )
    if slot < 0 then return false
    if EmitTypeCtorInto_( c, t, slot, cp ) = false then return false
    outv.kind = cast( ubyte, MV_LOCAL )
    outv.ty = cast( ubyte, MT_PTR )
    outv.id = slot
    return true
end function

'' The TYPE a 'T( args )' expression builds, or nothing when this is not one. A call
'' whose callee is bound to a UDT SYMBOL rather than to a procedure.
function TypeCtorTypeOf_( byref c as Ctx, byval id as Tko.NodeId ) as Tko.TypeId
    if c.ast->Kind( id ) <> Tko.N_CALL then return Tko.TYPE_NONE
    dim as Tko.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if cp->target = Tko.NODE_NONE then return Tko.TYPE_NONE
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( c.info->RefOf( cp->target ) )
    if s = 0 then return Tko.TYPE_NONE
    if s->kind <> cast( ubyte, Tko.SYM_UDT ) then return Tko.TYPE_NONE
    if s->type_ = Tko.TYPE_NONE then return Tko.TYPE_NONE
    if c.types->Kind( s->type_ ) <> Tko.TK_UDT then return Tko.TYPE_NONE
    return s->type_
end function


'' A PROPERTY ACCESS -- 't.V' with no parentheses, and 't.V = x'.
''
'' Both are CALLS. fbc emits '_ZN1T8V__get__Ev( &T )' and '_ZN1T8V__set__Ei( &T, 5 )',
'' and the mangler here already knew the two suffixes -- it was lowering that had no
'' case, so a bare property read declined and a property WRITE went to the ordinary
'' store path, which looked for a field of that name, found a procedure and declined
'' too.
''
'' 't.V( )' with parentheses already worked, because that is an ordinary call. The
'' whole gap is the spelling without them, which is how properties are actually used --
'' 'd1.Year', 'd1.Month', 'd1.Day' in one line of the finance headers.
''
'' WHICH OVERLOAD IS DECIDED BY ARITY, not by the name: the getter takes none and the
'' setter one, they share a symbol chain, and taking the head of it picks whichever was
'' declared first.
function PropertyAt_ _
    ( byref c as Ctx, byval node as Tko.NodeId, byval want as long, _
      byref self_ as MirValue ) as Tko.SymbolId

    if c.ast->Kind( node ) <> Tko.N_MEMBER then return Tko.SYMBOL_NONE
    dim as Tko.SymbolId sid = c.info->RefOf( node )
    if sid = Tko.SYMBOL_NONE then return Tko.SYMBOL_NONE

    '' The whole chain, because the getter and the setter share one symbol.
    dim as Tko.SymbolId cur = sid
    dim as Tko.SymbolId want_ = Tko.SYMBOL_NONE
    while cur <> Tko.SYMBOL_NONE
        dim as Tko.Symbol ptr s = c.syms->SymbolAt( cur )
        if s = 0 then exit while
        if s->kind = cast( ubyte, Tko.SYM_PROC ) then
            dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
            if (pn <> Tko.NODE_NONE) andalso (c.ast->Kind( pn ) = Tko.N_PROC) then
                dim as Tko.StmtPayload ptr pp = StmtOf( c, pn )
                if pp->op = cast( ushort, Tko.KW_PROPERTY ) then
                    dim as long np = 0
                    for i as long = 0 to pp->count - 1
                        dim as Tko.NodeId prm = _
                            cast( Tko.NodeId, c.ast->children[pp->first + i] )
                        if c.ast->Kind( prm ) = Tko.N_PARAM then np += 1
                    next
                    if np = want then
                        want_ = cur
                        exit while
                    end if
                end if
            end if
        end if
        cur = s->nextOverload
    wend
    if want_ = Tko.SYMBOL_NONE then return Tko.SYMBOL_NONE

    '' The RECEIVER is the member's base, by address -- 'p.V' through a pointer takes
    '' the pointer's value instead, exactly as a field access does.
    dim as Tko.BinaryPayload ptr mp = _
        @c.ast->binaries[cast( long, c.ast->nodes[cast( long, node )].data )]
    dim as Tko.TypeId bt = c.info->TypeOf_( mp->lhs )
    if (bt <> Tko.TYPE_NONE) andalso (c.types->Kind( bt ) = Tko.TK_POINTER) then
        self_ = LowerExpr( c, mp->lhs )
    else
        self_ = LowerAddr( c, mp->lhs )
    end if
    if self_.kind = cast( ubyte, MV_NONE ) then return Tko.SYMBOL_NONE
    return want_
end function

'' A USER-DEFINED BINARY OPERATOR, called. Check chose the overload and recorded it on
'' the expression node; what is left is passing the operands the way the parameters
'' want them -- BYREF is the usual spelling for a value type, and an operand with no
'' address of its own gets a temporary exactly as a call argument does.
''
'' A MEMBER operator takes the left operand as its RECEIVER and the right as its only
'' argument; a global one takes both.
declare function OperandValue_ _
    ( byref c as Ctx, byval e as Tko.NodeId, byval pt as Tko.TypeId, _
      byval byref_ as boolean, byref args as FB.Array( of ulong ) ) as boolean

function LowerUserBinaryOp_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byval bp as Tko.BinaryPayload ptr, _
      byval mt as MirType, byref outv as MirValue ) as boolean

    dim as Tko.SymbolId op = c.info->RefOf( id )
    if op = Tko.SYMBOL_NONE then return false
    dim as Tko.Symbol ptr os = c.syms->SymbolAt( op )
    if os = 0 then return false
    if os->kind <> cast( ubyte, Tko.SYM_PROC ) then return false
    dim as Tko.NodeId pn = cast( Tko.NodeId, os->payload )
    if pn = Tko.NODE_NONE then return false
    if c.ast->Kind( pn ) <> Tko.N_PROC then return false
    dim as Tko.StmtPayload ptr pp = StmtOf( c, pn )
    if pp->op <> cast( ushort, Tko.KW_OPERATOR ) then return false

    '' The parameters, in order, with their byref-ness.
    dim as FB.Array( of ulong ) ptypes
    dim as FB.Array( of ulong ) prefs
    for i as long = 0 to pp->count - 1
        dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp->first + i] )
        if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
        ptypes.Push( cast( ulong, c.info->TypeOf_( StmtOf( c, prm )->a ) ) )
        dim as ulong isRef = 0
        if (c.ast->nodes[cast( long, prm )].flags and Tko.NF_BYREF) <> 0 then isRef = 1
        prefs.Push( isRef )
    next
    if (ptypes.Count <> 1) andalso (ptypes.Count <> 2) then return false

    dim as FB.Array( of ulong ) args
    dim as long firstArg = 0
    if ptypes.Count = 1 then
        '' The RECEIVER is the left operand, by address.
        dim as MirValue self_ = LowerAddr( c, bp->lhs )
        if self_.kind = cast( ubyte, MV_NONE ) then return false
        args.Push( cast( ulong, self_.kind ) ) : args.Push( cast( ulong, self_.id ) )
    else
        if OperandValue_( c, bp->lhs, cast( Tko.TypeId, ptypes[0] ), _
                          (prefs[0] <> 0), args ) = false then return false
        firstArg = 1
    end if
    if OperandValue_( c, bp->rhs, cast( Tko.TypeId, ptypes[firstArg] ), _
                      (prefs[firstArg] <> 0), args ) = false then return false

    dim as MirType rmt = mt
    if os->type_ <> Tko.TYPE_NONE then rmt = LowerType( os->type_, *c.types )
    '' A STRING RESULT IS A DESCRIPTOR POINTER, which is what the function's own
    '' declaration says: 'FBSTRING* F( void )'. Reading it as the string's MIR type put
    '' an 'agg' result on a call to a function declared to return a pointer.
    if IsStringType( c, os->type_ ) then rmt = MT_PTR
    '' A BYREF RETURN IS A POINTER, which is what the DECLARATION says too. Reading it
    '' as the referent's own MIR type put an i32 result on a function declared to return
    '' a pointer -- 'operator *' over a smart pointer is byref by construction.
    if (c.ast->nodes[cast( long, pn )].flags and Tko.NF_BYREF) <> 0 then rmt = MT_PTR
    outv = EmitDirectCall_( c, op, rmt, args )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

'' A USER-DEFINED UNARY OPERATOR, called. A GLOBAL one takes the operand as its only
'' parameter; a MEMBER one takes it as the receiver and nothing else.
function LowerUserUnaryOp_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byval up as Tko.UnaryPayload ptr, _
      byval mt as MirType, byref outv as MirValue ) as boolean

    dim as Tko.SymbolId op = c.info->RefOf( id )
    if op = Tko.SYMBOL_NONE then return false
    dim as Tko.Symbol ptr os = c.syms->SymbolAt( op )
    if os = 0 then return false
    if os->kind <> cast( ubyte, Tko.SYM_PROC ) then return false
    dim as Tko.NodeId pn = cast( Tko.NodeId, os->payload )
    if pn = Tko.NODE_NONE then return false
    if c.ast->Kind( pn ) <> Tko.N_PROC then return false
    dim as Tko.StmtPayload ptr pp = StmtOf( c, pn )
    if pp->op <> cast( ushort, Tko.KW_OPERATOR ) then return false

    dim as Tko.TypeId pt = Tko.TYPE_NONE
    dim as boolean isRef = false
    dim as long np = 0
    for i as long = 0 to pp->count - 1
        dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp->first + i] )
        if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
        if np = 0 then
            pt = c.info->TypeOf_( StmtOf( c, prm )->a )
            isRef = ((c.ast->nodes[cast( long, prm )].flags and Tko.NF_BYREF) <> 0)
        end if
        np += 1
    next

    dim as MirType rmt = mt
    if os->type_ <> Tko.TYPE_NONE then rmt = LowerType( os->type_, *c.types )
    '' A STRING RESULT IS A DESCRIPTOR POINTER, which is what the function's own
    '' declaration says: 'FBSTRING* F( void )'. Reading it as the string's MIR type put
    '' an 'agg' result on a call to a function declared to return a pointer.
    if IsStringType( c, os->type_ ) then rmt = MT_PTR
    '' A BYREF RETURN IS A POINTER, which is what the DECLARATION says too. Reading it
    '' as the referent's own MIR type put an i32 result on a function declared to return
    '' a pointer -- 'operator *' over a smart pointer is byref by construction.
    if (c.ast->nodes[cast( long, pn )].flags and Tko.NF_BYREF) <> 0 then rmt = MT_PTR

    if np = 0 then
        dim as MirValue self_ = LowerAddr( c, up->operand )
        if self_.kind = cast( ubyte, MV_NONE ) then return false
        outv = EmitMemberCall( c, op, self_, rmt )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if
    if np <> 1 then return false

    dim as FB.Array( of ulong ) args
    if OperandValue_( c, up->operand, pt, isRef, args ) = false then return false
    outv = EmitDirectCall_( c, op, rmt, args )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

'' One operator operand, pushed as the parameter wants it.
private function OperandValue_ _
    ( byref c as Ctx, byval e as Tko.NodeId, byval pt as Tko.TypeId, _
      byval byref_ as boolean, byref args as FB.Array( of ulong ) ) as boolean

    dim as MirValue v
    if byref_ then
        v = LowerAddr( c, e )
        if v.kind = cast( ubyte, MV_NONE ) then
            '' An operand with no address -- another operator's result -- gets a
            '' temporary, the same answer a byref call argument gets.
            dim as MirValue rv = LowerExpr( c, e )
            if rv.kind = cast( ubyte, MV_NONE ) then return false
            dim as MirType pmt = LowerType( pt, *c.types )
            if pmt = MT_VOID then return false
            dim as long sz = c.types->Layout( pt ).size
            if pmt = MT_AGG then sz = SizeOfType( c, pt )
            dim as long slot = NewTempLocal( c, pmt, sz )
            if slot < 0 then return false
            dim as MirValue tmp
            tmp.kind = cast( ubyte, MV_LOCAL )
            tmp.ty = cast( ubyte, MT_PTR )
            tmp.id = slot
            if pmt <> MT_AGG then rv = Coerce( c, rv, pmt, IsUnsignedType( c, pt ) )
            StoreThrough( c, tmp, rv )
            v = tmp
        end if
    else
        v = LowerExpr( c, e )
        if v.kind = cast( ubyte, MV_NONE ) then return false
        dim as MirType pmt = LowerType( pt, *c.types )
        if (pmt <> MT_VOID) andalso (pmt <> MT_AGG) then
            v = Coerce( c, v, pmt, IsUnsignedType( c, pt ) )
        end if
    end if
    if v.kind = cast( ubyte, MV_NONE ) then return false
    args.Push( cast( ulong, v.kind ) ) : args.Push( cast( ulong, v.id ) )
    return true
end function

'' 't.V' as a value: the GETTER, called on the base.
function LowerPropertyGet_ _
    ( byref c as Ctx, byval node as Tko.NodeId, byref outv as MirValue ) as boolean
    dim as MirValue self_
    dim as Tko.SymbolId g = PropertyAt_( c, node, 0, self_ )
    if g = Tko.SYMBOL_NONE then return false
    dim as Tko.Symbol ptr gs = c.syms->SymbolAt( g )
    if gs = 0 then return false
    outv = EmitMemberCall( c, g, self_, LowerType( gs->type_, *c.types ) )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

'' 't.V = x': the SETTER, called with the value after the receiver.
function LowerPropertySet_ _
    ( byref c as Ctx, byval target as Tko.NodeId, byval value as Tko.NodeId ) as boolean
    dim as MirValue self_
    dim as Tko.SymbolId sset = PropertyAt_( c, target, 1, self_ )
    if sset = Tko.SYMBOL_NONE then return false

    '' The parameter's type, so the value is coerced the way the callee expects.
    dim as Tko.Symbol ptr ss = c.syms->SymbolAt( sset )
    if ss = 0 then return false
    dim as Tko.NodeId pn = cast( Tko.NodeId, ss->payload )
    if pn = Tko.NODE_NONE then return false
    dim as Tko.StmtPayload ptr pp = StmtOf( c, pn )
    dim as Tko.TypeId pt = Tko.TYPE_NONE
    for i as long = 0 to pp->count - 1
        dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp->first + i] )
        if c.ast->Kind( prm ) = Tko.N_PARAM then
            pt = c.info->TypeOf_( StmtOf( c, prm )->a )
            exit for
        end if
    next

    dim as MirValue v = LowerExpr( c, value )
    if v.kind = cast( ubyte, MV_NONE ) then return false
    if pt <> Tko.TYPE_NONE then
        v = Coerce( c, v, LowerType( pt, *c.types ), IsUnsignedType( c, pt ) )
        if v.kind = cast( ubyte, MV_NONE ) then return false
    end if

    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, v.kind ) ) : args.Push( cast( ulong, v.id ) )
    EmitStructorCall( c, sset, -1, @self_, @args )
    return true
end function

end namespace
