'' checkeach.bas -- FOR EACH, validated.
''
'' Split out of check.bas at the 1500-line cap and included from it, inside its
'' namespace, exactly as checkconv.bas is.
''
'' Until this ran, a FOR EACH THAT CANNOT WORK SAID NOTHING: the lowering declined the
'' statement and the count went up by one, which is the same thing it reports for a
'' shape nobody has implemented yet. A structural protocol's failure mode is getting it
'' NEARLY right, so "not iterable" on its own is useless -- RFC-0002 section 7 wants the
'' missing member NAMED, and the corpus has a test whose whole subject is that.
''
'' It runs BEFORE the walk, beside the type inference it mirrors, so the diagnostic
'' lands on the loop rather than on some consequence of it three statements later.

'' THE 'for each' LOOP VARIABLE, where Resolve could not work it out.
''
'' Resolve types it from the sequence's SYMBOL, which is all it can do -- an
'' expression's type is Check's to record and Check has not run yet. That covers a
'' variable and a parameter and nothing else: 'for each dd in d.Value( )' is a CALL,
'' whose symbol is the procedure, and the sequence type is its RETURN type. Which
'' Check knows and Resolve does not.
''
'' A PRE-PASS, before the walk, for the same reason InferUnusedVarTypes_ is: every
'' USE of the loop variable is inside the body, and the walk types those.
'' A VAR-LENGTH string, either width. 'string * N' is an ARRAY of a character builtin,
'' so it is not this and is not walked as one -- see LowerForEachStr_.
private function IsVarLenStringType_( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    if t = Tko.TYPE_NONE then return false
    if c.types->Kind( t ) <> Tko.TK_BUILTIN then return false
    dim as Tko.BuiltinType b = c.types->BuiltinOf( t )
    return (b = Tko.TY_STRING) orelse (b = Tko.TY_USTRING)
end function

private sub InferForEachVarTypes_( byref c as Ctx )
    for i as long = 1 to c.ast->Count( )
        dim as Tko.NodeId n = cast( Tko.NodeId, i )
        if c.ast->Kind( n ) <> Tko.N_FOREACH then continue for
        dim as Tko.StmtPayload ptr sp = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, n )].data )]
        if sp->a = Tko.NODE_NONE then continue for
        if sp->count <> 1 then continue for
        dim as Tko.Symbol ptr vsym = c.syms->SymbolAt( c.info->RefOf( sp->a ) )
        if vsym = 0 then continue for
        if vsym->type_ <> Tko.TYPE_NONE then continue for

        dim as Tko.NodeId seqE = cast( Tko.NodeId, c.ast->children[sp->first] )
        dim as Tko.TypeId seqT = TypeOf_( c, seqE )
        if seqT = Tko.TYPE_NONE then continue for
        seqT = c.types->Unqualify( seqT )
        if c.types->Kind( seqT ) = Tko.TK_REFERENCE then
            seqT = c.types->Unqualify( c.types->Inner( seqT ) )
        end if
        if c.types->Kind( seqT ) = Tko.TK_ARRAY then
            vsym->type_ = c.types->Inner( seqT )
        elseif IsVarLenStringType_( c, seqT ) then
            '' 'for each ch in s' over a VAR-LENGTH STRING walks its CHARACTERS, and
            '' a character is a UBYTE -- measured, fbc declares the loop variable
            '' 'uint8'. Without this the variable was declared and untyped, so every
            '' use of it in the body had no operand type to work from.
            vsym->type_ = c.types->Builtin( Tko.TY_UBYTE )
        elseif c.types->Kind( seqT ) = Tko.TK_UDT then
            '' The RFC-0002 protocol: GetIterator gives the iterator's type and its
            '' Value( ) gives the element's.
            dim as Tko.SymbolId gi = UdtMemberSym_( c, seqT, "getiterator" )
            dim as Tko.Symbol ptr gs = c.syms->SymbolAt( gi )
            if gs <> 0 then
                dim as Tko.SymbolId vo = UdtMemberSym_( c, gs->type_, "value" )
                dim as Tko.Symbol ptr vs2 = c.syms->SymbolAt( vo )
                if vs2 <> 0 then
                    dim as Tko.TypeId et = vs2->type_
                    if et <> Tko.TYPE_NONE then
                        if c.types->Kind( et ) = Tko.TK_REFERENCE then
                            et = c.types->Inner( et )
                        end if
                    end if
                    vsym->type_ = et
                end if
            end if
        end if
        '' ...AND 'for each byref' STAYS BYREF (T71), as Resolve's typing keeps it. A
        '' collection declared with 'var' has no type until Check, so its loop
        '' variable is typed here -- and was typed as the element, a copy: 'n *= 100'
        '' changed nothing, silently, where the same loop over a 'dim' changed the
        '' collection.
        '' NOT over a string, which CheckForEach_ refuses with TKO0941 (T72).
        dim as boolean wrap = (cast( Tko.TokenKind, sp->op ) = Tko.KW_BYREF)
        if vsym->type_ = Tko.TYPE_NONE then wrap = false
        if IsVarLenStringType_( c, seqT ) then wrap = false
        if wrap then
            if c.types->Kind( vsym->type_ ) <> Tko.TK_REFERENCE then
                vsym->type_ = c.types->Reference( vsym->type_ )
            end if
        end if
    next
