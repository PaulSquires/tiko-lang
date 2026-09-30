'' fieldctor.bas -- a FIELD of a type with no default constructor: fbc's error 183.
''
'' Included from latechecks.bas, inside its namespace, after HasDefaultCtor_, which it
'' shares with the variable check (CheckExternInitAndDefaultCtor_). Split out at the
'' 1500-line cap.

'' ...AND A FIELD IS BUILT WITH ITS TYPE: a field of a type with constructors and no default
'' one is fbc's error 183 at the FIELD, used or not (fbc-modern 1.20, 2026-09-25): 'as NDC f'
'' and 'as NDC arr( 1 )', in a type with a constructor of its own too; not '= NDC( 1 )', a
'' ptr or a static member; a UNION is 163, not this. fbc's generics/fail-result-nodefaultctor
'' .bas -- Result( of long, NoDefaultCtor ) holds an E by value -- compiled: tiko checked
'' only a variable. A generic's field is reported in the instance.
private sub CheckFieldDefaultCtor_( byref c as Ctx )
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr s = @c.syms->symbols[i]
        if s->kind <> cast( ubyte, SYM_FIELD ) then continue for
        if (s->flags and SYMF_STATIC) <> 0 then continue for
        '' The inheritance BASE is a field too, and its own rule -- fbc's 186 and 188 -- is
        '' CheckBaseHasDefaultCtor_'s: 'extends NeedsArg' is not reported twice.
        if s->name = c.baseName then continue for
        if s->type_ = TYPE_NONE then continue for
        '' A bitfield's payload is its WIDTH, not a node -- the kind check is what says so. A
        '' generic INSTANCE's field has none (payload 0) and is placed by its own loc; so do
        '' the synthesized 'base' and a spawn frame's '__ARG_k', which are not this question.
        dim as NodeId fn = cast( NodeId, s->payload )
        dim as SourceLoc at = s->loc
        if fn = NODE_NONE then
            dim as SymScope ptr fs0 = c.syms->ScopeAt( s->parent )
            if fs0 = 0 then continue for
            dim as Symbol ptr ow0 = c.syms->SymbolAt( fs0->owner )
            if ow0 = 0 then continue for
            if instr( c.names->Spelling( ow0->name ), "<" ) = 0 then continue for
        else
            if cast( long, fn ) > c.ast->Count( ) then continue for
            if c.ast->Kind( fn ) <> N_FIELD then continue for
            if c.ast->stmts[cast( long, c.ast->nodes[cast( long, fn )].data )].c <> NODE_NONE then continue for
            at = c.ast->Loc( fn )
        end if
        dim as SymScope ptr ps = c.syms->ScopeAt( s->parent )
        if ps = 0 then continue for
        dim as Symbol ptr os = c.syms->SymbolAt( ps->owner )
        if os <> 0 then
            if (os->flags and SYMF_UNION_KIND) <> 0 then continue for
        end if
        dim as TypeId u = c.types->Unqualify( s->type_ )
        dim as boolean isArray = false
        dim as long guard = 0
        while (c.types->Kind( u ) = TK_ARRAY) andalso (guard < 16)
            guard += 1
            isArray = true
            u = c.types->Unqualify( c.types->Inner( u ) )
        wend
        if c.types->Kind( u ) <> TK_UDT then continue for
        if HasDefaultCtor_( c, u, false ) then continue for    '' a field array is not REDIM'd -- see HasDefaultCtor_
        c.diags->Report( TKO0657, PointRange( at ), c.names->Spelling( s->name ) )
    next
end sub

'' Is this N_VAR_ITEM declared by a REDIM? Its statement is built after it, and names it.
private function ItemIsRedim_ ( byref c as Ctx, byval item as NodeId ) as boolean
    for n as long = cast( long, item ) + 1 to c.ast->Count( ) - 1
        if c.ast->Kind( cast( NodeId, n ) ) <> N_VAR then continue for
        dim as StmtPayload ptr sp = @c.ast->stmts[cast( long, c.ast->nodes[n].data )]
        for k as long = 0 to sp->count - 1
            if cast( NodeId, c.ast->children[sp->first + k] ) = item then return (sp->op = cast( ushort, KW_REDIM ))
        next
        if n > cast( long, item ) + 4096 then exit for
    next
    return false
end function

'' A 'static byref' FIELD is a declaration: it is bound where it is defined, 'dim byref
'' T.ri as integer = x' outside the type, and fbc takes it without one there (fbc-modern
'' 1.20, 2026-09-30; dim/byref2.bas, dim/byref-init-from-byref.bas). The definition is
'' what must carry the initializer -- fbc's 320 is on its line. An EXTERN is the same:
'' 'extern byref ri as integer' is fine alone (dim/byref.bas), and its 'dim' is judged.
private function ByrefNeedsInit_ ( byref c as Ctx, byval s as Symbol ptr ) as boolean
    if (s->flags and SYMF_EXTERN) <> 0 then return false
    dim as SymScope ptr sc = c.syms->ScopeAt( s->parent )
    return (sc = 0) orelse (sc->kind <> cast( ubyte, SCOPEK_TYPE ))
end function
