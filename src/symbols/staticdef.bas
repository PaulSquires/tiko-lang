'' staticdef.bas -- A STATIC MEMBER'S DEFINITION THAT DISAGREES WITH ITS DECLARATION, and a
'' CONVERSION INTRINSIC OVER A POINTER OR A UDT: CheckStaticMemberDef_ (asked of every N_VAR)
'' and CheckConvIntrinsic_ (every N_CALL).
''
'' Included from latesweeps2.bas, below iifudt.bas, in the same namespace and over the same Ctx.

'' 'var UDT.i = cshort( 0 )' OVER A 'static i as integer' -- measured on fbc-modern 1.20,
'' 2026-09-29:
''
''     var UDT.i = cshort( 0 )  /  = 0.5  /  = 5ll            error 20, "Type mismatch"
''     dim UDT.i as short                                     error 131
''     dim shared byref UDT.ri as integer = x                 error 20 -- ri is not byref
''     var UDT.i = 0    dim UDT.i as integer = 5              fine
''
'' dim/member-var-bad-5 and member-var-bad-byref-2 write the first and the third. tiko took
'' the definition's own type. Only a SCALAR member is judged: an array's element type is
'' what its definition writes, and its bounds are TKO0751's.
private sub CheckStaticMemberDef_ ( byref c as Ctx, byval id as NodeId )
    dim as StmtPayload ptr sp = @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
    for k as long = 0 to sp->count - 1
        dim as NodeId item = cast( NodeId, c.ast->children[sp->first + k] )
        if (item = NODE_NONE) orelse (c.ast->Kind( item ) <> N_VAR_ITEM) then continue for
        if (c.ast->nodes[cast( long, item )].flags and NF_QUALIFIED) = 0 then continue for
        dim as StmtPayload ptr ip = @c.ast->stmts[cast( long, c.ast->nodes[cast( long, item )].data )]
        if (ip->ownerName = 0) orelse (ip->c <> NODE_NONE) then continue for
        if instr( c.names->Spelling( ip->ownerName ), "." ) > 0 then continue for
        dim as Symbol ptr os = c.syms->SymbolAt( c.syms->LookupTyped( c.info->ScopeOf( id ), ip->ownerName, true ) )
        if (os = 0) orelse (os->kind <> cast( ubyte, SYM_UDT )) then continue for
        '' The member, in the type or in what it extends.
        dim as Symbol ptr ms = 0
        dim as TypeId ut = os->type_
        for guard as long = 0 to 31
            dim as Symbol ptr us = UdtSymbolOf_( c, ut )
            if (us = 0) orelse (us->inner = SCOPE_NONE) then exit for
            ms = c.syms->SymbolAt( c.syms->LookupLocalTyped( us->inner, ip->name, false ) )
            if ms <> 0 then exit for
            ut = BaseOf_( c, ut )
            if ut = TYPE_NONE then exit for
        next
        if ms = 0 then continue for
        if (ms->flags and SYMF_STATIC) = 0 then continue for
        if ms->type_ = TYPE_NONE then continue for
        dim as boolean declByref = ((ms->flags and SYMF_BYREF) <> 0) orelse (c.types->Kind( ms->type_ ) = TK_REFERENCE)
        dim as boolean defByref = (((c.ast->nodes[cast( long, id )].flags or c.ast->nodes[cast( long, item )].flags) and NF_BYREF) <> 0)
        '' 'dim byref T.ri as integer', with nothing to bind: fbc's 320 is HERE, and the
        '' declaration in the type needs none (ByrefNeedsInit_, fieldctor.bas).
        if declByref andalso defByref andalso (ip->b = NODE_NONE) then
            c.diags->Report( TKO0644, PointRange( c.ast->Loc( item ) ), c.names->Spelling( ip->name ) )
            continue for
        end if
        dim as TypeId dt = ValueType_( c, ms->type_ )
        if (dt = TYPE_NONE) orelse (c.types->Kind( dt ) = TK_ARRAY) orelse c.types->IsDynArray( dt ) then continue for
        dim as boolean bad = (declByref <> defByref)
        if bad = false then
            dim as TypeId vt = TYPE_NONE
            if ip->a <> NODE_NONE then
                vt = c.info->TypeOf_( ip->a )
            elseif ip->b <> NODE_NONE then
                vt = c.info->TypeOf_( ip->b )
            end if
            if vt = TYPE_NONE then continue for
            vt = ValueType_( c, vt )
            if vt = TYPE_NONE then continue for
            bad = (c.types->Unqualify( vt ) <> c.types->Unqualify( dt ))
        end if
        if bad then
            c.diags->Report( TKO0889, PointRange( c.ast->Loc( item ) ), _
                             c.names->Spelling( ip->ownerName ) & "." & c.names->Spelling( ip->name ) )
        end if
    next