end sub

'' The declaring symbol of a UDT type. Same lookup UdtMemberSym_ does, stopping one step
'' earlier because what is wanted here is the SCOPE and not one name in it.
private function UdtSymOfType_ _
    ( byref c as Ctx, byval t as Tko.TypeId ) as Tko.SymbolId

    if t = Tko.TYPE_NONE then return Tko.SYMBOL_NONE
    dim as Tko.TypeId u = c.types->Unqualify( t )
    if c.types->Kind( u ) <> Tko.TK_UDT then return Tko.SYMBOL_NONE
    dim as Tko.InternId tn = c.types->NameOf( u )
    if tn = 0 then return Tko.SYMBOL_NONE
    dim as Tko.ScopeId ds = cast( Tko.ScopeId, c.types->DeclScopeOf( u ) )
    dim as Tko.SymbolId ts = c.syms->LookupLocalTyped( ds, tn, true )
    if ts = Tko.SYMBOL_NONE then ts = c.syms->LookupTyped( ds, tn, true )
    return ts
end function

'' A FIXED-LENGTH string -- 'string * N', 'zstring * N', 'wstring * N', 'ustring * N'.
'' All four are spelled as an ARRAY of a character builtin, which is exactly why the
'' array arm would otherwise take them.
private function IsFixedStrTypeC_( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    dim as Tko.TypeId u = c.types->Unqualify( t )
    if c.types->Kind( u ) <> Tko.TK_ARRAY then return false
    dim as Tko.TypeId el = c.types->Inner( u )
    if el = Tko.TYPE_NONE then return false
    if c.types->Kind( el ) <> Tko.TK_BUILTIN then return false
    select case c.types->BuiltinOf( el )
    case Tko.TY_ZSTRING, Tko.TY_WSTRING, Tko.TY_FIXSTR, Tko.TY_FIXUSTR
        return true
    end select
    return false
end function

'' A VAR-LENGTH ustring. Not 'ustring * N', which is a fixed-length string and is caught
'' by IsFixedStrTypeC_ above.
private function IsUStringTypeC_( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    dim as Tko.TypeId u = c.types->Unqualify( t )
    if c.types->Kind( u ) <> Tko.TK_BUILTIN then return false
    return c.types->BuiltinOf( u ) = Tko.TY_USTRING
end function

'' An array's RANK. A dynamic array carries its own; a fixed one records it as the
'' number of dimensions its bounds were retained for.
private function ArrayRankOf_( byref c as Ctx, byval t as Tko.TypeId ) as long
    if c.types->IsDynArray( t ) then return c.types->DynRank( t )
    return c.types->types[cast( long, t )].dims
end function

'' The RFC-0002 iterator protocol's three members, in the order they are reported
'' missing, or "" when all three are there.
private function MissingIterMember_ _
    ( byref c as Ctx, byval itT as Tko.TypeId ) as string

    if UdtMemberSym_( c, itT, "isvalid" ) = Tko.SYMBOL_NONE then return "IsValid( )"
    if UdtMemberSym_( c, itT, "value" ) = Tko.SYMBOL_NONE then return "Value( )"
    if UdtMemberSym_( c, itT, "movenext" ) = Tko.SYMBOL_NONE then return "MoveNext( )"
    return ""
end function

'' How many elements a TUPLE has, or -1 for anything that is not one.
''
'' A tuple is built as a UDT whose fields are named '_1', '_2', ... in order; that is
'' what tells one from an ordinary structure, and there is no other marker on the type.
'' The same rule TupleElems_ uses in the lowering, deliberately -- if the two disagree,
'' one of them accepts a shape the other will not lower.
private function TupleArity_( byref c as Ctx, byval t as Tko.TypeId ) as long
    if t = Tko.TYPE_NONE then return -1
    dim as Tko.TypeId u = c.types->Unqualify( t )
    if c.types->Kind( u ) <> Tko.TK_UDT then return -1
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( UdtSymOfType_( c, u ) )
    if s = 0 then return -1
    if s->inner = Tko.SCOPE_NONE then return -1
    dim as Tko.SymScope ptr sc = c.syms->ScopeAt( s->inner )
    if sc = 0 then return -1

    dim as long n = 0
    dim as Tko.SymbolId cur = sc->firstSym
    dim as long guard = 0
    while (cur <> Tko.SYMBOL_NONE) andalso (guard < 100000)
        guard += 1
        dim as Tko.Symbol ptr f = c.syms->SymbolAt( cur )
        if f = 0 then exit while
        if f->kind = cast( ubyte, Tko.SYM_FIELD ) then
            n += 1
            if c.names->Spelling( f->name ) <> ("_" & trim( str( n ) )) then return -1
        end if
        cur = f->nextInScope
    wend
    if n < 2 then return -1
    return n
end function

'' The synthetic 'var' the parser put at the top of a destructuring loop's body. Its
'' item count IS the number of names that were written, which is the only place that
'' number survives -- the loop itself binds one hidden element like any other form.
private function DestructureArity_( byref c as Ctx, byval body as Tko.NodeId ) as long
    if body = Tko.NODE_NONE then return -1
    if c.ast->Kind( body ) <> Tko.N_BLOCK then return -1
    dim as Tko.ListPayload ptr bl = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, body )].data )]
    if bl->count < 1 then return -1
    dim as Tko.NodeId first_ = cast( Tko.NodeId, c.ast->children[bl->first] )
    if c.ast->Kind( first_ ) <> Tko.N_VAR then return -1
    dim as Tko.StmtPayload ptr vp = _
        @c.ast->stmts[cast( long, c.ast->nodes[cast( long, first_ )].data )]
    return vp->count
