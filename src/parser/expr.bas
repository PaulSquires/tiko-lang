'' expr.bas -- see expr.bi.  Also carries the AST arena and its dump.

#include once "parser/expr.bi"
#include once "support/text.bi"
#include once "pp/pp.bi"

namespace Tko

'' ---------------------------------------------------------------- node metadata

dim shared as zstring ptr nodeNames( 0 to N_KIND_COUNT - 1 )
dim shared as ubyte       nodeCats( 0 to N_KIND_COUNT - 1 )
dim shared as boolean     nodeTablesReady = false

private sub InitNodeTables( )
    if nodeTablesReady then return
    for i as long = 0 to N_KIND_COUNT - 1
        nodeNames(i) = @"?"
        nodeCats(i) = 0
    next
    #macro NODE( n_name, n_cat )
        nodeNames(n_name) = @#n_name
        nodeCats(n_name) = cast( ubyte, n_cat )
    #endmacro
    TKO_NODE_LIST( NODE )
    #undef NODE
    nodeTablesReady = true
end sub

function CallConvOf( byval procFlags as ushort ) as CallConv
    if (procFlags and PF_CDECL) <> 0 then return CC_CDECL
    if (procFlags and PF_STDCALL) <> 0 then return CC_STDCALL
    if (procFlags and PF_PASCAL) <> 0 then return CC_PASCAL
    return CC_NONE
end function

function CallConvName( byval c as CallConv ) as string
    select case c
    case CC_CDECL   : return "cdecl"
    case CC_STDCALL : return "stdcall"
    case CC_PASCAL  : return "pascal"
    end select
    return ""
end function

function NodeKindName( byval k as NodeKind ) as string
    InitNodeTables( )
    dim as boolean bad = (k < 0) orelse (k >= N_KIND_COUNT)
    if bad then return "?"
    return *nodeNames(k)
end function

function NodeKindCategory( byval k as NodeKind ) as NodeCategory
    InitNodeTables( )
    dim as boolean bad = (k < 0) orelse (k >= N_KIND_COUNT)
    if bad then return NCAT_EXPR
    return cast( NodeCategory, nodeCats(k) )
end function

'' -------------------------------------------------------------------- the arena

constructor AstArena( )
    '' Index 0 is a permanent sentinel so NodeId 0 can mean "none".
    dim as AstNode z
    z.kind = cast( ushort, N_NONE )
    z.flags = 0
    z.loc = LOC_NONE
    z.data = 0
    this.nodes.Push( z )
end constructor

function AstArena.Kind( byval id as NodeId ) as NodeKind
    if id = NODE_NONE then return N_NONE
    if cast( long, id ) >= this.nodes.Count then return N_NONE
    return cast( NodeKind, this.nodes[cast( long, id )].kind )
end function

function AstArena.Loc( byval id as NodeId ) as SourceLoc
    if id = NODE_NONE then return LOC_NONE
    if cast( long, id ) >= this.nodes.Count then return LOC_NONE
    return this.nodes[cast( long, id )].loc
end function

function AstArena.Count( ) as long
    return this.nodes.Count - 1
end function

sub AstArena.RecordTokens _
    ( byval id as NodeId, byval firstTok as long, byval lastTok as long )
    if id = NODE_NONE then return
    if lastTok < firstTok then return
    this.tokenRanges.Push( cast( ulong, id ) )
    this.tokenRanges.Push( cast( ulong, firstTok ) )
    this.tokenRanges.Push( cast( ulong, lastTok ) )
end sub

'' Scanned BACKWARDS, so a node recorded twice reads as its most recent range. That
'' does not happen today; it is the safe direction if it ever does.
sub AstArena.RecordCallTypeArgs _
    ( byval id as NodeId, byval firstArg as long, byval argCount as long )
    if id = NODE_NONE then return
    if argCount <= 0 then return
    this.callTypeArgs.Push( cast( ulong, id ) )
    this.callTypeArgs.Push( cast( ulong, firstArg ) )
    this.callTypeArgs.Push( cast( ulong, argCount ) )
end sub

function AstArena.CallTypeArgsOf _
    ( byval id as NodeId, byref firstArg as long, byref argCount as long ) as boolean
    if id = NODE_NONE then return false
    for i as long = this.callTypeArgs.Count - 3 to 0 step -3
        if cast( NodeId, this.callTypeArgs[i] ) = id then
            firstArg = cast( long, this.callTypeArgs[i + 1] )
            argCount = cast( long, this.callTypeArgs[i + 2] )
            return true
        end if
    next
    return false
end function

function AstArena.TokensOf _
    ( byval id as NodeId, byref firstTok as long, byref lastTok as long ) as boolean
    if id = NODE_NONE then return false
    for i as long = this.tokenRanges.Count - 3 to 0 step -3
        if cast( NodeId, this.tokenRanges[i] ) = id then
            firstTok = cast( long, this.tokenRanges[i + 1] )
            lastTok = cast( long, this.tokenRanges[i + 2] )
            return true
        end if
    next
    return false
end function

private function NewNode _
    ( byref a as AstArena, byval kind as NodeKind, byval loc as SourceLoc, _
      byval payload as ulong ) as NodeId

    dim as AstNode n
    n.kind = cast( ushort, kind )
    n.flags = 0
    n.loc = loc
    n.data = payload
    a.nodes.Push( n )
    return cast( NodeId, a.nodes.Count - 1 )
end function

'' --------------------------------------------------------------- infix lookup

dim shared as ubyte   infixPrecTb( 0 to TK_KIND_COUNT - 1 )
dim shared as boolean infixReady = false

