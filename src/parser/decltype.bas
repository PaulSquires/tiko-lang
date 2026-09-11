'' decltype.bas -- TYPE, ENUM and NAMESPACE declarations, and the top-level
'' Declaration dispatch.  Included by decl.bas, INSIDE namespace Tko.Parse.

private function ParseTypeDecl( byref p as Tko.ParserState ) as Tko.NodeId
    dim as Tko.Token t = Cur( p )
    dim as long typeTok0 = p.pos
    dim as boolean isUnion = (Peek( p ) = Tko.KW_UNION)
    Advance( p )

    '' 'type as integer myint' -- the REVERSED typedef, and it has to be tested before
    '' DeclName, which happily takes 'as' as the name. That is what happened: the type
    '' was called 'as', the next token was not AS, and the parser fell through to the
    '' aggregate body and hunted for an 'end type' that was never coming.
    ''
    '' Measured: fbc accepts 'type as integer myint', 'type as const u ptr t', the
    '' procedure form 'type as function( as integer ) as integer PFunc', and a COMMA
    '' LIST -- 'type as integer a, b' declares both, and three corpus files use it.
    dim as Tko.StmtPayload sp
    if Peek( p ) = Tko.KW_AS then
        Advance( p )
        dim as Tko.NodeId aliased = TypeRef( p )
        sp.a = aliased
        DeclName( p, sp.name )
        '' Every name after the first becomes its own N_TYPEDEF child sharing the same
        '' type reference. One node per name is what Collect and Resolve already know
        '' how to handle; a payload with a name LIST would need a new shape in both.
        dim as Tko.NodeIdVec extra
        while Accept( p, Tko.TK_COMMA )
            dim as Tko.Token nt = Cur( p )
            dim as Tko.StmtPayload ep
            ep.a = aliased
            if DeclName( p, ep.name ) = false then exit while
            extra.Push( cast( ulong, MakeStmt( p, Tko.N_TYPEDEF, nt.loc, ep ) ) )
        wend
        sp.first = p.ast->children.Count
        sp.count = extra.Count
        for i as long = 0 to extra.Count - 1
            p.ast->children.Push( extra[i] )
        next
        return MakeStmt( p, Tko.N_TYPEDEF, t.loc, sp )
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
    if Peek( p ) = Tko.KW_FIELD then
        if HasTok( p, p.pos + 1 ) then
            fieldClause = _
                (cast( Tko.TokenKind, p.toks->At( p.pos + 1 ).kind ) = Tko.TK_EQ)
        end if
    end if

    '' THE SOURCE SPELLING, CASE PRESERVED. A UDT declared inside an 'extern "C++"'
    '' block mangles by what was WRITTEN, not by the folded name -- see
    '' TypeInfo.rawName. Harmless everywhere else: nothing reads it unless the
    '' declaration is marked foreign.
    sp.rawName = RawSpelling( p )
    if fieldClause orelse (DeclName( p, sp.name ) = false) then
        '' An ANONYMOUS union or type, which is legal inside another aggregate and
        '' nowhere else. Its members belong to the enclosing type, so it carries no
        '' name and Collect splices it rather than opening a scope.
        if (p.aggDepth > 0) andalso _
           ((Peek( p ) = Tko.TK_EOL) orelse (Peek( p ) = Tko.KW_FIELD)) then
            sp.name = 0
            ParseFieldClause( p, sp )
            dim as Tko.NodeId anon = ParseAggregateBody( p, t, sp, isUnion )
            return anon
        end if
        '' 'type as long ptr Foo' is a typedef. But 'type' with nothing after it is
        '' malformed, and silently returning a node would swallow the error.
        if Peek( p ) <> Tko.KW_AS then
            ErrorNode( p, Tko.TKO0406 )
            return MakeStmt( p, Tko.N_TYPEDEF, t.loc, sp )
        end if
        Advance( p )
        sp.a = TypeRef( p )
        DeclName( p, sp.name )
        return MakeStmt( p, Tko.N_TYPEDEF, t.loc, sp )
    end if

    '' 'type Foo as long' -- also a typedef.
    if Peek( p ) = Tko.KW_AS then
        Advance( p )
        sp.a = TypeRef( p )

        '' A COMMA LIST, and unlike the reversed 'type as integer a, b' form each
        '' declarator carries its OWN type: 'type a as integer, b as double' declares
        '' a as integer and b as double. Only the first was parsed, so the rest of the
        '' line was silently dropped -- 'dim x2 as b' then had no type at all and its
        '' slot lowered to VOID. Measured: fbc accepts it and gives x2 a double.
        dim as Tko.NodeIdVec extra2
        while Accept( p, Tko.TK_COMMA )
            dim as Tko.Token nt2 = Cur( p )
            dim as Tko.StmtPayload ep2
            if DeclName( p, ep2.name ) = false then exit while
            if Accept( p, Tko.KW_AS ) = false then exit while
            ep2.a = TypeRef( p )
            extra2.Push( cast( ulong, MakeStmt( p, Tko.N_TYPEDEF, nt2.loc, ep2 ) ) )
        wend
        sp.first = p.ast->children.Count
        sp.count = extra2.Count
        for i as long = 0 to extra2.Count - 1
            p.ast->children.Push( extra2[i] )
        next
        return MakeStmt( p, Tko.N_TYPEDEF, t.loc, sp )
    end if

    '' 'type Box( of T )' -- THE TYPE PARAMETERS ARE KEPT, as an N_BLOCK of N_IDENT in
    '' 'b'. They used to be skipped, which is why every instantiation of one generic
    '' was the same type: 'Box( of long )' and 'Box( of double )' both resolved to one
    '' fieldless UDT of size ZERO, and every access through one declined.
    ''
    '' 'of' is CONTEXTUAL in fbc-modern -- there is no KW_OF -- so it is matched by
    '' spelling, and a paren group that does not start with it keeps the old blind
    '' skip rather than being reinterpreted.
    if Peek( p ) = Tko.TK_LPAREN then
        dim as long saveG = p.pos
        Advance( p )
        dim as boolean isGen = false
        if Peek( p ) = Tko.TK_IDENT then
            isGen = (p.names->Spelling( cast( Tko.InternId, Cur( p ).literal ) ) = "of")
        end if
        if isGen then
            Advance( p )
            sp.b = ParseTypeParams( p )
        else
            p.pos = saveG
            while (Peek( p ) <> Tko.TK_RPAREN) andalso (AtEnd( p ) = false)
                Advance( p )
            wend
            Expect( p, Tko.TK_RPAREN, ")" )
        end if
    end if
    ParseFieldClause( p, sp )

    '' 'type UDT alias ""' -- fbc's error 304 -- the same empty-alias test the other
    '' sites make; a non-empty one is accepted and, as a mangling control, otherwise
    '' left alone here.
    if Accept( p, Tko.KW_ALIAS ) then
        if Peek( p ) = Tko.TK_STRING_LIT then
            dim as Tko.Token aTok = Cur( p )
            EmptyAliasCheck( p, StringLitText( p ), aTok, false )
            Advance( p )
        end if
    end if

    if Accept( p, Tko.KW_EXTENDS ) then sp.c = TypeRef( p )

    dim as boolean isGeneric = (sp.b <> Tko.NODE_NONE)
    dim as Tko.NodeId tn = ParseAggregateBody( p, t, sp, isUnion )
    '' Only a GENERIC is recorded. An ordinary TYPE is never re-parsed, and the table
    '' is scanned linearly, so keeping every type in it would cost for nothing.
    if isGeneric then p.ast->RecordTokens( tn, typeTok0, p.pos )
    return tn
