'' parser.bas -- see parser.bi
''
'' StmtPayload slot conventions, by node kind:
''
''   N_IF          b = branch list (N_IF_BRANCH each), c = else block
''   N_IF_BRANCH   a = condition, b = body block
''   N_SELECT      a = subject, b = case list, c = case else block
''   N_CASE        b = body block, first/count = pattern list
''   N_CASE_RANGE  a = low, b = high, op = relational token for 'IS <op>'
''   N_FOR         a = counter, b = body, c = 'as T' TypeRef or NONE,
''                 children = [from, to, step], any of which may be NONE
''   N_FOREACH     a = loop variable, b = body, c = 'as T' TypeRef or NONE,
''                 children = [sequence]
''   N_DO/N_WHILE  a = condition, b = body
''   N_WITH        a = subject, b = body
''   N_SCOPE       b = body
''   N_RETURN      a = value
''   N_EXIT/N_CONT extra = level count, op = target keyword
''   N_GOTO/N_LABEL name
''   N_AMBIGUOUS   a = target expression, b = rhs, op = assignment token (0 = call),
''                 first/count = paren-less argument list
''   N_INTRINSIC   op = keyword, first/count = arguments
''   N_VAR         first/count = N_VAR_ITEM list, op = the declaring keyword
''   N_VAR_ITEM    name, a = typeref, b = initialiser, c = array bounds list
''   N_CONST       name, a = typeref, b = value
''   N_TYPE        name, first/count = members
''   N_FIELD       name, a = typeref, b = bitfield width
''   N_ENUM        name, first/count = N_ENUM_ITEM
''   N_ENUM_ITEM   name, b = value
''   N_PROC        name, a = return typeref, b = body, first/count = params, op = kind
''   N_PARAM       name, a = typeref, b = default value
''   N_NAMESPACE   name, first/count = members
''   N_TYPEREF     name, a = element typeref, first/count = args or dims

#include once "parser/parser.bi"
#include once "parser/intrinsics.bi"
#include once "support/text.bi"

namespace Fbx.Parse

declare function IsDeclarationStart( byval k as Fbx.TokenKind ) as boolean
declare function Declaration( byref p as Fbx.ParserState ) as Fbx.NodeId
declare function Block( byref p as Fbx.ParserState ) as Fbx.NodeId
declare sub EndOfStatement( byref p as Fbx.ParserState )
declare sub SkipEols( byref p as Fbx.ParserState )
declare function AtEnd( byref p as Fbx.ParserState ) as boolean
declare function ParseIntrinsic( byref p as Fbx.ParserState ) as Fbx.NodeId
declare sub ParseParamList( byref p as Fbx.ParserState, byref sp as Fbx.StmtPayload )

function AtEnd( byref p as Fbx.ParserState ) as boolean
    return (Peek( p ) = Fbx.TK_EOF)
end function

sub SkipEols( byref p as Fbx.ParserState )
    while Peek( p ) = Fbx.TK_EOL
        Advance( p )
    wend
end sub

sub EndOfStatement( byref p as Fbx.ParserState )
    '' A statement never consumes more than its own terminator.
    while (Peek( p ) <> Fbx.TK_EOL) andalso (AtEnd( p ) = false)
        Advance( p )
    wend
    if Peek( p ) = Fbx.TK_EOL then Advance( p )
end sub

'' Recovery: consume to the next line, guaranteeing progress so no input can loop.
private sub Sync( byref p as Fbx.ParserState )
    dim as long before = p.pos
    EndOfStatement( p )
    if p.pos = before then Advance( p )
end sub

'' The keywords that may follow END to close a block. Taken from the ExpectEnd call
'' sites, so the two cannot drift: anything ExpectEnd is asked to close must appear here.
private function ClosesABlock( byval k as Fbx.TokenKind ) as boolean
    select case k
    case Fbx.KW_IF, Fbx.KW_SELECT, Fbx.KW_WHILE, Fbx.KW_WITH, Fbx.KW_SCOPE, _
         Fbx.KW_ASM, Fbx.KW_ENUM, Fbx.KW_NAMESPACE, Fbx.KW_EXTERN, Fbx.KW_TYPE, _
         Fbx.KW_UNION, Fbx.KW_SUB, Fbx.KW_FUNCTION, Fbx.KW_CONSTRUCTOR, _
         Fbx.KW_DESTRUCTOR, Fbx.KW_PROPERTY, Fbx.KW_OPERATOR
        return true
    end select
    return false
end function

'' Whether the statement list should stop here.
''
'' END IS NOT UNCONDITIONAL. 'END' also TERMINATES THE PROGRAM, with an optional exit
'' code -- 'end', 'end 3' -- so it closes a block only when a block keyword follows.
''
'' This predicate is where a mistake propagates furthest: the comment above the
'' single-line-IF handling records an 'end if' taken from an enclosing block, which then
'' swallowed an 'end function' and left a namespace unclosed hundreds of lines later. So
'' the test is a WHITELIST of what may follow, not a guess about what may not: an
'' unrecognised word after END leaves it a block ender, which is the old behaviour and
'' the safe direction to be wrong in.
private function IsBlockEnderAt( byref p as Fbx.ParserState ) as boolean
    dim as Fbx.TokenKind k = Peek( p )
    select case k
    case Fbx.KW_ELSE, Fbx.KW_ELSEIF, Fbx.KW_NEXT, Fbx.KW_LOOP, _
         Fbx.KW_WEND, Fbx.KW_CASE, Fbx.TK_EOF
        return true
    case Fbx.KW_END
        if HasTok( p, p.pos + 1 ) = false then return true
        dim as Fbx.TokenKind nk = cast( Fbx.TokenKind, p.toks->At( p.pos + 1 ).kind )
        '' 'end' alone on its line, or 'end <expr>', is the STATEMENT.
        if nk = Fbx.TK_EOL then return false
        if ClosesABlock( nk ) then return true
        return false
    end select
    return false
end function

