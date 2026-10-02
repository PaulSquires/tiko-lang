'' staticthis.bas -- 'this', OR A FIELD BY ITSELF, IN A MEMBER THAT HAS NO OBJECT (T41).
''
'' Included from latesweeps2.bas, below constcall.bas, in the same namespace and over the
'' same Ctx.
''
'' 'operator new' and 'operator delete' -- and their [] forms -- are static: in 'new' the
'' object does not exist yet, in 'delete' it is already destroyed. So is a 'static' method.
'' Measured on fbc-modern 1.20, 2026-10-02, in each of them: 'this.n' is error 42,
'' "Variable not declared, this", a bare field 'n' is 215, and '@this' is 14. tiko
'' compiled them and read garbage -- 884317728 for 'print this.n' in an 'operator new'.
'' A field through a real object, and anything in an ordinary method, is untouched.
''
'' WHICH NODES ARE IN THE BODY: the parser makes a procedure's node AFTER everything in it,
'' so a top-level procedure's subtree is exactly the ids between its previous sibling and
'' itself. Check records no scope on an identifier, so this is how the enclosing procedure
'' is known.

'' The member a procedure node defines, when it has no object: 'static', or operator
'' new / new[] / delete / delete[]. The modifier is on the DECLARATION inside the type.
private function StaticMemberProc_ ( byref c as Ctx, byval pn as NodeId ) as Symbol ptr
    dim as StmtPayload ptr pp = @c.ast->stmts[cast( long, c.ast->nodes[cast( long, pn )].data )]
    dim as Symbol ptr ds = c.syms->SymbolAt( c.info->RefOf( pn ) )
    if ds = 0 then return 0
    if ds->kind <> cast( ubyte, SYM_PROC ) then return 0
    dim as boolean isStatic = ((pp->extra and PF_STATIC) <> 0)
    dim as NodeId dn = cast( NodeId, ds->payload )
    if (dn <> NODE_NONE) andalso (c.ast->Kind( dn ) = N_PROC) then
        if (c.ast->stmts[cast( long, c.ast->nodes[cast( long, dn )].data )].extra and PF_STATIC) <> 0 then isStatic = true
    end if
    if pp->op = cast( ushort, KW_OPERATOR ) then
        select case lcase( c.names->Spelling( ds->name ) )
        case "new", "new[]", "delete", "delete[]"
            isStatic = true
        end select
    end if
    '' A MEMBER: its symbol lives in a type's scope. A plain 'static sub' at module level
    '' has no object to miss.
    if isStatic = false then return 0
    dim as SymScope ptr ps = c.syms->ScopeAt( ds->parent )
    if (ps = 0) orelse (ps->kind <> cast( ubyte, SCOPEK_TYPE )) then return 0
    return ds
end function

private sub StaticThisRange_ _
    ( byref c as Ctx, byval lo as long, byval hi as long, byval sm as Symbol ptr, _
      byref memberRhs as FB.Array( of ubyte ) )
    for n as long = lo to hi - 1
        dim as NodeId id = cast( NodeId, n )
        if c.ast->Kind( id ) <> N_IDENT then continue for
        if memberRhs[n] <> 0 then continue for
        dim as string nm = lcase( c.names->Spelling( c.ast->idents[cast( long, c.ast->nodes[n].data )].name ) )
        if nm <> "this" then
            dim as Symbol ptr fs = c.syms->SymbolAt( c.info->RefOf( id ) )
            if fs = 0 then continue for
            if fs->kind <> cast( ubyte, SYM_FIELD ) then continue for
            if (fs->flags and (SYMF_STATIC or SYMF_SHARED)) <> 0 then continue for
        end if
        c.diags->Report( TKO0937, PointRange( c.ast->Loc( id ) ), nm, c.names->Spelling( sm->name ) )
    next
end sub

'' One statement list -- the module's, a namespace's, an extern block's -- with 'prev' the id
'' of whatever was made just before its first member.
private sub StaticThisList_ _
    ( byref c as Ctx, byval first_ as long, byval count_ as long, byref prev as long, _
      byref memberRhs as FB.Array( of ubyte ) )
    for i as long = 0 to count_ - 1
        dim as NodeId ch = cast( NodeId, c.ast->children[first_ + i] )
        if ch = NODE_NONE then continue for
        select case c.ast->Kind( ch )
        case N_PROC
            dim as Symbol ptr sm = StaticMemberProc_( c, ch )
            if sm <> 0 then StaticThisRange_( c, prev + 1, cast( long, ch ), sm, memberRhs )
        case N_NAMESPACE, N_EXTERN_BLOCK
            dim as StmtPayload ptr np = @c.ast->stmts[cast( long, c.ast->nodes[cast( long, ch )].data )]
            StaticThisList_( c, np->first, np->count, prev, memberRhs )
        end select
        if cast( long, ch ) > prev then prev = cast( long, ch )
    next
end sub

private sub CheckStaticThis_ ( byref c as Ctx )
    dim as long total = c.ast->Count( )
    if c.root = NODE_NONE then return
    '' A NAME AFTER '.' OR '->' IS A MEMBER OF THAT OBJECT, not a bare field.
    dim as FB.Array( of ubyte ) memberRhs
    for n as long = 0 to total
        memberRhs.Push( 0 )
    next
    for n as long = 1 to total - 1
        if c.ast->Kind( cast( NodeId, n ) ) <> N_MEMBER then continue for
        dim as NodeId r = c.ast->binaries[cast( long, c.ast->nodes[n].data )].rhs
        if (r > 0) andalso (cast( long, r ) < total) then memberRhs[cast( long, r )] = 1
    next
    if c.ast->Kind( c.root ) <> N_MODULE then return
    dim as ListPayload ptr ml = @c.ast->lists[cast( long, c.ast->nodes[cast( long, c.root )].data )]
    dim as long prev = 0
    StaticThisList_( c, ml->first, ml->count, prev, memberRhs )
end sub
