'' resolveamb.bas -- an N_AMBIGUOUS statement, resolved into a call or an assignment.
''
'' Split out of resolve.bas at the 1500-line cap and included from it in the same place.


'' The parser's three-way ambiguity, decided now that the target's symbol is known
'' (docs/plan/07 section 8). The payoff is the diagnostic: where fbc reports a syntax
'' error, tiko-lang can say what the name actually is.

'' An array type from a declaration's bounds, or the base type unchanged when there are
'' none.
''
'' THE PARSER SPELLS BOUNDS TWO DIFFERENT WAYS, which is why this takes node lists
'' rather than a payload:
''
''   N_FIELD      flat (lo, hi) children          as long f(0 to 3)
''   N_VAR_ITEM   an N_BLOCK of N_CASE_RANGE      dim as long a(0 to 9)
''
'' Both are collected into (lo, hi) pairs here so the arithmetic exists once. Assuming
'' the field shape for both is what left every LOCAL array typed as its element -- four
'' bytes where forty were needed -- and that went unnoticed only because indexing was
'' not lowered either.
''
'' A missing low bound means 0: 'a(9)' is 'a(0 to 9)'. BOUNDS ARE RETAINED, not just
'' their product, because indexing needs each dimension's stride and its lbound bias.
'' Nothing is folded when any bound is non-constant.
private sub ResolveAmbiguous _
    ( byref c as Ctx, byval id as Tko.NodeId, byval scope_ as Tko.ScopeId )

    dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
    WalkExpr( c, sp->a, scope_ )
    WalkExpr( c, sp->b, scope_ )
    for i as long = 0 to sp->count - 1
        WalkExpr( c, cast( Tko.NodeId, c.ast->children[sp->first + i] ), scope_ )
    next

    dim as boolean isAssign = (sp->op <> 0)

    '' 'function = expr' names no symbol, so it cannot reach the lookup below -- but it
    '' is the SAME statement as 'f = expr' inside f, and both belong in one bucket. The
    '' keyword form used to decline at a different line from the name form, which is
    '' the shape that made 'amb other' mislead for four commits.
    if c.ast->Kind( sp->a ) = Tko.N_FUNCRESULT then
        c.info->SetAmbiguous( id, Tko.AMB_RESULT )
        c.st->assigns += 1
        return
    end if

    '' The target's head symbol: for a.b.c the head is a.
    dim as Tko.NodeId head = sp->a
    dim as long guard = 0
    while guard < 64
        guard += 1
        dim as Tko.NodeKind hk = c.ast->Kind( head )
        if hk = Tko.N_MEMBER then
            head = c.ast->binaries[cast( long, c.ast->nodes[cast( long, head )].data )].lhs
        elseif (hk = Tko.N_CALL) orelse (hk = Tko.N_INDEX) then
            head = ListOf( c, head )->target
        else
            exit while
        end if
    wend

    '' A QUALIFIED name binds on the MEMBER node itself, so prefer that over the head:
    '' for 'ns.Greet( 1 )' the head is the namespace and tells us nothing useful, while
    '' the member resolved to the procedure.
    dim as Tko.SymbolId sid = c.info->RefOf( head )
    if c.ast->Kind( sp->a ) = Tko.N_MEMBER then
        dim as Tko.SymbolId qsid = c.info->RefOf( sp->a )
        if qsid <> Tko.SYMBOL_NONE then sid = qsid
    elseif c.ast->Kind( sp->a ) = Tko.N_CALL then
        dim as Tko.NodeId callee = ListOf( c, sp->a )->target
        if c.ast->Kind( callee ) = Tko.N_MEMBER then
            dim as Tko.SymbolId qsid = c.info->RefOf( callee )
            if qsid <> Tko.SYMBOL_NONE then sid = qsid
        end if
    end if
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( sid )

    if isAssign then
        '' Assigning to the enclosing function name is BASIC's result assignment.
        dim as boolean isResult = (c.currentProc <> Tko.SYMBOL_NONE) andalso _
                                  (sid = c.currentProc)
        if isResult then
            c.info->SetAmbiguous( id, Tko.AMB_RESULT )
        else
            c.info->SetAmbiguous( id, Tko.AMB_ASSIGN )
        end if
        c.st->assigns += 1
        return
    end if

    if s = 0 then
        c.info->SetAmbiguous( id, Tko.AMB_CALL )
        c.st->calls += 1
        return
    end if

    select case cast( Tko.SymbolKind, s->kind )
    case Tko.SYM_PROC
        c.info->SetAmbiguous( id, Tko.AMB_CALL )
        c.st->calls += 1
    case Tko.SYM_UDT, Tko.SYM_ENUM, Tko.SYM_TYPEDEF, Tko.SYM_NAMESPACE
        '' This is the diagnostic the ambiguous node exists to make possible.
        dim as Tko.SourceRange r = Tko.PointRange( c.ast->Loc( id ) )
        c.diags->Report( Tko.TKO0602, r, c.names->Spelling( s->name ), _
                         Tko.SymbolKindName( cast( Tko.SymbolKind, s->kind ) ) )
        c.info->SetAmbiguous( id, Tko.AMB_ERROR )
    case else
        c.info->SetAmbiguous( id, Tko.AMB_CALL )
        c.st->calls += 1
    end select
end sub