end function

'' Every FOR EACH in the arena, checked against what its sequence actually is.
''
'' The refusals are fbc's, not inventions: a MULTI-DIMENSIONAL array has no defensible
'' traversal order and fbc rejects it outright; a FIXED-LENGTH string carries no length,
'' so walking its declared size reads past its contents; a type with none of the
'' protocol's members cannot be walked at all; and one whose GetIterator returns
'' something ALMOST an iterator is the case the message has to be specific about.
'' DESTRUCTURING -- '(a, b) = t' and 'var (a, b) = t' -- needs a TUPLE of the right size on
'' the right. Measured on fbc-modern 1.20, 2026-09-25 (its errors/tuple-errors.bas):
''
''     (x, y) = t        t a 3-tuple        370    too FEW targets
''     (x, y, z) = t     t a 2-tuple        266    too MANY
''     (x, y) = u        u a UDT, or 42     371    not a tuple
''     var (a, b, c) = (1, 2)  or  var (a, b) = (1, 2, 3)          370
''     var (a, b) = 42                                             371
''
'' tiko accepted every one; three of them dropped the statement. The 'var' form is the
'' parser's desugaring -- 'var $dt<n> = expr, a = $dt<n>._1, ...' -- so its name count is
'' the items after the temporary. An operand with no type yet, a template's among them,
'' says nothing.
private sub DestructureJudge_ _
    ( byref c as Ctx, byval at as Tko.NodeId, byval rt as Tko.TypeId, byval names as long )
    if rt = Tko.TYPE_NONE then return
    dim as Tko.TypeId u = c.types->Unqualify( rt )
    if c.types->Kind( u ) = Tko.TK_REFERENCE then u = c.types->Unqualify( c.types->Inner( u ) )
    if c.types->Kind( u ) = Tko.TK_TUPLE then return
    dim as long have = TupleArity_( c, u )
    dim as Tko.SourceRange r = Tko.PointRange( c.ast->Loc( at ) )
    if have < 0 then
        c.diags->Report( Tko.TKO0826, r, c.types->Name( u ) )
    elseif have <> names then
        c.diags->Report( Tko.TKO0825, r, trim( str( have ) ), trim( str( names ) ) )
    end if
