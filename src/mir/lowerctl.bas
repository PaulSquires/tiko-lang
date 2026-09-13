'' lowerctl.bas -- control-flow lowering: SELECT CASE, labels and GOTO.
''
'' Split out of lower.bas when that file passed the 1500-line lint cap, by subject
'' rather than by size: what is here is the multi-way and non-local transfers, while
'' lower.bas keeps IF, the loops and the cleanup machinery they share.

#include once "mir/lowerctx.bi"
#include once "lexer/keywords.bi"

namespace Tko.Mir

declare function MemberNamed_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byref nm as string ) as Tko.SymbolId

'' A label name declared more than once in one procedure -- see ScanLabels.
const LABEL_AMBIGUOUS = -2

'' Local to this file.
declare function LowerCaseTest _
    ( byref c as Ctx, byref slotAddr as MirValue, byval mt as MirType, _
      byval isUns as boolean, byval val as Tko.NodeId, _
      byval subjT as Tko.TypeId = Tko.TYPE_NONE ) as MirValue
declare function LabelSlot( byref c as Ctx, byval nm as Tko.InternId ) as long
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
'' A node whose location is in the SOURCE rather than in a macro body. Every node the
'' preprocessor produced carries NF_FROM_MACRO, and its location is the '#define' line
'' -- so a decline inside 'CU_ASSERT( x )' was reported against one line of fbcunit.bi,
'' 1,071 times, whatever it was really about. The argument's own tokens come from the
'' INVOCATION, so the first descendant without the flag is where the work is.
private function NonMacroNode_( byref c as Ctx, byval n0 as ulong ) as ulong
    dim as Tko.NodeId n = cast( Tko.NodeId, n0 )
    for guard as long = 0 to 15
        if n = Tko.NODE_NONE then return n0
        '' NF_FROM_MACRO is declared and never set, so the test is the LOCATION
        '' itself: a node that came from a macro body sits in the file the '#define'
        '' is in, and the argument the caller wrote does not. Descend while the file
        '' MATCHES the statement's, which is the macro's when there is one.
        if c.ast->Loc( n ) <> c.ast->Loc( cast( Tko.NodeId, c.curStmtNode ) ) then
            if c.srcMgr->Decode( c.ast->Loc( n ) ).file <> _
               c.srcMgr->Decode( c.ast->Loc( cast( Tko.NodeId, c.curStmtNode ) ) ).file then
                return cast( ulong, n )
            end if
        end if
        '' Descend into the first child that has one. The payload pool differs per
        '' KIND, which is the mistake this codebase has made seven times, so only the
        '' three shapes that wrap a single operand are followed.
        select case c.ast->Kind( n )
        case Tko.N_PAREN, Tko.N_CALL, Tko.N_INDEX, Tko.N_TUPLE
            dim as Tko.ListPayload ptr lp = _
                @c.ast->lists[cast( long, c.ast->nodes[cast( long, n )].data )]
            if lp->count < 1 then return cast( ulong, n )
            n = cast( Tko.NodeId, c.ast->children[lp->first] )
        case Tko.N_BINARY
            dim as Tko.BinaryPayload ptr bp = _
                @c.ast->binaries[cast( long, c.ast->nodes[cast( long, n )].data )]
            n = bp->lhs
        case Tko.N_UNARY
            dim as Tko.UnaryPayload ptr up = _
                @c.ast->unaries[cast( long, c.ast->nodes[cast( long, n )].data )]
            n = up->operand
        case else
            return cast( ulong, n )
        end select
    next
    return n0
end function

'' THE SITE'S FILE NAME, CUT DOWN TO THE REPOSITORY. '__FILE__' expands to the path fbc
'' was given, which is ABSOLUTE for some sources and relative for others -- so a skip-site
'' line in a golden held the checkout's own directory, and the same test passed in one tree
'' and failed in another. Measured the hard way: tests/diagnostics/const-target-and-decl
'' differed between C:\dev\tiko-iso and C:\dev\tiko-iso2 by nothing but that.
private function SkipSiteName_( byref fileName as string ) as string
    dim as long at = instr( fileName, "src" & chr( 92 ) )
    if at = 0 then at = instr( fileName, "src/" )
    if at = 0 then return fileName
    return mid( fileName, at )
end function

sub SkipAt _
    ( byref c as Ctx, byref fileName as string, byval lineNo as long )

    c.st->skipped += 1
    '' TKO_TRACE_SKIP names the PROCEDURE each decline is in. A count says how much is
    '' owed and nothing about what to write; twice now the answer to "what is missing"
    '' has been a short list of names rather than a feature.
    if len( environ( "TKO_TRACE_SKIP" ) ) > 0 then
        '' ...and the SOURCE LINE the declining statement came from. A compiler line
        '' says which branch gave up; only the source line says what it gave up on,
        '' and the two largest parse-gap items were invisible without it.
        dim as string where = ""
        dim as ulong blameAt = c.curStmtNode
        if c.blameNode <> 0 then blameAt = NonMacroNode_( c, c.blameNode )
        if (c.srcMgr <> 0) andalso (blameAt <> 0) then
            dim as Tko.DecodedLoc sl = _
                c.srcMgr->Decode( c.ast->Loc( cast( Tko.NodeId, blameAt ) ) )
            where = " at " & c.srcMgr->PathOf( sl.file ) & ":" & str( sl.lineNo )
        end if
        print "SKIP " & fileName & ":" & str( lineNo ) & " in " & _
              iif( c.f <> 0, c.names->Spelling( c.f->name ), "?" ) & where
    end if
    '' The site, found by linear scan: about twenty of them, so a map would cost more
    '' than it saved and would not keep the order stable across runs.
    dim as Tko.InternId fid = c.names->GetString( SkipSiteName_( fileName ) )
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
    '' CONSUMED. A blame set for one decline must not be reported for the next.
    c.blameNode = 0
