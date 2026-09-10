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

'' A SysV RETURN THIS PASS CANNOT MODEL YET.
''
'' SysV returns an aggregate of sixteen bytes or fewer in REGISTERS, one per eightbyte,
'' and clang spells that as a literal struct -- '{ i64, i64 }' for two INTEGER
'' eightbytes. MIR has no pair type and the emitter has no coerced return type, so the
'' only sizes this pass can actually produce are the ones that fit a SINGLE integer.
'' Everything else was silently taken down the direct path anyway, where
'' DirectIntType( 16 ) is MT_VOID -- and the result was '%34 = call void MK(@x)'
'' followed by a store of %34: a call with no value, and a use of it.
''
'' Measured on tests/mir/src/udt-return.bas and on a plain two-field UDT at
'' -target linux-x86_64: eight verifier failures, "opcode with no result carries a
'' result temp" and "uses %30 before it is defined". Declining leaves the return
'' exactly as it was and the emitter says so, which is the rule for a half-modelled
'' ABI. THE EIGHTBYTE MACHINERY FOR PARAMETERS IS COMPLETE and is not touched here;
'' it is only the RETURN that has no representation.
private function SysvReturnUnmodelled_ _
    ( byval sizeBytes as long, byref target as TargetDescription ) as boolean

    if target.abi = ABI_WIN64 then return false
    if sizeBytes <= 0 then return false
    if sizeBytes > 16 then return false
    return (DirectIntType( sizeBytes ) = MT_VOID)
end function

function ClassifyAggregate _
    ( byval sizeBytes as long, byref target as TargetDescription ) as AbiClassKind

    if target.abi = ABI_WIN64 then
        if DirectIntType( sizeBytes ) <> MT_VOID then return ABIC_DIRECT_INT
        return ABIC_INDIRECT
    end if
    '' SysV: over sixteen bytes is MEMORY, and the rest is decided by the EIGHTBYTE
    '' CLASSES, which a size cannot answer -- see SysvClass below. This entry point is
    '' kept for the size-only question the win64 path asks.
    if sizeBytes > 16 then return ABIC_INDIRECT
    return ABIC_DIRECT_INT
end function

'' The MIR type one SysV eightbyte travels in.
''
'' 'nbytes' is how much of the aggregate this eightbyte actually covers -- the last one
'' is often partial, and a twelve-byte aggregate's second eightbyte is four bytes, which
'' clang passes as i32 rather than i64.
''
'' AN SSE EIGHTBYTE BECOMES 'double' (or 'float' when partial) WHERE CLANG WRITES
'' '<2 x float>'. MIR has no vector type and adding one for this would be a large change
'' to every layer. The two are register-compatible -- both occupy the low bits of one
'' XMM and nothing else is passed there -- but that is an ARGUMENT, not a measurement,
'' and it is the reason tests/abi has to run a real cross-ABI call before this is
'' trusted. It is written down here so the assumption is findable rather than implicit.
function SysvEightbyteType _
    ( byval cls as ulong, byval nbytes as long ) as MirType

    if cls = TKO_EB_SSE then
        if nbytes <= 4 then return MT_F32
        return MT_F64
    end if
    select case nbytes
    case 1 : return MT_I8
    case 2 : return MT_I16
    case 3, 4 : return MT_I32
    end select
    return MT_I64
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

'' The address of a byte offset inside something. SysV's second eightbyte lives eight
'' bytes into the copy, and M_FIELD_ADDR is exactly a base plus a constant byte offset.
private function FieldAddr _
    ( byref r as Rewriter, byref base_ as MirValue, byval off as long ) as MirValue

    dim as MirInst g
    g.op = cast( ushort, M_FIELD_ADDR )
    g.ty = cast( ubyte, MT_PTR )
    g.a = base_
    g.imm = off
    g.result = r.f->nextTemp
    r.f->nextTemp += 1
    r.outp.Push( g )
    return TempVal( g.result, MT_PTR )
end function

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

