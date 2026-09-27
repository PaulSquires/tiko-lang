'' argmismatch.bas -- AN ARGUMENT THAT CANNOT CONVERT, AT A CALL WITH ONE CANDIDATE.
''
'' #included at the top of overload.bas, whose no-candidate branch calls it. Split out
'' because overload.bas is at the 1500-line lint cap.
''
'' fbc's errors 58 ("Type mismatch, at parameter N") and 24 ("Invalid data types"). A
'' call whose only candidate scored unviable used to come out UNTYPED with nothing said,
'' and lowering then dropped the statement: 'print ptrp( y )' over 'byval p as T ptr'
'' with a T value compiled, printed nothing, and reported '1 statements not lowered'.
''
'' WHY SO NARROW. overload.bas deliberately says nothing for a single candidate, because
'' an unviable score there is more often a conversion this compiler does not model than a
'' program fbc refuses -- and a false error is worse than a silent decline. So this does
'' not report "no candidate"; it reports only the PAIRS that were measured, one call per
'' (argument, parameter) kind, 14 x 14 against fbc-modern 1.20, and only where no user
'' conversion could be in play (tests/diagnostics/arg-mismatch.test). Every pair below is
'' an error in fbc and was a silent drop here; every pair fbc accepts is left alone:
''
''   a UDT value    to a pointer, a procedure pointer, a string, 'byref as zstring' -- 58
''                  (unless the UDT has an 'operator cast' or a base type)
''   a pointer      to a number -- 24, except a NULL constant, 'cptr( T ptr, 0 )', which
''                  binds (numbers/cast-nullptr.bas); to a UDT, 'byref as long',
''                  'byref as zstring' -- 58
''                  (a UDT parameter only when it has no constructor, no 'let', no base)
''   a NUMERIC or BOOLEAN VARIABLE to a pointer or a procedure pointer -- 24. A
''                  LITERAL, a named constant, an enum and even 'i + 1' are fbc's warning
''                  1 and bind, so only a named variable or parameter is judged.
''   a string       to a UDT with no constructor, no 'let' and no base -- 58
''
'' Anything else -- an untyped argument, an array, an elided or 'byval'-forced argument,
'' a 'type( ... )' literal, a generic or property procedure -- is not judged at all.

private function AmPtrLike_( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    return (c.types->Kind( t ) = Tko.TK_POINTER)
end function

private function AmNumeric_( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    if c.types->Kind( t ) <> Tko.TK_BUILTIN then return false
    select case c.types->BuiltinOf( t )
    case Tko.TY_BYTE, Tko.TY_UBYTE, Tko.TY_SHORT, Tko.TY_USHORT, Tko.TY_LONG, Tko.TY_ULONG, _
         Tko.TY_INTEGER, Tko.TY_UINTEGER, Tko.TY_LONGINT, Tko.TY_ULONGINT, _
         Tko.TY_SINGLE, Tko.TY_DOUBLE
        return true
    end select
    return false
end function

private function AmString_( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    if c.types->Kind( t ) <> Tko.TK_BUILTIN then return false
    select case c.types->BuiltinOf( t )
    case Tko.TY_STRING, Tko.TY_ZSTRING : return true
    end select
    return false
end function

'' A UDT with NO WAY IN OR OUT: no base, and none of the named members. Anything that has
'' one may convert in a way this file does not model, so it is never judged.
private function AmPlainUdt_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byref m1 as string, byref m2 as string ) as boolean
    if c.types->Kind( t ) <> Tko.TK_UDT then return false
    if c.types->BaseOf( t ) <> Tko.TYPE_NONE then return false
    if UdtMemberSym_( c, t, m1 ) <> Tko.SYMBOL_NONE then return false
    if (len( m2 ) > 0) andalso (UdtMemberSym_( c, t, m2 ) <> Tko.SYMBOL_NONE) then return false
    return true
end function

'' A named VARIABLE or PARAMETER -- not a constant, not an expression.
private function AmNamedVar_( byref c as Ctx, byval a as Tko.NodeId ) as boolean
    if c.ast->Kind( a ) <> Tko.N_IDENT then return false
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( c.info->RefOf( a ) )
    if s = 0 then return false
    return (s->kind = cast( ubyte, Tko.SYM_VARIABLE )) orelse _
           (s->kind = cast( ubyte, Tko.SYM_PARAMETER ))
end function

'' A NULL POINTER CONSTANT: 'cptr( T ptr, 0 )' or 'cast( any ptr, 0 )'. fbc passes one to a
'' NUMBER parameter with warning 2 -- numbers/cast-nullptr.bas writes twenty -- while
'' 'cptr( any ptr, 5 )', '@x', a pointer variable and a pointer result are all 24. To a
'' UDT parameter even the null one is 58, so only the numeric rule asks.
private function AmNullPtrConst_( byref c as Ctx, byval a as Tko.NodeId ) as boolean
    if c.ast->Kind( a ) <> Tko.N_CALL then return false
    dim as Tko.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, a )].data )]
    if (lp->target = Tko.NODE_NONE) orelse (lp->count < 2) then return false
    if c.ast->Kind( lp->target ) <> Tko.N_IDENT then return false
    dim as Tko.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, lp->target )].data )]
    select case Tko.Text.LowerAscii( c.names->Spelling( ip->name ) )
    case "cptr", "cast"
    case else : return false
    end select
    dim as Tko.NodeId v = cast( Tko.NodeId, c.ast->children[lp->first + lp->count - 1] )
    if c.ast->Kind( v ) <> Tko.N_INT_LIT then return false
    return (c.ast->literals[cast( long, c.ast->nodes[cast( long, v )].data )].intValue = 0)