function InfixPrec( byval k as TokenKind ) as long
    if infixReady = false then
        for i as long = 0 to TK_KIND_COUNT - 1
            infixPrecTb(i) = 0
        next
        #macro BINOP( b_kind, b_prec )
            infixPrecTb(b_kind) = cast( ubyte, b_prec )
        #endmacro
        TKO_BINOP_LIST( BINOP )
        #undef BINOP
        infixReady = true
    end if
    dim as boolean bad = (k < 0) orelse (k >= TK_KIND_COUNT)
    if bad then return 0
    return infixPrecTb(k)
end function

end namespace

namespace Tko.Parse

'' -------------------------------------------------------------- token helpers

function HasTok( byref p as Tko.ParserState, byval want as long ) as boolean
    if want < 0 then return false
    if p.stream <> 0 then
        return Tko.PpEnsure( *cast( Tko.PpStream ptr, p.stream ), want )
    end if
    return (want < p.toks->Count)
end function

function Peek( byref p as Tko.ParserState ) as Tko.TokenKind
    if HasTok( p, p.pos ) = false then return Tko.TK_EOF
    return cast( Tko.TokenKind, p.toks->At( p.pos ).kind )
end function

function Cur( byref p as Tko.ParserState ) as Tko.Token
    dim as Tko.Token t
    if HasTok( p, p.pos ) then t = p.toks->At( p.pos )
    return t
end function

sub Advance( byref p as Tko.ParserState )
    if HasTok( p, p.pos ) then p.pos += 1
end sub

function Accept( byref p as Tko.ParserState, byval k as Tko.TokenKind ) as boolean
    if Peek( p ) <> k then return false
    Advance( p )
    return true
end function

function ErrorNode _
    ( byref p as Tko.ParserState, byval id as Tko.DiagId, byval a0 as string = "" ) as Tko.NodeId

    dim as Tko.Token t = Cur( p )
    '' One diagnostic per statement: the rest of a broken expression is noise
    '' (docs/plan/04 section 8).
    if p.silent = false then
        dim as Tko.SourceRange r
        r.first = t.loc
        r.last = t.loc
        p.diags->Report( id, r, a0 )
        p.silent = true
    end if
    p.errors += 1
    return Tko.NewNode( *p.ast, Tko.N_ERROR, t.loc, 0 )
end function

function Expect _
    ( byref p as Tko.ParserState, byval k as Tko.TokenKind, byval what as string ) as boolean

    if Accept( p, k ) then return true
    ErrorNode( p, Tko.TKO0401, what )
    return false
end function

'' ------------------------------------------------------------------- builders

private function MakeLiteral _
    ( byref p as Tko.ParserState, byref t as Tko.Token, byval kind as Tko.NodeKind, _
      byref pool as Tko.LiteralVec ) as Tko.NodeId

    dim as Tko.LiteralPayload lp
    if cast( long, t.literal ) < pool.Count then
        dim as Tko.Literal ptr src = @pool[cast( long, t.literal )]
        lp.intValue = src->intValue
        lp.fltValue = src->fltValue
        lp.strFile = src->textFile
        lp.strOffset = src->textOffset
        lp.strLength = src->textLength
        lp.strKind = src->strKind
        lp.suffix = src->suffix
        lp.radix = src->radix
    end if
    p.ast->literals.Push( lp )
    return Tko.NewNode( *p.ast, kind, t.loc, p.ast->literals.Count - 1 )
end function

'' One token as the node it IS -- a literal for a literal, an identifier otherwise.
''
'' DATA's items were built with MakeIdent unconditionally, and MakeIdent reads
'' 't.literal' as an INTERN ID. On a literal token that field is an index into the
'' LITERAL POOL, so 'data 1, "two", three' dumped as N_IDENT 'cushort', N_IDENT
'' 'cva_arg' -- whichever keywords happened to sit at those interner slots. It was
'' invisible because nothing lowers DATA yet, and it shifted the moment an unrelated
'' change altered how many literals the preprocessor interns first.
function MakeTokenNode _
    ( byref p as Tko.ParserState, byref t as Tko.Token ) as Tko.NodeId

    select case cast( Tko.TokenKind, t.kind )
    case Tko.TK_INT_LIT    : return MakeLiteral( p, t, Tko.N_INT_LIT, *p.litPool )
    case Tko.TK_FLOAT_LIT  : return MakeLiteral( p, t, Tko.N_FLOAT_LIT, *p.litPool )
    case Tko.TK_STRING_LIT : return MakeLiteral( p, t, Tko.N_STRING_LIT, *p.litPool )
    end select
    return MakeIdent( p, t )
end function

function MakeIdent( byref p as Tko.ParserState, byref t as Tko.Token ) as Tko.NodeId
    dim as Tko.IdentPayload ip
    ip.name = cast( Tko.InternId, t.literal )
    '' A KEYWORD token carries no interned spelling in 'literal', so an identifier
    '' built from one -- 'abs( x )', 'len( s )', a member called '.type' -- had an
    '' EMPTY name. It showed in the AST dump as N_IDENT '' and made every such callee
    '' unrecognisable to anything that matches on the name.
    if Tko.IsKeywordKind( cast( Tko.TokenKind, t.kind ) ) then
        ip.name = p.names->GetString( _
            Tko.Text.LowerAscii( Tko.TokenKindText( cast( Tko.TokenKind, t.kind ) ) ) )
    end if
    dim as Tko.DecodedLoc d = p.src->Decode( t.loc )
    ip.spellOffset = d.offset
    ip.spellLength = cast( long, t.length )
    p.ast->idents.Push( ip )
    return Tko.NewNode( *p.ast, Tko.N_IDENT, t.loc, p.ast->idents.Count - 1 )
end function

private function MakeUnary _
    ( byref p as Tko.ParserState, byval op as Tko.TokenKind, byval loc as Tko.SourceLoc, _
      byval operand as Tko.NodeId, byval kind as Tko.NodeKind = Tko.N_UNARY ) as Tko.NodeId

    dim as Tko.UnaryPayload up
    up.op = cast( ushort, op )
    up.operand = operand
    p.ast->unaries.Push( up )
    return Tko.NewNode( *p.ast, kind, loc, p.ast->unaries.Count - 1 )
