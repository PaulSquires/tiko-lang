'' arrresult.bas -- A TIKO EXTENSION: a function may return a dynamic array.
''
''     function foo( ) as integer( )
''         return { 10, 20, 30 }
''     end function
''     var i = foo( )
''
'' Included from assigncheck.bas, which is included from visibility.bas, inside its
'' namespace, after ptrwarn.bas. fbc has no array result -- it rejects the spelling with error 3 --
'' so nothing here is measured against it; the rules are this file's own.
''
'' A RESULT TRAVELS BY THE HIDDEN POINTER and the caller owns what comes back, so the body may
'' hand over only something it can GIVE AWAY:
''
''     { a, b, c }       a flat brace list, built straight into the caller's array
''     a local array     a dynamic array declared in THIS procedure, moved out
''     f( )              a call that returns an array, moved through
''
'' Everything else is refused here and not at lowering, where a decline is silent. A parameter,
'' a SHARED or STATIC array or a field would have to be COPIED -- fbc's copy of a dynamic array is
'' fb_ArrayRedimTo and an element loop, and it is not wired to a return yet -- and moving one out
'' would leave its owner holding freed memory.

'' The result type to carry down the walk for a procedure node. A procedure written 'as T( )' has
'' the wrapped type on its SYMBOL and not on its written typeref, whose recorded type is T.
private function ArrProcResult_ ( byref c as Ctx, byval id as NodeId ) as TypeId
    dim as StmtPayload ptr pp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if (pp->extra and PF_ARRAY_RESULT) <> 0 then
        dim as Symbol ptr ps = c.syms->SymbolAt( c.info->RefOf( id ) )
        if ps <> 0 then return ps->type_
    end if
    return c.info->TypeOf_( pp->a )
end function

'' A NAMED ARRAY given as the value: the array, through what it is declared as. A local of this
'' procedure is fine; any other array is TKO0840; anything that is not an array is TKO0838.
private sub ArrCheckNamed_ _
    ( byref c as Ctx, byval at_ as NodeId, byval rt as TypeId, byval n as NodeId )

    dim as Symbol ptr s = c.syms->SymbolAt( c.info->RefOf( n ) )
    if s = 0 then
        c.diags->Report( TKO0838, PointRange( c.ast->Loc( at_ ) ) )
        return
    end if
    dim as TypeId st = c.types->Unqualify( s->type_ )
    if c.types->Kind( st ) = TK_REFERENCE then st = c.types->Unqualify( c.types->Inner( st ) )
    if c.types->IsDynArray( st ) = false then
        c.diags->Report( TKO0838, PointRange( c.ast->Loc( at_ ) ) )
        return
    end if
    if c.types->Unqualify( c.types->Inner( st ) ) <> c.types->Unqualify( c.types->Inner( rt ) ) then
        c.diags->Report( TKO0838, PointRange( c.ast->Loc( at_ ) ) )
        return
    end if
    dim as boolean isLocal = (s->kind = cast( ubyte, SYM_VARIABLE))
    if isLocal then
        isLocal = ((s->flags and (SYMF_SHARED or SYMF_STATIC or SYMF_EXTERN)) = 0)
    end if
    if isLocal then return
    dim as string nm = ""
    if c.ast->Kind( n ) = N_IDENT then
        nm = c.names->Spelling( c.ast->idents[cast( long, c.ast->nodes[cast( long, n )].data )].name )
    end if
    c.diags->Report( TKO0840, PointRange( c.ast->Loc( at_ ) ), nm )
end sub

