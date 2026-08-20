'' decl.bas -- declarations.  Included by parser.bas.

namespace Fbx.Parse

'' One array bound. '...' is legal HERE and nowhere else, so it is read here rather
'' than in Primary -- loosening the expression grammar to carry it would let '...'
'' through in places FreeBASIC does not have it.
''
'' Measured: 'dim a(0 to ...)' and 'dim a(...)' both work, any dimension may use it and
'' several may, but 'redim a(0 to ...)' is fbc error 76, a TYPE FIELD is error 77, and
'' one with no initializer is error 281. The size comes from the initializer, so there
'' has to be one.
private function BoundExpr( byref p as Fbx.ParserState ) as Fbx.NodeId
    if Peek( p ) = Fbx.TK_ELLIPSIS then
        dim as Fbx.Token et = Cur( p )
        Advance( p )
        return NewNodeAt( p, Fbx.N_ELLIPSIS, et.loc, 0 )
    end if
    return Expression( p )
end function

function IsDeclarationStart( byval k as Fbx.TokenKind ) as boolean
    select case k
    case Fbx.KW_DIM, Fbx.KW_REDIM, Fbx.KW_VAR, Fbx.KW_CONST, Fbx.KW_STATIC, _
         Fbx.KW_SHARED, Fbx.KW_COMMON, Fbx.KW_EXTERN, Fbx.KW_TYPE, Fbx.KW_UNION, _
         Fbx.KW_ENUM, Fbx.KW_DECLARE, Fbx.KW_SUB, Fbx.KW_FUNCTION, Fbx.KW_PROPERTY, _
         Fbx.KW_CONSTRUCTOR, Fbx.KW_DESTRUCTOR, Fbx.KW_OPERATOR, Fbx.KW_NAMESPACE, _
         Fbx.KW_USING, Fbx.KW_OPTION, Fbx.KW_PRIVATE, Fbx.KW_PUBLIC, _
         Fbx.KW_VIRTUAL, Fbx.KW_ABSTRACT
        '' VIRTUAL and ABSTRACT were missing, so a member DEFINITION carrying one --
        '' 'virtual sub Base.vs( )' at module level -- never reached the declaration
        '' parser at all, even though the modifier loop inside it already handled both.
        ''
        '' ABSTRACT is included deliberately although fbc rejects a body for one: it does
        '' so SEMANTICALLY (error 224, "Implemented body for an ABSTRACT method"), having
        '' parsed the definition first. Refusing it here would report a syntax error for
        '' something that is not one. The real diagnostic is owed from the checker.
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

'' Array bounds into 'c'. 'dim x()' is a dynamic array with no bounds given. Shared by
'' the named form and by a REDIM's parenthesised target, which reads its bounds the
'' same way after a different head.
private sub ParseArrayBoundsInto _
    ( byref p as Fbx.ParserState, byref sp as Fbx.StmtPayload, byref t as Fbx.Token )

    if Peek( p ) <> Fbx.TK_LPAREN then return
    Advance( p )
    dim as Fbx.NodeIdVec dims
    if Peek( p ) <> Fbx.TK_RPAREN then
        do
            dim as Fbx.NodeId lo = BoundExpr( p )
            if Accept( p, Fbx.KW_TO ) then
                dim as Fbx.Token rt = Cur( p )
                dim as Fbx.StmtPayload rp
                rp.a = lo
                rp.b = BoundExpr( p )
                dims.Push( cast( ulong, MakeStmt( p, Fbx.N_CASE_RANGE, rt.loc, rp ) ) )
            else
                dims.Push( cast( ulong, lo ) )
            end if
            if Accept( p, Fbx.TK_COMMA ) = false then exit do
        loop
    end if
    Expect( p, Fbx.TK_RPAREN, ")" )
    sp.c = MakeList( p, Fbx.N_BLOCK, t.loc, Fbx.NODE_NONE, dims )
end sub

