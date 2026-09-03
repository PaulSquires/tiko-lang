'' abi.bas -- see the header for the rule and where it was measured.

#include once "codegen/abi.bi"

namespace Tko.Codegen

using Tko.Mir

function DirectIntType( byval sizeBytes as long ) as MirType
    select case sizeBytes
    case 1 : return MT_I8
    case 2 : return MT_I16
    case 4 : return MT_I32
    case 8 : return MT_I64
    end select
    return MT_VOID
end function

function ClassifyAggregate _
    ( byval sizeBytes as long, byref target as TargetDescription ) as AbiClassKind

    '' WIN64 ONLY so far. SysV classifies by walking an aggregate's fields into
    '' per-eightbyte classes, which is a different algorithm and not a parameter of
    '' this one -- so it is not silently approximated here. Phase 7 is Windows.
    if target.abi <> ABI_WIN64 then return ABIC_INDIRECT
    if DirectIntType( sizeBytes ) <> MT_VOID then return ABIC_DIRECT_INT
    return ABIC_INDIRECT
end function

'' ---------------------------------------------------------------- helpers
''
'' The pass builds each block's instruction list ANEW rather than inserting into the
'' existing one. FB.Array has no insert, and more to the point a rewrite that walks
'' forwards while mutating in place is where off-by-one bugs live: this way the old
'' list is read-only and the new one is append-only.

type Rewriter
    as MirModule ptr    m
    as MirFunction ptr  f
    as MirInstVec       outp        '' the block being built
    as AbiStats ptr     st
    as TargetDescription ptr tgt
    '' THE NEW SLOTS' ALLOCAS, held aside and flushed into the entry block after every
    '' block has been rebuilt. Pushing them straight into block 0 does not work: block 0
    '' is itself rebuilt from 'outp', and the rebuild clears exactly what was pushed. The
    '' verifier did not catch it -- it has no rule that a slot must be allocated -- and
    '' clang did: "use of undefined value '%s10'".
    as MirInstVec       pendingAllocas
end type

'' A fresh aggregate slot, plus its alloca in the entry block. Every aggregate that
'' crosses a call boundary gets one: a DIRECT argument is loaded out of it as an
'' integer, an INDIRECT one is passed by its address. That is what clang emits too --
'' a fresh copy per call, never a reuse of the caller's own storage.
private function NewAggSlot _
    ( byref r as Rewriter, byval sizeBytes as long, byref names as Tko.Interner ) as long

    dim as MirLocal l
    l.name = names.GetString( "$abi" & str( r.f->locals.Count ) )
    l.ty = cast( ubyte, MT_AGG )
    l.size = sizeBytes
    l.sym = 0
    r.f->locals.Push( l )
    dim as long slot = r.f->locals.Count - 1

    '' THE ALLOCA GOES IN THE ENTRY BLOCK, which is a verifier rule and also what lets
    '' LLVM's mem2reg promote the slot. Appended rather than inserted: an alloca may
    '' follow other allocas, and nothing in the entry block reads this slot before the
    '' point the value is stored into it.
    dim as MirInst a
    a.op = cast( ushort, M_ALLOCA )
    a.ty = cast( ubyte, MT_PTR )
    a.imm = slot
    a.result = r.f->nextTemp
    r.f->nextTemp += 1
    r.pendingAllocas.Push( a )
    return slot
end function

private function LocalVal( byval slot as long ) as MirValue
    dim as MirValue v
    v.kind = cast( ubyte, MV_LOCAL )
    v.ty = cast( ubyte, MT_PTR )
    v.id = slot
    return v
end function

private function TempVal( byval id as ulong, byval ty as MirType ) as MirValue
    dim as MirValue v
    v.kind = cast( ubyte, MV_TEMP )
    v.ty = cast( ubyte, ty )
    v.id = id
    return v
end function

