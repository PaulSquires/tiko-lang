'' decl.bas -- declarations.  Included by parser.bas.

namespace Fbx.Parse

'' Defined below: the TEXT of a string literal token, interned. Declared here because
'' VarItem needs it for a variable's ALIAS and is compiled before it.
declare function StringLitText( byref p as Fbx.ParserState ) as Fbx.InternId

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

'' 'a.b' as an EXPRESSION node, built without going through the postfix parser -- which
'' cannot be used here because it would take the '( 0 to 9 )' that follows as a CALL and
'' swallow the bounds. The same node shape Postfix builds: an N_BINARY over '.', with
'' its kind changed to N_MEMBER.
private function MakeMemberRef_ _
    ( byref p as Fbx.ParserState, byref dotTok as Fbx.Token, _
      byval lhs as Fbx.NodeId, byval rhs as Fbx.NodeId ) as Fbx.NodeId

    dim as Fbx.BinaryPayload bp
    bp.op = cast( ushort, Fbx.TK_DOT )
    bp.lhs = lhs
    bp.rhs = rhs
    p.ast->binaries.Push( bp )
    dim as Fbx.NodeId n = _
        NewNodeAt( p, Fbx.N_BINARY, dotTok.loc, p.ast->binaries.Count - 1 )
    p.ast->nodes[cast( long, n )].kind = cast( ushort, Fbx.N_MEMBER )
    return n
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

    dim as Fbx.Token headTok = Cur( p )
    if DeclName( p, sp.name ) = false then return ErrorNode( p, Fbx.FBX0406 )

    '' 'dim UDT.i as integer' -- a qualified name defines a static member.
    ''
    '' A REDIM IS DIFFERENT: 'redim x.array( 0 to 9 )' names an array THROUGH an
    '' object, and only the LAST name was kept. Lowering then looked up 'array' in the
    '' enclosing scope -- so it declined when nothing of that name was there, and would
    '' have re-dimensioned THE WRONG ARRAY if something was. The chain is built as an
    '' expression here and put in the target slot the parenthesised form already uses,
    '' so both spellings reach lowering the same way. 202 corpus lines write it.
    dim as boolean qualified = false
    dim as Fbx.NodeId qexpr = Fbx.NODE_NONE
    if isRedim then qexpr = MakeIdent( p, headTok )
    while Peek( p ) = Fbx.TK_DOT
        dim as Fbx.Token dotTok = Cur( p )
        Advance( p )
        qualified = true
        dim as Fbx.Token memberTok = Cur( p )
        DeclName( p, sp.name )
        if qexpr <> Fbx.NODE_NONE then
            qexpr = MakeMemberRef_( p, dotTok, qexpr, MakeIdent( p, memberTok ) )
        end if
    wend
    if isRedim andalso qualified andalso (qexpr <> Fbx.NODE_NONE) then
        sp.b = qexpr
        sp.extra = cast( ushort, Fbx.KW_REDIM )
    end if

    ParseArrayBoundsInto( p, sp, t )

    '' 'extern import _ctype alias "_ctype" as ushort ptr ptr' -- an ALIAS on a
    '' VARIABLE, which is how the CRT headers declare every imported one. Without it
    '' 'alias' was read where 'as' was expected, the declaration came out untyped, and
    '' ctype.bi and stdlib.bi failed on eight lines between them -- taking with them
    '' every corpus file that reaches the C runtime through either.
    ''
    '' Recorded in 'aliasName', which is where a PROCEDURE's alias already goes.
    if Accept( p, Fbx.KW_ALIAS ) then
        '' StringLitText does NOT advance -- it reads the token under the cursor -- so
        '' the literal has to be stepped over here, or the 'as' that follows is never
        '' seen and the declaration comes out untyped anyway.
        sp.aliasName = StringLitText( p )
        if Peek( p ) = Fbx.TK_STRING_LIT then Advance( p )
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
        case Fbx.KW_IMPORT, Fbx.KW_EXPORT
            '' 'extern import _ctype alias "_ctype" as ushort ptr ptr' -- a DLL-imported
            '' variable, which is how the CRT headers declare every one of theirs.
            '' Without this the modifier was read as the variable's NAME and the real
            '' name as its type, so ctype.bi and stdlib.bi each failed twice and every
            '' corpus file that reaches the C runtime through them failed with it.
            ''
            '' It affects the linkage, not the declaration, and fbx emits no import
            '' table -- so it is consumed and NOT recorded, which is honest about
            '' producing the same declaration either way.
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
        '' MARKED, because an ellipsis parameter is otherwise indistinguishable from an
        '' unnamed one by anything but the ABSENCE of a typeref -- and lowering has to
        '' know: a variadic procedure has no parameter list to run past, so nothing
        '' after the written arguments is defaulted. Without the mark, 'printf( @s )'
        '' looked like a one-argument call to a two-parameter procedure and declined.
        ''
        '' 'op' is the keyword that spelled a node, which is free on an N_PARAM.
        sp.op = cast( ushort, Fbx.TK_ELLIPSIS )
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
function StringLitText( byref p as Fbx.ParserState ) as Fbx.InternId
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
'' Is the cursor on a ':' ? There is no TK_COLON in the token stream: the lexer turns
'' every ':' into a TK_EOL marked TF_COLON, because it separates statements exactly as
'' a newline does. Anything looking for a literal colon has to ask this instead, and
'' the field reader's bitfield width did not -- so it never fired.
private function IsColonHere( byref p as Fbx.ParserState ) as boolean
    if Peek( p ) <> Fbx.TK_EOL then return false
    return ((Cur( p ).flags and Fbx.TF_COLON) <> 0)
