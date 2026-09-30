'' byrefcheck.bas -- WHAT A BYREF RESULT MAY AND MAY NOT BE ASSIGNED.
''
'' Split out of visibility.bas at the 1500-line lint cap and included from it, at the exact
'' spot the three checks stood, inside its namespace.

'' A DEFINITION MUST REPEAT THE DECLARATION'S 'byref' -- fbc error 20, "Type mismatch",
'' and it is symmetric: declaring BYREF and defining byval is refused, and so is the
'' reverse. Measured both ways, with 'both BYREF' accepted.
''
'' The symbol's payload is the DECLARATION node -- a definition joins its declare rather
'' than chaining beside it -- so the two nodes are both to hand here and nowhere else.
private sub CheckByrefResultAgrees_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if sp->b = NODE_NONE then return
    dim as Symbol ptr s = c.syms->SymbolAt( c.info->RefOf( id ) )
    if s = 0 then return
    dim as NodeId decl = cast( NodeId, s->payload )
    if decl = NODE_NONE then return
    if decl = id then return
    if c.ast->Kind( decl ) <> N_PROC then return
    dim as ushort a2 = cast( ushort, c.ast->nodes[cast( long, decl )].flags and NF_BYREF )
    dim as ushort b2 = cast( ushort, c.ast->nodes[cast( long, id )].flags and NF_BYREF )
    if a2 = b2 then return
    c.diags->Report( TKO0651, PointRange( c.ast->Loc( id ) ), _
                     c.names->Spelling( sp->name ) )
end sub

'' A BYREF RESULT MUST BE ASSIGNED SOMETHING OF EXACTLY ITS TYPE -- fbc error 318, "Type
'' mismatch in byref function result assignment". A byref result hands back the storage
'' itself, so there is nowhere for a conversion to happen.
''
'' EXACTLY is the word. Measured, against 'function f( ) byref as integer':
''     static i as integer          OK
''     static i as double           error 318
''     static i as long             error 318   -- the SAME SIZE, and still refused
''     static i as const integer    error 318   -- the qualifier counts
''     ...and 'byref as const integer' takes the const one, so it is identity, not width.
private sub CheckByrefResultType_ _
    ( byref c as Ctx, byval id as NodeId, byval byrefResult as boolean, _
      byval resultType as TypeId )

    if byrefResult = false then return
    if c.info->AmbiguousOf( id ) <> AMB_RESULT then return
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if sp->b = NODE_NONE then return
    '' ONLY WHAT WAS MEASURED: a NAMED variable of a non-string scalar builtin, on both
    '' sides. The corpus scan reported no false rejection, and this suite's own MIR tests
    '' then found four -- every one of them a STRING:
    ''
    ''     operator U.cast( ) byref as const zstring : operator = this._data
    ''         'zstring * N' is an ARRAY of TY_ZSTRING, never identical to plain zstring
    ''     function refZ( ) byref as zstring : function = "also good"
    ''         a LITERAL, and fbc takes it
    ''     function refI( ) byref as integer : function = byval pi
    ''         not a name at all
    ''
    '' fbc's real rule here is wider than identity for those shapes and this pass cannot
    '' model it, so they are declined rather than guessed at. A CLEAN CORPUS SCAN IS NOT
    '' PROOF: 1222 files said nothing about any of the four.
    '' A STRING LITERAL INTO A 'byref as STRING' RESULT -- fbc error 318 -- while the same
    '' literal into a 'byref as zstring' result is accepted (above). Measured both.
    if c.ast->Kind( sp->b ) = N_STRING_LIT then
        dim as TypeId lrt = resultType
        if lrt = TYPE_NONE then return
        if c.types->Kind( lrt ) = TK_REFERENCE then lrt = c.types->Inner( lrt )
        lrt = c.types->Unqualify( lrt )
        if c.types->Kind( lrt ) <> TK_BUILTIN then return
        if c.types->BuiltinOf( lrt ) = TY_STRING then
            c.diags->Report( TKO0667, PointRange( c.ast->Loc( sp->b ) ) )
        end if
        return
    end if
    if c.ast->Kind( sp->b ) <> N_IDENT then return
    dim as TypeId rt = resultType
    dim as TypeId vt = c.info->TypeOf_( sp->b )
    if (rt = TYPE_NONE) orelse (vt = TYPE_NONE) then return
    if rt = vt then return
    '' A REFERENCE ON EITHER SIDE IS THE SAME TYPE. A byref parameter's type is spelled
    '' as one, and returning it is the ordinary way to pass storage through.
    if c.types->Kind( rt ) = TK_REFERENCE then rt = c.types->Inner( rt )
    if c.types->Kind( vt ) = TK_REFERENCE then vt = c.types->Inner( vt )
    if rt = vt then return

    '' CONST GOES ONE WAY ONLY, and the two directions are not symmetric -- measured:
    ''     byref as integer       <- const integer     error 318   dropping it
    ''     byref as const integer <- integer           OK          adding it
    '' So the unqualified types must be identical, and a const value additionally
    '' demands a const result. Comparing the qualified ids outright refused the second
    '' line, which is a file fbc accepts.
    '' Both sides a NON-STRING scalar builtin -- see the header.
    if c.types->Kind( c.types->Unqualify( rt ) ) <> TK_BUILTIN then return
    if c.types->Kind( c.types->Unqualify( vt ) ) <> TK_BUILTIN then return
    select case c.types->BuiltinOf( c.types->Unqualify( rt ) )
    case TY_STRING, TY_ZSTRING, TY_WSTRING, TY_USTRING, TY_FIXSTR, TY_FIXUSTR
        return
    end select
    select case c.types->BuiltinOf( c.types->Unqualify( vt ) )
    case TY_STRING, TY_ZSTRING, TY_WSTRING, TY_USTRING, TY_FIXSTR, TY_FIXUSTR
        return
    end select

    dim as boolean valueConst = c.types->IsConst( vt )
    dim as boolean resConst = c.types->IsConst( rt )
    if c.types->Unqualify( rt ) <> c.types->Unqualify( vt ) then
        c.diags->Report( TKO0667, PointRange( c.ast->Loc( sp->b ) ) )
        return
    end if
    if valueConst andalso (resConst = false) then
        c.diags->Report( TKO0667, PointRange( c.ast->Loc( sp->b ) ) )
    end if