'' EVERY AGGREGATE ARGUMENT IS MATERIALISED INTO A FRESH SLOT FIRST, whatever its
'' class. One rule instead of several, it needs no def-use analysis to find where the
'' value came from, and it is what clang emits: a per-call copy the callee owns. The
'' direct cases then load out of that slot, which looks wasteful and is not -- LLVM's
'' SROA removes the slot and leaves the loads.
''
'' THE ARGUMENT RUN IS REBUILT RATHER THAN PATCHED, because on SysV one aggregate can
'' become TWO arguments: a twelve-byte struct is passed as 'i64, i32'. An in-place
'' patch cannot express that, and the signature rewrite expands the same way from the
'' same original signature, so the two agree by construction.
private sub RewriteCallArgs _
    ( byref r as Rewriter, byref ins as MirInst, byval callee as MirFunction ptr, _
      byref names as Tko.Interner )

    if callee = 0 then return
    dim as boolean anyAgg = false
    for i as long = 0 to ins.count - 1
        if i >= callee->paramTys.Count then exit for
        if cast( MirType, callee->paramTys[i] ) = MT_AGG then anyAgg = true
    next
    if anyAgg = false then return

    dim as long oldFirst = ins.first
    dim as long oldCount = ins.count
    '' The new run goes on the END of the pool. The old one is left where it is --
    '' nothing reclaims argument-pool space, and a run that is still referenced by an
    '' instruction this pass has not reached yet must not be disturbed.
    dim as long newFirst = r.m->argPool.Count \ 2
    dim as long newCount = 0

    for i as long = 0 to oldCount - 1
        dim as long k = (oldFirst + i) * 2
        if (k + 1) >= r.m->argPool.Count then exit for
        dim as MirValue av
        av.kind = cast( ubyte, r.m->argPool[k] )
        av.id = r.m->argPool[k + 1]

        dim as MirType pt = MT_I64
        if i < callee->paramTys.Count then pt = cast( MirType, callee->paramTys[i] )
        if pt <> MT_AGG then
            r.m->argPool.Push( cast( ulong, av.kind ) )
            r.m->argPool.Push( av.id )
            newCount += 1
            continue for
        end if

        dim as long sz = cast( long, callee->paramAggs[i] )
        if sz <= 0 then
            '' An aggregate whose size was never recorded. Passed through untouched so
            '' the emitter ICEs on it and says so; a guessed width would move a
            '' different number of bytes at each end of the call.
            r.st->declined += 1
            r.m->argPool.Push( cast( ulong, av.kind ) )
            r.m->argPool.Push( av.id )
            newCount += 1
            continue for
        end if

        '' The per-call copy.
        av.ty = cast( ubyte, MT_AGG )
        dim as long slot = NewAggSlot( r, sz, names )
        if (av.kind = cast( ubyte, MV_LOCAL )) orelse (av.kind = cast( ubyte, MV_GLOBAL )) then
            dim as MirValue loaded = LoadAs( r, av, MT_AGG, sz )
            StoreAggInto( r, slot, loaded, sz )
        else
            StoreAggInto( r, slot, av, sz )
        end if

        if r.tgt->abi = ABI_WIN64 then
            if ClassifyAggregate( sz, *r.tgt ) = ABIC_DIRECT_INT then
                dim as MirValue iv = LoadAs( r, LocalVal( slot ), DirectIntType( sz ) )
                r.m->argPool.Push( cast( ulong, iv.kind ) )
                r.m->argPool.Push( iv.id )
                newCount += 1
                r.st->coercedParams += 1
            else
                r.m->argPool.Push( cast( ulong, MV_LOCAL ) )
                r.m->argPool.Push( cast( ulong, slot ) )
                newCount += 1
                r.st->indirectParams += 1
            end if
            continue for
        end if

        '' ---- SysV
        dim as ulong packed = callee->paramClasses[i]
        if (sz > 16) orelse (packed = TKO_EB_MEMORY) orelse (packed = 0) then
            '' MEMORY: the slot's address, and the signature marks it byval so it
            '' travels on the stack rather than as a pointer in a register.
            r.m->argPool.Push( cast( ulong, MV_LOCAL ) )
            r.m->argPool.Push( cast( ulong, slot ) )
            newCount += 1
            r.st->indirectParams += 1
            continue for
        end if
        '' One register per eightbyte, loaded from the copy at its own offset.
        dim as long n0 = sz
        if n0 > 8 then n0 = 8
        dim as MirValue v0 = LoadAs( r, LocalVal( slot ), _
                                     SysvEightbyteType( TKO_EB0( packed ), n0 ) )
        r.m->argPool.Push( cast( ulong, v0.kind ) )
        r.m->argPool.Push( v0.id )
        newCount += 1
        r.st->coercedParams += 1
        if sz > 8 then
            dim as MirValue a1 = FieldAddr( r, LocalVal( slot ), 8 )
            dim as MirValue v1 = LoadAs( r, a1, _
                                         SysvEightbyteType( TKO_EB1( packed ), sz - 8 ) )
            r.m->argPool.Push( cast( ulong, v1.kind ) )
            r.m->argPool.Push( v1.id )
            newCount += 1
        end if
    next

    ins.first = newFirst
    ins.count = newCount