end function

'' The '( of T, U )' parameter list. Defined below; both the TYPE and the PROCEDURE
'' forms need it, and the procedure one is parsed first.
declare function ParseTypeParams( byref p as Fbx.ParserState ) as Fbx.NodeId

'' A 'BYREF' that introduces a RESULT TYPE, consumed if so. It is only that when an AS
'' follows: 'function F( ) byref as T'. A bare BYREF anywhere else is somebody's trailing
'' modifier and is left alone.
private function ByrefResult_( byref p as Fbx.ParserState ) as boolean
    if Peek( p ) <> Fbx.KW_BYREF then return false
    if HasTok( p, p.pos + 1 ) = false then return false
    if cast( Fbx.TokenKind, p.toks->At( p.pos + 1 ).kind ) <> Fbx.KW_AS then return false
    Advance( p )
    return true
end function

'' AN OPERATOR'S NAME CAN BE A TOKEN RATHER THAN A WORD: 'operator +'.
''
'' IT WAS SKIPPED, NOT RECORDED. 'private operator = ( byref a as D, byref b as D ) as
'' boolean' reached Collect with NO NAME AT ALL, so nothing was declared for it, Resolve
'' set no return type, and the body's result assignment declined for want of a result
'' slot -- while the function itself went out under an EMPTY mangled name. Every
'' comparison operator in the runtime headers is spelled this way; fb/decimal.bi alone
'' has six.
''
'' The spelling comes from the token table's TEXT column -- '=' -- rather than from the
'' source, because RawSpelling only reads identifiers and these are punctuation.
''
'' Called from TWO places, which is the whole reason it is a procedure: the name may
'' follow the procedure keyword directly, or a QUALIFIER -- and in a generic the
'' qualifier comes after the type arguments, 'operator Array( of T ).[]', which is a
'' second dot loop further down. Only the first ran this, so the generic form lost its
'' name, its parameter list AND its return type: fbc's own Array( of T ) subscript
'' operator instantiated as a no-argument sub returning nothing.
private sub ReadOperatorName _
    ( byref p as Fbx.ParserState, byref sp as Fbx.StmtPayload )

    if (Peek( p ) = Fbx.TK_LPAREN) orelse AtEnd( p ) then return
    if Peek( p ) = Fbx.TK_EOL then return
    if Peek( p ) = Fbx.TK_DOT then return
    dim as string opNm = Fbx.TokenKindText( Peek( p ) )
    if len( opNm ) = 0 then return
    Advance( p )
    '' 'operator []' IS TWO TOKENS AND ONE NAME. Taking only the '[' left the ']' where
    '' the parameter list was expected, so the whole list was lost and the subscript
    '' operator reached lowering with nothing but a receiver.
    if (opNm = "[") andalso (Peek( p ) = Fbx.TK_RBRACKET) then
        opNm = "[]"
        Advance( p )
    end if
    if sp.name = 0 then
        sp.name = p.names->Fold( p.names->GetString( opNm ) )
        sp.rawName = p.names->GetString( opNm )
    end if