'' Store an aggregate VALUE into a slot, so that it has an address to be passed by or
'' loaded out of. MIR spells an aggregate copy as a load and a store of the aggregate
'' itself, which is what LLVM does with '[N x i8]' as well.
private sub StoreAggInto _
    ( byref r as Rewriter, byval slot as long, byref v as MirValue, _
      byval sizeBytes as long )

    dim as MirInst s
    s.op = cast( ushort, M_STORE )
    s.ty = cast( ubyte, MT_VOID )
    s.a = LocalVal( slot )
    s.b = v
    '' THE SIZE, WRITTEN DOWN. An aggregate copy through an address that is not a local
    '' slot cannot be sized by looking at the address, and the emitter would otherwise
    '' move zero bytes. This pass always knows the number.
    s.imm = sizeBytes
    r.outp.Push( s )
end sub

'' Load from an address at a given type, returning the new temp.
private function LoadAs _
    ( byref r as Rewriter, byref addr as MirValue, byval ty as MirType, _
      byval sizeBytes as long = 0 ) as MirValue

    dim as MirInst l
    l.op = cast( ushort, M_LOAD )
    l.ty = cast( ubyte, ty )
    l.a = addr
    l.imm = sizeBytes
    l.result = r.f->nextTemp
    r.f->nextTemp += 1
    r.outp.Push( l )
    return TempVal( l.result, ty )
end function

'' ---------------------------------------------------------------- call sites
''
'' EVERY AGGREGATE ARGUMENT IS MATERIALISED INTO A FRESH SLOT FIRST, whatever its
'' class. That is one rule instead of two, it needs no def-use analysis to find where
'' the value came from, and it is what clang emits: a per-call copy that the callee
'' owns. The direct case then loads an integer back out of that slot, which looks
'' wasteful and is not -- LLVM's SROA removes the slot entirely and leaves the load.
private sub RewriteCallArgs _
    ( byref r as Rewriter, byref ins as MirInst, byval callee as MirFunction ptr, _
      byref names as Tko.Interner )

    if callee = 0 then return
    dim as long first = ins.first
    for i as long = 0 to ins.count - 1
        if i >= callee->paramTys.Count then exit for
        if cast( MirType, callee->paramTys[i] ) <> MT_AGG then continue for
        dim as long sz = cast( long, callee->paramAggs[i] )
        if sz <= 0 then
            '' An aggregate parameter whose size was never recorded. Declining leaves
            '' the emitter to ICE on it, which says so; guessing a width would emit a
            '' call whose two halves disagree about how many bytes moved.
            r.st->declined += 1
            continue for
        end if

        dim as long k = (first + i) * 2
        if (k + 1) >= r.m->argPool.Count then
            r.st->declined += 1
            continue for
        end if
        dim as MirValue av
        av.kind = cast( ubyte, r.m->argPool[k] )
        av.ty = cast( ubyte, MT_AGG )
        av.id = r.m->argPool[k + 1]

        '' A slot or a global is ALREADY an address and needs no copy of its own for
        '' the indirect case -- but it does for correctness: the callee owns its copy
        '' and may write to it. So the copy is made either way.
        dim as long slot = NewAggSlot( r, sz, names )
        if av.kind = cast( ubyte, MV_LOCAL ) orelse av.kind = cast( ubyte, MV_GLOBAL ) then
            dim as MirValue loaded = LoadAs( r, av, MT_AGG, sz )
            StoreAggInto( r, slot, loaded, sz )
        else
            StoreAggInto( r, slot, av, sz )
        end if

        if ClassifyAggregate( sz, *r.tgt ) = ABIC_DIRECT_INT then
            dim as MirType it = DirectIntType( sz )
            dim as MirValue iv = LoadAs( r, LocalVal( slot ), it )
            r.m->argPool[k] = cast( ulong, iv.kind )
            r.m->argPool[k + 1] = iv.id
            r.st->coercedParams += 1
        else
            '' The ADDRESS of the copy, which is what the callee receives.
            r.m->argPool[k] = cast( ulong, MV_LOCAL )
            r.m->argPool[k + 1] = cast( ulong, slot )
            r.st->indirectParams += 1
        end if
    next
end sub

