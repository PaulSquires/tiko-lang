'' decl.bas -- declarations.  Included by parser.bas.

namespace Tko.Parse

'' Defined below: the TEXT of a string literal token, interned. Declared here because
'' VarItem needs it for a variable's ALIAS and is compiled before it.
declare function StringLitText( byref p as Tko.ParserState ) as Tko.InternId

'' One array bound. '...' is legal HERE and nowhere else, so it is read here rather
'' than in Primary -- loosening the expression grammar to carry it would let '...'
'' through in places FreeBASIC does not have it.
''
'' Measured: 'dim a(0 to ...)' and 'dim a(...)' both work, any dimension may use it and
'' several may, but 'redim a(0 to ...)' is fbc error 76, a TYPE FIELD is error 77, and
'' one with no initializer is error 281. The size comes from the initializer, so there
'' has to be one.
private function BoundExpr( byref p as Tko.ParserState ) as Tko.NodeId
    if Peek( p ) = Tko.TK_ELLIPSIS then
        dim as Tko.Token et = Cur( p )
        Advance( p )
        return NewNodeAt( p, Tko.N_ELLIPSIS, et.loc, 0 )
    end if
    return Expression( p )
end function

function IsDeclarationStart( byval k as Tko.TokenKind ) as boolean
    select case k
    case Tko.KW_DIM, Tko.KW_REDIM, Tko.KW_VAR, Tko.KW_CONST, Tko.KW_STATIC, _
         Tko.KW_SHARED, Tko.KW_COMMON, Tko.KW_EXTERN, Tko.KW_TYPE, Tko.KW_UNION, _
         Tko.KW_ENUM, Tko.KW_DECLARE, Tko.KW_SUB, Tko.KW_FUNCTION, Tko.KW_PROPERTY, _
         Tko.KW_CONSTRUCTOR, Tko.KW_DESTRUCTOR, Tko.KW_OPERATOR, Tko.KW_NAMESPACE, _
         Tko.KW_USING, Tko.KW_OPTION, Tko.KW_PRIVATE, Tko.KW_PUBLIC, _
         Tko.KW_VIRTUAL, Tko.KW_ABSTRACT
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
private function RawSpelling( byref p as Tko.ParserState ) as Tko.InternId
    dim as Tko.Token t = Cur( p )
    if Peek( p ) <> Tko.TK_IDENT then return 0
    if t.length <= 0 then return 0
    dim as Tko.DecodedLoc d = p.src->Decode( t.loc )
    dim as Tko.SourceFile ptr f = p.src->FileAt( d.file )
    if f = 0 then return 0
    if (d.offset + cast( long, t.length )) > f->text.Count then return 0
    return p.names->Get( @f->text[d.offset], cast( long, t.length ) )
end function

'' 'a.b' as an EXPRESSION node, built without going through the postfix parser -- which
'' cannot be used here because it would take the '( 0 to 9 )' that follows as a CALL and
'' swallow the bounds. The same node shape Postfix builds: an N_BINARY over '.', with
'' its kind changed to N_MEMBER.
private function MakeMemberRef_ _
    ( byref p as Tko.ParserState, byref dotTok as Tko.Token, _
      byval lhs as Tko.NodeId, byval rhs as Tko.NodeId ) as Tko.NodeId

    dim as Tko.BinaryPayload bp
    bp.op = cast( ushort, Tko.TK_DOT )
    bp.lhs = lhs
    bp.rhs = rhs
    p.ast->binaries.Push( bp )
    dim as Tko.NodeId n = _
        NewNodeAt( p, Tko.N_BINARY, dotTok.loc, p.ast->binaries.Count - 1 )
    p.ast->nodes[cast( long, n )].kind = cast( ushort, Tko.N_MEMBER )
    return n
end function

private function DeclName( byref p as Tko.ParserState, byref outName as Tko.InternId ) as boolean
    dim as Tko.TokenKind k = Peek( p )
    if k = Tko.TK_IDENT then
        outName = cast( Tko.InternId, Cur( p ).literal )
        Advance( p )
        return true
    end if
    if Tko.IsKeywordKind( k ) then
        outName = p.names->GetString( Tko.Text.LowerAscii( Tko.TokenKindText( k ) ) )
        Advance( p )
        return true
    end if
    outName = Tko.INTERN_NONE
    return false
end function

'' Array bounds into 'c'. 'dim x()' is a dynamic array with no bounds given. Shared by
'' the named form and by a REDIM's parenthesised target, which reads its bounds the
'' same way after a different head.
private sub ParseArrayBoundsInto _
    ( byref p as Tko.ParserState, byref sp as Tko.StmtPayload, byref t as Tko.Token )

    if Peek( p ) <> Tko.TK_LPAREN then return
    Advance( p )
    dim as Tko.NodeIdVec dims
    if Peek( p ) <> Tko.TK_RPAREN then
        do
            dim as Tko.NodeId lo = BoundExpr( p )
            if Accept( p, Tko.KW_TO ) then
                dim as Tko.Token rt = Cur( p )
                dim as Tko.StmtPayload rp
                rp.a = lo
                rp.b = BoundExpr( p )
                dims.Push( cast( ulong, MakeStmt( p, Tko.N_CASE_RANGE, rt.loc, rp ) ) )
            else
                dims.Push( cast( ulong, lo ) )
            end if
            if Accept( p, Tko.TK_COMMA ) = false then exit do
        loop
    end if
    Expect( p, Tko.TK_RPAREN, ")" )
    sp.c = MakeList( p, Tko.N_BLOCK, t.loc, Tko.NODE_NONE, dims )
end sub