'' A statement list, stopping before whatever closes the enclosing construct.
function Block( byref p as Fbx.ParserState ) as Fbx.NodeId
    dim as Fbx.Token t = Cur( p )
    dim as Fbx.NodeIdVec items
    do
        SkipEols( p )
        if AtEnd( p ) then exit do
        if IsBlockEnderAt( p ) then exit do
        dim as Fbx.NodeId s = Statement( p )
        if s <> Fbx.NODE_NONE then items.Push( cast( ulong, s ) )
    loop
    return MakeList( p, Fbx.N_BLOCK, t.loc, Fbx.NODE_NONE, items )
end function

'' 'END IF', 'END SUB' ... -- accepted with or without the trailing keyword, because
'' fbc accepts both and a missing one is diagnosed by the caller, not here.
private sub ExpectEnd( byref p as Fbx.ParserState, byval what as Fbx.TokenKind )
    if Accept( p, Fbx.KW_END ) then
        if Peek( p ) = what then Advance( p )
        return
    end if
    ErrorNode( p, Fbx.FBX0405, Fbx.TokenKindText( what ) )
end sub

'' ---------------------------------------------------------------- type references

function TypeRef( byref p as Fbx.ParserState ) as Fbx.NodeId
    dim as Fbx.Token t = Cur( p )
    dim as Fbx.StmtPayload sp
    dim as ushort flags = 0

    '' 'const T' and 'T const' are both written; the qualifier is a flag, not a level.
    while Peek( p ) = Fbx.KW_CONST
        Advance( p )
        flags or= Fbx.NF_CONST
    wend

    '' A procedure type: 'sub|function [cdecl|stdcall|pascal] ( params ) [as T]'.
    '' This is what 'as function cdecl ( ) as long = NULL' needs, and it appears
    '' throughout real headers as a callback parameter.
    dim as Fbx.TokenKind pk = Peek( p )
    if (pk = Fbx.KW_SUB) orelse (pk = Fbx.KW_FUNCTION) then
        Advance( p )
        sp.op = cast( ushort, pk )
        while Fbx.IsCallConvKind( Peek( p ) )
            Advance( p )
        wend
        ParseParamList( p, sp )
        if Accept( p, Fbx.KW_AS ) then sp.a = TypeRef( p )
        dim as Fbx.NodeId pn = MakeStmt( p, Fbx.N_TYPEREF, t.loc, sp )
        p.ast->nodes[cast( long, pn )].flags or= flags or Fbx.NF_PROC_TYPE
        while (Peek( p ) = Fbx.KW_PTR) orelse (Peek( p ) = Fbx.KW_POINTER)
            Advance( p )
            dim as Fbx.StmtPayload up
            up.a = pn
            pn = MakeStmt( p, Fbx.N_TYPEREF, t.loc, up )
            p.ast->nodes[cast( long, pn )].flags or= Fbx.NF_PTR
        wend
        return pn
    end if

    dim as Fbx.TokenKind k = Peek( p )
    dim as boolean named = (k = Fbx.TK_IDENT) orelse Fbx.IsKeywordKind( k )
    if named = false then return ErrorNode( p, Fbx.FBX0406 )

    if k = Fbx.TK_IDENT then
        sp.name = cast( Fbx.InternId, Cur( p ).literal )
    else
        sp.name = p.names->GetString( Fbx.Text.LowerAscii( Fbx.TokenKindText( k ) ) )
    end if
    sp.op = cast( ushort, k )
    Advance( p )

    '' 'UNSIGNED <int type>' is a TWO-WORD type name, and it is the only one FreeBASIC
    '' has: measured, 'unsigned byte/short/long/integer/longint' give sizes 1/2/4/8/8,
    '' and 'SIGNED' is not a prefix at all -- fbc rejects 'as signed byte' outright.
    ''
    '' Without this the second word was simply left behind: 'dim as unsigned byte a'
    '' produced a TYPEREF of 'unsigned' and the declaration silently had the wrong type,
    '' which no diagnostic would ever mention.
    if k = Fbx.KW_UNSIGNED then
        dim as Fbx.TokenKind u = Peek( p )
        dim as Fbx.TokenKind mapped = cast( Fbx.TokenKind, 0 )
        select case u
        case Fbx.KW_BYTE    : mapped = Fbx.KW_UBYTE
        case Fbx.KW_SHORT   : mapped = Fbx.KW_USHORT
        case Fbx.KW_LONG    : mapped = Fbx.KW_ULONG
        case Fbx.KW_INTEGER : mapped = Fbx.KW_UINTEGER
        case Fbx.KW_LONGINT : mapped = Fbx.KW_ULONGINT
        end select
        if mapped <> cast( Fbx.TokenKind, 0 ) then
            Advance( p )
            sp.op = cast( ushort, mapped )
            sp.name = p.names->GetString( _
                Fbx.Text.LowerAscii( Fbx.TokenKindText( mapped ) ) )
        elseif u = Fbx.TK_IDENT then
            '' 'unsigned cxxlongint' -- UNSIGNED before a TYPEDEF rather than a builtin
            '' keyword. The name is carried here and 'op' is left as KW_UNSIGNED, which
            '' is what tells Resolve to take the unsigned counterpart of whatever the
            '' name turns out to be. No new node flag is needed: the two facts fit in
            '' the two fields already there.
            sp.name = cast( Fbx.InternId, Cur( p ).literal )
            Advance( p )
        end if
    end if

    '' Qualified names: ns.Type
    while Peek( p ) = Fbx.TK_DOT
        Advance( p )
        if (Peek( p ) = Fbx.TK_IDENT) orelse Fbx.IsKeywordKind( Peek( p ) ) then
            sp.name = cast( Fbx.InternId, Cur( p ).literal )
            Advance( p )
        else
            exit while
        end if
    wend

    '' Generic arguments: 'Box( of long )'.
    if Peek( p ) = Fbx.TK_LPAREN then
        dim as long save = p.pos
        Advance( p )
        dim as boolean isGeneric = false
        if Peek( p ) = Fbx.TK_IDENT then
            isGeneric = (p.names->Spelling( cast( Fbx.InternId, Cur( p ).literal ) ) = "of")
        end if
        if isGeneric then
            dim as long depth = 1
            while (depth > 0) andalso (AtEnd( p ) = false)
                if Peek( p ) = Fbx.TK_LPAREN then depth += 1
                if Peek( p ) = Fbx.TK_RPAREN then depth -= 1
                Advance( p )
            wend
        else
            p.pos = save
        end if
    end if

    '' A TYPE ALIAS: 'as byte alias "char"'.
    ''
    '' This is a C++ mangling control, not a rename. C++ has THREE distinct char types --
    '' char, signed char, unsigned char -- while FreeBASIC's BYTE and UBYTE map to the
    '' latter two, so there is no way to spell plain 'char' without it. The alias says
    '' which C++ type name to mangle against.
    ''
    '' Measured: fbc allows it on BYTE, UBYTE and UNSIGNED BYTE only, and rejects
    '' 'as long alias "int"' with a syntax error. That restriction is not applied here --
    '' the shape parses for any type and the diagnostic is owed from the checker, which
    '' does not emit it yet. Recorded rather than silently permitted.
    if Peek( p ) = Fbx.KW_ALIAS then
        dim as long saveAlias = p.pos
        Advance( p )
        if Peek( p ) = Fbx.TK_STRING_LIT then
            sp.b = Expression( p, Fbx.PREC_POSTFIX )
        else
            p.pos = saveAlias
        end if
    end if

    '' 'zstring * 32' and friends: a fixed length.
    if Peek( p ) = Fbx.TK_STAR then
        dim as long save = p.pos
        Advance( p )
        if (Peek( p ) = Fbx.TK_INT_LIT) orelse (Peek( p ) = Fbx.TK_IDENT) then
            sp.c = Expression( p, Fbx.PREC_MUL )
        else
            p.pos = save
        end if
    end if

    dim as Fbx.NodeId n = MakeStmt( p, Fbx.N_TYPEREF, t.loc, sp )
    p.ast->nodes[cast( long, n )].flags or= flags

    '' 'ptr' may repeat, and 'const' may appear between levels: 'const zstring ptr'.
    do
        if Peek( p ) = Fbx.KW_CONST then
            Advance( p )
            p.ast->nodes[cast( long, n )].flags or= Fbx.NF_CONST
            continue do
        end if
        dim as boolean isPtr = (Peek( p ) = Fbx.KW_PTR) orelse (Peek( p ) = Fbx.KW_POINTER)
        if isPtr = false then exit do
        Advance( p )
        dim as Fbx.StmtPayload up
        up.a = n
        n = MakeStmt( p, Fbx.N_TYPEREF, t.loc, up )
        p.ast->nodes[cast( long, n )].flags or= Fbx.NF_PTR
    loop

    return n
