'' lowerfor.bas -- the counted FOR loop.
''
'' Split out of lower.bas, which is at its size limit. FOR EACH is a different
'' construct and lives in lowerctl.bas with the other loops.

#include once "lowerctx.bi"

namespace Tko.Mir

using Tko

sub LowerFor( byref c as Ctx, byval id as Tko.NodeId )
    dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
    '' children are [from, to, step]; any may be absent.
    dim as Tko.NodeId fromE = Tko.NODE_NONE
    dim as Tko.NodeId toE = Tko.NODE_NONE
    dim as Tko.NodeId stepE = Tko.NODE_NONE
    if sp->count >= 1 then fromE = cast( Tko.NodeId, c.ast->children[sp->first] )
    if sp->count >= 2 then toE = cast( Tko.NodeId, c.ast->children[sp->first + 1] )
    if sp->count >= 3 then stepE = cast( Tko.NodeId, c.ast->children[sp->first + 2] )

    dim as MirValue addr = LowerAddr( c, sp->a )
    if addr.kind = cast( ubyte, MV_NONE ) then
        SkipHere( c )
        return
    end if
    '' THE COUNTER'S TYPE, from whichever table its address actually names.
    ''
    '' This indexed c.f->locals by addr.id WITHOUT LOOKING AT addr.kind. A SHARED
    '' counter -- 'dim shared idx as integer : for idx = 1 to n' -- puts a GLOBALS
    '' index in addr.id, so the type came off an unrelated local: in practice $tmp0,
    '' the result slot, which means the loop counter took THE ENCLOSING FUNCTION'S
    '' RETURN TYPE. Demonstrated three ways: in a function returning DOUBLE the
    '' counter coerced to f64, and in one returning BOOLEAN it truncated an INTEGER
    '' counter to eight bits. That last one is fbcunit's own suite loop.
    ''
    '' And in a SUB there is no result slot at all, so 'locals' is empty and tiko-lang
    '' SEGFAULTED. The corpus sweep was not reporting that as anything.
    dim as MirType ity = MT_VOID
    if addr.kind = cast( ubyte, MV_GLOBAL ) then
        if (addr.id < 0) orelse (addr.id >= c.m->globals.Count) then
            SkipHere( c )
            return
        end if
        ity = cast( MirType, c.m->globals[cast( long, addr.id )].ty )
    else
        if (addr.id < 0) orelse (addr.id >= c.f->locals.Count) then
            SkipHere( c )
            return
        end if
        ity = cast( MirType, c.f->locals[cast( long, addr.id )].ty )
    end if
    if ity = MT_VOID then
        SkipHere( c )
        return
    end if

    '' init
    dim as MirValue init_ = CoerceTy( c, LowerExpr( c, fromE ), ity, c.info->TypeOf_( fromE ) )
    if init_.kind <> cast( ubyte, MV_NONE ) then
        dim as MirInst st0
        st0.op = cast( ushort, M_STORE )
        st0.ty = cast( ubyte, MT_VOID )
        st0.a = addr
        st0.b = init_
        Emit( c, st0 )
    end if

    '' THE STEP IS EVALUATED ONCE, BEFORE THE LOOP, into a temporary -- which is what
    '' fbc does ('TMP$2$1 = S$0'). It used to be re-lowered inside the step block, so
    '' a step expression with a side effect ran once per iteration.
    dim as boolean haveStep = (stepE <> Tko.NODE_NONE)
    dim as boolean stepConst = false
    dim as boolean negStep = false
    dim as long stepSlot = -1
    dim as MirValue stepAddr
    if haveStep then
        dim as Tko.Check.ConstVal sv = Tko.Check.ConstOf( *c.ast, stepE, *c.srcMgr, *c.names, _
                                   c.types->target.pointerBits )
        stepConst = sv.known
        if sv.known then negStep = (sv.value < 0)

        stepSlot = NewTempLocal( c, ity, 8 )
        if stepSlot < 0 then
            SkipHere( c )
            return
        end if
        stepAddr.kind = cast( ubyte, MV_LOCAL )
        stepAddr.ty = cast( ubyte, MT_PTR )
        stepAddr.id = stepSlot
        dim as MirValue sv0 = CoerceTy( c, LowerExpr( c, stepE ), ity, c.info->TypeOf_( stepE ) )
        if sv0.kind = cast( ubyte, MV_NONE ) then
            SkipHere( c )
            return
        end if
        dim as MirInst sst
        sst.op = cast( ushort, M_STORE )
        sst.ty = cast( ubyte, MT_VOID )
        sst.a = stepAddr
        sst.b = sv0
        Emit( c, sst )
    end if

    '' A RUNTIME STEP needs its SIGN tested once, also before the loop, because the
    '' comparison direction depends on it. fbc computes '-(step >= 0)' into a second
    '' temporary and branches on that at the top of every iteration.
    dim as long signSlot = -1
    dim as MirValue signAddr
    if haveStep andalso (stepConst = false) then
        signSlot = NewTempLocal( c, MT_I8, 1 )
        if signSlot < 0 then
            SkipHere( c )
            return
        end if
        signAddr.kind = cast( ubyte, MV_LOCAL )
        signAddr.ty = cast( ubyte, MT_PTR )
        signAddr.id = signSlot
        dim as MirValue sload = LowerExprLoad( c, stepAddr, ity )
        dim as MirInst scmp
        scmp.op = cast( ushort, iif( IsFloatTy( ity ), M_FCMP_GE, M_ICMP_SGE ) )
        scmp.ty = cast( ubyte, MT_I8 )
        scmp.a = sload
        scmp.b = ZeroOf( c, ity )
        dim as MirValue snn = Emit( c, scmp )
        dim as MirInst sst2
        sst2.op = cast( ushort, M_STORE )
        sst2.ty = cast( ubyte, MT_VOID )
        sst2.a = signAddr
        sst2.b = snn
        Emit( c, sst2 )
    end if

    dim as long headB = NewBlock( c, "for.head" )
    dim as long bodyB = NewBlock( c, "for.body" )
    dim as long stepB = NewBlock( c, "for.step" )
    dim as long exitB = NewBlock( c, "for.exit" )
    dim as long upB = -1
    dim as long downB = -1
    if signSlot >= 0 then
        upB = NewBlock( c, "for.up" )
        downB = NewBlock( c, "for.down" )
    end if
    Terminate( c, MTERM_BR, headB, -1, NoVal( ) )

    '' guard: counter <= limit for a rising step, >= for a falling one.
    c.curBlock = headB
    dim as MirValue cur = LowerExprLoad( c, addr, ity )
    dim as MirValue lim = CoerceTy( c, LowerExpr( c, toE ), ity, c.info->TypeOf_( toE ) )

    if signSlot >= 0 then
        '' Two tests, chosen at run time. The limit is loaded ONCE, above, and both
        '' arms compare against it.
        dim as MirValue sflag = LowerExprLoad( c, signAddr, MT_I8 )
        Terminate( c, MTERM_CONDBR, upB, downB, sflag )

        c.curBlock = upB
        dim as MirInst cu
        cu.op = cast( ushort, iif( IsFloatTy( ity ), M_FCMP_LE, M_ICMP_SLE ) )
        cu.ty = cast( ubyte, MT_I8 )
        cu.a = cur
        cu.b = lim
        Terminate( c, MTERM_CONDBR, bodyB, exitB, Emit( c, cu ) )

        c.curBlock = downB
        dim as MirInst cd
        cd.op = cast( ushort, iif( IsFloatTy( ity ), M_FCMP_GE, M_ICMP_SGE ) )
        cd.ty = cast( ubyte, MT_I8 )
        cd.a = cur
        cd.b = lim
        Terminate( c, MTERM_CONDBR, bodyB, exitB, Emit( c, cd ) )
    else
        dim as MirInst cmp
        cmp.op = cast( ushort, iif( IsFloatTy( ity ), _
                                    iif( negStep, M_FCMP_GE, M_FCMP_LE ), _
                                    iif( negStep, M_ICMP_SGE, M_ICMP_SLE ) ) )
        cmp.ty = cast( ubyte, MT_I8 )
        cmp.a = cur
        cmp.b = lim
        dim as MirValue cond = Emit( c, cmp )
        Terminate( c, MTERM_CONDBR, bodyB, exitB, cond )
    end if

    c.curBlock = bodyB
    c.breakTo.Push( exitB )
    c.contTo.Push( stepB )
    c.loopScope.Push( c.scopeMark.Count )
    c.loopKind.Push( cast( long, Tko.KW_FOR ) )
    PushScope( c )
    LowerBlock( c, sp->b )
    CloseScope( c )
    c.loopScope.Pop( )
    c.loopKind.Pop( )
    c.breakTo.Pop( )
    c.contTo.Pop( )
    Terminate( c, MTERM_BR, stepB, -1, NoVal( ) )

    c.curBlock = stepB
    dim as MirValue cur2 = LowerExprLoad( c, addr, ity )
    '' The step comes from the TEMPORARY, not from the expression again.
    dim as MirValue inc
    if stepSlot >= 0 then
        inc = LowerExprLoad( c, stepAddr, ity )
    else
        inc = ConstInt( c, 1, ity )
    end if
    dim as MirInst add_
    add_.op = cast( ushort, M_ADD )
    add_.ty = cast( ubyte, ity )
    add_.a = cur2
    add_.b = inc
    dim as MirValue nxt = Emit( c, add_ )
    dim as MirInst st1
    st1.op = cast( ushort, M_STORE )
    st1.ty = cast( ubyte, MT_VOID )
    st1.a = addr
    st1.b = nxt
    Emit( c, st1 )
    Terminate( c, MTERM_BR, headB, -1, NoVal( ) )

    c.curBlock = exitB
end sub

end namespace
