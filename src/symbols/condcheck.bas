'' condcheck.bas -- A CONDITION THAT IS NOT A NUMBER (TKO0966). #included from latesweeps2.bas.
''
'' Measured on fbc-modern: 'if s then', 'while s', 'do until s', 'iif( s, 1, 2 )' over a string --
'' var-length, 'zstring * N' or 'wstring * N' -- are error 24, and 's andalso 1' is 20; over a UDT
'' declaring no cast, 'if v then' is 99. A double, a pointer and a UDT casting to a number or a
'' pointer are fine. tiko let clang refuse the string ones (TKO0113) and dropped 's andalso 1'.

private function CondBadType_ ( byref c as Ctx, byval e as NodeId ) as TypeId
    if e = NODE_NONE then return TYPE_NONE
    dim as TypeId t = c.info->TypeOf_( e )
    if t = TYPE_NONE then return TYPE_NONE
    dim as TypeId u = c.types->Unqualify( t )
    if c.types->Kind( u ) = TK_REFERENCE then u = c.types->Unqualify( c.types->Inner( u ) )
    dim as TypeId b = u
    if c.types->Kind( b ) = TK_ARRAY then b = c.types->Unqualify( c.types->Inner( b ) )
    if c.types->Kind( b ) = TK_BUILTIN then
        '' A CHARACTER READ THROUGH A POINTER IS A NUMBER: 'while *p' over a 'zstring ptr' walks a
        '' string to its NUL -- fbc's own compound/select_const.bas does it.
        if CharAccess_( c, e, b ) then return TYPE_NONE
        select case c.types->BuiltinOf( b )
        case TY_STRING, TY_ZSTRING, TY_WSTRING, TY_USTRING, TY_FIXSTR, TY_FIXUSTR
            return u
        end select
        return TYPE_NONE
    end if
    if c.types->Kind( u ) <> TK_UDT then return TYPE_NONE
    if TupleLike_( c, u ) then return TYPE_NONE
    if c.types->BaseOf( u ) <> TYPE_NONE then return TYPE_NONE
    if Tko.Check.NumericCastPick( *c.syms, *c.types, *c.names, u, TYPE_NONE ) <> SYMBOL_NONE then return TYPE_NONE
    if Tko.Check.PtrCastPick( *c.syms, *c.types, *c.names, u, TYPE_NONE ) <> SYMBOL_NONE then return TYPE_NONE
    return u
end function

private sub CheckCond_ ( byref c as Ctx, byval e as NodeId )
    dim as TypeId bt = CondBadType_( c, e )
    if bt = TYPE_NONE then return
    c.diags->Report( TKO0966, PointRange( c.ast->Loc( e ) ), c.types->Name( bt ) )
end sub

private sub CheckConditions_ ( byref c as Ctx, byval id as NodeId, byval k as NodeKind )
    select case k
    case N_IF_BRANCH, N_WHILE
        CheckCond_( c, c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )].a )
    case N_DO
        dim as StmtPayload ptr sp = @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
        CheckCond_( c, sp->a )
        CheckCond_( c, sp->c )
    case N_BINARY
        dim as BinaryPayload ptr bp = @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        select case cast( TokenKind, bp->op )
        case KW_ANDALSO, KW_ORELSE
            CheckCond_( c, bp->lhs )
            CheckCond_( c, bp->rhs )
        end select
    case N_CALL
        dim as ListPayload ptr lp = @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
        if (lp->target = NODE_NONE) orelse (lp->count <> 3) then return
        if c.ast->Kind( lp->target ) <> N_IDENT then return
        if c.info->RefOf( lp->target ) <> SYMBOL_NONE then return
        if Text.LowerAscii( c.names->Spelling( c.ast->idents[cast( long, c.ast->nodes[cast( long, lp->target )].data )].name ) ) <> "iif" then return
        CheckCond_( c, cast( NodeId, c.ast->children[lp->first] ) )
    end select
end sub
