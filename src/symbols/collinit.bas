'' collinit.bas -- COLLECTION INITIALISERS, a tiko extension. fbc has no equivalent: over a
'' UDT it refuses a brace list outright (its error 63, "Expected array").
''
''     dim a as containers.Array( of integer )        = { 10, 20, 30 }
''     dim m as containers.Map( of ustring, integer ) = { {"a", 1}, {"b", 2} }
''
'' THE RULE. A brace list on a declared variable of UDT type is a collection initialiser
'' when the type NEEDS CONSTRUCTION -- a constructor of its own, or a field that needs one
'' (a dynamic array, a var-len string, an object with a constructor) -- AND has a member
'' procedure named Add, PushBack or Push, the first of those found. Each element becomes
'' one call, in order, after construction: 'e' is 'x.Method( e )' and a nested '{ a, b }'
'' is 'x.Method( a, b )'. They are REAL CALLS, so overloads and conversions are the
'' ordinary ones.
''
'' WHY THE BOUNDARY IS SAFE: a brace list over a type that needs construction was
'' silently DROPPED before this -- 'Array.Count( )' came out 0 -- so giving it a meaning
'' changes no program that worked. A plain-data type keeps its field-list meaning.
''
'' HOW. The calls are built here, as the statements 'x.Push( 10 )' parses to, recorded
'' against the declaration (ast/collinit.bas), and the brace list is DETACHED from the
'' item: every later pass sees a plain 'dim', and lowering runs the recorded statements
'' after constructing the variable. Detaching is what keeps Check's field-list rules --
'' TKO0757 and the rest -- from judging a list that is no longer one.
''
'' Included from resolve.bas, at the 1500-line cap.

'' A member by name: the type's own scope, then -- for an instantiation, whose members are
'' not built yet -- its generic's (check.bas FieldOf_ explains why), then up the 'base'
'' chain.
private function CiMember_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byval nm as Tko.InternId, _
      byval depth as long ) as Tko.Symbol ptr

    if depth > 8 then return 0
    t = c.types->Unqualify( t )
    if c.types->Kind( t ) <> Tko.TK_UDT then return 0
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( UdtSymOf_( c, t ) )
    if s = 0 then return 0
    if s->inner = Tko.SCOPE_NONE then return 0
    dim as Tko.Symbol ptr f = c.syms->SymbolAt( c.syms->LookupLocal( s->inner, nm ) )
    if f <> 0 then return f

    dim as Tko.NodeId gnode = cast( Tko.NodeId, s->payload )
    if (gnode <> Tko.NODE_NONE) andalso (c.ast->Kind( gnode ) = Tko.N_TYPE) then
        dim as Tko.StmtPayload ptr gp = StmtOf( c, gnode )
        if (gp->b <> Tko.NODE_NONE) andalso (gp->name <> c.types->NameOf( t )) then
            dim as Tko.Symbol ptr gs = c.syms->SymbolAt( c.info->RefOf( gnode ) )
            if gs <> 0 then
                if gs->inner <> Tko.SCOPE_NONE then
                    f = c.syms->SymbolAt( c.syms->LookupLocal( gs->inner, nm ) )
                    if f <> 0 then return f
                end if
            end if
        end if
    end if

    dim as Tko.InternId baseNm = c.names->Fold( c.names->GetString( "base" ) )
    if nm = baseNm then return 0
    dim as Tko.Symbol ptr b = c.syms->SymbolAt( c.syms->LookupLocal( s->inner, baseNm ) )
    if b = 0 then return 0
    if (b->type_ = Tko.TYPE_NONE) orelse (b->type_ = t) then return 0
    return CiMember_( c, b->type_, nm, depth + 1 )
end function

private function CiProc_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byref nm as string ) as boolean
    dim as Tko.Symbol ptr s = _
        CiMember_( c, t, c.names->Fold( c.names->GetString( nm ) ), 0 )
    if s = 0 then return false
    return s->kind = cast( ubyte, Tko.SYM_PROC )
end function