end sub

private function ParseProc _
    ( byref p as Fbx.ParserState, byval declareOnly as boolean ) as Fbx.NodeId

    dim as Fbx.Token t = Cur( p )
    dim as long procTok0 = p.pos
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
            '' THE WHOLE PATH, dotted, in the one field -- the same shape a qualified
            '' TYPE REFERENCE keeps. Overwriting per component kept only the LAST TWO,
            '' so 'constructor ctor.nested.UDT2( )' arrived with owner 'nested' and no
            '' way to reach it: 'this' stayed untyped AND the procedure mangled as
            '' plain 'UDT2', which links wrong rather than merely typing wrong.
            if sp.ownerName = 0 then
                sp.ownerName = sp.name
            else
                sp.ownerName = p.names->GetString( _
                    p.names->Spelling( sp.ownerName ) & "." & _
                    p.names->Spelling( sp.name ) )
            end if
            sp.rawName = RawSpelling( p )
            DeclName( p, sp.name )
        wend
    end if

    '' An operator's name can be a token rather than a word: 'operator +'.
    ''
    '' IT WAS SKIPPED, NOT RECORDED. 'private operator = ( byref a as D, byref b as D )
    '' as boolean' reached Collect with NO NAME AT ALL, so nothing was declared for it,
    '' Resolve set no return type, and the body's 'operator = ( ... )' result assignment
    '' declined for want of a result slot -- while the function itself went out under an
    '' EMPTY mangled name. Every comparison operator in the runtime headers is spelled
    '' this way; fb/decimal.bi alone has six.
    ''
    '' The spelling comes from the token table's TEXT column -- '=' -- rather than from
    '' the source, because RawSpelling only reads identifiers and these are punctuation.
    if kw = Fbx.KW_OPERATOR then ReadOperatorName( p, sp )

    '' FBC-Modern generics: 'type Box( of T )' and 'function Max( of T )( ... )'.
    if Peek( p ) = Fbx.TK_LPAREN then
        dim as long save = p.pos
        Advance( p )
        dim as boolean isGeneric = false
        if Peek( p ) = Fbx.TK_IDENT then
            isGeneric = (p.names->Spelling( cast( Fbx.InternId, Cur( p ).literal ) ) = "of")
        end if
        if isGeneric then
            '' THE PARAMETER NAMES ARE KEPT, in 'c' -- the same field N_TYPE uses in 'b'
            '' for exactly this. They used to be skipped, and with them went any chance
            '' of instantiating the procedure: its body lowered with every 'as T'
            '' standing for nothing, and produced a function under a name no call site
            '' would ever use. See PF_GENERIC_PROC.
            Advance( p )                  '' past 'of'
            sp.c = ParseTypeParams( p )
            sp.extra or= Fbx.PF_GENERIC_PROC
        else
            p.pos = save
        end if
    end if

    '' The qualification can follow the generic arguments:
    '' 'sub SetIterator( of T ).MoveNext( )'. Check again after them.
    ''
    '' AND IT MUST RECORD THE OWNER, exactly as the loop above does. Without that
    '' line 'sub Array( of T ).Push( )' had no ownerName, so Collect opened the body's
    '' scope under the MODULE instead of under the type, BindThis found no enclosing
    '' SCOPEK_TYPE, and 'this' stayed untyped -- every 'this.Reserve( ... )' inside a
    '' generic method was an unlowered call with an untyped base. Two of them per file
    '' for anything that merely includes fb/array.bi.
    while Peek( p ) = Fbx.TK_DOT
        Advance( p )
        qualified = true
        if sp.ownerName = 0 then
            sp.ownerName = sp.name
        else
            sp.ownerName = p.names->GetString( _
                p.names->Spelling( sp.ownerName ) & "." & _
                p.names->Spelling( sp.name ) )
        end if
        sp.rawName = RawSpelling( p )
        DeclName( p, sp.name )
    wend
    '' ...and the member after that qualifier may be an OPERATOR's punctuation, which
    '' DeclName cannot read: 'operator Array( of T ).[]'.
    if kw = Fbx.KW_OPERATOR then ReadOperatorName( p, sp )

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

    '' 'function F( ) BYREF as T' -- A BYREF RESULT. The BYREF sits between the
    '' parameter list and the AS, so Accept( KW_AS ) failed on it and the trailing-
    '' modifier loop below ate the whole return type: EVERY byref-returning function in
    '' the corpus reached Collect with NO RESULT TYPE AT ALL, which is most of
    '' fb/result.bi, fb/optional.bi and every conversion operator declared that way.
    '' Nothing said so -- an untyped result is not a diagnostic.
    dim as boolean byrefRet = ByrefResult_( p )
    if Accept( p, Fbx.KW_AS ) then sp.a = TypeRef( p )

    '' Trailing modifiers: static, const, export, alias "x", lib "y", cdecl ...
    while (Peek( p ) <> Fbx.TK_EOL) andalso (AtEnd( p ) = false)
        Advance( p )
    wend

    if declareOnly then
        dim as Fbx.NodeId dn = MakeStmt( p, Fbx.N_PROC, t.loc, sp )
        if qualified then p.ast->nodes[cast( long, dn )].flags or= Fbx.NF_QUALIFIED
        if byrefRet then p.ast->nodes[cast( long, dn )].flags or= Fbx.NF_BYREF
        return dn
    end if

    sp.b = Block( p )
    ExpectEnd( p, kw )
    dim as Fbx.NodeId pn = MakeStmt( p, Fbx.N_PROC, t.loc, sp )
    if qualified then p.ast->nodes[cast( long, pn )].flags or= Fbx.NF_QUALIFIED
    if byrefRet then p.ast->nodes[cast( long, pn )].flags or= Fbx.NF_BYREF
    '' A QUALIFIED DEFINITION -- 'function Box.Get( ) as T' -- may belong to a generic,
    '' and a GENERIC PROCEDURE is one in its own right. Either way instantiating it has
    '' to parse this body again to get nodes of its own. Nothing else is recorded: an
    '' ordinary procedure is never re-parsed and the table is scanned linearly.
    dim as boolean genProc = ((sp.extra and Fbx.PF_GENERIC_PROC) <> 0)
    if qualified orelse genProc then p.ast->RecordTokens( pn, procTok0, p.pos )
    return pn