end sub

'' A call that RETURNS an aggregate. Direct: the call yields an integer and the value
'' is written into a slot the old result temp then loads from, so every existing
'' consumer keeps working unchanged. Indirect: the caller allocates the destination,
'' passes it as a hidden FIRST argument, and the call returns nothing.
private sub RewriteCallReturn _
    ( byref r as Rewriter, byref ins as MirInst, byval callee as MirFunction ptr, _
      byref names as Tko.Interner, byval discard as boolean = false )

    dim as long sz = 0
    if callee <> 0 then sz = callee->retSize
    if sz <= 0 then
        r.st->declined += 1
        r.outp.Push( ins )
        return
    end if

    '' See SysvReturnUnmodelled_. The SIGNATURE declines the same size, so the two
    '' halves stay in step.
    if SysvReturnUnmodelled_( sz, *r.tgt ) then
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
        '' A DISCARDED RESULT HAS NO TEMP TO LOAD INTO. 'Conjugate( z )' as a
        '' statement is a call whose MIR type is VOID; reading the aggregate back out
        '' would name result temp zero, which belongs to something else.
        if discard = false then
            dim as MirInst l
            l.op = cast( ushort, M_LOAD )
            l.ty = cast( ubyte, MT_AGG )
            l.a = LocalVal( slot )
            l.imm = sz
            l.result = oldResult
            r.outp.Push( l )
        end if
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
    '' ...and the value is what landed in the slot -- unless nothing wanted it.
    if discard = false then
        dim as MirInst l2
        l2.op = cast( ushort, M_LOAD )
        l2.ty = cast( ubyte, MT_AGG )
        l2.a = LocalVal( slot )
        l2.imm = sz
        l2.result = oldResult
        r.outp.Push( l2 )
    end if
    r.st->sretReturns += 1
end sub

