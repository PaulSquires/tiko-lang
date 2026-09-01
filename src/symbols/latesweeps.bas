'' latesweeps.bas -- THE AST SWEEPS OF THE POST-CHECK PASS THAT RUN AFTER THE WALK.
''
'' Split out of visibility.bas at the 1500-line lint cap and included from it, inside its
'' namespace: these are ordinary members of that pass and share its Ctx. What they have in
'' common is that each sweeps the WHOLE AST once rather than being hooked into Walk_,
'' because each asks about a declaration whose answer is not in the node the walk reaches.

'' A NAMESPACE CANNOT BE ADDED TO FROM OUTSIDE IT -- fbc error 158, "Declaration outside
'' the original namespace or class". DEFINING something the namespace already declared is
'' the ordinary and accepted use; introducing a NEW name is not.
''
'' MEASURED, and the accepted half is what makes the rule narrow enough to be safe:
''     namespace a : declare sub f1( ) : end namespace
''     sub a.f1( ) : end sub                              OK    -- a DEFINITION
''     namespace a : extern s as string : end namespace
''     dim a.s as string                                  OK    -- likewise
''     namespace a : end namespace
''     sub a.f1( ) : end sub                              error 158
''     dim a.s as integer                                 error 131
''
'' So the test is "does that namespace already have this name", and nothing finer. fbc
'' separates a re-DECLARATION from a definition and gives 158 for the former even when the
'' name is there; that distinction is not modelled, and missing it costs an accepted file,
'' not a wrong one.
private function NamespaceScopeOf_ _
    ( byref c as Ctx, byval path as InternId ) as ScopeId

    if path = 0 then return SCOPE_NONE
    dim as string qp = c.names->Spelling( path )
    '' THE FIRST COMPONENT IS FOUND IN THE SYMBOL TABLE, not from SCOPE_GLOBAL: a
    '' file's namespaces live in the MODULE scope, which is a child of the global one and
    '' which nothing here holds a handle to. Only an UNAMBIGUOUS match counts -- two
    '' namespaces of one name under different parents would make the wrong scope the
    '' answer, and a wrong scope here means refusing a file fbc accepts.
    dim as long firstDot = instr( qp, "." )
    dim as long firstEnd = firstDot
    if firstEnd = 0 then firstEnd = len( qp ) + 1
    dim as InternId head = c.names->GetString( left( qp, firstEnd - 1 ) )
    dim as ScopeId sc = SCOPE_NONE
    dim as long hits = 0
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr ns = @c.syms->symbols[i]
        if ns->kind <> cast( ubyte, SYM_NAMESPACE ) then continue for
        if c.names->Fold( ns->name ) <> c.names->Fold( head ) then continue for
        hits += 1
        sc = ns->inner
    next
    if (hits <> 1) orelse (sc = SCOPE_NONE) then return SCOPE_NONE
    if firstDot = 0 then return sc
    dim as long at = firstDot
    dim as long guard = 0
    while (at <= len( qp )) andalso (guard < 64)
        guard += 1
        dim as long dot = instr( at + 1, qp, "." )
        dim as long stop_ = dot
        if stop_ = 0 then stop_ = len( qp ) + 1
        dim as string comp = mid( qp, at + 1, stop_ - at - 1 )
        if len( comp ) = 0 then return SCOPE_NONE
        dim as SymbolId sid = _
            c.syms->LookupLocal( sc, c.names->Fold( c.names->GetString( comp ) ) )
        dim as Symbol ptr sym = c.syms->SymbolAt( sid )
        if sym = 0 then return SCOPE_NONE
        '' ONLY A NAMESPACE. A TYPE's members are a different rule with a different error,
        '' and answering for one here would report the other's shape.
        if sym->kind <> cast( ubyte, SYM_NAMESPACE ) then return SCOPE_NONE
        if sym->inner = SCOPE_NONE then return SCOPE_NONE
        sc = sym->inner
        if dot = 0 then return sc
        at = dot
    wend
    return SCOPE_NONE
