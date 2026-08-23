'' decltype.bas -- TYPE, ENUM and NAMESPACE declarations, and the top-level
'' Declaration dispatch.  Included by decl.bas, INSIDE namespace Fbx.Parse.

private function ParseTypeDecl( byref p as Fbx.ParserState ) as Fbx.NodeId
    dim as Fbx.Token t = Cur( p )
    dim as long typeTok0 = p.pos
    dim as boolean isUnion = (Peek( p ) = Fbx.KW_UNION)
    Advance( p )

    '' 'type as integer myint' -- the REVERSED typedef, and it has to be tested before
    '' DeclName, which happily takes 'as' as the name. That is what happened: the type
    '' was called 'as', the next token was not AS, and the parser fell through to the
    '' aggregate body and hunted for an 'end type' that was never coming.
    ''
    '' Measured: fbc accepts 'type as integer myint', 'type as const u ptr t', the
    '' procedure form 'type as function( as integer ) as integer PFunc', and a COMMA
    '' LIST -- 'type as integer a, b' declares both, and three corpus files use it.
    dim as Fbx.StmtPayload sp
    if Peek( p ) = Fbx.KW_AS then
        Advance( p )
        dim as Fbx.NodeId aliased = TypeRef( p )
        sp.a = aliased
        DeclName( p, sp.name )
        '' Every name after the first becomes its own N_TYPEDEF child sharing the same
        '' type reference. One node per name is what Collect and Resolve already know
        '' how to handle; a payload with a name LIST would need a new shape in both.
        dim as Fbx.NodeIdVec extra
        while Accept( p, Fbx.TK_COMMA )
            dim as Fbx.Token nt = Cur( p )
            dim as Fbx.StmtPayload ep
            ep.a = aliased
            if DeclName( p, ep.name ) = false then exit while
            extra.Push( cast( ulong, MakeStmt( p, Fbx.N_TYPEDEF, nt.loc, ep ) ) )
        wend
        sp.first = p.ast->children.Count
        sp.count = extra.Count
        for i as long = 0 to extra.Count - 1
            p.ast->children.Push( extra[i] )
        next
        return MakeStmt( p, Fbx.N_TYPEDEF, t.loc, sp )
    end if

    '' 'union field = 4' -- an ANONYMOUS aggregate carrying the alignment clause. The
    '' branch below already anticipates a FIELD after the name, but it never ran,
    '' because DeclName happily takes 'field' AS the name: the union was called 'field',
    '' and a TYPE containing two of them reported a duplicate. 14 corpus files, all
    '' through winnt.bi.
    ''
    '' The '=' is what tells the clause from a genuine name -- 'union field' with
    '' nothing after it really is a union called 'field'.
    dim as boolean fieldClause = false
    if Peek( p ) = Fbx.KW_FIELD then
        if HasTok( p, p.pos + 1 ) then
            fieldClause = _
                (cast( Fbx.TokenKind, p.toks->At( p.pos + 1 ).kind ) = Fbx.TK_EQ)
        end if
    end if

    if fieldClause orelse (DeclName( p, sp.name ) = false) then
        '' An ANONYMOUS union or type, which is legal inside another aggregate and
        '' nowhere else. Its members belong to the enclosing type, so it carries no
        '' name and Collect splices it rather than opening a scope.
        if (p.aggDepth > 0) andalso _
           ((Peek( p ) = Fbx.TK_EOL) orelse (Peek( p ) = Fbx.KW_FIELD)) then
            sp.name = 0
            ParseFieldClause( p, sp )
            dim as Fbx.NodeId anon = ParseAggregateBody( p, t, sp, isUnion )
            return anon
        end if
        '' 'type as long ptr Foo' is a typedef. But 'type' with nothing after it is
        '' malformed, and silently returning a node would swallow the error.
        if Peek( p ) <> Fbx.KW_AS then
            ErrorNode( p, Fbx.FBX0406 )
            return MakeStmt( p, Fbx.N_TYPEDEF, t.loc, sp )
        end if
        Advance( p )
        sp.a = TypeRef( p )
        DeclName( p, sp.name )
        return MakeStmt( p, Fbx.N_TYPEDEF, t.loc, sp )
    end if

    '' 'type Foo as long' -- also a typedef.
    if Peek( p ) = Fbx.KW_AS then
        Advance( p )
        sp.a = TypeRef( p )

        '' A COMMA LIST, and unlike the reversed 'type as integer a, b' form each
        '' declarator carries its OWN type: 'type a as integer, b as double' declares
        '' a as integer and b as double. Only the first was parsed, so the rest of the
        '' line was silently dropped -- 'dim x2 as b' then had no type at all and its
        '' slot lowered to VOID. Measured: fbc accepts it and gives x2 a double.
        dim as Fbx.NodeIdVec extra2
        while Accept( p, Fbx.TK_COMMA )
            dim as Fbx.Token nt2 = Cur( p )
            dim as Fbx.StmtPayload ep2
            if DeclName( p, ep2.name ) = false then exit while
            if Accept( p, Fbx.KW_AS ) = false then exit while
            ep2.a = TypeRef( p )
            extra2.Push( cast( ulong, MakeStmt( p, Fbx.N_TYPEDEF, nt2.loc, ep2 ) ) )
        wend
        sp.first = p.ast->children.Count
        sp.count = extra2.Count
        for i as long = 0 to extra2.Count - 1
            p.ast->children.Push( extra2[i] )
        next
        return MakeStmt( p, Fbx.N_TYPEDEF, t.loc, sp )
    end if

    '' 'type Box( of T )' -- THE TYPE PARAMETERS ARE KEPT, as an N_BLOCK of N_IDENT in
    '' 'b'. They used to be skipped, which is why every instantiation of one generic
    '' was the same type: 'Box( of long )' and 'Box( of double )' both resolved to one
    '' fieldless UDT of size ZERO, and every access through one declined.
    ''
    '' 'of' is CONTEXTUAL in fbc-modern -- there is no KW_OF -- so it is matched by
    '' spelling, and a paren group that does not start with it keeps the old blind
    '' skip rather than being reinterpreted.
    if Peek( p ) = Fbx.TK_LPAREN then
        dim as long saveG = p.pos
        Advance( p )
        dim as boolean isGen = false
        if Peek( p ) = Fbx.TK_IDENT then
            isGen = (p.names->Spelling( cast( Fbx.InternId, Cur( p ).literal ) ) = "of")
        end if
        if isGen then
            Advance( p )
            sp.b = ParseTypeParams( p )
        else
            p.pos = saveG
            while (Peek( p ) <> Fbx.TK_RPAREN) andalso (AtEnd( p ) = false)
                Advance( p )
            wend
            Expect( p, Fbx.TK_RPAREN, ")" )
        end if
    end if
    ParseFieldClause( p, sp )

    if Accept( p, Fbx.KW_EXTENDS ) then sp.c = TypeRef( p )

    dim as boolean isGeneric = (sp.b <> Fbx.NODE_NONE)
    dim as Fbx.NodeId tn = ParseAggregateBody( p, t, sp, isUnion )
    '' Only a GENERIC is recorded. An ordinary TYPE is never re-parsed, and the table
    '' is scanned linearly, so keeping every type in it would cost for nothing.
    if isGeneric then p.ast->RecordTokens( tn, typeTok0, p.pos )
    return tn