'' THE PROLOGUE STORE, against the signature the pass has just produced.
''
'' The body still names parameters by their ORIGINAL index, and the pass may have moved
'' them: an sret pointer shifts everything right by one, and on SysV one aggregate
'' becomes two. paramOrig maps new to old, so the original index is found by searching
'' rather than assumed to be unchanged -- assuming it silently made '$1' the second
'' eightbyte of '$0'.
private sub RewriteParamStore _
    ( byref r as Rewriter, byref ins as MirInst, byref changed as boolean )

    changed = false
    if ins.b.kind <> cast( ubyte, MV_PARAM ) then return
    dim as long oldIdx = cast( long, ins.b.id )
    if oldIdx < 0 then return

    '' AND THE DESTINATION MUST REALLY BE AN AGGREGATE SLOT. A parameter that was
    '' ALWAYS a pointer -- a byval non-trivial UDT, a byval var-length string -- has a
    '' pointer-sized slot holding an address, and this rewrite would copy an object
    '' into it. The signature says 'ptr' in both cases and cannot tell them apart; the
    '' SLOT can, and it is the thing being written to.
    if ins.a.kind <> cast( ubyte, MV_LOCAL ) then return
    dim as long dslot = cast( long, ins.a.id )
    if (dslot < 0) orelse (dslot >= r.f->locals.Count) then return
    if cast( MirType, r.f->locals[dslot].ty ) <> MT_AGG then return

    '' Every new parameter that came from this original one, in order.
    dim as FB.Array( of long ) parts
    for j as long = 0 to r.f->paramOrig.Count - 1
        if r.f->paramOrig[j] = oldIdx then parts.Push( j )
    next
    if parts.Count = 0 then return

    dim as long sz = cast( long, r.f->paramAggs[parts[0]] )
    if sz <= 0 then return
    dim as MirType t0 = cast( MirType, r.f->paramTys[parts[0]] )

    '' INDIRECT: the parameter is the address of the caller's copy -- a win64 pointer
    '' or a SysV byval -- so the body's slot is filled by copying through it.
    if (parts.Count = 1) andalso (t0 = MT_PTR) then
        dim as MirValue pv
        pv.kind = cast( ubyte, MV_PARAM )
        pv.ty = cast( ubyte, MT_PTR )
        pv.id = cast( ulong, parts[0] )
        dim as MirValue loaded = LoadAs( r, pv, MT_AGG, sz )
        dim as MirInst st2
        st2.op = cast( ushort, M_STORE )
        st2.ty = cast( ubyte, MT_VOID )
        st2.a = ins.a
        st2.b = loaded
        st2.imm = sz
        r.outp.Push( st2 )
        changed = true
        return
    end if

    '' DIRECT: one register per eightbyte, each written at its own offset in the slot.
    for k as long = 0 to parts.Count - 1
        dim as long j = parts[k]
        dim as MirValue pv
        pv.kind = cast( ubyte, MV_PARAM )
        pv.ty = r.f->paramTys[j]
        pv.id = cast( ulong, j )
        dim as MirValue dst = ins.a
        if r.f->paramPart[j] > 0 then dst = FieldAddr( r, ins.a, r.f->paramPart[j] )
        dim as MirInst st3
        st3.op = cast( ushort, M_STORE )
        st3.ty = cast( ubyte, MT_VOID )
        st3.a = dst
        st3.b = pv
        r.outp.Push( st3 )
    next
    changed = true
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

    '' THE PARAMETER LIST IS REBUILT, because on SysV one aggregate can become TWO
    '' parameters and an in-place rewrite cannot say that. RewriteCallArgs expands the
    '' same way from the same original signature, and the two agree by construction --
    '' which is why the pass does every call site BEFORE any signature.
    dim as FB.Array( of ubyte ) ptys
    dim as FB.Array( of ulong ) paggs
    dim as FB.Array( of ulong ) pcls
    dim as FB.Array( of ubyte ) pattr
    dim as FB.Array( of long )  porig
    dim as FB.Array( of long )  ppart

    for i as long = 0 to f->paramTys.Count - 1
        dim as MirType pt = cast( MirType, f->paramTys[i] )
        dim as long sz = cast( long, f->paramAggs[i] )
        dim as ulong packed = 0
        if i < f->paramClasses.Count then packed = f->paramClasses[i]
        dim as ubyte at_ = TKO_PA_NONE
        if i < f->paramAttrs.Count then at_ = f->paramAttrs[i]

        if (pt <> MT_AGG) orelse (sz <= 0) then
            if (pt = MT_AGG) andalso (sz <= 0) then st.declined += 1
            ptys.Push( cast( ubyte, pt ) )
            paggs.Push( cast( ulong, sz ) )
            pcls.Push( packed )
            pattr.Push( at_ )
            porig.Push( i ) : ppart.Push( 0 )
            continue for
        end if

        if target.abi = ABI_WIN64 then
            '' THE SIZE IS KEPT EITHER WAY. The prologue rewrite reads it to know how
            '' many bytes the parameter stands for; zeroing it silently disabled that
            '' rewrite, and the store kept its '[8 x i8]' operand while the parameter
            '' had already become an i64.
            if ClassifyAggregate( sz, target ) = ABIC_DIRECT_INT then
                ptys.Push( cast( ubyte, DirectIntType( sz ) ) )
            else
                ptys.Push( cast( ubyte, MT_PTR ) )
            end if
            paggs.Push( cast( ulong, sz ) )
            pcls.Push( packed )
            pattr.Push( TKO_PA_NONE )
            porig.Push( i ) : ppart.Push( 0 )
            continue for
        end if

        '' ---- SysV
        if (sz > 16) orelse (packed = TKO_EB_MEMORY) orelse (packed = 0) then
            ptys.Push( cast( ubyte, MT_PTR ) )
            paggs.Push( cast( ulong, sz ) )
            pcls.Push( packed )
            '' BYVAL: on the stack, by value. Without it this is a pointer in a
            '' register, which is a different ABI.
            pattr.Push( TKO_PA_BYVAL )
            porig.Push( i ) : ppart.Push( 0 )
            continue for
        end if
        dim as long n0 = sz
        if n0 > 8 then n0 = 8
        ptys.Push( cast( ubyte, SysvEightbyteType( TKO_EB0( packed ), n0 ) ) )
        paggs.Push( cast( ulong, sz ) )
        pcls.Push( 0 )
        pattr.Push( TKO_PA_NONE )
        porig.Push( i ) : ppart.Push( 0 )
        if sz > 8 then
            ptys.Push( cast( ubyte, SysvEightbyteType( TKO_EB1( packed ), sz - 8 ) ) )
            paggs.Push( cast( ulong, sz ) )
            pcls.Push( 0 )
            pattr.Push( TKO_PA_NONE )
            porig.Push( i ) : ppart.Push( 8 )
        end if
    next

    f->paramTys.Clear( ) : f->paramAggs.Clear( )
    f->paramClasses.Clear( ) : f->paramAttrs.Clear( )
    f->paramOrig.Clear( ) : f->paramPart.Clear( )
    for i as long = 0 to ptys.Count - 1
        f->paramTys.Push( ptys[i] )
        f->paramAggs.Push( paggs[i] )
        f->paramClasses.Push( pcls[i] )
        f->paramAttrs.Push( pattr[i] )
        f->paramOrig.Push( porig[i] )
        f->paramPart.Push( ppart[i] )
    next
    f->paramCount = f->paramTys.Count

    if cast( MirType, f->retTy ) <> MT_AGG then return
    if f->retSize <= 0 then
        st.declined += 1
        return
    end if
    if SysvReturnUnmodelled_( f->retSize, target ) then
        '' ZEROED, because that is what "declined" means everywhere else in this pass:
        '' WalkBody skips the return rewrite on it and the emitter reports the
        '' untouched aggregate. Leaving the size in place rewrote the body against a
        '' signature the call sites had already declined.
        f->retSize = 0
        f->retClass = 0
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
    dim as FB.Array( of ubyte ) rtys
    dim as FB.Array( of ulong ) raggs
    dim as FB.Array( of ulong ) rcls
    dim as FB.Array( of ubyte ) rattr
    rtys.Push( cast( ubyte, MT_PTR ) )
    raggs.Push( cast( ulong, f->retSize ) )
    rcls.Push( 0 )
    '' SRET, and it is not decoration: the callee must also return this pointer, which
    '' LLVM does only when told. An fbc-compiled caller reads it -- fbc's own C is
    '' 'struct T* vr = F( &tmp )'.
    rattr.Push( TKO_PA_SRET )
    dim as FB.Array( of long ) rorig
    dim as FB.Array( of long ) rpart
    '' -1: the pass invented this parameter, so no original index maps onto it.
    rorig.Push( -1 ) : rpart.Push( 0 )
    '' ALL FOUR ARRAYS MOVE TOGETHER. They are parallel and indexed by parameter, so
    '' one that is shorter than the others is a silent misread of every parameter after
    '' the gap -- which is what inserting into two of them used to do.
    for i as long = 0 to f->paramTys.Count - 1
        rtys.Push( f->paramTys[i] )
        raggs.Push( f->paramAggs[i] )
        rcls.Push( iif( i < f->paramClasses.Count, f->paramClasses[i], 0ul ) )
        rattr.Push( iif( i < f->paramAttrs.Count, f->paramAttrs[i], TKO_PA_NONE ) )
        rorig.Push( iif( i < f->paramOrig.Count, f->paramOrig[i], cast( long, i ) ) )
        rpart.Push( iif( i < f->paramPart.Count, f->paramPart[i], 0l ) )
    next
    f->paramTys.Clear( ) : f->paramAggs.Clear( )
    f->paramClasses.Clear( ) : f->paramAttrs.Clear( )
    f->paramOrig.Clear( ) : f->paramPart.Clear( )
    for i as long = 0 to rtys.Count - 1
        f->paramTys.Push( rtys[i] )
        f->paramAggs.Push( raggs[i] )
        f->paramClasses.Push( rcls[i] )
        f->paramAttrs.Push( rattr[i] )
        f->paramOrig.Push( rorig[i] )
        f->paramPart.Push( rpart[i] )
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
            '' A CALL WHOSE RESULT IS DISCARDED STILL HAS THE CALLEE'S CONVENTION.
            '' 'Conjugate( z )' written as a statement is 'call void CONJUGATE(@z)'
            '' over a definition that returns an aggregate: the hidden destination
            '' pointer is still a parameter, and passing nothing for it hands the
            '' callee the FIRST REAL ARGUMENT to write its result through.
            '' math/vector.bas is that call, and DeclineInconsistentReturns used to
            '' read the VOID as the disagreement it is not.
            dim as boolean discardAgg = false
            if cast( MirType, ins.ty ) = MT_VOID then
                if callee <> 0 then
                    if cast( MirType, callee->retTy ) = MT_AGG then
                        discardAgg = (callee->retSize > 0)
                    end if
                end if
            end if
            if cast( MirType, ins.ty ) = MT_AGG then
                RewriteCallReturn( r, ins, callee, names )
            elseif discardAgg then
                RewriteCallReturn( r, ins, callee, names, true )
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