'' 'dim x(0 to 9, 3) as long = 5' -- one item of a declaration list.
''
'' A REDIM target may be PARENTHESISED: 'redim (a)(0 to 1)' is legal on a var-len
'' array, and 'redim (1+1)(0 to 1)' PARSES and is then fbc error 54. Both have to get
'' through the parser or the corpus's COMPILE_ONLY_FAIL files fail for the wrong
'' reason. A dotted target -- 'redim ns.arr(0 to 2)' -- already worked.
private function VarItem _
    ( byref p as Tko.ParserState, byval isRedim as boolean = false ) as Tko.NodeId

    dim as Tko.Token t = Cur( p )
    dim as Tko.StmtPayload sp

    if isRedim andalso (Peek( p ) = Tko.TK_LPAREN) then
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
        Expect( p, Tko.TK_RPAREN, ")" )
        sp.extra = cast( ushort, Tko.KW_REDIM )
        ParseArrayBoundsInto( p, sp, t )
        dim as Tko.NodeId rn = MakeStmt( p, Tko.N_VAR_ITEM, t.loc, sp )
        if sp.c <> Tko.NODE_NONE then p.ast->nodes[cast( long, rn )].flags or= Tko.NF_ARRAY
        return rn
    end if

    dim as Tko.Token headTok = Cur( p )
    if DeclName( p, sp.name ) = false then return ErrorNode( p, Tko.TKO0406 )

    '' 'dim UDT.i as integer' -- a qualified name defines a static member.
    ''
    '' A REDIM IS DIFFERENT: 'redim x.array( 0 to 9 )' names an array THROUGH an
    '' object, and only the LAST name was kept. Lowering then looked up 'array' in the
    '' enclosing scope -- so it declined when nothing of that name was there, and would
    '' have re-dimensioned THE WRONG ARRAY if something was. The chain is built as an
    '' expression here and put in the target slot the parenthesised form already uses,
    '' so both spellings reach lowering the same way. 202 corpus lines write it.
    dim as boolean qualified = false
    dim as Tko.NodeId qexpr = Tko.NODE_NONE
    if isRedim then qexpr = MakeIdent( p, headTok )
    '' THE QUALIFIER IS KEPT. Only the LAST component used to survive, so
    '' 'dim shared as integer T.counter' -- the DEFINITION of a static member --
    '' looked like a module-level 'counter' that nothing had declared, and the
    '' statement declined. The owner goes where a member PROCEDURE's already does.
    dim as string ownerPath = ""
    while Peek( p ) = Tko.TK_DOT
        dim as Tko.Token dotTok = Cur( p )
        Advance( p )
        if len( ownerPath ) > 0 then ownerPath += "."
        ownerPath += p.names->Spelling( sp.name )
        qualified = true
        dim as Tko.Token memberTok = Cur( p )
        DeclName( p, sp.name )
        if qexpr <> Tko.NODE_NONE then
            qexpr = MakeMemberRef_( p, dotTok, qexpr, MakeIdent( p, memberTok ) )
        end if
    wend
    if qualified then sp.ownerName = p.names->GetString( ownerPath )
    if isRedim andalso qualified andalso (qexpr <> Tko.NODE_NONE) then
        sp.b = qexpr
        sp.extra = cast( ushort, Tko.KW_REDIM )
    end if

    ParseArrayBoundsInto( p, sp, t )

    '' 'extern import _ctype alias "_ctype" as ushort ptr ptr' -- an ALIAS on a
    '' VARIABLE, which is how the CRT headers declare every imported one. Without it
    '' 'alias' was read where 'as' was expected, the declaration came out untyped, and
    '' ctype.bi and stdlib.bi failed on eight lines between them -- taking with them
    '' every corpus file that reaches the C runtime through either.
    ''
    '' Recorded in 'aliasName', which is where a PROCEDURE's alias already goes.
    if Accept( p, Tko.KW_ALIAS ) then
        '' StringLitText does NOT advance -- it reads the token under the cursor -- so
        '' the literal has to be stepped over here, or the 'as' that follows is never
        '' seen and the declaration comes out untyped anyway.
        sp.aliasName = StringLitText( p )
        if Peek( p ) = Tko.TK_STRING_LIT then Advance( p )
    end if

    if Accept( p, Tko.KW_AS ) then sp.a = TypeRef( p )

    '' '=' initialiser, or '=>' for a const.
    if (Peek( p ) = Tko.TK_EQ) orelse (Peek( p ) = Tko.TK_FATARROW) then
        Advance( p )
        sp.b = Expression( p )
    end if

    dim as Tko.NodeId n = MakeStmt( p, Tko.N_VAR_ITEM, t.loc, sp )
    if sp.c <> Tko.NODE_NONE then p.ast->nodes[cast( long, n )].flags or= Tko.NF_ARRAY
    if qualified then p.ast->nodes[cast( long, n )].flags or= Tko.NF_QUALIFIED
    return n
end function

