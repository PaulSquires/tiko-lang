'' resolvesynth.bas -- the two types Resolve SYNTHESISES: a 'spawn' frame and a
'' capturing lambda's closure. Both are named by the parser and built here, because
'' only this pass can see what their fields' types are.
''
'' Split out of resolve.bas at the 1500-line cap and INCLUDED from it, inside the
'' same namespace. Nothing moved here changed in the move.

'' THE CLOSURE TYPE OF A CAPTURING LAMBDA, built HERE because this is the only pass
'' that can see both halves: the captures' types are only knowable in the scope the
'' lambda was WRITTEN in, and the type has to live at module level for the hoisted
'' invoke procedure to name it.
''
'' One '__CAP_<NAME>' field per capture -- a POINTER for byref and the value INLINE
'' for byval -- which is what fbc emits. Built the way TupleUdtFor builds its own:
'' a symbol, a scope and its fields, with no AST behind it.
''
'' '__fbinvoke' is declared in the type's scope so a CALL on a closure object can
'' find the procedure from the OBJECT, which is the only thing the call site has.
'' THE FRAME TYPE FOR A 'spawn', named by the parser and built here for the same
'' reason the closure type is: only this pass can see the CALLEE's declaration from
'' the spawn site's scope, and the type has to live at module level for the hoisted
'' thunk to name it.
''
'' ITS FIELDS ARE THE CALLEE'S PARAMETER TYPES, one '__ARG_k' each. fbc parameterises
'' its frame on the ARGUMENT types instead and converts inside the invoke -- measured,
'' 'spawn worker( 7 )' over 'worker( byval n as long )' stores an INTEGER and calls
'' 'WORKER( (int32)*(int64*)(THIS + 8) )' -- which for a value argument is the same
'' copy either way. Taking the parameter's type puts the conversion at the spawn,
'' where the argument expression still is.
''
'' NOTHING IS BUILT UNLESS EVERY PART IS KNOWN: a unique callee of matching arity,
'' every parameter BYVAL, and every parameter type already resolved. A frame with a
'' missing or guessed field would be an argument copied to the wrong offset, which is
'' worse than the decline this leaves behind.
''
'' A BYREF PARAMETER IS fbc's ERROR 358 (TKO0812), and it was a SILENT decline: the
'' spawn vanished and only '--dump-ir' said "statements not lowered". fbc checks it
'' before the arguments, on the FIRST-DECLARED procedure of the name -- measured on
'' fbc-modern 1.20, 2026-09-24:
''
''     sub W( byref x as long )             spawn W( k )        358
''     sub W( x as string ) / ( x as U )    by default byref    358
''     sub W( byval x as string )                               accepted
''     sub W( byref x as long = 3 )         spawn W( )          358, not the arity
''     W( byval long ) declared first, W( byref string, long ) second: spawn W( k )
''                                                              accepted
''     ...the same two declared the other way round             358
''
'' The flag is Resolve's for a parameter with neither keyword (resolvetype.bas), and the
'' callee is declared above the spawn, which is fbc's rule too, so it is set by now.
private function SpawnByrefParam_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byval scope_ as Tko.ScopeId ) as boolean

    '' The callee's name: the desugared form keeps it in 'aliasName', and 'spawn W' with no
    '' parentheses is not desugared at all -- its bare name is in 'a'. fbc asks for the '('
    '' AFTER this check, so that form is 358 too.
    dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
    dim as Tko.InternId cnm = sp->aliasName
    if (cnm = 0) andalso (sp->a <> Tko.NODE_NONE) then cnm = IdentNameOf( c, sp->a )
    if cnm = 0 then return false
    dim as Tko.Symbol ptr hs = c.syms->SymbolAt( c.syms->Lookup( scope_, cnm ) )
    if hs = 0 then return false
    if hs->kind <> cast( ubyte, Tko.SYM_PROC ) then return false
    dim as Tko.NodeId pn = cast( Tko.NodeId, hs->payload )
    if pn = Tko.NODE_NONE then return false
    if c.ast->Kind( pn ) <> Tko.N_PROC then return false
    dim as Tko.StmtPayload ptr pp = StmtOf( c, pn )
    for i as long = 0 to pp->count - 1
        dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp->first + i] )
        if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
        if (c.ast->nodes[cast( long, prm )].flags and Tko.NF_BYREF) = 0 then continue for
        c.diags->Report( Tko.TKO0812, Tko.PointRange( c.ast->Loc( id ) ), _
                         c.names->Spelling( hs->name ), _
                         c.names->Spelling( StmtOf( c, prm )->name ) )
        c.diags->AddNote( Tko.TKO0901, Tko.PointRange( c.ast->Loc( prm ) ) )
        return true
    next
    return false