'' THE VALUE OF A 'return' OR A 'function =' in a procedure that returns an array.
private sub ArrCheckSource_ _
    ( byref c as Ctx, byval at_ as NodeId, byval rt as TypeId, byval e0 as NodeId )

    dim as NodeId e = e0
    for guard as long = 0 to 15
        if e = NODE_NONE then return
        if c.ast->Kind( e ) <> N_PAREN then exit for
        dim as ListPayload ptr pl = @c.ast->lists[cast( long, c.ast->nodes[cast( long, e )].data )]
        if pl->count <> 1 then exit for
        e = cast( NodeId, c.ast->children[pl->first] )
    next

    select case c.ast->Kind( e )
    case N_INITIALIZER
        dim as ListPayload ptr lp = @c.ast->lists[cast( long, c.ast->nodes[cast( long, e )].data )]
        for i as long = 0 to lp->count - 1
            dim as NodeId el = cast( NodeId, c.ast->children[lp->first + i] )
            if c.ast->Kind( el ) = N_INITIALIZER then
                c.diags->Report( TKO0839, PointRange( c.ast->Loc( el ) ) )
                return
            end if
        next
    case N_IDENT
        ArrCheckNamed_( c, at_, rt, e )
    case N_CALL
        dim as ListPayload ptr cp = @c.ast->lists[cast( long, c.ast->nodes[cast( long, e )].data )]
        dim as SymbolId callee = c.info->RefOf( e )
        if (callee = SYMBOL_NONE) andalso (cp->target <> NODE_NONE) then callee = c.info->RefOf( cp->target )
        dim as Symbol ptr cs = c.syms->SymbolAt( callee )
        dim as boolean isProc = false
        if cs <> 0 then isProc = (cs->kind = cast( ubyte, SYM_PROC ))
        if isProc then
            dim as TypeId ct = c.types->Unqualify( cs->type_ )
            dim as boolean callOk = c.types->IsDynArray( ct )
            if callOk then
                callOk = (c.types->Unqualify( c.types->Inner( ct ) ) = c.types->Unqualify( c.types->Inner( rt ) ))
            end if
            if callOk = false then c.diags->Report( TKO0838, PointRange( c.ast->Loc( at_ ) ) )
        elseif (cp->count = 0) andalso (cp->target <> NODE_NONE) andalso (c.ast->Kind( cp->target ) = N_IDENT) then
            '' 'return a( )' -- the array's name with an empty subscript, as a call argument spells it.
            ArrCheckNamed_( c, at_, rt, cp->target )
        else
            c.diags->Report( TKO0838, PointRange( c.ast->Loc( at_ ) ) )
        end if
    case else
        c.diags->Report( TKO0838, PointRange( c.ast->Loc( at_ ) ) )
    end select
end sub

'' A CALL OF A PROCEDURE THAT RETURNS AN ARRAY -- not an array's own name with an empty subscript,
'' which is also an N_CALL and is typed as an element.
private function ArrIsResultCall_ ( byref c as Ctx, byval e0 as NodeId ) as boolean
    dim as NodeId e = e0
    for guard as long = 0 to 15
        if e = NODE_NONE then return false
        if c.ast->Kind( e ) <> N_PAREN then exit for
        dim as ListPayload ptr pl = @c.ast->lists[cast( long, c.ast->nodes[cast( long, e )].data )]
        if pl->count <> 1 then return false
        e = cast( NodeId, c.ast->children[pl->first] )
    next
    if e = NODE_NONE then return false
    if c.ast->Kind( e ) <> N_CALL then return false
    if c.types->IsDynArray( c.types->Unqualify( c.info->TypeOf_( e ) ) ) = false then return false
    dim as ListPayload ptr cp = @c.ast->lists[cast( long, c.ast->nodes[cast( long, e )].data )]
    dim as SymbolId callee = c.info->RefOf( e )
    if (callee = SYMBOL_NONE) andalso (cp->target <> NODE_NONE) then callee = c.info->RefOf( cp->target )
    dim as Symbol ptr cs = c.syms->SymbolAt( callee )
    if cs = 0 then return false
    return (cs->kind = cast( ubyte, SYM_PROC ))
end function

'' AN ARRAY RESULT'S VALUE IS AN ARRAY, and converts to nothing else. It gave no error and
'' stored a zero: 'dim x as integer = f( )' compiled and x held nothing.
private sub CheckArrayReturn_ ( byref c as Ctx, byval id as NodeId, byval resultType as TypeId )
    dim as NodeId e = c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )].a
    if c.types->IsDynArray( resultType ) = false then
        if ArrIsResultCall_( c, e ) then c.diags->Report( TKO0842, PointRange( c.ast->Loc( id ) ) )
        return
    end if
    '' A bare 'return' leaves whatever the result already holds, which is a valid array.
    if e = NODE_NONE then return
    ArrCheckSource_( c, id, resultType, e )
