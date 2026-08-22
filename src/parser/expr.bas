'' expr.bas -- see expr.bi.  Also carries the AST arena and its dump.

#include once "parser/expr.bi"
#include once "support/text.bi"
#include once "pp/pp.bi"

namespace Fbx

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
    FBX_NODE_LIST( NODE )
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
        FBX_BINOP_LIST( BINOP )
        #undef BINOP
        infixReady = true
    end if
    dim as boolean bad = (k < 0) orelse (k >= TK_KIND_COUNT)
    if bad then return 0
    return infixPrecTb(k)
end function

end namespace

namespace Fbx.Parse

'' -------------------------------------------------------------- token helpers

function HasTok( byref p as Fbx.ParserState, byval want as long ) as boolean
    if want < 0 then return false
    if p.stream <> 0 then
        return Fbx.PpEnsure( *cast( Fbx.PpStream ptr, p.stream ), want )
    end if
    return (want < p.toks->Count)
end function

function Peek( byref p as Fbx.ParserState ) as Fbx.TokenKind
    if HasTok( p, p.pos ) = false then return Fbx.TK_EOF
    return cast( Fbx.TokenKind, p.toks->At( p.pos ).kind )
end function

function Cur( byref p as Fbx.ParserState ) as Fbx.Token
    dim as Fbx.Token t
    if HasTok( p, p.pos ) then t = p.toks->At( p.pos )
    return t
end function

sub Advance( byref p as Fbx.ParserState )
    if HasTok( p, p.pos ) then p.pos += 1
end sub

function Accept( byref p as Fbx.ParserState, byval k as Fbx.TokenKind ) as boolean
    if Peek( p ) <> k then return false
    Advance( p )
    return true
end function

function ErrorNode _
    ( byref p as Fbx.ParserState, byval id as Fbx.DiagId, byval a0 as string = "" ) as Fbx.NodeId

    dim as Fbx.Token t = Cur( p )
    '' One diagnostic per statement: the rest of a broken expression is noise
    '' (docs/plan/04 section 8).
    if p.silent = false then
        dim as Fbx.SourceRange r
        r.first = t.loc
        r.last = t.loc
        p.diags->Report( id, r, a0 )
        p.silent = true
    end if
    p.errors += 1
    return Fbx.NewNode( *p.ast, Fbx.N_ERROR, t.loc, 0 )
end function

function Expect _
    ( byref p as Fbx.ParserState, byval k as Fbx.TokenKind, byval what as string ) as boolean

    if Accept( p, k ) then return true
    ErrorNode( p, Fbx.FBX0401, what )
    return false
end function

'' ------------------------------------------------------------------- builders

private function MakeLiteral _
    ( byref p as Fbx.ParserState, byref t as Fbx.Token, byval kind as Fbx.NodeKind, _
      byref pool as Fbx.LiteralVec ) as Fbx.NodeId

    dim as Fbx.LiteralPayload lp
    if cast( long, t.literal ) < pool.Count then
        dim as Fbx.Literal ptr src = @pool[cast( long, t.literal )]
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
    return Fbx.NewNode( *p.ast, kind, t.loc, p.ast->literals.Count - 1 )
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
    ( byref p as Fbx.ParserState, byref t as Fbx.Token ) as Fbx.NodeId

    select case cast( Fbx.TokenKind, t.kind )
    case Fbx.TK_INT_LIT    : return MakeLiteral( p, t, Fbx.N_INT_LIT, *p.litPool )
    case Fbx.TK_FLOAT_LIT  : return MakeLiteral( p, t, Fbx.N_FLOAT_LIT, *p.litPool )
    case Fbx.TK_STRING_LIT : return MakeLiteral( p, t, Fbx.N_STRING_LIT, *p.litPool )
    end select
    return MakeIdent( p, t )
end function