end sub

'' Which HALF of a declined call statement is at fault: a callee that bound to nothing,
'' or a callee that bound and still emitted nothing. The two need completely different
'' work -- a missing declaration against a missing lowering -- and the count against
'' N_AMBIGUOUS alone cannot tell them apart.
''
'' The unbound callee's NAME is recorded too. Twice now the answer to "what is missing"
'' has been a short list of names rather than a feature.
sub CountUnlowredCall( byref c as Ctx, byval call_ as Tko.NodeId )
    if call_ = Tko.NODE_NONE then return
    '' The CALLEE, whichever spelling was used: an N_CALL keeps it in the list payload,
    '' while the paren-less statement form IS the callee. Counting the second as 'other'
    '' hid 19,629 unbound calls in a bucket named for something else, and made a shape
    '' histogram of callees look like a histogram of statements.
    dim as Tko.NodeId target = call_
    dim as boolean bound = false
    if c.ast->Kind( call_ ) = Tko.N_CALL then
        dim as Tko.ListPayload ptr cp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, call_ )].data )]
        target = cp->target
        bound = (c.info->RefOf( call_ ) <> Tko.SYMBOL_NONE)
    else
        bound = (c.info->RefOf( call_ ) <> Tko.SYMBOL_NONE)
    end if
    if bound then
        c.st->ambCallNoCode += 1
        return
    end if
    c.st->ambCallUnbound += 1
    if target = Tko.NODE_NONE then return
    '' AN UNDECLARED NAME CALLED AS A STATEMENT IS AN ERROR -- fbc's 42, "Variable not
    '' declared". Measured: 'here', 'here is' and 'bar 1, 2' are all 42 to fbc; tiko dropped
    '' the statement and built the program, so 'here is an error on line 4' compiled.
    '' Reported HERE, not in Resolve, because only here is it known that no builtin claimed
    '' the name either -- 'run', 'width' and 'color' reach lowering unbound and still lower.
    '' A keyword spelling is not a declaration question and stays a silent decline.
    if (c.diags <> 0) andalso (c.ast->Kind( target ) = Tko.N_IDENT) then
        if c.info->RefOf( target ) = Tko.SYMBOL_NONE then
            dim as Tko.IdentPayload ptr uip = _
                @c.ast->idents[cast( long, c.ast->nodes[cast( long, target )].data )]
            if cast( long, uip->name ) > TKO_KEYWORD_COUNT then
                cast( Tko.DiagnosticEngine ptr, c.diags )->Report( Tko.TKO0743, _
                    Tko.PointRange( c.ast->Loc( target ) ), c.names->Spelling( uip->name ) )
            end if
        end if
    end if
    dim as long tk = cast( long, c.ast->Kind( target ) )
    while c.st->ambUnboundShape.Count <= tk
        c.st->ambUnboundShape.Push( 0 )
    wend
    c.st->ambUnboundShape[tk] += 1
    '' A MEMBER callee: record the member's own name, and whether the base typed. The
    '' base is what decides which question this is -- "no such member on that type" or
    '' "no type to look in".
    if c.ast->Kind( target ) = Tko.N_MEMBER then
        dim as Tko.BinaryPayload ptr mb = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, target )].data )]
        if c.info->TypeOf_( mb->lhs ) = Tko.TYPE_NONE then
            c.st->ambMemberBaseUntyped += 1
        else
            c.st->ambMemberBaseTyped += 1
        end if
        if c.ast->Kind( mb->rhs ) <> Tko.N_IDENT then return
        if c.st->ambMemberNames.Count >= 200000 then return
        dim as Tko.IdentPayload ptr mp = _
            @c.ast->idents[cast( long, c.ast->nodes[cast( long, mb->rhs )].data )]
        c.st->ambMemberNames.Push( cast( ulong, mp->name ) )
        return
    end if

    if c.ast->Kind( target ) <> Tko.N_IDENT then return
    if c.st->ambUnboundNames.Count >= 200000 then return
    '' An N_IDENT's payload is an IDENT, not a statement. Reading it through StmtOf
    '' indexes a different pool -- the mistake this project has made six times.
    dim as Tko.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, target )].data )]
    c.st->ambUnboundNames.Push( cast( ulong, ip->name ) )
end sub