end function

'' An ANONYMOUS procedure used as a VALUE -- a lambda.
''
''   dim as function( byref as T, byref as T ) as boolean less = _
''       function( byref x as T, byref y as T ) as boolean
''           return x < y
''       end function
''
'' fb/sort.bi writes exactly that, so this was not an exotic corner: four corpus
'' files failed inside a RUNTIME HEADER, at a construct none of them wrote.
''
'' Deliberately NOT ParseProc. That routine reads a name, a qualifier and a run of
'' trailing modifiers terminated by end of line, and a lambda has none of the first
'' two and cannot afford the third -- 'g( function( ) as long ... end function )'
'' has a ')' after the header's own line in some spellings, and the modifier loop
'' would swallow whatever followed. This reads exactly the header a lambda has.
''
'' The body is parsed and kept but NOT collected: an N_PROC reached through an
'' expression payload is never visited by the statement walker, so nothing declares
'' it and lowering declines the value. That is the honest position -- the file
'' parses, and nothing pretends the lambda was compiled.
'' 'sub( )' is not always a lambda. In 'procptr( T.constructor, sub( ) )' and in
'' 'type<sub( )>( 0 )' the very same tokens are a SIGNATURE -- an argument that names
'' a procedure's shape -- and both are accepted by fbc. Taking them as lambdas cost
'' 81 and 12 instructions in two corpus files that had been quietly correct.
''
'' fbc's own disambiguator is the BODY, and it says so: 'function( ) as long return 1
'' end function' on one line is error 351, "Unterminated lambda body, expected END SUB
'' or END FUNCTION". So a lambda's header is followed by end of line (a ':' counts --
'' it lexes as TK_EOL) and a signature's is followed by ')' or ',' or '>'.
''
'' That cannot be decided by lookahead: the header contains a parameter list and an
'' arbitrary type reference. So the header is parsed SPECULATIVELY and the cursor put
'' back if the answer is no. Diagnostics are suppressed across the attempt and the
'' error count restored with the position, or a signature would leave the count raised
'' for a parse that never happened. Nodes built during the attempt are abandoned in
'' the arena -- the arena is bump-allocated and never freed, so that is a few bytes,
'' not a leak.
declare function LambdaExpr( byref p as Fbx.ParserState ) as Fbx.NodeId