function MakeIdent( byref p as Fbx.ParserState, byref t as Fbx.Token ) as Fbx.NodeId
    dim as Fbx.IdentPayload ip
    ip.name = cast( Fbx.InternId, t.literal )
    '' A KEYWORD token carries no interned spelling in 'literal', so an identifier
    '' built from one -- 'abs( x )', 'len( s )', a member called '.type' -- had an
    '' EMPTY name. It showed in the AST dump as N_IDENT '' and made every such callee
    '' unrecognisable to anything that matches on the name.
    if Fbx.IsKeywordKind( cast( Fbx.TokenKind, t.kind ) ) then
        ip.name = p.names->GetString( _
            Fbx.Text.LowerAscii( Fbx.TokenKindText( cast( Fbx.TokenKind, t.kind ) ) ) )
    end if
    dim as Fbx.DecodedLoc d = p.src->Decode( t.loc )
    ip.spellOffset = d.offset
    ip.spellLength = cast( long, t.length )
    p.ast->idents.Push( ip )
    return Fbx.NewNode( *p.ast, Fbx.N_IDENT, t.loc, p.ast->idents.Count - 1 )
end function

private function MakeUnary _
    ( byref p as Fbx.ParserState, byval op as Fbx.TokenKind, byval loc as Fbx.SourceLoc, _
      byval operand as Fbx.NodeId, byval kind as Fbx.NodeKind = Fbx.N_UNARY ) as Fbx.NodeId

    dim as Fbx.UnaryPayload up
    up.op = cast( ushort, op )
    up.operand = operand
    p.ast->unaries.Push( up )
    return Fbx.NewNode( *p.ast, kind, loc, p.ast->unaries.Count - 1 )
end function

private function MakeBinary _
    ( byref p as Fbx.ParserState, byval op as Fbx.TokenKind, byval loc as Fbx.SourceLoc, _
      byval lhs as Fbx.NodeId, byval rhs as Fbx.NodeId ) as Fbx.NodeId

    dim as Fbx.BinaryPayload bp
    bp.op = cast( ushort, op )
    bp.lhs = lhs
    bp.rhs = rhs
    p.ast->binaries.Push( bp )
    return Fbx.NewNode( *p.ast, Fbx.N_BINARY, loc, p.ast->binaries.Count - 1 )
end function

'' Children are appended to the shared pool, so a list node allocates nothing of
'' its own (docs/plan/05 section 1).
function MakeList _
    ( byref p as Fbx.ParserState, byval kind as Fbx.NodeKind, byval loc as Fbx.SourceLoc, _
      byval target as Fbx.NodeId, byref items as Fbx.NodeIdVec ) as Fbx.NodeId

    dim as Fbx.ListPayload lp
    lp.target = target
    lp.first = p.ast->children.Count
    lp.count = items.Count
    for i as long = 0 to items.Count - 1
        p.ast->children.Push( items[i] )
    next
    p.ast->lists.Push( lp )
    return Fbx.NewNode( *p.ast, kind, loc, p.ast->lists.Count - 1 )
end function

'' A general statement/declaration node.
function MakeStmt _
    ( byref p as Fbx.ParserState, byval kind as Fbx.NodeKind, byval loc as Fbx.SourceLoc, _
      byref sp as Fbx.StmtPayload ) as Fbx.NodeId

    p.ast->stmts.Push( sp )
    return Fbx.NewNode( *p.ast, kind, loc, p.ast->stmts.Count - 1 )
end function

function NewNodeAt _
    ( byref p as Fbx.ParserState, byval kind as Fbx.NodeKind, byval loc as Fbx.SourceLoc, _
      byval payload as ulong ) as Fbx.NodeId
    return Fbx.NewNode( *p.ast, kind, loc, payload )
end function

'' ------------------------------------------------------------------- the parser

declare function Primary( byref p as Fbx.ParserState ) as Fbx.NodeId
declare function PostfixChain _
    ( byref p as Fbx.ParserState, byval base_ as Fbx.NodeId ) as Fbx.NodeId
'' Declared rather than included: TypeRef lives in parser.bi, which sits ABOVE this
'' file. Including it here would make the dependency circular and would be caught by
'' build/lint.sh; the declaration keeps the edge one-way.
declare function TypeRef( byref p as Fbx.ParserState ) as Fbx.NodeId

