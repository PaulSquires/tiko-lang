'' expr.bi -- the expression parser.
''
'' A Pratt engine over the measured precedence table. The parser is a pure function of
'' the token stream: it never consults symbols or types (docs/plan/01 section 1).
''
'' Invariants:
''   - Always returns a valid NodeId. On failure that is an N_ERROR node, and a
''     diagnostic has been emitted for it.
''   - Never consumes TK_EOL or TK_EOF: statements own their terminators.
''   - Recursion is capped, so no input can overflow the stack.

#ifndef __FBX_EXPR_BI__
#define __FBX_EXPR_BI__

#include once "fbx.bi"
#include once "ast/nodes.bi"
#include once "parser/prectable.bi"
#include once "lexer/token.bi"
#include once "source/manager.bi"
#include once "diag/engine.bi"
#include once "support/intern.bi"

namespace Fbx

    const PARSE_MAX_DEPTH as long = 256

    type ParserState
        as TokenVec ptr         toks
        '' When set, the token buffer is filled ON DEMAND from the preprocessor
        '' (docs/plan/03 section 6.1). The buffer only grows, so a saved p.pos stays
        '' valid and backtracking is unaffected.
        as any ptr              stream      '' PpStream ptr, or 0 for a fixed vector
        as LiteralVec ptr       litPool     '' the lexer's literal pool for these tokens
        as long                 pos
        as AstArena ptr         ast
        as SourceManager ptr    src
        as Interner ptr         names
        as DiagnosticEngine ptr diags
        as long                 depth
        '' How many TYPE/UNION bodies enclose the cursor. An anonymous 'union' or
        '' 'type' is legal ONLY inside one; at module level a bare 'type' is an error
        '' worth keeping, so the two cases are told apart by this rather than by
        '' silently accepting both.
        as long                 aggDepth
        as long                 errors
        as boolean              silent      '' suppress cascades after an error
    end type

end namespace

namespace Fbx.Parse

'' Defined in intrinsics.bas: 'open( ... )' used as an EXPRESSION. Declared here
'' because Primary needs it and expr.bas is compiled before that file.
declare function OpenExprCall( byref p as Fbx.ParserState ) as Fbx.NodeId

'' Defined in decl.bas: an ANONYMOUS procedure used as a value --
''   dim as function( byref as T, byref as T ) as boolean less = _
''       function( byref x as T, byref y as T ) as boolean
''           return x < y
''       end function
'' Same routing reason as OpenExprCall: Primary needs it, decl.bas is compiled later.
declare function TryLambdaExpr( byref p as Fbx.ParserState ) as Fbx.NodeId
declare function ArgOrElided _
    ( byref p as Fbx.ParserState, byval closer as Fbx.TokenKind ) as Fbx.NodeId

    declare function Expression _
        ( byref p as Fbx.ParserState, byval minPrec as long = 1 ) as Fbx.NodeId

    '' Parse one whole token vector as a single expression. Used by the expression
    '' tests and by the precedence differential harness.
    declare function OneExpression( byref p as Fbx.ParserState ) as Fbx.NodeId

    '' Shared with parser.bas. Not private: the statement layer is a separate module.
    '' True when buffer index 'want' exists, pulling from the preprocessor if needed.
    declare function HasTok( byref p as Fbx.ParserState, byval want as long ) as boolean
    declare function Peek( byref p as Fbx.ParserState ) as Fbx.TokenKind
    declare function Cur( byref p as Fbx.ParserState ) as Fbx.Token
    declare sub Advance( byref p as Fbx.ParserState )
    declare function Accept( byref p as Fbx.ParserState, byval k as Fbx.TokenKind ) as boolean
    declare function ErrorNode _
        ( byref p as Fbx.ParserState, byval id as Fbx.DiagId, _
          byval a0 as string = "" ) as Fbx.NodeId
    declare function Expect _
        ( byref p as Fbx.ParserState, byval k as Fbx.TokenKind, _
          byval what as string ) as boolean
    declare function MakeIdent( byref p as Fbx.ParserState, byref t as Fbx.Token ) as Fbx.NodeId
    '' A token as the node it is: literals stay literals. See the comment on it.
    declare function MakeTokenNode _
        ( byref p as Fbx.ParserState, byref t as Fbx.Token ) as Fbx.NodeId
    declare function MakeList _
        ( byref p as Fbx.ParserState, byval kind as Fbx.NodeKind, byval loc as Fbx.SourceLoc, _
          byval target as Fbx.NodeId, byref items as Fbx.NodeIdVec ) as Fbx.NodeId
    declare function MakeStmt _
        ( byref p as Fbx.ParserState, byval kind as Fbx.NodeKind, byval loc as Fbx.SourceLoc, _
          byref sp as Fbx.StmtPayload ) as Fbx.NodeId
    declare function NewNodeAt _
        ( byref p as Fbx.ParserState, byval kind as Fbx.NodeKind, byval loc as Fbx.SourceLoc, _
          byval payload as ulong ) as Fbx.NodeId

    declare function Dump _
        ( byref ast as Fbx.AstArena, byref src as Fbx.SourceManager, _
          byref names as Fbx.Interner, byval root as Fbx.NodeId ) as string

end namespace

#endif