'' 'dim x(0 to 9, 3) as long = 5' -- one item of a declaration list.
''
'' A REDIM target may be PARENTHESISED: 'redim (a)(0 to 1)' is legal on a var-len
'' array, and 'redim (1+1)(0 to 1)' PARSES and is then fbc error 54. Both have to get
'' through the parser or the corpus's COMPILE_ONLY_FAIL files fail for the wrong
'' reason. A dotted target -- 'redim ns.arr(0 to 2)' -- already worked.
private function VarItem _
    ( byref p as Fbx.ParserState, byval isRedim as boolean = false ) as Fbx.NodeId

    dim as Fbx.Token t = Cur( p )
    dim as Fbx.StmtPayload sp

    if isRedim andalso (Peek( p ) = Fbx.TK_LPAREN) then
        '' The parenthesised group is read EXPLICITLY rather than through the postfix
        '' chain, which would take '(a)(0 to 1)' as a CALL of '(a)' and swallow the
        '' bounds -- the target parsed, the dimensions vanished, and the only sign was
        '' one leftover diagnostic.
        ''
        '' The target goes in 'b', the initializer slot, which a REDIM never uses --
        '' and Resolve returns immediately for a REDIM item, so nothing reads it yet.
        '' 'extra' records that it is a target rather than a value, so a later reader
        '' cannot mistake one for the other.
        Advance( p )                          '' '('
        sp.b = Expression( p )
        Expect( p, Fbx.TK_RPAREN, ")" )
        sp.extra = cast( ushort, Fbx.KW_REDIM )
        ParseArrayBoundsInto( p, sp, t )
        dim as Fbx.NodeId rn = MakeStmt( p, Fbx.N_VAR_ITEM, t.loc, sp )
        if sp.c <> Fbx.NODE_NONE then p.ast->nodes[cast( long, rn )].flags or= Fbx.NF_ARRAY
        return rn
    end if

    if DeclName( p, sp.name ) = false then return ErrorNode( p, Fbx.FBX0406 )

    '' 'dim UDT.i as integer' -- a qualified name defines a static member.
    dim as boolean qualified = false
    while Peek( p ) = Fbx.TK_DOT
        Advance( p )
        qualified = true
        DeclName( p, sp.name )
    wend

    ParseArrayBoundsInto( p, sp, t )

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
        case Fbx.KW_BYREF
            '' 'dim byref rb as string = a' -- a REFERENCE variable. Without this the
            '' name was read as 'byref' and the rest of the statement discarded: no
            '' type, no initializer, no 'rb', and NO DIAGNOSTIC. It only surfaced on the
            '' second occurrence, as a redeclaration of 'byref'.
            ''
            '' Measured: fbc accepts it with and without SHARED, and refuses one with no
            '' initializer (error 320, 'Reference not initialized') -- a semantic rule
            '' fbx does not implement yet.
            flags or= Fbx.NF_BYREF
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
        dim as Fbx.NodeId item = VarItem( p, sp.op = cast( ushort, Fbx.KW_REDIM ) )
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

    '' 'const as ulongint u = 1' -- the TYPE-FIRST form, which DIM has always had and
    '' CONST did not. Without it 'as' was read as the constant's NAME and everything
    '' after it discarded: no type, no value, no 'u', and NO DIAGNOSTIC. It surfaced
    '' only on the second such declaration, as a redeclaration of 'as' -- twenty corpus
    '' files, the largest single line-shape in the largest remaining bucket.
    ''
    '' Measured: fbc accepts 'const as ubyte a = 1, b = 2' too, so the type is shared
    '' across a comma list exactly as it is for DIM.
    dim as Fbx.NodeId sharedType = Fbx.NODE_NONE
    if Accept( p, Fbx.KW_AS ) then sharedType = TypeRef( p )

    do
        dim as Fbx.NodeId item = VarItem( p, false )
        items.Push( cast( ulong, item ) )
        '' An ERROR node has no StmtPayload; indexing its 'data' as one is a segfault.
        if p.ast->Kind( item ) <> Fbx.N_VAR_ITEM then exit do
        if sharedType <> Fbx.NODE_NONE then
            dim as long si = cast( long, p.ast->nodes[cast( long, item )].data )
            if p.ast->stmts[si].a = Fbx.NODE_NONE then p.ast->stmts[si].a = sharedType
        end if
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

    '' An UNNAMED parameter -- 'sub( byref as long )' -- which is how a procedure
    '' POINTER type is normally written, the names being meaningless there. The name is
    '' simply absent and 'as' follows straight away.
    ''
    '' Measured: fbc accepts this in a DECLARE and in a procedure type, but REJECTS it
    '' in a definition ("error 59: Illegal specification, at parameter 1"). That is a
    '' semantic rule rather than a syntactic one -- the shape parses either way -- so it
    '' is accepted here and the diagnostic is owed from the checker, which does not
    '' emit it yet.
    '' ... or an unnamed ARRAY-DESCRIPTOR parameter: 'declare sub f( ( ) as integer )'
    '' and 'dim p as sub cdecl( byval as integer, ( ) as integer )'. The bounds follow
    '' where the name would be, so '(' means the name is absent just as 'as' does. The
    '' NAMED forms -- 'a( )', 'a( any )', 'a( any, any )' -- already worked, which is
    '' why only two of the eight files in this bucket failed on the descriptor itself.
    dim as Fbx.TokenKind pk = Peek( p )
    if (pk <> Fbx.KW_AS) andalso (pk <> Fbx.TK_LPAREN) then
        if DeclName( p, sp.name ) = false then return ErrorNode( p, Fbx.FBX0406 )
    end if

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