'' 'cast( T, e )', 'cptr( T, e )', 'sizeof( T )', 'len( T )'.
''
'' CAST and CPTR always name a type first. SIZEOF and LEN accept EITHER a type or an
'' expression -- 'len( s )' is the common case -- so the type is taken only when the
'' argument unambiguously opens one: a type keyword, or a name followed by PTR. That
'' keeps every existing 'len( someString )' parsing exactly as it did, without
'' consulting the symbol table, which this layer may not do.
private function TypeArgCall _
    ( byref p as Fbx.ParserState, byref t as Fbx.Token, _
      byval k as Fbx.TokenKind ) as Fbx.NodeId

    dim as Fbx.NodeId callee = MakeIdent( p, t )
    Advance( p )                                  '' the intrinsic name
    Advance( p )                                  '' '('

    dim as Fbx.NodeIdVec items
    if Peek( p ) <> Fbx.TK_RPAREN then
        dim as boolean always = (k = Fbx.KW_CAST) orelse (k = Fbx.KW_CPTR)
        dim as boolean looksLikeType = Fbx.IsTypeKeyword( Peek( p ) )
        if (looksLikeType = false) andalso (Peek( p ) = Fbx.TK_IDENT) then
            if HasTok( p, p.pos + 1 ) then
                dim as Fbx.TokenKind n = cast( Fbx.TokenKind, p.toks->At( p.pos + 1 ).kind )
                looksLikeType = (n = Fbx.KW_PTR) orelse (n = Fbx.KW_POINTER)
            end if
        end if

        if always orelse looksLikeType then
            items.Push( cast( ulong, TypeRef( p ) ) )
        else
            items.Push( cast( ulong, Expression( p ) ) )
        end if

        while Accept( p, Fbx.TK_COMMA )
            items.Push( cast( ulong, Expression( p ) ) )
        wend
    end if
    Expect( p, Fbx.TK_RPAREN, ")" )
    return PostfixChain( p, MakeList( p, Fbx.N_CALL, t.loc, callee, items ) )
end function

'' One argument, or the ABSENCE of one. FreeBASIC lets a call leave an argument out and
'' take the parameter's default -- 'f( 1, , 3 )', 'locate ,,0', 'screenres( w, h, 32, ,
'' fb.GFX_NULL )' -- and the empty slot still COUNTS, so it is a node rather than a gap
'' in the list.
function ArgOrElided _
    ( byref p as Fbx.ParserState, byval closer as Fbx.TokenKind ) as Fbx.NodeId

    dim as Fbx.TokenKind k = Peek( p )
    if (k = Fbx.TK_COMMA) orelse (k = closer) orelse (k = Fbx.TK_EOL) then
        return NewNodeAt( p, Fbx.N_ELIDED, Cur( p ).loc, 0 )
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
    ( byref p as Fbx.ParserState, byval callee as Fbx.NodeId ) as boolean

    if callee = Fbx.NODE_NONE then return false
    dim as Fbx.AstNode ptr n = @p.ast->nodes[cast( long, callee )]
    if cast( Fbx.NodeKind, n->kind ) <> Fbx.N_IDENT then return false
    dim as string nm = p.names->Spelling( p.ast->idents[cast( long, n->data )].name )
    select case nm
    case "instr", "instrrev", "trim", "ltrim", "rtrim"
        return true
    end select
    return false
end function

'' Is the '(' at the cursor the start of '( of T, U )'?
private function IsGenericArgs( byref p as Fbx.ParserState ) as boolean
    if Peek( p ) <> Fbx.TK_LPAREN then return false
    if HasTok( p, p.pos + 1 ) = false then return false
    dim as Fbx.Token nx = p.toks->At( p.pos + 1 )
    if cast( Fbx.TokenKind, nx.kind ) <> Fbx.TK_IDENT then return false
    return (p.names->Spelling( cast( Fbx.InternId, nx.literal ) ) = "of")
end function