end function

private function MakeBinary _
    ( byref p as Tko.ParserState, byval op as Tko.TokenKind, byval loc as Tko.SourceLoc, _
      byval lhs as Tko.NodeId, byval rhs as Tko.NodeId ) as Tko.NodeId

    dim as Tko.BinaryPayload bp
    bp.op = cast( ushort, op )
    bp.lhs = lhs
    bp.rhs = rhs
    p.ast->binaries.Push( bp )
    return Tko.NewNode( *p.ast, Tko.N_BINARY, loc, p.ast->binaries.Count - 1 )
end function

'' Children are appended to the shared pool, so a list node allocates nothing of
'' its own (docs/plan/05 section 1).
function MakeList _
    ( byref p as Tko.ParserState, byval kind as Tko.NodeKind, byval loc as Tko.SourceLoc, _
      byval target as Tko.NodeId, byref items as Tko.NodeIdVec ) as Tko.NodeId

    dim as Tko.ListPayload lp
    lp.target = target
    lp.first = p.ast->children.Count
    lp.count = items.Count
    for i as long = 0 to items.Count - 1
        p.ast->children.Push( items[i] )
    next
    p.ast->lists.Push( lp )
    return Tko.NewNode( *p.ast, kind, loc, p.ast->lists.Count - 1 )
end function

'' A general statement/declaration node.
function MakeStmt _
    ( byref p as Tko.ParserState, byval kind as Tko.NodeKind, byval loc as Tko.SourceLoc, _
      byref sp as Tko.StmtPayload ) as Tko.NodeId

    p.ast->stmts.Push( sp )
    return Tko.NewNode( *p.ast, kind, loc, p.ast->stmts.Count - 1 )
end function

function NewNodeAt _
    ( byref p as Tko.ParserState, byval kind as Tko.NodeKind, byval loc as Tko.SourceLoc, _
      byval payload as ulong ) as Tko.NodeId
    return Tko.NewNode( *p.ast, kind, loc, payload )
end function

'' ------------------------------------------------------------------- the parser

declare function Primary( byref p as Tko.ParserState ) as Tko.NodeId
declare function PostfixChain _
    ( byref p as Tko.ParserState, byval base_ as Tko.NodeId ) as Tko.NodeId
'' Declared rather than included: TypeRef lives in parser.bi, which sits ABOVE this
'' file. Including it here would make the dependency circular and would be caught by
'' build/lint.sh; the declaration keeps the edge one-way.
declare function TypeRef( byref p as Tko.ParserState ) as Tko.NodeId

'' 'cast( T, e )', 'cptr( T, e )', 'sizeof( T )', 'len( T )'.
''
'' CAST and CPTR always name a type first. SIZEOF and LEN accept EITHER a type or an
'' expression -- 'len( s )' is the common case -- so the type is taken only when the
'' argument unambiguously opens one: a type keyword, or a name followed by PTR. That
'' keeps every existing 'len( someString )' parsing exactly as it did, without
'' consulting the symbol table, which this layer may not do.
private function TypeArgCall _
    ( byref p as Tko.ParserState, byref t as Tko.Token, _
      byval k as Tko.TokenKind ) as Tko.NodeId

    dim as Tko.NodeId callee = MakeIdent( p, t )
    Advance( p )                                  '' the intrinsic name
    Advance( p )                                  '' '('

    dim as Tko.NodeIdVec items

    '' 'cva_arg( list, TYPE )' PUTS THE TYPE SECOND, alone among these. The first
    '' argument is an ordinary expression naming the cursor and the second is a type
    '' reference, so neither the always-a-type rule nor the looks-like-a-type guess
    '' below fits it. Without this the type came through as an N_IDENT -- 'integer'
    '' read as a name that binds to nothing -- and the call could be neither typed nor
    '' lowered. The statement-position form was already parsed correctly, which is why
    '' this only ever showed up in an initialiser.
    if k = Tko.KW_CVA_ARG then
        items.Push( cast( ulong, Expression( p ) ) )
        Expect( p, Tko.TK_COMMA, "," )
        items.Push( cast( ulong, TypeRef( p ) ) )
        Expect( p, Tko.TK_RPAREN, ")" )
        return PostfixChain( p, MakeList( p, Tko.N_CALL, t.loc, callee, items ) )
    end if

    if Peek( p ) <> Tko.TK_RPAREN then
        dim as boolean always = (k = Tko.KW_CAST) orelse (k = Tko.KW_CPTR)
        dim as boolean looksLikeType = Tko.IsTypeKeyword( Peek( p ) )
        if (looksLikeType = false) andalso (Peek( p ) = Tko.TK_IDENT) then
            if HasTok( p, p.pos + 1 ) then
                dim as Tko.TokenKind n = cast( Tko.TokenKind, p.toks->At( p.pos + 1 ).kind )
                looksLikeType = (n = Tko.KW_PTR) orelse (n = Tko.KW_POINTER)
            end if
        end if

        if always orelse looksLikeType then
            items.Push( cast( ulong, TypeRef( p ) ) )
        else
            items.Push( cast( ulong, Expression( p ) ) )
        end if

        while Accept( p, Tko.TK_COMMA )
            items.Push( cast( ulong, Expression( p ) ) )
        wend
    end if
    Expect( p, Tko.TK_RPAREN, ")" )
    return PostfixChain( p, MakeList( p, Tko.N_CALL, t.loc, callee, items ) )
end function