'' The bounds of an array declarator: '(0 to 3)', '(3)', '(0 to 1, 0 to 2)'. Stored
'' as LOW/HIGH PAIRS in the child list, with an omitted low bound written as 0 --
'' 'a(3)' means 0 to 3 in FreeBASIC, four elements, not three.
''
'' They used to be skipped token by token, which cost the element count and made
'' every array field lay out as a single element.
private sub ParseArrayBounds _
    ( byref p as Fbx.ParserState, byref sp as Fbx.StmtPayload )

    dim as Fbx.NodeIdVec bounds
    if Accept( p, Fbx.TK_LPAREN ) = false then return
    if Peek( p ) <> Fbx.TK_RPAREN then
        do
            dim as long before = p.pos
            dim as Fbx.NodeId first_ = BoundExpr( p )
            if Accept( p, Fbx.KW_TO ) then
                bounds.Push( cast( ulong, first_ ) )
                bounds.Push( cast( ulong, BoundExpr( p ) ) )
            else
                bounds.Push( cast( ulong, Fbx.NODE_NONE ) )
                bounds.Push( cast( ulong, first_ ) )
            end if
            if p.pos = before then exit do
            if Accept( p, Fbx.TK_COMMA ) = false then exit do
        loop
    end if
    Expect( p, Fbx.TK_RPAREN, ")" )
    sp.first = p.ast->children.Count
    sp.count = bounds.Count
    for i as long = 0 to bounds.Count - 1
        p.ast->children.Push( bounds[i] )
    next
end sub

'' Intern the text of the string literal at the cursor, WITHOUT advancing. The
'' literal pool records the span with the quotes already stripped, and the case is
'' preserved: an ALIAS keeps exactly the spelling that was written.
private function StringLitText( byref p as Fbx.ParserState ) as Fbx.InternId
    dim as Fbx.Token t = Cur( p )
    if p.litPool = 0 then return 0
    if cast( long, t.literal ) >= p.litPool->Count then return 0
    dim as Fbx.Literal ptr lit = @(*p.litPool)[cast( long, t.literal )]
    if lit->textLength <= 0 then return 0
    '' The literal's OWN file. Taking it from t.loc breaks for any token produced by
    '' macro expansion, whose loc points at the use site rather than at the text.
    dim as Fbx.SourceFile ptr f = p.src->FileAt( cast( Fbx.FileId, lit->textFile ) )
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
        '' The convention is RECORDED, not merely eaten. It decides the emitted name on
        '' win32 -- '_H@4' for stdcall against '_G' for cdecl -- and it is checked
        '' against the DECLARE prototype, which fbc refuses to contradict.
        while Fbx.IsCallConvKind( Peek( p ) )
            select case Peek( p )
            case Fbx.KW_CDECL   : sp.extra or= Fbx.PF_CDECL
            case Fbx.KW_STDCALL : sp.extra or= Fbx.PF_STDCALL
            case Fbx.KW_PASCAL  : sp.extra or= Fbx.PF_PASCAL
            end select
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

