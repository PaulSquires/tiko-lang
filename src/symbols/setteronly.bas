'' setteronly.bas -- READING A PROPERTY THAT HAS ONLY A SETTER (T35).
''
'' Included from latesweeps2.bas, below anyptrderef.bas, in the same namespace and over
'' the same Ctx.
''
'' Measured on fbc-modern 1.20, 2026-10-02, over a type declaring only 'property P( byval
'' v as long )' and only 'property Q( byval i as long, byval v as long )': 'gx.P = 5' and
'' 'gx.Q( 1 ) = 3' set; 'dim n as long = gx.P', 'print gx.P', 'n = gx.P + 1' and '.P'
'' inside a 'with' are error 1, "Argument count mismatch", and 'print gx.Q( 1 )' is 196.
'' tiko compiled every read: the value was 0 or garbage, and a print item truncated its
'' statement. A property with a getter beside the setter reads as before.

'' Every overload of the property is a setter: a property procedure with no result.
private function SetterOnly_ ( byref c as Ctx, byval sid as SymbolId ) as boolean
    dim as Symbol ptr s = c.syms->SymbolAt( sid )
    if s = 0 then return false
    if s->kind <> cast( ubyte, SYM_PROC ) then return false
    dim as SymbolId cur = c.syms->LookupLocal( s->parent, s->name )
    if cur = SYMBOL_NONE then cur = sid
    dim as boolean anyProp = false
    for guard as long = 0 to 255
        dim as Symbol ptr os = c.syms->SymbolAt( cur )
        if os = 0 then exit for
        if os->kind = cast( ubyte, SYM_PROC ) then
            dim as NodeId pn = cast( NodeId, os->payload )
            if (pn = NODE_NONE) orelse (c.ast->Kind( pn ) <> N_PROC) then return false
            if c.ast->stmts[cast( long, c.ast->nodes[cast( long, pn )].data )].op <> cast( ushort, KW_PROPERTY ) then return false
            if os->type_ <> TYPE_NONE then return false
            anyProp = true
        end if
        cur = os->nextOverload
    next
    return anyProp
end function

private sub CheckSetterOnlyReads_ ( byref c as Ctx )
    dim as long total = c.ast->Count( )
    '' A STATEMENT'S TARGET IS NOT A READ: 'gx.P = 5', 'gx.Q( 1 ) = 3', and a call statement.
    dim as FB.Array( of ubyte ) isTarget
    for n as long = 0 to total
        isTarget.Push( 0 )
    next
    for n as long = 1 to total - 1
        if c.ast->Kind( cast( NodeId, n ) ) <> N_AMBIGUOUS then continue for
        dim as NodeId a = c.ast->stmts[cast( long, c.ast->nodes[n].data )].a
        if (a <= 0) orelse (cast( long, a ) >= total) then continue for
        isTarget[cast( long, a )] = 1
        if c.ast->Kind( a ) = N_CALL then
            dim as NodeId ct = c.ast->lists[cast( long, c.ast->nodes[cast( long, a )].data )].target
            if (ct > 0) andalso (cast( long, ct ) < total) then isTarget[cast( long, ct )] = 1
        end if
    next
    for n as long = 1 to total - 1
        dim as NodeId id = cast( NodeId, n )
        if c.ast->Kind( id ) <> N_MEMBER then continue for
        if isTarget[n] <> 0 then continue for
        dim as SymbolId sid = c.info->RefOf( id )
        if sid = SYMBOL_NONE then
            sid = c.info->RefOf( c.ast->binaries[cast( long, c.ast->nodes[n].data )].rhs )
        end if
        if sid = SYMBOL_NONE then continue for
        if SetterOnly_( c, sid ) = false then continue for
        c.diags->Report( TKO0934, PointRange( c.ast->Loc( id ) ), c.names->Spelling( c.syms->SymbolAt( sid )->name ) )
    next
end sub
