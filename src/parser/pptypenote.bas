'' pptypenote.bas -- telling the preprocessor what a declaration's type is, for
'' '#if typeof( name )' (T61). #included by decltype.bas.
''
'' fbc reads a file once, so an '#if' below 'dim as long n' knows n is a LONG. tiko's
'' preprocessor runs ahead of the type system, but it is pulled by this parser, so a
'' declaration finished here is in place before the next line's directives are read --
'' the same arrangement PpNoteConst uses for a constant's value. Only types this side can
'' spell are noted: a builtin, a name, and 'ptr' levels over either.

'' The keywords that ARE types. Any other keyword in a TYPEREF is a name -- 'type Point'
'' is legal, POINT being the graphics function -- and is keyed as one.
private function BuiltinTypeKw_( byval k as Tko.TokenKind ) as boolean
    select case k
    case Tko.KW_BYTE, Tko.KW_UBYTE, Tko.KW_SHORT, Tko.KW_USHORT, Tko.KW_LONG, Tko.KW_ULONG, _
         Tko.KW_INTEGER, Tko.KW_UINTEGER, Tko.KW_LONGINT, Tko.KW_ULONGINT, Tko.KW_SINGLE, _
         Tko.KW_DOUBLE, Tko.KW_STRING, Tko.KW_ZSTRING, Tko.KW_WSTRING, Tko.KW_USTRING, _
         Tko.KW_BOOLEAN, Tko.KW_ANY
        return true
    end select
    return false
end function

'' A TYPEREF as the preprocessor keys it -- 'K<token kind>' or 'N<name>', then ' ptr' per
'' level -- or "" for a procedure type, a tuple, a qualified or generic name.
private function PpTypeKey_( byref p as Tko.ParserState, byval tr as Tko.NodeId ) as string
    dim as string suffix
    for guard as long = 0 to 15
        if tr = Tko.NODE_NONE then return ""
        if p.ast->Kind( tr ) <> Tko.N_TYPEREF then return ""
        dim as ushort fl = p.ast->nodes[cast( long, tr )].flags
        dim as Tko.StmtPayload ptr sp = @p.ast->stmts[cast( long, p.ast->nodes[cast( long, tr )].data )]
        if (fl and Tko.NF_PTR) <> 0 then
            suffix &= " ptr"
            tr = sp->a
            continue for
        end if
        if (fl and Tko.NF_PROC_TYPE) <> 0 then return ""
        if sp->count > 0 then return ""
        dim as Tko.TokenKind k = cast( Tko.TokenKind, sp->op )
        if (k <> Tko.TK_IDENT) andalso (BuiltinTypeKw_( k ) = false) then k = Tko.TK_IDENT
        if k = Tko.TK_IDENT then
            if sp->name = Tko.INTERN_NONE then return ""
            if instr( p.names->Spelling( sp->name ), "." ) > 0 then return ""
            return "N" & str( cast( long, p.names->Fold( sp->name ) ) ) & suffix
        end if
        if Tko.IsKeywordKind( k ) = false then return ""
        return "K" & str( cast( long, k ) ) & suffix
    next
    return ""
end function

'' A PARAMETER'S TYPE, for an '#if typeof( t )' in the body -- measured, fbc's
'' pp/typeof.bas writes '#if typeof( t ) = "STRING"' over 'byref t as __type__' in one
'' overload per type. Noted as its header is read, ahead of the body, and overwritten by
'' the next procedure's parameter of the same name, as a variable's is.
sub NoteParamType_( byref p as Tko.ParserState, byval n as Tko.NodeId )
    if (p.stream = 0) orelse (n = Tko.NODE_NONE) then return
    if p.ast->Kind( n ) <> Tko.N_PARAM then return
    dim as Tko.StmtPayload ptr sp = @p.ast->stmts[cast( long, p.ast->nodes[cast( long, n )].data )]
    if (sp->name = Tko.INTERN_NONE) orelse (sp->a = Tko.NODE_NONE) then return
    dim as string key = PpTypeKey_( p, sp->a )
    if len( key ) = 0 then return
    Tko.PpNoteType( *cast( Tko.PpStream ptr, p.stream ), sp->name, key, Tko.PP_TYPE_VAR, p.ast->Loc( n ) )
end sub

'' A DECLARATION JUST PARSED: each variable's type, each typedef's target, and each TYPE,
'' UNION or ENUM name.
private sub NoteTypes_( byref p as Tko.ParserState, byval n as Tko.NodeId )
    if (p.stream = 0) orelse (n = Tko.NODE_NONE) then return
    dim as Tko.PpStream ptr st = cast( Tko.PpStream ptr, p.stream )
    '' The payload is read only for the kinds that have one -- N_ERROR's data is 0 (F-72).
    if Tko.NodeKindCategory( p.ast->Kind( n ) ) <> Tko.NCAT_DECL then return
    dim as Tko.StmtPayload ptr sp = @p.ast->stmts[cast( long, p.ast->nodes[cast( long, n )].data )]
    select case p.ast->Kind( n )
    case Tko.N_VAR
        for i as long = 0 to sp->count - 1
            dim as Tko.NodeId item = cast( Tko.NodeId, p.ast->children[sp->first + i] )
            if p.ast->Kind( item ) <> Tko.N_VAR_ITEM then continue for
            dim as Tko.StmtPayload ptr ip = @p.ast->stmts[cast( long, p.ast->nodes[cast( long, item )].data )]
            Tko.PpNoteType( *st, ip->name, PpTypeKey_( p, ip->a ), Tko.PP_TYPE_VAR, p.ast->Loc( item ) )
        next
    case Tko.N_TYPEDEF
        dim as string key = PpTypeKey_( p, sp->a )
        Tko.PpNoteType( *st, sp->name, key, Tko.PP_TYPE_TYPEDEF, p.ast->Loc( n ) )
        for i as long = 0 to sp->count - 1
            dim as Tko.NodeId more = cast( Tko.NodeId, p.ast->children[sp->first + i] )
            if p.ast->Kind( more ) <> Tko.N_TYPEDEF then continue for
            dim as Tko.StmtPayload ptr mp = @p.ast->stmts[cast( long, p.ast->nodes[cast( long, more )].data )]
            Tko.PpNoteType( *st, mp->name, key, Tko.PP_TYPE_TYPEDEF, p.ast->Loc( more ) )
        next
    case Tko.N_TYPE, Tko.N_ENUM
        Tko.PpNoteType( *st, sp->name, "", Tko.PP_TYPE_NAMED, p.ast->Loc( n ) )
    end select
end sub