'' Records an unlowered STATEMENT, by kind, so the next thing to implement is something
'' to read off rather than guess at.
sub SkipStmt( byref c as Ctx, byval id as Tko.NodeId )
    SkipHere( c )
    dim as long k = cast( long, c.ast->Kind( id ) )
    while c.st->skippedKind.Count <= k
        c.st->skippedKind.Push( 0 )
    wend
    c.st->skippedKind[k] += 1

    if c.ast->Kind( id ) <> Tko.N_INTRINSIC then return
    '' Every intrinsic shares one node kind, so the keyword is counted separately.
    dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
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
sub LowerEndStmt( byref c as Ctx, byval id as Tko.NodeId )
    dim as Tko.StmtPayload ptr esp = StmtOf( c, id )
    dim as MirValue code
    if esp->a <> Tko.NODE_NONE then
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
    ( byref c as Ctx, byval id as Tko.NodeId, byval isExit as boolean )

    dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
    dim as Tko.TokenKind want = cast( Tko.TokenKind, sp->op )
    dim as long levels = sp->extra
    if levels < 1 then levels = 1

    '' EXIT SUB / FUNCTION / PROPERTY / CONSTRUCTOR / DESTRUCTOR / OPERATOR.
    dim as boolean isProcExit = _
        (want = Tko.KW_SUB) orelse (want = Tko.KW_FUNCTION) orelse _
        (want = Tko.KW_PROPERTY) orelse (want = Tko.KW_CONSTRUCTOR) orelse _
        (want = Tko.KW_DESTRUCTOR) orelse (want = Tko.KW_OPERATOR)
    if isExit andalso isProcExit then
        '' See lower.bas: a return's temporaries cannot wait for the statement
        '' to end, because the terminator ends the block first.
        ReleaseUdtTemps_( c, c.stmtUdtMark )
        '' A STRING RESULT LEAVES THROUGH fb_StrAllocTempResult, exactly as a bare
        '' 'return' does. Loading the descriptor and returning IT gave 'ret [24 x i8]'
        '' in a function declared to return a pointer, and clang refused the module --
        '' AfxNova's DWStrAcode, 'if pwszStr = NULL then exit function'.
        if LowerStringReturn( c, Tko.NODE_NONE ) then return
        '' ...AND A UDT RETURNED THROUGH THE HIDDEN POINTER RETURNS THAT POINTER, as the
        '' end of the body does. There is no result slot to load, so this said 'ret void'
        '' -- AfxNova's DWStrBase64EncodeW, 'if bRes = 0 or cchStr = 0 then exit function'.
        if (c.udtResult = false) andalso (c.sretParam >= 0) then
            EmitCleanupsTo( c, 0 )
            dim as MirValue xsp
            xsp.kind = cast( ubyte, MV_LOCAL )
            xsp.ty = cast( ubyte, MT_PTR )
            xsp.id = c.sretParam
            Terminate( c, MTERM_RET, -1, -1, LowerExprLoad( c, xsp, MT_PTR ) )
            c.curBlock = -1
            return
        end if
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
    dim as boolean anyKind = (want = 0) orelse (want = Tko.KW_ANY)
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
    if isExit andalso (dest < 0) andalso (c.loopKind[at] = cast( long, Tko.KW_SCOPE )) then
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


declare function StrSwapKind_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byref n as longint ) as long
declare function LowerStrCaseTest_ _
    ( byref c as Ctx, byref slotAddr as MirValue, byval wide as boolean, _
      byval val as Tko.NodeId ) as MirValue
declare function StrCaseCompare_ _
    ( byref c as Ctx, byref slotAddr as MirValue, byval wide as boolean, _
      byval val as Tko.NodeId, byval op as Tko.TokenKind ) as MirValue