'' A call that RETURNS an aggregate. Direct: the call yields an integer and the value
'' is written into a slot the old result temp then loads from, so every existing
'' consumer keeps working unchanged. Indirect: the caller allocates the destination,
'' passes it as a hidden FIRST argument, and the call returns nothing.
private sub RewriteCallReturn _
    ( byref r as Rewriter, byref ins as MirInst, byval callee as MirFunction ptr, _
      byref names as Tko.Interner )

    dim as long sz = 0
    if callee <> 0 then sz = callee->retSize
    if sz <= 0 then
        r.st->declined += 1
        r.outp.Push( ins )
        return
    end if

    dim as long slot = NewAggSlot( r, sz, names )
    dim as ulong oldResult = ins.result

    if ClassifyAggregate( sz, *r.tgt ) = ABIC_DIRECT_INT then
        dim as MirType it = DirectIntType( sz )
        dim as MirInst c = ins
        c.ty = cast( ubyte, it )
        c.result = r.f->nextTemp
        r.f->nextTemp += 1
        r.outp.Push( c )
        '' The integer goes into the slot, and the ORIGINAL result temp becomes a load
        '' of the aggregate back out of it -- so whatever consumed the aggregate before
        '' consumes the same thing now, at the same temp number.
        dim as MirInst s
        s.op = cast( ushort, M_STORE )
        s.ty = cast( ubyte, MT_VOID )
        s.a = LocalVal( slot )
        s.b = TempVal( c.result, it )
        r.outp.Push( s )
        dim as MirInst l
        l.op = cast( ushort, M_LOAD )
        l.ty = cast( ubyte, MT_AGG )
        l.a = LocalVal( slot )
        l.imm = sz
        l.result = oldResult
        r.outp.Push( l )
        r.st->coercedReturns += 1
        return
    end if

    '' INDIRECT: the hidden pointer is a real first argument and it shifts every other
    '' argument right -- including 'this'. The pool is rebuilt rather than patched,
    '' because the arguments are a contiguous run and one more does not fit in it.
    dim as long newFirst = r.m->argPool.Count \ 2
    r.m->argPool.Push( cast( ulong, MV_LOCAL ) )
    r.m->argPool.Push( cast( ulong, slot ) )
    for i as long = 0 to ins.count - 1
        dim as long k = (ins.first + i) * 2
        if (k + 1) >= r.m->argPool.Count then exit for
        r.m->argPool.Push( r.m->argPool[k] )
        r.m->argPool.Push( r.m->argPool[k + 1] )
    next
    dim as MirInst c2 = ins
    c2.ty = cast( ubyte, MT_VOID )
    c2.result = 0
    c2.first = newFirst
    c2.count = ins.count + 1
    r.outp.Push( c2 )
    '' ...and the value is what landed in the slot.
    dim as MirInst l2
    l2.op = cast( ushort, M_LOAD )
    l2.ty = cast( ubyte, MT_AGG )
    l2.a = LocalVal( slot )
    l2.imm = sz
    l2.result = oldResult
    r.outp.Push( l2 )
    r.st->sretReturns += 1
end sub

'' ---------------------------------------------------------------- signatures
''
'' A DEFINITION's aggregate parameter arrives either as an integer or as a pointer to
'' the caller's copy. Either way the body keeps its own slot and its own type: the
'' prologue's 'store @slot, $i' is rewritten to put the right bytes there, and nothing
'' else in the function has to change. That is deliberate -- a pass that rewrote every
'' USE of a parameter would have to understand the whole body.
private sub RewriteParamStore _
    ( byref r as Rewriter, byref ins as MirInst, byref changed as boolean )

    changed = false
    if ins.b.kind <> cast( ubyte, MV_PARAM ) then return
    dim as long pi = cast( long, ins.b.id )
    if (pi < 0) orelse (pi >= r.f->paramTys.Count) then return
    dim as MirType pt = cast( MirType, r.f->paramTys[pi] )
    dim as long sz = cast( long, r.f->paramAggs[pi] )
    if sz <= 0 then return

    '' AND THE DESTINATION MUST REALLY BE AN AGGREGATE SLOT. A parameter that was
    '' ALWAYS a pointer -- a byval non-trivial UDT, a byval var-length string -- has a
    '' pointer-sized slot holding an address, and this rewrite would copy an object into
    '' it. The signature says 'ptr' in both cases and cannot tell them apart; the SLOT
    '' can, and it is the thing being written to.
    if ins.a.kind <> cast( ubyte, MV_LOCAL ) then return
    dim as long dslot = cast( long, ins.a.id )
    if (dslot < 0) orelse (dslot >= r.f->locals.Count) then return
    if cast( MirType, r.f->locals[dslot].ty ) <> MT_AGG then return

    if pt = MT_PTR then
        '' INDIRECT: the parameter is the address of the caller's copy, so the body's
        '' slot is filled by copying through it.
        dim as MirValue pv
        pv.kind = cast( ubyte, MV_PARAM )
        pv.ty = cast( ubyte, MT_PTR )
        pv.id = ins.b.id
        dim as MirValue loaded = LoadAs( r, pv, MT_AGG, sz )
        dim as MirInst s = ins
        s.b = loaded
        s.imm = sz
        r.outp.Push( s )
        changed = true
        return
    end if

    if pt <> MT_VOID then
        '' DIRECT: the parameter is an integer of the aggregate's own width, and
        '' storing it into the slot writes exactly those bytes.
        dim as MirInst s = ins
        s.b.ty = cast( ubyte, pt )
        r.outp.Push( s )
        changed = true
    end if
