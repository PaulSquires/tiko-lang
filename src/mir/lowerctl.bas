'' lowerctl.bas -- control-flow lowering: SELECT CASE, labels and GOTO.
''
'' Split out of lower.bas when that file passed the 1500-line lint cap, by subject
'' rather than by size: what is here is the multi-way and non-local transfers, while
'' lower.bas keeps IF, the loops and the cleanup machinery they share.

#include once "mir/lowerctx.bi"

namespace Fbx.Mir

'' A label name declared more than once in one procedure -- see ScanLabels.
const LABEL_AMBIGUOUS = -2

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

'' A decline part-way THROUGH a statement, attributed to the kind of statement it was
'' inside. The statement-dispatch counter says which statements were never started; this
'' says which ones were started and could not be finished, and that is the larger number
'' by more than an order of magnitude.
sub SkipAt _
    ( byref c as Ctx, byref fileName as string, byval lineNo as long )

    c.st->skipped += 1
    '' The site, found by linear scan: about twenty of them, so a map would cost more
    '' than it saved and would not keep the order stable across runs.
    dim as Fbx.InternId fid = c.names->GetString( fileName )
    dim as boolean seen = false
    for i as long = 0 to c.st->skipSiteN.Count - 1
        if (c.st->skipSiteFile[i] = cast( ulong, fid )) andalso _
           (c.st->skipSiteLine[i] = lineNo) then
            c.st->skipSiteN[i] += 1
            seen = true
            exit for
        end if
    next
    if seen = false then
        c.st->skipSiteFile.Push( cast( ulong, fid ) )
        c.st->skipSiteLine.Push( lineNo )
        c.st->skipSiteN.Push( 1 )
    end if
    dim as long k = cast( long, c.curStmtKind )
    while c.st->innerKind.Count <= k
        c.st->innerKind.Push( 0 )
    wend
    c.st->innerKind[k] += 1
end sub

'' Which HALF of a declined call statement is at fault: a callee that bound to nothing,
'' or a callee that bound and still emitted nothing. The two need completely different
'' work -- a missing declaration against a missing lowering -- and the count against
'' N_AMBIGUOUS alone cannot tell them apart.
''
'' The unbound callee's NAME is recorded too. Twice now the answer to "what is missing"
'' has been a short list of names rather than a feature.
sub CountUnlowredCall( byref c as Ctx, byval call_ as Fbx.NodeId )
    if call_ = Fbx.NODE_NONE then return
    '' The CALLEE, whichever spelling was used: an N_CALL keeps it in the list payload,
    '' while the paren-less statement form IS the callee. Counting the second as 'other'
    '' hid 19,629 unbound calls in a bucket named for something else, and made a shape
    '' histogram of callees look like a histogram of statements.
    dim as Fbx.NodeId target = call_
    dim as boolean bound = false
    if c.ast->Kind( call_ ) = Fbx.N_CALL then
        dim as Fbx.ListPayload ptr cp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, call_ )].data )]
        target = cp->target
        bound = (c.info->RefOf( call_ ) <> Fbx.SYMBOL_NONE)
    else
        bound = (c.info->RefOf( call_ ) <> Fbx.SYMBOL_NONE)
    end if
    if bound then
        c.st->ambCallNoCode += 1
        return
    end if
    c.st->ambCallUnbound += 1
    if target = Fbx.NODE_NONE then return
    dim as long tk = cast( long, c.ast->Kind( target ) )
    while c.st->ambUnboundShape.Count <= tk
        c.st->ambUnboundShape.Push( 0 )
    wend
    c.st->ambUnboundShape[tk] += 1
    '' A MEMBER callee: record the member's own name, and whether the base typed. The
    '' base is what decides which question this is -- "no such member on that type" or
    '' "no type to look in".
    if c.ast->Kind( target ) = Fbx.N_MEMBER then
        dim as Fbx.BinaryPayload ptr mb = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, target )].data )]
        if c.info->TypeOf_( mb->lhs ) = Fbx.TYPE_NONE then
            c.st->ambMemberBaseUntyped += 1
        else
            c.st->ambMemberBaseTyped += 1
        end if
        if c.ast->Kind( mb->rhs ) <> Fbx.N_IDENT then return
        if c.st->ambMemberNames.Count >= 200000 then return
        dim as Fbx.IdentPayload ptr mp = _
            @c.ast->idents[cast( long, c.ast->nodes[cast( long, mb->rhs )].data )]
        c.st->ambMemberNames.Push( cast( ulong, mp->name ) )
        return
    end if

    if c.ast->Kind( target ) <> Fbx.N_IDENT then return
    if c.st->ambUnboundNames.Count >= 200000 then return
    '' An N_IDENT's payload is an IDENT, not a statement. Reading it through StmtOf
    '' indexes a different pool -- the mistake this project has made six times.
    dim as Fbx.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, target )].data )]
    c.st->ambUnboundNames.Push( cast( ulong, ip->name ) )