end function

'' ------------------------------------------------------------------- statements

private function ParseIf( byref p as Fbx.ParserState ) as Fbx.NodeId
    dim as Fbx.Token t = Cur( p )
    Advance( p )

    dim as Fbx.StmtPayload sp
    dim as Fbx.NodeIdVec branches

    dim as Fbx.StmtPayload first_
    first_.a = Expression( p )
    if Peek( p ) = Fbx.KW_THEN then Advance( p )

    '' 'if c then stmt' on one line is the same node with a flag, so semantics and
    '' lowering see one shape (docs/plan/04 section 4).
    dim as boolean singleLine = (Peek( p ) <> Fbx.TK_EOL) andalso (AtEnd( p ) = false)
    if singleLine then
        dim as Fbx.NodeIdVec one
        dim as Fbx.NodeId s = Statement( p )
        if s <> Fbx.NODE_NONE then one.Push( cast( ulong, s ) )
        first_.b = MakeList( p, Fbx.N_BLOCK, t.loc, Fbx.NODE_NONE, one )
        branches.Push( cast( ulong, MakeStmt( p, Fbx.N_IF_BRANCH, t.loc, first_ ) ) )
        '' 'if c then s : end if' terminates explicitly. ':' and a newline both lex
        '' as an EOL, so the token kinds cannot tell them apart -- only the LINE can:
        ''
        ''     if ( a mod b ) <> 0 then        <- a block IF
        ''         if negA <> negB then q -= 1 <- a single-line IF
        ''     end if                          <- belongs to the BLOCK if
        ''
        '' Taking that 'end if' because it merely came next left the block IF open,
        '' which then consumed the enclosing 'end function', which left a namespace
        '' unclosed hundreds of lines later. The 'end' is this IF's only if it is on
        '' this IF's own line.
        if (Peek( p ) = Fbx.KW_END) andalso HasTok( p, p.pos + 1 ) then
            if p.toks->At( p.pos + 1 ).kind = cast( ubyte, Fbx.KW_IF ) then
                if p.src->Decode( Cur( p ).loc ).lineNo = _
                   p.src->Decode( t.loc ).lineNo then
                    Advance( p )
                    Advance( p )
                end if
            end if
        end if

        dim as Fbx.NodeId n = MakeStmt( p, Fbx.N_IF, t.loc, sp )
        p.ast->nodes[cast( long, n )].flags or= Fbx.NF_SINGLE_LINE
        dim as Fbx.StmtPayload done_
        done_.b = MakeList( p, Fbx.N_BLOCK, t.loc, Fbx.NODE_NONE, branches )
        p.ast->stmts[cast( long, p.ast->nodes[cast( long, n )].data )] = done_
        return n
    end if

    first_.b = Block( p )
    branches.Push( cast( ulong, MakeStmt( p, Fbx.N_IF_BRANCH, t.loc, first_ ) ) )

    while Peek( p ) = Fbx.KW_ELSEIF
        dim as Fbx.Token et = Cur( p )
        Advance( p )
        dim as Fbx.StmtPayload br
        br.a = Expression( p )
        if Peek( p ) = Fbx.KW_THEN then Advance( p )
        br.b = Block( p )
        branches.Push( cast( ulong, MakeStmt( p, Fbx.N_IF_BRANCH, et.loc, br ) ) )
    wend

    if Accept( p, Fbx.KW_ELSE ) then sp.c = Block( p )

    sp.b = MakeList( p, Fbx.N_BLOCK, t.loc, Fbx.NODE_NONE, branches )
    ExpectEnd( p, Fbx.KW_IF )
    return MakeStmt( p, Fbx.N_IF, t.loc, sp )
end function