end sub

'' A DEFINITION that returns an aggregate. Direct: the value is put in a slot and the
'' integer loaded back out, so the 'ret' carries what the ABI expects. Indirect: the
'' caller's destination is parameter zero and the value is stored through it.
private sub RewriteReturn _
    ( byref r as Rewriter, byref b as MirBlock, byval sz as long, _
      byval indirect as boolean, byref names as Tko.Interner )

    if b.term <> cast( ubyte, MTERM_RET ) then return
    if b.cond.kind = cast( ubyte, MV_NONE ) then return

    if indirect then
        dim as MirValue sretp
        sretp.kind = cast( ubyte, MV_PARAM )
        sretp.ty = cast( ubyte, MT_PTR )
        sretp.id = 0
        dim as MirInst s
        s.op = cast( ushort, M_STORE )
        s.ty = cast( ubyte, MT_VOID )
        s.a = sretp
        s.b = b.cond
        '' Through a POINTER PARAMETER, which no slot sizes.
        s.imm = sz
        r.outp.Push( s )
        dim as MirValue none_
        b.cond = none_
        return
    end if

    dim as long slot = NewAggSlot( r, sz, names )
    StoreAggInto( r, slot, b.cond, sz )
    b.cond = LoadAs( r, LocalVal( slot ), DirectIntType( sz ) )
end sub

'' Rewrite a function's SIGNATURE. Done for every function, defined here or not: a
'' declaration that disagrees with the call site is the same miscompile as a definition
'' that does.
private sub RewriteSignature _
    ( byval f as MirFunction ptr, byref target as TargetDescription, byref st as AbiStats )

    for i as long = 0 to f->paramTys.Count - 1
        if cast( MirType, f->paramTys[i] ) <> MT_AGG then continue for
        dim as long sz = cast( long, f->paramAggs[i] )
        if sz <= 0 then
            st.declined += 1
            continue for
        end if
        if ClassifyAggregate( sz, target ) = ABIC_DIRECT_INT then
            f->paramTys[i] = cast( ubyte, DirectIntType( sz ) )
        else
            f->paramTys[i] = cast( ubyte, MT_PTR )
        end if
    next

    if cast( MirType, f->retTy ) <> MT_AGG then return
    if f->retSize <= 0 then
        st.declined += 1
        return
    end if
    if ClassifyAggregate( f->retSize, target ) = ABIC_DIRECT_INT then
        f->retTy = cast( ubyte, DirectIntType( f->retSize ) )
        return
    end if
    '' INDIRECT: the hidden destination pointer becomes parameter ZERO and shifts every
    '' other parameter right. It is inserted rather than appended, because that is where
    '' the ABI puts it and because the call sites do the same.
    f->retTy = cast( ubyte, MT_VOID )
    dim as FB.Array( of ubyte ) ptys
    dim as FB.Array( of ulong ) paggs
    ptys.Push( cast( ubyte, MT_PTR ) )
    paggs.Push( 0 )
    for i as long = 0 to f->paramTys.Count - 1
        ptys.Push( f->paramTys[i] )
        paggs.Push( f->paramAggs[i] )
    next
    f->paramTys.Clear( )
    f->paramAggs.Clear( )
    for i as long = 0 to ptys.Count - 1
        f->paramTys.Push( ptys[i] )
        f->paramAggs.Push( paggs[i] )
    next
    f->paramCount = f->paramTys.Count
    f->hasSretParam = true