'' Consume a balanced parenthesised group, cursor on the '('.
private sub SkipBalanced( byref p as Fbx.ParserState )
    dim as long depth = 0
    do
        dim as Fbx.TokenKind k = Peek( p )
        if k = Fbx.TK_LPAREN then depth += 1
        if k = Fbx.TK_RPAREN then depth -= 1
        Advance( p )
        if depth <= 0 then exit do
        '' AtEnd lives in parser.bas, ABOVE this file, so the guard is the token kind
        '' itself rather than a call that would make the dependency circular.
        if Peek( p ) = Fbx.TK_EOF then exit do
    loop
end sub

'' Postfix chain: calls, indexing and member access, all tighter than any operator.
function PostfixChain _
    ( byref p as Fbx.ParserState, byval base_ as Fbx.NodeId ) as Fbx.NodeId

    dim as Fbx.NodeId result = base_
    '' The type arguments of a pending '( of ... )', waiting for the call they belong to.
    dim as Fbx.NodeIdVec typeArgs
    do
        dim as Fbx.TokenKind k = Peek( p )
        dim as Fbx.Token t = Cur( p )

        select case k
        case Fbx.TK_LPAREN, Fbx.TK_LBRACKET
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
            if (k = Fbx.TK_LPAREN) andalso IsGenericArgs( p ) then
                Advance( p )
                Advance( p )              '' past '(' and 'of'
                do
                    typeArgs.Push( cast( ulong, TypeRef( p ) ) )
                    if Accept( p, Fbx.TK_COMMA ) = false then exit do
                loop
                Expect( p, Fbx.TK_RPAREN, ")" )
                continue do
            end if

            dim as Fbx.TokenKind closer = Fbx.TK_RPAREN
            dim as Fbx.NodeKind kind = Fbx.N_CALL
            if k = Fbx.TK_LBRACKET then
                closer = Fbx.TK_RBRACKET
                kind = Fbx.N_INDEX
            end if
            Advance( p )

            dim as boolean anyOk = (kind = Fbx.N_CALL) andalso AllowsAnyArg( p, result )

            dim as Fbx.NodeIdVec items
            if Peek( p ) <> closer then
                do
                    '' 'any' only on the LAST argument and never on the first, so the
                    '' marker is taken only when something precedes it -- and what
                    '' follows the argument has to be the closer, which the loop's own
                    '' exit already enforces for the last one.
                    if anyOk andalso (items.Count > 0) andalso (Peek( p ) = Fbx.KW_ANY) then
                        dim as Fbx.Token anyTok = Cur( p )
                        Advance( p )
                        items.Push( cast( ulong, MakeUnary( p, Fbx.KW_ANY, anyTok.loc, _
                                                            Expression( p ) ) ) )
                    else
                        items.Push( cast( ulong, ArgOrElided( p, closer ) ) )
                    end if
                    if Accept( p, Fbx.TK_COMMA ) = false then exit do
                loop
            end if
            Expect( p, closer, iif( closer = Fbx.TK_RPAREN, ")", "]" ) )
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

        case Fbx.TK_DOT, Fbx.TK_ARROW
            Advance( p )
            dim as Fbx.Token nameTok = Cur( p )
            dim as boolean isName = (Peek( p ) = Fbx.TK_IDENT) orelse _
                                    Fbx.IsKeywordKind( Peek( p ) )
            if isName = false then
                result = ErrorNode( p, Fbx.FBX0402 )
                exit do
            end if
            Advance( p )
            dim as Fbx.NodeId member = MakeIdent( p, nameTok )
            result = MakeBinary( p, k, t.loc, result, member )
            p.ast->nodes[cast( long, result )].kind = cast( ushort, Fbx.N_MEMBER )
            if k = Fbx.TK_ARROW then
                p.ast->nodes[cast( long, result )].flags or= Fbx.NF_ARROW
            end if

        case else
            exit do
        end select
    loop
    return result
end function