private function ParseSelect( byref p as Fbx.ParserState ) as Fbx.NodeId
    dim as Fbx.Token t = Cur( p )
    Advance( p )
    if Peek( p ) = Fbx.KW_CASE then Advance( p )
    if Peek( p ) = Fbx.KW_AS then
        Advance( p )                          '' 'select case as const'
        if Peek( p ) = Fbx.KW_CONST then Advance( p )
    end if

    dim as Fbx.StmtPayload sp
    sp.a = Expression( p )

    dim as Fbx.NodeIdVec cases
    do
        SkipEols( p )
        if Peek( p ) <> Fbx.KW_CASE then exit do
        dim as Fbx.Token ct = Cur( p )
        Advance( p )

        if Accept( p, Fbx.KW_ELSE ) then
            sp.c = Block( p )
            continue do
        end if

        dim as Fbx.StmtPayload cs
        dim as Fbx.NodeIdVec patterns
        do
            dim as Fbx.Token pt = Cur( p )
            dim as Fbx.StmtPayload pat
            if Accept( p, Fbx.KW_IS ) then
                pat.op = cast( ushort, Peek( p ) )
                Advance( p )
                pat.a = Expression( p )
                patterns.Push( cast( ulong, MakeStmt( p, Fbx.N_CASE_RANGE, pt.loc, pat ) ) )
            else
                pat.a = Expression( p )
                if Accept( p, Fbx.KW_TO ) then
                    pat.b = Expression( p )
                    patterns.Push( cast( ulong, MakeStmt( p, Fbx.N_CASE_RANGE, pt.loc, pat ) ) )
                else
                    patterns.Push( cast( ulong, pat.a ) )
                end if
            end if
            if Accept( p, Fbx.TK_COMMA ) = false then exit do
        loop

        cs.first = p.ast->children.Count
        cs.count = patterns.Count
        for i as long = 0 to patterns.Count - 1
            p.ast->children.Push( patterns[i] )
        next
        cs.b = Block( p )
        cases.Push( cast( ulong, MakeStmt( p, Fbx.N_CASE, ct.loc, cs ) ) )
    loop

    sp.b = MakeList( p, Fbx.N_BLOCK, t.loc, Fbx.NODE_NONE, cases )
    ExpectEnd( p, Fbx.KW_SELECT )
    return MakeStmt( p, Fbx.N_SELECT, t.loc, sp )
end function

private function ParseFor( byref p as Fbx.ParserState ) as Fbx.NodeId
    dim as Fbx.Token t = Cur( p )
    Advance( p )

    '' FOR EACH is FBC-Modern's; 'each' is CONTEXTUAL, so it arrives as an identifier
    '' and is recognised by spelling (probes V2).
    dim as boolean isEach = false
    if Peek( p ) = Fbx.TK_IDENT then
        dim as Fbx.InternId id = cast( Fbx.InternId, Cur( p ).literal )
        if p.names->Spelling( id ) = "each" then
            isEach = true
            Advance( p )
        end if
    end if

    dim as Fbx.StmtPayload sp
    if isEach then
        if Accept( p, Fbx.KW_BYREF ) then
            sp.op = cast( ushort, Fbx.KW_BYREF )
        end if
        sp.a = Expression( p, Fbx.PREC_POSTFIX )
        if Accept( p, Fbx.KW_AS ) then sp.c = TypeRef( p )
        '' 'in' is contextual too.
        if Peek( p ) = Fbx.TK_IDENT then
            dim as Fbx.InternId id = cast( Fbx.InternId, Cur( p ).literal )
            if p.names->Spelling( id ) = "in" then Advance( p )
        end if
        dim as Fbx.NodeId seq = Expression( p )
        sp.first = p.ast->children.Count
        sp.count = 1
        p.ast->children.Push( cast( ulong, seq ) )
        sp.b = Block( p )
        if Accept( p, Fbx.KW_NEXT ) then
            while (Peek( p ) <> Fbx.TK_EOL) andalso (AtEnd( p ) = false)
                Advance( p )
            wend
        end if
        return MakeStmt( p, Fbx.N_FOREACH, t.loc, sp )
    end if

    sp.a = Expression( p, Fbx.PREC_POSTFIX )
    if Accept( p, Fbx.KW_AS ) then sp.c = TypeRef( p )

    '' children are ALWAYS the three slots [from, to, step], NODE_NONE where absent.
    '' They used to be a packed list with the step in 'c', which silently overwrote
    '' the 'as T' TypeRef parsed above -- 'for i as integer' lost its type.
    dim as Fbx.NodeIdVec bounds
    dim as Fbx.NodeId fromExpr = Fbx.NODE_NONE
    dim as Fbx.NodeId toExpr = Fbx.NODE_NONE
    dim as Fbx.NodeId stepExpr = Fbx.NODE_NONE
    if Accept( p, Fbx.TK_EQ ) then fromExpr = Expression( p )
    if Accept( p, Fbx.KW_TO ) then toExpr = Expression( p )
    if Accept( p, Fbx.KW_STEP ) then stepExpr = Expression( p )

    sp.first = p.ast->children.Count
    sp.count = 3
    p.ast->children.Push( cast( ulong, fromExpr ) )
    p.ast->children.Push( cast( ulong, toExpr ) )
    p.ast->children.Push( cast( ulong, stepExpr ) )

    sp.b = Block( p )
    if Accept( p, Fbx.KW_NEXT ) then
        while (Peek( p ) <> Fbx.TK_EOL) andalso (AtEnd( p ) = false)
            Advance( p )
        wend
    end if

    return MakeStmt( p, Fbx.N_FOR, t.loc, sp )
end function