end sub

'' A CONVERSION INTRINSIC OVER A POINTER OR A UDT -- fbc's error 20, measured on fbc-modern
'' 1.20, 2026-09-29, 64-bit:
''
''     clng( p ), culng( p ), cshort( p ), cbyte( p ), cdbl( p )     p any ptr     error 20
''     cint( p ), cuint( p ), clngint( p )                                         fine
''     cint( f ) over a UDT whose only 'operator cast' is 'as single' or 'as long'  error 20
''     cint( f ) with 'cast as integer', csng( f ) with 'cast as single'            fine
''
'' A pointer converts to an integer of ITS OWN size and nothing else, and a UDT converts
'' through a cast to EXACTLY the intrinsic's type. pointers/cast-to-int-mismatch and
'' overload/op_cast_missing write one each, and tiko converted both.
private function ConvTarget_ ( byref nm as string ) as BuiltinType
    select case nm
    case "cbyte"    : return TY_BYTE
    case "cubyte"   : return TY_UBYTE
    case "cshort"   : return TY_SHORT
    case "cushort"  : return TY_USHORT
    case "clng"     : return TY_LONG
    case "culng"    : return TY_ULONG
    case "cint"     : return TY_INTEGER
    case "cuint"    : return TY_UINTEGER
    case "clngint"  : return TY_LONGINT
    case "culngint" : return TY_ULONGINT
    case "csng"     : return TY_SINGLE
    case "cdbl"     : return TY_DOUBLE
    end select
    return TY_NONE
end function

private sub CheckConvIntrinsic_ ( byref c as Ctx, byval id as NodeId )
    dim as ListPayload ptr lp = @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if (lp->target = NODE_NONE) orelse (lp->count <> 1) then return
    if c.ast->Kind( lp->target ) <> N_IDENT then return
    if (c.info->RefOf( lp->target ) <> SYMBOL_NONE) orelse (c.info->RefOf( id ) <> SYMBOL_NONE) then return
    dim as string nm = lcase( SpellOf_( c, lp->target ) )
    dim as BuiltinType want = ConvTarget_( nm )
    if want = TY_NONE then return
    dim as NodeId arg = cast( NodeId, c.ast->children[lp->first] )
    dim as TypeId at = c.info->TypeOf_( arg )
    if at = TYPE_NONE then return
    at = c.types->Unqualify( at )
    if c.types->Kind( at ) = TK_REFERENCE then at = c.types->Unqualify( c.types->Inner( at ) )
    select case c.types->Kind( at )
    case TK_POINTER
        dim as boolean ok
        if c.types->target.pointerBits = 64 then
            ok = (want = TY_INTEGER) orelse (want = TY_UINTEGER) orelse (want = TY_LONGINT) orelse (want = TY_ULONGINT)
        else
            ok = (want = TY_INTEGER) orelse (want = TY_UINTEGER) orelse (want = TY_LONG) orelse (want = TY_ULONG)
        end if
        if ok then return
    case TK_UDT
        dim as InternId un = c.types->NameOf( at )
        if un = 0 then return
        dim as string h = left( c.names->Spelling( un ), 1 )
        if (h = "(") orelse (h = "$") orelse (h = "~") then return
        if instr( c.names->Spelling( un ), "<" ) > 0 then return
        '' A type that extends another may convert through the base's cast: not judged.
        if BaseOf_( c, at ) <> TYPE_NONE then return
        dim as Symbol ptr cs = StructorOf_( c, at, "cast" )
        for guard as long = 0 to 63
            if cs = 0 then exit for
            dim as TypeId rt = c.types->Unqualify( cs->type_ )
            if c.types->Kind( rt ) = TK_REFERENCE then rt = c.types->Unqualify( c.types->Inner( rt ) )
            if (c.types->Kind( rt ) = TK_BUILTIN) andalso (c.types->BuiltinOf( rt ) = want) then return
            cs = c.syms->SymbolAt( cs->nextOverload )
        next
    case else
        return
    end select
    c.diags->Report( TKO0890, PointRange( c.ast->Loc( id ) ), nm, c.types->Name( at ) )
