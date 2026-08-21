'' intrinsics.bas -- the intrinsic statement grammars.  Included by parser.bas.
''
'' Dispatch is on the registry, so adding an intrinsic is a table row plus, sometimes,
'' a function (docs/plan/04 section 5).
''
'' Every parser here obeys the same two rules as the rest of the parser: it consumes
'' at least one token per iteration, and it never runs past the end of the line.

namespace Fbx

dim shared as ubyte   intrForm( 0 to TK_KIND_COUNT - 1 )
dim shared as boolean intrReady = false

private sub InitIntrinsicTable( )
    if intrReady then return
    for i as long = 0 to TK_KIND_COUNT - 1
        intrForm(i) = cast( ubyte, IFORM_NONE )
    next
    #macro INTR( i_kind, i_form )
        intrForm(i_kind) = cast( ubyte, i_form )
    #endmacro
    FBX_INTRINSIC_LIST( INTR )
    #undef INTR
    intrReady = true
end sub

function IntrinsicFormOf( byval k as TokenKind ) as IntrinsicForm
    InitIntrinsicTable( )
    dim as boolean bad = (k < 0) orelse (k >= TK_KIND_COUNT)
    if bad then return IFORM_NONE
    return cast( IntrinsicForm, intrForm(k) )
end function

'' Only these forms may BEGIN a statement. Expression functions and context modifiers
'' must not, or 'x = len(s)' would parse as a LEN statement.
function IsStatementIntrinsic( byval k as TokenKind ) as boolean
    select case IntrinsicFormOf( k )
    case IFORM_GENERIC, IFORM_NOARGS, IFORM_PRINT, IFORM_INPUT, IFORM_LINE, _
         IFORM_OPEN, IFORM_FILENUM, IFORM_GETPUT, IFORM_DATA, IFORM_ON, _
         IFORM_SWAP, IFORM_NAME, IFORM_DEFTYPE, IFORM_GFX, IFORM_UNSUPPORTED
        return true
    end select
    return false
end function

end namespace

namespace Fbx.Parse

'' Comma-separated expressions to end of line. The workhorse: two thirds of the
'' registry needs nothing more.
private sub IntrArgList( byref p as Fbx.ParserState, byref items as Fbx.NodeIdVec )
    do
        if (Peek( p ) = Fbx.TK_EOL) orelse AtEnd( p ) then exit do
        dim as long before = p.pos
        '' 'locate ,,0' -- an intrinsic's arguments may be elided too.
        dim as Fbx.NodeId arg = ArgOrElided( p, Fbx.TK_EOL )
        items.Push( cast( ulong, arg ) )
        '' The no-progress guard exists to stop a loop that cannot consume anything.
        '' An ELIDED argument consumes nothing BY DEFINITION, so it has to be exempt --
        '' the comma after it is what advances, and without this 'locate ,,0' bailed
        '' out on its first argument.
        if (p.ast->Kind( arg ) <> Fbx.N_ELIDED) andalso (p.pos = before) then exit do
        if Accept( p, Fbx.TK_COMMA ) = false then exit do
    loop
end sub

'' '#n' or '#n,' -- a file number, which several forms accept as a leading argument.
private function IntrFileNum( byref p as Fbx.ParserState ) as Fbx.NodeId
    if Peek( p ) <> Fbx.TK_HASH then return Fbx.NODE_NONE
    Advance( p )
    return Expression( p, Fbx.PREC_POSTFIX )
end function

