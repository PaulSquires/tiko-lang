'' selchan.bas -- 'select channel', desugared into the shape fbc builds for it.
''
'' SELECT CHANNEL IS NOT A SELECT CASE. fbc-modern's channel select takes five case
'' forms -- 'receive v from c', 'receive from c' (the DISCARD form), 'send v to c',
'' 'timeout ms' and 'else' -- and lowers them onto the generics in 'fb/select.bi'.
'' Measured, the emitted shape is:
''
''     FB.SelectCtx sc                       one per statement, default-constructed
''     var c<i> = <channel expr>             a channel COPY per receive/send case,
''                                           evaluated in SOURCE ORDER, alive for the
''                                           whole statement
''     v<i>                                  a send's value, in a temp of the CHANNEL'S
''                                           ELEMENT type
''     FB.SelectAddRecv/AddSend/AddRecvDiscard( sc, i, c<i>, dst )
''     sc.SetTimeout( ms ) / sc.SetElse( )   consuming NO case index
''     f = FB.SelectRun( sc )
''     if f = i then
''         if sc.PolledReady( ) then FB.SelectCommitRecv/CommitSend( sc, i, c<i> )
''         <the case body>
''     elseif f = -2 then <timeout body>     SELECT_TIMEOUT
''     elseif f = -3 then <else body>        SELECT_ELSE
''     end if
''     FB.SelectRelease...( sc, i, c<i> )    in REVERSE order, unconditionally
''
'' The COMMIT runs only on the poll path -- on the wake path the counterparty has
'' already moved the value -- which is what the PolledReady guard is for.
''
'' DESUGARED HERE, into ordinary AST, because every piece of it is an ordinary
'' construct this compiler already lowers: the generics being called come from a
'' SOURCE header and instantiate the way any other does, 'var' gives the channel copy
'' its type without naming it, and 'typeof( *c.ElemPtr( ) )' names the element type --
'' which is what ElemPtr exists for, and its own comment in fb/select.bi says so.
'' Hand-written, all five forms lower with nothing left over; that is what made this
'' the cheap way to reach it.
''
'' WHAT FBC REFUSES IS REFUSED HERE, with the same shape of message: no cases at all,
'' a second TIMEOUT or a second ELSE, a case that is not one of the five forms, and a
'' missing FROM or TO.

namespace Tko.Parse

'' Defined in parser.bas, above this file: the contextual-word test every one of
'' FBC-Modern's non-reserved keywords is recognised by.
declare function IsContextual _
    ( byref p as Tko.ParserState, byref word as string ) as boolean

'' The five case forms, in the order the dispatch chain tests them.
const SELCASE_RECV    as long = 0
const SELCASE_SEND    as long = 1
const SELCASE_DISCARD as long = 2
const SELCASE_TIMEOUT as long = 3
const SELCASE_ELSE    as long = 4

'' 'select channel' is spelled with a CONTEXTUAL word: 'channel' is not reserved, so it
'' arrives as an identifier and is recognised by spelling, exactly as 'defer', 'spawn'
'' and 'each' are.
function SelectIsChannel_( byref p as Tko.ParserState ) as boolean
    if Peek( p ) <> Tko.TK_IDENT then return false
    return IsContextual( p, "channel" )
end function


'' One synthesised name, interned FOLDED the way the lexer interns every other --
'' unfolded it would match no lookup.
private function SelName_ _
    ( byref p as Tko.ParserState, byref nm as string ) as Tko.InternId
    return p.names->Fold( p.names->GetString( nm ) )
end function

private function SelIdent_ _
    ( byref p as Tko.ParserState, byval lc as Tko.SourceLoc, byref nm as string ) as Tko.NodeId
    dim as Tko.IdentPayload ip
    ip.name = SelName_( p, nm )
    p.ast->idents.Push( ip )
    return NewNodeAt( p, Tko.N_IDENT, lc, p.ast->idents.Count - 1 )
end function

'' 'a.b' -- and 'FB.Spawn'-style qualified names are the same node.
private function SelDot_ _
    ( byref p as Tko.ParserState, byval lc as Tko.SourceLoc, _
      byval lhs as Tko.NodeId, byref nm as string ) as Tko.NodeId
    dim as Tko.BinaryPayload bp
    bp.op = cast( ushort, Tko.TK_DOT )
    bp.lhs = lhs
    bp.rhs = SelIdent_( p, lc, nm )
    p.ast->binaries.Push( bp )
    return NewNodeAt( p, Tko.N_MEMBER, lc, p.ast->binaries.Count - 1 )
