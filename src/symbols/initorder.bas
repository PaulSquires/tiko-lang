'' initorder.bas -- A MODULE GLOBAL INITIALISED FROM ONE DECLARED LATER (ADR 0017; RFC-0003
'' §5, TKO0869).
''
'' Included from the end of latesweeps3.bas, in the same namespace and over the same Ctx.
''
'' A module's declarations have no order, but its 'dim shared' initialisers still run in
'' textual order, files in sorted order: 'dim shared a as T = T( b.v )' above 'dim shared b
'' as T = T( 3 )' would construct a from b before b was constructed. Classic code cannot
'' write it -- b is not declared yet there, fbc's error 42 -- and in a module it is TKO0869,
'' the same line drawn with the reason given. Go orders initialisation by dependency
'' instead; that can come later without breaking anything this accepts.

'' The first use in an initialiser of a module global declared below 'item', or NODE_NONE.
private function ReadsLater_ _
    ( byref c as Ctx, byval n as NodeId, byval item as NodeId, byval depth as long ) as NodeId

    if (n = NODE_NONE) orelse (depth > 64) then return NODE_NONE
    select case c.ast->Kind( n )
    case N_IDENT
        dim as Symbol ptr s = c.syms->SymbolAt( c.info->RefOf( n ) )
        if s = 0 then return NODE_NONE
        if s->kind <> cast( ubyte, SYM_VARIABLE ) then return NODE_NONE
        if (s->flags and SYMF_MODSRC) = 0 then return NODE_NONE
        if s->declAt <= cast( ulong, item ) then return NODE_NONE
        return n
    case N_MEMBER
        dim as BinaryPayload ptr mp = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, n )].data )]
        return ReadsLater_( c, mp->lhs, item, depth + 1 )
    case N_BINARY
        dim as BinaryPayload ptr bp = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, n )].data )]
        dim as NodeId l = ReadsLater_( c, bp->lhs, item, depth + 1 )
        if l <> NODE_NONE then return l
        return ReadsLater_( c, bp->rhs, item, depth + 1 )
    case N_UNARY
        dim as UnaryPayload ptr up = _
            @c.ast->unaries[cast( long, c.ast->nodes[cast( long, n )].data )]
        return ReadsLater_( c, up->operand, item, depth + 1 )
    case N_CALL, N_PAREN, N_TUPLE, N_INITIALIZER
        dim as ListPayload ptr lp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, n )].data )]
        if c.ast->Kind( n ) = N_CALL then
            dim as NodeId t = ReadsLater_( c, lp->target, item, depth + 1 )
            if t <> NODE_NONE then return t
        end if
        for i as long = 0 to lp->count - 1
            dim as NodeId e = ReadsLater_( c, _
                cast( NodeId, c.ast->children[lp->first + i] ), item, depth + 1 )
            if e <> NODE_NONE then return e
        next
    end select
    return NODE_NONE
end function

private sub CheckInitOrder_( byref c as Ctx )
    if c.syms->modFileCount = 0 then return
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr s = @c.syms->symbols[i]
        if s->kind <> cast( ubyte, SYM_VARIABLE ) then continue for
        if (s->flags and SYMF_MODSRC) = 0 then continue for
        if (s->flags and SYMF_SHARED) = 0 then continue for
        if s->payload = 0 then continue for
        dim as NodeId item = cast( NodeId, s->payload )
        if c.ast->Kind( item ) <> N_VAR_ITEM then continue for
        dim as StmtPayload ptr ip = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, item )].data )]
        if ip->b = NODE_NONE then continue for
        dim as NodeId leaf = ReadsLater_( c, ip->b, item, 0 )
        if leaf = NODE_NONE then continue for
        dim as Symbol ptr r = c.syms->SymbolAt( c.info->RefOf( leaf ) )
        c.diags->Report( TKO0869, PointRange( c.ast->Loc( leaf ) ), _
                         c.names->Spelling( s->name ), c.names->Spelling( r->name ) )
    next
end sub

