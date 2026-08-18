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
'' The RAW spelling of the identifier at the cursor, case as written, or 0.
private function RawSpelling( byref p as Fbx.ParserState ) as Fbx.InternId
    dim as Fbx.Token t = Cur( p )
    if Peek( p ) <> Fbx.TK_IDENT then return 0
    if t.length <= 0 then return 0
    dim as Fbx.DecodedLoc d = p.src->Decode( t.loc )
    dim as Fbx.SourceFile ptr f = p.src->FileAt( d.file )
    if f = 0 then return 0
    if (d.offset + cast( long, t.length )) > f->text.Count then return 0
    return p.names->Get( @f->text[d.offset], cast( long, t.length ) )
end function

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

'' Intern the text of the string literal at the cursor, WITHOUT advancing. The
'' literal pool records the span with the quotes already stripped, and the case is
'' preserved: an ALIAS keeps exactly the spelling that was written.
private function StringLitText( byref p as Fbx.ParserState ) as Fbx.InternId
    dim as Fbx.Token t = Cur( p )
    if p.litPool = 0 then return 0
    if cast( long, t.literal ) >= p.litPool->Count then return 0
    dim as Fbx.Literal ptr lit = @(*p.litPool)[cast( long, t.literal )]
    if lit->textLength <= 0 then return 0
    dim as Fbx.DecodedLoc d = p.src->Decode( t.loc )
    dim as Fbx.SourceFile ptr f = p.src->FileAt( d.file )
    if f = 0 then return 0
    if (lit->textOffset + lit->textLength) > f->text.Count then return 0
    return p.names->Get( @f->text[lit->textOffset], lit->textLength )
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

    '' 'const function T.F( )' and 'static sub T.S( )' put the modifier BEFORE the
    '' procedure keyword. Const-ness is not cosmetic: it is what makes the mangled
    '' name _ZNK... rather than _ZN..., so a procedure that loses it links wrong.
    do
        select case Peek( p )
        case Fbx.KW_CONST    : sp.extra or= Fbx.PF_CONST
        case Fbx.KW_STATIC   : sp.extra or= Fbx.PF_STATIC
        case Fbx.KW_ABSTRACT : sp.extra or= Fbx.PF_ABSTRACT
        case Fbx.KW_VIRTUAL  : sp.extra or= Fbx.PF_VIRTUAL
        case else            : exit do
        end select
        Advance( p )
    loop

    dim as Fbx.TokenKind kw = Peek( p )
    sp.op = cast( ushort, kw )
    Advance( p )

    '' The name may be qualified ('Stack.Push') or absent (constructors).
    dim as boolean qualified = false
    if (Peek( p ) = Fbx.TK_IDENT) orelse Fbx.IsKeywordKind( Peek( p ) ) then
        sp.rawName = RawSpelling( p )
        DeclName( p, sp.name )
        while Peek( p ) = Fbx.TK_DOT
            Advance( p )
            qualified = true
            sp.ownerName = sp.name
            sp.rawName = RawSpelling( p )
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
    '' OVERLOAD must precede ALIAS -- fbc rejects the other order.
    do
        dim as boolean ate = false
        while Fbx.IsCallConvKind( Peek( p ) )
            Advance( p )
            ate = true
        wend
        if Accept( p, Fbx.KW_OVERLOAD ) then
            '' OVERLOAD alone forces mangling, even when nothing else shares the
            '' name: fbc mangles on the KEYWORD, not on there being a second one.
            sp.extra or= Fbx.PF_OVERLOAD
            ate = true
        end if
        if Accept( p, Fbx.KW_ALIAS ) then
            '' The alias replaces the IDENTIFIER and keeps its case, but the name is
            '' still mangled around it: 'sub F overload alias "lower_case"' is
            '' _Z10lower_casei, not 'lower_case'.
            if Peek( p ) = Fbx.TK_STRING_LIT then
                sp.aliasName = StringLitText( p )
                Advance( p )
            end if
            ate = true
        end if
        if Accept( p, Fbx.KW_LIB ) then
            if Peek( p ) = Fbx.TK_STRING_LIT then Advance( p )
            ate = true
        end if
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

'' The member list of a TYPE or UNION, its 'end', and the node. Shared by the named
'' and the ANONYMOUS forms, which differ only in whether a name was read.
private function ParseAggregateBody _
    ( byref p as Fbx.ParserState, byref t as Fbx.Token, _
      byref sp as Fbx.StmtPayload, byval isUnion as boolean ) as Fbx.NodeId

    p.aggDepth += 1
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
    p.aggDepth -= 1
    return n
end function

private function ParseTypeDecl( byref p as Fbx.ParserState ) as Fbx.NodeId
    dim as Fbx.Token t = Cur( p )
    dim as boolean isUnion = (Peek( p ) = Fbx.KW_UNION)
    Advance( p )

    dim as Fbx.StmtPayload sp
    if DeclName( p, sp.name ) = false then
        '' An ANONYMOUS union or type, which is legal inside another aggregate and
        '' nowhere else. Its members belong to the enclosing type, so it carries no
        '' name and Collect splices it rather than opening a scope.
        if (p.aggDepth > 0) andalso _
           ((Peek( p ) = Fbx.TK_EOL) orelse (Peek( p ) = Fbx.KW_FIELD)) then
            sp.name = 0
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
        return MakeStmt( p, Fbx.N_TYPEDEF, t.loc, sp )
    end if

    if Peek( p ) = Fbx.TK_LPAREN then          '' generic parameter list
        while (Peek( p ) <> Fbx.TK_RPAREN) andalso (AtEnd( p ) = false)
            Advance( p )
        wend
        Expect( p, Fbx.TK_RPAREN, ")" )
    end if
    if Accept( p, Fbx.KW_EXTENDS ) then sp.c = TypeRef( p )

    return ParseAggregateBody( p, t, sp, isUnion )
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
    '' 'namespace a.b.c' opens THREE nested namespaces, not one called 'c'. fbcunit's
    '' SUITE macro expands to exactly this, and keeping only the last component made
    '' every generated procedure mangle three qualifiers short of fbc's.
    dim as FB.Array( of ulong ) parts
    dim as Fbx.StmtPayload sp
    DeclName( p, sp.name )
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
                end if
                p.ast->children.Push( members[i] )
            next
            ExpectEnd( p, Fbx.KW_EXTERN )
            return MakeStmt( p, Fbx.N_EXTERN_BLOCK, t.loc, sp )
        end if
    end if

    '' A leading CONST or STATIC followed by a procedure keyword modifies the
    '' PROCEDURE; it does not start a constant or a variable declaration.
    if (k = Fbx.KW_CONST) orelse (k = Fbx.KW_STATIC) then
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

end namespace