'' An access section reaches into a nested anonymous TYPE or UNION -- measured: a
'' field of a union written under 'private:' is an illegal member access from outside.
'' The nested body parses with its own section state, so the label is applied here
'' instead, and only to members that carry none of their own.
private sub ApplyVisibility _
    ( byref p as Fbx.ParserState, byval n as Fbx.NodeId, byval vis as ushort )

    if (vis = 0) orelse (n = Fbx.NODE_NONE) then return
    if p.ast->nodes[cast( long, n )].kind <> Fbx.N_TYPE then return

    dim as Fbx.StmtPayload ptr tp = _
        @p.ast->stmts[cast( long, p.ast->nodes[cast( long, n )].data )]

    for i as long = 0 to tp->count - 1
        dim as Fbx.NodeId m = cast( Fbx.NodeId, p.ast->children[tp->first + i] )
        if m = Fbx.NODE_NONE then continue for
        dim as Fbx.NodeKind mk = p.ast->nodes[cast( long, m )].kind
        if mk = Fbx.N_TYPE then
            ApplyVisibility( p, m, vis )
        elseif (mk = Fbx.N_FIELD) orelse (mk = Fbx.N_PROC) then
            dim as Fbx.StmtPayload ptr mp = _
                @p.ast->stmts[cast( long, p.ast->nodes[cast( long, m )].data )]
            dim as ushort had = mp->extra and _
                                (Fbx.PF_MEMB_PRIVATE or Fbx.PF_MEMB_PROTECTED)
            if had = 0 then mp->extra or= vis
        end if
    next
end sub

'' A FIELD whose NAME is a keyword that also starts a declaration. MEASURED against fbc,
'' because the accepted set is not guessable -- TYPE and UNION are in it and ENUM and
'' DECLARE are not:
''
''   Function Sub Property Type Union     accepted as a field name
''   Enum Declare Const Static Dim        fbc rejects
''
'' What follows decides it: a field is 'name as T', 'name( bounds ) as T' or
'' 'as T name' -- the last handled elsewhere. A DECLARATION never has 'as' or '(' in
'' that position.
private function IsFieldNamedByKeyword _
    ( byref p as Fbx.ParserState, byval k as Fbx.TokenKind ) as boolean

    select case k
    case Fbx.KW_FUNCTION, Fbx.KW_SUB, Fbx.KW_PROPERTY, Fbx.KW_TYPE, Fbx.KW_UNION
    case else
        return false
    end select
    if HasTok( p, p.pos + 1 ) = false then return false
    dim as Fbx.TokenKind nx = cast( Fbx.TokenKind, p.toks->At( p.pos + 1 ).kind )
    return (nx = Fbx.KW_AS) orelse (nx = Fbx.TK_LPAREN)
end function