'' Prefix position: unary operators and primaries.
private function Prefix( byref p as Fbx.ParserState ) as Fbx.NodeId
    dim as Fbx.TokenKind k = Peek( p )
    dim as Fbx.Token t = Cur( p )

    select case k
    case Fbx.TK_MINUS, Fbx.TK_PLUS
        Advance( p )
        '' Unary sign binds looser than '^': -2 ^ 2 is -4.
        dim as Fbx.NodeId operand = Expression( p, Fbx.PREC_SIGN )
        return MakeUnary( p, k, t.loc, operand )

    case Fbx.KW_NOT
        Advance( p )
        '' NOT is looser than the relationals and tighter than AND.
        dim as Fbx.NodeId operand = Expression( p, Fbx.PREC_NOT )
        return MakeUnary( p, k, t.loc, operand )

    case Fbx.TK_AT
        Advance( p )
        dim as Fbx.NodeId operand = Expression( p, Fbx.PREC_SIGN )
        return MakeUnary( p, k, t.loc, operand, Fbx.N_ADDROF )

    case Fbx.TK_STAR
        Advance( p )
        dim as Fbx.NodeId operand = Expression( p, Fbx.PREC_SIGN )
        return MakeUnary( p, k, t.loc, operand, Fbx.N_DEREF )
    end select

    return Primary( p )
end function

