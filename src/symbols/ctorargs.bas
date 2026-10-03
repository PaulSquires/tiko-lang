'' ctorargs.bas -- AN ARGUMENT A TYPE'S ONLY CONSTRUCTOR CANNOT TAKE, fbc's error 58.
''
'' Included from latesweeps2.bas, below declshape.bas, in the same namespace and over the same Ctx.
''
'' CheckDirectCallArgs_ (latechecks.bas) judges a SUB or FUNCTION's arguments and leaves a
'' structor alone, so 'T( 1, "hi" )' over 'constructor( byval a as long, byref w as long )'
'' compiled, and the constructor read a string descriptor as its long. Measured on
'' fbc-modern 1.20, 2026-10-02, every shape is error 58, "Type mismatch, at parameter 2":
''
''     dim x as T = T( 1, "hi" )      var z = T( 4, "w" )      x = T( 5, "v" )
''     g( T( 2, "x" ) )               dim q as T ptr = new T( 3, "y" )
''
'' -- byref or byval, a literal or a string variable. The rule is ProcPtrArgBad_'s, the one
'' an ordinary call is judged by, so the two cannot drift apart.
''
'' ONE CONSTRUCTOR ONLY. Over an overload set fbc says 99, "No matching overloaded
'' function", which is not this report. And not a ONE-ARGUMENT call over a UDT value: 'C( c1 )'
'' over only 'constructor( byval a as long )' is 58 for plain fields, but give C a string
'' field and fbc accepts it -- the implicit copy constructor is a second candidate, and the
'' symbol table does not hold it. Saying nothing is the side that cannot be wrong.

private sub CheckCtorArgsOf_ _
    ( byref c as Ctx, byval t as TypeId, byval argFirst as long, byval argCount as long )

    if argCount <= 0 then return
    t = c.types->Unqualify( t )
    if (t = TYPE_NONE) orelse (c.types->Kind( t ) <> TK_UDT) then return
    dim as InternId tn = c.types->NameOf( t )
    if tn = 0 then return
    '' Not an anonymous, synthesised or generic type -- CheckUdtCallNoCtor_'s exclusions.
    dim as string h = left( c.names->Spelling( tn ), 1 )
    if (h = "(") orelse (h = "$") orelse (h = "~") then return
    if instr( c.names->Spelling( tn ), "<" ) > 0 then return
    dim as Symbol ptr s = StructorOf_( c, t, "__ctor" )
    if s = 0 then return
    if s->kind <> cast( ubyte, SYM_PROC ) then return
    if (s->nextOverload <> SYMBOL_NONE) orelse ((s->flags and SYMF_OVERLOAD) <> 0) then return
    dim as NodeId decl = cast( NodeId, s->payload )
    if (decl = NODE_NONE) orelse (c.ast->Kind( decl ) <> N_PROC) then return
    if (c.ast->stmts[cast( long, c.ast->nodes[cast( long, decl )].data )].extra and PF_GENERIC_PROC) <> 0 then return

    if argCount = 1 then
        dim as TypeId a0 = c.types->Unqualify( c.info->TypeOf_( cast( NodeId, c.ast->children[argFirst] ) ) )
        if c.types->Kind( a0 ) = TK_REFERENCE then a0 = c.types->Unqualify( c.types->Inner( a0 ) )
        if c.types->Kind( a0 ) = TK_UDT then return
    end if

    for i as long = 0 to argCount - 1
        dim as NodeId warg = cast( NodeId, c.ast->children[argFirst + i] )
        if c.ast->Kind( warg ) = N_ELIDED then continue for
        dim as NodeId prm = ProcDeclParam_( c.ast, decl, i )
        if prm = NODE_NONE then exit for
        if (c.ast->nodes[cast( long, prm )].flags and NF_ARRAY) <> 0 then continue for
        dim as NodeId pref = c.ast->stmts[cast( long, c.ast->nodes[cast( long, prm )].data )].a
        if pref = NODE_NONE then continue for
        dim as TypeId pt = c.info->TypeOf_( pref )
        if pt = TYPE_NONE then continue for
        if (c.ast->nodes[cast( long, prm )].flags and NF_BYREF) <> 0 then pt = c.types->Reference( pt )
        if ProcPtrArgBad_( c, pt, warg ) then
            c.diags->Report( TKO0698, PointRange( c.ast->Loc( warg ) ) )
            return
        end if
    next
end sub

