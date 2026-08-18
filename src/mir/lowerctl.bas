'' lowerctl.bas -- control-flow lowering: SELECT CASE, labels and GOTO.
''
'' Split out of lower.bas when that file passed the 1500-line lint cap, by subject
'' rather than by size: what is here is the multi-way and non-local transfers, while
'' lower.bas keeps IF, the loops and the cleanup machinery they share.

#include once "mir/lowerctx.bi"

namespace Fbx.Mir

'' Local to this file.
declare function LowerCaseTest _
    ( byref c as Ctx, byref slotAddr as MirValue, byval mt as MirType, _
      byval isUns as boolean, byval val as Fbx.NodeId ) as MirValue
declare function LabelSlot( byref c as Ctx, byval nm as Fbx.InternId ) as long
declare function LabelBlockOf( byref c as Ctx, byval slot as long ) as long

'' SELECT CASE, lowered as a COMPARISON CHAIN.
''
'' docs/plan/09 section 4 also lists a dense-switch and a jump-table form. The chain is
'' correct for every shape, including the ranged and relational ones a switch cannot
'' express, so it is what exists first; the denser forms are an optimisation over a
'' working lowering rather than a prerequisite for one.
''
'' The SUBJECT IS EVALUATED ONCE, into a slot. Re-evaluating it per case would call a
'' function once per branch tested -- observable whenever it has side effects.
sub LowerSelect( byref c as Ctx, byval id as Fbx.NodeId )
    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
    if sp->b = Fbx.NODE_NONE then
        c.st->skipped += 1
        return
    end if

    dim as Fbx.TypeId subjT = c.info->TypeOf_( sp->a )
    dim as MirType mt = LowerType( subjT, *c.types )
    if mt = MT_VOID then
        c.st->skipped += 1
        return
    end if
    dim as MirValue subj = LowerExpr( c, sp->a )
    if subj.kind = cast( ubyte, MV_NONE ) then
        c.st->skipped += 1
        return
    end if
    dim as long slot = NewTempLocal( c, mt, c.types->Layout( subjT ).size )
    dim as MirValue slotAddr
    slotAddr.kind = cast( ubyte, MV_LOCAL )
    slotAddr.ty = cast( ubyte, MT_PTR )
    slotAddr.id = slot
    dim as MirInst st0
    st0.op = cast( ushort, M_STORE )
    st0.ty = cast( ubyte, MT_VOID )
    st0.a = slotAddr
    st0.b = subj
    Emit( c, st0 )

    dim as Fbx.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, sp->b )].data )]
    dim as long joinB = NewBlock( c, "sel.join" )
    dim as boolean isUns = IsUnsignedType( c, subjT )

    for i as long = 0 to lp->count - 1
        dim as Fbx.NodeId cs = cast( Fbx.NodeId, c.ast->children[lp->first + i] )
        if c.ast->Kind( cs ) <> Fbx.N_CASE then continue for
        dim as Fbx.StmtPayload ptr cp = StmtOf( c, cs )
        dim as long bodyB = NewBlock( c, "sel.body" )
        dim as long nextB = NewBlock( c, "sel.next" )

        '' Several values in one CASE are alternatives: any match enters the body, so
        '' each failed test falls through to the next value rather than to the body.
        for v as long = 0 to cp->count - 1
            dim as Fbx.NodeId val = cast( Fbx.NodeId, c.ast->children[cp->first + v] )
            dim as long moreB = nextB
            if v < cp->count - 1 then moreB = NewBlock( c, "sel.alt" )
            dim as MirValue cond = LowerCaseTest( c, slotAddr, mt, isUns, val )
            if cond.kind = cast( ubyte, MV_NONE ) then
                c.st->skipped += 1
                Terminate( c, MTERM_BR, moreB, -1, NoVal( ) )
            else
                Terminate( c, MTERM_CONDBR, bodyB, moreB, cond )
            end if
            c.curBlock = moreB
        next
        if cp->count = 0 then Terminate( c, MTERM_BR, bodyB, -1, NoVal( ) )

        dim as long savedCur = c.curBlock
        c.curBlock = bodyB
        PushScope( c )
        LowerBlock( c, cp->b )
        CloseScope( c )
        Terminate( c, MTERM_BR, joinB, -1, NoVal( ) )
        c.curBlock = savedCur
    next

    '' CASE ELSE is the trailing block, reached when every test failed.
    if sp->c <> Fbx.NODE_NONE then
        PushScope( c )
        LowerBlock( c, sp->c )
        CloseScope( c )
    end if
    Terminate( c, MTERM_BR, joinB, -1, NoVal( ) )
    c.curBlock = joinB