function Primary( byref p as Fbx.ParserState ) as Fbx.NodeId
    dim as Fbx.TokenKind k = Peek( p )
    dim as Fbx.Token t = Cur( p )

    select case k
    case Fbx.TK_INT_LIT
        Advance( p )
        return MakeLiteral( p, t, Fbx.N_INT_LIT, *p.litPool )

    case Fbx.TK_FLOAT_LIT
        Advance( p )
        return MakeLiteral( p, t, Fbx.N_FLOAT_LIT, *p.litPool )

    case Fbx.TK_STRING_LIT
        Advance( p )
        dim as Fbx.NodeId first_ = MakeLiteral( p, t, Fbx.N_STRING_LIT, *p.litPool )
        '' Adjacent string literals concatenate at COMPILE time, as in C:
        '' 'print "a" "b" "c"' prints "abc". This is what makes a macro body like
        '' '"CU_ASSERT(" #a ")"' work, and missing it accounted for 567 of the
        '' corpus's parse errors.
        if Peek( p ) <> Fbx.TK_STRING_LIT then return first_
        dim as Fbx.NodeIdVec pieces
        pieces.Push( cast( ulong, first_ ) )
        while Peek( p ) = Fbx.TK_STRING_LIT
            dim as Fbx.Token nt = Cur( p )
            Advance( p )
            pieces.Push( cast( ulong, MakeLiteral( p, nt, Fbx.N_STRING_LIT, *p.litPool ) ) )
        wend
        return MakeList( p, Fbx.N_STRCAT, t.loc, Fbx.NODE_NONE, pieces )

    case Fbx.TK_IDENT
        Advance( p )
        return PostfixChain( p, MakeIdent( p, t ) )

    case Fbx.KW_NEW
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
        dim as Fbx.NodeId nty = TypeRef( p )
        dim as Fbx.NodeIdVec nargs
        dim as boolean nIsArray = false
        if Peek( p ) = Fbx.TK_LBRACKET then
            Advance( p )
            nIsArray = true
            nargs.Push( cast( ulong, Expression( p ) ) )
            Expect( p, Fbx.TK_RBRACKET, "]" )
        elseif Peek( p ) = Fbx.TK_LPAREN then
            Advance( p )
            if Peek( p ) <> Fbx.TK_RPAREN then
                do
                    nargs.Push( cast( ulong, Expression( p ) ) )
                    if Accept( p, Fbx.TK_COMMA ) = false then exit do
                loop
            end if
            Expect( p, Fbx.TK_RPAREN, ")" )
        end if
        dim as Fbx.NodeId nn = MakeList( p, Fbx.N_NEW, t.loc, nty, nargs )
        if nIsArray then p.ast->nodes[cast( long, nn )].flags or= Fbx.NF_ARRAY
        return nn

    case Fbx.TK_LPAREN
        '' '(a)' is a parenthesised expression; '(a, b)' is a tuple. Purely
        '' syntactic, so the parser decides (docs/plan/04 section 3.3).
        Advance( p )
        dim as Fbx.NodeIdVec items
        dim as boolean sawComma = false
        if Peek( p ) <> Fbx.TK_RPAREN then
            do
                items.Push( cast( ulong, Expression( p ) ) )
                if Accept( p, Fbx.TK_COMMA ) = false then exit do
                sawComma = true
            loop
        end if
        Expect( p, Fbx.TK_RPAREN, ")" )

        dim as Fbx.NodeId n = 0
        if sawComma then
            n = MakeList( p, Fbx.N_TUPLE, t.loc, Fbx.NODE_NONE, items )
            p.ast->nodes[cast( long, n )].flags or= Fbx.NF_HAS_COMMA
        else
            n = MakeList( p, Fbx.N_PAREN, t.loc, Fbx.NODE_NONE, items )
        end if
        return PostfixChain( p, n )

    case Fbx.TK_LBRACE
        Advance( p )
        dim as Fbx.NodeIdVec items
        if Peek( p ) <> Fbx.TK_RBRACE then
            do
                items.Push( cast( ulong, Expression( p ) ) )
                if Accept( p, Fbx.TK_COMMA ) = false then exit do
            loop
        end if
        Expect( p, Fbx.TK_RBRACE, "}" )
        return MakeList( p, Fbx.N_INITIALIZER, t.loc, Fbx.NODE_NONE, items )
    end select

    '' CAST, CPTR, SIZEOF and LEN take a TYPE where an expression would otherwise
    '' go, and a type is not an expression: 'cptr( double ptr, @u )' stops dead at
    '' 'ptr'. The resulting FBX0401 then desynchronises the parse badly enough to
    '' swallow an 'end namespace' several hundred lines later, so this is not a
    '' cosmetic gap. Which four accept a type was measured against fbc -- TYPEOF is
    '' deliberately absent, because fbc does not accept it in expression position.
    '' 'if open( "x", for output, as #1 ) <> 0' -- OPEN yields its error code. The
    '' clause keywords ('for output', 'as #1') are not expressions, so a generic call
    '' parse chokes on the first one; it needs the statement's own clause reader,
    '' stopped at the closing paren instead of at end of line.
    if k = Fbx.KW_OPEN then
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
    if (k = Fbx.KW_FUNCTION) orelse (k = Fbx.KW_SUB) then
        dim as Fbx.NodeId lam = TryLambdaExpr( p )
        if lam <> Fbx.NODE_NONE then return PostfixChain( p, lam )
    end if

    if (k = Fbx.KW_CAST) orelse (k = Fbx.KW_CPTR) orelse _
       (k = Fbx.KW_SIZEOF) orelse (k = Fbx.KW_LEN) then
        if HasTok( p, p.pos + 1 ) then
            if cast( Fbx.TokenKind, p.toks->At( p.pos + 1 ).kind ) = Fbx.TK_LPAREN then
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
    if k = Fbx.TK_DOT then
        dim as boolean twoDots = false
        if HasTok( p, p.pos + 1 ) then
            twoDots = (cast( Fbx.TokenKind, p.toks->At( p.pos + 1 ).kind ) = Fbx.TK_DOT)
        end if
        if twoDots then
            Advance( p )
            Advance( p )
            dim as Fbx.NodeId base_ = NewNodeAt( p, Fbx.N_GLOBALSCOPE, t.loc, 0 )
            if (Peek( p ) = Fbx.TK_IDENT) orelse Fbx.IsKeywordKind( Peek( p ) ) then
                dim as Fbx.Token nameTok = Cur( p )
                Advance( p )
                dim as Fbx.NodeId member = MakeIdent( p, nameTok )
                dim as Fbx.NodeId n = MakeBinary( p, Fbx.TK_DOT, t.loc, base_, member )
                p.ast->nodes[cast( long, n )].kind = cast( ushort, Fbx.N_MEMBER )
                return PostfixChain( p, n )
            end if
            return base_
        end if
    end if

    if k = Fbx.TK_DOT then
        if HasTok( p, p.pos + 1 ) then
            dim as Fbx.TokenKind nk = cast( Fbx.TokenKind, p.toks->At( p.pos + 1 ).kind )
            if (nk = Fbx.TK_IDENT) orelse Fbx.IsKeywordKind( nk ) then
                Advance( p )
                dim as Fbx.Token nameTok = Cur( p )
                Advance( p )
                dim as Fbx.NodeId member = MakeIdent( p, nameTok )
                dim as Fbx.NodeId n = MakeBinary( p, Fbx.TK_DOT, t.loc, _
                                                  Fbx.NODE_NONE, member )
                p.ast->nodes[cast( long, n )].kind = cast( ushort, Fbx.N_MEMBER )
                return PostfixChain( p, n )
            end if
        end if
    end if

    '' A keyword in primary position is usually an intrinsic function call; the
    '' statement layer will route those. Anything else is a real syntax error.
    if Fbx.IsKeywordKind( k ) then
        Advance( p )
        return PostfixChain( p, MakeIdent( p, t ) )
    end if

    return ErrorNode( p, Fbx.FBX0400 )
