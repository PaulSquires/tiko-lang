'' resolveunbound.bas -- AN UNBOUND NAME, as Resolve leaves it for Check.ReportUndeclared.
''
'' Included from resolve.bas, inside its namespace, before WalkExpr.

'' Is this scope inside a generic TEMPLATE -- the body of a generic procedure, or of a
'' member of a generic type? A type parameter there is a name nothing declares --
'' 'sizeof( T )' in fb/comptr.bi, 'TK' in fb/map.bi -- until an instantiation re-parses
'' the body and binds it, and the INSTANTIATION is what gets checked: its scopes belong to
'' an instance, which is not a template.
private function InTemplate_( byref c as Ctx, byval scope_ as Tko.ScopeId ) as boolean
    dim as long guard = 0
    while (scope_ <> Tko.SCOPE_NONE) andalso (guard < 256)
        guard += 1
        dim as Tko.SymScope ptr sc = c.syms->ScopeAt( scope_ )
        if sc = 0 then exit while
        dim as Tko.Symbol ptr os = c.syms->SymbolAt( sc->owner )
        if os <> 0 then
            if (os->flags and Tko.SYMF_GENERIC_INST) <> 0 then return false
            dim as Tko.NodeId dn = cast( Tko.NodeId, os->payload )
            dim as boolean isNode = (os->kind = cast( ubyte, Tko.SYM_UDT )) orelse _
                                    (os->kind = cast( ubyte, Tko.SYM_PROC ))
            if isNode andalso (dn > 0) andalso (cast( long, dn ) <= c.ast->Count( )) then
                select case c.ast->Kind( dn )
                case Tko.N_TYPE
                    if StmtOf( c, dn )->b <> Tko.NODE_NONE then return true
                case Tko.N_PROC
                    if (StmtOf( c, dn )->extra and Tko.PF_GENERIC_PROC) <> 0 then return true
                end select
            end if
        end if
        scope_ = sc->parent
    wend
    return false
end function

'' Kept for the report after Check -- which makes it only if nothing types the name by
'' then and it is not a builtin, see undeclared.bas -- unless a template holds it.
private sub NoteUnbound_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byval scope_ as Tko.ScopeId )
    if c.st->unresolvedIds.Count >= 200000 then return
    if InTemplate_( c, scope_ ) then return
    c.st->unresolvedIds.Push( cast( ulong, id ) )
end sub