end sub

'' One CASE value against the subject: an equality, a range, or a relational test.
private function LowerCaseTest _
    ( byref c as Ctx, byref slotAddr as MirValue, byval mt as MirType, _
      byval isUns as boolean, byval val as Fbx.NodeId ) as MirValue

    dim as MirValue none_
    if val = Fbx.NODE_NONE then return none_

    if c.ast->Kind( val ) = Fbx.N_CASE_RANGE then
        dim as Fbx.StmtPayload ptr rp = StmtOf( c, val )
        dim as Fbx.TokenKind op = cast( Fbx.TokenKind, rp->op )
        if op <> 0 then
            '' 'case is > 10' -- a relational test against one operand.
            dim as MirValue cur = LowerExprLoad( c, slotAddr, mt )
            dim as MirValue rhs = Coerce( c, LowerExpr( c, rp->a ), mt )
            if rhs.kind = cast( ubyte, MV_NONE ) then return none_
            dim as MirInst ins
            ins.op = cast( ushort, BinOpFor( op, mt, isUns ) )
            ins.ty = cast( ubyte, MT_I8 )
            ins.a = cur
            ins.b = rhs
            if ins.op = cast( ushort, M_NONE ) then return none_
            return Emit( c, ins )
        end if

        '' 'case 4 to 6' -- inclusive at both ends.
        dim as MirValue lo = Coerce( c, LowerExpr( c, rp->a ), mt )
        dim as MirValue c1 = none_
        if lo.kind <> cast( ubyte, MV_NONE ) then
            dim as MirInst i1
            i1.op = cast( ushort, BinOpFor( Fbx.TK_GE, mt, isUns ) )
            i1.ty = cast( ubyte, MT_I8 )
            i1.a = LowerExprLoad( c, slotAddr, mt )
            i1.b = lo
            c1 = Emit( c, i1 )
        end if
        dim as MirValue hi = Coerce( c, LowerExpr( c, rp->b ), mt )
        if (c1.kind = cast( ubyte, MV_NONE )) orelse (hi.kind = cast( ubyte, MV_NONE )) then
            return none_
        end if
        dim as MirInst i2
        i2.op = cast( ushort, BinOpFor( Fbx.TK_LE, mt, isUns ) )
        i2.ty = cast( ubyte, MT_I8 )
        i2.a = LowerExprLoad( c, slotAddr, mt )
        i2.b = hi
        dim as MirValue c2 = Emit( c, i2 )
        dim as MirInst i3
        i3.op = cast( ushort, M_AND )
        i3.ty = cast( ubyte, MT_I8 )
        i3.a = c1
        i3.b = c2
        return Emit( c, i3 )
    end if

    dim as MirValue rhs2 = Coerce( c, LowerExpr( c, val ), mt )
    if rhs2.kind = cast( ubyte, MV_NONE ) then return none_
    dim as MirInst ins2
    ins2.op = cast( ushort, BinOpFor( Fbx.TK_EQ, mt, isUns ) )
    ins2.ty = cast( ubyte, MT_I8 )
    ins2.a = LowerExprLoad( c, slotAddr, mt )
    ins2.b = rhs2
    return Emit( c, ins2 )
end function


'' ------------------------------------------------------------ labels and GOTO

'' The label slot for a name, created on first mention. A goto may be lowered before
'' its label exists, so both directions come through here.
private function LabelSlot( byref c as Ctx, byval nm as Fbx.InternId ) as long
    for i as long = 0 to c.labelName.Count - 1
        if c.labelName[i] = cast( ulong, nm ) then return i
    next
    c.labelName.Push( cast( ulong, nm ) )
    c.labelBlock.Push( -1 )
    c.labelDepth.Push( -1 )
    return c.labelName.Count - 1
end function

private function LabelBlockOf( byref c as Ctx, byval slot as long ) as long
    if c.labelBlock[slot] < 0 then
        c.labelBlock[slot] = NewBlock( c, "lbl." & c.names->Spelling( _
            cast( Fbx.InternId, c.labelName[slot] ) ) )
    end if
    return c.labelBlock[slot]
end function