end sub

'' 'function = expr' -- the same rule, for the assignment spelling of a result -- and 'x = f( )',
'' which moves the array in when x is one and is refused for any other target.
'' A WHOLE ARRAY, NOT AN ELEMENT: its name -- 'a', 'h.arr' -- or 'a( )' with no index, which
'' Check does not type as the array. 'wt' is the array type. A fixed-length string is an array
'' of its character in this type model, and is not one.
private function WholeArray_ ( byref c as Ctx, byval n as NodeId, byref wt as TypeId ) as boolean
    wt = TYPE_NONE
    if n = NODE_NONE then return false
    if c.ast->Kind( n ) = N_CALL then
        dim as ListPayload ptr lp = @c.ast->lists[cast( long, c.ast->nodes[cast( long, n )].data )]
        if (lp->count <> 0) orelse (lp->target = NODE_NONE) then return false
        n = lp->target
    end if
    dim as TypeId t = c.types->Unqualify( c.info->TypeOf_( n ) )
    if c.types->Kind( t ) = TK_REFERENCE then t = c.types->Unqualify( c.types->Inner( t ) )
    dim as boolean whole = c.types->IsDynArray( t )
    if (whole = false) andalso (c.types->Kind( t ) = TK_ARRAY) then
        whole = (Tko.Check.FixedStringElem( t, *c.types ) = TYPE_NONE)
    end if
    if whole then wt = t
    return whole
end function

'' ...AND NO 'swap' OPERAND (T22): fbc's 73 for 'swap a, c', measured. tiko swapped two arrays
'' of one size and silently dropped the statement for two of different sizes.
private sub CheckArraySwap_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if cast( TokenKind, sp->op ) <> KW_SWAP then return
    dim as TypeId wt
    if WholeArray_( c, sp->a, wt ) then
        c.diags->Report( TKO0930, PointRange( c.ast->Loc( sp->a ) ) )
    elseif WholeArray_( c, sp->b, wt ) then
        c.diags->Report( TKO0930, PointRange( c.ast->Loc( sp->b ) ) )
    end if
end sub

private sub CheckArrayAssign_ ( byref c as Ctx, byval id as NodeId, byval resultType as TypeId )
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if (sp->a = NODE_NONE) orelse (sp->b = NODE_NONE) then return
    dim as boolean isRes = (c.ast->Kind( sp->a ) = N_FUNCRESULT)
    '' A WHOLE ARRAY IS NO ASSIGNMENT TARGET (T22) -- fbc's error 73, "Array access, index
    '' expected", for 'a = b', 'a = 5', 'a += b' and a field array alike, measured on
    '' fbc-modern 1.20 2026-10-02 ('a( ) = b( )' is its 181). tiko accepted them and copied the
    '' SOURCE's byte size into the destination: a 2-element 'long' array assigned from an
    '' 8-element one overwrote 24 bytes past it, and -exx did not see it. The one whole-array
    '' assignment tiko has is its own extension, 'd = f( )' moving an array result into a
    '' dynamic array -- see below.
    if (isRes = false) andalso (c.info->AmbiguousOf( id ) = AMB_ASSIGN) then
        dim as TypeId wt
        if WholeArray_( c, sp->a, wt ) then
            dim as boolean moveIn = (sp->op = cast( ushort, TK_EQ )) andalso c.types->IsDynArray( wt )
            if moveIn then moveIn = ArrIsResultCall_( c, sp->b )
            if moveIn = false then
                c.diags->Report( TKO0930, PointRange( c.ast->Loc( sp->a ) ) )
                return
            end if
        end if
    end if
    if sp->op <> cast( ushort, TK_EQ ) then return
    dim as TypeId lt = resultType
    if isRes = false then lt = c.info->TypeOf_( sp->a )
    if c.types->IsDynArray( c.types->Unqualify( lt ) ) then
        if isRes then ArrCheckSource_( c, id, resultType, sp->b )
        return
    end if
    if lt = TYPE_NONE then return
    if ArrIsResultCall_( c, sp->b ) then c.diags->Report( TKO0842, PointRange( c.ast->Loc( id ) ) )
