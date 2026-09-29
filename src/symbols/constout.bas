'' constout.bas -- A CONSTANT AS A RUNTIME STATEMENT'S OUTPUT: CheckConstOutput_, asked of every
'' N_INTRINSIC and N_AMBIGUOUS.
''
'' Included from latesweeps2.bas, below branchcross.bas, in the same namespace and over the same
'' Ctx.
''
'' Measured on fbc-modern 1.20, 2026-09-29, each over a 'dim as const ...' variable:
''
''     get #1, , fp               error 119, "Cannot modify a constant"   the variable GET reads into
''     get (0,0)-(0,0), arr       error 119                                the array GET fills
''     input #1, v   input v      error 119                                every variable INPUT sets
''     line input #1, s / s       error 119
''     lset s, "x"                error 119
''     read v                     error 181, "Invalid assignment/conversion"
''     clear a, 0, n              error 181, at parameter 1              a byref parameter, in a
''     getjoystick id, b, a1      error 181, at parameter 2              call without parentheses
''
'' tiko accepted every one. A const FILE NUMBER, a const GET position and 'put #1, , v' over a
'' const are fbc's -- only what the statement WRITES is judged. The call-with-parentheses half of
'' the last two rows is assigncheck.bas's (TKO0699); this is the paren-less half.

'' A CONSTANT, or an array of them.
private function ConstOut_ ( byref c as Ctx, byval n as NodeId ) as boolean
    if n = NODE_NONE then return false
    dim as TypeId t = c.info->TypeOf_( n )
    if t = TYPE_NONE then return false
    if c.types->Kind( t ) = TK_REFERENCE then t = c.types->Inner( t )
    if c.types->IsConst( t ) then return true
    t = c.types->Unqualify( t )
    if (c.types->Kind( t ) = TK_ARRAY) orelse c.types->IsDynArray( t ) then
        dim as TypeId et = c.types->Inner( t )
        if et <> TYPE_NONE then return c.types->IsConst( et )
    end if
    return false
end function

'' A GRAPHICS GET'S BUFFER AS AN ELEMENT REACHED THROUGH A CALL -- fbc's error 28, "Expected
'' pointer". Measured on fbc-modern 1.20, 2026-09-29 (gfx/image-expr-sidefx-1..3):
''
''     get (0,0)-(31,31), f1( @x )->array( 0 )      error 28     f1 returns a pointer
''     get (0,0)-(31,31), f3( x ).array( 0 )        error 28     byref or byval result
''     ...x.array( 0 ), px->array( 0 ), (*px).array( 0 ), ba( 0 ), ba, img, f1( @x )    fine
''     put (0,0), f1( @x )->array( 0 )             fine -- PUT only reads
''
'' fbc evaluates an element's base twice for GET, and a call there has side effects, so it
'' refuses. tiko accepted each. Does 'n' reach its value through a procedure call?
private function ThroughCall_ ( byref c as Ctx, byval n as NodeId ) as boolean
    for guard as long = 0 to 63
        if n = NODE_NONE then return false
        select case c.ast->Kind( n )
        case N_PAREN
            n = Unparen3_( c, n )
        case N_MEMBER
            n = c.ast->binaries[cast( long, c.ast->nodes[cast( long, n )].data )].lhs
        case N_DEREF
            n = c.ast->unaries[cast( long, c.ast->nodes[cast( long, n )].data )].operand
        case N_CALL
            dim as NodeId tg = c.ast->lists[cast( long, c.ast->nodes[cast( long, n )].data )].target
            if tg = NODE_NONE then return false
            dim as Symbol ptr ts = c.syms->SymbolAt( c.info->RefOf( n ) )
            if ts = 0 then ts = c.syms->SymbolAt( c.info->RefOf( tg ) )
            if ts <> 0 then
                if ts->kind = cast( ubyte, SYM_PROC ) then return true
            end if
            n = tg
        case else
            return false
        end select
    next
    return false
end function

private sub CheckGetElemThroughCall_ ( byref c as Ctx, byval n as NodeId )
    '' THE ELEMENT: an indexing call over a field or variable -- not a call's own result.
    if (n = NODE_NONE) orelse (c.ast->Kind( n ) <> N_CALL) then return
    dim as NodeId tg = c.ast->lists[cast( long, c.ast->nodes[cast( long, n )].data )].target
    if (tg = NODE_NONE) orelse (c.ast->Kind( tg ) <> N_MEMBER) then return
    dim as Symbol ptr fs = c.syms->SymbolAt( c.info->RefOf( tg ) )
    if fs = 0 then return
    if fs->kind <> cast( ubyte, SYM_FIELD ) then return
    if ThroughCall_( c, c.ast->binaries[cast( long, c.ast->nodes[cast( long, tg )].data )].lhs ) = false then return
    c.diags->Report( TKO0883, PointRange( c.ast->Loc( n ) ) )