end function

private function ParseEnumDecl( byref p as Tko.ParserState ) as Tko.NodeId
    dim as Tko.Token t = Cur( p )
    Advance( p )
    dim as Tko.StmtPayload sp
    DeclName( p, sp.name )

    '' 'enum E explicit' -- the members are reachable ONLY as 'E.A'. Without this
    '' EXPLICIT was consumed as the enum's FIRST MEMBER: a constant nobody wrote, which
    '' collides with anything actually named 'explicit' and shifts every real member's
    '' implicit value by one. No diagnostic either way.
    ''
    '' The keyword is recorded and the SCOPING it implies is NOT implemented: fbc says
    '' a bare 'A' is error 42 for an explicit enum, and tiko-lang still resolves it, because
    '' the members would need a scope of their own and 'E.A' a path to reach into it.
    '' Accepting more than fbc never loses a file; the diagnostic is owed.
    '' 'enum E alias ""' is fbc's error 304 as well.
    if Accept( p, Tko.KW_ALIAS ) then
        if Peek( p ) = Tko.TK_STRING_LIT then
            dim as Tko.Token eaTok = Cur( p )
            EmptyAliasCheck( p, StringLitText( p ), eaTok, false )
            Advance( p )
        end if
    end if
    dim as boolean isExplicit = Accept( p, Tko.KW_EXPLICIT )

    dim as Tko.NodeIdVec items
    do
        SkipEols( p )
        if AtEnd( p ) then exit do
        if Peek( p ) = Tko.KW_END then exit do

        dim as Tko.Token it = Cur( p )
        dim as Tko.StmtPayload ip
        if DeclName( p, ip.name ) = false then
            Advance( p )
            continue do
        end if
        if Accept( p, Tko.TK_EQ ) then ip.b = Expression( p )
        items.Push( cast( ulong, MakeStmt( p, Tko.N_ENUM_ITEM, it.loc, ip ) ) )
        if Accept( p, Tko.TK_COMMA ) = false then EndOfStatement( p )
    loop

    sp.first = p.ast->children.Count
    sp.count = items.Count
    for i as long = 0 to items.Count - 1
        p.ast->children.Push( items[i] )
    next
    ExpectEnd( p, Tko.KW_ENUM )
    '' Recorded in 'extra' rather than a node flag: the ushort NF_ set is fully
    '' allocated, and N_ENUM uses 'extra' for nothing else.
    if isExplicit then sp.extra = 1
    return MakeStmt( p, Tko.N_ENUM, t.loc, sp )
