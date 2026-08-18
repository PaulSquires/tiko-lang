'' decl.bas -- declarations.  Included by parser.bas.

namespace Fbx.Parse

function IsDeclarationStart( byval k as Fbx.TokenKind ) as boolean
    select case k
    case Fbx.KW_DIM, Fbx.KW_REDIM, Fbx.KW_VAR, Fbx.KW_CONST, Fbx.KW_STATIC, _
         Fbx.KW_SHARED, Fbx.KW_COMMON, Fbx.KW_EXTERN, Fbx.KW_TYPE, Fbx.KW_UNION, _
         Fbx.KW_ENUM, Fbx.KW_DECLARE, Fbx.KW_SUB, Fbx.KW_FUNCTION, Fbx.KW_PROPERTY, _
         Fbx.KW_CONSTRUCTOR, Fbx.KW_DESTRUCTOR, Fbx.KW_OPERATOR, Fbx.KW_NAMESPACE, _
         Fbx.KW_USING, Fbx.KW_OPTION, Fbx.KW_PRIVATE, Fbx.KW_PUBLIC
        return true
    end select
    return false
end function

'' A name in declaration position: an identifier, or a keyword being reused as one
'' (which FreeBASIC allows in several places).
private function DeclName( byref p as Fbx.ParserState, byref outName as Fbx.InternId ) as boolean
    dim as Fbx.TokenKind k = Peek( p )
    if k = Fbx.TK_IDENT then
        outName = cast( Fbx.InternId, Cur( p ).literal )
        Advance( p )
        return true
    end if
    if Fbx.IsKeywordKind( k ) then
        outName = p.names->GetString( Fbx.Text.LowerAscii( Fbx.TokenKindText( k ) ) )
        Advance( p )
        return true
    end if
    outName = Fbx.INTERN_NONE
    return false
end function

'' 'dim x(0 to 9, 3) as long = 5' -- one item of a declaration list.
private function VarItem( byref p as Fbx.ParserState ) as Fbx.NodeId
    dim as Fbx.Token t = Cur( p )
    dim as Fbx.StmtPayload sp

    if DeclName( p, sp.name ) = false then return ErrorNode( p, Fbx.FBX0406 )

    '' 'dim UDT.i as integer' -- a qualified name defines a static member.
    dim as boolean qualified = false
    while Peek( p ) = Fbx.TK_DOT
        Advance( p )
        qualified = true
        DeclName( p, sp.name )
    wend

    '' Array bounds. 'dim x()' is a dynamic array with no bounds given.
    if Peek( p ) = Fbx.TK_LPAREN then
        Advance( p )
        dim as Fbx.NodeIdVec dims
        if Peek( p ) <> Fbx.TK_RPAREN then
            do
                dim as Fbx.NodeId lo = Expression( p )
                if Accept( p, Fbx.KW_TO ) then
                    dim as Fbx.Token rt = Cur( p )
                    dim as Fbx.StmtPayload rp
                    rp.a = lo
                    rp.b = Expression( p )
                    dims.Push( cast( ulong, MakeStmt( p, Fbx.N_CASE_RANGE, rt.loc, rp ) ) )
                else
                    dims.Push( cast( ulong, lo ) )
                end if
                if Accept( p, Fbx.TK_COMMA ) = false then exit do
            loop
        end if
        Expect( p, Fbx.TK_RPAREN, ")" )
        sp.c = MakeList( p, Fbx.N_BLOCK, t.loc, Fbx.NODE_NONE, dims )
    end if

    if Accept( p, Fbx.KW_AS ) then sp.a = TypeRef( p )

    '' '=' initialiser, or '=>' for a const.
    if (Peek( p ) = Fbx.TK_EQ) orelse (Peek( p ) = Fbx.TK_FATARROW) then
        Advance( p )
        sp.b = Expression( p )
    end if

    dim as Fbx.NodeId n = MakeStmt( p, Fbx.N_VAR_ITEM, t.loc, sp )
    if sp.c <> Fbx.NODE_NONE then p.ast->nodes[cast( long, n )].flags or= Fbx.NF_ARRAY
    if qualified then p.ast->nodes[cast( long, n )].flags or= Fbx.NF_QUALIFIED
    return n