sub LowerSelect( byref c as Ctx, byval id as Tko.NodeId )
    dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
    if sp->b = Tko.NODE_NONE then
        SkipHere( c )
        return
    end if

    dim as Tko.TypeId subjT = c.info->TypeOf_( sp->a )
    dim as MirType mt = LowerType( subjT, *c.types )

    '' A STRING SUBJECT IS COMPARED, NOT LOADED. 'select case s : case "a"' was
    '' loading the DESCRIPTOR'S first eight bytes and comparing them against the
    '' literal's ADDRESS truncated to 32 bits -- verifier-clean, no decline, and wrong
    '' every time. fbc emits one fb_StrCompare per case value and tests its result
    '' against zero, which is what the ordinary string comparison already does.
    ''
    '' The subject is evaluated ONCE into a slot holding its descriptor pointer, so a
    '' subject with a side effect runs once however many cases follow.
    dim as long strMode = -1
    if TermIsWide_( c, sp->a ) then
        strMode = 1
    else
        dim as longint sn0
        if IsStringType( c, subjT ) orelse (StrSwapKind_( c, subjT, sn0 ) >= 0) then
            strMode = 0
        elseif c.types->Kind( subjT ) = Tko.TK_UDT then
            dim as MirValue probe
            if StrDescriptorOf_( c, sp->a, probe ) then strMode = 0
        end if
    end if

    dim as MirValue slotAddr
    if strMode >= 0 then
        dim as MirValue sv
        dim as boolean got = false
        if strMode = 1 then
            got = WideOperand_( c, sp->a, sv )
        else
            got = StrDescriptorOf_( c, sp->a, sv )
        end if
        if got = false then
            SkipHere( c )
            return
        end if
        '' A SUBJECT THAT IS NOT ITS OWN DESCRIPTOR IS COPIED FIRST, and the copy is what
        '' the cases compare. Measured, over 'select case lcase( Spell( id ) )':
        ''
        ''     vr = fb_StrLcase2( SPELL( ID ), 0 )
        ''     fb_StrInit( &TMP, -1, vr, -1, 0 )
        ''     fb_StrCompare( &TMP, -1, "new", 4 ) ... one per case value
        ''     fb_StrDelete( &TMP )       -- on the RETURN out of a case as well
        ''
        '' The slot held the TEMPORARY'S POINTER instead, and fb_StrCompare releases a
        '' temporary argument: the first case value freed it, and every later one used it
        '' after the free and released it again. That corrupts the runtime's descriptor
        '' pool for good -- after one fall-through over four values, every later str()
        '' came back empty. The self-hosted compiler's IsAllocOperator_ is exactly this
        '' select, so from its first operator on every mangled name lost its lengths.
        ''
        '' A fixed-length or zstring subject arrives as a pool descriptor too, and is
        '' copied the same way; only a var-length string LVALUE is compared in place.
        '' The copy is released by its scope, which a RETURN inside a case runs.
        if (strMode = 0) andalso (IsUStringType( c, subjT ) = false) andalso _
           (StrArgOwnDescriptor_( c, sp->a, subjT ) = false) then
            dim as long dslot = NewTempLocal( c, MT_AGG, c.types->target.stringBytes )
            if dslot < 0 then
                SkipHere( c )
                return
            end if
            dim as MirValue dsc
            dsc.kind = cast( ubyte, MV_LOCAL )
            dsc.ty = cast( ubyte, MT_PTR )
            dsc.id = dslot
            ZeroStrTempAtEntry_( c, dsc )
            dim as FB.Array( of ulong ) dargs
            dargs.Push( cast( ulong, dsc.kind ) ) : dargs.Push( cast( ulong, dsc.id ) )
            PushStrLen_( c, dargs, -1 )
            dargs.Push( cast( ulong, sv.kind ) ) : dargs.Push( cast( ulong, sv.id ) )
            PushStrLen_( c, dargs, -1 )
            dargs.Push( cast( ulong, MV_CONST_INT ) ) : dargs.Push( 0 )
            EmitRtl( c, RTL_STR_ASSIGN, dargs )
            c.cleanupNode.Push( 0 )
            c.cleanupSlot.Push( dslot )
            c.cleanupType.Push( 0 )
            sv = dsc
        end if
        dim as long pslot = NewTempLocal( c, MT_PTR, c.types->target.pointerBits \ 8 )
        if pslot < 0 then
            SkipHere( c )
            return
        end if
        slotAddr.kind = cast( ubyte, MV_LOCAL )
        slotAddr.ty = cast( ubyte, MT_PTR )
        slotAddr.id = pslot
        StoreThrough( c, slotAddr, sv )
    else
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
        slotAddr.kind = cast( ubyte, MV_LOCAL )
        slotAddr.ty = cast( ubyte, MT_PTR )
        slotAddr.id = slot
        dim as MirInst st0
        st0.op = cast( ushort, M_STORE )
        st0.ty = cast( ubyte, MT_VOID )
        st0.a = slotAddr
        st0.b = subj
        Emit( c, st0 )
    end if

    dim as Tko.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, sp->b )].data )]
    dim as long joinB = NewBlock( c, "sel.join" )
    '' A SELECT is a break TARGET: 'exit select' leaves it. It pushes no continue
    '' target -- 'continue select' does not exist -- so -1 marks the slot as one that
    '' must never be branched to.
    c.breakTo.Push( joinB )
    c.contTo.Push( -1 )
    c.loopScope.Push( c.scopeMark.Count )
    c.loopKind.Push( cast( long, Tko.KW_SELECT ) )
    dim as boolean isUns = IsUnsignedType( c, subjT )

    for i as long = 0 to lp->count - 1
        dim as Tko.NodeId cs = cast( Tko.NodeId, c.ast->children[lp->first + i] )
        if c.ast->Kind( cs ) <> Tko.N_CASE then continue for
        dim as Tko.StmtPayload ptr cp = StmtOf( c, cs )
        dim as long bodyB = NewBlock( c, "sel.body" )
        dim as long nextB = NewBlock( c, "sel.next" )

        '' Several values in one CASE are alternatives: any match enters the body, so
        '' each failed test falls through to the next value rather than to the body.
        for v as long = 0 to cp->count - 1
            dim as Tko.NodeId val = cast( Tko.NodeId, c.ast->children[cp->first + v] )
            dim as long moreB = nextB
            if v < cp->count - 1 then moreB = NewBlock( c, "sel.alt" )
            dim as MirValue cond
            if strMode >= 0 then
                cond = LowerStrCaseTest_( c, slotAddr, (strMode = 1), val )
            else
                cond = LowerCaseTest( c, slotAddr, mt, isUns, val, subjT )
            end if
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
    if sp->c <> Tko.NODE_NONE then
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

'' One CASE value against a STRING subject: fb_StrCompare or fb_WstrCompare, then the
'' case's operator against ZERO -- the same shape an ordinary string comparison takes.
''
'' 'slotAddr' holds the subject's DESCRIPTOR POINTER (narrow) or its uint16* (wide),
'' evaluated once before the first case.
private function LowerStrCaseTest_ _
    ( byref c as Ctx, byref slotAddr as MirValue, byval wide as boolean, _
      byval val as Tko.NodeId ) as MirValue

    dim as MirValue none_
    if val = Tko.NODE_NONE then return none_

    dim as Tko.TokenKind op = Tko.TK_EQ
    dim as Tko.NodeId lhsV = val
    dim as Tko.NodeId hiV = Tko.NODE_NONE
    if c.ast->Kind( val ) = Tko.N_CASE_RANGE then
        dim as Tko.StmtPayload ptr rp = StmtOf( c, val )
        lhsV = rp->a
        if cast( Tko.TokenKind, rp->op ) <> 0 then
            '' 'case is > "d"'.
            op = cast( Tko.TokenKind, rp->op )
        else
            '' 'case "a" to "c"' -- inclusive at both ends, so two comparisons.
            op = Tko.TK_GE
            hiV = rp->b
        end if
    end if

    dim as MirValue c1 = StrCaseCompare_( c, slotAddr, wide, lhsV, op )
    if c1.kind = cast( ubyte, MV_NONE ) then return none_
    if hiV = Tko.NODE_NONE then return c1
    dim as MirValue c2 = StrCaseCompare_( c, slotAddr, wide, hiV, Tko.TK_LE )
    if c2.kind = cast( ubyte, MV_NONE ) then return none_
    dim as MirInst i3
    i3.op = cast( ushort, M_AND )
    i3.ty = cast( ubyte, MT_I8 )
    i3.a = c1
    i3.b = c2
    return Emit( c, i3 )