end sub

'' Records an unlowered STATEMENT, by kind, so the next thing to implement is something
'' to read off rather than guess at.
sub SkipStmt( byref c as Ctx, byval id as Fbx.NodeId )
    SkipHere( c )
    dim as long k = cast( long, c.ast->Kind( id ) )
    while c.st->skippedKind.Count <= k
        c.st->skippedKind.Push( 0 )
    wend
    c.st->skippedKind[k] += 1

    if c.ast->Kind( id ) <> Fbx.N_INTRINSIC then return
    '' Every intrinsic shares one node kind, so the keyword is counted separately.
    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
    for i as long = 0 to c.st->skippedIntrOp.Count - 1
        if c.st->skippedIntrOp[i] = cast( ulong, sp->op ) then
            c.st->skippedIntrN[i] += 1
            return
        end if
    next
    c.st->skippedIntrOp.Push( cast( ulong, sp->op ) )
    c.st->skippedIntrN.Push( 1 )
end sub

'' 'END [exitcode]' terminates the program: a direct fb_End call, measured from fbc.
''
'' IT RUNS NO CLEANUPS, and that is measured too rather than assumed by analogy with
'' RETURN. A trace program holding a live destructor and a live string prints neither
'' before exiting -- END bypasses every open scope, where RETURN runs them all
'' innermost-first. So there is deliberately no EmitCleanupsTo here, and the scope's
'' cleanup ends up in the unreachable block after the call, which is exactly right: it is
'' the normal exit path, and END is not one.
sub LowerEndStmt( byref c as Ctx, byval id as Fbx.NodeId )
    dim as Fbx.StmtPayload ptr esp = StmtOf( c, id )
    dim as MirValue code
    if esp->a <> Fbx.NODE_NONE then
        code = Coerce( c, LowerExpr( c, esp->a ), MT_I32 )
    end if
    if code.kind = cast( ubyte, MV_NONE ) then code = ConstInt( c, 0, MT_I32 )
    dim as FB.Array( of ulong ) ea
    ea.Push( cast( ulong, code.kind ) ) : ea.Push( cast( ulong, code.id ) )
    EmitRtl( c, RTL_END, ea )
    '' fb_End does not return, so nothing follows it in the same block.
    Terminate( c, MTERM_UNREACHABLE, -1, -1, NoVal( ) )
    c.curBlock = NewBlock( c, "end.after" )
end sub