'' A COUNT OF ARGUMENTS NO CONSTRUCTOR TAKES (T82) -- fbc's error 1, "Argument count
'' mismatch", over one constructor, and 99, "No matching overloaded function", over a set.
'' Measured on fbc-modern 1.20, 2026-10-03, in every shape CheckCtorArgsOf_ lists, through a
'' typedef as well. tiko said nothing and built the value from SOME constructor:
'' 'TimeSpan( 0, 1, 30, 0 )' against constructors of three and five gave thirty minutes.
''
'' Each candidate takes from its count of parameters without a default to its count of
'' parameters (no upper end past '...'). ONE ARGUMENT OF A UDT TYPE is left alone: the implicit
'' copy constructor is a candidate the symbol table does not hold (see the note above). Nor
'' a generic candidate, whose parameters are not instantiated here. Returns true if reported.
private function CheckCtorArity_ _
    ( byref c as Ctx, byval t as TypeId, byval argFirst as long, byval argCount as long, _
      byval at as NodeId ) as boolean

    t = c.types->Unqualify( t )
    if (t = TYPE_NONE) orelse (c.types->Kind( t ) <> TK_UDT) then return false
    dim as InternId tn = c.types->NameOf( t )
    if tn = 0 then return false
    dim as string h = left( c.names->Spelling( tn ), 1 )
    if (h = "(") orelse (h = "$") orelse (h = "~") then return false
    if instr( c.names->Spelling( tn ), "<" ) > 0 then return false
    dim as Symbol ptr s = StructorOf_( c, t, "__ctor" )
    if s = 0 then return false
    if s->kind <> cast( ubyte, SYM_PROC ) then return false

    if argCount = 1 then
        dim as NodeId a0n = cast( NodeId, c.ast->children[argFirst] )
        dim as TypeId a0 = c.types->Unqualify( c.info->TypeOf_( a0n ) )
        if a0 = TYPE_NONE then return false
        if c.types->Kind( a0 ) = TK_REFERENCE then a0 = c.types->Unqualify( c.types->Inner( a0 ) )
        if c.types->Kind( a0 ) = TK_UDT then return false
    end if

    dim as long candidates = 0, lo = 0, hi = 0
    dim as Symbol ptr cs = s
    while cs <> 0
        if cs->kind <> cast( ubyte, SYM_PROC ) then return false
        dim as NodeId decl = cast( NodeId, cs->payload )
        if (decl = NODE_NONE) orelse (c.ast->Kind( decl ) <> N_PROC) then return false
        dim as StmtPayload ptr pp = @c.ast->stmts[cast( long, c.ast->nodes[cast( long, decl )].data )]
        if (pp->extra and PF_GENERIC_PROC) <> 0 then return false
        dim as long need = 0, np = 0
        dim as boolean variadic = false
        for i as long = 0 to pp->count - 1
            dim as NodeId prm = cast( NodeId, c.ast->children[pp->first + i] )
            if c.ast->Kind( prm ) <> N_PARAM then continue for
            dim as StmtPayload ptr psp = @c.ast->stmts[cast( long, c.ast->nodes[cast( long, prm )].data )]
            if psp->op = cast( ushort, TK_ELLIPSIS ) then
                variadic = true
                continue for
            end if
            np += 1
            if psp->b = NODE_NONE then need = np
        next
        '' One candidate that takes this many settles it.
        if argCount >= need then
            if variadic orelse (argCount <= np) then return false
        end if
        candidates += 1
        lo = need
        hi = np
        if cs->nextOverload = SYMBOL_NONE then exit while
        cs = c.syms->SymbolAt( cs->nextOverload )
    wend

    dim as string shown = c.names->Spelling( tn ) & ".constructor"
    if candidates = 1 then
        dim as string takes = str( hi )
        if lo <> hi then takes = lo & " to " & hi
        c.diags->Report( TKO0775, PointRange( c.ast->Loc( at ) ), str( argCount ), shown, takes )
    else
        c.diags->Report( TKO0632, PointRange( c.ast->Loc( at ) ), shown )
    end if
    return true
end function

'' 'T( ... )' naming the type, and 'new T( ... )'.
private sub CheckCtorCallArgs_ ( byref c as Ctx, byval id as NodeId, byval k as NodeKind )
    dim as ListPayload ptr lp = @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if lp->target = NODE_NONE then return
    if k = N_NEW then
        dim as long first, count
        NewCtorArgs_( c, id, first, count )
        '' 'new T' with no list is a default construction, judged elsewhere.
        if count > 0 then
            if CheckCtorArity_( c, c.info->TypeOf_( lp->target ), first, count, id ) then return
        end if
        CheckCtorArgsOf_( c, c.info->TypeOf_( lp->target ), first, count )
        return
    end if
    if c.ast->Kind( lp->target ) <> N_IDENT then return
    dim as Symbol ptr ts = c.syms->SymbolAt( c.info->RefOf( lp->target ) )
    if ts = 0 then return
    if (ts->kind <> cast( ubyte, SYM_UDT )) andalso (ts->kind <> cast( ubyte, SYM_TYPEDEF )) then return
    if CheckCtorArity_( c, c.info->TypeOf_( id ), lp->first, lp->count, id ) then return
    CheckCtorArgsOf_( c, c.info->TypeOf_( id ), lp->first, lp->count )
end sub