private function ParseDo( byref p as Fbx.ParserState ) as Fbx.NodeId
    dim as Fbx.Token t = Cur( p )
    Advance( p )

    dim as Fbx.StmtPayload sp
    dim as ushort flags = 0

    if Peek( p ) = Fbx.KW_WHILE then
        Advance( p )
        sp.a = Expression( p )
    elseif Peek( p ) = Fbx.KW_UNTIL then
        Advance( p )
        flags or= Fbx.NF_UNTIL
        sp.a = Expression( p )
    end if

    sp.b = Block( p )

    if Accept( p, Fbx.KW_LOOP ) then
        if Peek( p ) = Fbx.KW_WHILE then
            Advance( p )
            flags or= Fbx.NF_POST_COND
            sp.c = Expression( p )
        elseif Peek( p ) = Fbx.KW_UNTIL then
            Advance( p )
            flags or= Fbx.NF_POST_COND or Fbx.NF_UNTIL
            sp.c = Expression( p )
        end if
    else
        ErrorNode( p, Fbx.FBX0405, "loop" )
    end if

    dim as Fbx.NodeId n = MakeStmt( p, Fbx.N_DO, t.loc, sp )
    p.ast->nodes[cast( long, n )].flags or= flags
    return n
end function

private function ParseWhile( byref p as Fbx.ParserState ) as Fbx.NodeId
    dim as Fbx.Token t = Cur( p )
    Advance( p )
    dim as Fbx.StmtPayload sp
    sp.a = Expression( p )
    sp.b = Block( p )
    if Accept( p, Fbx.KW_WEND ) = false then ExpectEnd( p, Fbx.KW_WHILE )
    return MakeStmt( p, Fbx.N_WHILE, t.loc, sp )
end function

private function ParseWith( byref p as Fbx.ParserState ) as Fbx.NodeId
    dim as Fbx.Token t = Cur( p )
    Advance( p )
    dim as Fbx.StmtPayload sp
    sp.a = Expression( p )
    sp.b = Block( p )
    ExpectEnd( p, Fbx.KW_WITH )
    return MakeStmt( p, Fbx.N_WITH, t.loc, sp )
end function

private function ParseScope( byref p as Fbx.ParserState ) as Fbx.NodeId
    dim as Fbx.Token t = Cur( p )
    Advance( p )
    dim as Fbx.StmtPayload sp
    sp.b = Block( p )
    ExpectEnd( p, Fbx.KW_SCOPE )
    return MakeStmt( p, Fbx.N_SCOPE, t.loc, sp )
end function

private function ParseExitLike _
    ( byref p as Fbx.ParserState, byval kind as Fbx.NodeKind ) as Fbx.NodeId

    dim as Fbx.Token t = Cur( p )
    Advance( p )
    dim as Fbx.StmtPayload sp
    sp.extra = 0
    '' 'exit for, for' names the target repeatedly; count how deep it goes.
    do
        dim as Fbx.TokenKind k = Peek( p )
        dim as boolean target = (k = Fbx.KW_FOR) orelse (k = Fbx.KW_DO) orelse _
                                (k = Fbx.KW_WHILE) orelse (k = Fbx.KW_SELECT) orelse _
                                (k = Fbx.KW_SUB) orelse (k = Fbx.KW_FUNCTION) orelse _
                                (k = Fbx.KW_SCOPE) orelse (k = Fbx.KW_PROPERTY) orelse _
                                (k = Fbx.KW_CONSTRUCTOR) orelse (k = Fbx.KW_DESTRUCTOR) orelse _
                                (k = Fbx.KW_OPERATOR) orelse (k = Fbx.KW_ANY)
        if target = false then exit do
        if sp.op = 0 then sp.op = cast( ushort, k )
        sp.extra += 1
        Advance( p )
        if Accept( p, Fbx.TK_COMMA ) = false then exit do
    loop
    return MakeStmt( p, kind, t.loc, sp )
end function

'' A KEYWORD directly followed by '(' is an expression, not a statement -- 'cast(...)',
'' 'mid(...)', 'cuint(...)', 'strptr(...)'. It is safe to say so this late in the
'' dispatch: every keyword that BEGINS a statement has already been matched by the
'' cases above, by IsDeclarationStart, or by IsStatementIntrinsic, which deliberately
'' excludes the IFORM_EXPR family for exactly this reason -- 'x = len(s)' must not
'' parse as a LEN statement.
''
'' Testing the '(' rather than enumerating the keywords is what makes this cover the
'' whole conversion family without a list that would go stale.
private function KeywordLedExpression _
    ( byref p as Fbx.ParserState, byval k as Fbx.TokenKind ) as boolean

    if Fbx.IsKeywordKind( k ) = false then return false
    if HasTok( p, p.pos + 1 ) = false then return false
    return (cast( Fbx.TokenKind, p.toks->At( p.pos + 1 ).kind ) = Fbx.TK_LPAREN)
end function

'' 'function =' / 'operator =' / 'property =', and nothing else that starts with one
'' of those keywords. The cross-kind rules fbc enforces -- 'function =' is a syntax
'' error inside a SUB -- are deliberately NOT checked here: accepting a little more
'' than fbc never loses a file, and rejecting a little more would.
private function IsResultAssign _
    ( byref p as Fbx.ParserState, byval k as Fbx.TokenKind ) as boolean

    dim as boolean isResultKw = (k = Fbx.KW_FUNCTION) orelse _
                                (k = Fbx.KW_OPERATOR) orelse (k = Fbx.KW_PROPERTY)
    if isResultKw = false then return false
    if HasTok( p, p.pos + 1 ) = false then return false
    return (cast( Fbx.TokenKind, p.toks->At( p.pos + 1 ).kind ) = Fbx.TK_EQ)
end function

'' The three-way ambiguity of docs/plan/04 section 6: a leading expression is a call,
'' an assignment, or a paren-less call with arguments. The parser does not decide.
private function ParseAmbiguous( byref p as Fbx.ParserState ) as Fbx.NodeId
    dim as Fbx.Token t = Cur( p )
    dim as Fbx.StmtPayload sp
    sp.a = Expression( p, Fbx.PREC_POSTFIX )

    dim as Fbx.TokenKind k = Peek( p )
    dim as boolean isAssign = (k = Fbx.TK_EQ) orelse (k = Fbx.TK_PLUSEQ) orelse _
                              (k = Fbx.TK_MINUSEQ) orelse (k = Fbx.TK_STAREQ) orelse _
                              (k = Fbx.TK_SLASHEQ) orelse (k = Fbx.TK_BSLASHEQ) orelse _
                              (k = Fbx.TK_CARETEQ) orelse (k = Fbx.TK_AMPEQ)
    if isAssign then
        sp.op = cast( ushort, k )
        Advance( p )
        sp.b = Expression( p )
        return MakeStmt( p, Fbx.N_AMBIGUOUS, t.loc, sp )
    end if

    '' Anything else on the line is a paren-less argument list.
    dim as Fbx.NodeIdVec args
    dim as boolean more = (Peek( p ) <> Fbx.TK_EOL) andalso (AtEnd( p ) = false)
    if more then
        do
            args.Push( cast( ulong, Expression( p ) ) )
            if Accept( p, Fbx.TK_COMMA ) = false then exit do
        loop
    end if
    sp.first = p.ast->children.Count
    sp.count = args.Count
    for i as long = 0 to args.Count - 1
        p.ast->children.Push( args[i] )
    next

    return MakeStmt( p, Fbx.N_AMBIGUOUS, t.loc, sp )