'' The member list of a TYPE or UNION, its 'end', and the node. Shared by the named
'' and the ANONYMOUS forms, which differ only in whether a name was read.
private function ParseAggregateBody _
    ( byref p as Fbx.ParserState, byref t as Fbx.Token, _
      byref sp as Fbx.StmtPayload, byval isUnion as boolean ) as Fbx.NodeId

    p.aggDepth += 1
    dim as Fbx.NodeIdVec members

    '' The access section in force. Measured against fbc rather than assumed:
    ''
    ''   default             PUBLIC
    ''   private:            own members yes, DERIVED no, outside no
    ''   protected:          own members yes, derived YES, outside no
    ''   in a UNION          a syntax error, not a label -- which symmetry would
    ''                       have got wrong, so the label is only read for a TYPE
    ''
    '' A label reaches into a nested anonymous union too, which falls out of keeping
    '' one variable across the whole member loop.
    dim as ushort vis = 0

    do
        SkipEols( p )
        if AtEnd( p ) then exit do
        if Peek( p ) = Fbx.KW_END then exit do

        dim as long before = p.pos
        dim as Fbx.TokenKind k = Peek( p )

        '' 'private:' and friends. The colon is what tells a LABEL from the PRIVATE
        '' that modifies a procedure, so both tokens are required before either is
        '' consumed -- and 4 corpus files reach the keyword through a macro parameter,
        '' which is why this tests the token and not the source text.
        dim as boolean isVisKw = (k = Fbx.KW_PRIVATE) orelse _
                                 (k = Fbx.KW_PUBLIC) orelse (k = Fbx.KW_PROTECTED)
        if (isUnion = false) andalso isVisKw then
            '' There is no TK_COLON to look for: the lexer turns a ':' statement
            '' separator into a TK_EOL and marks it TF_COLON, because ':' separates
            '' statements exactly as a newline does. So the label is a visibility
            '' keyword followed by an EOL THAT CAME FROM A COLON, and a bare
            '' 'private' on its own line is not one -- fbc says so too, error 203.
            dim as boolean labelled = false
            if HasTok( p, p.pos + 1 ) then
                dim as Fbx.Token nx = p.toks->At( p.pos + 1 )
                labelled = (cast( Fbx.TokenKind, nx.kind ) = Fbx.TK_EOL) andalso _
                           ((nx.flags and Fbx.TF_COLON) <> 0)
            end if
            if labelled then
                select case as const k
                case Fbx.KW_PRIVATE   : vis = Fbx.PF_MEMB_PRIVATE
                case Fbx.KW_PROTECTED : vis = Fbx.PF_MEMB_PROTECTED
                case else             : vis = 0
                end select
                Advance( p )
                Advance( p )
                continue do
            end if
        end if

        if k = Fbx.KW_AS then
            '' 'as long x, y' -- the type comes first and is shared by the names.
            Advance( p )
            dim as Fbx.NodeId shared_ = TypeRef( p )
            do
                dim as Fbx.Token ft = Cur( p )
                dim as Fbx.StmtPayload fp
                if DeclName( p, fp.name ) = false then exit do
                ParseArrayBounds( p, fp )
                if fp.count > 0 then fp.op = cast( ushort, Fbx.KW_DIM )
                fp.a = shared_
                fp.extra or= vis
                members.Push( cast( ulong, MakeStmt( p, Fbx.N_FIELD, ft.loc, fp ) ) )
                if Accept( p, Fbx.TK_COMMA ) = false then exit do
            loop
        elseif IsFieldNamedByKeyword( p, k ) then
            '' A FIELD whose name is a keyword that also starts a declaration:
            '' winnt.bi writes 'Function as ULONGLONG' inside two unions, and fbx read
            '' it as a nested FUNCTION declaration, which ran off looking for an
            '' 'end function' and ate the 'end union'.
            ''
            '' Measured, and the accepted set is not guessable -- TYPE and UNION are in
            '' it, ENUM and DECLARE are not:
            ''
            ''   Function Sub Property Type Union   accepted as a field name
            ''   Enum Declare Const Static Dim      fbc rejects
            ''
            '' The '(' and 'as' forms are both accepted by fbc, so both are read here.
            dim as Fbx.Token ft = Cur( p )
            dim as Fbx.StmtPayload fp
            fp.name = p.names->GetString( _
                Fbx.Text.LowerAscii( Fbx.TokenKindText( k ) ) )
            Advance( p )
            ParseArrayBoundsInto( p, fp, ft )
            if fp.c <> Fbx.NODE_NONE then fp.op = cast( ushort, Fbx.KW_DIM )
            if Accept( p, Fbx.KW_AS ) then fp.a = TypeRef( p )
            fp.extra or= vis
            members.Push( cast( ulong, MakeStmt( p, Fbx.N_FIELD, ft.loc, fp ) ) )
        elseif IsDeclarationStart( k ) then
            dim as Fbx.NodeId mn = Declaration( p )
            '' Only an N_PROC carries a StmtPayload whose 'extra' is the modifier set;
            '' reaching into stmts[] for any other kind would land on another node's
            '' payload and corrupt it silently.
            dim as boolean tagIt = (vis <> 0) andalso (mn <> Fbx.NODE_NONE)
            if tagIt then
                select case p.ast->nodes[cast( long, mn )].kind
                case Fbx.N_PROC
                    dim as Fbx.StmtPayload ptr mp = _
                        @p.ast->stmts[cast( long, p.ast->nodes[cast( long, mn )].data )]
                    mp->extra or= vis
                case Fbx.N_TYPE
                    ApplyVisibility( p, mn, vis )
                end select
            end if
            members.Push( cast( ulong, mn ) )
        elseif (k = Fbx.TK_IDENT) orelse Fbx.IsKeywordKind( k ) then
            '' A field: 'name as T' or 'as T name' (the latter via ParseVarDecl).
            dim as Fbx.Token ft = Cur( p )
            dim as Fbx.StmtPayload fp
            if DeclName( p, fp.name ) then
                ParseArrayBounds( p, fp )
                if fp.count > 0 then
                    fp.op = cast( ushort, Fbx.KW_DIM )   '' marks 'has bounds'
                end if
                if Accept( p, Fbx.KW_AS ) then fp.a = TypeRef( p )
                if Accept( p, Fbx.TK_COLON ) then fp.b = Expression( p )
                fp.extra or= vis
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

    ExpectEnd( p, iif( isUnion, Fbx.KW_UNION, Fbx.KW_TYPE ), t.loc )
    dim as Fbx.NodeId n = MakeStmt( p, Fbx.N_TYPE, t.loc, sp )
    if isUnion then p.ast->nodes[cast( long, n )].flags or= Fbx.NF_IS_UNION
    return n
    p.aggDepth -= 1
    return n