end function

'' One comparison of the stored subject against one case value.
private function StrCaseCompare_ _
    ( byref c as Ctx, byref slotAddr as MirValue, byval wide as boolean, _
      byval val as Tko.NodeId, byval op as Tko.TokenKind ) as MirValue

    dim as MirValue none_
    dim as MirValue subjPtr = LowerExprLoad( c, slotAddr, MT_PTR )
    if subjPtr.kind = cast( ubyte, MV_NONE ) then return none_

    dim as FB.Array( of ulong ) args
    dim as MirValue cmp
    if wide then
        dim as MirValue rv
        if WideOperand_( c, val, rv ) = false then
            if NarrowToWideTemp_( c, val, rv ) = false then return none_
        end if
        args.Push( cast( ulong, subjPtr.kind ) ) : args.Push( cast( ulong, subjPtr.id ) )
        args.Push( cast( ulong, rv.kind ) ) : args.Push( cast( ulong, rv.id ) )
        cmp = EmitRtl( c, RTL_WSTR_COMPARE, args )
    else
        '' The subject is a descriptor, so its length is -1; the case value pushes its
        '' own (pointer, length) pair the way every string term does.
        args.Push( cast( ulong, subjPtr.kind ) ) : args.Push( cast( ulong, subjPtr.id ) )
        args.Push( cast( ulong, MV_CONST_INT ) )
        args.Push( cast( ulong, cast( ulongint, -1 ) ) )
        '' THE SUBJECT'S FLAVOUR, taken from the slot it was stored in: there is no
        '' subject NODE here, only its address, and the case value is usually a narrow
        '' literal that says nothing about which comparison is wanted.
        dim as boolean isU = false
        if slotAddr.kind = cast( ubyte, MV_LOCAL ) then
            if (slotAddr.id >= 0) andalso (slotAddr.id < c.f->locals.Count) then
                isU = IsUStringType( c, c.f->locals[slotAddr.id].frontendType )
            end if
        end if
        '' A REAL STRING AS THE CASE VALUE IS CONVERTED, not reinterpreted -- the same
        '' fact as an ordinary ustring comparison. A literal still follows the subject.
        if isU then
            if UStrCmpOperand_( c, args, val ) = false then return none_
            cmp = EmitRtl( c, RTL_USTR_COMPARE, args )
        else
            if EmitStrTerm( c, args, val, false ) = false then return none_
            cmp = EmitRtl( c, RTL_STR_COMPARE, args )
        end if
    end if
    if cmp.kind = cast( ubyte, MV_NONE ) then return none_

    dim as MirInst ins
    ins.op = cast( ushort, BinOpFor( op, MT_I32, false ) )
    ins.ty = cast( ubyte, MT_I8 )
    ins.a = cmp
    ins.b = ConstInt( c, 0, MT_I32 )
    if ins.op = cast( ushort, M_NONE ) then return none_
    return Emit( c, ins )
end function

'' One CASE value against the subject: an equality, a range, or a relational test.
private function LowerCaseTest _
    ( byref c as Ctx, byref slotAddr as MirValue, byval mt as MirType, _
      byval isUns as boolean, byval val as Tko.NodeId, _
      byval subjT as Tko.TypeId = Tko.TYPE_NONE ) as MirValue

    dim as MirValue none_
    if val = Tko.NODE_NONE then return none_

    if c.ast->Kind( val ) = Tko.N_CASE_RANGE then
        dim as Tko.StmtPayload ptr rp = StmtOf( c, val )
        dim as Tko.TokenKind op = cast( Tko.TokenKind, rp->op )
        if op <> 0 then
            '' 'case is > 10' -- a relational test against one operand.
            dim as MirValue cur = LowerExprLoad( c, slotAddr, mt )
            dim as MirValue rhs = CoerceTy( c, LowerExpr( c, rp->a ), mt, _
                                            c.info->TypeOf_( rp->a ), subjT )
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
        dim as MirValue lo = CoerceTy( c, LowerExpr( c, rp->a ), mt, _
                                       c.info->TypeOf_( rp->a ), subjT )
        dim as MirValue c1 = none_
        if lo.kind <> cast( ubyte, MV_NONE ) then
            dim as MirInst i1
            i1.op = cast( ushort, BinOpFor( Tko.TK_GE, mt, isUns ) )
            i1.ty = cast( ubyte, MT_I8 )
            i1.a = LowerExprLoad( c, slotAddr, mt )
            i1.b = lo
            c1 = Emit( c, i1 )
        end if
        dim as MirValue hi = CoerceTy( c, LowerExpr( c, rp->b ), mt, _
                                       c.info->TypeOf_( rp->b ), subjT )
        if (c1.kind = cast( ubyte, MV_NONE )) orelse (hi.kind = cast( ubyte, MV_NONE )) then
            return none_
        end if
        dim as MirInst i2
        i2.op = cast( ushort, BinOpFor( Tko.TK_LE, mt, isUns ) )
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

    '' TO THE SUBJECT'S TYPE, not merely to its width. A BOOLEAN subject holds 0 or
    '' 1 and the corpus writes 'case TRUE' with TRUE defined as -1, so the plain
    '' width coercion compared 1 against 255 and every such case fell to 'case
    '' else'. CoerceTy with the subject's type id narrows the way a store into a
    '' boolean does, which is what fbc compares.
    dim as MirValue rhs2 = CoerceTy( c, LowerExpr( c, val ), mt, _
                                     c.info->TypeOf_( val ), subjT )
    if rhs2.kind = cast( ubyte, MV_NONE ) then return none_
    dim as MirInst ins2
    ins2.op = cast( ushort, BinOpFor( Tko.TK_EQ, mt, isUns ) )
    ins2.ty = cast( ubyte, MT_I8 )
    ins2.a = LowerExprLoad( c, slotAddr, mt )
    ins2.b = rhs2
    return Emit( c, ins2 )