'' A CONSTANT CYCLE -- 'const A = B', 'const B = A' -- which a module can write, its
'' constants having no order, and fold never: TKO0867, naming the cycle once, at the first
'' constant of it in declaration order. Classic code cannot write one, the later name being
'' fbc's error 42.
private sub ConstRefs_ _
    ( byref c as Ctx, byval n as NodeId, byval scope_ as ScopeId, _
      byref outv as FB.Array( of ulong ), byval depth as long )

    if (n = NODE_NONE) orelse (depth > 64) then return
    select case c.ast->Kind( n )
    case N_IDENT
        dim as SymbolId sid = c.info->RefOf( n )
        if sid = SYMBOL_NONE then
            sid = c.syms->Lookup( scope_, c.ast->idents[cast( long, c.ast->nodes[cast( long, n )].data )].name )
        end if
        dim as Symbol ptr s = c.syms->SymbolAt( sid )
        if s = 0 then return
        if s->kind <> cast( ubyte, SYM_CONSTANT ) then return
        if (s->flags and SYMF_MODSRC) = 0 then return
        outv.Push( cast( ulong, sid ) )
        outv.Push( cast( ulong, n ) )
    case N_BINARY
        dim as BinaryPayload ptr bp = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, n )].data )]
        ConstRefs_( c, bp->lhs, scope_, outv, depth + 1 )
        ConstRefs_( c, bp->rhs, scope_, outv, depth + 1 )
    case N_UNARY
        dim as UnaryPayload ptr up = _
            @c.ast->unaries[cast( long, c.ast->nodes[cast( long, n )].data )]
        ConstRefs_( c, up->operand, scope_, outv, depth + 1 )
    case N_CALL, N_PAREN, N_TUPLE
        dim as ListPayload ptr lp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, n )].data )]
        for i as long = 0 to lp->count - 1
            ConstRefs_( c, cast( NodeId, c.ast->children[lp->first + i] ), scope_, outv, depth + 1 )
        next
    end select
end sub

private function ConstInit_( byref c as Ctx, byval sid as SymbolId ) as NodeId
    dim as Symbol ptr s = c.syms->SymbolAt( sid )
    if s = 0 then return NODE_NONE
    if s->payload = 0 then return NODE_NONE
    dim as NodeId item = cast( NodeId, s->payload )
    if c.ast->Kind( item ) <> N_VAR_ITEM then return NODE_NONE
    return c.ast->stmts[cast( long, c.ast->nodes[cast( long, item )].data )].b
end function

private sub ConstVisit_ _
    ( byref c as Ctx, byval sid as SymbolId, byref color_ as FB.Array( of ubyte ), _
      byref stack as FB.Array( of ulong ), byref found as boolean )

    if found then return
    color_[cast( long, sid )] = 1
    stack.Push( cast( ulong, sid ) )
    dim as Symbol ptr s = c.syms->SymbolAt( sid )
    dim as FB.Array( of ulong ) refs
    ConstRefs_( c, ConstInit_( c, sid ), s->parent, refs, 0 )
    for q as long = 0 to refs.Count - 2 step 2
        if found then exit for
        dim as ulong r = refs[q]
        if color_[cast( long, r )] = 1 then
            dim as string text_ = ""
            dim as boolean on_ = false
            for each k as ulong in stack
                if k = r then on_ = true
                if on_ then text_ &= c.names->Spelling( c.syms->SymbolAt( cast( SymbolId, k ) )->name ) & " -> "
            next
            text_ &= c.names->Spelling( c.syms->SymbolAt( cast( SymbolId, r ) )->name )
            dim as Symbol ptr rs = c.syms->SymbolAt( cast( SymbolId, r ) )
            c.diags->Report( TKO0867, PointRange( rs->loc ), text_ )
            '' ...AND BROKEN: the name that closes it is left unbound, as the later name
            '' is in classic code, so nothing downstream folds it forever.
            c.info->SetRef( cast( NodeId, refs[q + 1] ), SYMBOL_NONE )
            found = true
        elseif color_[cast( long, r )] = 0 then
            ConstVisit_( c, cast( SymbolId, r ), color_, stack, found )
        end if
    next
    stack.Pop( )
    color_[cast( long, sid )] = 2
end sub

private sub CheckConstCycles_( byref c as Ctx )
    if c.syms->modFileCount = 0 then return
    dim as FB.Array( of ubyte ) color_
    for i as long = 0 to c.syms->symbols.Count - 1
        color_.Push( 0 )
    next
    for i as long = 1 to c.syms->symbols.Count - 1
        dim as Symbol ptr s = @c.syms->symbols[i]
        if s->kind <> cast( ubyte, SYM_CONSTANT ) then continue for
        if (s->flags and SYMF_MODSRC) = 0 then continue for
        if color_[i] <> 0 then continue for
        dim as FB.Array( of ulong ) stack
        dim as boolean found = false
        ConstVisit_( c, cast( SymbolId, i ), color_, stack, found )
    next
end sub