end sub

'' A BYVAL PARAMETER fbc PASSES BY A HIDDEN REFERENCE is the caller's storage, not a local:
'' measured on fbc-modern 1.20, 2026-09-30, 'function = u' in a byref-result function is
'' fine over 'byval u as string', and over a UDT with a destructor -- written, inherited,
'' or implied by a string, destructor-bearing or dynamic-array field, in an array too -- or
'' one that extends OBJECT (functions/temp-strings.bas). A plain-data UDT, a scalar or a
'' pointer is still error 272, and so is a UDT with only a copy constructor or 'let'.
private function PassedByHiddenRef_ ( byref c as Ctx, byval t as TypeId, byval depth as long = 0 ) as boolean
    if (t = TYPE_NONE) orelse (depth > 16) then return false
    dim as TypeId u = c.types->Unqualify( t )
    if c.types->IsDynArray( u ) then return (depth > 0)
    select case c.types->Kind( u )
    case TK_BUILTIN
        select case c.types->BuiltinOf( u )
        case TY_STRING, TY_USTRING
            return true
        end select
        return false
    case TK_ARRAY
        return PassedByHiddenRef_( c, c.types->Inner( u ), depth + 1 )
    case TK_UDT
    case else
        return false
    end select
    if ExtendsObject_( c, u ) then return true
    dim as TypeId b = u
    for g as long = 0 to 63
        if b = TYPE_NONE then exit for
        if StructorOf_( c, b, "__dtor" ) <> 0 then return true
        dim as ScopeId ds = cast( ScopeId, c.types->DeclScopeOf( b ) )
        dim as SymbolId ts = c.syms->LookupLocalTyped( ds, c.types->NameOf( b ), true )
        if ts = SYMBOL_NONE then ts = c.syms->LookupTyped( ds, c.types->NameOf( b ), true )
        dim as Symbol ptr s = c.syms->SymbolAt( ts )
        if (s <> 0) andalso (s->inner <> SCOPE_NONE) then
            dim as SymScope ptr sc = c.syms->ScopeAt( s->inner )
            dim as SymbolId cur = iif( sc <> 0, sc->firstSym, SYMBOL_NONE )
            while cur <> SYMBOL_NONE
                dim as Symbol ptr f = c.syms->SymbolAt( cur )
                if f = 0 then exit while
                if (f->kind = cast( ubyte, SYM_FIELD )) andalso ((f->flags and SYMF_STATIC) = 0) andalso (f->type_ <> u) then
                    if PassedByHiddenRef_( c, f->type_, depth + 1 ) then return true
                end if
                cur = f->nextInScope
            wend
        end if
        b = BaseOf_( c, b )
    next
    return false