'' PRINT / LPRINT / WRITE.
''   [#n,] [USING fmt;] expr [ ; | , ] expr ...
'' The separators are semantically meaningful -- ';' suppresses the column advance --
'' so they are recorded as N_PRINT_SEP children rather than skipped.
private sub IntrPrint( byref p as Fbx.ParserState, byref sp as Fbx.StmtPayload )
    sp.a = IntrFileNum( p )
    if sp.a <> Fbx.NODE_NONE then
        if Accept( p, Fbx.TK_COMMA ) = false then Accept( p, Fbx.TK_SEMICOLON )
    end if

    if Peek( p ) = Fbx.KW_USING then
        Advance( p )
        sp.c = Expression( p )
        if Accept( p, Fbx.TK_SEMICOLON ) = false then Accept( p, Fbx.TK_COMMA )
        sp.extra = 1                      '' marks the USING form for lowering
    end if

    '' Separators are INTERLEAVED with the items as N_PRINT_SEP markers, because what
    '' follows an item decides how it prints: fbc passes 0 for ';', 2 for ',' and 1 for
    '' end-of-statement as the third argument to every fb_Print* call. Dropping them
    '' would make 'print a; b', 'print a, b' and 'print a;' indistinguishable, and all
    '' three produce different output.
    dim as Fbx.NodeIdVec items
    do
        if (Peek( p ) = Fbx.TK_EOL) orelse AtEnd( p ) then exit do
        '' 'if c then print i end if' -- the item list must stop at what closes the
        '' enclosing single-line statement, or it eats it.
        if EndsSingleLineStmt( p ) then exit do
        dim as Fbx.TokenKind k = Peek( p )
        if (k = Fbx.TK_SEMICOLON) orelse (k = Fbx.TK_COMMA) then
            dim as Fbx.Token t = Cur( p )
            Advance( p )
            dim as Fbx.StmtPayload ssp
            ssp.op = cast( ushort, k )
            items.Push( cast( ulong, MakeStmt( p, Fbx.N_PRINT_SEP, t.loc, ssp ) ) )
            continue do
        end if
        dim as long before = p.pos
        items.Push( cast( ulong, Expression( p ) ) )
        if p.pos = before then exit do
    loop

    sp.first = p.ast->children.Count
    sp.count = items.Count
    for i as long = 0 to items.Count - 1
        p.ast->children.Push( items[i] )
    next
end sub

'' INPUT / WINPUT / LINE INPUT.
''   [#n,] [;] [prompt ( ; | , )] var [, var]
'' The prompt is a string literal followed by ';' or ',', which is the only thing that
'' distinguishes it from the first variable.
private sub IntrInput( byref p as Fbx.ParserState, byref sp as Fbx.StmtPayload )
    sp.a = IntrFileNum( p )
    if sp.a <> Fbx.NODE_NONE then Accept( p, Fbx.TK_COMMA )

    '' A LEADING ';' -- 'input ; a' -- suppresses the newline the runtime would echo
    '' after the user presses return. It comes before the prompt, so it cannot be folded
    '' into the prompt handling below, and without it the ';' is read as the start of an
    '' expression and the whole statement fails to parse.
    ''
    '' Worth the note: this one missing token produced 9,568 of the corpus's 11,719
    '' error nodes, because four machine-generated syntax tests exercise every INPUT
    '' variation about 1,200 times each.
    '' BIT 4, not 1. LINE INPUT arrives here with 'extra' already set to 1 to say so,
    '' and overwriting it made a LINE INPUT and a semicolon-suppressed INPUT
    '' indistinguishable -- the flags are a SET, and each needs its own bit.
    if Accept( p, Fbx.TK_SEMICOLON ) then sp.extra or= 4

    if Peek( p ) = Fbx.TK_STRING_LIT then
        dim as long save = p.pos
        dim as Fbx.NodeId prompt = Expression( p, Fbx.PREC_POSTFIX )
        dim as boolean isPrompt = (Peek( p ) = Fbx.TK_SEMICOLON) orelse _
                                  (Peek( p ) = Fbx.TK_COMMA)
        if isPrompt then
            sp.c = prompt
            Advance( p )
        else
            p.pos = save
        end if
    end if

    dim as Fbx.NodeIdVec items
    IntrArgList( p, items )
    sp.first = p.ast->children.Count
    sp.count = items.Count
    for i as long = 0 to items.Count - 1
        p.ast->children.Push( items[i] )
    next
end sub

'' OPEN f FOR mode [ACCESS a] [LOCK l] AS [#]n [LEN = x]
'' The modifiers are context keywords, which is why they are in the registry as
'' IFORM_CONTEXT: they are only meaningful here.
'' OPEN, in both spellings. As a STATEMENT the clauses run to end of line; as an
'' EXPRESSION -- 'if open( "x", for output, as #1 ) <> 0' -- they run to the closing
'' paren and the whole thing yields the error code. Measured: fbc accepts the
'' expression form with every clause the statement takes, the comma-less QB spelling
'' 'open( f for input as #1 )', ACCESS, ENCODING, and 'open pipe( ... )'.
private sub IntrOpen _
    ( byref p as Fbx.ParserState, byref sp as Fbx.StmtPayload, _
      byval stopParen as boolean = false )

    sp.a = Expression( p )

    dim as Fbx.NodeIdVec items
    do
        if (Peek( p ) = Fbx.TK_EOL) orelse AtEnd( p ) then exit do
        if stopParen andalso (Peek( p ) = Fbx.TK_RPAREN) then exit do
        dim as Fbx.TokenKind k = Peek( p )

        if k = Fbx.KW_FOR then
            Advance( p )
            if (Peek( p ) <> Fbx.TK_EOL) andalso (AtEnd( p ) = false) then Advance( p )
            continue do
        end if
        if (k = Fbx.KW_ACCESS) orelse (k = Fbx.KW_LOCK) then
            Advance( p )
            '' 'access read write' is two words; consume while they are keywords.
            while Fbx.IsKeywordKind( Peek( p ) ) andalso (Peek( p ) <> Fbx.KW_AS)
                Advance( p )
            wend
            continue do
        end if
        if k = Fbx.KW_AS then
            Advance( p )
            if Peek( p ) = Fbx.TK_HASH then Advance( p )
            sp.b = Expression( p, Fbx.PREC_POSTFIX )
            continue do
        end if
        '' ENCODING takes a string that is not one of the clause keywords, so without
        '' this it would fall through to the trailing-expression case and be collected
        '' as a filename.
        if k = Fbx.KW_ENCODING then
            Advance( p )
            if (Peek( p ) <> Fbx.TK_EOL) andalso (AtEnd( p ) = false) then
                items.Push( cast( ulong, Expression( p ) ) )
            end if
            continue do
        end if
        if k = Fbx.KW_LEN then
            Advance( p )
            Accept( p, Fbx.TK_EQ )
            sp.c = Expression( p )
            continue do
        end if
        if k = Fbx.TK_COMMA then
            Advance( p )
            continue do
        end if

        dim as long before = p.pos
        items.Push( cast( ulong, Expression( p ) ) )
        if p.pos = before then exit do
    loop

    sp.first = p.ast->children.Count
    sp.count = items.Count
    for i as long = 0 to items.Count - 1
        p.ast->children.Push( items[i] )
    next
end sub

'' CLOSE / SEEK / LOCK / UNLOCK: '#n [, expr ...]', and CLOSE takes a list of them.
'' 'open( ... )' / 'open pipe( ... )' in EXPRESSION position. The cursor is on OPEN.
function OpenExprCall( byref p as Fbx.ParserState ) as Fbx.NodeId
    dim as Fbx.Token t = Cur( p )
    Advance( p )                                    '' OPEN
    '' 'pipe' is not a keyword -- it arrives as an identifier, the same way the
    '' statement form sees it.
    if Peek( p ) = Fbx.TK_IDENT then Advance( p )
    if Accept( p, Fbx.TK_LPAREN ) = false then
        return ErrorNode( p, Fbx.FBX0401, "(" )
    end if
    dim as Fbx.StmtPayload sp
    sp.op = cast( ushort, Fbx.KW_OPEN )
    IntrOpen( p, sp, true )
    Expect( p, Fbx.TK_RPAREN, ")" )
    return MakeStmt( p, Fbx.N_INTRINSIC, t.loc, sp )
end function

private sub IntrFileNumList( byref p as Fbx.ParserState, byref sp as Fbx.StmtPayload )
    dim as Fbx.NodeIdVec items
    do
        if (Peek( p ) = Fbx.TK_EOL) orelse AtEnd( p ) then exit do
        if Peek( p ) = Fbx.TK_HASH then Advance( p )
        dim as long before = p.pos
        items.Push( cast( ulong, Expression( p ) ) )
        if p.pos = before then exit do
        if Accept( p, Fbx.TK_COMMA ) = false then exit do
    loop
    sp.first = p.ast->children.Count
    sp.count = items.Count
    for i as long = 0 to items.Count - 1
        p.ast->children.Push( items[i] )
    next
end sub

'' GET and PUT are TWO statements sharing one keyword:
''   file:     GET #n, [pos], var
''   graphics: PUT [target,] (x, y), source [, mode]
'' A leading '#' or a leading '(' is what tells them apart.
private sub IntrGetPut( byref p as Fbx.ParserState, byref sp as Fbx.StmtPayload )
    dim as boolean isFile = (Peek( p ) = Fbx.TK_HASH)
    sp.extra = iif( isFile, 1, 2 )

    if isFile then
        Advance( p )
        sp.a = Expression( p, Fbx.PREC_POSTFIX )
        Accept( p, Fbx.TK_COMMA )
    end if

    dim as Fbx.NodeIdVec items
    do
        if (Peek( p ) = Fbx.TK_EOL) orelse AtEnd( p ) then exit do
        if Peek( p ) = Fbx.TK_COMMA then
            Advance( p )
            continue do
        end if
        '' The graphics form writes '(x,y)-(x,y)'; the '-' parses as a binary minus
        '' between two parenthesised expressions, which is structurally faithful.
        dim as long before = p.pos
        items.Push( cast( ulong, Expression( p ) ) )
        if p.pos = before then exit do
    loop

    sp.first = p.ast->children.Count
    sp.count = items.Count
    for i as long = 0 to items.Count - 1
        p.ast->children.Push( items[i] )
    next
end sub

'' LINE is two statements too: 'LINE INPUT ...' and the graphics LINE.
private sub IntrLine( byref p as Fbx.ParserState, byref sp as Fbx.StmtPayload )
    if Peek( p ) = Fbx.KW_INPUT then
        Advance( p )
        sp.extra = 1
        IntrInput( p, sp )
        return
    end if
    sp.extra = 2
    dim as Fbx.NodeIdVec items
    do
        if (Peek( p ) = Fbx.TK_EOL) orelse AtEnd( p ) then exit do
        if Peek( p ) = Fbx.TK_COMMA then
            Advance( p )
            continue do
        end if
        dim as long before = p.pos
        items.Push( cast( ulong, Expression( p ) ) )
        if p.pos = before then exit do
    loop
    sp.first = p.ast->children.Count
    sp.count = items.Count
    for i as long = 0 to items.Count - 1
        p.ast->children.Push( items[i] )
    next
end sub

'' DATA holds literals, not expressions: unquoted words are data, not identifiers.
'' They are kept as raw tokens because only the DATA table cares what they say.
private sub IntrData( byref p as Fbx.ParserState, byref sp as Fbx.StmtPayload )
    dim as Fbx.NodeIdVec items
    do
        if (Peek( p ) = Fbx.TK_EOL) orelse AtEnd( p ) then exit do
        if Peek( p ) = Fbx.TK_COMMA then
            Advance( p )
            continue do
        end if
        dim as Fbx.Token t = Cur( p )
        items.Push( cast( ulong, MakeTokenNode( p, t ) ) )
        Advance( p )
    loop
    sp.first = p.ast->children.Count
    sp.count = items.Count
    for i as long = 0 to items.Count - 1
        p.ast->children.Push( items[i] )
    next
end sub

'' ON expr GOTO l1, l2 ...   /   ON [LOCAL] ERROR GOTO label
private sub IntrOn( byref p as Fbx.ParserState, byref sp as Fbx.StmtPayload )
    if Peek( p ) = Fbx.KW_LOCAL then Advance( p )

    if Peek( p ) = Fbx.KW_ERROR then
        Advance( p )
        sp.extra = 1
        if (Peek( p ) = Fbx.KW_GOTO) orelse (Peek( p ) = Fbx.KW_GOSUB) then Advance( p )
        if (Peek( p ) = Fbx.TK_IDENT) orelse (Peek( p ) = Fbx.TK_INT_LIT) then
            sp.name = cast( Fbx.InternId, Cur( p ).literal )
            Advance( p )
        end if
        return
    end if

    sp.extra = 2
    sp.a = Expression( p )
    if (Peek( p ) = Fbx.KW_GOTO) orelse (Peek( p ) = Fbx.KW_GOSUB) then Advance( p )

    dim as Fbx.NodeIdVec items
    do
        if (Peek( p ) = Fbx.TK_EOL) orelse AtEnd( p ) then exit do
        dim as Fbx.Token t = Cur( p )
        items.Push( cast( ulong, MakeIdent( p, t ) ) )
        Advance( p )
        if Accept( p, Fbx.TK_COMMA ) = false then exit do
    loop
    sp.first = p.ast->children.Count
    sp.count = items.Count
    for i as long = 0 to items.Count - 1
        p.ast->children.Push( items[i] )
    next
end sub

'' DEFINT A-Z: letter ranges, not expressions.
private sub IntrDefType( byref p as Fbx.ParserState, byref sp as Fbx.StmtPayload )
    dim as Fbx.NodeIdVec items
    do
        if (Peek( p ) = Fbx.TK_EOL) orelse AtEnd( p ) then exit do
        dim as Fbx.Token t = Cur( p )
        if (Peek( p ) = Fbx.TK_IDENT) orelse Fbx.IsKeywordKind( Peek( p ) ) then
            items.Push( cast( ulong, MakeIdent( p, t ) ) )
        end if
        Advance( p )
        if (Peek( p ) = Fbx.TK_MINUS) orelse (Peek( p ) = Fbx.TK_COMMA) then
            Advance( p )
            continue do
        end if
        exit do
    loop
    sp.first = p.ast->children.Count
    sp.count = items.Count
    for i as long = 0 to items.Count - 1
        p.ast->children.Push( items[i] )
    next
end sub

'' The entry point: dispatch on the registry.
function ParseIntrinsic( byref p as Fbx.ParserState ) as Fbx.NodeId
    dim as Fbx.Token t = Cur( p )
    dim as Fbx.TokenKind k = Peek( p )
    dim as Fbx.StmtPayload sp
    sp.op = cast( ushort, k )

    '' '?' is PRINT, and is not a keyword at all.
    dim as Fbx.IntrinsicForm form = Fbx.IFORM_PRINT
    if k <> Fbx.TK_QUESTION then form = Fbx.IntrinsicFormOf( k )
    Advance( p )

    select case form
    case Fbx.IFORM_PRINT    : IntrPrint( p, sp )
    case Fbx.IFORM_INPUT    : IntrInput( p, sp )
    case Fbx.IFORM_LINE     : IntrLine( p, sp )
    case Fbx.IFORM_OPEN     : IntrOpen( p, sp )
    case Fbx.IFORM_FILENUM  : IntrFileNumList( p, sp )
    case Fbx.IFORM_GETPUT   : IntrGetPut( p, sp )
    case Fbx.IFORM_DATA     : IntrData( p, sp )
    case Fbx.IFORM_ON       : IntrOn( p, sp )
    case Fbx.IFORM_DEFTYPE  : IntrDefType( p, sp )

    case Fbx.IFORM_SWAP, Fbx.IFORM_NAME
        sp.a = Expression( p )
        if Accept( p, Fbx.TK_COMMA ) = false then Accept( p, Fbx.KW_AS )
        sp.b = Expression( p )

    case Fbx.IFORM_CVA_ARG
        '' cva_arg( list, TYPE ). The second argument is a TYPE REFERENCE, not an
        '' expression, so the argument list cannot be parsed generically.
        Expect( p, Fbx.TK_LPAREN, "(" )
        sp.a = Expression( p )
        Expect( p, Fbx.TK_COMMA, "," )
        sp.c = TypeRef( p )
        Expect( p, Fbx.TK_RPAREN, ")" )

    case Fbx.IFORM_UNSUPPORTED
        ErrorNode( p, Fbx.FBX0409, Fbx.TokenKindText( k ) )
        EndOfStatement( p )

    case else
        '' IFORM_GENERIC and IFORM_GFX. The graphics coordinate syntax
        '' '(x,y)-(x,y)' parses as ordinary expressions, which is faithful enough
        '' for the tree; gfxlib2 lowering will interpret it.
        dim as Fbx.NodeIdVec items
        IntrArgList( p, items )
        sp.first = p.ast->children.Count
        sp.count = items.Count
        for i as long = 0 to items.Count - 1
            p.ast->children.Push( items[i] )
        next
    end select

    return MakeStmt( p, Fbx.N_INTRINSIC, t.loc, sp )
end function

end namespace
