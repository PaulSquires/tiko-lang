'' branchcross.bas -- A GOTO THAT JUMPS OVER A DEFINITION NEEDING CONSTRUCTION, fbc's error 105:
''
''     error 105: Branch crossing local array, var-len string or object definition, to label: L
''
'' Included from latesweeps2.bas, below recursivetype.bas, in the same namespace and over the
'' same Ctx. CheckBranchCross_ is asked of every N_GOTO.
''
'' Measured on fbc-modern 1.20, 2026-09-28. Reported on the GOTO's line, once for each variable
'' crossed:
''
''     goto L : dim as string s : L:                     a var-len string, with or without '='
''     goto L : var s = "abc" : L:                       ...inferred
''     goto L : dim as long a( 0 to 3 ) : L:             any local array, fixed, dynamic, REDIM
''     goto L : dim as U x : L:                          U with a constructor, a vtable
''                                                       (EXTENDS OBJECT) or a field needing one
''     goto L : scope : dim as string s : L: : end scope into the definition's scope
''     sub F( ) : goto L : dim as string s : L:          the same inside a procedure
''
'' and accepted:
''
''     an integer, a pointer, a 'zstring * 8' or 'string * 8', a UDT with none of the above
''     (a destructor ALONE is not one); a SHARED or STATIC variable; a backward jump; a jump
''     out of the definition's scope, or over a scope that has closed; 'on n goto'.
''
'' tiko accepted every one, and at the label a string or an object nobody constructed was in
'' scope. The walk is by node id, which is source order, and by the scopes Collect recorded.
''
'' NOT HERE: a GOTO into a SELECT CASE over a string, or into a FOR over a UDT, crosses the
'' TEMPORARY those statements define -- scopes/branch-cross-select-case-*.bas and
'' branch-cross-for-udt-*.bas. That is owed.

'' THE PROCEDURE a scope belongs to: its nearest ancestor that is not a block.
private function BxProcScope_ ( byref c as Ctx, byval s as ScopeId ) as ScopeId
    dim as ScopeId cur = s
    for guard as long = 0 to 4095
        if cur = SCOPE_NONE then exit for
        dim as SymScope ptr ss = c.syms->ScopeAt( cur )
        if ss = 0 then exit for
        if ss->kind <> SCOPEK_BLOCK then return cur
        cur = ss->parent
    next
    return SCOPE_NONE
end function

'' Is 'outer' the scope 'inner' is, or one of its ancestors?
private function BxHolds_ ( byref c as Ctx, byval outer as ScopeId, byval inner as ScopeId ) as boolean
    dim as ScopeId cur = inner
    for guard as long = 0 to 4095
        if cur = SCOPE_NONE then exit for
        if cur = outer then return true
        dim as SymScope ptr ss = c.syms->ScopeAt( cur )
        if ss = 0 then exit for
        cur = ss->parent
    next
    return false
end function

'' Does this item, which declares its own variable, need constructing?
private function BxNeedsCtor_ _
    ( byref c as Ctx, byval item as NodeId, byval s as Symbol ptr ) as boolean
    if (c.ast->nodes[cast( long, item )].flags and NF_ARRAY) <> 0 then return true
    if (s->flags and SYMF_REDIM) <> 0 then return true
    dim as TypeId t = c.types->Unqualify( s->type_ )
    if t = TYPE_NONE then return false
    if c.types->IsDynArray( t ) then return true
    if c.types->Kind( t ) = TK_BUILTIN then
        select case c.types->BuiltinOf( t )
        case TY_STRING, TY_USTRING : return true
        end select
        return false
    end if
    return TcNeedsCtor_( c, t, 0 )
end function

private sub CheckBranchCross_ ( byref c as Ctx, byval id as NodeId )
    '' THE LABELS AND THE LOCAL DEFINITIONS, in node order, once per tree.
    static as long lab( ), vars( )
    static as long nLab, nVar
    static as any ptr forAst = 0
    static as long forCount = -1
    dim as long n = c.ast->Count( )
    if (forAst <> cast( any ptr, c.ast )) orelse (forCount <> n) then
        redim lab( 0 to 15 ) : redim vars( 0 to 15 )
        nLab = 0 : nVar = 0
        for i as long = 1 to n
            dim as NodeKind ik = c.ast->Kind( cast( NodeId, i ) )
            if ik = N_LABEL then
                if nLab > ubound( lab ) then redim preserve lab( 0 to nLab * 2 )
                lab( nLab ) = i : nLab += 1
            elseif ik = N_VAR then
                dim as StmtPayload ptr vp = @c.ast->stmts[cast( long, c.ast->nodes[i].data )]
                select case cast( TokenKind, vp->op )
                case KW_DIM, KW_VAR, KW_REDIM
                case else
                    continue for
                end select
                if (c.ast->nodes[i].flags and (NF_SHARED or NF_STATIC)) <> 0 then continue for
                if nVar > ubound( vars ) then redim preserve vars( 0 to nVar * 2 )
                vars( nVar ) = i : nVar += 1
            end if
        next
        forAst = c.ast : forCount = n
    end if

    dim as StmtPayload ptr gp = @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if gp->name = 0 then return
    dim as ScopeId gproc = BxProcScope_( c, c.info->ScopeOf( id ) )
    '' The label: FORWARD, in the same procedure.
    dim as long lid = 0
    for i as long = 0 to nLab - 1
        if lab( i ) <= id then continue for
        dim as StmtPayload ptr lp = @c.ast->stmts[cast( long, c.ast->nodes[lab( i )].data )]
        if lp->name <> gp->name then continue for
        if BxProcScope_( c, c.info->ScopeOf( cast( NodeId, lab( i ) ) ) ) <> gproc then continue for
        lid = lab( i )
        exit for
    next
    if lid = 0 then return
    dim as ScopeId lscope = c.info->ScopeOf( cast( NodeId, lid ) )
    for v as long = 0 to nVar - 1
        dim as long vid = vars( v )
        if vid <= id then continue for
        if vid >= lid then exit for
        dim as ScopeId vscope = c.info->ScopeOf( cast( NodeId, vid ) )
        if BxHolds_( c, vscope, lscope ) = false then continue for
        dim as StmtPayload ptr vp = @c.ast->stmts[cast( long, c.ast->nodes[vid].data )]
        for j as long = 0 to vp->count - 1
            dim as NodeId it = cast( NodeId, c.ast->children[vp->first + j] )
            if (it < 1) orelse (c.ast->Kind( it ) <> N_VAR_ITEM) then continue for
            dim as StmtPayload ptr ip = @c.ast->stmts[cast( long, c.ast->nodes[cast( long, it )].data )]
            dim as Symbol ptr s = c.syms->SymbolAt( c.syms->LookupLocal( vscope, ip->name ) )
            if s = 0 then continue for
            '' ONLY A DEFINITION: a REDIM of an array declared earlier defines nothing here.
            if cast( NodeId, s->payload ) <> it then continue for
            if BxNeedsCtor_( c, it, s ) = false then continue for
            c.diags->Report( TKO0880, PointRange( c.ast->Loc( id ) ), _
                c.names->Spelling( gp->name ), c.names->Spelling( ip->name ) )
        next
    next
end sub