end function

'' A BYREF RESULT CANNOT RETURN A LOCAL -- fbc error 272, "Local symbols can't be
'' referenced". The caller is handed a reference, and the frame it points into is gone by
'' the time it is read. Measured, all three shapes:
''
''     function = x.i           x a local UDT              error 272
''     function = array( i )    array a local array        error 272
''     function = f1( )         a call's RESULT is a temp  error 272
''     function = g             g SHARED                   OK
''
'' THE BASE OF THE CHAIN IS WHAT MATTERS: 'x.i' is local because x is, and 'array( i )'
'' because array is. So the walk goes down to the head of the member and index chain, and
'' a CALL is refused outright unless it returns byref itself.
private sub CheckByrefResultValue_ _
    ( byref c as Ctx, byval id as NodeId, byval byrefResult as boolean )

    if byrefResult = false then return
    if c.info->AmbiguousOf( id ) <> AMB_RESULT then return
    dim as StmtPayload ptr sp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    if sp->b = NODE_NONE then return

    '' THE VALUE MUST HAVE AN ADDRESS. Measured, in a 'byref as integer' function:
    ''     function = 123               error 24     function = @g       error 24
    ''     function = g + 1             error 3      function = iif(..)  error 24
    ''     function = type<UDT>( 123 )  error 24
    '' ...and 'function = "also good"' in a 'byref as zstring' function is ACCEPTED,
    '' so a string literal is left alone.
    select case c.ast->Kind( sp->b )
    case N_INT_LIT, N_FLOAT_LIT, N_ADDROF, N_BINARY, N_IIF
        c.diags->Report( TKO0711, PointRange( c.ast->Loc( sp->b ) ) )
        return
    case N_TUPLE
        if (c.ast->nodes[cast( long, sp->b )].flags and NF_TYPE_LITERAL) <> 0 then
            c.diags->Report( TKO0711, PointRange( c.ast->Loc( sp->b ) ) )
            return
        end if
    end select

    '' Down to the head of the chain.
    dim as NodeId head = sp->b
    dim as long guard = 0
    while guard < 64
        guard += 1
        dim as NodeKind hk = c.ast->Kind( head )
        if hk = N_MEMBER then
            head = c.ast->binaries[cast( long, c.ast->nodes[cast( long, head )].data )].lhs
        elseif hk = N_CALL then
            '' AN ARRAY SUBSCRIPT IS SPELLED LIKE A CALL. 'x.a(0)' over a FIELD array
            '' stopped the walk here: the branch below resolved the target 'x.a' to a
            '' SYM_FIELD, which is neither a proc nor a variable, and the statement was
            '' let through. Descending into the target continues to 'x' -- which is the
            '' local the rule is about. A real CALL still stops, and is judged below.
            dim as ListPayload ptr cl = _
                @c.ast->lists[cast( long, c.ast->nodes[cast( long, head )].data )]
            dim as Symbol ptr cts = c.syms->SymbolAt( c.info->RefOf( cl->target ) )
            if cts = 0 then exit while
            if cts->kind <> cast( ubyte, SYM_FIELD ) then exit while
            head = cl->target
        elseif (hk = N_INDEX) orelse (hk = N_PAREN) then
            dim as ListPayload ptr lp = _
                @c.ast->lists[cast( long, c.ast->nodes[cast( long, head )].data )]
            if hk = N_PAREN then
                if lp->count <> 1 then exit while
                head = cast( NodeId, c.ast->children[lp->first] )
            else
                head = lp->target
            end if
        else
            exit while
        end if
    wend
    if head = NODE_NONE then return

    if c.ast->Kind( head ) = N_CALL then
        '' A CALL's result is a temporary -- unless the callee returns BYREF, in which
        '' case what comes back is already somebody else's storage.
        dim as ListPayload ptr lp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, head )].data )]
        dim as Symbol ptr ts = c.syms->SymbolAt( c.info->RefOf( lp->target ) )
        if ts = 0 then
            '' 'iif( a, b, c )' IS A TEMPORARY -- error 24 -- and it binds no symbol.
            if c.ast->Kind( lp->target ) = N_IDENT then
                dim as string tn = c.names->Spelling( _
                    c.ast->idents[cast( long, c.ast->nodes[cast( long, lp->target )].data )].name )
                if lcase( tn ) = "iif" then
                    c.diags->Report( TKO0711, PointRange( c.ast->Loc( sp->b ) ) )
                end if
            end if
            return
        end if
        if ts->kind <> cast( ubyte, SYM_PROC ) then
            '' An INDEXING expression, not a call: fall through to the variable test.
            if ts->kind <> cast( ubyte, SYM_VARIABLE ) then return
            if (ts->flags and (SYMF_SHARED or SYMF_STATIC or SYMF_EXTERN or _
                               SYMF_COMMON)) <> 0 then return
            c.diags->Report( TKO0650, PointRange( c.ast->Loc( sp->b ) ) )
            return
        end if
        dim as NodeId cd = cast( NodeId, ts->payload )
        if (cd <> NODE_NONE) andalso (c.ast->Kind( cd ) = N_PROC) then
            if (c.ast->nodes[cast( long, cd )].flags and NF_BYREF) <> 0 then return
        end if
        c.diags->Report( TKO0650, PointRange( c.ast->Loc( sp->b ) ) )
        return
    end if

    if c.ast->Kind( head ) <> N_IDENT then return
    dim as Symbol ptr s = c.syms->SymbolAt( c.info->RefOf( head ) )
    if s = 0 then return
    '' A BYVAL PARAMETER IS A LOCAL TOO -- error 272 for 'function = i' over 'byval i as
    '' integer', while a BYREF one is the caller's storage and passes. Measured both.
    '' A parameter's symbol carries no node; its TYPE says how it is passed -- Resolve
    '' types a byref one as a REFERENCE and a bydesc one as an ARRAY. 'this' is a
    '' pointer to the caller's object and is exempt.
    if s->kind = cast( ubyte, SYM_PARAMETER ) then
        if IsThisBase_( c, head ) then return
        if s->type_ = TYPE_NONE then return
        if PassedByHiddenRef_( c, s->type_ ) then return
        select case c.types->Kind( c.types->Unqualify( s->type_ ) )
        case TK_REFERENCE, TK_ARRAY
            return
        end select
        c.diags->Report( TKO0650, PointRange( c.ast->Loc( sp->b ) ), _
                         c.names->Spelling( s->name ) )
        return
    end if
    if s->kind <> cast( ubyte, SYM_VARIABLE ) then return
    if (s->flags and (SYMF_SHARED or SYMF_STATIC or SYMF_EXTERN or _
                      SYMF_COMMON)) <> 0 then return
    c.diags->Report( TKO0650, PointRange( c.ast->Loc( sp->b ) ), _
                     c.names->Spelling( s->name ) )
end sub