end function

private sub BuildSpawnFrame_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byval scope_ as Tko.ScopeId )

    if SpawnByrefParam_( c, id, scope_ ) then return
    dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
    if sp->name = 0 then return
    if sp->aliasName = 0 then return
    if c.syms->LookupLocalTyped( Tko.SCOPE_GLOBAL, sp->name, true ) <> Tko.SYMBOL_NONE then
        return
    end if

    '' THE OVERLOAD OF MATCHING ARITY, uniquely or not at all.
    dim as Tko.SymbolId pick = Tko.SYMBOL_NONE
    dim as long hits = 0
    dim as Tko.SymbolId cur = c.syms->Lookup( scope_, sp->aliasName )
    while cur <> Tko.SYMBOL_NONE
        dim as Tko.Symbol ptr cs = c.syms->SymbolAt( cur )
        if cs = 0 then exit while
        if cs->kind <> cast( ubyte, Tko.SYM_PROC ) then exit while
        dim as Tko.NodeId pn = cast( Tko.NodeId, cs->payload )
        if pn <> Tko.NODE_NONE then
            if c.ast->Kind( pn ) = Tko.N_PROC then
                dim as Tko.StmtPayload ptr pp = StmtOf( c, pn )
                dim as long np = 0
                for i as long = 0 to pp->count - 1
                    dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp->first + i] )
                    if c.ast->Kind( prm ) = Tko.N_PARAM then np += 1
                next
                if np = cast( long, sp->extra ) then
                    pick = cur
                    hits += 1
                end if
            end if
        end if
        cur = cs->nextOverload
    wend
    if hits <> 1 then return

    dim as Tko.Symbol ptr ps = c.syms->SymbolAt( pick )
    dim as Tko.NodeId pnode = cast( Tko.NodeId, ps->payload )
    dim as Tko.StmtPayload ptr pp2 = StmtOf( c, pnode )
    dim as FB.Array( of ulong ) fTy
    for i as long = 0 to pp2->count - 1
        dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp2->first + i] )
        if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
        '' A BYREF PARAMETER WOULD MAKE THE FRAME HOLD AN ADDRESS into a stack
        '' frame the goroutine outlives. fbc has no such case in the corpus and
        '' inventing one here would be inventing a lifetime.
        if (c.ast->nodes[cast( long, prm )].flags and Tko.NF_BYREF) <> 0 then return
        dim as Tko.TypeId pt = c.info->TypeOf_( StmtOf( c, prm )->a )
        if pt = Tko.TYPE_NONE then return
        if c.types->Kind( pt ) = Tko.TK_REFERENCE then return
        fTy.Push( cast( ulong, pt ) )
    next
    if fTy.Count <> cast( long, sp->extra ) then return

    dim as boolean dup = false
    dim as Tko.SourceLoc at = c.ast->Loc( id )
    dim as Tko.SymbolId tsid = c.syms->DeclareSym( _
        Tko.SCOPE_GLOBAL, sp->name, Tko.SYM_UDT, at, dup )
    dim as Tko.Symbol ptr ts = c.syms->SymbolAt( tsid )
    if ts = 0 then return
    dim as Tko.ScopeId tin = c.syms->OpenScope( _
        Tko.SCOPEK_TYPE, Tko.SCOPE_GLOBAL, tsid )
    ts->inner = tin
    ts->type_ = c.types->NamedType( Tko.TK_UDT, sp->name, cast( ulong, Tko.SCOPE_GLOBAL ) )
    for k as long = 0 to fTy.Count - 1
        dim as Tko.InternId fnm = c.names->Fold( c.names->GetString( _
            "__ARG_" & trim( str( k ) ) ) )
        dim as boolean fdup = false
        dim as Tko.SymbolId fsid = c.syms->DeclareSym( tin, fnm, Tko.SYM_FIELD, at, fdup )
        dim as Tko.Symbol ptr fs = c.syms->SymbolAt( fsid )
        if fs <> 0 then fs->type_ = cast( Tko.TypeId, fTy[k] )
    next
    c.info->SetType( id, ts->type_ )
end sub