'' dim / redim / var / static / shared / common / extern, in any legal combination.
private function ParseVarDecl( byref p as Tko.ParserState ) as Tko.NodeId
    dim as Tko.Token t = Cur( p )
    dim as Tko.StmtPayload sp
    sp.op = cast( ushort, Peek( p ) )
    dim as ushort flags = 0

    '' The leading keywords may stack: 'dim shared', 'static shared', 'redim preserve'.
    do
        dim as Tko.TokenKind k = Peek( p )
        select case k
        case Tko.KW_DIM, Tko.KW_REDIM, Tko.KW_VAR, Tko.KW_COMMON, Tko.KW_EXTERN
            Advance( p )
        case Tko.KW_SHARED
            flags or= Tko.NF_SHARED
            Advance( p )
        case Tko.KW_STATIC
            flags or= Tko.NF_STATIC
            Advance( p )
        case Tko.KW_PRESERVE
            flags or= Tko.NF_PRESERVE
            Advance( p )
        case Tko.KW_IMPORT, Tko.KW_EXPORT
            '' 'extern import _ctype alias "_ctype" as ushort ptr ptr' -- a DLL-imported
            '' variable, which is how the CRT headers declare every one of theirs.
            '' Without this the modifier was read as the variable's NAME and the real
            '' name as its type, so ctype.bi and stdlib.bi each failed twice and every
            '' corpus file that reaches the C runtime through them failed with it.
            ''
            '' It affects the linkage, not the declaration, and tiko-lang emits no import
            '' table -- so it is consumed and NOT recorded, which is honest about
            '' producing the same declaration either way.
            Advance( p )
        case Tko.KW_BYREF
            '' 'dim byref rb as string = a' -- a REFERENCE variable. Without this the
            '' name was read as 'byref' and the rest of the statement discarded: no
            '' type, no initializer, no 'rb', and NO DIAGNOSTIC. It only surfaced on the
            '' second occurrence, as a redeclaration of 'byref'.
            ''
            '' Measured: fbc accepts it with and without SHARED, and refuses one with no
            '' initializer (error 320, 'Reference not initialized') -- a semantic rule
            '' tiko-lang does not implement yet.
            flags or= Tko.NF_BYREF
            Advance( p )
        case else
            exit do
        end select
    loop

    '' 'dim as long a, b' -- a shared type written before the names.
    dim as Tko.NodeId sharedType = Tko.NODE_NONE
    if Accept( p, Tko.KW_AS ) then sharedType = TypeRef( p )

    dim as Tko.NodeIdVec items
    do
        dim as long before = p.pos
        dim as Tko.NodeId item = VarItem( p, sp.op = cast( ushort, Tko.KW_REDIM ) )
        items.Push( cast( ulong, item ) )
        '' The item may be an ERROR node, which has no StmtPayload -- indexing its
        '' 'data' as one is a segfault. Error nodes must be checked for, never
        '' assumed away (docs/plan/05 invariant 5).
        dim as boolean isItem = (p.ast->Kind( item ) = Tko.N_VAR_ITEM)
        if isItem andalso (sharedType <> Tko.NODE_NONE) then
            dim as long si = cast( long, p.ast->nodes[cast( long, item )].data )
            if p.ast->stmts[si].a = Tko.NODE_NONE then p.ast->stmts[si].a = sharedType
        end if
        if isItem = false then exit do
        if p.pos = before then exit do
        if Accept( p, Tko.TK_COMMA ) = false then exit do
    loop

    sp.first = p.ast->children.Count
    sp.count = items.Count
    for i as long = 0 to items.Count - 1
        p.ast->children.Push( items[i] )
    next

    dim as Tko.NodeId n = MakeStmt( p, Tko.N_VAR, t.loc, sp )
    p.ast->nodes[cast( long, n )].flags or= flags
    return n
end function

private function ParseConstDecl( byref p as Tko.ParserState ) as Tko.NodeId
    dim as Tko.Token t = Cur( p )
    Advance( p )
    dim as Tko.StmtPayload sp
    dim as Tko.NodeIdVec items

    '' 'const as ulongint u = 1' -- the TYPE-FIRST form, which DIM has always had and
    '' CONST did not. Without it 'as' was read as the constant's NAME and everything
    '' after it discarded: no type, no value, no 'u', and NO DIAGNOSTIC. It surfaced
    '' only on the second such declaration, as a redeclaration of 'as' -- twenty corpus
    '' files, the largest single line-shape in the largest remaining bucket.
    ''
    '' Measured: fbc accepts 'const as ubyte a = 1, b = 2' too, so the type is shared
    '' across a comma list exactly as it is for DIM.
    dim as Tko.NodeId sharedType = Tko.NODE_NONE
    if Accept( p, Tko.KW_AS ) then sharedType = TypeRef( p )

    do
        dim as Tko.NodeId item = VarItem( p, false )
        items.Push( cast( ulong, item ) )
        '' An ERROR node has no StmtPayload; indexing its 'data' as one is a segfault.
        if p.ast->Kind( item ) <> Tko.N_VAR_ITEM then exit do
        if sharedType <> Tko.NODE_NONE then
            dim as long si = cast( long, p.ast->nodes[cast( long, item )].data )
            if p.ast->stmts[si].a = Tko.NODE_NONE then p.ast->stmts[si].a = sharedType
        end if
        if Accept( p, Tko.TK_COMMA ) = false then exit do
    loop
    sp.first = p.ast->children.Count
    sp.count = items.Count
    for i as long = 0 to items.Count - 1
        p.ast->children.Push( items[i] )
    next
    return MakeStmt( p, Tko.N_CONST, t.loc, sp )
end function