'' One argument, or the ABSENCE of one. FreeBASIC lets a call leave an argument out and
'' take the parameter's default -- 'f( 1, , 3 )', 'locate ,,0', 'screenres( w, h, 32, ,
'' fb.GFX_NULL )' -- and the empty slot still COUNTS, so it is a node rather than a gap
'' in the list.
function ArgOrElided _
    ( byref p as Tko.ParserState, byval closer as Tko.TokenKind ) as Tko.NodeId

    dim as Tko.TokenKind k = Peek( p )
    if (k = Tko.TK_COMMA) orelse (k = closer) orelse (k = Tko.TK_EOL) then
        return NewNodeAt( p, Tko.N_ELIDED, Cur( p ).loc, 0 )
    end if

    '' 'f( byval x )' OVERRIDES A BYREF PARAMETER for this one argument: the value goes
    '' where the address would have. It is the marker-keyword shape again -- the word
    '' was read as an ordinary identifier and the expression after it then had nowhere
    '' to go, so 'u( byval @i )' was 'expected )' pointing at the '@'.
    ''
    '' Only BYVAL. Measured: 'u( byref i )' is fbc's error 1, argument count mismatch,
    '' which is what reading 'byref' as a name looks like from inside fbc too.
    if k = Tko.KW_BYVAL then
        dim as Tko.Token bt = Cur( p )
        Advance( p )
        return MakeUnary( p, Tko.KW_BYVAL, bt.loc, Expression( p ) )
    end if
    return Expression( p )
end function

'' Five string intrinsics take a SET of characters rather than a substring, and mark
'' it with ANY: 'instr( s, any "ab" )' finds the first a-or-b. It is not an operator
'' and not a keyword argument -- it is a marker on ONE argument of ONE of five names.
''
'' Measured against fbc: INSTR, INSTRREV, TRIM, LTRIM and RTRIM accept it, MID does
'' not; it may sit on a variable or a parenthesised expression as readily as a literal;
'' and it is rejected in FIRST position -- 'instr( any "ab", "b" )' is error 9, as is
'' 'trim( any "b" )'. So the rule is 'the last argument, and not the only one'.
''
'' 14 corpus files, the largest single parse-gap cluster, and every one of them said
'' 'expected )' -- invisible in a table keyed on the diagnostic.
private function AllowsAnyArg _
    ( byref p as Tko.ParserState, byval callee as Tko.NodeId ) as boolean

    if callee = Tko.NODE_NONE then return false
    dim as Tko.AstNode ptr n = @p.ast->nodes[cast( long, callee )]
    if cast( Tko.NodeKind, n->kind ) <> Tko.N_IDENT then return false
    dim as string nm = p.names->Spelling( p.ast->idents[cast( long, n->data )].name )
    select case nm
    case "instr", "instrrev", "trim", "ltrim", "rtrim"
        return true
    end select
    return false
end function

'' Is the '(' at the cursor the start of '( of T, U )'?
private function IsGenericArgs( byref p as Tko.ParserState ) as boolean
    if Peek( p ) <> Tko.TK_LPAREN then return false
    if HasTok( p, p.pos + 1 ) = false then return false
    dim as Tko.Token nx = p.toks->At( p.pos + 1 )
    if cast( Tko.TokenKind, nx.kind ) <> Tko.TK_IDENT then return false
    return (p.names->Spelling( cast( Tko.InternId, nx.literal ) ) = "of")
end function

'' Consume a balanced parenthesised group, cursor on the '('.
private sub SkipBalanced( byref p as Tko.ParserState )
    dim as long depth = 0
    do
        dim as Tko.TokenKind k = Peek( p )
        if k = Tko.TK_LPAREN then depth += 1
        if k = Tko.TK_RPAREN then depth -= 1
        Advance( p )
        if depth <= 0 then exit do
        '' AtEnd lives in parser.bas, ABOVE this file, so the guard is the token kind
        '' itself rather than a call that would make the dependency circular.
        if Peek( p ) = Tko.TK_EOF then exit do
    loop
end sub