end sub

'' Asked from CheckIncompleteObjects_ in latesweeps4.bas, which is at the line cap.
private sub CheckByrefResultCalls_ ( byref c as Ctx, byval total as long )
    '' A CALL TO A BYREF-RESULT FUNCTION whose declared result is not complete where it is
    '' called: 'print f( )', 'f( )' and 'f( ) = 1' are fbc's 71, '@f( )' is not -- measured
    '' with the typedef rule in CompletedBelow4_. Only a declaration's byref result may name
    '' an incomplete type at all.
    dim as FB.Array( of ubyte ) addrOf
    for i as long = 0 to total
        addrOf.Push( 0 )
    next
    for i as long = 1 to total
        if c.ast->Kind( cast( NodeId, i ) ) <> N_ADDROF then continue for
        dim as NodeId ao = Unparen3_( c, c.ast->unaries[cast( long, c.ast->nodes[i].data )].operand )
        if (ao > 0) andalso (cast( long, ao ) <= total) then addrOf[cast( long, ao )] = 1
    next
    for i as long = 1 to total
        if c.ast->Kind( cast( NodeId, i ) ) <> N_CALL then continue for
        if addrOf[i] <> 0 then continue for
        dim as ListPayload ptr cp = @c.ast->lists[cast( long, c.ast->nodes[i].data )]
        if cp->target = NODE_NONE then continue for
        dim as Symbol ptr ps = c.syms->SymbolAt( c.info->RefOf( cast( NodeId, i ) ) )
        if ps = 0 then ps = c.syms->SymbolAt( c.info->RefOf( cp->target ) )
        if (ps = 0) orelse (ps->kind <> cast( ubyte, SYM_PROC )) then continue for
        dim as NodeId pd = cast( NodeId, ps->payload )
        if (pd = NODE_NONE) orelse (c.ast->Kind( pd ) <> N_PROC) then continue for
        dim as StmtPayload ptr pdp = @c.ast->stmts[cast( long, c.ast->nodes[cast( long, pd )].data )]
        if (((c.ast->nodes[cast( long, pd )].flags and NF_BYREF) <> 0) orelse ((pdp->extra and PF_BYREF_RESULT) <> 0)) = false then continue for
        if (pdp->a = NODE_NONE) orelse (c.ast->Kind( pdp->a ) <> N_TYPEREF) then continue for
        if (c.ast->nodes[cast( long, pdp->a )].flags and (NF_PTR or NF_PROC_TYPE)) <> 0 then continue for
        dim as TypeId rt = c.info->TypeOf_( pdp->a )
        if rt = TYPE_NONE then continue for
        rt = c.types->Unqualify( rt )
        if c.types->Kind( rt ) = TK_REFERENCE then rt = c.types->Unqualify( c.types->Inner( rt ) )
        if c.types->Kind( rt ) = TK_FORWARD then
            c.diags->Report( TKO0810, PointRange( c.ast->Loc( cast( NodeId, i ) ) ), c.names->Spelling( c.types->NameOf( rt ) ) )
        else
            dim as string cnm = CompletedBelow4_( c, pdp->a, cast( NodeId, i ) )
            if len( cnm ) > 0 then c.diags->Report( TKO0811, PointRange( c.ast->Loc( cast( NodeId, i ) ) ), cnm )
        end if
    next
end sub