end function

'' 'FB.<name>' as an expression.
private function SelFb_ _
    ( byref p as Tko.ParserState, byval lc as Tko.SourceLoc, byref nm as string ) as Tko.NodeId
    return SelDot_( p, lc, SelIdent_( p, lc, "FB" ), nm )
end function

'' A call, as a STATEMENT: the call-or-assign node every paren-less call already is.
private function SelCallStmt_ _
    ( byref p as Tko.ParserState, byval lc as Tko.SourceLoc, _
      byval callee as Tko.NodeId, byref args as Tko.NodeIdVec ) as Tko.NodeId
    dim as Tko.StmtPayload sp
    sp.a = callee
    sp.first = p.ast->children.Count
    sp.count = args.Count
    for i as long = 0 to args.Count - 1
        p.ast->children.Push( args[i] )
    next
    return MakeStmt( p, Tko.N_AMBIGUOUS, lc, sp )
end function

'' A call, as an EXPRESSION.
private function SelCallExpr_ _
    ( byref p as Tko.ParserState, byval lc as Tko.SourceLoc, _
      byval callee as Tko.NodeId, byref args as Tko.NodeIdVec ) as Tko.NodeId
    return MakeList( p, Tko.N_CALL, lc, callee, args )
end function

'' 'dim as <ty> <nm> = <init>', or 'var <nm> = <init>' when no type is written.
private function SelDim_ _
    ( byref p as Tko.ParserState, byval lc as Tko.SourceLoc, byref nm as string, _
      byval ty as Tko.NodeId, byval init_ as Tko.NodeId, byval isVar as boolean ) as Tko.NodeId
    dim as Tko.StmtPayload item
    item.name = SelName_( p, nm )
    item.a = ty
    item.b = init_
    dim as Tko.NodeIdVec items
    items.Push( cast( ulong, MakeStmt( p, Tko.N_VAR_ITEM, lc, item ) ) )
    dim as Tko.StmtPayload dsp
    dsp.op = cast( ushort, iif( isVar, Tko.KW_VAR, Tko.KW_DIM ) )
    dsp.first = p.ast->children.Count
    dsp.count = items.Count
    for i as long = 0 to items.Count - 1
        p.ast->children.Push( items[i] )
    next
    return MakeStmt( p, Tko.N_VAR, lc, dsp )
end function

'' An integer literal, for the case indices and the two negative sentinels.
private function SelInt_ _
    ( byref p as Tko.ParserState, byval lc as Tko.SourceLoc, byval v as longint ) as Tko.NodeId
    dim as Tko.LiteralPayload lp
    lp.intValue = cast( ulongint, abs( v ) )
    lp.radix = 10
    p.ast->literals.Push( lp )
    dim as Tko.NodeId n = NewNodeAt( p, Tko.N_INT_LIT, lc, p.ast->literals.Count - 1 )
    if v < 0 then
        dim as Tko.UnaryPayload up
        up.op = cast( ushort, Tko.TK_MINUS )
        up.operand = n
        p.ast->unaries.Push( up )
        n = NewNodeAt( p, Tko.N_UNARY, lc, p.ast->unaries.Count - 1 )
    end if
    return n
end function

'' '<lhs> = <rhs>' as a comparison.
private function SelEq_ _
    ( byref p as Tko.ParserState, byval lc as Tko.SourceLoc, _
      byval lhs as Tko.NodeId, byval rhs as Tko.NodeId ) as Tko.NodeId
    dim as Tko.BinaryPayload bp
    bp.op = cast( ushort, Tko.TK_EQ )
    bp.lhs = lhs
    bp.rhs = rhs
    p.ast->binaries.Push( bp )
    return NewNodeAt( p, Tko.N_BINARY, lc, p.ast->binaries.Count - 1 )
end function

'' ONE BRANCH of the dispatch chain: 'f = <n>' guarding a block.
private function SelBranch_ _
    ( byref p as Tko.ParserState, byval lc as Tko.SourceLoc, byval cond as Tko.NodeId, _
      byref items as Tko.NodeIdVec ) as Tko.NodeId
    dim as Tko.StmtPayload br
    br.a = cond
    br.b = MakeList( p, Tko.N_BLOCK, lc, Tko.NODE_NONE, items )
    return MakeStmt( p, Tko.N_IF_BRANCH, lc, br )
end function