end function

private function ParseNamespaceDecl( byref p as Tko.ParserState ) as Tko.NodeId
    dim as Tko.Token t = Cur( p )
    Advance( p )
    '' 'namespace a.b.c' opens THREE nested namespaces, not one called 'c'. fbcunit's
    '' SUITE macro expands to exactly this, and keeping only the last component made
    '' every generated procedure mangle three qualifiers short of fbc's.
    dim as FB.Array( of ulong ) parts
    dim as Tko.StmtPayload sp
    DeclName( p, sp.name )

    '' 'namespace aaa alias "aaa"' -- a MANGLING control, exactly as it is on a
    '' procedure. Measured: fbc accepts it, and REJECTS an empty one with error 304,
    '' "ALIAS name string is empty" -- which the corpus tests, so the string is kept
    '' rather than skipped and the diagnostic is owed from the checker.
    if Accept( p, Tko.KW_ALIAS ) then
        if Peek( p ) = Tko.TK_STRING_LIT then
            dim as Tko.Token aTok = Cur( p )
            sp.aliasName = StringLitText( p )
            EmptyAliasCheck( p, sp.aliasName, aTok, false )
            Advance( p )
        end if
    end if
    parts.Push( cast( ulong, sp.name ) )
    while Peek( p ) = Tko.TK_DOT
        Advance( p )
        DeclName( p, sp.name )
        parts.Push( cast( ulong, sp.name ) )
    wend

    dim as Tko.NodeIdVec members
    do
        SkipEols( p )
        if AtEnd( p ) then exit do
        if Peek( p ) = Tko.KW_END then exit do
        dim as long before = p.pos
        dim as Tko.NodeId s = Statement( p )
        if s <> Tko.NODE_NONE then members.Push( cast( ulong, s ) )
        if p.pos = before then Advance( p )
    loop

    sp.first = p.ast->children.Count
    sp.count = members.Count
    for i as long = 0 to members.Count - 1
        p.ast->children.Push( members[i] )
    next
    ExpectEnd( p, Tko.KW_NAMESPACE )

    '' Innermost first: each outer level wraps the one below as its single member.
    sp.name = cast( Tko.InternId, parts[parts.Count - 1] )
    dim as Tko.NodeId n = MakeStmt( p, Tko.N_NAMESPACE, t.loc, sp )
    for i as long = parts.Count - 2 to 0 step -1
        dim as Tko.StmtPayload outer
        outer.name = cast( Tko.InternId, parts[i] )
        outer.first = p.ast->children.Count
        outer.count = 1
        p.ast->children.Push( cast( ulong, n ) )
        n = MakeStmt( p, Tko.N_NAMESPACE, t.loc, outer )
    next
    return n