'' 'exit X' and 'continue X'.
''
'' The parser records the TARGET KEYWORD and a LEVEL COUNT -- 'exit for, for' names
'' 'for' twice and leaves the SECOND-innermost for loop. Both were being ignored: every
'' exit broke the innermost breakTo entry whatever it was, so
''
''     for i as long = 1 to 3
''       for j as long = 1 to 3
''         exit for, for          <-- left the INNER loop, silently
''
'' and 'exit sub' declined outright, which is 1,594 corpus statements.
''
'' The five procedure keywords are a RETURN, not a break: EXIT SUB and EXIT FUNCTION
'' leave the procedure, running every open scope's cleanups on the way, exactly as a
'' bare RETURN does. A function's result comes from its result slot.
sub LowerExitLike _
    ( byref c as Ctx, byval id as Fbx.NodeId, byval isExit as boolean )

    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
    dim as Fbx.TokenKind want = cast( Fbx.TokenKind, sp->op )
    dim as long levels = sp->extra
    if levels < 1 then levels = 1

    '' EXIT SUB / FUNCTION / PROPERTY / CONSTRUCTOR / DESTRUCTOR / OPERATOR.
    dim as boolean isProcExit = _
        (want = Fbx.KW_SUB) orelse (want = Fbx.KW_FUNCTION) orelse _
        (want = Fbx.KW_PROPERTY) orelse (want = Fbx.KW_CONSTRUCTOR) orelse _
        (want = Fbx.KW_DESTRUCTOR) orelse (want = Fbx.KW_OPERATOR)
    if isExit andalso isProcExit then
        dim as MirValue rv = LoadResult( c )
        EmitCleanupsTo( c, 0 )
        Terminate( c, MTERM_RET, -1, -1, rv )
        c.curBlock = -1
        return
    end if
    '' 'continue sub' does not exist, and neither does 'continue select/scope'.
    if (isExit = false) andalso isProcExit then
        SkipHere( c )
        return
    end if

    '' Walk outwards counting only frames of the requested KIND. 'exit any' and an
    '' unnamed target take whatever is innermost.
    dim as boolean anyKind = (want = 0) orelse (want = Fbx.KW_ANY)
    dim as long at = -1
    dim as long seen = 0
    for i as long = c.loopKind.Count - 1 to 0 step -1
        dim as boolean match = anyKind
        if match = false then match = (c.loopKind[i] = cast( long, want ))
        '' CONTINUE only ever targets a loop: a select or scope frame has no
        '' continue target, and stepping over it would branch to -1.
        if (isExit = false) andalso (c.contTo[i] < 0) then match = false
        if match then
            seen += 1
            if seen = levels then
                at = i
                exit for
            end if
        end if
    next

    if at < 0 then
        SkipHere( c )
        return
    end if

    dim as long dest = c.breakTo[at]
    if isExit = false then dest = c.contTo[at]
    '' A SCOPE frame carries -1 until the first 'exit scope' asks for a block. The
    '' id is written back so the scope itself branches there on the way out.
    if isExit andalso (dest < 0) andalso (c.loopKind[at] = cast( long, Fbx.KW_SCOPE )) then
        dest = NewBlock( c, "scope.exit" )
        c.breakTo[at] = dest
    end if
    if dest < 0 then
        SkipHere( c )
        return
    end if

    EmitCleanupsTo( c, c.loopScope[at] )
    Terminate( c, MTERM_BR, dest, -1, NoVal( ) )
    c.curBlock = -1
end sub


