'' resolveintr.bas -- A CALL SPELLED LIKE A BUILTIN, as Resolve leaves it for Check.
''
'' Included from resolve.bas, inside its namespace, before WalkExpr.

'' A CALL SPELLED LIKE A BUILTIN THE INTRINSIC TABLE TYPES (Check.IsTypedIntrinsicName).
''
'' '..NAME( )', AND '.NAME( )' WITH NO WITH OPEN, ARE THE BUILTIN. AfxNova's BSTRING.inc
'' writes '.LEN( t )' to reach the builtin past its own OPERATOR LEN overloads, and fbc runs
'' the builtin (scratchpad afx/p7.bas). The member form reached Check with a target that is
'' not an identifier, the intrinsic table never saw it, and '..len' tied two operators
'' (TKO0660) while '..hex( 255 )', '..val( "42" )' and '..space( 2 )' declined outright.
'' Rewritten AFTER the member is walked: that binds the name in the FILE scope, where a
'' bare 'left' inside a function NAMED Left binds its result and recursed (scratchpad
'' afx/ovA.bas), and where '..space( 2 )' inside a namespace declaring its own 'space'
'' does not find that one -- fbc prints the builtin's two spaces.
''
'' A PROCEDURE IMPORTED BY 'USING' IS NOT SEEN BESIDE THE BUILTIN. Measured: with
'' 'using N' over N's 'hex( byref as string )', fbc answers 'hex( "q" )' with error 99 and
'' over N's 'hex( byval as double )' runs the builtin for 'hex( d )' -- while the same
'' procedure called from INSIDE N is N's, which is a different rule (IntrinsicCallType_).
'' So the binding is dropped when the procedure's namespace does not enclose the call, and
'' Check then types the builtin.
private sub BuiltinCallTarget_ _
    ( byref c as Ctx, byval lp as Tko.ListPayload ptr, byval scope_ as Tko.ScopeId )

    dim as Tko.NodeId tg = lp->target
    if tg = Tko.NODE_NONE then return
    if c.ast->Kind( tg ) = Tko.N_MEMBER then
        dim as Tko.BinaryPayload ptr gmb = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, tg )].data )]
        dim as boolean viaGlobal = false
        if gmb->lhs = Tko.NODE_NONE then
            viaGlobal = (c.withSubject.Count = 0)
        elseif c.ast->Kind( gmb->lhs ) = Tko.N_GLOBALSCOPE then
            viaGlobal = true
        end if
        if (viaGlobal = false) orelse (gmb->rhs = Tko.NODE_NONE) then return
        if c.ast->Kind( gmb->rhs ) <> Tko.N_IDENT then return
        tg = gmb->rhs
    elseif c.ast->Kind( tg ) <> Tko.N_IDENT then
        return
    end if
    dim as string nm = Tko.Text.LowerAscii( c.names->Spelling( IdentNameOf( c, tg ) ) )
    if Check.IsTypedIntrinsicName( nm ) = false then return
    lp->target = tg

    dim as Tko.Symbol ptr bs = c.syms->SymbolAt( c.info->RefOf( tg ) )
    if bs = 0 then return
    if bs->kind <> cast( ubyte, Tko.SYM_PROC ) then return
    dim as Tko.NodeId decl = cast( Tko.NodeId, bs->payload )
    if decl <> Tko.NODE_NONE then
        if c.ast->Kind( decl ) = Tko.N_PROC then
            if c.ast->stmts[cast( long, c.ast->nodes[cast( long, decl )].data )].op = _
               cast( ushort, Tko.KW_OPERATOR ) then return
        end if
    end if
    dim as Tko.SymScope ptr ns = c.syms->ScopeAt( bs->parent )
    if ns = 0 then return
    if ns->kind <> cast( ubyte, Tko.SCOPEK_NAMESPACE ) then return
    dim as Tko.ScopeId sc = scope_
    dim as long guard = 0
    while (sc <> Tko.SCOPE_NONE) andalso (guard < 256)
        guard += 1
        if sc = bs->parent then return
        dim as Tko.SymScope ptr s_ = c.syms->ScopeAt( sc )
        if s_ = 0 then exit while
        sc = s_->parent
    wend
    c.info->SetRef( tg, Tko.SYMBOL_NONE )
end sub