'' Postfix chain: calls, indexing and member access, all tighter than any operator.
function PostfixChain _
    ( byref p as Tko.ParserState, byval base_ as Tko.NodeId ) as Tko.NodeId

    dim as Tko.NodeId result = base_
    '' The type arguments of a pending '( of ... )', waiting for the call they belong to.
    dim as Tko.NodeIdVec typeArgs
    do
        dim as Tko.TokenKind k = Peek( p )
        dim as Tko.Token t = Cur( p )

        select case k
        case Tko.TK_LPAREN, Tko.TK_LBRACKET
            '' 'Box( of long )' is a GENERIC INSTANTIATION, not a call with two
            '' arguments named 'of' and 'long'. Taking it as a call parsed 'of' as an
            '' expression and then wanted a ')' where the type argument was -- 37 corpus
            '' files failed there, three of them RUNTIME HEADERS, so everything that
            '' includes fb/currency.bi, fb/fserror.bi or fb/mathtext.bi failed too.
            ''
            '' 'of' is CONTEXTUAL -- not a keyword -- so it is recognised by spelling,
            '' exactly as 'each' and 'defer' are.
            ''
            '' THE ARGUMENTS ARE KEPT. They used to be consumed and discarded, which was
            '' fine while nothing could instantiate anything -- but a GENERIC PROCEDURE
            '' is always called with them written out ('Ok( of Decimal, FinanceError )
            '' ( v )' is how every runtime header spells it), so they are the whole of
            '' the instantiation's input and throwing them away threw the call away.
            ''
            '' They are recorded against the CALL NODE, which is built on the next turn
            '' of this loop -- so 'typeArgs' is carried across rather than attached here.
            if (k = Tko.TK_LPAREN) andalso IsGenericArgs( p ) then
                Advance( p )
                Advance( p )              '' past '(' and 'of'
                do
                    typeArgs.Push( cast( ulong, TypeRef( p ) ) )
                    if Accept( p, Tko.TK_COMMA ) = false then exit do
                loop
                Expect( p, Tko.TK_RPAREN, ")" )
                continue do
            end if

            dim as Tko.TokenKind closer = Tko.TK_RPAREN
            dim as Tko.NodeKind kind = Tko.N_CALL
            if k = Tko.TK_LBRACKET then
                closer = Tko.TK_RBRACKET
                kind = Tko.N_INDEX
            end if
            Advance( p )

            dim as boolean anyOk = (kind = Tko.N_CALL) andalso AllowsAnyArg( p, result )

            dim as Tko.NodeIdVec items
            if Peek( p ) <> closer then
                do
                    '' 'any' only on the LAST argument and never on the first, so the
                    '' marker is taken only when something precedes it -- and what
                    '' follows the argument has to be the closer, which the loop's own
                    '' exit already enforces for the last one.
                    if anyOk andalso (items.Count > 0) andalso (Peek( p ) = Tko.KW_ANY) then
                        dim as Tko.Token anyTok = Cur( p )
                        Advance( p )
                        items.Push( cast( ulong, MakeUnary( p, Tko.KW_ANY, anyTok.loc, _
                                                            Expression( p ) ) ) )
                    else
                        items.Push( cast( ulong, ArgOrElided( p, closer ) ) )
                    end if
                    if Accept( p, Tko.TK_COMMA ) = false then exit do
                loop
            end if
            Expect( p, closer, iif( closer = Tko.TK_RPAREN, ")", "]" ) )
            result = MakeList( p, kind, t.loc, result, items )

            '' THE PENDING TYPE ARGUMENTS BELONG TO THIS CALL. Cleared afterwards, so a
            '' second call in the same postfix chain does not inherit them.
            if typeArgs.Count > 0 then
                dim as long taFirst = p.ast->children.Count
                dim as long taCount = typeArgs.Count
                for i as long = 0 to taCount - 1
                    p.ast->children.Push( typeArgs[i] )
                next
                p.ast->RecordCallTypeArgs( result, taFirst, taCount )
                while typeArgs.Count > 0
                    typeArgs.Pop( )
                wend
            end if

        case Tko.TK_DOT, Tko.TK_ARROW
            Advance( p )
            dim as Tko.Token nameTok = Cur( p )
            dim as boolean isName = (Peek( p ) = Tko.TK_IDENT) orelse _
                                    Tko.IsKeywordKind( Peek( p ) )
            if isName = false then
                result = ErrorNode( p, Tko.TKO0402 )
                exit do
            end if
            Advance( p )
            dim as Tko.NodeId member = MakeIdent( p, nameTok )
            result = MakeBinary( p, k, t.loc, result, member )
            p.ast->nodes[cast( long, result )].kind = cast( ushort, Tko.N_MEMBER )
            if k = Tko.TK_ARROW then
                p.ast->nodes[cast( long, result )].flags or= Tko.NF_ARROW
            end if

        case else
            exit do
        end select
    loop
    return result
end function

'' Prefix position: unary operators and primaries.
private function Prefix( byref p as Tko.ParserState ) as Tko.NodeId
    dim as Tko.TokenKind k = Peek( p )
    dim as Tko.Token t = Cur( p )

    select case k
    case Tko.TK_MINUS, Tko.TK_PLUS
        Advance( p )
        '' Unary sign binds looser than '^': -2 ^ 2 is -4.
        dim as Tko.NodeId operand = Expression( p, Tko.PREC_SIGN )
        return MakeUnary( p, k, t.loc, operand )

    case Tko.KW_NOT
        Advance( p )
        '' NOT is looser than the relationals and tighter than AND.
        dim as Tko.NodeId operand = Expression( p, Tko.PREC_NOT )
        return MakeUnary( p, k, t.loc, operand )

    case Tko.TK_AT
        Advance( p )
        dim as Tko.NodeId operand = Expression( p, Tko.PREC_SIGN )
        return MakeUnary( p, k, t.loc, operand, Tko.N_ADDROF )

    case Tko.TK_STAR
        Advance( p )
        dim as Tko.NodeId operand = Expression( p, Tko.PREC_SIGN )
        return MakeUnary( p, k, t.loc, operand, Tko.N_DEREF )
    end select

    return Primary( p )
end function

function Primary( byref p as Tko.ParserState ) as Tko.NodeId
    dim as Tko.TokenKind k = Peek( p )
    dim as Tko.Token t = Cur( p )

    select case k
    case Tko.TK_INT_LIT
        Advance( p )
        return MakeLiteral( p, t, Tko.N_INT_LIT, *p.litPool )

    case Tko.TK_FLOAT_LIT
        Advance( p )
        return MakeLiteral( p, t, Tko.N_FLOAT_LIT, *p.litPool )

    case Tko.TK_STRING_LIT
        Advance( p )
        dim as Tko.NodeId first_ = MakeLiteral( p, t, Tko.N_STRING_LIT, *p.litPool )
        '' Adjacent string literals concatenate at COMPILE time, as in C:
        '' 'print "a" "b" "c"' prints "abc". This is what makes a macro body like
        '' '"CU_ASSERT(" #a ")"' work, and missing it accounted for 567 of the
        '' corpus's parse errors.
        if Peek( p ) <> Tko.TK_STRING_LIT then return first_
        dim as Tko.NodeIdVec pieces
        pieces.Push( cast( ulong, first_ ) )
        while Peek( p ) = Tko.TK_STRING_LIT
            dim as Tko.Token nt = Cur( p )
            Advance( p )
            pieces.Push( cast( ulong, MakeLiteral( p, nt, Tko.N_STRING_LIT, *p.litPool ) ) )
        wend
        return MakeList( p, Tko.N_STRCAT, t.loc, Tko.NODE_NONE, pieces )

    case Tko.TK_IDENT
        Advance( p )
        return PostfixChain( p, MakeIdent( p, t ) )

    case Tko.KW_NEW
        '' 'new T', 'new T( args )', 'new T[ n ]'.
        ''
        '' NEW is classed as an OPERATOR in the keyword table, so Primary had no case
        '' for it and it fell through to the identifier path: 'p = new T' parsed as the
        '' plain identifier 'new' with the TYPE DROPPED ENTIRELY, and every allocation
        '' in the corpus lowered to nothing.
        ''
        '' The node is a LIST whose target is the TYPE and whose children are the
        '' constructor arguments. The ARRAY form marks the node NF_ARRAY and puts the
        '' element count in child 0 -- fbc accepts no constructor arguments there, so
        '' the two uses of the child list never collide.
        Advance( p )
        dim as Tko.NodeId nty = TypeRef( p )
        dim as Tko.NodeIdVec nargs
        dim as boolean nIsArray = false
        if Peek( p ) = Tko.TK_LBRACKET then
            Advance( p )
            nIsArray = true
            nargs.Push( cast( ulong, Expression( p ) ) )
            Expect( p, Tko.TK_RBRACKET, "]" )
        elseif Peek( p ) = Tko.TK_LPAREN then
            Advance( p )
            if Peek( p ) <> Tko.TK_RPAREN then
                do
                    nargs.Push( cast( ulong, Expression( p ) ) )
                    if Accept( p, Tko.TK_COMMA ) = false then exit do
                loop
            end if
            Expect( p, Tko.TK_RPAREN, ")" )
        end if
        dim as Tko.NodeId nn = MakeList( p, Tko.N_NEW, t.loc, nty, nargs )
        if nIsArray then p.ast->nodes[cast( long, nn )].flags or= Tko.NF_ARRAY
        return nn

    case Tko.KW_TYPE
        '' 'type<P>( 5, 6 )' -- THE ANONYMOUS UDT LITERAL, and 'type( 5, 6 )' with the
        '' type taken from context. 789 corpus lines and 36 in the runtime headers
        '' write one.
        ''
        '' It was not recognised at all, and the failure was SILENT: the expression
        '' parser read 'type<P>( 5, 6 )' as '(type < P) > (5, 6)' -- two comparisons
        '' over a name that binds to nothing -- so 'dim as GUID g = type<GUID>( ... )'
        '' produced a boolean-shaped tree where an object belonged, and declined three
        '' passes later with nothing pointing back here.
        ''
        '' Measured: it is EXACTLY the parenthesised field list with the type written
        '' out. fbc emits the same field stores and the same tail memset for
        '' 'type<P>( 5, 6 )' as for '( 5, 6 )', so the node built here is the same
        '' N_TUPLE -- with the type reference in the list's TARGET, which the bare form
        '' leaves empty.
        dim as Tko.NodeId litType = Tko.NODE_NONE
        dim as long save_ = p.pos
        Advance( p )                                  '' 'type'
        if Peek( p ) = Tko.TK_LT then
            Advance( p )
            litType = TypeRef( p )
            if Accept( p, Tko.TK_GT ) = false then
                '' Not a literal after all -- put the cursor back and let the ordinary
                '' paths have it, rather than consuming tokens on a guess.
                p.pos = save_
                return ErrorNode( p, Tko.TKO0402 )
            end if
        end if
        if Peek( p ) <> Tko.TK_LPAREN then
            p.pos = save_
            return ErrorNode( p, Tko.TKO0402 )
        end if
        Advance( p )                                  '' '('
        dim as Tko.NodeIdVec titems
        if Peek( p ) <> Tko.TK_RPAREN then
            do
                titems.Push( cast( ulong, Expression( p ) ) )
                if Accept( p, Tko.TK_COMMA ) = false then exit do
            loop
        end if
        Expect( p, Tko.TK_RPAREN, ")" )
        dim as Tko.NodeId tn = MakeList( p, Tko.N_TUPLE, t.loc, litType, titems )
        p.ast->nodes[cast( long, tn )].flags or= Tko.NF_HAS_COMMA
        p.ast->nodes[cast( long, tn )].flags or= Tko.NF_TYPE_LITERAL
        return PostfixChain( p, tn )

    case Tko.TK_LPAREN
        '' '(a)' is a parenthesised expression; '(a, b)' is a tuple. Purely
        '' syntactic, so the parser decides (docs/plan/04 section 3.3).
        Advance( p )
        dim as Tko.NodeIdVec items
        dim as boolean sawComma = false
        if Peek( p ) <> Tko.TK_RPAREN then
            do
                items.Push( cast( ulong, Expression( p ) ) )
                if Accept( p, Tko.TK_COMMA ) = false then exit do
                sawComma = true
            loop
        end if
        Expect( p, Tko.TK_RPAREN, ")" )

        dim as Tko.NodeId n = 0
        if sawComma then
            n = MakeList( p, Tko.N_TUPLE, t.loc, Tko.NODE_NONE, items )
            p.ast->nodes[cast( long, n )].flags or= Tko.NF_HAS_COMMA
        else
            n = MakeList( p, Tko.N_PAREN, t.loc, Tko.NODE_NONE, items )
        end if
        return PostfixChain( p, n )

    case Tko.TK_LBRACE
        Advance( p )
        dim as Tko.NodeIdVec items
        if Peek( p ) <> Tko.TK_RBRACE then
            do
                items.Push( cast( ulong, Expression( p ) ) )
                if Accept( p, Tko.TK_COMMA ) = false then exit do
            loop
        end if
        Expect( p, Tko.TK_RBRACE, "}" )
        return MakeList( p, Tko.N_INITIALIZER, t.loc, Tko.NODE_NONE, items )
    end select

    '' CAST, CPTR, SIZEOF and LEN take a TYPE where an expression would otherwise
    '' go, and a type is not an expression: 'cptr( double ptr, @u )' stops dead at
    '' 'ptr'. The resulting TKO0401 then desynchronises the parse badly enough to
    '' swallow an 'end namespace' several hundred lines later, so this is not a
    '' cosmetic gap. Which four accept a type was measured against fbc -- TYPEOF is
    '' deliberately absent, because fbc does not accept it in expression position.
    '' 'if open( "x", for output, as #1 ) <> 0' -- OPEN yields its error code. The
    '' clause keywords ('for output', 'as #1') are not expressions, so a generic call
    '' parse chokes on the first one; it needs the statement's own clause reader,
    '' stopped at the closing paren instead of at end of line.
    if k = Tko.KW_OPEN then
        return OpenExprCall( p )
    end if

    '' An ANONYMOUS procedure is a VALUE: 'f = function( byval x as long ) as long
    '' ... end function'. fb/sort.bi writes one, so every corpus file that includes
    '' it failed at the header rather than at anything of its own -- four of them.
    ''
    '' Measured against fbc: the FUNCTION and the SUB form are both accepted, in an
    '' initialiser, as a call argument, and all on one line separated by colons; the
    '' body may reference an enclosing local's TYPE but fbc does not capture values.
    '' Distinguished from a call to something named 'function' by the '(' that must
    '' follow immediately -- a lambda always has a parameter list, even an empty one.
    if (k = Tko.KW_FUNCTION) orelse (k = Tko.KW_SUB) then
        dim as Tko.NodeId lam = TryLambdaExpr( p )
        if lam <> Tko.NODE_NONE then return PostfixChain( p, lam )
    end if

    '' TYPEOF belongs with them: its operand may be a TYPE -- '#assert typeof( p ) =
    '' typeof( any ptr )' is how the corpus asserts a pointer type -- and an expression
    '' parser reads 'any ptr' as two names and fails on the second.
    if (k = Tko.KW_CAST) orelse (k = Tko.KW_CPTR) orelse _
       (k = Tko.KW_SIZEOF) orelse (k = Tko.KW_LEN) orelse (k = Tko.KW_TYPEOF) orelse _
       (k = Tko.KW_CVA_ARG) then
        if HasTok( p, p.pos + 1 ) then
            if cast( Tko.TokenKind, p.toks->At( p.pos + 1 ).kind ) = Tko.TK_LPAREN then
                return TypeArgCall( p, t, k )
            end if
        end if
    end if

    '' '.field' with nothing before it is the WITH shorthand: inside 'with expr' it
    '' means 'expr.field'. The base is supplied by the enclosing WITH, which this
    '' layer does not track -- it records a member access with NO base and leaves
    '' binding to the phase that knows which WITH is open.
    '' '..x' is the GLOBAL-SCOPE prefix -- inside a namespace it names the x at file
    '' scope rather than the one in view. It lexes as two separate TK_DOTs, so the
    '' WITH-shorthand branch below saw a dot followed by a dot, found no identifier,
    '' and reported 'expected an expression'.
    ''
    '' Measured: fbc accepts '..x', '..f( )', a chain '..a.b.v', an assignment target,
    '' and the prefix at module level where it means nothing extra.
    if k = Tko.TK_DOT then
        dim as boolean twoDots = false
        if HasTok( p, p.pos + 1 ) then
            twoDots = (cast( Tko.TokenKind, p.toks->At( p.pos + 1 ).kind ) = Tko.TK_DOT)
        end if
        if twoDots then
            Advance( p )
            Advance( p )
            dim as Tko.NodeId base_ = NewNodeAt( p, Tko.N_GLOBALSCOPE, t.loc, 0 )
            if (Peek( p ) = Tko.TK_IDENT) orelse Tko.IsKeywordKind( Peek( p ) ) then
                dim as Tko.Token nameTok = Cur( p )
                Advance( p )
                dim as Tko.NodeId member = MakeIdent( p, nameTok )
                dim as Tko.NodeId n = MakeBinary( p, Tko.TK_DOT, t.loc, base_, member )
                p.ast->nodes[cast( long, n )].kind = cast( ushort, Tko.N_MEMBER )
                return PostfixChain( p, n )
            end if
            return base_
        end if
    end if

    if k = Tko.TK_DOT then
        if HasTok( p, p.pos + 1 ) then
            dim as Tko.TokenKind nk = cast( Tko.TokenKind, p.toks->At( p.pos + 1 ).kind )
            if (nk = Tko.TK_IDENT) orelse Tko.IsKeywordKind( nk ) then
                Advance( p )
                dim as Tko.Token nameTok = Cur( p )
                Advance( p )
                dim as Tko.NodeId member = MakeIdent( p, nameTok )
                dim as Tko.NodeId n = MakeBinary( p, Tko.TK_DOT, t.loc, _
                                                  Tko.NODE_NONE, member )
                p.ast->nodes[cast( long, n )].kind = cast( ushort, Tko.N_MEMBER )
                return PostfixChain( p, n )
            end if
        end if
    end if

    '' A keyword in primary position is usually an intrinsic function call; the
    '' statement layer will route those. Anything else is a real syntax error.
    if Tko.IsKeywordKind( k ) then
        Advance( p )
        return PostfixChain( p, MakeIdent( p, t ) )
    end if

    return ErrorNode( p, Tko.TKO0400 )
end function

function Expression _
    ( byref p as Tko.ParserState, byval minPrec as long = 1 ) as Tko.NodeId

    p.depth += 1
    if p.depth > Tko.PARSE_MAX_DEPTH then
        p.depth -= 1
        return ErrorNode( p, Tko.TKO0403, str( Tko.PARSE_MAX_DEPTH ) )
    end if

    dim as Tko.NodeId left = Prefix( p )

    do
        dim as Tko.TokenKind k = Peek( p )
        dim as long prec = Tko.InfixPrec( k )
        if prec = 0 then exit do
        if prec < minPrec then exit do

        dim as Tko.Token opTok = Cur( p )
        Advance( p )
        '' Every FreeBASIC binary operator is LEFT-associative, so the right side
        '' is parsed at one level tighter. There is no right-associative case --
        '' not even '^' (docs/language/precedence.md).
        dim as Tko.NodeId right = Expression( p, prec + 1 )
        left = MakeBinary( p, k, opTok.loc, left, right )
    loop

    p.depth -= 1
    return left
end function

function OneExpression( byref p as Tko.ParserState ) as Tko.NodeId
    p.silent = false
    dim as Tko.NodeId n = Expression( p )
    '' Trailing junk means the expression was not what the user meant.
    dim as Tko.TokenKind k = Peek( p )
    dim as boolean atEnd = (k = Tko.TK_EOF) orelse (k = Tko.TK_EOL)
    if atEnd = false then n = ErrorNode( p, Tko.TKO0404 )
    return n
end function

end namespace

namespace Tko.Parse

'' ----------------------------------------------------------------------- dump
'' Byte-stable for identical input: this is a golden-test artefact.

private sub DumpNode _
    ( byref ast as Tko.AstArena, byref src as Tko.SourceManager, _
      byref names as Tko.Interner, byval id as Tko.NodeId, byval indent as long, _
      byref outp as string )

    if id = Tko.NODE_NONE then return
    dim as Tko.AstNode ptr n = @ast.nodes[cast( long, id )]
    dim as Tko.NodeKind k = cast( Tko.NodeKind, n->kind )
    dim as Tko.DecodedLoc d = src.Decode( n->loc )

    dim as string row = space( indent * 2 ) & Tko.NodeKindName( k )

    select case k
    case Tko.N_INT_LIT
        dim as Tko.LiteralPayload ptr lp = @ast.literals[cast( long, n->data )]
        row += " " & str( lp->intValue ) & " radix=" & lp->radix
    case Tko.N_FLOAT_LIT
        dim as Tko.LiteralPayload ptr lp = @ast.literals[cast( long, n->data )]
        row += " " & str( lp->fltValue )
    case Tko.N_STRING_LIT
        dim as Tko.LiteralPayload ptr lp = @ast.literals[cast( long, n->data )]
        row += " len=" & lp->strLength & " kind=" & lp->strKind
    case Tko.N_IDENT
        dim as Tko.IdentPayload ptr ip = @ast.idents[cast( long, n->data )]
        row += " '" & names.Spelling( ip->name ) & "'"
    case Tko.N_UNARY, Tko.N_ADDROF, Tko.N_DEREF
        dim as Tko.UnaryPayload ptr up = @ast.unaries[cast( long, n->data )]
        row += " " & Tko.TokenKindText( cast( Tko.TokenKind, up->op ) )
    case Tko.N_BINARY, Tko.N_MEMBER
        dim as Tko.BinaryPayload ptr bp = @ast.binaries[cast( long, n->data )]
        row += " " & Tko.TokenKindText( cast( Tko.TokenKind, bp->op ) )
    case Tko.N_INTRINSIC
        dim as Tko.StmtPayload ptr ip = @ast.stmts[cast( long, n->data )]
        '' TokenKindText, matching the statement dumper: one shape printed one way.
        if ip->op <> 0 then
            dim as string ot = Tko.TokenKindText( cast( Tko.TokenKind, ip->op ) )
            if len( ot ) > 0 then row += " [" & ot & "]"
        end if
    end select

    row += " <" & d.lineNo & ":" & d.column & ">"
    outp += row & chr( 10 )

    select case k
    case Tko.N_UNARY, Tko.N_ADDROF, Tko.N_DEREF
        dim as Tko.UnaryPayload ptr up = @ast.unaries[cast( long, n->data )]
        DumpNode( ast, src, names, up->operand, indent + 1, outp )
    case Tko.N_BINARY, Tko.N_MEMBER
        dim as Tko.BinaryPayload ptr bp = @ast.binaries[cast( long, n->data )]
        DumpNode( ast, src, names, bp->lhs, indent + 1, outp )
        DumpNode( ast, src, names, bp->rhs, indent + 1, outp )
    case Tko.N_INTRINSIC
        '' An intrinsic can appear INSIDE an expression -- 'open( ... )' yields its
        '' error code. It carries a statement payload, so without this the expression
        '' printer stops at the bare row and every child is invisible to a golden,
        '' which is precisely how a construct that parsed but dropped its arguments
        '' would look.
        dim as Tko.StmtPayload ptr ip = @ast.stmts[cast( long, n->data )]
        DumpNode( ast, src, names, ip->a, indent + 1, outp )
        DumpNode( ast, src, names, ip->b, indent + 1, outp )
        DumpNode( ast, src, names, ip->c, indent + 1, outp )
        for i as long = 0 to ip->count - 1
            DumpNode( ast, src, names, _
                      cast( Tko.NodeId, ast.children[ip->first + i] ), indent + 1, outp )
        next
    case Tko.N_CALL, Tko.N_INDEX, Tko.N_PAREN, Tko.N_TUPLE, Tko.N_INITIALIZER, Tko.N_STRCAT
        dim as Tko.ListPayload ptr lp = @ast.lists[cast( long, n->data )]
        if lp->target <> Tko.NODE_NONE then
            DumpNode( ast, src, names, lp->target, indent + 1, outp )
        end if
        for i as long = 0 to lp->count - 1
            dim as Tko.NodeId child = cast( Tko.NodeId, ast.children[lp->first + i] )
            DumpNode( ast, src, names, child, indent + 1, outp )
        next
    end select
end sub

function Dump _
    ( byref ast as Tko.AstArena, byref src as Tko.SourceManager, _
      byref names as Tko.Interner, byval root as Tko.NodeId ) as string

    dim as string outp = ""
    DumpNode( ast, src, names, root, 0, outp )
    return outp
end function

end namespace