end sub

'' ---------------------------------------------------------------- the pass
''
'' TWO WALKS OVER EACH BODY, and the order matters.
''
'' Call sites are rewritten FIRST, while every signature still says what the FRONTEND
'' meant -- 'agg' where an aggregate was passed. Signatures are rewritten second.
'' Parameter stores and returns are rewritten THIRD, because they need the signature's
'' NEW shape to know whether a parameter arrived as an integer or as a pointer.
''
'' Doing it in one walk was tried on paper and does not work: an indirect return inserts
'' a parameter at index zero, so after that rewrite a call site's argument index no
'' longer lines up with the callee's parameter index, and every aggregate after the
'' first is classified against the wrong parameter.
'' THE ALLOCAS GO IN FIRST, ahead of everything the entry block already held. Ahead
'' rather than behind, because a slot must be allocated before the first store into it
'' and the entry block is where the stores can begin.
private sub FlushAllocas( byref r as Rewriter )
    if r.pendingAllocas.Count = 0 then return
    dim as MirInstVec merged
    for i as long = 0 to r.pendingAllocas.Count - 1
        merged.Push( r.pendingAllocas[i] )
    next
    for i as long = 0 to r.f->blocks[0].insts.Count - 1
        merged.Push( r.f->blocks[0].insts[i] )
    next
    r.f->blocks[0].insts.Clear( )
    for i as long = 0 to merged.Count - 1
        r.f->blocks[0].insts.Push( merged[i] )
    next
    r.pendingAllocas.Clear( )
end sub

private sub WalkCalls _
    ( byref r as Rewriter, byref names as Tko.Interner )

    for bi as long = 0 to r.f->blocks.Count - 1
        dim as MirBlock ptr b = @r.f->blocks[bi]
        r.outp.Clear( )
        for i as long = 0 to b->insts.Count - 1
            dim as MirInst ins = b->insts[i]
            dim as MirOp op = cast( MirOp, ins.op )
            if (op <> M_CALL) andalso (op <> M_CALL_RTL) then
                '' A CALL THROUGH A POINTER has no callee entry to classify against.
                '' The signature is on the pointee's type, which MIR does not carry
                '' here, so it is declined rather than approximated.
                if op = M_CALL_IND then
                    if cast( MirType, ins.ty ) = MT_AGG then r.st->declined += 1
                end if
                r.outp.Push( ins )
                continue for
            end if
            dim as long ci = cast( long, ins.callee )
            dim as MirFunction ptr callee = 0
            if (ci >= 0) andalso (ci < r.m->functions.Count) then
                callee = r.m->functions[ci]
            end if
            RewriteCallArgs( r, ins, callee, names )
            if cast( MirType, ins.ty ) = MT_AGG then
                RewriteCallReturn( r, ins, callee, names )
            else
                r.outp.Push( ins )
            end if
            r.st->callsRewritten += 1
        next
        b->insts.Clear( )
        for i as long = 0 to r.outp.Count - 1
            b->insts.Push( r.outp[i] )
        next
    next
    FlushAllocas( r )
end sub

private sub WalkBody _
    ( byref r as Rewriter, byref names as Tko.Interner )

    dim as boolean indirectRet = r.f->hasSretParam
    dim as long retSz = r.f->retSize
    for bi as long = 0 to r.f->blocks.Count - 1
        dim as MirBlock ptr b = @r.f->blocks[bi]
        r.outp.Clear( )
        for i as long = 0 to b->insts.Count - 1
            dim as MirInst ins = b->insts[i]
            if cast( MirOp, ins.op ) = M_STORE then
                dim as boolean changed = false
                RewriteParamStore( r, ins, changed )
                if changed then continue for
            end if
            r.outp.Push( ins )
        next
        '' The terminator's value, if this function returns an aggregate at all.
        if retSz > 0 then
            RewriteReturn( r, *b, retSz, indirectRet, names )
        end if
        b->insts.Clear( )
        for i as long = 0 to r.outp.Count - 1
            b->insts.Push( r.outp[i] )
        next
    next
    FlushAllocas( r )