end sub

private sub ConstOutReport_ ( byref c as Ctx, byval n as NodeId )
    if ConstOut_( c, n ) = false then return
    c.diags->Report( TKO0617, PointRange( c.ast->Loc( n ) ), SpellOf_( c, Unparen3_( c, n ) ) )
end sub

private sub CheckConstOutput_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if c.ast->Kind( id ) = N_INTRINSIC then
        select case cast( TokenKind, sp->op )
        case KW_INPUT, KW_READ
            for i as long = 0 to sp->count - 1
                ConstOutReport_( c, cast( NodeId, c.ast->children[sp->first + i] ) )
            next
        case KW_LINE
            '' LINE INPUT only (bit 1 of 'extra'); the graphics LINE writes nothing.
            if (sp->extra and 1) = 0 then return
            for i as long = 0 to sp->count - 1
                ConstOutReport_( c, cast( NodeId, c.ast->children[sp->first + i] ) )
            next
        case KW_GET
            '' The LAST item, file form or graphics: the variable read into, the array filled.
            if sp->count < 1 then return
            ConstOutReport_( c, cast( NodeId, c.ast->children[sp->first + sp->count - 1] ) )
            '' Bit 1 of 'extra' is the FILE form; the graphics one alone refuses a call's element.
            if (sp->extra and 1) = 0 then CheckGetElemThroughCall_( c, cast( NodeId, c.ast->children[sp->first + sp->count - 1] ) )
        case KW_LSET, KW_RSET
            if sp->count < 1 then return
            dim as NodeId t0 = cast( NodeId, c.ast->children[sp->first] )
            if c.ast->Kind( t0 ) = N_BINARY then t0 = c.ast->binaries[cast( long, c.ast->nodes[cast( long, t0 )].data )].lhs
            ConstOutReport_( c, t0 )
        end select
        return
    end if

    '' A CALL WITHOUT PARENTHESES -- 'clear a, 0, n' -- to a procedure with a byref parameter.
    if c.info->AmbiguousOf( id ) <> AMB_CALL then return
    if sp->count < 1 then return
    dim as Symbol ptr callee = c.syms->SymbolAt( c.info->RefOf( id ) )
    if callee = 0 then callee = c.syms->SymbolAt( c.info->RefOf( sp->a ) )
    '' CLEAR is the runtime's and has no symbol: its first argument is the memory it fills.
    if (callee = 0) andalso (sp->a <> NODE_NONE) then
        if lcase( SpellOf_( c, sp->a ) ) = "clear" then
            dim as NodeId a0 = cast( NodeId, c.ast->children[sp->first] )
            if (c.ast->Kind( a0 ) = N_IDENT) andalso ConstOut_( c, a0 ) then
                c.diags->Report( TKO0699, PointRange( c.ast->Loc( a0 ) ) )
            end if
        end if
        return
    end if
    if callee = 0 then return
    if callee->kind <> cast( ubyte, SYM_PROC ) then return
    dim as NodeId decl = cast( NodeId, callee->payload )
    if (decl = NODE_NONE) orelse (c.ast->Kind( decl ) <> N_PROC) then return
    dim as StmtPayload ptr pp = @c.ast->stmts[cast( long, c.ast->nodes[cast( long, decl )].data )]
    dim as long ai = 0
    for i as long = 0 to pp->count - 1
        dim as NodeId prm = cast( NodeId, c.ast->children[pp->first + i] )
        if c.ast->Kind( prm ) <> N_PARAM then continue for
        if ai >= sp->count then exit for
        dim as NodeId arg = cast( NodeId, c.ast->children[sp->first + ai] )
        ai += 1
        if (c.ast->nodes[cast( long, prm )].flags and NF_BYREF) = 0 then continue for
        if c.ast->Kind( arg ) <> N_IDENT then continue for
        dim as StmtPayload ptr prp = @c.ast->stmts[cast( long, c.ast->nodes[cast( long, prm )].data )]
        if prp->a <> NODE_NONE then
            dim as TypeId pt = c.info->TypeOf_( prp->a )
            if (pt <> TYPE_NONE) andalso c.types->IsConst( pt ) then continue for
        end if
        if ConstOut_( c, arg ) = false then continue for
        '' ONCE PER CALL, as fbc does and as the call-with-parentheses half does.
        c.diags->Report( TKO0699, PointRange( c.ast->Loc( arg ) ) )
        return
    next
end sub