end function

function Expression _
    ( byref p as Fbx.ParserState, byval minPrec as long = 1 ) as Fbx.NodeId

    p.depth += 1
    if p.depth > Fbx.PARSE_MAX_DEPTH then
        p.depth -= 1
        return ErrorNode( p, Fbx.FBX0403, str( Fbx.PARSE_MAX_DEPTH ) )
    end if

    dim as Fbx.NodeId left = Prefix( p )

    do
        dim as Fbx.TokenKind k = Peek( p )
        dim as long prec = Fbx.InfixPrec( k )
        if prec = 0 then exit do
        if prec < minPrec then exit do

        dim as Fbx.Token opTok = Cur( p )
        Advance( p )
        '' Every FreeBASIC binary operator is LEFT-associative, so the right side
        '' is parsed at one level tighter. There is no right-associative case --
        '' not even '^' (docs/language/precedence.md).
        dim as Fbx.NodeId right = Expression( p, prec + 1 )
        left = MakeBinary( p, k, opTok.loc, left, right )
    loop

    p.depth -= 1
    return left
end function

function OneExpression( byref p as Fbx.ParserState ) as Fbx.NodeId
    p.silent = false
    dim as Fbx.NodeId n = Expression( p )
    '' Trailing junk means the expression was not what the user meant.
    dim as Fbx.TokenKind k = Peek( p )
    dim as boolean atEnd = (k = Fbx.TK_EOF) orelse (k = Fbx.TK_EOL)
    if atEnd = false then n = ErrorNode( p, Fbx.FBX0404 )
    return n
end function

end namespace

namespace Fbx.Parse

'' ----------------------------------------------------------------------- dump
'' Byte-stable for identical input: this is a golden-test artefact.