end function

'' dim / redim / var / static / shared / common / extern, in any legal combination.
private function ParseVarDecl( byref p as Fbx.ParserState ) as Fbx.NodeId
    dim as Fbx.Token t = Cur( p )
    dim as Fbx.StmtPayload sp
    sp.op = cast( ushort, Peek( p ) )
    dim as ushort flags = 0

    '' The leading keywords may stack: 'dim shared', 'static shared', 'redim preserve'.
    do
        dim as Fbx.TokenKind k = Peek( p )
        select case k
        case Fbx.KW_DIM, Fbx.KW_REDIM, Fbx.KW_VAR, Fbx.KW_COMMON, Fbx.KW_EXTERN
            Advance( p )
        case Fbx.KW_SHARED
            flags or= Fbx.NF_SHARED
            Advance( p )
        case Fbx.KW_STATIC
            flags or= Fbx.NF_STATIC
            Advance( p )
        case Fbx.KW_PRESERVE
            flags or= Fbx.NF_PRESERVE
            Advance( p )
        case else
            exit do
        end select
    loop

    '' 'dim as long a, b' -- a shared type written before the names.
    dim as Fbx.NodeId sharedType = Fbx.NODE_NONE
    if Accept( p, Fbx.KW_AS ) then sharedType = TypeRef( p )

    dim as Fbx.NodeIdVec items
    do
        dim as long before = p.pos
        dim as Fbx.NodeId item = VarItem( p )
        items.Push( cast( ulong, item ) )
        '' The item may be an ERROR node, which has no StmtPayload -- indexing its
        '' 'data' as one is a segfault. Error nodes must be checked for, never
        '' assumed away (docs/plan/05 invariant 5).
        dim as boolean isItem = (p.ast->Kind( item ) = Fbx.N_VAR_ITEM)
        if isItem andalso (sharedType <> Fbx.NODE_NONE) then
            dim as long si = cast( long, p.ast->nodes[cast( long, item )].data )
            if p.ast->stmts[si].a = Fbx.NODE_NONE then p.ast->stmts[si].a = sharedType
        end if
        if isItem = false then exit do
        if p.pos = before then exit do
        if Accept( p, Fbx.TK_COMMA ) = false then exit do
    loop

    sp.first = p.ast->children.Count
    sp.count = items.Count
    for i as long = 0 to items.Count - 1
        p.ast->children.Push( items[i] )
    next

    dim as Fbx.NodeId n = MakeStmt( p, Fbx.N_VAR, t.loc, sp )
    p.ast->nodes[cast( long, n )].flags or= flags
    return n
end function

private function ParseConstDecl( byref p as Fbx.ParserState ) as Fbx.NodeId
    dim as Fbx.Token t = Cur( p )
    Advance( p )
    dim as Fbx.StmtPayload sp
    dim as Fbx.NodeIdVec items
    do
        items.Push( cast( ulong, VarItem( p ) ) )
        if Accept( p, Fbx.TK_COMMA ) = false then exit do
    loop
    sp.first = p.ast->children.Count
    sp.count = items.Count
    for i as long = 0 to items.Count - 1
        p.ast->children.Push( items[i] )
    next
    return MakeStmt( p, Fbx.N_CONST, t.loc, sp )
end function