end function

end namespace

#include once "parser/decl.bas"
#include once "parser/intrinsics.bas"

namespace Fbx.Parse

'' True when the identifier at the cursor is the given contextual word. FBC-Modern's
'' additions -- defer, each, in, of, spawn -- are NOT reserved, so they can only be
'' recognised by spelling and only where the grammar expects them.
private function IsContextual _
    ( byref p as Fbx.ParserState, byref word as string ) as boolean

    if Peek( p ) <> Fbx.TK_IDENT then return false
    dim as Fbx.InternId nm = cast( Fbx.InternId, Cur( p ).literal )
    return p.names->Spelling( nm ) = word
end function

function Statement( byref p as Fbx.ParserState ) as Fbx.NodeId
    SkipEols( p )
    if AtEnd( p ) then return Fbx.NODE_NONE

    p.silent = false
    dim as Fbx.Token t = Cur( p )
    dim as Fbx.TokenKind k = Peek( p )
    dim as Fbx.NodeId n = Fbx.NODE_NONE
    dim as boolean consumesLine = true

    select case k
    case Fbx.KW_IF
        n = ParseIf( p )
        '' A single-line IF's inner statement already ran EndOfStatement and so ate
        '' the line's EOL. Running it again here would skip forward to the NEXT EOL
        '' and swallow whatever followed -- an 'end sub' or a 'wend' -- whole. It
        '' only showed up when the IF was the LAST statement of a block, because
        '' otherwise the token it ate was an ordinary statement that reparsed fine.
        if (n <> Fbx.NODE_NONE) andalso _
           ((p.ast->nodes[cast( long, n )].flags and Fbx.NF_SINGLE_LINE) <> 0) then
            consumesLine = false
        end if
    case Fbx.KW_SELECT    : n = ParseSelect( p )
    case Fbx.KW_FOR       : n = ParseFor( p )
    case Fbx.KW_DO        : n = ParseDo( p )
    case Fbx.KW_WHILE     : n = ParseWhile( p )
    case Fbx.KW_WITH      : n = ParseWith( p )
    case Fbx.KW_SCOPE     : n = ParseScope( p )
    case Fbx.KW_EXIT      : n = ParseExitLike( p, Fbx.N_EXIT )
    case Fbx.KW_CONTINUE  : n = ParseExitLike( p, Fbx.N_CONTINUE )

    case Fbx.KW_RETURN
        Advance( p )
        dim as Fbx.StmtPayload sp
        dim as boolean hasValue = (Peek( p ) <> Fbx.TK_EOL) andalso (AtEnd( p ) = false)
        if hasValue then sp.a = Expression( p )
        n = MakeStmt( p, Fbx.N_RETURN, t.loc, sp )

    case Fbx.KW_GOTO
        Advance( p )
        dim as Fbx.StmtPayload sp
        if (Peek( p ) = Fbx.TK_IDENT) orelse (Peek( p ) = Fbx.TK_INT_LIT) then
            sp.name = cast( Fbx.InternId, Cur( p ).literal )
            Advance( p )
        end if
        n = MakeStmt( p, Fbx.N_GOTO, t.loc, sp )

    case Fbx.KW_DELETE
        '' DELETE is classed as an OPERATOR in the keyword table, so it never reached
        '' the statement dispatch -- 54 corpus errors from one missing case.
        Advance( p )
        dim as Fbx.StmtPayload sp
        if Accept( p, Fbx.TK_LBRACKET ) then
            Expect( p, Fbx.TK_RBRACKET, "]" )
            sp.extra = 1
        end if
        sp.a = Expression( p )
        n = MakeStmt( p, Fbx.N_DELETE_STMT, t.loc, sp )

    case Fbx.TK_HASH
        '' '#assert' is passed through by the preprocessor because its expression is a
        '' COMPILE-TIME one that can name types ('#assert typeof( a ) = typeof( b )'),
        '' so it belongs to the parser, not the PP. See probe P2.
        dim as long save = p.pos
        Advance( p )
        dim as boolean isAssert = false
        if Peek( p ) = Fbx.TK_IDENT then
            isAssert = (p.names->Spelling( cast( Fbx.InternId, Cur( p ).literal ) ) = "assert")
        end if
        if isAssert then
            Advance( p )
            dim as Fbx.StmtPayload sp
            sp.a = Expression( p )
            n = MakeStmt( p, Fbx.N_ASSERT, t.loc, sp )
        else
            p.pos = save
            n = ErrorNode( p, Fbx.FBX0408 )
            Sync( p )
            return n
        end if

    case Fbx.KW_ASM
        '' Parsed only so it can be rejected with a real diagnostic rather than
        '' miscompiled (docs/plan/01 section 5.6).
        Advance( p )
        dim as Fbx.StmtPayload sp
        n = MakeStmt( p, Fbx.N_ASM, t.loc, sp )
        ErrorNode( p, Fbx.FBX0407 )
        while (Peek( p ) <> Fbx.KW_END) andalso (AtEnd( p ) = false)
            Advance( p )
        wend
        ExpectEnd( p, Fbx.KW_ASM )

    case else
        '' 'function = expr' -- BASIC's result assignment written with the KEYWORD
        '' rather than the procedure's name. It has to be tested before the
        '' declaration dispatch, which would otherwise read FUNCTION as the start of
        '' a nested procedure and consume the enclosing 'end function' looking for a
        '' body. That is why 158 corpus files reported 'expected end FUNCTION' at EOF.
        ''
        '' The '=' is the whole disambiguator, and it is enough: at module level
        '' 'operator = ( ... )' is a global operator DEFINITION, but that spelling has
        '' a '(' after the '=' rather than an expression -- and a definition cannot
        '' appear where a statement is being parsed inside a body.
        ''
        '' Measured against fbc: assignment only. 'function += 1' is error 61 and
        '' 'print function' is error 6, so the keyword is a WRITE-ONLY target.
        if IsResultAssign( p, k ) then
            dim as Fbx.StmtPayload sp
            sp.a = NewNodeAt( p, Fbx.N_FUNCRESULT, t.loc, 0 )
            Advance( p )                       '' the keyword
            sp.op = cast( ushort, Fbx.TK_EQ )
            Advance( p )                       '' the '='
            sp.b = Expression( p )
            n = MakeStmt( p, Fbx.N_AMBIGUOUS, t.loc, sp )
        elseif IsDeclarationStart( k ) then
            n = Declaration( p )
        elseif Fbx.IsStatementIntrinsic( k ) then
            n = ParseIntrinsic( p )
        elseif (k = Fbx.TK_IDENT) andalso IsContextual( p, "defer" ) then
            '' 'defer' is CONTEXTUAL in FBC-Modern -- not reserved, so it arrives as
            '' an identifier and is recognised by spelling, exactly as 'each' and
            '' 'in' are. Without this it parsed as a CALL to something named defer.
            dim as Fbx.Token dt = Cur( p )
            Advance( p )
            dim as Fbx.StmtPayload sp
            sp.b = Statement( p )
            n = MakeStmt( p, Fbx.N_DEFER, dt.loc, sp )
            consumesLine = false
        elseif k = Fbx.TK_IDENT then
            '' 'name:' is a label; anything else is the call-or-assign ambiguity.
            ''
            '' The test is the COLON FLAG, not the token's length. Both ':' and a
            '' newline are TK_EOL, and a length of 1 matches a bare LF as well as a
            '' colon -- so on an LF file every parenthesis-less zero-argument call,
            '' 'Bar' on a line of its own, was parsed as a LABEL named bar. It only
            '' looked correct on CRLF input, where the newline is two bytes.
            dim as boolean isLabel = false
            if HasTok( p, p.pos + 1 ) then
                isLabel = (cast( Fbx.TokenKind, p.toks->At( p.pos + 1 ).kind ) = Fbx.TK_EOL) andalso _
                          ((p.toks->At( p.pos + 1 ).flags and Fbx.TF_COLON) <> 0)
            end if
            if isLabel then
                dim as Fbx.StmtPayload sp
                sp.name = cast( Fbx.InternId, t.literal )
                Advance( p )
                Advance( p )
                n = MakeStmt( p, Fbx.N_LABEL, t.loc, sp )
                consumesLine = false
            else
                n = ParseAmbiguous( p )
            end if
        elseif k = Fbx.TK_DOT then
            '' '.field = 1' inside a WITH. It is the same call-or-assign ambiguity as
            '' a bare name, just with the base left to the enclosing WITH.
            n = ParseAmbiguous( p )
        elseif k = Fbx.TK_LPAREN then
            '' A PARENTHESISED assignment target: '(a) = 5', '(*p) = 5', '(arr(1)) = 5'.
            '' The parentheses are permitted around an lvalue and change nothing, so the
            '' statement is the same call-or-assign ambiguity as a bare name.
            n = ParseAmbiguous( p )
        elseif k = Fbx.KW_LET then
            '' 'let (a, b) = f( )' -- the multiple assignment. Measured: in the fb
            '' dialect ONLY the parenthesised form exists; plain 'let a = 5' is fbc
            '' error 146, valid in deprecated/fblite/qb alone. The keyword is consumed
            '' and what follows is the ordinary call-or-assign ambiguity, so the target
            '' being a tuple needs nothing special here.
            Advance( p )
            n = ParseAmbiguous( p )
        elseif KeywordLedExpression( p, k ) then
            '' A statement whose head is a KEYWORD-led expression rather than a name:
            ''
            ''     cast( U, x ).i = 5        mid( s, 1, 1 ) = "H"
            ''     cptr( short ptr, p ) += 1  cuint( g( ) )        strptr( s ) = 0
            ''
            '' fbc parses all of these; two of them it then REJECTS -- 'strptr(s) = 0'
            '' is error 119 and a literal on the left is error 24 -- but it rejects
            '' them in the semantic pass, having parsed the statement. fbx died in the
            '' parser, so those files failed for the wrong reason and their goldens
            '' could never match.
            n = ParseAmbiguous( p )
        elseif (k = Fbx.TK_INT_LIT) orelse (k = Fbx.TK_FLOAT_LIT) orelse _
               (k = Fbx.TK_STRING_LIT) then
            '' '0 = 1' and '"" = "a"'. fbc parses these and rejects them semantically,
            '' and the corpus tests exactly that. Accepting the parse is what lets the
            '' rejection happen in the right pass.
            n = ParseAmbiguous( p )
        elseif k = Fbx.KW_END then
            '' 'END [exitcode]' TERMINATES THE PROGRAM. Reaching here at all means
            '' IsBlockEnderAt already decided this END does not close a block.
            Advance( p )
            dim as Fbx.StmtPayload ep
            if (Peek( p ) <> Fbx.TK_EOL) andalso (AtEnd( p ) = false) then
                ep.a = Expression( p )
            end if
            n = MakeStmt( p, Fbx.N_END_STMT, t.loc, ep )
        elseif k = Fbx.KW_BASE then
            '' 'base.vs( )' -- a call on the BASE-class receiver. Like '.field' inside a
            '' WITH, the base is implicit and what follows is an ordinary member
            '' expression, so it is the same call-or-assign ambiguity.
            n = ParseAmbiguous( p )
        elseif k = Fbx.TK_STAR then
            '' Assignment THROUGH A POINTER: '*p = 5', '**pp = 5'. A statement may begin
            '' with the dereference operator, and the target is an ordinary lvalue
            '' expression from there -- the same call-or-assign ambiguity again.
            n = ParseAmbiguous( p )
        elseif k = Fbx.TK_QUESTION then
            n = ParseIntrinsic( p )       '' '?' is PRINT
        else
            n = ErrorNode( p, Fbx.FBX0408 )
            Sync( p )
            return n
        end if
    end select

    if consumesLine then EndOfStatement( p )
    return n