end function

private function MarkPrivate _
    ( byref p as Tko.ParserState, byval n as Tko.NodeId, _
      byval isPrivate as boolean ) as Tko.NodeId

    if (isPrivate = false) orelse (n = Tko.NODE_NONE) then return n
    if p.ast->Kind( n ) <> Tko.N_PROC then return n
    dim as Tko.StmtPayload ptr sp = _
        @p.ast->stmts[cast( long, p.ast->nodes[cast( long, n )].data )]
    sp->extra or= Tko.PF_PRIVATE
    return n
end function

function Declaration( byref p as Tko.ParserState ) as Tko.NodeId
    dim as Tko.Token t = Cur( p )
    dim as Tko.TokenKind k = Peek( p )

    '' 'private'/'public' only qualify what follows -- except that PRIVATE makes a
    '' procedure module-static, which means it has no linker-visible name at all.
    dim as boolean isPrivate = false
    if (k = Tko.KW_PRIVATE) orelse (k = Tko.KW_PUBLIC) then
        isPrivate = (k = Tko.KW_PRIVATE)
        Advance( p )
        k = Peek( p )
    end if

    '' 'extern "C" ... end extern' is a linkage BLOCK; 'extern x as long' is a
    '' variable declaration. The string literal is what tells them apart.
    if k = Tko.KW_EXTERN then
        dim as boolean isBlock = false
        if HasTok( p, p.pos + 1 ) then
            isBlock = (cast( Tko.TokenKind, p.toks->At( p.pos + 1 ).kind ) = Tko.TK_STRING_LIT)
        end if
        if isBlock then
            Advance( p )
            dim as Tko.StmtPayload sp
            '' The language decides how everything inside is NAMED: 'C' and
            '' 'Windows' take the source spelling verbatim, case and all, and the
            '' OVERLOAD keyword is ignored for them.
            dim as Tko.InternId lang = StringLitText( p )
            sp.aliasName = lang
            sp.a = Expression( p, Tko.PREC_POSTFIX )
            '' 'extern "c" lib ""' -- fbc's error 305, "LIB name string is empty".
            if Accept( p, Tko.KW_LIB ) then
                if Peek( p ) = Tko.TK_STRING_LIT then
                    dim as Tko.Token lbTok = Cur( p )
                    EmptyAliasCheck( p, StringLitText( p ), lbTok, true )
                    Advance( p )
                end if
            end if
            EndOfStatement( p )
            dim as boolean foreign_ = false
            if lang <> 0 then
                foreign_ = (Tko.Text.LowerAscii( p.names->Spelling( lang ) ) <> "fb")
            end if

            dim as Tko.NodeIdVec members
            do
                SkipEols( p )
                if AtEnd( p ) then exit do
                if Peek( p ) = Tko.KW_END then exit do
                dim as long before = p.pos
                dim as Tko.NodeId st = Statement( p )
                if st <> Tko.NODE_NONE then members.Push( cast( ulong, st ) )
                if p.pos = before then Advance( p )
            loop

            sp.first = p.ast->children.Count
            sp.count = members.Count
            for i as long = 0 to members.Count - 1
                dim as Tko.NodeId m = cast( Tko.NodeId, members[i] )
                '' A FOREIGN BLOCK NAMES ITS VARIABLES TOO, not only its procedures.
                '' 'extern "Windows" : extern CLSID_ShellLink as const GUID' links by
                '' the source spelling; the same line outside a block is 'CLSID_SHELLLINK$'.
                if foreign_ andalso (p.ast->Kind( m ) = Tko.N_TYPE) then
                    dim as Tko.StmtPayload ptr tp2 = _
                        @p.ast->stmts[cast( long, p.ast->nodes[cast( long, m )].data )]
                    tp2->extra or= Tko.PF_FOREIGN
                end if
                if foreign_ andalso (p.ast->Kind( m ) = Tko.N_VAR) then
                    dim as Tko.StmtPayload ptr vp = _
                        @p.ast->stmts[cast( long, p.ast->nodes[cast( long, m )].data )]
                    vp->extra or= Tko.PF_FOREIGN
                end if
                if foreign_ andalso (p.ast->Kind( m ) = Tko.N_PROC) then
                    dim as Tko.StmtPayload ptr mp = _
                        @p.ast->stmts[cast( long, p.ast->nodes[cast( long, m )].data )]
                    mp->extra or= Tko.PF_FOREIGN
                    '' The BLOCK supplies a convention to members that wrote none:
                    '' measured, 'extern "C"' gives _EC and 'extern "Windows"' _EW@4.
                    if Tko.CallConvOf( mp->extra ) = Tko.CC_NONE then
                        dim as string lg = Tko.Text.LowerAscii( p.names->Spelling( lang ) )
                        if lg = "c" then
                            mp->extra or= Tko.PF_CDECL
                        elseif left( lg, 7 ) = "windows" then
                            mp->extra or= Tko.PF_STDCALL
                        end if
                    end if
                end if
                p.ast->children.Push( members[i] )
            next
            ExpectEnd( p, Tko.KW_EXTERN )
            return MakeStmt( p, Tko.N_EXTERN_BLOCK, t.loc, sp )
        end if
    end if

    '' A leading CONST, STATIC, VIRTUAL or ABSTRACT followed by a procedure keyword
    '' modifies the PROCEDURE; it does not start a constant or a variable declaration.
    '' The keyword is deliberately NOT consumed here -- ParseProc's own modifier loop
    '' reads it, which is why this only has to route.
    dim as boolean procQual = (k = Tko.KW_CONST) orelse (k = Tko.KW_STATIC) orelse _
                              (k = Tko.KW_VIRTUAL) orelse (k = Tko.KW_ABSTRACT)
    '' ...AND THERE MAY BE MORE THAN ONE OF THEM. 'const virtual sub A.s07( )' is one
    '' declaration and fbc emits it, mangled _ZNK1A3S07Ev and in the vtable. Peeking a
    '' single token saw 'virtual', fell through to ParseConstDecl, and reported
    '' "'virtual' has no type" -- and the desync then took the NEXT definition with it,
    '' which is where the decline landed. ParseProc's own modifier loop already reads
    '' the whole run; only the routing here stopped at one.
    if procQual then
        dim as long q = p.pos + 1
        do while HasTok( p, q )
            select case cast( Tko.TokenKind, p.toks->At( q ).kind )
            case Tko.KW_CONST, Tko.KW_STATIC, Tko.KW_VIRTUAL, Tko.KW_ABSTRACT
                q += 1
            case Tko.KW_SUB, Tko.KW_FUNCTION, Tko.KW_PROPERTY, Tko.KW_OPERATOR, _
                 Tko.KW_CONSTRUCTOR, Tko.KW_DESTRUCTOR
                return MarkPrivate( p, ParseProc( p, false ), isPrivate )
            case else
                exit do
            end select
        loop
    end if

    select case k
    case Tko.KW_DIM, Tko.KW_REDIM, Tko.KW_VAR, Tko.KW_STATIC, Tko.KW_SHARED, _
         Tko.KW_COMMON, Tko.KW_EXTERN
        return ParseVarDecl( p )

    case Tko.KW_CONST
        return ParseConstDecl( p )

    case Tko.KW_TYPE, Tko.KW_UNION
        return ParseTypeDecl( p )

    case Tko.KW_ENUM
        return ParseEnumDecl( p )

    case Tko.KW_NAMESPACE
        return ParseNamespaceDecl( p )

    case Tko.KW_DECLARE
        Advance( p )
        return MarkPrivate( p, ParseProc( p, true ), isPrivate )

    case Tko.KW_SUB, Tko.KW_FUNCTION, Tko.KW_PROPERTY, Tko.KW_CONSTRUCTOR, _
         Tko.KW_DESTRUCTOR, Tko.KW_OPERATOR
        return MarkPrivate( p, ParseProc( p, false ), isPrivate )

    case Tko.KW_USING
        Advance( p )
        dim as Tko.StmtPayload sp
        '' THE WHOLE PATH, DOTTED, in the one field -- the same shape a qualified TYPE
        '' REFERENCE and a member DEFINITION both keep.
        ''
        '' It used to OVERWRITE the name per component, so 'using a.b' arrived as plain
        '' 'b' -- which is not visible unqualified, so the lookup found nothing and
        '' AddUsing was never called at all. Seventeen corpus statements imported
        '' nothing and every name they were meant to bring in declined.
        dim as string usePath
        '' A LEADING '..' IS THE GLOBAL ROOT: 'using ..outer1' inside a namespace
        '' names the outer1 at FILE scope. fbc accepts it -- the probe prints 7 --
        '' and here the first token is a DOT, so DeclName failed, the path came out
        '' EMPTY, and the using imported nothing at all. The dots are kept in the
        '' path spelling; the resolver reads them.
        while Peek( p ) = Tko.TK_DOT
            Advance( p )
            usePath += "."
        wend
        DeclName( p, sp.name )
        if sp.name <> 0 then usePath += p.names->Spelling( sp.name )
        while Peek( p ) = Tko.TK_DOT
            Advance( p )
            dim as Tko.InternId comp = 0
            DeclName( p, comp )
            if comp = 0 then exit while
            usePath += "." & p.names->Spelling( comp )
        wend
        if len( usePath ) > 0 then sp.name = p.names->GetString( usePath )
        return MakeStmt( p, Tko.N_USING, t.loc, sp )

    case Tko.KW_OPTION
        Advance( p )
        dim as Tko.StmtPayload sp
        DeclName( p, sp.name )
        return MakeStmt( p, Tko.N_OPTION, t.loc, sp )
    end select

    return ErrorNode( p, Tko.TKO0408 )