'' One parameter: '[byval|byref] name [( )] [as T] [= default]'.
private function ParseParam( byref p as Tko.ParserState ) as Tko.NodeId
    dim as Tko.Token t = Cur( p )
    dim as Tko.StmtPayload sp
    dim as ushort flags = 0

    if Accept( p, Tko.KW_BYVAL ) then
        '' RECORDED, because the absence of NF_BYREF does NOT mean byval: with neither
        '' keyword written the default is BYREF for a UDT or a string and BYVAL for
        '' everything else, and which one that is depends on a type this pass has not
        '' resolved. Resolve settles it.
        flags or= Tko.NF_BYVAL_WRITTEN
    elseif Accept( p, Tko.KW_BYREF ) then
        flags or= Tko.NF_BYREF
    end if

    if Peek( p ) = Tko.TK_ELLIPSIS then
        Advance( p )
        '' MARKED, because an ellipsis parameter is otherwise indistinguishable from an
        '' unnamed one by anything but the ABSENCE of a typeref -- and lowering has to
        '' know: a variadic procedure has no parameter list to run past, so nothing
        '' after the written arguments is defaulted. Without the mark, 'printf( @s )'
        '' looked like a one-argument call to a two-parameter procedure and declined.
        ''
        '' 'op' is the keyword that spelled a node, which is free on an N_PARAM.
        sp.op = cast( ushort, Tko.TK_ELLIPSIS )
        dim as Tko.NodeId v = MakeStmt( p, Tko.N_PARAM, t.loc, sp )
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
    dim as Tko.TokenKind pk = Peek( p )
    if (pk <> Tko.KW_AS) andalso (pk <> Tko.TK_LPAREN) then
        if DeclName( p, sp.name ) = false then return ErrorNode( p, Tko.TKO0406 )
    end if

    if Peek( p ) = Tko.TK_LPAREN then
        Advance( p )
        while (Peek( p ) <> Tko.TK_RPAREN) andalso (AtEnd( p ) = false)
            Advance( p )
        wend
        Expect( p, Tko.TK_RPAREN, ")" )
        flags or= Tko.NF_ARRAY
    end if

    if Accept( p, Tko.KW_AS ) then sp.a = TypeRef( p )
    if Accept( p, Tko.TK_EQ ) then sp.b = Expression( p )

    dim as Tko.NodeId n = MakeStmt( p, Tko.N_PARAM, t.loc, sp )
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
    ( byref p as Tko.ParserState, byref sp as Tko.StmtPayload )

    dim as Tko.NodeIdVec bounds
    if Accept( p, Tko.TK_LPAREN ) = false then return
    if Peek( p ) <> Tko.TK_RPAREN then
        do
            dim as long before = p.pos
            dim as Tko.NodeId first_ = BoundExpr( p )
            if Accept( p, Tko.KW_TO ) then
                bounds.Push( cast( ulong, first_ ) )
                bounds.Push( cast( ulong, BoundExpr( p ) ) )
            else
                bounds.Push( cast( ulong, Tko.NODE_NONE ) )
                bounds.Push( cast( ulong, first_ ) )
            end if
            if p.pos = before then exit do
            if Accept( p, Tko.TK_COMMA ) = false then exit do
        loop
    end if
    Expect( p, Tko.TK_RPAREN, ")" )
    sp.first = p.ast->children.Count
    sp.count = bounds.Count
    for i as long = 0 to bounds.Count - 1
        p.ast->children.Push( bounds[i] )
    next
end sub

'' Intern the text of the string literal at the cursor, WITHOUT advancing. The
'' literal pool records the span with the quotes already stripped, and the case is
'' preserved: an ALIAS keeps exactly the spelling that was written.
function StringLitText( byref p as Tko.ParserState ) as Tko.InternId
    dim as Tko.Token t = Cur( p )
    if p.litPool = 0 then return 0
    if cast( long, t.literal ) >= p.litPool->Count then return 0
    dim as Tko.Literal ptr lit = @(*p.litPool)[cast( long, t.literal )]
    if lit->textLength <= 0 then return 0
    '' The literal's OWN file. Taking it from t.loc breaks for any token produced by
    '' macro expansion, whose loc points at the use site rather than at the text.
    dim as Tko.SourceFile ptr f = p.src->FileAt( cast( Tko.FileId, lit->textFile ) )
    if f = 0 then return 0
    if (lit->textOffset + lit->textLength) > f->text.Count then return 0
    return p.names->Get( @f->text[lit->textOffset], lit->textLength )
end function

sub ParseParamList( byref p as Tko.ParserState, byref sp as Tko.StmtPayload )
    dim as Tko.NodeIdVec params
    if Peek( p ) = Tko.TK_LPAREN then
        Advance( p )
        if Peek( p ) <> Tko.TK_RPAREN then
            do
                dim as long before = p.pos
                params.Push( cast( ulong, ParseParam( p ) ) )
                if p.pos = before then exit do
                if Accept( p, Tko.TK_COMMA ) = false then exit do
            loop
        end if
        Expect( p, Tko.TK_RPAREN, ")" )
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
private function IsColonHere( byref p as Tko.ParserState ) as boolean
    if Peek( p ) <> Tko.TK_EOL then return false
    return ((Cur( p ).flags and Tko.TF_COLON) <> 0)
end function

'' The '( of T, U )' parameter list. Defined below; both the TYPE and the PROCEDURE
'' forms need it, and the procedure one is parsed first.
declare function ParseTypeParams( byref p as Tko.ParserState ) as Tko.NodeId

'' A 'BYREF' that introduces a RESULT TYPE, consumed if so. It is only that when an AS
'' follows: 'function F( ) byref as T'. A bare BYREF anywhere else is somebody's trailing
'' modifier and is left alone.
private function ByrefResult_( byref p as Tko.ParserState ) as boolean
    if Peek( p ) <> Tko.KW_BYREF then return false
    if HasTok( p, p.pos + 1 ) = false then return false
    if cast( Tko.TokenKind, p.toks->At( p.pos + 1 ).kind ) <> Tko.KW_AS then return false
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
    ( byref p as Tko.ParserState, byref sp as Tko.StmtPayload )

    if (Peek( p ) = Tko.TK_LPAREN) orelse AtEnd( p ) then return
    if Peek( p ) = Tko.TK_EOL then return
    if Peek( p ) = Tko.TK_DOT then return
    dim as string opNm = Tko.TokenKindText( Peek( p ) )
    if len( opNm ) = 0 then return
    Advance( p )
    '' 'operator []' IS TWO TOKENS AND ONE NAME. Taking only the '[' left the ']' where
    '' the parameter list was expected, so the whole list was lost and the subscript
    '' operator reached lowering with nothing but a receiver.
    if (opNm = "[") andalso (Peek( p ) = Tko.TK_RBRACKET) then
        opNm = "[]"
        Advance( p )
    end if
    if sp.name = 0 then
        sp.name = p.names->Fold( p.names->GetString( opNm ) )
        sp.rawName = p.names->GetString( opNm )
    end if