'' THE BODY STILL NAMES PARAMETERS BY THEIR OLD INDEX. Inserting the hidden result
'' pointer at position ZERO shifts every other parameter right, and RewriteParamStore
'' only rewrites the stores whose DESTINATION IS AN AGGREGATE SLOT -- so a plain BYREF
'' parameter kept its old number and silently became the sret pointer:
''
''     func void _ZptR3UDT(ptr $0, ptr $1)
''       store @l, $0          '' l is now the caller's destination, not the argument
''
'' Measured on tests/mir/src/arrow-field-deref.bas: fbc prints 123/123/-1 and the
'' unremapped body segfaulted. paramOrig maps each NEW parameter back to the original
'' it came from, so the inverse of it is the renumbering.
private function NewParamIndex_ _
    ( byref r as Rewriter, byval oldIdx as long ) as long

    for j as long = 0 to r.f->paramOrig.Count - 1
        if r.f->paramOrig[j] = oldIdx then
            if r.f->paramPart[j] = 0 then return j
        end if
    next
    return oldIdx
end function

private sub RemapParamVal_( byref r as Rewriter, byref v as MirValue )
    if v.kind <> cast( ubyte, MV_PARAM ) then return
    v.id = cast( ulong, NewParamIndex_( r, cast( long, v.id ) ) )
