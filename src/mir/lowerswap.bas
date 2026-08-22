'' lowerswap.bas -- SWAP.
''
'' Split out of lowerstr.bas, which is at its size limit. SWAP lives near the string
'' code because its string forms are most of its complexity, not because it is one.

#include once "lowerctx.bi"

namespace Fbx.Mir

using Fbx

declare function StrSwapKind_ _
    ( byref c as Ctx, byval t as Fbx.TypeId, byref n as longint ) as long

'' A SWAP operand's type.
''
'' Check does not type a POINTER SUBSCRIPT: TypeOf_( pa[i] ) is TYPE_NONE, so
'' 'swap pa[i], pb[i]' declined on its very first line while the array form beside it
'' lowered. The pointee is what the subscript yields, and asking the TARGET for it is
'' the same thing LowerPtrIndex already does to compute the element size.
private function SwapOperandType_ _
    ( byref c as Ctx, byval e as Fbx.NodeId ) as Fbx.TypeId

    dim as Fbx.TypeId t = c.info->TypeOf_( e )
    if t <> Fbx.TYPE_NONE then return t
    if e = Fbx.NODE_NONE then return Fbx.TYPE_NONE
    if c.ast->Kind( e ) <> Fbx.N_INDEX then return Fbx.TYPE_NONE

    dim as Fbx.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, e )].data )]
    if lp->target = Fbx.NODE_NONE then return Fbx.TYPE_NONE
    dim as Fbx.TypeId pt = c.info->TypeOf_( lp->target )
    if pt = Fbx.TYPE_NONE then return Fbx.TYPE_NONE
    if c.types->Kind( pt ) <> Fbx.TK_POINTER then return Fbx.TYPE_NONE
    return c.types->Inner( pt )
end function


function LowerSwap( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
    if (sp->a = Fbx.NODE_NONE) orelse (sp->b = Fbx.NODE_NONE) then return false

    dim as Fbx.TypeId t = SwapOperandType_( c, sp->a )
    if t = Fbx.TYPE_NONE then return false

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
    dim as Fbx.TypeId rt = SwapOperandType_( c, sp->b )
    if rt = Fbx.TYPE_NONE then return false
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
    ( byref c as Ctx, byval node as Fbx.NodeId, byval want as long, _
      byref self_ as MirValue ) as Fbx.SymbolId

    if c.ast->Kind( node ) <> Fbx.N_MEMBER then return Fbx.SYMBOL_NONE
    dim as Fbx.SymbolId sid = c.info->RefOf( node )
    if sid = Fbx.SYMBOL_NONE then return Fbx.SYMBOL_NONE

    '' The whole chain, because the getter and the setter share one symbol.
    dim as Fbx.SymbolId cur = sid
    dim as Fbx.SymbolId want_ = Fbx.SYMBOL_NONE
    while cur <> Fbx.SYMBOL_NONE
        dim as Fbx.Symbol ptr s = c.syms->SymbolAt( cur )
        if s = 0 then exit while
        if s->kind = cast( ubyte, Fbx.SYM_PROC ) then
            dim as Fbx.NodeId pn = cast( Fbx.NodeId, s->payload )
            if (pn <> Fbx.NODE_NONE) andalso (c.ast->Kind( pn ) = Fbx.N_PROC) then
                dim as Fbx.StmtPayload ptr pp = StmtOf( c, pn )
                if pp->op = cast( ushort, Fbx.KW_PROPERTY ) then
                    dim as long np = 0
                    for i as long = 0 to pp->count - 1
                        dim as Fbx.NodeId prm = _
                            cast( Fbx.NodeId, c.ast->children[pp->first + i] )
                        if c.ast->Kind( prm ) = Fbx.N_PARAM then np += 1
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
    if want_ = Fbx.SYMBOL_NONE then return Fbx.SYMBOL_NONE

    '' The RECEIVER is the member's base, by address -- 'p.V' through a pointer takes
    '' the pointer's value instead, exactly as a field access does.
    dim as Fbx.BinaryPayload ptr mp = _
        @c.ast->binaries[cast( long, c.ast->nodes[cast( long, node )].data )]
    dim as Fbx.TypeId bt = c.info->TypeOf_( mp->lhs )
    if (bt <> Fbx.TYPE_NONE) andalso (c.types->Kind( bt ) = Fbx.TK_POINTER) then
        self_ = LowerExpr( c, mp->lhs )
    else
        self_ = LowerAddr( c, mp->lhs )
    end if
    if self_.kind = cast( ubyte, MV_NONE ) then return Fbx.SYMBOL_NONE
    return want_
end function

'' 't.V' as a value: the GETTER, called on the base.
function LowerPropertyGet_ _
    ( byref c as Ctx, byval node as Fbx.NodeId, byref outv as MirValue ) as boolean
    dim as MirValue self_
    dim as Fbx.SymbolId g = PropertyAt_( c, node, 0, self_ )
    if g = Fbx.SYMBOL_NONE then return false
    dim as Fbx.Symbol ptr gs = c.syms->SymbolAt( g )
    if gs = 0 then return false
    outv = EmitMemberCall( c, g, self_, LowerType( gs->type_, *c.types ) )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

'' 't.V = x': the SETTER, called with the value after the receiver.
function LowerPropertySet_ _
    ( byref c as Ctx, byval target as Fbx.NodeId, byval value as Fbx.NodeId ) as boolean
    dim as MirValue self_
    dim as Fbx.SymbolId sset = PropertyAt_( c, target, 1, self_ )
    if sset = Fbx.SYMBOL_NONE then return false

    '' The parameter's type, so the value is coerced the way the callee expects.
    dim as Fbx.Symbol ptr ss = c.syms->SymbolAt( sset )
    if ss = 0 then return false
    dim as Fbx.NodeId pn = cast( Fbx.NodeId, ss->payload )
    if pn = Fbx.NODE_NONE then return false
    dim as Fbx.StmtPayload ptr pp = StmtOf( c, pn )
    dim as Fbx.TypeId pt = Fbx.TYPE_NONE
    for i as long = 0 to pp->count - 1
        dim as Fbx.NodeId prm = cast( Fbx.NodeId, c.ast->children[pp->first + i] )
        if c.ast->Kind( prm ) = Fbx.N_PARAM then
            pt = c.info->TypeOf_( StmtOf( c, prm )->a )
            exit for
        end if
    next

    dim as MirValue v = LowerExpr( c, value )
    if v.kind = cast( ubyte, MV_NONE ) then return false
    if pt <> Fbx.TYPE_NONE then
        v = Coerce( c, v, LowerType( pt, *c.types ), IsUnsignedType( c, pt ) )
        if v.kind = cast( ubyte, MV_NONE ) then return false
    end if

    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, v.kind ) ) : args.Push( cast( ulong, v.id ) )
    EmitStructorCall( c, sset, -1, @self_, @args )
    return true
end function

end namespace