end function

function Unit( byref p as Fbx.ParserState ) as Fbx.NodeId
    dim as Fbx.Token t = Cur( p )
    dim as Fbx.NodeIdVec items
    do
        SkipEols( p )
        if AtEnd( p ) then exit do
        dim as long before = p.pos
        dim as Fbx.NodeId s = Statement( p )
        if s <> Fbx.NODE_NONE then items.Push( cast( ulong, s ) )
        if p.pos = before then Advance( p )        '' guaranteed progress
    loop
    return MakeList( p, Fbx.N_MODULE, t.loc, Fbx.NODE_NONE, items )
end function

end namespace

namespace Fbx.Parse

'' ----------------------------------------------------------------------- dump

private sub DumpAny _
    ( byref ast as Fbx.AstArena, byref src as Fbx.SourceManager, _
      byref names as Fbx.Interner, byval id as Fbx.NodeId, byval indent as long, _
      byref outp as string )

    if id = Fbx.NODE_NONE then return
    if cast( long, id ) >= ast.nodes.Count then return

    dim as Fbx.AstNode ptr n = @ast.nodes[cast( long, id )]
    dim as Fbx.NodeKind k = cast( Fbx.NodeKind, n->kind )
    dim as Fbx.NodeCategory cat = Fbx.NodeKindCategory( k )

    '' Expressions already have a printer; reuse it so one shape is printed one way.
    if (cat = Fbx.NCAT_EXPR) andalso (k <> Fbx.N_ERROR) then
        dim as string sub_ = Dump( ast, src, names, id )
        dim as long start = 1
        while start <= len( sub_ )
            dim as long nl = instr( start, sub_, chr( 10 ) )
            if nl = 0 then exit while
            outp += space( indent * 2 ) & mid( sub_, start, nl - start ) & chr( 10 )
            start = nl + 1
        wend
        return
    end if

    dim as Fbx.DecodedLoc d = src.Decode( n->loc )
    dim as string row = space( indent * 2 ) & Fbx.NodeKindName( k )

    dim as boolean hasStmt = (cat = Fbx.NCAT_STMT) orelse (cat = Fbx.NCAT_TYPE) orelse _
                             (cat = Fbx.NCAT_DECL)
    dim as boolean isList = (k = Fbx.N_BLOCK) orelse (k = Fbx.N_MODULE)

    if isList then
        dim as Fbx.ListPayload ptr lp = @ast.lists[cast( long, n->data )]
        row += " (" & lp->count & ")"
        outp += row & " <" & d.lineNo & ":" & d.column & ">" & chr( 10 )
        for i as long = 0 to lp->count - 1
            DumpAny( ast, src, names, cast( Fbx.NodeId, ast.children[lp->first + i] ), _
                     indent + 1, outp )
        next
        return
    end if

    if hasStmt = false then
        outp += row & " <" & d.lineNo & ":" & d.column & ">" & chr( 10 )
        return
    end if

    dim as Fbx.StmtPayload ptr sp = @ast.stmts[cast( long, n->data )]
    if sp->name <> Fbx.INTERN_NONE then row += " '" & names.Spelling( sp->name ) & "'"
    if sp->op <> 0 then
        dim as string ot = Fbx.TokenKindText( cast( Fbx.TokenKind, sp->op ) )
        if len( ot ) > 0 then row += " [" & ot & "]"
    end if
    if (n->flags and Fbx.NF_BYREF) <> 0 then row += " byref"
    if (n->flags and Fbx.NF_PTR) <> 0 then row += " ptr"
    if (n->flags and Fbx.NF_ARRAY) <> 0 then row += " array"
    if (n->flags and Fbx.NF_SHARED) <> 0 then row += " shared"
    if (n->flags and Fbx.NF_STATIC) <> 0 then row += " static"
    if (n->flags and Fbx.NF_UNTIL) <> 0 then row += " until"
    if (n->flags and Fbx.NF_POST_COND) <> 0 then row += " post"
    if (n->flags and Fbx.NF_IS_UNION) <> 0 then row += " union"
    if (n->flags and Fbx.NF_SINGLE_LINE) <> 0 then row += " single-line"

    '' Member visibility lives in 'extra', not in the node flags, so it needs its own
    '' line here -- and without one a 'private:' label is invisible in the dump, which
    '' is exactly how a parsed-but-discarded label would look.
    if (n->kind = Fbx.N_FIELD) orelse (n->kind = Fbx.N_PROC) then
        if (sp->extra and Fbx.PF_MEMB_PRIVATE) <> 0 then row += " private"
        if (sp->extra and Fbx.PF_MEMB_PROTECTED) <> 0 then row += " protected"
    end if
    '' EXPLICIT is invisible in the dump otherwise, and an unparsed EXPLICIT looked
    '' exactly like a parsed one -- as an extra member nobody wrote.
    if (n->kind = Fbx.N_ENUM) andalso (sp->extra <> 0) then row += " explicit"
    outp += row & " <" & d.lineNo & ":" & d.column & ">" & chr( 10 )

    DumpAny( ast, src, names, sp->a, indent + 1, outp )
    DumpAny( ast, src, names, sp->b, indent + 1, outp )
    DumpAny( ast, src, names, sp->c, indent + 1, outp )
    for i as long = 0 to sp->count - 1
        DumpAny( ast, src, names, cast( Fbx.NodeId, ast.children[sp->first + i] ), _
                 indent + 1, outp )
    next
end sub

function DumpTree _
    ( byref ast as Fbx.AstArena, byref src as Fbx.SourceManager, _
      byref names as Fbx.Interner, byval root as Fbx.NodeId ) as string

    dim as string outp = ""
    DumpAny( ast, src, names, root, 0, outp )
    return outp
end function

end namespace