'' One parameter: '[byval|byref] name [( )] [as T] [= default]'.
private function ParseParam( byref p as Fbx.ParserState ) as Fbx.NodeId
    dim as Fbx.Token t = Cur( p )
    dim as Fbx.StmtPayload sp
    dim as ushort flags = 0

    if Accept( p, Fbx.KW_BYVAL ) then
        '' byval is the marker absence of NF_BYREF
    elseif Accept( p, Fbx.KW_BYREF ) then
        flags or= Fbx.NF_BYREF
    end if

    if Peek( p ) = Fbx.TK_ELLIPSIS then
        Advance( p )
        dim as Fbx.NodeId v = MakeStmt( p, Fbx.N_PARAM, t.loc, sp )
        return v
    end if

    if DeclName( p, sp.name ) = false then return ErrorNode( p, Fbx.FBX0406 )

    if Peek( p ) = Fbx.TK_LPAREN then
        Advance( p )
        while (Peek( p ) <> Fbx.TK_RPAREN) andalso (AtEnd( p ) = false)
            Advance( p )
        wend
        Expect( p, Fbx.TK_RPAREN, ")" )
        flags or= Fbx.NF_ARRAY
    end if

    if Accept( p, Fbx.KW_AS ) then sp.a = TypeRef( p )
    if Accept( p, Fbx.TK_EQ ) then sp.b = Expression( p )

    dim as Fbx.NodeId n = MakeStmt( p, Fbx.N_PARAM, t.loc, sp )
    p.ast->nodes[cast( long, n )].flags or= flags
    return n
end function

sub ParseParamList( byref p as Fbx.ParserState, byref sp as Fbx.StmtPayload )
    dim as Fbx.NodeIdVec params
    if Peek( p ) = Fbx.TK_LPAREN then
        Advance( p )
        if Peek( p ) <> Fbx.TK_RPAREN then
            do
                dim as long before = p.pos
                params.Push( cast( ulong, ParseParam( p ) ) )
                if p.pos = before then exit do
                if Accept( p, Fbx.TK_COMMA ) = false then exit do
            loop
        end if
        Expect( p, Fbx.TK_RPAREN, ")" )
    end if
    sp.first = p.ast->children.Count
    sp.count = params.Count
    for i as long = 0 to params.Count - 1
        p.ast->children.Push( params[i] )
    next
end sub