sub LowerSelect( byref c as Ctx, byval id as Fbx.NodeId )
    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
    if sp->b = Fbx.NODE_NONE then
        SkipHere( c )
        return
    end if

    dim as Fbx.TypeId subjT = c.info->TypeOf_( sp->a )
    dim as MirType mt = LowerType( subjT, *c.types )
    if mt = MT_VOID then
        SkipHere( c )
        return
    end if
    dim as MirValue subj = LowerExpr( c, sp->a )
    if subj.kind = cast( ubyte, MV_NONE ) then
        SkipHere( c )
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
    '' A SELECT is a break TARGET: 'exit select' leaves it. It pushes no continue
    '' target -- 'continue select' does not exist -- so -1 marks the slot as one that
    '' must never be branched to.
    c.breakTo.Push( joinB )
    c.contTo.Push( -1 )
    c.loopScope.Push( c.scopeMark.Count )
    c.loopKind.Push( cast( long, Fbx.KW_SELECT ) )
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
                SkipHere( c )
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
    c.breakTo.Pop( )
    c.contTo.Pop( )
    c.loopScope.Pop( )
    c.loopKind.Pop( )
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
        dim as long slot = LabelSlot( c, cast( Fbx.InternId, sp->name ) )
        '' The SAME NAME twice in one procedure. Labels are scoped in FreeBASIC, so
        '' sibling scopes may each declare 'label1' -- fbcunit's TEST macro produces
        '' exactly that. Slots are keyed by name alone, which cannot tell them apart,
        '' so the name is marked AMBIGUOUS rather than resolved to whichever came last.
        '' A goto naming it then declines to lower instead of branching somewhere that
        '' merely looks plausible.
        if c.labelDepth[slot] <> -1 then
            c.labelDepth[slot] = LABEL_AMBIGUOUS
        else
            c.labelDepth[slot] = depth
        end if
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

    '' An ambiguous name gets a FRESH block per occurrence. Sharing one block between
    '' two same-named labels would splice unrelated code together; nothing branches to
    '' these, since LowerGoto declines them.
    dim as long b
    if c.labelDepth[slot] = LABEL_AMBIGUOUS then
        b = NewBlock( c, "lbl.dup" )
    else
        '' The pre-scan's depth against the depth actually open. They must agree: a
        '' goto has already emitted cleanups based on the recorded number.
        if c.labelDepth[slot] <> c.scopeMark.Count then
            c.st->labelDepthMismatch += 1
            c.labelDepth[slot] = c.scopeMark.Count
        end if
        b = LabelBlockOf( c, slot )
    end if
    Terminate( c, MTERM_BR, b, -1, NoVal( ) )
    c.curBlock = b
end sub

sub LowerGoto( byref c as Ctx, byval id as Fbx.NodeId )
    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
    if sp->name = 0 then
        SkipHere( c )
        return
    end if
    dim as long slot = LabelSlot( c, cast( Fbx.InternId, sp->name ) )
    dim as long d = c.labelDepth[slot]
    if d = LABEL_AMBIGUOUS then
        '' Two labels of this name in one procedure; which one is meant depends on
        '' scope, which these slots do not record.
        SkipHere( c )
        return
    end if
    if d < 0 then
        '' A label the pre-scan never saw, so the jump is to somewhere outside this
        '' body. Emitting a branch to a block that will never exist is worse than
        '' declining to lower it.
        SkipHere( c )
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