'' Does the type need constructing? 'sawString' says a var-len string field was among the
'' reasons -- the one case a field list already has a diagnostic for (TKO0757).
private function CiNeedsCtor_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byval depth as long, _
      byref sawString as boolean ) as boolean

    if depth > 8 then return false
    t = c.types->Unqualify( t )
    if c.types->Kind( t ) <> Tko.TK_UDT then return false
    if CiProc_( c, t, "__ctor" ) then return true
    dim as Tko.InternId tn = c.types->NameOf( t )
    if tn = 0 then return false
    if lcase( c.names->Spelling( tn ) ) = "object" then return true
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( UdtSymOf_( c, t ) )
    if s = 0 then return false
    if s->inner = Tko.SCOPE_NONE then return false
    dim as Tko.SymScope ptr sc = c.syms->ScopeAt( s->inner )
    if sc = 0 then return false
    dim as boolean needs = false
    dim as Tko.SymbolId cur = sc->firstSym
    for guard as long = 0 to 9999
        if cur = Tko.SYMBOL_NONE then exit for
        dim as Tko.Symbol ptr f = c.syms->SymbolAt( cur )
        if f = 0 then exit for
        dim as boolean isField = (f->kind = cast( ubyte, Tko.SYM_FIELD ))
        if isField andalso ((f->flags and (Tko.SYMF_STATIC or Tko.SYMF_SHARED)) = 0) then
            dim as Tko.TypeId ft = c.types->Unqualify( f->type_ )
            if c.types->IsDynArray( ft ) then
                needs = true
            elseif c.types->Kind( ft ) = Tko.TK_BUILTIN then
                select case c.types->BuiltinOf( ft )
                case Tko.TY_STRING, Tko.TY_USTRING
                    needs = true
                    sawString = true
                end select
            elseif CiNeedsCtor_( c, ft, depth + 1, sawString ) then
                needs = true
            end if
        end if
        cur = f->nextInScope
    next
    return needs
end function

private function CiNode_ _
    ( byref c as Ctx, byval k as Tko.NodeKind, byval lc as Tko.SourceLoc, _
      byval payload as ulong ) as Tko.NodeId
    dim as Tko.AstNode n
    n.kind = cast( ushort, k )
    n.flags = 0
    n.loc = lc
    n.data = payload
    c.ast->nodes.Push( n )
    return cast( Tko.NodeId, c.ast->nodes.Count - 1 )
end function

private function CiIdent_ _
    ( byref c as Ctx, byval lc as Tko.SourceLoc, byval nm as Tko.InternId ) as Tko.NodeId
    dim as Tko.IdentPayload ip
    ip.name = nm
    c.ast->idents.Push( ip )
    return CiNode_( c, Tko.N_IDENT, lc, c.ast->idents.Count - 1 )
end function

'' 'x.Method( args )' as a statement: N_AMBIGUOUS over N_CALL over N_MEMBER, the shape the
'' parser gives the same line written out. 'elem' is one argument, or a nested brace list
'' whose elements are the arguments.
private function CiCallStmt_ _
    ( byref c as Ctx, byval varNm as Tko.InternId, byval methodNm as Tko.InternId, _
      byval elem as Tko.NodeId ) as Tko.NodeId

    dim as Tko.SourceLoc lc = c.ast->Loc( elem )
    dim as FB.Array( of ulong ) args
    dim as boolean nested = (c.ast->Kind( elem ) = Tko.N_INITIALIZER)
    if nested then nested = (ListOf( c, elem )->target = Tko.NODE_NONE)
    if nested then
        dim as Tko.ListPayload ptr el = ListOf( c, elem )
        for k as long = 0 to el->count - 1
            args.Push( c.ast->children[el->first + k] )
        next
    else
        args.Push( cast( ulong, elem ) )
    end if

    dim as Tko.BinaryPayload bp
    bp.op = cast( ushort, Tko.TK_DOT )
    bp.lhs = CiIdent_( c, lc, varNm )
    bp.rhs = CiIdent_( c, lc, methodNm )
    c.ast->binaries.Push( bp )
    dim as Tko.NodeId callee = CiNode_( c, Tko.N_MEMBER, lc, c.ast->binaries.Count - 1 )
    c.ast->nodes[cast( long, callee )].flags or= Tko.NF_CALL_TARGET

    dim as Tko.ListPayload lp
    lp.target = callee
    lp.first = c.ast->children.Count
    lp.count = args.Count
    for k as long = 0 to args.Count - 1
        c.ast->children.Push( args[k] )
    next
    c.ast->lists.Push( lp )
    dim as Tko.StmtPayload sp
    sp.a = CiNode_( c, Tko.N_CALL, lc, c.ast->lists.Count - 1 )
    c.ast->stmts.Push( sp )
    return CiNode_( c, Tko.N_AMBIGUOUS, lc, c.ast->stmts.Count - 1 )
end function