'' sub / function / property / constructor / destructor / operator, declaration or
'' definition. 'declare' prefixes the declaration-only form.
private function ParseProc _
    ( byref p as Fbx.ParserState, byval declareOnly as boolean ) as Fbx.NodeId

    dim as Fbx.Token t = Cur( p )
    dim as Fbx.StmtPayload sp
    dim as Fbx.TokenKind kw = Peek( p )
    sp.op = cast( ushort, kw )
    Advance( p )

    '' The name may be qualified ('Stack.Push') or absent (constructors).
    dim as boolean qualified = false
    if (Peek( p ) = Fbx.TK_IDENT) orelse Fbx.IsKeywordKind( Peek( p ) ) then
        DeclName( p, sp.name )
        while Peek( p ) = Fbx.TK_DOT
            Advance( p )
            qualified = true
            DeclName( p, sp.name )
        wend
    end if

    '' An operator's name can be a token rather than a word: 'operator +'.
    if kw = Fbx.KW_OPERATOR then
        if (Peek( p ) <> Fbx.TK_LPAREN) andalso (AtEnd( p ) = false) then
            if Peek( p ) <> Fbx.TK_EOL then Advance( p )
        end if
    end if

    '' FBC-Modern generics: 'type Box( of T )' and 'function Max( of T )( ... )'.
    if Peek( p ) = Fbx.TK_LPAREN then
        dim as long save = p.pos
        Advance( p )
        dim as boolean isGeneric = false
        if Peek( p ) = Fbx.TK_IDENT then
            isGeneric = (p.names->Spelling( cast( Fbx.InternId, Cur( p ).literal ) ) = "of")
        end if
        if isGeneric then
            while (Peek( p ) <> Fbx.TK_RPAREN) andalso (AtEnd( p ) = false)
                Advance( p )
            wend
            Expect( p, Fbx.TK_RPAREN, ")" )
        else
            p.pos = save
        end if
    end if

    '' The qualification can follow the generic arguments:
    '' 'sub SetIterator( of T ).MoveNext( )'. Check again after them.
    while Peek( p ) = Fbx.TK_DOT
        Advance( p )
        qualified = true
        DeclName( p, sp.name )
    wend

    '' 'sub F cdecl( ... )' and 'declare sub F stdcall alias "g" ( ... )' put the
    '' calling convention and the ALIAS between the name and the parameter list.
    '' Leaving them unconsumed meant ParseParamList saw no '(' and the trailing-
    '' modifier loop below silently ate the ENTIRE parameter list -- so every
    '' parameter of every cdecl procedure in every header went undeclared.
    do
        dim as boolean ate = false
        while Fbx.IsCallConvKind( Peek( p ) )
            Advance( p )
            ate = true
        wend
        if Accept( p, Fbx.KW_ALIAS ) then
            if Peek( p ) = Fbx.TK_STRING_LIT then Advance( p )
            ate = true
        end if
        if Accept( p, Fbx.KW_LIB ) then
            if Peek( p ) = Fbx.TK_STRING_LIT then Advance( p )
            ate = true
        end if
        if Accept( p, Fbx.KW_OVERLOAD ) then ate = true
        if ate = false then exit do
    loop

    ParseParamList( p, sp )

    if Accept( p, Fbx.KW_AS ) then sp.a = TypeRef( p )

    '' Trailing modifiers: static, const, export, alias "x", lib "y", cdecl ...
    while (Peek( p ) <> Fbx.TK_EOL) andalso (AtEnd( p ) = false)
        Advance( p )
    wend

    if declareOnly then
        dim as Fbx.NodeId dn = MakeStmt( p, Fbx.N_PROC, t.loc, sp )
        if qualified then p.ast->nodes[cast( long, dn )].flags or= Fbx.NF_QUALIFIED
        return dn
    end if

    sp.b = Block( p )
    ExpectEnd( p, kw )
    dim as Fbx.NodeId pn = MakeStmt( p, Fbx.N_PROC, t.loc, sp )
    if qualified then p.ast->nodes[cast( long, pn )].flags or= Fbx.NF_QUALIFIED
    return pn
end function