function TryLambdaExpr( byref p as Fbx.ParserState ) as Fbx.NodeId
    dim as long savedPos = p.pos
    dim as long savedErrors = p.errors
    dim as boolean savedSilent = p.silent
    p.silent = true

    dim as Fbx.StmtPayload probe
    dim as Fbx.TokenKind kw = Peek( p )
    Advance( p )
    select case Peek( p )
    case Fbx.KW_CDECL, Fbx.KW_STDCALL, Fbx.KW_PASCAL
        Advance( p )
    end select
    dim as boolean isLambda = false
    if Peek( p ) = Fbx.TK_LPAREN then
        ParseParamList( p, probe )
        if Accept( p, Fbx.KW_AS ) then probe.a = TypeRef( p )
        isLambda = (Peek( p ) = Fbx.TK_EOL)
    end if

    p.pos = savedPos
    p.errors = savedErrors
    p.silent = savedSilent
    if isLambda = false then return Fbx.NODE_NONE
    return LambdaExpr( p )
end function

private function LambdaExpr( byref p as Fbx.ParserState ) as Fbx.NodeId
    dim as Fbx.Token t = Cur( p )
    dim as Fbx.StmtPayload sp
    dim as Fbx.TokenKind kw = Peek( p )
    sp.op = cast( ushort, kw )
    Advance( p )

    '' A calling convention may sit between the keyword and the '(' -- measured:
    '' cdecl, stdcall and pascal are accepted there, EXPORT is not, and there are no
    '' trailing modifiers at all ('function( ) as long static' is error 3).
    select case Peek( p )
    case Fbx.KW_CDECL, Fbx.KW_STDCALL, Fbx.KW_PASCAL
        Advance( p )
    end select

    ParseParamList( p, sp )
    dim as boolean byrefRet = ByrefResult_( p )
    if Accept( p, Fbx.KW_AS ) then sp.a = TypeRef( p )

    sp.b = Block( p )
    ExpectEnd( p, kw )
    dim as Fbx.NodeId ln = MakeStmt( p, Fbx.N_PROC, t.loc, sp )
    if byrefRet then p.ast->nodes[cast( long, ln )].flags or= Fbx.NF_BYREF
    return ln
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

    '' 'EXTENDS T' IS A FIELD, not a flag. fbc embeds the base as the first member --
    ''
    ''     struct $1A { struct $10fb_Object$ BASE$; int32 F1; };
    ''
    '' -- at offset 0, before everything declared here, and every consequence of
    '' inheritance follows from that one fact: the layout is right without a special
    '' case, an upcast is the identity on the address, and the vptr of a type that
    '' extends 'object' lands at offset 0 because 'object' puts it there.
    ''
    '' The name is 'base', which no user field can collide with -- BASE is a keyword, so
    '' the lexer never produces it as an identifier.
    ''
    '' The typeref is still on the TYPE node as well, because a later pass wanting the
    '' base type should not have to recognise a field by its name.
    if sp.c <> Fbx.NODE_NONE then
        dim as Fbx.StmtPayload bp
        bp.name = p.names->GetString( "base" )
        bp.a = sp.c
        members.Push( cast( ulong, MakeStmt( p, Fbx.N_FIELD, t.loc, bp ) ) )
    end if

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

                '' A BITFIELD: 'xb0 : 1 as ulong'. The width comes BEFORE the type --
                '' measured, 'a as ulong : 3' is fbc error 14 and only 'a : 3 as ulong'
                '' and the type-first 'as ulong a : 3' are accepted.
                ''
                '' And there is NO TK_COLON TO LOOK FOR. The lexer turns every ':' into
                '' a TK_EOL marked TF_COLON, so the 'Accept( p, TK_COLON )' this
                '' replaces could never fire: the width was never read, the 'as ulong'
                '' after it was never reached, and the field came out with no type at
                '' all -- which is why a UDT of three bitfields laid out as SIZE ZERO.
                if IsColonHere( p ) then
                    Advance( p )
                    fp.b = Expression( p )
                end if
                if Accept( p, Fbx.KW_AS ) then fp.a = TypeRef( p )
                '' NO TRAILING WIDTH. 'a as ulong : 3' is fbc error 14, and a ':' after
                '' a field's type is a STATEMENT SEPARATOR -- 'x as integer : y as
                '' integer' is two fields on one line. Reading a width there consumed
                '' the next field as the expression and ran off the end of the TYPE:
                '' three corpus files that fbc accepts reported "expected 'end TYPE'".
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
    '' THE DECREMENT USED TO SIT AFTER THE RETURN, so aggDepth only ever grew: once one
    '' TYPE had been seen anywhere in the unit, a bare anonymous 'union' at module level
    '' was accepted for the rest of the file rather than being the error fbc calls it.
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

