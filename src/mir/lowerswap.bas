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

end namespace