end sub

private sub RemapParamsIn_( byref r as Rewriter, byref ins as MirInst )
    RemapParamVal_( r, ins.a )
    RemapParamVal_( r, ins.b )
    dim as MirOp op = cast( MirOp, ins.op )
    if (op <> M_CALL) andalso (op <> M_CALL_RTL) andalso (op <> M_CALL_IND) then return
    dim as long base_ = cast( long, ins.first ) * 2
    for k as long = 0 to cast( long, ins.count ) - 1
        dim as long ki = base_ + k * 2
        if (ki + 1) >= r.m->argPool.Count then exit for
        if r.m->argPool[ki] = cast( ulong, MV_PARAM ) then
            r.m->argPool[ki + 1] = _
                cast( ulong, NewParamIndex_( r, cast( long, r.m->argPool[ki + 1] ) ) )
        end if
    next
end sub

private sub WalkBody _
    ( byref r as Rewriter, byref names as Tko.Interner )

    dim as boolean indirectRet = r.f->hasSretParam
    dim as long retSz = r.f->retSize
    '' Only when the numbering actually moved -- otherwise the map is the identity and
    '' walking it per operand is work for nothing.
    dim as boolean renumbered = false
    for j as long = 0 to r.f->paramOrig.Count - 1
        if r.f->paramOrig[j] <> j then renumbered = true
    next
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
            '' AFTER RewriteParamStore, which reads the OLD index by design.
            if renumbered then RemapParamsIn_( r, ins )
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
                '' ...AND A VOID CALL IS NOT A DISAGREEMENT. It is a result nobody
                '' wanted, and WalkCalls rewrites it against the callee's real
                '' convention like any other. Reading it as one declined every
                '' aggregate-returning function called as a statement.
                if cast( MirType, ins->ty ) = MT_VOID then continue for
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