end sub

private function ParseProc _
    ( byref p as Tko.ParserState, byval declareOnly as boolean ) as Tko.NodeId

    dim as Tko.Token t = Cur( p )
    dim as long procTok0 = p.pos
    dim as Tko.StmtPayload sp

    '' 'const function T.F( )' and 'static sub T.S( )' put the modifier BEFORE the
    '' procedure keyword. Const-ness is not cosmetic: it is what makes the mangled
    '' name _ZNK... rather than _ZN..., so a procedure that loses it links wrong.
    do
        select case Peek( p )
        case Tko.KW_CONST    : sp.extra or= Tko.PF_CONST
        case Tko.KW_STATIC   : sp.extra or= Tko.PF_STATIC
        case Tko.KW_ABSTRACT : sp.extra or= Tko.PF_ABSTRACT
        case Tko.KW_VIRTUAL  : sp.extra or= Tko.PF_VIRTUAL
        case else            : exit do
        end select
        Advance( p )
    loop

    dim as Tko.TokenKind kw = Peek( p )
    sp.op = cast( ushort, kw )
    Advance( p )

    '' The name may be qualified ('Stack.Push') or absent (constructors).
    dim as boolean qualified = false
    if (Peek( p ) = Tko.TK_IDENT) orelse Tko.IsKeywordKind( Peek( p ) ) then
        sp.rawName = RawSpelling( p )
        DeclName( p, sp.name )
        while Peek( p ) = Tko.TK_DOT
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
    if kw = Tko.KW_OPERATOR then ReadOperatorName( p, sp )

    '' FBC-Modern generics: 'type Box( of T )' and 'function Max( of T )( ... )'.
    if Peek( p ) = Tko.TK_LPAREN then
        dim as long save = p.pos
        Advance( p )
        dim as boolean isGeneric = false
        if Peek( p ) = Tko.TK_IDENT then
            isGeneric = (p.names->Spelling( cast( Tko.InternId, Cur( p ).literal ) ) = "of")
        end if
        if isGeneric then
            '' THE PARAMETER NAMES ARE KEPT, in 'c' -- the same field N_TYPE uses in 'b'
            '' for exactly this. They used to be skipped, and with them went any chance
            '' of instantiating the procedure: its body lowered with every 'as T'
            '' standing for nothing, and produced a function under a name no call site
            '' would ever use. See PF_GENERIC_PROC.
            Advance( p )                  '' past 'of'
            sp.c = ParseTypeParams( p )
            sp.extra or= Tko.PF_GENERIC_PROC
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
    while Peek( p ) = Tko.TK_DOT
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
    if kw = Tko.KW_OPERATOR then ReadOperatorName( p, sp )

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
        while Tko.IsCallConvKind( Peek( p ) )
            select case Peek( p )
            case Tko.KW_CDECL   : sp.extra or= Tko.PF_CDECL
            case Tko.KW_STDCALL : sp.extra or= Tko.PF_STDCALL
            case Tko.KW_PASCAL  : sp.extra or= Tko.PF_PASCAL
            end select
            Advance( p )
            ate = true
        wend
        if Accept( p, Tko.KW_OVERLOAD ) then
            '' OVERLOAD alone forces mangling, even when nothing else shares the
            '' name: fbc mangles on the KEYWORD, not on there being a second one.
            sp.extra or= Tko.PF_OVERLOAD
            ate = true
        end if
        if Accept( p, Tko.KW_ALIAS ) then
            '' The alias replaces the IDENTIFIER and keeps its case, but the name is
            '' still mangled around it: 'sub F overload alias "lower_case"' is
            '' _Z10lower_casei, not 'lower_case'.
            if Peek( p ) = Tko.TK_STRING_LIT then
                sp.aliasName = StringLitText( p )
                Advance( p )
            end if
            ate = true
        end if
        if Accept( p, Tko.KW_LIB ) then
            if Peek( p ) = Tko.TK_STRING_LIT then Advance( p )
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
    if Accept( p, Tko.KW_AS ) then sp.a = TypeRef( p )

    '' Trailing modifiers: static, const, export, alias "x", lib "y", cdecl ...
    while (Peek( p ) <> Tko.TK_EOL) andalso (AtEnd( p ) = false)
        Advance( p )
    wend

    if declareOnly then
        dim as Tko.NodeId dn = MakeStmt( p, Tko.N_PROC, t.loc, sp )
        if qualified then p.ast->nodes[cast( long, dn )].flags or= Tko.NF_QUALIFIED
        if byrefRet then p.ast->nodes[cast( long, dn )].flags or= Tko.NF_BYREF
        return dn
    end if

    sp.b = Block( p )
    ExpectEnd( p, kw )
    dim as Tko.NodeId pn = MakeStmt( p, Tko.N_PROC, t.loc, sp )
    if qualified then p.ast->nodes[cast( long, pn )].flags or= Tko.NF_QUALIFIED
    if byrefRet then p.ast->nodes[cast( long, pn )].flags or= Tko.NF_BYREF
    '' A QUALIFIED DEFINITION -- 'function Box.Get( ) as T' -- may belong to a generic,
    '' and a GENERIC PROCEDURE is one in its own right. Either way instantiating it has
    '' to parse this body again to get nodes of its own. Nothing else is recorded: an
    '' ordinary procedure is never re-parsed and the table is scanned linearly.
    dim as boolean genProc = ((sp.extra and Tko.PF_GENERIC_PROC) <> 0)
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
declare function LambdaExpr( byref p as Tko.ParserState ) as Tko.NodeId