end function

private sub CheckOutsideNamespace_( byref c as Ctx )
    for n as long = 0 to c.ast->Count( ) - 1
        dim as NodeId id = cast( NodeId, n )
        dim as NodeKind k = c.ast->Kind( id )
        if (k <> N_PROC) andalso (k <> N_VAR_ITEM) then continue for
        if (c.ast->nodes[n].flags and NF_QUALIFIED) = 0 then continue for
        dim as StmtPayload ptr sp = _
            @c.ast->stmts[cast( long, c.ast->nodes[n].data )]
        dim as ScopeId ns = NamespaceScopeOf_( c, sp->ownerName )
        if ns = SCOPE_NONE then continue for
        dim as SymbolId have = c.syms->LookupLocal( ns, c.names->Fold( sp->name ) )
        if have <> SYMBOL_NONE then continue for
        c.diags->Report( TKO0669, PointRange( c.ast->Loc( id ) ), _
                         c.names->Spelling( sp->ownerName ) & "." & _
                         c.names->Spelling( sp->name ) )
    next
end sub

'' 'const N = lbound( a )' OVER A DYNAMIC ARRAY -- fbc error 11, "Expected constant". A
'' fixed array's bounds are known and fold; a dynamic one has none until it is
'' redimensioned, and a BYDESC parameter's arrive with the descriptor at run time, which
'' is the same thing here and is why one is typed as a dynamic array.
''
'' HERE AND NOT IN RESOLVE, where the sibling test on the DIMENSION argument lives: that
'' walk is what gives a declaration its type, so during it the array's symbol has none
'' yet and IsDynArray said no to every one of them.
''
'' IT REPORTS ONLY WHAT IT CAN POSITIVELY ESTABLISH. Asking "did the fold succeed" instead
'' measured THIS compiler's folder against fbc's: tiko-lang does not fold lbound of a
'' FIXED array either, and that refused three lines fbc accepts.
private sub CheckConstBounds_( byref c as Ctx )
    for n as long = 0 to c.ast->Count( ) - 1
        if c.ast->Kind( cast( NodeId, n ) ) <> N_CONST then continue for
        dim as StmtPayload ptr sp = _
            @c.ast->stmts[cast( long, c.ast->nodes[n].data )]
        for i as long = 0 to sp->count - 1
            dim as NodeId item = cast( NodeId, c.ast->children[sp->first + i] )
            if c.ast->Kind( item ) <> N_VAR_ITEM then continue for
            dim as StmtPayload ptr ip = _
                @c.ast->stmts[cast( long, c.ast->nodes[cast( long, item )].data )]
            if ip->b = NODE_NONE then continue for
            if c.ast->Kind( ip->b ) <> N_CALL then continue for
            dim as ListPayload ptr lp = _
                @c.ast->lists[cast( long, c.ast->nodes[cast( long, ip->b )].data )]
            if lp->target = NODE_NONE then continue for
            if c.ast->Kind( lp->target ) <> N_IDENT then continue for
            '' A USER SYMBOL OF THAT NAME IS NOT THE INTRINSIC.
            if c.info->RefOf( lp->target ) <> SYMBOL_NONE then continue for
            dim as string spell = c.names->Spelling( _
                c.ast->idents[cast( long, c.ast->nodes[cast( long, lp->target )].data )].name )
            if (spell <> "lbound") andalso (spell <> "ubound") then continue for
            if lp->count < 1 then continue for
            dim as NodeId arr = cast( NodeId, c.ast->children[lp->first] )
            dim as Symbol ptr asym = c.syms->SymbolAt( c.info->RefOf( arr ) )
            if asym = 0 then continue for
            if c.types->IsDynArray( asym->type_ ) = false then continue for
            c.diags->Report( TKO0674, PointRange( c.ast->Loc( ip->b ) ) )
        next
    next
end sub