end sub

private sub CheckDestructure_( byref c as Ctx )
    for i as long = 1 to c.ast->Count( )
        dim as Tko.NodeId n = cast( Tko.NodeId, i )
        dim as Tko.NodeKind k = c.ast->Kind( n )
        if (k <> Tko.N_AMBIGUOUS) andalso (k <> Tko.N_VAR) then continue for
        dim as Tko.StmtPayload ptr sp = @c.ast->stmts[cast( long, c.ast->nodes[cast( long, n )].data )]
        if k = Tko.N_AMBIGUOUS then
            if sp->op <> cast( ushort, Tko.TK_EQ ) then continue for
            if (sp->a = Tko.NODE_NONE) orelse (sp->b = Tko.NODE_NONE) then continue for
            if c.ast->Kind( sp->a ) <> Tko.N_TUPLE then continue for
            '' 'let ( a, b ) = udt' assigns FIELDS in order, and is not this -- NF_LET_LIST.
            if (c.ast->nodes[cast( long, sp->a )].flags and Tko.NF_LET_LIST) <> 0 then continue for
            dim as long cnt = c.ast->lists[cast( long, c.ast->nodes[cast( long, sp->a )].data )].count
            DestructureJudge_( c, n, TypeOf_( c, sp->b ), cnt )
        else
            '' 'var (a) = x' is the parser's TKO0821 -- a single name is not judged twice.
            if sp->count < 3 then continue for
            dim as Tko.NodeId first_ = cast( Tko.NodeId, c.ast->children[sp->first] )
            if c.ast->Kind( first_ ) <> Tko.N_VAR_ITEM then continue for
            dim as Tko.StmtPayload ptr fp = @c.ast->stmts[cast( long, c.ast->nodes[cast( long, first_ )].data )]
            if left( c.names->Spelling( fp->name ), 3 ) <> "$dt" then continue for
            if fp->b = Tko.NODE_NONE then continue for
            DestructureJudge_( c, n, TypeOf_( c, fp->b ), sp->count - 1 )
        end if
    next
end sub

