'' branchtarget.bas -- statements whose target must exist where they are written (T95).
''
'' Included from latesweeps2.bas, in the same namespace, and run from RunLateSweeps2_.
''
'' EXIT AND CONTINUE NEED A BLOCK OF THEIR KIND AROUND THEM. Measured on fbc-modern 1.20:
''
''     exit for, continue for      outside any FOR          error 239
''     exit do, continue do        outside any DO           error 240
''     exit while                  outside any WHILE        error 241
''     exit select                 outside any SELECT       error 242
''     exit sub / function         outside one              errors 253 / 254
''     exit property / operator / constructor               errors 193 / 144 / 165
''     exit for, for               inside only one FOR      error 247, "No outer FOR"
''
'' A procedure is a wall: an 'exit for' in a SUB called from a loop is still outside one.
'' tiko-lang compiled every one of them -- the loop exits to nothing -- and the module-level
'' 'exit sub' family went on to emit IR that clang refused.
''
'' A GOTO NEEDS ITS LABEL IN THE SAME PROCEDURE, module-level code counting as one: fbc's
'' error 48, "Undefined label", or 104, "Branching to other functions or to module-level".
'' tiko-lang compiled a 'goto' to a label that did not exist, and the program ran on.
''
'' 'exit scope' is refused by fbc too, but differently (its error 251), and is not judged here.

'' The block an EXIT or CONTINUE keyword names, as the diagnostic spells it.
private function BtBlockName_( byval kw as TokenKind ) as string
    select case kw
    case KW_FOR         : return "a FOR loop"
    case KW_DO          : return "a DO loop"
    case KW_WHILE       : return "a WHILE loop"
    case KW_SELECT      : return "a SELECT"
    case KW_SUB         : return "a SUB"
    case KW_FUNCTION    : return "a FUNCTION"
    case KW_PROPERTY    : return "a PROPERTY"
    case KW_OPERATOR    : return "an OPERATOR"
    case KW_CONSTRUCTOR : return "a CONSTRUCTOR"
    case KW_DESTRUCTOR  : return "a DESTRUCTOR"
    end select
    return ""
end function

private sub BtExit_ _
    ( byref c as Ctx, byval id as NodeId, byval procKw as TokenKind, _
      byval nFor as long, byval nDo as long, byval nWhile as long, byval nSel as long )
    dim as StmtPayload ptr sp = @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    dim as TokenKind kw = cast( TokenKind, sp->op )
    dim as string what = BtBlockName_( kw )
    if len( what ) = 0 then return
    dim as long have = 0
    select case kw
    case KW_FOR    : have = nFor
    case KW_DO     : have = nDo
    case KW_WHILE  : have = nWhile
    case KW_SELECT : have = nSel
    case else
        have = iif( kw = procKw, 1, 0 )
    end select
    dim as string stmt = iif( c.ast->Kind( id ) = N_EXIT, "exit ", "continue " ) & lcase( TokenKindText( kw ) )
    dim as long want = sp->extra
    if want < 1 then want = 1
    if have = 0 then
        c.diags->Report( TKO0947, PointRange( c.ast->Loc( id ) ), stmt, what )
    elseif have < want then
        c.diags->Report( TKO0948, PointRange( c.ast->Loc( id ) ), stmt, mid( what, instr( what, " " ) + 1 ) )
    end if
end sub

'' The labels a procedure's body (or the module-level code) defines. Not into a procedure.
private sub BtLabels_ ( byref c as Ctx, byval id as NodeId, byref labels as containers.Array( of ulong ) )
    if id = NODE_NONE then return
    dim as NodeKind k = c.ast->Kind( id )
    if (NodeKindCategory( k ) = NCAT_EXPR) orelse (NodeKindCategory( k ) = NCAT_TYPE) then return
    if k = N_PROC then return
    if (k = N_MODULE) orelse (k = N_BLOCK) then
        dim as ListPayload ptr lp = @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
        for i as long = 0 to lp->count - 1
            BtLabels_( c, cast( NodeId, c.ast->children[lp->first + i] ), labels )
        next
        return
    end if
    dim as StmtPayload ptr sp = @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if k = N_LABEL then labels.Push( cast( ulong, sp->name ) ) : return
    BtLabels_( c, sp->a, labels )
    BtLabels_( c, sp->b, labels )
    BtLabels_( c, sp->c, labels )
    for i as long = 0 to sp->count - 1
        BtLabels_( c, cast( NodeId, c.ast->children[sp->first + i] ), labels )
    next
end sub

private sub BtWalk_ _
    ( byref c as Ctx, byval id as NodeId, byval procKw as TokenKind, _
      byval nFor as long, byval nDo as long, byval nWhile as long, byval nSel as long, _
      byref labels as containers.Array( of ulong ) )
    if id = NODE_NONE then return
    dim as NodeKind k = c.ast->Kind( id )
    if (NodeKindCategory( k ) = NCAT_EXPR) orelse (NodeKindCategory( k ) = NCAT_TYPE) then return
    if k = N_PROC then return
    select case k
    case N_FOR, N_FOREACH : nFor += 1
    case N_DO             : nDo += 1
    case N_WHILE          : nWhile += 1
    case N_SELECT         : nSel += 1
    case N_EXIT, N_CONTINUE
        BtExit_( c, id, procKw, nFor, nDo, nWhile, nSel )
        return
    end select
    if (k = N_MODULE) orelse (k = N_BLOCK) then
        dim as ListPayload ptr lp = @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
        for i as long = 0 to lp->count - 1
            BtWalk_( c, cast( NodeId, c.ast->children[lp->first + i] ), procKw, _
                     nFor, nDo, nWhile, nSel, labels )
        next
        return
    end if
    dim as StmtPayload ptr sp = @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if k = N_GOTO then
        if sp->name = 0 then return
        for each l as ulong in labels
            if l = cast( ulong, sp->name ) then return
        next
        c.diags->Report( TKO0949, PointRange( c.ast->Loc( id ) ), c.names->Spelling( sp->name ) )
        return
    end if
    BtWalk_( c, sp->a, procKw, nFor, nDo, nWhile, nSel, labels )
    BtWalk_( c, sp->b, procKw, nFor, nDo, nWhile, nSel, labels )
    BtWalk_( c, sp->c, procKw, nFor, nDo, nWhile, nSel, labels )
    for i as long = 0 to sp->count - 1
        BtWalk_( c, cast( NodeId, c.ast->children[sp->first + i] ), procKw, _
                 nFor, nDo, nWhile, nSel, labels )
    next
end sub

private sub CheckBranchTargets_( byref c as Ctx )
    '' Module-level code: the root, with every procedure left to the loop below.
    if c.root <> NODE_NONE then
        dim as containers.Array( of ulong ) top
        BtLabels_( c, c.root, top )
        BtWalk_( c, c.root, cast( TokenKind, 0 ), 0, 0, 0, 0, top )
    end if
    for n as long = 0 to c.ast->Count( ) - 1
        if c.ast->Kind( cast( NodeId, n ) ) <> N_PROC then continue for
        dim as StmtPayload ptr pp = @c.ast->stmts[cast( long, c.ast->nodes[n].data )]
        if pp->b = NODE_NONE then continue for
        dim as containers.Array( of ulong ) labels
        BtLabels_( c, pp->b, labels )
        BtWalk_( c, pp->b, cast( TokenKind, pp->op ), 0, 0, 0, 0, labels )
    next
end sub