end function

'' 'type T field = 1' caps how far each member is aligned. It does NOT reduce the type's
'' own alignment when embedded -- measured -- so it is kept separately rather than
'' folded into the alignment.
''
'' Shared by the named and the ANONYMOUS forms: 'union field = 4' with no name at all is
'' what winnt.bi writes, and reading the clause in only one of the two places left
'' 'field' behind as a MEMBER of the anonymous union.
private sub ParseFieldClause( byref p as Fbx.ParserState, byref sp as Fbx.StmtPayload )
    if Peek( p ) <> Fbx.KW_FIELD then return
    Advance( p )
    if Accept( p, Fbx.TK_EQ ) = false then return
    dim as Fbx.NodeId nExpr = Expression( p )
    sp.extra = 0
    if nExpr = Fbx.NODE_NONE then return
    if p.ast->Kind( nExpr ) <> Fbx.N_INT_LIT then return
    sp.extra = cast( ushort, _
        p.ast->literals[cast( long, p.ast->nodes[cast( long, nExpr )].data )].intValue )
end sub

private function ParseTypeDecl( byref p as Fbx.ParserState ) as Fbx.NodeId
    dim as Fbx.Token t = Cur( p )
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
        return MakeStmt( p, Fbx.N_TYPEDEF, t.loc, sp )
    end if

    if Peek( p ) = Fbx.TK_LPAREN then          '' generic parameter list
        while (Peek( p ) <> Fbx.TK_RPAREN) andalso (AtEnd( p ) = false)
            Advance( p )
        wend
        Expect( p, Fbx.TK_RPAREN, ")" )
    end if
    ParseFieldClause( p, sp )

    if Accept( p, Fbx.KW_EXTENDS ) then sp.c = TypeRef( p )

    return ParseAggregateBody( p, t, sp, isUnion )
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

end namespace
