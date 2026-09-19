'' resolveunbound.bas -- AN UNBOUND NAME, as Resolve leaves it for Check.ReportUndeclared,
'' and a name declared BELOW its use, which Resolve leaves unbound on purpose.
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

'' A NAME DECLARED BELOW ITS USE is fbc's error 42, as if it were never declared: fbc
'' reads a file once, top to bottom, and a declaration it has not reached yet does not
'' exist. Collect declares everything before Resolve binds anything, so 'x = 1 : dim as
'' integer x' bound the later x and compiled. Measured 2026-09-19, fbc-modern 1.20 and
'' 1.10.1 agreeing, every one error 42: a variable, a local, a STATIC, a VAR, an array, a
'' REDIM, EXTERN and COMMON; a CONST and an enum constant; a SUB or FUNCTION called or
'' taken with '@'; 'sizeof' and 'len' of a TYPE, an ENUM or a type alias; a namespace;
'' and each of those from a procedure or method body written above the declaration.
''
'' What a use DOES see is the declaration's own initialiser -- 'dim as integer v = v + 1'
'' compiles, which is why Symbol.declAt is the lowest node the declaration owns -- and a
'' procedure, type, enum or namespace from inside ITSELF: recursion, a function's result,
'' 'sizeof( T )' in a field of T.
private function DeclaredBelow_ _
    ( byref c as Ctx, byval sid as Tko.SymbolId, byval use as Tko.NodeId, _
      byval scope_ as Tko.ScopeId ) as boolean
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( sid )
    if s = 0 then return false
    if s->declAt = 0 then return false
    if cast( ulong, use ) >= s->declAt then return false
    dim as long guard = 0
    while (scope_ <> Tko.SCOPE_NONE) andalso (guard < 256)
        guard += 1
        dim as Tko.SymScope ptr sc = c.syms->ScopeAt( scope_ )
        if sc = 0 then exit while
        if sc->owner = sid then return false
        scope_ = sc->parent
    wend
    '' ...OR TEXTUALLY INSIDE IT, which the scopes do not always say. The parser turns
    '' 'spawn nested( depth - 1 )' inside sub 'nested' into a THUNK of its own at module
    '' level, so the recursive call is in no scope of 'nested' -- but its nodes were built
    '' while the body was read, after the SUB keyword and below the procedure's own node:
    '' concurrency/sched.bas, which fbc compiles. Same file, at or past the keyword.
    select case cast( Tko.SymbolKind, s->kind )
    case Tko.SYM_PROC, Tko.SYM_UDT, Tko.SYM_ENUM, Tko.SYM_NAMESPACE
        if c.srcMgr <> 0 then
            dim as Tko.DecodedLoc dd = c.srcMgr->Decode( c.ast->Loc( cast( Tko.NodeId, s->declAt ) ) )
            dim as Tko.DecodedLoc du = c.srcMgr->Decode( c.ast->Loc( use ) )
            if (dd.file = du.file) andalso (du.offset >= dd.offset) then return false
        end if
    end select
    return true
end function

'' The symbol a use at 'use' can see: 'sid' itself, or -- when that one is declared below
'' the use -- whatever the same name means past it, which is what fbc binds. So the walk
'' LookupTyped makes is made again, passing over what is declared below: each scope's own
'' names, then its USINGs, then the next scope out.
''
''     dim x : namespace N : ... print x ... : dim x : end namespace    the module's x
''     scope : using ns_a : print foo : ... : dim as integer foo        ns_a.foo
''
'' The second is namespace/dups_fail.bas: going straight to the enclosing scope skipped
'' the USING, which belongs to the SCOPE block that also holds the later local.
private function VisibleValue_ _
    ( byref c as Ctx, byval got as Tko.SymbolId, byval use as Tko.NodeId, _
      byval scope_ as Tko.ScopeId ) as boolean
    if got = Tko.SYMBOL_NONE then return false
    select case cast( Tko.SymbolKind, c.syms->SymbolAt( got )->kind )
    case Tko.SYM_UDT, Tko.SYM_TYPEDEF
        return false
    end select
    return (DeclaredBelow_( c, got, use, scope_ ) = false)