function TryLambdaExpr( byref p as Tko.ParserState ) as Tko.NodeId
    dim as long savedPos = p.pos
    dim as long savedErrors = p.errors
    dim as boolean savedSilent = p.silent
    p.silent = true

    dim as Tko.StmtPayload probe
    dim as Tko.TokenKind kw = Peek( p )
    Advance( p )
    select case Peek( p )
    case Tko.KW_CDECL, Tko.KW_STDCALL, Tko.KW_PASCAL
        Advance( p )
    end select
    dim as boolean isLambda = false
    if Peek( p ) = Tko.TK_LPAREN then
        ParseParamList( p, probe )
        '' A BYREF RESULT IS PART OF THE SIGNATURE. 'function( byref a as long, byref
        '' b as long ) byref as long' is how generics/lambda.bas writes its picker,
        '' and stopping at the 'byref' made the probe say "not a lambda" -- so the
        '' body was parsed as statements where an expression belonged.
        ByrefResult_( p )
        if Accept( p, Tko.KW_AS ) then probe.a = TypeRef( p )
        '' ...AND THE ONE-LINE FORM ends in a COLON, not an EOL: 'dim shared g as Fn =
        '' function( byval x as long ) as long : return x + 100 : end function'.
        isLambda = (Peek( p ) = Tko.TK_EOL) orelse (Peek( p ) = Tko.TK_COLON)
    end if

    p.pos = savedPos
    p.errors = savedErrors
    p.silent = savedSilent
    if isLambda = false then return Tko.NODE_NONE
    return LambdaExpr( p )
end function

