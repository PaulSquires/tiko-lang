'' lowerarr.bas -- addresses: array indexing, and LowerAddr itself.
''
'' The address of a(i, j) is
''
''     base + SUM( index_k * stride_k )  -  SUM( lbound_k * stride_k )
''
'' row-major, so the LAST dimension has stride elemSize and each earlier one is scaled by
'' the element counts of every dimension after it. The second sum is a constant, and fbc
'' folds it into a single bias -- 'dim as long b(1 to 3, 1 to 4)' indexed b(i,i) becomes
''
''     *(int32*)( (int64)B$1 + ((((int64)I$1 << 2) + (int64)I$1) << 2) + -20ll )
''
'' which is base + 20i - 20: stride 16 for the first dimension, 4 for the second, and a
'' bias of 1*16 + 1*4 = 20.

#include once "mir/lowerctx.bi"

namespace Fbx.Mir

declare function ArrayStrides _
    ( byref c as Ctx, byval t as Fbx.TypeId, byref strides as FB.Array( of longint ), _
      byref bias as longint ) as boolean

'' The ADDRESS of an assignable expression, or an undef value when this slice cannot
'' produce one (a member, an index, a dereference).
function LowerAddr _
    ( byref c as Ctx, byval id as Fbx.NodeId ) as MirValue

    dim as MirValue v
    if id = Fbx.NODE_NONE then return v

    '' A QUALIFIED NAME -- 'ns.counter' -- is bound by Resolve to the symbol inside the
    '' namespace, so its address is that symbol's storage. It is NOT a member access on
    '' a value and has no base to compute from.
    ''
    '' Without this the resolve fix made 'ns.counter = 2' stop being counted as declined
    '' while still emitting no store: the statement silently did nothing, which is worse
    '' than the honest decline it replaced.
    if c.ast->Kind( id ) = Fbx.N_MEMBER then
        dim as Fbx.SymbolId qsid = c.info->RefOf( id )
        if qsid <> Fbx.SYMBOL_NONE then
            dim as Fbx.Symbol ptr qs = c.syms->SymbolAt( qsid )
            if qs <> 0 then
                if qs->kind = cast( ubyte, Fbx.SYM_VARIABLE ) then return AddrOfVar( c, qsid )
            end if
        end if
    end if

    '' 'x.f' is the base's address plus a CONSTANT offset. The offset comes from the
    '' measured layout, and Check already bound the member to its field symbol, so
    '' nothing is looked up twice.
    if c.ast->Kind( id ) = Fbx.N_MEMBER then
        dim as Fbx.BinaryPayload ptr mp = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        dim as Fbx.TypeId bt = c.info->TypeOf_( mp->lhs )
        dim as MirValue base_
        if (bt <> Fbx.TYPE_NONE) andalso (c.types->Kind( bt ) = Fbx.TK_POINTER) then
            '' Through a pointer the base is the VALUE, not its slot.
            base_ = LowerExpr( c, mp->lhs )
            bt = c.types->Inner( bt )
        else
            base_ = LowerAddr( c, mp->lhs )
        end if
        if base_.kind = cast( ubyte, MV_NONE ) then return v
        dim as Fbx.SymbolId fsym = c.info->RefOf( id )
        dim as Fbx.Symbol ptr fs = c.syms->SymbolAt( fsym )
        if fs = 0 then return v

        '' A BITFIELD HAS NO ADDRESS OF ITS OWN. Its declared type sizes the storage
        '' UNIT, not the field, so handing back the unit's address would let an
        '' ordinary load or store read and write every field packed beside it. The
        '' layout is not packed yet either -- tools/gen/check-udt.sh measures that gap
        '' on three shapes -- so this declines rather than emitting an access that
        '' would be wrong twice over.
        if (fs->flags and Fbx.SYMF_BITFIELD) <> 0 then return v

        dim as boolean found = false
        dim as long off = c.udts->FieldOffset( bt, fs->name, found )
        if found = false then return v
        dim as MirInst ins
        ins.op = cast( ushort, M_FIELD_ADDR )
        ins.ty = cast( ubyte, MT_PTR )
        ins.a = base_
        ins.imm = off
        return Emit( c, ins )
    end if

    '' Parentheses are kept in the tree for diagnostics, so an address has to see through
    '' them: '(*p).M( )' is a PAREN around a deref, and stopping at the paren lost the
    '' receiver.
    if c.ast->Kind( id ) = Fbx.N_PAREN then
        dim as Fbx.ListPayload ptr pp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
        if pp->count = 1 then
            return LowerAddr( c, cast( Fbx.NodeId, c.ast->children[pp->first] ) )
        end if
        return v
    end if

    '' The address of '*p' IS p. Without this '(*p).M( )' had no receiver to pass, and
    '' 'sub P( byref x as T )' -- which lowering sees as a dereference -- had no address
    '' to store through.
    if c.ast->Kind( id ) = Fbx.N_DEREF then
        dim as Fbx.UnaryPayload ptr dp = _
            @c.ast->unaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        return LowerExpr( c, dp->operand )
    end if

    '' A subscript is spelled as a call, so it is recognised by the callee's TYPE.
    if IsArrayIndex( c, id ) then return LowerArrayIndex( c, id )

    if c.ast->Kind( id ) <> Fbx.N_IDENT then return v
    dim as Fbx.SymbolId sid = c.info->RefOf( id )
    if sid = Fbx.SYMBOL_NONE then return v
    return AddrOfVar( c, sid )
end function

