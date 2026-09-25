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
    c.ast->nodes[cast( long, tg )].flags or= Tko.NF_CALL_TARGET   '' the CALLED name now

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

'' LEN, SIZEOF AND TYPEOF DROP A NAMESPACE PREFIX FROM A PROCEDURE. Their operand may be a
'' type, and 'NS.' may begin one, so fbc tries a type first: that reads the prefix, finds
'' no type, and the expression is then parsed from the name after it -- which a variable
'' honours ('NS.v' is NS's) and a procedure does not: its name is looked up UNQUALIFIED,
'' from here. Measured on fbc-modern 1.20, 2026-09-24:
''
''     print len( FB.Replace( s, "a", "b" ) )     error 42 -- no 'Replace' in view
''     print len( NS.N( ) )     global 'N as short' beside NS's longint    2
''     print len( NS.Twice( t ) )   calls the GLOBAL Twice, not NS's
''     print len( NS.N )        a local 'dim as ubyte N' in view           1
''     len( NS.N( ) ) inside NS, or after 'using NS'                      NS's, 8
''
'' Only the LEADING operand: fbc decides on the first token, so 'NS.N( ) + 1',
'' 'NS.P( )[0]' and 'NS.N( ) = 1' drop the prefix and '-NS.N( )', '( NS.N( ) )',
'' 'cast( long, NS.N( ) )' and '"x" & NS.Twice( t )' keep it. tiko kept it always, so
'' it accepted the first line and measured the wrong procedure in the rest.
''
'' THE QUALIFIED NODE BECOMES THE BARE NAME and is walked again, so it binds whatever an
'' unqualified 'N' binds here -- a procedure, a variable, an array, or nothing, which
'' ReportUndeclared then gives fbc's 42. A TYPE's static member ('U.SF( )', fbc's 7)
'' is another path and not this one.
sub DropNsPrefix_ _
    ( byref c as Ctx, byval opnd as Tko.NodeId, byval scope_ as Tko.ScopeId )

    dim as Tko.NodeId n = opnd, parent = Tko.NODE_NONE
    dim as long guard = 0
    do while (n <> Tko.NODE_NONE) andalso (guard < 256)
        guard += 1
        select case c.ast->Kind( n )
        case Tko.N_BINARY
            parent = Tko.NODE_NONE
            n = c.ast->binaries[cast( long, c.ast->nodes[cast( long, n )].data )].lhs
        case Tko.N_CALL, Tko.N_INDEX
            parent = n
            n = ListOf( c, n )->target
        case Tko.N_MEMBER
            dim as Tko.BinaryPayload ptr mb = _
                @c.ast->binaries[cast( long, c.ast->nodes[cast( long, n )].data )]
            if mb->lhs = Tko.NODE_NONE then return
            dim as Tko.Symbol ptr bs = c.syms->SymbolAt( c.info->RefOf( mb->lhs ) )
            dim as boolean viaNs = false
            if bs <> 0 then viaNs = (bs->kind = cast( ubyte, Tko.SYM_NAMESPACE ))
            if viaNs = false then
                parent = Tko.NODE_NONE
                n = mb->lhs
                continue do
            end if
            if c.ast->Kind( mb->rhs ) <> Tko.N_IDENT then return
            dim as Tko.Symbol ptr ps = c.syms->SymbolAt( c.info->RefOf( mb->rhs ) )
            if ps = 0 then return
            if ps->kind <> cast( ubyte, Tko.SYM_PROC ) then return
            c.ast->nodes[cast( long, n )].kind = cast( ushort, Tko.N_IDENT )
            c.ast->nodes[cast( long, n )].data = c.ast->nodes[cast( long, mb->rhs )].data
            c.info->SetRef( n, Tko.SYMBOL_NONE )
            WalkExpr( c, n, scope_ )
            if parent <> Tko.NODE_NONE then
                if c.ast->Kind( parent ) = Tko.N_CALL then
                    c.info->SetRef( parent, c.info->RefOf( n ) )
                end if
            end if
            return
        case else
            return
        end select
    loop
end sub

'' 'len( x )' / 'sizeof( x )', the builtin -- a user procedure of that name is bound.
private sub LenOperandPrefix_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byval scope_ as Tko.ScopeId )

    dim as Tko.ListPayload ptr lp = ListOf( c, id )
    if (lp->count <> 1) orelse (lp->target = Tko.NODE_NONE) then return
    if c.ast->Kind( lp->target ) <> Tko.N_IDENT then return
    if c.info->RefOf( lp->target ) <> Tko.SYMBOL_NONE then return
    dim as string nm = Tko.Text.LowerAscii( c.names->Spelling( IdentNameOf( c, lp->target ) ) )
    if (nm <> "len") andalso (nm <> "sizeof") then return
    DropNsPrefix_( c, cast( Tko.NodeId, c.ast->children[lp->first] ), scope_ )
end sub

#include once "symbols/resolvertl.bas"
#include once "symbols/resolvestmt.bas"