end function

private function ParseEnumDecl( byref p as Fbx.ParserState ) as Fbx.NodeId
    dim as Fbx.Token t = Cur( p )
    Advance( p )
    dim as Fbx.StmtPayload sp
    DeclName( p, sp.name )

    '' 'enum E explicit' -- the members are reachable ONLY as 'E.A'. Without this
    '' EXPLICIT was consumed as the enum's FIRST MEMBER: a constant nobody wrote, which
    '' collides with anything actually named 'explicit' and shifts every real member's
    '' implicit value by one. No diagnostic either way.
    ''
    '' The keyword is recorded and the SCOPING it implies is NOT implemented: fbc says
    '' a bare 'A' is error 42 for an explicit enum, and fbx still resolves it, because
    '' the members would need a scope of their own and 'E.A' a path to reach into it.
    '' Accepting more than fbc never loses a file; the diagnostic is owed.
    dim as boolean isExplicit = Accept( p, Fbx.KW_EXPLICIT )

    dim as Fbx.NodeIdVec items
    do
        SkipEols( p )
        if AtEnd( p ) then exit do
        if Peek( p ) = Fbx.KW_END then exit do

        dim as Fbx.Token it = Cur( p )
        dim as Fbx.StmtPayload ip
        if DeclName( p, ip.name ) = false then
            Advance( p )
            continue do
        end if
        if Accept( p, Fbx.TK_EQ ) then ip.b = Expression( p )
        items.Push( cast( ulong, MakeStmt( p, Fbx.N_ENUM_ITEM, it.loc, ip ) ) )
        if Accept( p, Fbx.TK_COMMA ) = false then EndOfStatement( p )
    loop

    sp.first = p.ast->children.Count
    sp.count = items.Count
    for i as long = 0 to items.Count - 1
        p.ast->children.Push( items[i] )
    next
    ExpectEnd( p, Fbx.KW_ENUM )
    '' Recorded in 'extra' rather than a node flag: the ushort NF_ set is fully
    '' allocated, and N_ENUM uses 'extra' for nothing else.
    if isExplicit then sp.extra = 1
    return MakeStmt( p, Fbx.N_ENUM, t.loc, sp )