'' Whether an N_CALL is really a subscript: FreeBASIC spells indexing and calling the
'' same way, so the callee's TYPE is what tells them apart.
function IsArrayIndex( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    if c.ast->Kind( id ) <> Fbx.N_CALL then return false
    '' N_CALL is a LIST node -- callee in 'target', arguments in the child pool -- not a
    '' statement payload. Reading it as one is the payload-pool mistake this codebase has
    '' now made four times; the rule is to check how a node is CONSTRUCTED, not what its
    '' name suggests.
    dim as Fbx.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if cp->target = Fbx.NODE_NONE then return false
    dim as Fbx.TypeId t = c.info->TypeOf_( cp->target )
    if t = Fbx.TYPE_NONE then return false
    return (c.types->Kind( t ) = Fbx.TK_ARRAY)
end function

'' The ADDRESS of one element.
function LowerArrayIndex( byref c as Ctx, byval id as Fbx.NodeId ) as MirValue
    dim as MirValue none_
    dim as Fbx.ListPayload ptr sp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    dim as Fbx.TypeId at = c.info->TypeOf_( sp->target )

    dim as FB.Array( of longint ) strides
    dim as longint bias
    if ArrayStrides( c, at, strides, bias ) = false then return none_
    '' A subscript count that does not match the rank is an error the checker should
    '' report; lowering something with the wrong number of indices would compute an
    '' address from whichever dimensions happened to line up.
    if sp->count <> strides.Count then return none_

    dim as MirValue base_ = LowerAddr( c, sp->target )
    if base_.kind = cast( ubyte, MV_NONE ) then return none_

    '' Offsets are computed at pointer width, so a 32-bit index does not truncate the
    '' product on a large array.
    dim as MirType offTy = MT_I64
    if c.types->target.pointerBits = 32 then offTy = MT_I32

    dim as MirValue acc
    for k as long = 0 to sp->count - 1
        dim as Fbx.NodeId ix = cast( Fbx.NodeId, c.ast->children[sp->first + k] )
        dim as MirValue iv = LowerExpr( c, ix )
        if iv.kind = cast( ubyte, MV_NONE ) then return none_
        iv = Coerce( c, iv, offTy )

        '' A stride of 1 needs no multiply, which is most of the single-dimension cases.
        dim as MirValue term = iv
        if strides[k] <> 1 then
            dim as MirInst mul
            mul.op = cast( ushort, M_MUL )
            mul.ty = cast( ubyte, offTy )
            mul.a = iv
            mul.b = ConstInt( c, strides[k], offTy )
            term = Emit( c, mul )
        end if

        if acc.kind = cast( ubyte, MV_NONE ) then
            acc = term
        else
            dim as MirInst add_
            add_.op = cast( ushort, M_ADD )
            add_.ty = cast( ubyte, offTy )
            add_.a = acc
            add_.b = term
            acc = Emit( c, add_ )
        end if
    next
    if acc.kind = cast( ubyte, MV_NONE ) then return none_

    '' The lbound bias is one constant for the whole subscript, subtracted once.
    if bias <> 0 then
        dim as MirInst sub_
        sub_.op = cast( ushort, M_SUB )
        sub_.ty = cast( ubyte, offTy )
        sub_.a = acc
        sub_.b = ConstInt( c, bias, offTy )
        acc = Emit( c, sub_ )
    end if

    dim as MirInst pa
    pa.op = cast( ushort, M_PTR_ADD )
    pa.ty = cast( ubyte, MT_PTR )
    pa.a = base_
    pa.b = acc
    return Emit( c, pa )
end function

'' Per-dimension byte strides, and the constant lbound bias.
''
'' Row-major: the last dimension has stride elemSize, and each earlier one is scaled by
'' the element COUNTS of every dimension after it. Returns false when the bounds were not
'' constant, in which case nothing may be folded and the subscript is not lowered.
private function ArrayStrides _
    ( byref c as Ctx, byval t as Fbx.TypeId, byref strides as FB.Array( of longint ), _
      byref bias as longint ) as boolean

    bias = 0
    if t = Fbx.TYPE_NONE then return false
    if c.types->Kind( t ) <> Fbx.TK_ARRAY then return false

    dim as Fbx.TypeId elem = c.types->Inner( t )
    dim as long esz
    dim as long ui = c.udts->Find( elem )
    if ui >= 0 then
        esz = c.udts->udts[ui].size
    else
        esz = c.types->Layout( elem ).size
    end if
    if esz <= 0 then return false

    '' Rank comes from the retained bounds rather than from 'dims', so a type whose
    '' bounds were dropped cannot silently produce a plausible stride list.
    dim as long rank = 0
    do
        dim as boolean known
        c.types->ArrayBound( t, rank, false, known )
        if known = false then exit do
        rank += 1
    loop
    if rank = 0 then return false

    dim as FB.Array( of longint ) los, counts
    for k as long = 0 to rank - 1
        dim as boolean lk, hk
        dim as longint lo = c.types->ArrayBound( t, k, false, lk )
        dim as longint hi = c.types->ArrayBound( t, k, true, hk )
        if (lk = false) orelse (hk = false) then return false
        if hi < lo then return false
        los.Push( lo )
        counts.Push( hi - lo + 1 )
    next

    for k as long = 0 to rank - 1
        strides.Push( 0 )
    next
    dim as longint run = esz
    for k as long = rank - 1 to 0 step -1
        strides[k] = run
        run *= counts[k]
    next
    for k as long = 0 to rank - 1
        bias += los[k] * strides[k]
    next
    return true
end function

end namespace