end function

private function VisibleAbove_ _
    ( byref c as Ctx, byval sid as Tko.SymbolId, byval use as Tko.NodeId, _
      byval scope_ as Tko.ScopeId, byval nm as Tko.InternId ) as Tko.SymbolId
    if sid = Tko.SYMBOL_NONE then return sid
    if DeclaredBelow_( c, sid, use, scope_ ) = false then return sid
    dim as Tko.ScopeId sc = scope_
    dim as long guard = 0
    while (sc <> Tko.SCOPE_NONE) andalso (guard < 256)
        guard += 1
        dim as Tko.SymbolId got = c.syms->LookupLocalTyped( sc, nm, false )
        if VisibleValue_( c, got, use, scope_ ) then return got
        for i as long = 0 to c.syms->usingAt.Count - 1
            if c.syms->usingAt[i] <> cast( ulong, sc ) then continue for
            got = c.syms->LookupInNamespaceTyped( _
                cast( Tko.ScopeId, c.syms->usingInner[i] ), nm, false, 0 )
            if VisibleValue_( c, got, use, scope_ ) then return got
        next
        dim as Tko.SymScope ptr ss = c.syms->ScopeAt( sc )
        if ss = 0 then exit while
        sc = ss->parent
    wend
    '' ...OR, WITH NO VALUE LEFT, A TYPE of that spelling -- LookupTyped's own fallback,
    '' which the hidden value had pre-empted. 'return Stamp.FromTicks( 0 )' in a method
    '' of type Stamp, above a module-level 'declare function stamp', names the TYPE:
    '' tests/mir/udt-arg-shapes.bas, which fbc compiles.
    dim as Tko.SymbolId t = c.syms->LookupTyped( scope_, nm, true )
    if t = Tko.SYMBOL_NONE then return Tko.SYMBOL_NONE
    select case cast( Tko.SymbolKind, c.syms->SymbolAt( t )->kind )
    case Tko.SYM_UDT, Tko.SYM_ENUM, Tko.SYM_TYPEDEF
    case else
        return Tko.SYMBOL_NONE
    end select
    if DeclaredBelow_( c, t, use, scope_ ) then return Tko.SYMBOL_NONE
    return t
end function

'' A TYPE NAMED ABOVE ITS DECLARATION -- 'dim as TL t' before 'type TL'. fbc refuses
'' every one, measured 2026-09-19 on 1.20 and 1.10.1: error 14 in a DIM, a field, a
'' result, over a typedef and over an enum, 59 in a parameter, 17 in a CAST -- behind a
'' PTR as well. tiko-lang binds it anyway (LookupTypeAtPoint_: an incomplete type the
'' revisit machinery finishes) and still does, so nothing downstream changes; this only
'' reports it.
''
'' What fbc DOES take: a type naming itself inside its own body ('nxt as TN ptr'), and
'' the FORWARD DECLARATION 'type TF as TF_' -- a typedef's own target may come later,
'' which is the whole point of the idiom. Once per reference: the revisit machinery
'' resolves a typeref more than once, and the first time is the one with no binding yet.
private sub ForwardTypeRef_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byval sid as Tko.SymbolId, _
      byval scope_ as Tko.ScopeId )
    if c.info->RefOf( id ) = sid then exit sub
    if InTemplate_( c, scope_ ) then exit sub
    if DeclaredBelow_( c, sid, id, scope_ ) = false then exit sub
    for i as long = 0 to c.typedefNode.Count - 1
        dim as Tko.NodeId t = StmtOf( c, cast( Tko.NodeId, c.typedefNode[i] ) )->a
        dim as long guard = 0
        while (t <> Tko.NODE_NONE) andalso (guard < 64)
            guard += 1
            if t = id then exit sub
            if c.ast->Kind( t ) <> Tko.N_TYPEREF then exit while
            t = StmtOf( c, t )->a
        wend
    next
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( sid )
    c.diags->Report( Tko.TKO0784, Tko.PointRange( c.ast->Loc( id ) ), c.names->Spelling( s->name ) )
    c.diags->AddNote( Tko.TKO0901, Tko.PointRange( s->loc ) )
end sub