private sub BuildClosureType_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byval scope_ as Tko.ScopeId )

    dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
    if sp->name = 0 then return
    if c.syms->LookupLocalTyped( Tko.SCOPE_GLOBAL, sp->name, true ) <> Tko.SYMBOL_NONE then
        return
    end if

    '' EVERY CAPTURE MUST RESOLVE, or the type is not built at all: a closure with a
    '' missing field would lower to an object whose body reads the wrong offsets.
    ''
    '' ...BUT A 'var' IS RESOLVED WITHOUT A TYPE (T74). 'var total = 0' is typed by
    '' Check, so its capture's field is left TYPE_NONE here and filled in by Check's
    '' CompleteClosureFields_, before its walk and long before the layout pass. Without
    '' that the type was never built, the invoke procedure's receiver was 'void', and
    '' clang refused the module.
    dim as FB.Array( of ulong ) fTy
    for k as long = 0 to sp->count - 1
        dim as Tko.NodeId cn = cast( Tko.NodeId, c.ast->children[sp->first + k] )
        if c.ast->Kind( cn ) <> Tko.N_IDENT then return
        dim as Tko.SymbolId csid = c.syms->LookupTyped( scope_, IdentNameOf( c, cn ), false )
        dim as Tko.Symbol ptr cs = c.syms->SymbolAt( csid )
        '' A CAPTURE THAT NAMES NOTHING is reported where it is written (T73): fbc's
        '' error 354, as the TKO0743 every other undeclared name gets. Left silent, the
        '' error surfaced at some use in the body -- or, with none, as a 'void'
        '' parameter clang refused.
        if cs = 0 then
            NoteUnbound_( c, cn, scope_ )
            return
        end if
        dim as Tko.TypeId ct = cs->type_
        c.info->SetRef( cn, csid )
        if ct = Tko.TYPE_NONE then
            if cs->kind <> cast( ubyte, Tko.SYM_VARIABLE ) then return
            fTy.Push( cast( ulong, Tko.TYPE_NONE ) )
            continue for
        end if
        if c.types->Kind( ct ) = Tko.TK_REFERENCE then ct = c.types->Inner( ct )
        c.info->SetType( cn, ct )
        if (c.ast->nodes[cast( long, cn )].flags and Tko.NF_BYREF) <> 0 then
            ct = c.types->Pointer_( ct )
        end if
        fTy.Push( cast( ulong, ct ) )
    next

    dim as boolean dup = false
    dim as Tko.SourceLoc at = c.ast->Loc( id )
    dim as Tko.SymbolId tsid = c.syms->DeclareSym( _
        Tko.SCOPE_GLOBAL, sp->name, Tko.SYM_UDT, at, dup )
    dim as Tko.Symbol ptr ts = c.syms->SymbolAt( tsid )
    if ts = 0 then return
    dim as Tko.ScopeId tin = c.syms->OpenScope( _
        Tko.SCOPEK_TYPE, Tko.SCOPE_GLOBAL, tsid )
    ts->inner = tin
    ts->type_ = c.types->NamedType( Tko.TK_UDT, sp->name, cast( ulong, Tko.SCOPE_GLOBAL ) )
    for k as long = 0 to sp->count - 1
        dim as Tko.NodeId cn = cast( Tko.NodeId, c.ast->children[sp->first + k] )
        dim as Tko.InternId fnm = c.names->Fold( c.names->GetString( _
            "__CAP_" & c.names->Spelling( IdentNameOf( c, cn ) ) ) )
        dim as boolean fdup = false
        dim as Tko.SymbolId fsid = c.syms->DeclareSym( tin, fnm, Tko.SYM_FIELD, at, fdup )
        dim as Tko.Symbol ptr fs = c.syms->SymbolAt( fsid )
        if fs <> 0 then fs->type_ = cast( Tko.TypeId, fTy[k] )
    next

    '' THE INVOKE PROCEDURE, reachable from the TYPE. Its own module-level symbol is
    '' declared by Collect like any other hoisted lambda; this is a second name for
    '' the same N_PROC, so nothing is emitted twice.
    if sp->a <> Tko.NODE_NONE then
        dim as Tko.InternId inm = c.names->Fold( c.names->GetString( "__fbinvoke" ) )
        dim as boolean idup = false
        dim as Tko.SymbolId isid = c.syms->DeclareSym( tin, inm, Tko.SYM_PROC, at, idup )
        dim as Tko.Symbol ptr isy = c.syms->SymbolAt( isid )
        '' ITS PAYLOAD IS THE MODULE-LEVEL SYMBOL, not the node. The hoisted lambda
        '' already has one -- Collect declared it like any other procedure -- and
        '' that is what carries the type and the mangled name. Looked up from HERE
        '' because the lambda site's scope chain reaches the module and a later
        '' pass's does not.
        if isy <> 0 then
            isy->payload = cast( ulong, c.syms->Lookup( _
                scope_, StmtOf( c, sp->a )->name ) )
        end if
    end if

    c.info->SetType( id, ts->type_ )
end sub