end function


'' ------------------------------------------------------------ labels and GOTO

'' The label slot for a name, created on first mention. A goto may be lowered before
'' its label exists, so both directions come through here.
private function LabelSlot( byref c as Ctx, byval nm as Tko.InternId ) as long
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
            cast( Tko.InternId, c.labelName[slot] ) ) )
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
    ( byref c as Ctx, byval id as Tko.NodeId, byval depth as long )

    if id = Tko.NODE_NONE then return
    dim as Tko.NodeKind k = c.ast->Kind( id )

    select case k
    case Tko.N_LABEL
        dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
        dim as long slot = LabelSlot( c, cast( Tko.InternId, sp->name ) )
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

    case Tko.N_BLOCK
        dim as Tko.ListPayload ptr lp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
        for i as long = 0 to lp->count - 1
            ScanLabels( c, cast( Tko.NodeId, c.ast->children[lp->first + i] ), depth )
        next
        return

    case Tko.N_SCOPE, Tko.N_WHILE, Tko.N_DO, Tko.N_FOR, Tko.N_FOREACH
        '' Each of these opens exactly one scope around its body, matching the
        '' PushScope in the corresponding Lower* routine.
        dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
        ScanLabels( c, sp->a, depth + 1 )
        ScanLabels( c, sp->b, depth + 1 )
        ScanLabels( c, sp->c, depth + 1 )
        return

    case Tko.N_SELECT
        dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
        if sp->b <> Tko.NODE_NONE then
            dim as Tko.ListPayload ptr lp = _
                @c.ast->lists[cast( long, c.ast->nodes[cast( long, sp->b )].data )]
            for i as long = 0 to lp->count - 1
                dim as Tko.NodeId cs = cast( Tko.NodeId, c.ast->children[lp->first + i] )
                if c.ast->Kind( cs ) = Tko.N_CASE then
                    ScanLabels( c, StmtOf( c, cs )->b, depth + 1 )
                end if
            next
        end if
        ScanLabels( c, sp->c, depth + 1 )
        return

    case Tko.N_IF
        '' An IF branch is NOT a scope in this lowering, so its arms stay at depth.
        dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
        ScanLabels( c, sp->b, depth )
        ScanLabels( c, sp->c, depth )
        return
    end select

    if Tko.NodeKindCategory( k ) = Tko.NCAT_STMT then
        dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
        ScanLabels( c, sp->b, depth )
        ScanLabels( c, sp->c, depth )
    end if
end sub

sub LowerLabel( byref c as Ctx, byval id as Tko.NodeId )
    dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
    dim as long slot = LabelSlot( c, cast( Tko.InternId, sp->name ) )

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

'' 'on n goto l1, l2, l3' -- the COMPUTED GOTO, which was not lowered at all.
''
'' Measured semantics, and the two facts that matter are both in the range test fbc
'' emits:
''
''   TMP = (uint64)I$0;
''   if( (TMP - 1ull) > 2ull ) goto label$5;   <- past the list: FALL THROUGH
''   goto *tmp$7[TMP - 1ull];
''
'' -- the list is ONE-BASED, so the selector has 1 subtracted from it, and the test is
'' UNSIGNED, which is what makes a selector of 0 (or any negative) fall through in a
'' single comparison rather than needing two.
''
'' THE DISPATCH ITSELF IS A CHAIN HERE, not a jump table. fbc uses GCC's computed goto
'' over a static array of label addresses; MIR has BR and CONDBR and nothing else, so
'' the same choice is made with one equality test per label. Semantically identical --
'' the range test above still runs first, so the chain is entered only for a selector
'' that names a label -- and O(N) where fbc is O(1). The corpus's longest list is
'' three.
''
'' 'on n GOSUB' is a separate statement -- it pushes a return address -- and is NOT
'' lowered: it declines rather than jumping without one. 'on error goto' likewise; it
'' needs the error-handler machinery, which is not built.
'' 'ON ERROR GOTO label' and 'ON ERROR GOTO 0'. Measured from fbc's own C:
''
''     fb_ErrorSetHandler( &&label$2 );      installs
''     fb_ErrorSetHandler( (void*)0ull );    'goto 0' clears it
''
'' The handler is an ADDRESS OF A LABEL -- GCC's '&&label', LLVM's blockaddress -- and
'' the runtime hands it back from a failed check for the caller to jump to. That jump is
'' the other half, at the check sites.
''
'' RESUME AND RESUME NEXT ARE NOT PART OF THIS and are not planned: fbc passes their
'' addresses as fb_ErrorThrowAt's third and fourth arguments and passes NULL for both in
'' a program that uses neither, which is what this emits.
private sub LowerOnError_( byref c as Ctx, byval id as Tko.NodeId )
    dim as Tko.StmtPayload ptr sp = StmtOf( c, id )

    dim as FB.Array( of ulong ) args
    if sp->name = 0 then
        '' 'ON ERROR GOTO 0' -- a null handler. The parser leaves the name empty for the
        '' integer form, which in the fb dialect can only be 0: a numeric label is fbc's
        '' error 146 here, so there is no other integer to mean.
        args.Push( cast( ulong, MV_CONST_INT ) )
        args.Push( 0 )
        EmitRtl( c, RTL_ERROR_SET_HANDLER, args )
        return
    end if

    dim as long slot = LabelSlot( c, sp->name )
    dim as long d = c.labelDepth[slot]
    if (d < 0) orelse (d = LABEL_AMBIGUOUS) then
        SkipHere( c )
        return
    end if

    '' THE ADDRESS IS NOT KNOWN YET, and cannot be made known by creating the block
    '' early. A block is an EXTENT over the function's one instruction list, so blocks
    '' have to be created in the order they are FILLED -- see Emit. Calling LabelBlockOf
    '' here made the handler's block exist before the code between here and the label,
    '' and everything after was then emitted into the wrong extent: the handler came out
    '' as a bare 'br' into the jump block, the jump block branched back to it, and the
    '' two formed a loop that hung the assembler. The IR read plausibly.
    ''
    '' So the operand goes out as a null placeholder and ResolveErrorJumps_ rewrites it
    '' once the label has been reached and its block exists in order.
    dim as long argAt = c.m->argPool.Count
    args.Push( cast( ulong, MV_CONST_INT ) )
    args.Push( 0 )
    EmitRtl( c, RTL_ERROR_SET_HANDLER, args )
    c.errPendingArg.Push( cast( ulong, argAt ) )
    c.errPendingSlot.Push( cast( ulong, slot ) )