end sub

'' A RETURN THIS PASS MUST NOT TOUCH.
''
'' The signature rewrite reads the CALLEE's declared return; the call rewrite reads what
'' the CALL recorded as its result type. Those are normally the same fact. Where they
'' are NOT -- and MIR does contain such functions, 'operator ->' among them, whose
'' definition says it returns an aggregate while every call site reads a pointer -- a
'' pass that believes each half in turn rewrites the signature and leaves the calls
'' alone. The result was a definition carrying a hidden result pointer that nothing
'' passed: 'func void _ZptR3UDT(ptr, ptr)' called as 'call ptr _ZptR3UDT(@x)'.
''
'' So the disagreement is DETECTED FIRST and the return is left exactly as it was.
'' retSize 0 is already what both halves read as "decline", so clearing it is the whole
'' fix -- and the emitter then ICEs on the untouched aggregate, which says so, rather
'' than a call whose two halves move different numbers of bytes.
private sub DeclineInconsistentReturns _
    ( byref m as MirModule, byref st as AbiStats )

    for fi as long = 0 to m.functions.Count - 1
        dim as MirFunction ptr f = m.functions[fi]
        if f = 0 then continue for
        if f->isDefinition = false then continue for
        for bi as long = 0 to f->blocks.Count - 1
            for ii as long = 0 to f->blocks[bi].insts.Count - 1
                dim as MirInst ptr ins = @f->blocks[bi].insts[ii]
                dim as MirOp op = cast( MirOp, ins->op )
                if (op <> M_CALL) andalso (op <> M_CALL_RTL) then continue for
                dim as long ci = cast( long, ins->callee )
                if (ci < 0) orelse (ci >= m.functions.Count) then continue for
                dim as MirFunction ptr callee = m.functions[ci]
                if callee = 0 then continue for
                if cast( MirType, callee->retTy ) <> MT_AGG then continue for
                if cast( MirType, ins->ty ) = MT_AGG then continue for
                if callee->retSize <> 0 then
                    callee->retSize = 0
                    '' ...and its classification with it. Declining means "leave this
                    '' return exactly as it was", and a size of zero beside a live
                    '' eightbyte class describes nothing that exists.
                    callee->retClass = 0
                    st.declined += 1
                end if
            next
        next
    next
end sub

sub LowerModule _
    ( byref m as MirModule, byref names as Tko.Interner, _
      byref target as TargetDescription, byref st as AbiStats )

    DeclineInconsistentReturns( m, st )

    '' CALL SITES, against the signatures the frontend produced.
    for fi as long = 0 to m.functions.Count - 1
        dim as MirFunction ptr f = m.functions[fi]
        if f = 0 then continue for
        if f->isDefinition = false then continue for
        dim as Rewriter r
        r.m = @m
        r.f = f
        r.st = @st
        r.tgt = @target
        WalkCalls( r, names )
    next

    '' SIGNATURES, every function, defined here or not.
    for fi as long = 0 to m.functions.Count - 1
        dim as MirFunction ptr f = m.functions[fi]
        if f = 0 then continue for
        dim as boolean touched = false
        if cast( MirType, f->retTy ) = MT_AGG then touched = true
        for i as long = 0 to f->paramTys.Count - 1
            if cast( MirType, f->paramTys[i] ) = MT_AGG then touched = true
        next
        RewriteSignature( f, target, st )
        if touched then st.functionsRewritten += 1
    next

    '' PARAMETER STORES AND RETURNS, against the new shapes.
    for fi as long = 0 to m.functions.Count - 1
        dim as MirFunction ptr f = m.functions[fi]
        if f = 0 then continue for
        if f->isDefinition = false then continue for
        dim as Rewriter r
        r.m = @m
        r.f = f
        r.st = @st
        r.tgt = @target
        WalkBody( r, names )
    next
end sub

end namespace