end sub

'' 'dim x as integer = f( )' over an array result. A 'dim a( ) as T = f( )' is TKO0612, fbc's own
'' error 75 for any initialised dynamic array, and a 'var' takes the array's type.
private sub CheckArrayInit_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr ip = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if (ip->a = NODE_NONE) orelse (ip->b = NODE_NONE) then return
    if ArrIsResultCall_( c, ip->b ) = false then return
    '' AN ARRAY DECLARATION IS TKO0612'S -- the item carries NF_ARRAY, its type node only the element.
    if (c.ast->nodes[cast( long, id )].flags and NF_ARRAY) <> 0 then return
    if c.info->TypeOf_( ip->a ) = TYPE_NONE then return
    c.diags->Report( TKO0842, PointRange( c.ast->Loc( ip->b ) ) )
end sub

'' THE NAME OF AN ARRAY-RETURNING PROCEDURE WITHOUT ITS PARENTHESES. Its identifier is not typed
'' (it would read as the array being subscripted), so 'var b = f' had no type and no value and
'' compiled to nothing. fbc lets a procedure without parameters be called bare; for an array
'' result that would be a second way to write a call, so it is refused.
private sub CheckArrayResultName_ ( byref c as Ctx, byval id as NodeId )
    if (c.ast->nodes[cast( long, id )].flags and NF_CALL_TARGET) <> 0 then return
    dim as Symbol ptr s = c.syms->SymbolAt( c.info->RefOf( id ) )
    if s = 0 then return
    if s->kind <> cast( ubyte, SYM_PROC ) then return
    if c.types->IsDynArray( c.types->Unqualify( s->type_ ) ) = false then return
    c.diags->Report( TKO0841, PointRange( c.ast->Loc( id ) ), c.names->Spelling( s->name ) )
end sub

'' AN ARRAY RESULT AS THE ARGUMENT OF A SCALAR PARAMETER. No overload takes it, so the call was
'' left untyped and the statement around it dropped with nothing said: 'print TakesInt( f( ) )'
'' printed nothing. Refused when no procedure of the name has an array parameter in that place.
private sub CheckArrayArgs_ ( byref c as Ctx, byval id as NodeId )
    dim as ListPayload ptr lp = @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if lp->count = 0 then return
    dim as SymbolId head = c.info->RefOf( id )
    if (head = SYMBOL_NONE) andalso (lp->target <> NODE_NONE) then head = c.info->RefOf( lp->target )
    dim as Symbol ptr hs = c.syms->SymbolAt( head )
    if hs = 0 then return
    if hs->kind <> cast( ubyte, SYM_PROC ) then return
    for ai as long = 0 to lp->count - 1
        dim as NodeId an = cast( NodeId, c.ast->children[lp->first + ai] )
        if ArrIsResultCall_( c, an ) = false then continue for
        dim as boolean taken = false
        dim as SymbolId cur = head
        for guard as long = 0 to 255
            if cur = SYMBOL_NONE then exit for
            dim as Symbol ptr cs = c.syms->SymbolAt( cur )
            if cs = 0 then exit for
            dim as NodeId pn = cast( NodeId, cs->payload )
            if (pn <> NODE_NONE) andalso (c.ast->Kind( pn ) = N_PROC) then
                dim as StmtPayload ptr pp = @c.ast->stmts[cast( long, c.ast->nodes[cast( long, pn )].data )]
                dim as long seen = 0
                for i as long = 0 to pp->count - 1
                    dim as NodeId prm = cast( NodeId, c.ast->children[pp->first + i] )
                    if c.ast->Kind( prm ) <> N_PARAM then continue for
                    if seen = ai then
                        if (c.ast->nodes[cast( long, prm )].flags and NF_ARRAY) <> 0 then taken = true
                        exit for
                    end if
                    seen += 1
                next
            end if
            if taken then exit for
            cur = cs->nextOverload
        next
        if taken = false then c.diags->Report( TKO0842, PointRange( c.ast->Loc( an ) ) )
    next
end sub