sub CheckForEach_( byref c as Ctx )
    for i as long = 1 to c.ast->Count( )
        dim as Tko.NodeId n = cast( Tko.NodeId, i )
        if c.ast->Kind( n ) <> Tko.N_FOREACH then continue for
        dim as Tko.StmtPayload ptr sp = _
            @c.ast->stmts[cast( long, c.ast->nodes[cast( long, n )].data )]
        if sp->count <> 1 then continue for

        dim as Tko.NodeId seqE = cast( Tko.NodeId, c.ast->children[sp->first] )
        dim as Tko.TypeId seqT = TypeOf_( c, seqE )
        '' NO TYPE IS NOT A DIAGNOSTIC HERE. The sequence may be an expression nothing
        '' has typed yet, and reporting "not iterable" for one of those would put an
        '' error on every program that merely has something else wrong with it.
        if seqT = Tko.TYPE_NONE then continue for
        seqT = c.types->Unqualify( seqT )
        if c.types->Kind( seqT ) = Tko.TK_REFERENCE then
            seqT = c.types->Unqualify( c.types->Inner( seqT ) )
        end if

        dim as Tko.SourceRange r = Tko.PointRange( c.ast->Loc( n ) )
        dim as Tko.TypeId elT = Tko.TYPE_NONE
        dim as boolean ok = true

        if IsFixedStrTypeC_( c, seqT ) then
            c.diags->Report( Tko.TKO0609, r )
            ok = false
        elseif IsUStringTypeC_( c, seqT ) then
            '' A USTRING IS NOT WALKED, and this is where it is refused -- not in lowering,
            '' which used to decline it silently while Check had already accepted it. The
            '' loop then emitted nothing and ran zero times, which is the one outcome worse
            '' than either answer (tiko-book T17). fbc refuses it too, as error 342.
            c.diags->Report( Tko.TKO0688, r )
            ok = false
        elseif c.types->Kind( seqT ) = Tko.TK_ARRAY then
            if ArrayRankOf_( c, seqT ) > 1 then
                c.diags->Report( Tko.TKO0608, r )
                ok = false
            else
                elT = c.types->Inner( seqT )
            end if
        elseif IsVarLenStringType_( c, seqT ) then
            elT = c.types->Builtin( Tko.TY_UBYTE )
            '' 'for each BYREF' OVER A STRING binds nothing: fbc's error 345 (T72). tiko
            '' bound a copy of each character and the loop changed nothing, silently.
            if sp->op = cast( ushort, Tko.KW_BYREF ) then
                c.diags->Report( Tko.TKO0941, r )
                ok = false
            end if
        elseif c.types->Kind( seqT ) = Tko.TK_UDT then
            dim as Tko.SymbolId gi = UdtMemberSym_( c, seqT, "getiterator" )
            dim as Tko.Symbol ptr gs = c.syms->SymbolAt( gi )
            dim as Tko.TypeId itT = Tko.TYPE_NONE
            if gs <> 0 then itT = gs->type_
            if (itT = Tko.TYPE_NONE) orelse (c.types->Kind( itT ) <> Tko.TK_UDT) then
                c.diags->Report( Tko.TKO0606, r, c.types->Name( seqT ) )
                ok = false
            else
                dim as string miss = MissingIterMember_( c, itT )
                if len( miss ) > 0 then
                    c.diags->Report( Tko.TKO0607, r, c.types->Name( itT ), miss )
                    ok = false
                else
                    dim as Tko.Symbol ptr vo = _
                        c.syms->SymbolAt( UdtMemberSym_( c, itT, "value" ) )
                    '' 'for each BYREF' BINDS THE ELEMENT, so Value( ) has to hand one back --
                    '' fbc's error 345 otherwise, "Cannot bind BYREF in FOR EACH, the
                    '' iterator's Value( ) returns by value" (fbc-modern 1.20, 2026-09-25;
                    '' its generics/fail-foreach-byref.bas). tiko built no program and said
                    '' nothing. The flag is the one lowereach.bas reads: NF_BYREF on the
                    '' Value( ) declaration. An array needs nothing of the kind.
                    if (vo <> 0) andalso (sp->op = cast( ushort, Tko.KW_BYREF )) then
                        dim as Tko.NodeId vpn = cast( Tko.NodeId, vo->payload )
                        if (vpn <> Tko.NODE_NONE) andalso (c.ast->Kind( vpn ) = Tko.N_PROC) then
                            if (c.ast->nodes[cast( long, vpn )].flags and Tko.NF_BYREF) = 0 then
                                c.diags->Report( Tko.TKO0818, r, c.types->Name( itT ) )
                                ok = false
                            end if
                        end if
                    end if
                    if vo <> 0 then
                        elT = vo->type_
                        if elT <> Tko.TYPE_NONE then
                            if c.types->Kind( elT ) = Tko.TK_REFERENCE then
                                elT = c.types->Inner( elT )
                            end if
                        end if
                    end if
                end if
            end if
        else
            c.diags->Report( Tko.TKO0606, r, c.types->Name( seqT ) )
            ok = false
        end if

        '' THE NAME LIST, against the element it will be taken apart into. An arity that
        '' does not match would otherwise surface as a missing '_3' on a type nobody
        '' wrote, in a body the source does not contain.
        if ok = false then continue for
        if (c.ast->nodes[cast( long, n )].flags and Tko.NF_DESTRUCTURE) = 0 then
            continue for
        end if
        dim as long want = DestructureArity_( c, sp->b )
        if want < 2 then continue for
        if elT = Tko.TYPE_NONE then continue for
        dim as long have = TupleArity_( c, elT )
        if have < 0 then
            c.diags->Report( Tko.TKO0610, r, c.types->Name( elT ) )
        elseif have <> want then
            c.diags->Report( Tko.TKO0611, r, trim( str( want ) ), trim( str( have ) ) )
        end if
    next
    CheckDestructure_( c )
end sub