'' FOR EACH over a FIXED ARRAY.
''
'' Measured from fbc: it is an ordinary counted loop over the array's own bounds, with
'' three hidden temps hoisted BEFORE the loop -- an lbound snapshot, a ubound snapshot
'' and the induction variable -- then 'goto test' first so a zero-length array runs the
'' body no times, and the element loaded at the top of the body.
''
''     TMP_lo = 0; TMP_hi = 5; TMP_i = TMP_lo; goto test
''   body:  V = *(A + TMP_i*4);  <user body>
''   cont:  TMP_i = TMP_i + 1
''   test:  if TMP_i <= TMP_hi goto body
''
'' A NONZERO lbound keeps the counter in the array's own range and lets the ADDRESS
'' carry the bias, which is what the ordinary subscript path already does.
''
'' The DYNAMIC-array form needs fb_ArrayLBound/fb_ArrayUBound and an array descriptor,
'' which fbx does not build at all yet; it declines. So does the iterator-protocol form
'' over a user type, which needs GetIterator/IsValid/Value/MoveNext resolved as members.
function LowerForEachArray _
    ( byref c as Ctx, byval id as Fbx.NodeId ) as boolean

    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
    if sp->count <> 1 then return false
    if sp->a = Fbx.NODE_NONE then return false
    dim as Fbx.NodeId seqE = cast( Fbx.NodeId, c.ast->children[sp->first] )

    dim as Fbx.TypeId at = c.info->TypeOf_( seqE )
    if at = Fbx.TYPE_NONE then return false
    if c.types->Kind( at ) <> Fbx.TK_ARRAY then return false
    '' ONE DIMENSION only, and the rank comes from the RETAINED BOUNDS rather than
    '' from a field -- the same rule ArrayStrides uses, so a type whose bounds were
    '' dropped cannot produce a plausible loop over the wrong extent. A dynamic array
    '' has no compile-time bounds at all and falls out here.
    dim as boolean known0 = false
    c.types->ArrayBound( at, 0, false, known0 )
    if known0 = false then return false
    dim as boolean known1 = false
    c.types->ArrayBound( at, 1, false, known1 )
    if known1 then return false
    dim as long total = c.types->ElemCount( at )
    if total <= 0 then return false

    dim as Fbx.TypeId el = c.types->Inner( at )
    dim as MirType emt = LowerType( el, *c.types )
    if (emt = MT_VOID) orelse (emt = MT_AGG) then return false
    dim as long esz = c.types->Layout( el ).size
    if esz <= 0 then return false

    '' The loop VARIABLE. Its type is the element's, which Resolve bound when the
    '' 'as T' clause was written and which the element type supplies when it was not.
    dim as Fbx.SymbolId vs = c.info->RefOf( sp->a )
    if vs = Fbx.SYMBOL_NONE then return false
    dim as Fbx.Symbol ptr vsym = c.syms->SymbolAt( vs )
    if vsym = 0 then return false
    if vsym->type_ = Fbx.TYPE_NONE then vsym->type_ = el
    dim as MirValue vaddr = LowerAddr( c, sp->a )
    if vaddr.kind = cast( ubyte, MV_NONE ) then return false

    dim as MirValue base_ = LowerAddr( c, seqE )
    if base_.kind = cast( ubyte, MV_NONE ) then return false

    dim as MirType offTy = MT_I64
    if c.types->target.pointerBits = 32 then offTy = MT_I32

    '' The induction variable, in a temporary of its own -- the loop VARIABLE holds the
    '' element, not the index.
    dim as long islot = NewTempLocal( c, offTy, iif( offTy = MT_I32, 4, 8 ) )
    if islot < 0 then return false
    dim as MirValue iaddr
    iaddr.kind = cast( ubyte, MV_LOCAL )
    iaddr.ty = cast( ubyte, MT_PTR )
    iaddr.id = islot
    dim as MirInst st0
    st0.op = cast( ushort, M_STORE )
    st0.ty = cast( ubyte, MT_VOID )
    st0.a = iaddr
    st0.b = ConstInt( c, 0, offTy )
    Emit( c, st0 )

    dim as long headB = NewBlock( c, "each.head" )
    dim as long bodyB = NewBlock( c, "each.body" )
    dim as long stepB = NewBlock( c, "each.step" )
    dim as long exitB = NewBlock( c, "each.exit" )
    Terminate( c, MTERM_BR, headB, -1, NoVal( ) )

    '' TEST FIRST, so an empty array runs the body no times.
    c.curBlock = headB
    dim as MirValue ix = LowerExprLoad( c, iaddr, offTy )
    dim as MirInst cmp
    cmp.op = cast( ushort, M_ICMP_SLT )
    cmp.ty = cast( ubyte, MT_I8 )
    cmp.a = ix
    cmp.b = ConstInt( c, total, offTy )
    dim as MirValue cond = Emit( c, cmp )
    Terminate( c, MTERM_CONDBR, bodyB, exitB, cond )

    '' The element, loaded into the loop variable at the top of the body.
    c.curBlock = bodyB
    dim as MirValue ix2 = LowerExprLoad( c, iaddr, offTy )
    dim as MirValue off = ix2
    if esz <> 1 then
        dim as MirInst mul
        mul.op = cast( ushort, M_MUL )
        mul.ty = cast( ubyte, offTy )
        mul.a = ix2
        mul.b = ConstInt( c, esz, offTy )
        off = Emit( c, mul )
    end if
    dim as MirInst pa
    pa.op = cast( ushort, M_PTR_ADD )
    pa.ty = cast( ubyte, MT_PTR )
    pa.a = base_
    pa.b = off
    dim as MirValue ea = Emit( c, pa )
    if ea.kind = cast( ubyte, MV_NONE ) then return false
    dim as MirValue ev = LowerExprLoad( c, ea, emt )
    dim as MirInst stv
    stv.op = cast( ushort, M_STORE )
    stv.ty = cast( ubyte, MT_VOID )
    stv.a = vaddr
    stv.b = ev
    Emit( c, stv )

    c.breakTo.Push( exitB )
    c.contTo.Push( stepB )
    c.loopScope.Push( c.scopeMark.Count )
    c.loopKind.Push( cast( long, Fbx.KW_FOR ) )
    PushScope( c )
    LowerBlock( c, sp->b )
    CloseScope( c )
    c.loopScope.Pop( )
    c.loopKind.Pop( )
    c.breakTo.Pop( )
    c.contTo.Pop( )
    Terminate( c, MTERM_BR, stepB, -1, NoVal( ) )

    c.curBlock = stepB
    dim as MirValue ix3 = LowerExprLoad( c, iaddr, offTy )
    dim as MirInst add_
    add_.op = cast( ushort, M_ADD )
    add_.ty = cast( ubyte, offTy )
    add_.a = ix3
    add_.b = ConstInt( c, 1, offTy )
    dim as MirValue nxt = Emit( c, add_ )
    dim as MirInst st1
    st1.op = cast( ushort, M_STORE )
    st1.ty = cast( ubyte, MT_VOID )
    st1.a = iaddr
    st1.b = nxt
    Emit( c, st1 )
    Terminate( c, MTERM_BR, headB, -1, NoVal( ) )

    c.curBlock = exitB
    return true