end function

private function ParseNamespaceDecl( byref p as Fbx.ParserState ) as Fbx.NodeId
    dim as Fbx.Token t = Cur( p )
    Advance( p )
    '' 'namespace a.b.c' opens THREE nested namespaces, not one called 'c'. fbcunit's
    '' SUITE macro expands to exactly this, and keeping only the last component made
    '' every generated procedure mangle three qualifiers short of fbc's.
    dim as FB.Array( of ulong ) parts
    dim as Fbx.StmtPayload sp
    DeclName( p, sp.name )

    '' 'namespace aaa alias "aaa"' -- a MANGLING control, exactly as it is on a
    '' procedure. Measured: fbc accepts it, and REJECTS an empty one with error 304,
    '' "ALIAS name string is empty" -- which the corpus tests, so the string is kept
    '' rather than skipped and the diagnostic is owed from the checker.
    if Accept( p, Fbx.KW_ALIAS ) then
        if Peek( p ) = Fbx.TK_STRING_LIT then
            sp.aliasName = StringLitText( p )
            Advance( p )
        end if
    end if
    parts.Push( cast( ulong, sp.name ) )
    while Peek( p ) = Fbx.TK_DOT
        Advance( p )
        DeclName( p, sp.name )
        parts.Push( cast( ulong, sp.name ) )
    wend

    dim as Fbx.NodeIdVec members
    do
        SkipEols( p )
        if AtEnd( p ) then exit do
        if Peek( p ) = Fbx.KW_END then exit do
        dim as long before = p.pos
        dim as Fbx.NodeId s = Statement( p )
        if s <> Fbx.NODE_NONE then members.Push( cast( ulong, s ) )
        if p.pos = before then Advance( p )
    loop

    sp.first = p.ast->children.Count
    sp.count = members.Count
    for i as long = 0 to members.Count - 1
        p.ast->children.Push( members[i] )
    next
    ExpectEnd( p, Fbx.KW_NAMESPACE )

    '' Innermost first: each outer level wraps the one below as its single member.
    sp.name = cast( Fbx.InternId, parts[parts.Count - 1] )
    dim as Fbx.NodeId n = MakeStmt( p, Fbx.N_NAMESPACE, t.loc, sp )
    for i as long = parts.Count - 2 to 0 step -1
        dim as Fbx.StmtPayload outer
        outer.name = cast( Fbx.InternId, parts[i] )
        outer.first = p.ast->children.Count
        outer.count = 1
        p.ast->children.Push( cast( ulong, n ) )
        n = MakeStmt( p, Fbx.N_NAMESPACE, t.loc, outer )
    next
    return n
end function

private function MarkPrivate _
    ( byref p as Fbx.ParserState, byval n as Fbx.NodeId, _
      byval isPrivate as boolean ) as Fbx.NodeId

    if (isPrivate = false) orelse (n = Fbx.NODE_NONE) then return n
    if p.ast->Kind( n ) <> Fbx.N_PROC then return n
    dim as Fbx.StmtPayload ptr sp = _
        @p.ast->stmts[cast( long, p.ast->nodes[cast( long, n )].data )]
    sp->extra or= Fbx.PF_PRIVATE
    return n
end function