end function

'' A calling convention -- RECORDED, not eaten: it decides the win32 name -- and,
'' with 'nameless', the OVERLOAD and ALIAS that may sit WHERE A NAME WOULD BE. A
'' constructor has none, and the name reader accepts any keyword, so it took those
'' as the name and then as the OWNING TYPE, losing the file from that line on.
function TakeProcPrefix_ _
    ( byref p as Tko.ParserState, byref sp as Tko.StmtPayload, _
      byval nameless as boolean = false ) as boolean
    if Tko.IsCallConvKind( Peek( p ) ) then
        select case Peek( p )
        case Tko.KW_CDECL   : sp.extra or= Tko.PF_CDECL
        case Tko.KW_STDCALL : sp.extra or= Tko.PF_STDCALL
        case Tko.KW_PASCAL  : sp.extra or= Tko.PF_PASCAL
        end select
        Advance( p )
        return true
    end if
    if nameless = false then return false
    if Accept( p, Tko.KW_OVERLOAD ) then
        sp.extra or= Tko.PF_OVERLOAD
        return true
    end if
    if Accept( p, Tko.KW_ALIAS ) then
        if Peek( p ) = Tko.TK_STRING_LIT then
            dim as Tko.Token aTok2 = Cur( p )
            sp.aliasName = StringLitText( p )
            EmptyAliasCheck( p, sp.aliasName, aTok2, false )
            Advance( p )
        end if
        return true
    end if
    return false
end function