end function

'' Is (argument at, parameter pt) one of the measured refusals? 'byref_' is the
'' parameter's mode; 'a' the argument node.
private function AmBadPair_ _
    ( byref c as Ctx, byval at as Tko.TypeId, byval pt as Tko.TypeId, _
      byval byref_ as boolean, byval a as Tko.NodeId ) as boolean

    if c.types->Kind( at ) = Tko.TK_UDT then
        if AmPlainUdt_( c, at, "cast", "" ) = false then return false
        if AmPtrLike_( c, pt ) then return true
        if AmString_( c, pt ) then
            '' 'byval as zstring' is not a parameter anyone writes; only these three were
            '' measured: byval and byref STRING, and byref ZSTRING.
            if c.types->BuiltinOf( pt ) = Tko.TY_STRING then return true
            return byref_
        end if
        return false
    end if

    if AmPtrLike_( c, at ) then
        if AmNumeric_( c, pt ) then return (AmNullPtrConst_( c, a ) = false)
        if AmPlainUdt_( c, pt, "__ctor", "let" ) then return true
        if AmString_( c, pt ) andalso (c.types->BuiltinOf( pt ) = Tko.TY_ZSTRING) then return byref_
        return false
    end if

    '' ...and a BOOLEAN variable the same way: 'f( bo )' over 'byval p as T ptr' is 24.
    dim as boolean boolArg = (c.types->Kind( at ) = Tko.TK_BUILTIN)
    if boolArg then boolArg = (c.types->BuiltinOf( at ) = Tko.TY_BOOLEAN)
    if AmNumeric_( c, at ) orelse boolArg then
        if AmPtrLike_( c, pt ) then return AmNamedVar_( c, a )
        return false
    end if

    if AmString_( c, at ) then
        if AmPlainUdt_( c, pt, "__ctor", "let" ) then return true
    end if
    return false
end function

'' Called by ResolveCall_ when a NON-overloaded callee scored unviable. Reports TKO0698 at
'' the first argument that is one of the pairs above, and nothing otherwise.
private sub ReportArgMismatch_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byval callee as Tko.SymbolId, _
      byval argFirst as long, byval argCount as long, byref argT as FB.Array( of ulong ) )

    if c.info->AmbiguousOf( id ) = Tko.AMB_PROPERTY_SET then exit sub
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( callee )
    if s = 0 then exit sub
    if s->kind <> cast( ubyte, Tko.SYM_PROC ) then exit sub
    dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
    if (pn = Tko.NODE_NONE) orelse (c.ast->Kind( pn ) <> Tko.N_PROC) then exit sub
    dim as Tko.StmtPayload ptr pp = StmtOf( c, pn )
    if (pp->extra and Tko.PF_GENERIC_PROC) <> 0 then exit sub
    if pp->op = cast( ushort, Tko.KW_PROPERTY ) then exit sub

    dim as long ai = 0
    for i as long = 0 to pp->count - 1
        dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp->first + i] )
        if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
        if ai >= argCount then exit for
        if ai >= argT.Count then exit for
        dim as Tko.StmtPayload ptr sp = StmtOf( c, prm )
        if sp->op = cast( ushort, Tko.TK_ELLIPSIS ) then exit for
        dim as Tko.NodeId a = cast( Tko.NodeId, c.ast->children[argFirst + ai] )
        dim as Tko.TypeId at = cast( Tko.TypeId, argT[ai] )
        ai += 1
        if (c.ast->nodes[cast( long, prm )].flags and Tko.NF_ARRAY) <> 0 then continue for
        if (at = Tko.TYPE_NONE) orelse (sp->a = Tko.NODE_NONE) then continue for
        select case c.ast->Kind( a )
        case Tko.N_ELIDED, Tko.N_TUPLE : continue for
        case Tko.N_UNARY
            dim as Tko.UnaryPayload ptr up = _
                @c.ast->unaries[cast( long, c.ast->nodes[cast( long, a )].data )]
            if cast( Tko.TokenKind, up->op ) = Tko.KW_BYVAL then continue for
        end select
        dim as Tko.TypeId pt = c.info->TypeOf_( sp->a )
        if pt = Tko.TYPE_NONE then continue for
        dim as Tko.TypeId au = c.types->Unqualify( at )
        dim as Tko.TypeId pu = c.types->Unqualify( pt )
        if c.types->Kind( au ) = Tko.TK_REFERENCE then au = c.types->Unqualify( c.types->Inner( au ) )
        if c.types->Kind( pu ) = Tko.TK_REFERENCE then pu = c.types->Unqualify( c.types->Inner( pu ) )
        dim as boolean byref_ = ((c.ast->nodes[cast( long, prm )].flags and Tko.NF_BYREF) <> 0)
        if AmBadPair_( c, au, pu, byref_, a ) then
            c.diags->Report( Tko.TKO0698, Tko.PointRange( c.ast->Loc( a ) ) )
            exit sub
        end if
    next
end sub