'' The whole chain as one N_IF: its 'b' is a BLOCK OF BRANCHES, which is how the
'' parser builds every 'if / elseif / elseif'.
private function SelChain_ _
    ( byref p as Tko.ParserState, byval lc as Tko.SourceLoc, _
      byref branches as Tko.NodeIdVec ) as Tko.NodeId
    dim as Tko.StmtPayload sp
    sp.b = MakeList( p, Tko.N_BLOCK, lc, Tko.NODE_NONE, branches )
    return MakeStmt( p, Tko.N_IF, lc, sp )
end function

'' ---------------------------------------------------------------- the statement
''
'' Each case is kept as five parallel values while the statement is read, because the
'' REGISTRATION order (source order), the DISPATCH order (by index, with the two
'' sentinels last) and the RELEASE order (reverse) are three different walks over it.
function ParseSelectChannel_ _
    ( byref p as Tko.ParserState, byref t as Tko.Token ) as Tko.NodeId

    dim as Tko.SourceLoc lc = t.loc
    Advance( p )                              '' past 'channel'

    dim as FB.Array( of ulong ) kinds
    dim as FB.Array( of ulong ) chans         '' the channel expression
    dim as FB.Array( of ulong ) vals          '' a send's value / a receive's target
    dim as FB.Array( of ulong ) bodies
    dim as Tko.NodeId timeoutMs = Tko.NODE_NONE
    dim as Tko.NodeId timeoutBody = Tko.NODE_NONE
    dim as Tko.NodeId elseBody = Tko.NODE_NONE
    dim as boolean sawTimeout = false
    dim as boolean sawElse = false
    dim as boolean bad = false

    do
        SkipEols( p )
        if Peek( p ) <> Tko.KW_CASE then exit do
        Advance( p )

        if Accept( p, Tko.KW_ELSE ) then
            if sawElse then
                ErrorNode( p, Tko.TKO0417 )
                bad = true
            end if
            sawElse = true
            elseBody = Block( p )
            continue do
        end if

        '' The three contextual words. None of them is reserved, so each is matched
        '' by spelling exactly as 'channel' was.
        dim as boolean isRecv = IsContextual( p, "receive" )
        dim as boolean isSend = IsContextual( p, "send" )
        dim as boolean isTmo  = IsContextual( p, "timeout" )
        if (isRecv orelse isSend orelse isTmo) = false then
            ErrorNode( p, Tko.TKO0415 )
            bad = true
            exit do
        end if
        Advance( p )

        if isTmo then
            if sawTimeout then
                ErrorNode( p, Tko.TKO0417 )
                bad = true
            end if
            sawTimeout = true
            timeoutMs = Expression( p )
            timeoutBody = Block( p )
            continue do
        end if

        if isSend then
            '' 'case send <value> to <channel>'
            dim as Tko.NodeId sv = Expression( p )
            if Accept( p, Tko.KW_TO ) = false then
                ErrorNode( p, Tko.TKO0416, "to" )
                bad = true
                exit do
            end if
            kinds.Push( cast( ulong, SELCASE_SEND ) )
            chans.Push( cast( ulong, Expression( p ) ) )
            vals.Push( cast( ulong, sv ) )
            bodies.Push( cast( ulong, Block( p ) ) )
            continue do
        end if

        '' 'case receive <var> from <channel>', and the DISCARD form with no
        '' variable at all -- 'case receive from ctx.Done( )', which sync.bas writes
        '' three times.
        dim as Tko.NodeId rv = Tko.NODE_NONE
        if IsContextual( p, "from" ) = false then
            if Peek( p ) <> Tko.TK_IDENT then
                ErrorNode( p, Tko.TKO0406 )
                bad = true
                exit do
            end if
            rv = Expression( p, Tko.PREC_POSTFIX )
        end if
        if IsContextual( p, "from" ) = false then
            ErrorNode( p, Tko.TKO0416, "from" )
            bad = true
            exit do
        end if
        Advance( p )
        kinds.Push( cast( ulong, iif( rv = Tko.NODE_NONE, SELCASE_DISCARD, SELCASE_RECV ) ) )
        chans.Push( cast( ulong, Expression( p ) ) )
        vals.Push( cast( ulong, rv ) )
        bodies.Push( cast( ulong, Block( p ) ) )
    loop

    ExpectEnd( p, Tko.KW_SELECT )

    dim as boolean noCases = (kinds.Count = 0)
    if noCases then noCases = (sawTimeout = false)
    if noCases then noCases = (sawElse = false)
    if noCases then
        ErrorNode( p, Tko.TKO0414 )
        bad = true
    end if
    if bad then
        dim as Tko.NodeIdVec empty_
        return MakeList( p, Tko.N_BLOCK, lc, Tko.NODE_NONE, empty_ )
    end if

    '' ---- the desugaring ------------------------------------------------------
    dim as Tko.NodeIdVec body

    '' 'dim as FB.SelectCtx __sc'
    dim as Tko.StmtPayload ctxTy
    ctxTy.name = SelName_( p, "SelectCtx" )
    ctxTy.ownerName = SelName_( p, "FB" )
    body.Push( cast( ulong, SelDim_( p, lc, "__tkosel_sc", _
        MakeStmt( p, Tko.N_TYPEREF, lc, ctxTy ), Tko.NODE_NONE, false ) ) )

    '' ---- registration, in SOURCE ORDER --------------------------------------
    dim as long ci = 0
    for i as long = 0 to kinds.Count - 1
        dim as string cnm = "__tkosel_c" & trim( str( ci ) )
        '' 'var __cN = <channel expr>' -- the channel COPY, whose type is the
        '' channel's and needs no naming.
        body.Push( cast( ulong, SelDim_( p, lc, cnm, Tko.NODE_NONE, _
            cast( Tko.NodeId, chans[i] ), true ) ) )

        dim as Tko.NodeIdVec aargs
        aargs.Push( cast( ulong, SelIdent_( p, lc, "__tkosel_sc" ) ) )
        aargs.Push( cast( ulong, SelInt_( p, lc, ci ) ) )
        aargs.Push( cast( ulong, SelIdent_( p, lc, cnm ) ) )

        dim as string addNm = "SelectAddRecv"
        select case cast( long, kinds[i] )
        case SELCASE_SEND
            '' The value goes in a temp of the CHANNEL'S ELEMENT type, which is
            '' spellable only as 'typeof( *c.ElemPtr( ) )' -- inferring it from the
            '' value instead would conflict with the channel's own T.
            dim as string vnm = "__tkosel_v" & trim( str( ci ) )
            dim as Tko.NodeIdVec noargs
            dim as Tko.NodeId ep = SelCallExpr_( p, lc, _
                SelDot_( p, lc, SelIdent_( p, lc, cnm ), "ElemPtr" ), noargs )
            dim as Tko.UnaryPayload dp
            dp.op = cast( ushort, Tko.TK_STAR )
            dp.operand = ep
            p.ast->unaries.Push( dp )
            dim as Tko.NodeId deref = NewNodeAt( p, Tko.N_DEREF, lc, p.ast->unaries.Count - 1 )
            '' A 'typeof' TYPEREF carries its expression in 'b' and names itself the
            '' way every keyword-spelled type does -- the folded keyword text in
            '' 'name' and the token kind in 'op'.
            dim as Tko.StmtPayload toType
            toType.b = deref
            toType.name = SelName_( p, "typeof" )
            toType.op = cast( ushort, Tko.KW_TYPEOF )
            dim as Tko.NodeId tyN = MakeStmt( p, Tko.N_TYPEREF, lc, toType )
            body.Push( cast( ulong, SelDim_( p, lc, vnm, tyN, _
                cast( Tko.NodeId, vals[i] ), false ) ) )
            aargs.Push( cast( ulong, SelIdent_( p, lc, vnm ) ) )
            addNm = "SelectAddSend"
        case SELCASE_RECV
            aargs.Push( vals[i] )
        case else
            addNm = "SelectAddRecvDiscard"
        end select
        body.Push( cast( ulong, SelCallStmt_( p, lc, SelFb_( p, lc, addNm ), aargs ) ) )
        ci += 1
    next

    '' SetTimeout and SetElse consume NO case index -- measured, 'sc.n' stays where
    '' the receive and send cases left it.
    if sawTimeout then
        dim as Tko.NodeIdVec targs
        targs.Push( cast( ulong, timeoutMs ) )
        body.Push( cast( ulong, SelCallStmt_( p, lc, _
            SelDot_( p, lc, SelIdent_( p, lc, "__tkosel_sc" ), "SetTimeout" ), targs ) ) )
    end if
    if sawElse then
        dim as Tko.NodeIdVec eargs
        body.Push( cast( ulong, SelCallStmt_( p, lc, _
            SelDot_( p, lc, SelIdent_( p, lc, "__tkosel_sc" ), "SetElse" ), eargs ) ) )
    end if

    '' 'dim as long __f = FB.SelectRun( __sc )'
    dim as Tko.NodeIdVec rargs
    rargs.Push( cast( ulong, SelIdent_( p, lc, "__tkosel_sc" ) ) )
    dim as Tko.StmtPayload longTy
    longTy.name = SelName_( p, "long" )
    longTy.op = cast( ushort, Tko.KW_LONG )
    body.Push( cast( ulong, SelDim_( p, lc, "__tkosel_f", _
        MakeStmt( p, Tko.N_TYPEREF, lc, longTy ), _
        SelCallExpr_( p, lc, SelFb_( p, lc, "SelectRun" ), rargs ), false ) ) )

    '' ---- the dispatch chain -------------------------------------------------
    dim as Tko.NodeIdVec branches
    ci = 0
    for i as long = 0 to kinds.Count - 1
        dim as string cnm = "__tkosel_c" & trim( str( ci ) )
        dim as Tko.NodeIdVec items
        '' THE COMMIT RUNS ONLY ON THE POLL PATH: on the wake path the counterparty
        '' has already moved the value, and committing again would move a second.
        dim as Tko.NodeIdVec cargs
        cargs.Push( cast( ulong, SelIdent_( p, lc, "__tkosel_sc" ) ) )
        cargs.Push( cast( ulong, SelInt_( p, lc, ci ) ) )
        cargs.Push( cast( ulong, SelIdent_( p, lc, cnm ) ) )
        dim as string comNm = "SelectCommitRecv"
        if cast( long, kinds[i] ) = SELCASE_SEND then comNm = "SelectCommitSend"
        dim as Tko.NodeIdVec guardItems
        guardItems.Push( cast( ulong, SelCallStmt_( p, lc, SelFb_( p, lc, comNm ), cargs ) ) )
        dim as Tko.NodeIdVec prArgs
        dim as Tko.NodeIdVec guardBranches
        guardBranches.Push( cast( ulong, SelBranch_( p, lc, _
            SelCallExpr_( p, lc, _
                SelDot_( p, lc, SelIdent_( p, lc, "__tkosel_sc" ), "PolledReady" ), prArgs ), _
            guardItems ) ) )
        items.Push( cast( ulong, SelChain_( p, lc, guardBranches ) ) )
        items.Push( bodies[i] )
        branches.Push( cast( ulong, SelBranch_( p, lc, _
            SelEq_( p, lc, SelIdent_( p, lc, "__tkosel_f" ), SelInt_( p, lc, ci ) ), items ) ) )
        ci += 1
    next
    if sawTimeout then
        dim as Tko.NodeIdVec titems
        titems.Push( cast( ulong, timeoutBody ) )
        branches.Push( cast( ulong, SelBranch_( p, lc, _
            SelEq_( p, lc, SelIdent_( p, lc, "__tkosel_f" ), SelInt_( p, lc, -2 ) ), titems ) ) )
    end if
    if sawElse then
        dim as Tko.NodeIdVec eitems
        eitems.Push( cast( ulong, elseBody ) )
        branches.Push( cast( ulong, SelBranch_( p, lc, _
            SelEq_( p, lc, SelIdent_( p, lc, "__tkosel_f" ), SelInt_( p, lc, -3 ) ), eitems ) ) )
    end if
    if branches.Count > 0 then
        body.Push( cast( ulong, SelChain_( p, lc, branches ) ) )
    end if

    '' ---- the releases, in REVERSE registration order ------------------------
    for i as long = kinds.Count - 1 to 0 step -1
        dim as string cnm = "__tkosel_c" & trim( str( i ) )
        dim as Tko.NodeIdVec relArgs
        relArgs.Push( cast( ulong, SelIdent_( p, lc, "__tkosel_sc" ) ) )
        relArgs.Push( cast( ulong, SelInt_( p, lc, i ) ) )
        relArgs.Push( cast( ulong, SelIdent_( p, lc, cnm ) ) )
        dim as string relNm = "SelectReleaseRecv"
        if cast( long, kinds[i] ) = SELCASE_SEND then relNm = "SelectReleaseSend"
        body.Push( cast( ulong, SelCallStmt_( p, lc, SelFb_( p, lc, relNm ), relArgs ) ) )
    next

    '' A SCOPE, so the context, the channel copies and the send temporaries are
    '' destroyed at the end of the statement and cannot collide with a second
    '' select in the same procedure.
    dim as Tko.StmtPayload scp
    scp.b = MakeList( p, Tko.N_BLOCK, lc, Tko.NODE_NONE, body )
    return MakeStmt( p, Tko.N_SCOPE, lc, scp )
end function

end namespace