end sub

sub LowerOnGoto( byref c as Ctx, byval id as Tko.NodeId )
    dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
    '' 'ON ERROR GOTO' is its own statement and not a computed goto at all.
    if sp->extra = 1 then
        LowerOnError_( c, id )
        return
    end if
    '' 3 is 'on n gosub'; that is not this either.
    if sp->extra <> 2 then
        SkipHere( c )
        return
    end if
    if (sp->count < 1) orelse (sp->a = Tko.NODE_NONE) then
        SkipHere( c )
        return
    end if

    '' EVERY LABEL FIRST. A list naming one this procedure has not got would leave a
    '' branch to a block that never exists, so nothing is emitted until all of them
    '' are known -- the same rule LowerGoto applies to its single label.
    dim as FB.Array( of ulong ) blocks
    for i as long = 0 to sp->count - 1
        dim as Tko.NodeId ln = cast( Tko.NodeId, c.ast->children[sp->first + i] )
        if c.ast->Kind( ln ) <> Tko.N_IDENT then
            SkipHere( c )
            return
        end if
        dim as Tko.IdentPayload ptr lip = _
            @c.ast->idents[cast( long, c.ast->nodes[cast( long, ln )].data )]
        dim as long slot = LabelSlot( c, lip->name )
        dim as long d = c.labelDepth[slot]
        if (d < 0) orelse (d = LABEL_AMBIGUOUS) then
            SkipHere( c )
            return
        end if
        blocks.Push( cast( ulong, LabelBlockOf( c, slot ) ) )
    next

    dim as MirValue sel = LowerExpr( c, sp->a )
    if sel.kind = cast( ubyte, MV_NONE ) then
        SkipHere( c )
        return
    end if
    sel = Coerce( c, sel, MT_I64, true )

    '' THE LIST IS ONE-BASED: the index is the selector minus one.
    dim as MirValue one
    one.kind = cast( ubyte, MV_CONST_INT )
    one.ty = cast( ubyte, MT_I64 )
    one.id = 1
    dim as MirInst sub_
    sub_.op = cast( ushort, M_SUB )
    sub_.ty = cast( ubyte, MT_I64 )
    sub_.a = sel
    sub_.b = one
    dim as MirValue idx = Emit( c, sub_ )
    if idx.kind = cast( ubyte, MV_NONE ) then
        SkipHere( c )
        return
    end if

    '' ...and the range test is UNSIGNED, so 0 and every negative selector fall
    '' through on the same comparison.
    dim as MirValue hi
    hi.kind = cast( ubyte, MV_CONST_INT )
    hi.ty = cast( ubyte, MT_I64 )
    hi.id = cast( ulong, sp->count - 1 )
    dim as MirInst cmp
    cmp.op = cast( ushort, M_ICMP_UGT )
    cmp.ty = cast( ubyte, MT_I64 )
    cmp.a = idx
    cmp.b = hi
    dim as MirValue over = Emit( c, cmp )
    if over.kind = cast( ubyte, MV_NONE ) then
        SkipHere( c )
        return
    end if

    dim as long afterB = NewBlock( c, "on.after" )
    dim as long testB = NewBlock( c, "on.test" )
    Terminate( c, MTERM_CONDBR, afterB, testB, over )

    for i as long = 0 to sp->count - 1
        c.curBlock = testB
        dim as MirValue k
        k.kind = cast( ubyte, MV_CONST_INT )
        k.ty = cast( ubyte, MT_I64 )
        k.id = cast( ulong, i )
        dim as MirInst eq
        eq.op = cast( ushort, M_ICMP_EQ )
        eq.ty = cast( ubyte, MT_I64 )
        eq.a = idx
        eq.b = k
        dim as MirValue hit = Emit( c, eq )
        if hit.kind = cast( ubyte, MV_NONE ) then
            SkipHere( c )
            return
        end if
        dim as long nextB = afterB
        if i < (sp->count - 1) then nextB = NewBlock( c, "on.test" )
        Terminate( c, MTERM_CONDBR, cast( long, blocks[i] ), nextB, hit )
        testB = nextB
    next

    c.curBlock = afterB
end sub

sub LowerGoto( byref c as Ctx, byval id as Tko.NodeId )
    dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
    if sp->name = 0 then
        SkipHere( c )
        return
    end if
    dim as long slot = LabelSlot( c, cast( Tko.InternId, sp->name ) )
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