'' True when this item IS a collection initialiser -- built now or on the first walk, or
'' refused with a report -- and the caller skips the field-list checks. 'sp' and 'ip' are
'' the caller's payload pointers, RE-READ here because building nodes grows the very
'' vectors they point into.
private function CollInit_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byval item as Tko.NodeId, _
      byval t as Tko.TypeId, byval revisit as boolean, byval here as Tko.ScopeId, _
      byref sp as Tko.StmtPayload ptr, byref ip as Tko.StmtPayload ptr ) as boolean

    '' THE SECOND WALK. A unit that declares a generic is resolved twice, and the brace
    '' list is gone by then -- so the record is the only thing that says.
    dim as Tko.NodeId blk = Tko.CollInitOf( *c.ast, item )
    if blk <> Tko.NODE_NONE then
        dim as Tko.ListPayload ptr bkl = ListOf( c, blk )
        dim as long bfirst = bkl->first
        dim as long bcount = bkl->count
        for k as long = 0 to bcount - 1
            WalkStmt( c, cast( Tko.NodeId, c.ast->children[bfirst + k] ), here )
        next
        return true
    end if

    if revisit then return false
    if c.ast->Kind( id ) <> Tko.N_VAR then return false
    if sp->op = cast( ushort, Tko.KW_VAR ) then return false
    dim as Tko.NodeId braces = ip->b
    if braces = Tko.NODE_NONE then return false
    if c.ast->Kind( braces ) <> Tko.N_INITIALIZER then return false
    if ListOf( c, braces )->target <> Tko.NODE_NONE then return false
    if c.types->Kind( t ) <> Tko.TK_UDT then return false
    dim as boolean sawString = false
    if CiNeedsCtor_( c, t, 0, sawString ) = false then return false

    '' THE REFUSALS LEAVE THE LIST WHERE IT IS, so the real walk of a unit with generics
    '' reports them again: the discovery walk's diagnostics are rolled back.
    dim as string method
    if CiProc_( c, t, "add" ) then
        method = "add"
    elseif CiProc_( c, t, "pushback" ) then
        method = "pushback"
    elseif CiProc_( c, t, "push" ) then
        method = "push"
    else
        '' NOTHING TO CALL. Reported where the list was dropped in silence before; a type
        '' with no constructor of its own that holds a string is TKO0757's already.
        if CiProc_( c, t, "__ctor" ) orelse (sawString = false) then
            c.diags->Report( Tko.TKO0843, Tko.PointRange( c.ast->Loc( braces ) ), _
                             c.names->Spelling( ip->name ) )
            return true
        end if
        return false
    end if

    '' A 'dim shared' or NAMESPACE variable is filled in the MODULE INITIALISER, right after
    '' it is constructed there (mir/lowermodinit.bas). NOT YET a static member's definition,
    '' 'dim shared T.x as ... = { ... }': the calls would name an unqualified 'x', which is
    '' not in scope where the definition stands. Nor an extern or a common, which have no
    '' initialiser of their own to give.
    dim as Tko.Symbol ptr vs = c.syms->SymbolAt( c.syms->LookupLocal( here, ip->name ) )
    dim as boolean elsewhere = _
        ((c.ast->nodes[cast( long, item )].flags and Tko.NF_QUALIFIED) <> 0)
    if vs <> 0 then
        if (vs->flags and (Tko.SYMF_EXTERN or Tko.SYMF_COMMON)) <> 0 then elsewhere = true
    end if
    dim as Tko.SymScope ptr hs = c.syms->ScopeAt( here )
    if hs <> 0 then
        if hs->kind = cast( ubyte, Tko.SCOPEK_TYPE ) then elsewhere = true
    end if
    if elsewhere then
        c.diags->Report( Tko.TKO0844, Tko.PointRange( c.ast->Loc( braces ) ), _
                         c.names->Spelling( ip->name ) )
        return true
    end if

    '' BUILT, then gathered into a block -- each call's own nodes interleave in the pool.
    dim as Tko.InternId varNm = ip->name
    dim as Tko.InternId methodNm = c.names->Fold( c.names->GetString( method ) )
    dim as FB.Array( of ulong ) elems
    dim as Tko.ListPayload ptr bl = ListOf( c, braces )
    for k as long = 0 to bl->count - 1
        elems.Push( c.ast->children[bl->first + k] )
    next
    dim as FB.Array( of ulong ) stmts
    for k as long = 0 to elems.Count - 1
        stmts.Push( cast( ulong, CiCallStmt_( c, varNm, methodNm, cast( Tko.NodeId, elems[k] ) ) ) )
    next
    dim as Tko.ListPayload lp
    lp.target = Tko.NODE_NONE
    lp.first = c.ast->children.Count
    lp.count = stmts.Count
    for k as long = 0 to stmts.Count - 1
        c.ast->children.Push( stmts[k] )
    next
    c.ast->lists.Push( lp )
    blk = CiNode_( c, Tko.N_BLOCK, c.ast->Loc( braces ), c.ast->lists.Count - 1 )
    Tko.RecordCollInit( *c.ast, item, braces, blk )
    c.info->Resize( c.ast->nodes.Count )

    sp = StmtOf( c, id )
    ip = StmtOf( c, item )
    ip->b = Tko.NODE_NONE
    for k as long = 0 to stmts.Count - 1
        WalkStmt( c, cast( Tko.NodeId, stmts[k] ), here )
    next
    sp = StmtOf( c, id )
    ip = StmtOf( c, item )
    return true
end function