private function LambdaExpr( byref p as Tko.ParserState ) as Tko.NodeId
    dim as Tko.Token t = Cur( p )
    dim as Tko.StmtPayload sp
    dim as Tko.TokenKind kw = Peek( p )
    sp.op = cast( ushort, kw )
    Advance( p )

    '' A calling convention may sit between the keyword and the '(' -- measured:
    '' cdecl, stdcall and pascal are accepted there, EXPORT is not, and there are no
    '' trailing modifiers at all ('function( ) as long static' is error 3).
    select case Peek( p )
    case Tko.KW_CDECL, Tko.KW_STDCALL, Tko.KW_PASCAL
        Advance( p )
    end select

    ParseParamList( p, sp )
    dim as boolean byrefRet = ByrefResult_( p )
    if Accept( p, Tko.KW_AS ) then sp.a = TypeRef( p )

    sp.b = Block( p )
    ExpectEnd( p, kw )

    '' A LAMBDA IS AN ORDINARY PROCEDURE WITH A GENERATED NAME, and the expression is
    '' its ADDRESS. Measured: fbc emits a function called L2B9C516C192D043_LT_0003 and
    '' writes 'LESS$1 = (tmp$2)&L2B9C516C192D043_LT_0003'. Nothing outside the module
    '' can name it, so the spelling is ours to choose -- but it must not COLLIDE
    '' across translation units, which is what the file's content hash is for: the
    '' same thing fbc's own hex prefix does.
    ''
    '' HOISTED to module level rather than lowered in place, because a procedure is
    '' not an expression: Collect declares it, Resolve binds its body, and the site
    '' that wrote it gets '@name' -- which is what fbc emits and what every later pass
    '' already understands. FreeBASIC lambdas CAPTURE NOTHING (the body may name an
    '' enclosing local's TYPE but not its value), so there is no closure to build.
    dim as ulong lhash = 0
    dim as Tko.DecodedLoc ld = p.src->Decode( t.loc )
    dim as Tko.SourceFile ptr lf = p.src->FileAt( ld.file )
    if lf <> 0 then lhash = lf->contentHash
    sp.name = p.names->GetString( "__tko_lambda_" & hex( lhash ) & "_" & _
                                  trim( str( p.lambdaSeq ) ) )
    p.lambdaSeq += 1

    dim as Tko.NodeId ln = MakeStmt( p, Tko.N_PROC, t.loc, sp )
    if byrefRet then p.ast->nodes[cast( long, ln )].flags or= Tko.NF_BYREF
    p.lambdas.Push( cast( ulong, ln ) )

    return MakeAddrOfName( p, sp.name, t.loc, ld.offset, cast( long, t.length ) )
end function

'' An access section reaches into a nested anonymous TYPE or UNION -- measured: a
'' field of a union written under 'private:' is an illegal member access from outside.
'' The nested body parses with its own section state, so the label is applied here
'' instead, and only to members that carry none of their own.
private sub ApplyVisibility _
    ( byref p as Tko.ParserState, byval n as Tko.NodeId, byval vis as ushort )

    if (vis = 0) orelse (n = Tko.NODE_NONE) then return
    if p.ast->nodes[cast( long, n )].kind <> Tko.N_TYPE then return

    dim as Tko.StmtPayload ptr tp = _
        @p.ast->stmts[cast( long, p.ast->nodes[cast( long, n )].data )]

    for i as long = 0 to tp->count - 1
        dim as Tko.NodeId m = cast( Tko.NodeId, p.ast->children[tp->first + i] )
        if m = Tko.NODE_NONE then continue for
        dim as Tko.NodeKind mk = p.ast->nodes[cast( long, m )].kind
        if mk = Tko.N_TYPE then
            ApplyVisibility( p, m, vis )
        elseif (mk = Tko.N_FIELD) orelse (mk = Tko.N_PROC) then
            dim as Tko.StmtPayload ptr mp = _
                @p.ast->stmts[cast( long, p.ast->nodes[cast( long, m )].data )]
            dim as ushort had = mp->extra and _
                                (Tko.PF_MEMB_PRIVATE or Tko.PF_MEMB_PROTECTED)
            if had = 0 then mp->extra or= vis
        end if
    next
end sub

'' A FIELD whose NAME is a keyword. MEASURED against fbc, one keyword at a time over
'' all 247 of them: it accepts 223 and REJECTS exactly these twenty-four --
''
''   the operator words   and andalso eqv imp mod not or orelse shl shr xor
''   the declarers        const declare dim enum redim static private protected public
''   and                  as delete new rem
''
'' -- so the rule is a DENY list, not the five-name allow list this used to be.
'' win/shldisp.bi alone declares interface members called Open, NameSpace, Windows and
'' Explore, and 'NameSpace as function( ... )' opened a NAMESPACE BLOCK that swallowed
'' the next eighteen lines: the vtable lost its fields and all 133 calls through it
'' declined.
''
'' What follows decides it: a field is 'name as T', 'name( bounds ) as T' or
'' 'as T name' -- the last handled elsewhere. A DECLARATION never has 'as' or '(' in
'' that position, which is what keeps a real 'type T' or 'namespace N' out.
private function IsFieldNamedByKeyword _
    ( byref p as Tko.ParserState, byval k as Tko.TokenKind ) as boolean

    if Tko.IsKeywordKind( k ) = false then return false
    select case k
    case Tko.KW_AND, Tko.KW_ANDALSO, Tko.KW_EQV, Tko.KW_IMP, Tko.KW_MOD, _
         Tko.KW_NOT, Tko.KW_OR, Tko.KW_ORELSE, Tko.KW_SHL, Tko.KW_SHR, Tko.KW_XOR
        return false
    case Tko.KW_CONST, Tko.KW_DECLARE, Tko.KW_DIM, Tko.KW_ENUM, Tko.KW_REDIM, _
         Tko.KW_STATIC, Tko.KW_PRIVATE, Tko.KW_PROTECTED, Tko.KW_PUBLIC
        return false
    case Tko.KW_AS, Tko.KW_DELETE, Tko.KW_NEW, Tko.KW_REM
        return false
    end select
    if HasTok( p, p.pos + 1 ) = false then return false
    dim as Tko.TokenKind nx = cast( Tko.TokenKind, p.toks->At( p.pos + 1 ).kind )
    return (nx = Tko.KW_AS) orelse (nx = Tko.TK_LPAREN)
end function

'' The member list of a TYPE or UNION, its 'end', and the node. Shared by the named
'' and the ANONYMOUS forms, which differ only in whether a name was read.
private function ParseAggregateBody _
    ( byref p as Tko.ParserState, byref t as Tko.Token, _
      byref sp as Tko.StmtPayload, byval isUnion as boolean ) as Tko.NodeId

    p.aggDepth += 1
    dim as Tko.NodeIdVec members

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
    if sp.c <> Tko.NODE_NONE then
        dim as Tko.StmtPayload bp
        bp.name = p.names->GetString( "base" )
        bp.a = sp.c
        members.Push( cast( ulong, MakeStmt( p, Tko.N_FIELD, t.loc, bp ) ) )
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
        if Peek( p ) = Tko.KW_END then exit do

        dim as long before = p.pos
        dim as Tko.TokenKind k = Peek( p )

        '' 'private:' and friends. The colon is what tells a LABEL from the PRIVATE
        '' that modifies a procedure, so both tokens are required before either is
        '' consumed -- and 4 corpus files reach the keyword through a macro parameter,
        '' which is why this tests the token and not the source text.
        dim as boolean isVisKw = (k = Tko.KW_PRIVATE) orelse _
                                 (k = Tko.KW_PUBLIC) orelse (k = Tko.KW_PROTECTED)
        if (isUnion = false) andalso isVisKw then
            '' There is no TK_COLON to look for: the lexer turns a ':' statement
            '' separator into a TK_EOL and marks it TF_COLON, because ':' separates
            '' statements exactly as a newline does. So the label is a visibility
            '' keyword followed by an EOL THAT CAME FROM A COLON, and a bare
            '' 'private' on its own line is not one -- fbc says so too, error 203.
            dim as boolean labelled = false
            if HasTok( p, p.pos + 1 ) then
                dim as Tko.Token nx = p.toks->At( p.pos + 1 )
                labelled = (cast( Tko.TokenKind, nx.kind ) = Tko.TK_EOL) andalso _
                           ((nx.flags and Tko.TF_COLON) <> 0)
            end if
            if labelled then
                select case as const k
                case Tko.KW_PRIVATE   : vis = Tko.PF_MEMB_PRIVATE
                case Tko.KW_PROTECTED : vis = Tko.PF_MEMB_PROTECTED
                case else             : vis = 0
                end select
                Advance( p )
                Advance( p )
                continue do
            end if
        end if

        if k = Tko.KW_AS then
            '' 'as long x, y' -- the type comes first and is shared by the names.
            Advance( p )
            dim as Tko.NodeId shared_ = TypeRef( p )
            do
                dim as Tko.Token ft = Cur( p )
                dim as Tko.StmtPayload fp
                if DeclName( p, fp.name ) = false then exit do
                ParseArrayBounds( p, fp )
                if fp.count > 0 then fp.op = cast( ushort, Tko.KW_DIM )
                fp.a = shared_
                fp.extra or= vis
                members.Push( cast( ulong, MakeStmt( p, Tko.N_FIELD, ft.loc, fp ) ) )
                if Accept( p, Tko.TK_COMMA ) = false then exit do
            loop
        elseif IsFieldNamedByKeyword( p, k ) then
            '' A FIELD whose name is a keyword that also starts a declaration:
            '' winnt.bi writes 'Function as ULONGLONG' inside two unions, and tiko-lang read
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
            dim as Tko.Token ft = Cur( p )
            dim as Tko.StmtPayload fp
            fp.name = p.names->GetString( _
                Tko.Text.LowerAscii( Tko.TokenKindText( k ) ) )
            Advance( p )
            ParseArrayBoundsInto( p, fp, ft )
            if fp.c <> Tko.NODE_NONE then fp.op = cast( ushort, Tko.KW_DIM )
            if Accept( p, Tko.KW_AS ) then fp.a = TypeRef( p )
            fp.extra or= vis
            members.Push( cast( ulong, MakeStmt( p, Tko.N_FIELD, ft.loc, fp ) ) )
        elseif IsDeclarationStart( k ) then
            dim as Tko.NodeId mn = Declaration( p )
            '' Only an N_PROC carries a StmtPayload whose 'extra' is the modifier set;
            '' reaching into stmts[] for any other kind would land on another node's
            '' payload and corrupt it silently.
            dim as boolean tagIt = (vis <> 0) andalso (mn <> Tko.NODE_NONE)
            if tagIt then
                select case p.ast->nodes[cast( long, mn )].kind
                case Tko.N_PROC
                    dim as Tko.StmtPayload ptr mp = _
                        @p.ast->stmts[cast( long, p.ast->nodes[cast( long, mn )].data )]
                    mp->extra or= vis
                case Tko.N_TYPE
                    ApplyVisibility( p, mn, vis )
                end select
            end if
            members.Push( cast( ulong, mn ) )
        elseif (k = Tko.TK_IDENT) orelse Tko.IsKeywordKind( k ) then
            '' A field: 'name as T' or 'as T name' (the latter via ParseVarDecl).
            dim as Tko.Token ft = Cur( p )
            dim as Tko.StmtPayload fp
            if DeclName( p, fp.name ) then
                ParseArrayBounds( p, fp )
                if fp.count > 0 then
                    fp.op = cast( ushort, Tko.KW_DIM )   '' marks 'has bounds'
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
                if Accept( p, Tko.KW_AS ) then fp.a = TypeRef( p )
                '' NO TRAILING WIDTH. 'a as ulong : 3' is fbc error 14, and a ':' after
                '' a field's type is a STATEMENT SEPARATOR -- 'x as integer : y as
                '' integer' is two fields on one line. Reading a width there consumed
                '' the next field as the expression and ran off the end of the TYPE:
                '' three corpus files that fbc accepts reported "expected 'end TYPE'".
                fp.extra or= vis
                members.Push( cast( ulong, MakeStmt( p, Tko.N_FIELD, ft.loc, fp ) ) )
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

    ExpectEnd( p, iif( isUnion, Tko.KW_UNION, Tko.KW_TYPE ), t.loc )
    dim as Tko.NodeId n = MakeStmt( p, Tko.N_TYPE, t.loc, sp )
    if isUnion then p.ast->nodes[cast( long, n )].flags or= Tko.NF_IS_UNION
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
private sub ParseFieldClause( byref p as Tko.ParserState, byref sp as Tko.StmtPayload )
    if Peek( p ) <> Tko.KW_FIELD then return
    Advance( p )
    if Accept( p, Tko.TK_EQ ) = false then return
    dim as Tko.NodeId nExpr = Expression( p )
    sp.extra = 0
    if nExpr = Tko.NODE_NONE then return
    if p.ast->Kind( nExpr ) <> Tko.N_INT_LIT then return
    sp.extra = cast( ushort, _
        p.ast->literals[cast( long, p.ast->nodes[cast( long, nExpr )].data )].intValue )
end sub

'' The names in a generic's parameter list, after the 'of', as an N_BLOCK of N_IDENT.
'' Positional: the first name binds the first argument. One node kind per name rather
'' than a bare InternId list, because everything downstream already walks children.
function ParseTypeParams( byref p as Tko.ParserState ) as Tko.NodeId
    dim as Tko.Token t = Cur( p )
    dim as Tko.NodeIdVec names
    dim as FB.Array( of ulong ) seen
    do
        if (Peek( p ) <> Tko.TK_IDENT) andalso (Tko.IsKeywordKind( Peek( p ) ) = false) then
            '' 'type Empty( of )' and 'type NotId( of 42 )'. fbc reports both at the
            '' DECLARATION, without waiting for an instantiation, and so does this --
            '' a parameter list that names nothing usable would otherwise produce a
            '' generic that can never be instantiated and never says why.
            ErrorNode( p, Tko.TKO0321 )
            exit do
        end if
        dim as Tko.Token nt = Cur( p )
        dim as Tko.InternId nid = cast( Tko.InternId, nt.literal )
        dim as boolean dup = false
        for i as long = 0 to seen.Count - 1
            if cast( Tko.InternId, seen[i] ) = nid then dup = true
        next
        if dup then
            ErrorNode( p, Tko.TKO0322, p.names->Spelling( nid ) )
        else
            seen.Push( cast( ulong, nid ) )
        end if
        names.Push( cast( ulong, MakeIdent( p, nt ) ) )
        Advance( p )
        if Accept( p, Tko.TK_COMMA ) = false then exit do
    loop
    Expect( p, Tko.TK_RPAREN, ")" )
    return MakeList( p, Tko.N_BLOCK, t.loc, Tko.NODE_NONE, names )
end function

'' TYPE / ENUM / NAMESPACE and the top-level Declaration dispatch live in their own
'' file: this one reached the 1500-line cap. Included HERE rather than compiled
'' separately because everything in it calls the helpers above and FreeBASIC has no
'' forward-declaration story that would make the other order work.
#include once "parser/decltype.bas"

end namespace