function Declaration( byref p as Fbx.ParserState ) as Fbx.NodeId
    dim as Fbx.Token t = Cur( p )
    dim as Fbx.TokenKind k = Peek( p )

    '' 'private'/'public' only qualify what follows -- except that PRIVATE makes a
    '' procedure module-static, which means it has no linker-visible name at all.
    dim as boolean isPrivate = false
    if (k = Fbx.KW_PRIVATE) orelse (k = Fbx.KW_PUBLIC) then
        isPrivate = (k = Fbx.KW_PRIVATE)
        Advance( p )
        k = Peek( p )
    end if

    '' 'extern "C" ... end extern' is a linkage BLOCK; 'extern x as long' is a
    '' variable declaration. The string literal is what tells them apart.
    if k = Fbx.KW_EXTERN then
        dim as boolean isBlock = false
        if HasTok( p, p.pos + 1 ) then
            isBlock = (cast( Fbx.TokenKind, p.toks->At( p.pos + 1 ).kind ) = Fbx.TK_STRING_LIT)
        end if
        if isBlock then
            Advance( p )
            dim as Fbx.StmtPayload sp
            '' The language decides how everything inside is NAMED: 'C' and
            '' 'Windows' take the source spelling verbatim, case and all, and the
            '' OVERLOAD keyword is ignored for them.
            dim as Fbx.InternId lang = StringLitText( p )
            sp.aliasName = lang
            sp.a = Expression( p, Fbx.PREC_POSTFIX )
            EndOfStatement( p )
            dim as boolean foreign_ = false
            if lang <> 0 then
                foreign_ = (Fbx.Text.LowerAscii( p.names->Spelling( lang ) ) <> "fb")
            end if

            dim as Fbx.NodeIdVec members
            do
                SkipEols( p )
                if AtEnd( p ) then exit do
                if Peek( p ) = Fbx.KW_END then exit do
                dim as long before = p.pos
                dim as Fbx.NodeId st = Statement( p )
                if st <> Fbx.NODE_NONE then members.Push( cast( ulong, st ) )
                if p.pos = before then Advance( p )
            loop

            sp.first = p.ast->children.Count
            sp.count = members.Count
            for i as long = 0 to members.Count - 1
                dim as Fbx.NodeId m = cast( Fbx.NodeId, members[i] )
                if foreign_ andalso (p.ast->Kind( m ) = Fbx.N_PROC) then
                    dim as Fbx.StmtPayload ptr mp = _
                        @p.ast->stmts[cast( long, p.ast->nodes[cast( long, m )].data )]
                    mp->extra or= Fbx.PF_FOREIGN
                    '' The BLOCK supplies a convention to members that wrote none:
                    '' measured, 'extern "C"' gives _EC and 'extern "Windows"' _EW@4.
                    if Fbx.CallConvOf( mp->extra ) = Fbx.CC_NONE then
                        dim as string lg = Fbx.Text.LowerAscii( p.names->Spelling( lang ) )
                        if lg = "c" then
                            mp->extra or= Fbx.PF_CDECL
                        elseif left( lg, 7 ) = "windows" then
                            mp->extra or= Fbx.PF_STDCALL
                        end if
                    end if
                end if
                p.ast->children.Push( members[i] )
            next
            ExpectEnd( p, Fbx.KW_EXTERN )
            return MakeStmt( p, Fbx.N_EXTERN_BLOCK, t.loc, sp )
        end if
    end if

    '' A leading CONST, STATIC, VIRTUAL or ABSTRACT followed by a procedure keyword
    '' modifies the PROCEDURE; it does not start a constant or a variable declaration.
    '' The keyword is deliberately NOT consumed here -- ParseProc's own modifier loop
    '' reads it, which is why this only has to route.
    dim as boolean procQual = (k = Fbx.KW_CONST) orelse (k = Fbx.KW_STATIC) orelse _
                              (k = Fbx.KW_VIRTUAL) orelse (k = Fbx.KW_ABSTRACT)
    if procQual then
        if HasTok( p, p.pos + 1 ) then
            select case cast( Fbx.TokenKind, p.toks->At( p.pos + 1 ).kind )
            case Fbx.KW_SUB, Fbx.KW_FUNCTION, Fbx.KW_PROPERTY, Fbx.KW_OPERATOR, _
                 Fbx.KW_CONSTRUCTOR, Fbx.KW_DESTRUCTOR
                return MarkPrivate( p, ParseProc( p, false ), isPrivate )
            end select
        end if
    end if

    select case k
    case Fbx.KW_DIM, Fbx.KW_REDIM, Fbx.KW_VAR, Fbx.KW_STATIC, Fbx.KW_SHARED, _
         Fbx.KW_COMMON, Fbx.KW_EXTERN
        return ParseVarDecl( p )

    case Fbx.KW_CONST
        return ParseConstDecl( p )

    case Fbx.KW_TYPE, Fbx.KW_UNION
        return ParseTypeDecl( p )

    case Fbx.KW_ENUM
        return ParseEnumDecl( p )

    case Fbx.KW_NAMESPACE
        return ParseNamespaceDecl( p )

    case Fbx.KW_DECLARE
        Advance( p )
        return MarkPrivate( p, ParseProc( p, true ), isPrivate )

    case Fbx.KW_SUB, Fbx.KW_FUNCTION, Fbx.KW_PROPERTY, Fbx.KW_CONSTRUCTOR, _
         Fbx.KW_DESTRUCTOR, Fbx.KW_OPERATOR
        return MarkPrivate( p, ParseProc( p, false ), isPrivate )

    case Fbx.KW_USING
        Advance( p )
        dim as Fbx.StmtPayload sp
        DeclName( p, sp.name )
        while Peek( p ) = Fbx.TK_DOT
            Advance( p )
            DeclName( p, sp.name )
        wend
        return MakeStmt( p, Fbx.N_USING, t.loc, sp )

    case Fbx.KW_OPTION
        Advance( p )
        dim as Fbx.StmtPayload sp
        DeclName( p, sp.name )
        return MakeStmt( p, Fbx.N_OPTION, t.loc, sp )
    end select

    return ErrorNode( p, Fbx.FBX0408 )
end function