sub LowerDo( byref c as Ctx, byval id as Tko.NodeId )
    dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
    dim as ushort flags = c.ast->nodes[cast( long, id )].flags
    dim as boolean postCond = ((flags and Tko.NF_POST_COND) <> 0)
    dim as boolean isUntil = ((flags and Tko.NF_UNTIL) <> 0)

    dim as long headB = NewBlock( c, "do.head" )
    dim as long bodyB = NewBlock( c, "do.body" )
    dim as long exitB = NewBlock( c, "do.exit" )
    Terminate( c, MTERM_BR, iif( postCond, bodyB, headB ), -1, NoVal( ) )

    '' THE POST-TEST CONDITION LIVES IN 'c', NOT IN 'a', and this read 'a' either way.
    ''
    '' The parser puts a LEADING 'do while c' in sp.a and a TRAILING 'loop while c' in
    '' sp.c -- they can both be present, which is why they are separate fields. Reading
    '' only 'a' meant a post-test loop saw NO condition at all and fell to the
    '' unconditional else-branch below:
    ''
    ''     do.head1:  br do.body2
    ''     do.body2:  ... br do.head1
    ''     do.exit3:  <unreachable>
    ''
    '' -- an infinite loop, for EVERY 'loop while' and 'loop until' in the language.
    '' Measured: 'do : i += 1 : loop while i < 10' prints 10 under fbc and never
    '' terminates under tiko, while the pre-test spellings were right all along.
    ''
    '' Nothing caught it because no golden asserts a post-test loop's RUNTIME
    '' behaviour and the IR it produces is perfectly well formed -- the verifier has
    '' nothing to object to. build/runscan.sh found it as a 30-second timeout in
    '' scopes/dtor_eol_eof2.bas.
    dim as Tko.NodeId condE = sp->a
    if postCond then condE = sp->c

    c.curBlock = headB
    if condE <> Tko.NODE_NONE then
        '' A UDT temporary made by the CONDITION dies here, not at the end of the
        '' loop: the head runs again on every iteration and the slot is the same one.
        dim as long umark = c.udtTemps.Count
        dim as MirValue cond = LowerCondition( c, condE )
        ReleaseUdtTemps_( c, umark )
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
    c.loopKind.Push( cast( long, Tko.KW_DO ) )
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


sub LowerIf _
    ( byref c as Ctx, byval id as Tko.NodeId, byval sp as Tko.StmtPayload ptr )

    '' The branches hang off a list of N_IF_BRANCH, each with its own condition; the
    '' ELSE body is 'c'.
    dim as Tko.NodeId branches = sp->b
    if branches = Tko.NODE_NONE then
        SkipHere( c )
        return
    end if
    dim as Tko.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, branches )].data )]

    dim as long joinB = NewBlock( c, "if.join" )
    for i as long = 0 to lp->count - 1
        dim as Tko.NodeId br = cast( Tko.NodeId, c.ast->children[lp->first + i] )
        if c.ast->Kind( br ) <> Tko.N_IF_BRANCH then continue for
        dim as Tko.StmtPayload ptr bp = StmtOf( c, br )
        dim as long thenB = NewBlock( c, "if.then" )
        dim as long elseB = NewBlock( c, "if.else" )
        '' A CONDITION THAT WOULD NOT LOWER IS A DECLINE. It used to go out as
        '' 'condbr _, then, else' -- a conditional branch with NO CONDITION -- which
        '' the verifier passes and a backend cannot mean anything by. The IF counted as
        '' fully lowered while its test had vanished, which is the worst of the three
        '' outcomes and is how 'if a + b = c' looked for as long as a concatenation
        '' could not be compared.
        ''
        '' The branch still goes out, to the THEN side: an unconditional entry is no
        '' more wrong than a missing condition and keeps the block graph well formed,
        '' and the decline beside it is what says the test is missing.
        dim as MirValue cond = LowerCondition( c, bp->a )
        if cond.kind = cast( ubyte, MV_NONE ) then
            SkipHere( c )
            Terminate( c, MTERM_BR, thenB, -1, NoVal( ) )
        else
            Terminate( c, MTERM_CONDBR, thenB, elseB, cond )
        end if
        '' AN ARM IS A SCOPE, and neither of them was one.
        ''
        '' Every other block-forming construct in this compiler brackets its body
        '' with PushScope/CloseScope -- LowerSelect, LowerDo, LowerFor, N_SCOPE, the
        '' loop bodies -- and IF did not. So a destructor or a 'defer' registered
        '' inside an arm stayed on the cleanup list until the PROCEDURE scope closed,
        '' and because nothing popped it BOTH arms' cleanups were still there:
        ''
        ''     if n = 1 then : dim t as Tr : ... : else : dim u as Tr : ... : end if
        ''
        '' printed 'then-body|after-if~T~T' where fbc prints 'then-body~T|after-if'.
        '' The second destructor ran over an object that was NEVER CONSTRUCTED, and
        '' over a type holding a string that is a release of a descriptor nothing
        '' wrote -- the probe crashed. Measured against fbc, which destroys at the
        '' END OF THE ARM, before the statement after the IF.
        c.curBlock = thenB
        PushScope( c )
        LowerBlock( c, bp->b )
        CloseScope( c )
        Terminate( c, MTERM_BR, joinB, -1, NoVal( ) )
        c.curBlock = elseB
    next

    '' ...AND THE ELSE BODY, for the same reason.
    if sp->c <> Tko.NODE_NONE then
        PushScope( c )
        LowerBlock( c, sp->c )
        CloseScope( c )
    end if
    Terminate( c, MTERM_BR, joinB, -1, NoVal( ) )
    c.curBlock = joinB
end sub

end namespace