private sub DumpNode _
    ( byref ast as Fbx.AstArena, byref src as Fbx.SourceManager, _
      byref names as Fbx.Interner, byval id as Fbx.NodeId, byval indent as long, _
      byref outp as string )

    if id = Fbx.NODE_NONE then return
    dim as Fbx.AstNode ptr n = @ast.nodes[cast( long, id )]
    dim as Fbx.NodeKind k = cast( Fbx.NodeKind, n->kind )
    dim as Fbx.DecodedLoc d = src.Decode( n->loc )

    dim as string row = space( indent * 2 ) & Fbx.NodeKindName( k )

    select case k
    case Fbx.N_INT_LIT
        dim as Fbx.LiteralPayload ptr lp = @ast.literals[cast( long, n->data )]
        row += " " & str( lp->intValue ) & " radix=" & lp->radix
    case Fbx.N_FLOAT_LIT
        dim as Fbx.LiteralPayload ptr lp = @ast.literals[cast( long, n->data )]
        row += " " & str( lp->fltValue )
    case Fbx.N_STRING_LIT
        dim as Fbx.LiteralPayload ptr lp = @ast.literals[cast( long, n->data )]
        row += " len=" & lp->strLength & " kind=" & lp->strKind
    case Fbx.N_IDENT
        dim as Fbx.IdentPayload ptr ip = @ast.idents[cast( long, n->data )]
        row += " '" & names.Spelling( ip->name ) & "'"
    case Fbx.N_UNARY, Fbx.N_ADDROF, Fbx.N_DEREF
        dim as Fbx.UnaryPayload ptr up = @ast.unaries[cast( long, n->data )]
        row += " " & Fbx.TokenKindText( cast( Fbx.TokenKind, up->op ) )
    case Fbx.N_BINARY, Fbx.N_MEMBER
        dim as Fbx.BinaryPayload ptr bp = @ast.binaries[cast( long, n->data )]
        row += " " & Fbx.TokenKindText( cast( Fbx.TokenKind, bp->op ) )
    case Fbx.N_INTRINSIC
        dim as Fbx.StmtPayload ptr ip = @ast.stmts[cast( long, n->data )]
        '' TokenKindText, matching the statement dumper: one shape printed one way.
        if ip->op <> 0 then
            dim as string ot = Fbx.TokenKindText( cast( Fbx.TokenKind, ip->op ) )
            if len( ot ) > 0 then row += " [" & ot & "]"
        end if
    end select

    row += " <" & d.lineNo & ":" & d.column & ">"
    outp += row & chr( 10 )

    select case k
    case Fbx.N_UNARY, Fbx.N_ADDROF, Fbx.N_DEREF
        dim as Fbx.UnaryPayload ptr up = @ast.unaries[cast( long, n->data )]
        DumpNode( ast, src, names, up->operand, indent + 1, outp )
    case Fbx.N_BINARY, Fbx.N_MEMBER
        dim as Fbx.BinaryPayload ptr bp = @ast.binaries[cast( long, n->data )]
        DumpNode( ast, src, names, bp->lhs, indent + 1, outp )
        DumpNode( ast, src, names, bp->rhs, indent + 1, outp )
    case Fbx.N_INTRINSIC
        '' An intrinsic can appear INSIDE an expression -- 'open( ... )' yields its
        '' error code. It carries a statement payload, so without this the expression
        '' printer stops at the bare row and every child is invisible to a golden,
        '' which is precisely how a construct that parsed but dropped its arguments
        '' would look.
        dim as Fbx.StmtPayload ptr ip = @ast.stmts[cast( long, n->data )]
        DumpNode( ast, src, names, ip->a, indent + 1, outp )
        DumpNode( ast, src, names, ip->b, indent + 1, outp )
        DumpNode( ast, src, names, ip->c, indent + 1, outp )
        for i as long = 0 to ip->count - 1
            DumpNode( ast, src, names, _
                      cast( Fbx.NodeId, ast.children[ip->first + i] ), indent + 1, outp )
        next
    case Fbx.N_CALL, Fbx.N_INDEX, Fbx.N_PAREN, Fbx.N_TUPLE, Fbx.N_INITIALIZER, Fbx.N_STRCAT
        dim as Fbx.ListPayload ptr lp = @ast.lists[cast( long, n->data )]
        if lp->target <> Fbx.NODE_NONE then
            DumpNode( ast, src, names, lp->target, indent + 1, outp )
        end if
        for i as long = 0 to lp->count - 1
            dim as Fbx.NodeId child = cast( Fbx.NodeId, ast.children[lp->first + i] )
            DumpNode( ast, src, names, child, indent + 1, outp )
        next
    end select
end sub

function Dump _
    ( byref ast as Fbx.AstArena, byref src as Fbx.SourceManager, _
      byref names as Fbx.Interner, byval root as Fbx.NodeId ) as string

    dim as string outp = ""
    DumpNode( ast, src, names, root, 0, outp )
    return outp
end function

end namespace