'' Records the scope depth of every label in the body BEFORE any of it is lowered.
''
'' The measurement (tests/semantic/cleanup/trace-goto) is that a scope-crossing jump
'' runs the cleanups of every scope it leaves, innermost first, BEFORE the branch. To
'' emit those at a forward goto, the target's depth has to be known already -- hence a
'' pre-pass rather than a fixup.
''
'' This mirrors the scope discipline of the lowering rather than sharing it, so the two
'' could drift. They are not left to drift silently: LowerLabel asserts that the depth
'' recorded here equals the depth actually open when the label is reached, so any
'' divergence is reported on the first program that shows it instead of quietly
'' producing the wrong number of destructor calls.
sub ScanLabels _
    ( byref c as Ctx, byval id as Fbx.NodeId, byval depth as long )

    if id = Fbx.NODE_NONE then return
    dim as Fbx.NodeKind k = c.ast->Kind( id )

    select case k
    case Fbx.N_LABEL
        dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
        c.labelDepth[LabelSlot( c, cast( Fbx.InternId, sp->name ) )] = depth
        return

    case Fbx.N_BLOCK
        dim as Fbx.ListPayload ptr lp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
        for i as long = 0 to lp->count - 1
            ScanLabels( c, cast( Fbx.NodeId, c.ast->children[lp->first + i] ), depth )
        next
        return

    case Fbx.N_SCOPE, Fbx.N_WHILE, Fbx.N_DO, Fbx.N_FOR, Fbx.N_FOREACH
        '' Each of these opens exactly one scope around its body, matching the
        '' PushScope in the corresponding Lower* routine.
        dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
        ScanLabels( c, sp->a, depth + 1 )
        ScanLabels( c, sp->b, depth + 1 )
        ScanLabels( c, sp->c, depth + 1 )
        return

    case Fbx.N_SELECT
        dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
        if sp->b <> Fbx.NODE_NONE then
            dim as Fbx.ListPayload ptr lp = _
                @c.ast->lists[cast( long, c.ast->nodes[cast( long, sp->b )].data )]
            for i as long = 0 to lp->count - 1
                dim as Fbx.NodeId cs = cast( Fbx.NodeId, c.ast->children[lp->first + i] )
                if c.ast->Kind( cs ) = Fbx.N_CASE then
                    ScanLabels( c, StmtOf( c, cs )->b, depth + 1 )
                end if
            next
        end if
        ScanLabels( c, sp->c, depth + 1 )
        return

    case Fbx.N_IF
        '' An IF branch is NOT a scope in this lowering, so its arms stay at depth.
        dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
        ScanLabels( c, sp->b, depth )
        ScanLabels( c, sp->c, depth )
        return
    end select

    if Fbx.NodeKindCategory( k ) = Fbx.NCAT_STMT then
        dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
        ScanLabels( c, sp->b, depth )
        ScanLabels( c, sp->c, depth )
    end if
end sub

sub LowerLabel( byref c as Ctx, byval id as Fbx.NodeId )
    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
    dim as long slot = LabelSlot( c, cast( Fbx.InternId, sp->name ) )

    '' The pre-scan's depth against the depth actually open. They must agree: a goto
    '' has already emitted cleanups based on the recorded number.
    if c.labelDepth[slot] <> c.scopeMark.Count then
        c.st->labelDepthMismatch += 1
        c.labelDepth[slot] = c.scopeMark.Count
    end if

    dim as long b = LabelBlockOf( c, slot )
    Terminate( c, MTERM_BR, b, -1, NoVal( ) )
    c.curBlock = b
end sub

sub LowerGoto( byref c as Ctx, byval id as Fbx.NodeId )
    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
    if sp->name = 0 then
        c.st->skipped += 1
        return
    end if
    dim as long slot = LabelSlot( c, cast( Fbx.InternId, sp->name ) )
    dim as long d = c.labelDepth[slot]
    if d < 0 then
        '' A label the pre-scan never saw, so the jump is to somewhere outside this
        '' body. Emitting a branch to a block that will never exist is worse than
        '' declining to lower it.
        c.st->skipped += 1
        return
    end if

    '' Leaving scopes runs their cleanups, innermost first. Jumping INWARD leaves
    '' nothing, and the loop below simply does not run -- fbc permits that jump with
    '' warning 14 rather than rejecting it, so it must lower, not fail.
    EmitCleanupsTo( c, d )
    Terminate( c, MTERM_BR, LabelBlockOf( c, slot ), -1, NoVal( ) )

    '' Statements after an unconditional jump are unreachable but still lower, so they
    '' need somewhere to go that is not the block just terminated.
    c.curBlock = NewBlock( c, "goto.after" )
end sub

end namespace