private function ParseTypeDecl( byref p as Fbx.ParserState ) as Fbx.NodeId
    dim as Fbx.Token t = Cur( p )
    dim as boolean isUnion = (Peek( p ) = Fbx.KW_UNION)
    Advance( p )

    dim as Fbx.StmtPayload sp
    if DeclName( p, sp.name ) = false then
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
        return MakeStmt( p, Fbx.N_TYPEDEF, t.loc, sp )
    end if

    if Peek( p ) = Fbx.TK_LPAREN then          '' generic parameter list
        while (Peek( p ) <> Fbx.TK_RPAREN) andalso (AtEnd( p ) = false)
            Advance( p )
        wend
        Expect( p, Fbx.TK_RPAREN, ")" )
    end if
    if Accept( p, Fbx.KW_EXTENDS ) then sp.c = TypeRef( p )

    dim as Fbx.NodeIdVec members
    do
        SkipEols( p )
        if AtEnd( p ) then exit do
        if Peek( p ) = Fbx.KW_END then exit do

        dim as long before = p.pos
        dim as Fbx.TokenKind k = Peek( p )

        if k = Fbx.KW_AS then
            '' 'as long x, y' -- the type comes first and is shared by the names.
            Advance( p )
            dim as Fbx.NodeId shared_ = TypeRef( p )
            do
                dim as Fbx.Token ft = Cur( p )
                dim as Fbx.StmtPayload fp
                if DeclName( p, fp.name ) = false then exit do
                if Peek( p ) = Fbx.TK_LPAREN then
                    Advance( p )
                    while (Peek( p ) <> Fbx.TK_RPAREN) andalso (AtEnd( p ) = false)
                        Advance( p )
                    wend
                    Expect( p, Fbx.TK_RPAREN, ")" )
                end if
                fp.a = shared_
                members.Push( cast( ulong, MakeStmt( p, Fbx.N_FIELD, ft.loc, fp ) ) )
                if Accept( p, Fbx.TK_COMMA ) = false then exit do
            loop
        elseif IsDeclarationStart( k ) then
            members.Push( cast( ulong, Declaration( p ) ) )
        elseif (k = Fbx.TK_IDENT) orelse Fbx.IsKeywordKind( k ) then
            '' A field: 'name as T' or 'as T name' (the latter via ParseVarDecl).
            dim as Fbx.Token ft = Cur( p )
            dim as Fbx.StmtPayload fp
            if DeclName( p, fp.name ) then
                if Peek( p ) = Fbx.TK_LPAREN then
                    Advance( p )
                    while (Peek( p ) <> Fbx.TK_RPAREN) andalso (AtEnd( p ) = false)
                        Advance( p )
                    wend
                    Expect( p, Fbx.TK_RPAREN, ")" )
                end if
                if Accept( p, Fbx.KW_AS ) then fp.a = TypeRef( p )
                if Accept( p, Fbx.TK_COLON ) then fp.b = Expression( p )
                members.Push( cast( ulong, MakeStmt( p, Fbx.N_FIELD, ft.loc, fp ) ) )
            end if
        end if

        if p.pos = before then Advance( p )
        EndOfStatement( p )
    loop

    sp.first = p.ast->children.Count
    sp.count = members.Count
    for i as long = 0 to members.Count - 1
        p.ast->children.Push( members[i] )
    next

    ExpectEnd( p, iif( isUnion, Fbx.KW_UNION, Fbx.KW_TYPE ) )
    dim as Fbx.NodeId n = MakeStmt( p, Fbx.N_TYPE, t.loc, sp )
    if isUnion then p.ast->nodes[cast( long, n )].flags or= Fbx.NF_IS_UNION
    return n
end function

private function ParseEnumDecl( byref p as Fbx.ParserState ) as Fbx.NodeId
    dim as Fbx.Token t = Cur( p )
    Advance( p )
    dim as Fbx.StmtPayload sp
    DeclName( p, sp.name )

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
    return MakeStmt( p, Fbx.N_ENUM, t.loc, sp )
end function

private function ParseNamespaceDecl( byref p as Fbx.ParserState ) as Fbx.NodeId
    dim as Fbx.Token t = Cur( p )
    Advance( p )
    dim as Fbx.StmtPayload sp
    DeclName( p, sp.name )
    while Peek( p ) = Fbx.TK_DOT
        Advance( p )
        DeclName( p, sp.name )
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
    return MakeStmt( p, Fbx.N_NAMESPACE, t.loc, sp )
end function

function Declaration( byref p as Fbx.ParserState ) as Fbx.NodeId
    dim as Fbx.Token t = Cur( p )
    dim as Fbx.TokenKind k = Peek( p )

    '' 'private'/'public' only qualify what follows.
    if (k = Fbx.KW_PRIVATE) orelse (k = Fbx.KW_PUBLIC) then
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
            sp.a = Expression( p, Fbx.PREC_POSTFIX )
            EndOfStatement( p )

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
                p.ast->children.Push( members[i] )
            next
            ExpectEnd( p, Fbx.KW_EXTERN )
            return MakeStmt( p, Fbx.N_EXTERN_BLOCK, t.loc, sp )
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
        return ParseProc( p, true )

    case Fbx.KW_SUB, Fbx.KW_FUNCTION, Fbx.KW_PROPERTY, Fbx.KW_CONSTRUCTOR, _
         Fbx.KW_DESTRUCTOR, Fbx.KW_OPERATOR
        return ParseProc( p, false )

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

end namespace