end function

sub LowerDo( byref c as Ctx, byval id as Fbx.NodeId )
    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
    dim as ushort flags = c.ast->nodes[cast( long, id )].flags
    dim as boolean postCond = ((flags and Fbx.NF_POST_COND) <> 0)
    dim as boolean isUntil = ((flags and Fbx.NF_UNTIL) <> 0)

    dim as long headB = NewBlock( c, "do.head" )
    dim as long bodyB = NewBlock( c, "do.body" )
    dim as long exitB = NewBlock( c, "do.exit" )
    Terminate( c, MTERM_BR, iif( postCond, bodyB, headB ), -1, NoVal( ) )

    c.curBlock = headB
    if sp->a <> Fbx.NODE_NONE then
        dim as MirValue cond = LowerExpr( c, sp->a )
        '' UNTIL is the same test with the arms swapped, which is cheaper than
        '' emitting a negation and is exactly what fbc's own lowering does.
        if isUntil then
            Terminate( c, MTERM_CONDBR, exitB, bodyB, cond )
        else
            Terminate( c, MTERM_CONDBR, bodyB, exitB, cond )
        end if
    else
        Terminate( c, MTERM_BR, bodyB, -1, NoVal( ) )
    end if

    c.curBlock = bodyB
    c.breakTo.Push( exitB )
    c.contTo.Push( headB )
    c.loopScope.Push( c.scopeMark.Count )
    c.loopKind.Push( cast( long, Fbx.KW_DO ) )
    PushScope( c )
    LowerBlock( c, sp->b )
    CloseScope( c )
    c.loopScope.Pop( )
    c.loopKind.Pop( )
    c.breakTo.Pop( )
    c.contTo.Pop( )
    Terminate( c, MTERM_BR, headB, -1, NoVal( ) )
    c.curBlock = exitB
end sub


end namespace