'' The names in a generic's parameter list, after the 'of', as an N_BLOCK of N_IDENT.
'' Positional: the first name binds the first argument. One node kind per name rather
'' than a bare InternId list, because everything downstream already walks children.
function ParseTypeParams( byref p as Fbx.ParserState ) as Fbx.NodeId
    dim as Fbx.Token t = Cur( p )
    dim as Fbx.NodeIdVec names
    dim as FB.Array( of ulong ) seen
    do
        if (Peek( p ) <> Fbx.TK_IDENT) andalso (Fbx.IsKeywordKind( Peek( p ) ) = false) then
            '' 'type Empty( of )' and 'type NotId( of 42 )'. fbc reports both at the
            '' DECLARATION, without waiting for an instantiation, and so does this --
            '' a parameter list that names nothing usable would otherwise produce a
            '' generic that can never be instantiated and never says why.
            ErrorNode( p, Fbx.FBX0321 )
            exit do
        end if
        dim as Fbx.Token nt = Cur( p )
        dim as Fbx.InternId nid = cast( Fbx.InternId, nt.literal )
        dim as boolean dup = false
        for i as long = 0 to seen.Count - 1
            if cast( Fbx.InternId, seen[i] ) = nid then dup = true
        next
        if dup then
            ErrorNode( p, Fbx.FBX0322, p.names->Spelling( nid ) )
        else
            seen.Push( cast( ulong, nid ) )
        end if
        names.Push( cast( ulong, MakeIdent( p, nt ) ) )
        Advance( p )
        if Accept( p, Fbx.TK_COMMA ) = false then exit do
    loop
    Expect( p, Fbx.TK_RPAREN, ")" )
    return MakeList( p, Fbx.N_BLOCK, t.loc, Fbx.NODE_NONE, names )
end function

'' TYPE / ENUM / NAMESPACE and the top-level Declaration dispatch live in their own
'' file: this one reached the 1500-line cap. Included HERE rather than compiled
'' separately because everything in it calls the helpers above and FreeBASIC has no
'' forward-declaration story that would make the other order work.
#include once "parser/decltype.bas"

end namespace
