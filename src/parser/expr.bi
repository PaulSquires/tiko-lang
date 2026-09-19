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

#ifndef __TKO_EXPR_BI__
#define __TKO_EXPR_BI__

#include once "tko.bi"
#include once "ast/nodes.bi"
#include once "parser/prectable.bi"
#include once "lexer/token.bi"
#include once "lexer/lexer.bi"
#include once "source/manager.bi"
#include once "diag/engine.bi"
#include once "support/intern.bi"

namespace Tko

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
        '' The keyword table, so the parser can LEX a prelude of its own. fbc predeclares
        '' a set of runtime procedures -- 'kill', 'sleep', 'locate' -- that are in no
        '' header and are not reserved words either: 'dim as long kill' is a DUPLICATED
        '' DEFINITION, not a syntax error. Writing them as source and lexing it is what
        '' lets them be declared the way everything else is.
        as any ptr              kw          '' KeywordTable ptr, or 0 for no prelude
        as long                 depth
        '' How many TYPE/UNION bodies enclose the cursor. An anonymous 'union' or
        '' 'type' is legal ONLY inside one; at module level a bare 'type' is an error
        '' worth keeping, so the two cases are told apart by this rather than by
        '' silently accepting both.
        as long                 aggDepth
        '' How many PROCEDURE BODIES enclose the cursor. Only module-level declarations
        '' are told to the preprocessor for 'defined( X )', because fbc's answer is
        '' scope-respecting: measured, a local or a parameter is NOT visible to
        '' 'defined' once its procedure has ended. Recording one would make a later
        '' '#ifndef' skip a declaration it should have taken -- silently.
        as long                 procDepth
        '' THE CONVENTION A PROCEDURE GETS WHEN IT WRITES NONE -- fbc's 'fbcall', stdcall
        '' on Windows and cdecl on Linux. Only the '...' rule reads it (CheckVarargConv_),
        '' and CC_NONE, the default, turns that rule off: the prelude and a generic
        '' re-parse re-read text the unit's own parse has already asked about.
        as ubyte                fbcallConv
        '' ...and the default the enclosing EXTERN block gives instead: cdecl for "C" and
        '' "C++", stdcall for "Windows" and "Windows-MS", CC_NONE for "rtlib" and outside
        '' any block, where the target's applies.
        as ubyte                externConv
        '' A '...' REFUSED WHILE SILENT, as (node, diagnostic, convention) triples. A
        '' speculative parse reports nothing, and the one whose result is KEPT --
        '' 'typeof( sub( ..., ... ) )' -- owes the report afterwards; see
        '' FlushVarargPending_.
        as FB.Array( of ulong ) varargPending
        '' THE LIBRARIES 'declare ... lib "name"' ASKS FOR. The clause was parsed and
        '' the name THROWN AWAY, so 'declare function SHCreateItemFromParsingName lib
        '' "shell32"' linked against nothing -- 'undefined symbol', with the library
        '' sitting in the toolchain all along. Interned ids, drained by the driver
        '' into the same list '#inclib' feeds.
        as FB.Array( of ulong ) declLibs
        as long                 errors
        as boolean              silent      '' suppress cascades after an error
        '' LAMBDAS, HOISTED. 'function( ) as long ... end function' written where an
        '' expression belongs is an ordinary procedure with a generated name --
        '' measured, fbc emits one and assigns its ADDRESS -- so the N_PROC is moved
        '' to module level and the expression becomes '@<that name>'. Collected here
        '' because the expression parser has no way to reach the module's child list.
        '' Inside a PROCPTR argument list, where 'T.+=' and 'T.[]' name a member by
        '' its OPERATOR token rather than by a word. Nowhere else in an expression is
        '' an operator legal after a dot, so the member parser only accepts one while
        '' this is set.
        as boolean              inProcPtrArg
        as NodeIdVec            lambdas
        as long                 lambdaSeq
        '' HOW MANY ANONYMOUS NAMESPACES have been opened. 'namespace' with no name
        '' is legal, and two of them are two DIFFERENT namespaces -- fbc names them
        '' LABEL$2, LABEL$7 from a counter of its own. A LINE NUMBER will not do:
        '' every token of a macro expansion carries the INVOCATION's location, so
        '' 508 expansions of one macro all report the same line and collide.
        as long                 anonNsSeq
        '' How many GENERIC procedure bodies enclose the cursor. A lambda written
        '' inside one is a TEMPLATE like the body around it -- its own body names the
        '' generic's type parameters, which stand for nothing at module level -- so it
        '' is hoisted carrying PF_GENERIC_PROC and lowering leaves it alone. Each
        '' INSTANTIATION re-parses the body and hoists a lambda of its own, with the
        '' flag cleared and a sequence number no other instantiation can produce.
        as long                 genericDepth
        '' How many 'var (a, b) = expr' declarations have been desugared. Each needs a
        '' temporary of its own: two in one loop body, or one nested inside another,
        '' must not name the same thing.
        as long                 destructureSeq
        '' Inside the THEN-BRANCH OF A SINGLE-LINE IF, where an ELSE on the same line
        '' belongs to that IF and not to the statement being parsed. EndOfStatement
        '' otherwise walks to the line's end and DISCARDS whatever it passes, which is
        '' how 'if c then a else b' lost its else branch in silence.
        as boolean              stopAtElse
    end type

end namespace

namespace Tko.Parse

'' Defined in intrinsics.bas: 'open( ... )' used as an EXPRESSION. Declared here
'' because Primary needs it and expr.bas is compiled before that file.
declare function OpenExprCall( byref p as Tko.ParserState ) as Tko.NodeId
declare function GetPutExprCall( byref p as Tko.ParserState ) as Tko.NodeId
declare function CloseExprCall( byref p as Tko.ParserState ) as Tko.NodeId

'' Defined in decl.bas: an ANONYMOUS procedure used as a value --
''   dim as function( byref as T, byref as T ) as boolean less = _
''       function( byref x as T, byref y as T ) as boolean
''           return x < y
''       end function
'' Same routing reason as OpenExprCall: Primary needs it, decl.bas is compiled later.
declare function TryLambdaExpr( byref p as Tko.ParserState ) as Tko.NodeId
declare function ArgOrElided _
    ( byref p as Tko.ParserState, byval closer as Tko.TokenKind ) as Tko.NodeId

    declare function Expression _
        ( byref p as Tko.ParserState, byval minPrec as long = 1 ) as Tko.NodeId

    '' Parse one whole token vector as a single expression. Used by the expression
    '' tests and by the precedence differential harness.
    declare function OneExpression( byref p as Tko.ParserState ) as Tko.NodeId

    '' Shared with parser.bas. Not private: the statement layer is a separate module.
    '' True when buffer index 'want' exists, pulling from the preprocessor if needed.
    declare function HasTok( byref p as Tko.ParserState, byval want as long ) as boolean
    declare function Peek( byref p as Tko.ParserState ) as Tko.TokenKind
    declare function Cur( byref p as Tko.ParserState ) as Tko.Token
    declare sub Advance( byref p as Tko.ParserState )
    declare function Accept( byref p as Tko.ParserState, byval k as Tko.TokenKind ) as boolean
    '' Lives in decltype.bas: a calling convention, and with 'nameless' the
    '' OVERLOAD and ALIAS that may sit where a CONSTRUCTOR's name would be.
    declare function TakeProcPrefix_ _
        ( byref p as Tko.ParserState, byref sp as Tko.StmtPayload, _
          byval nameless as boolean = false ) as boolean

    declare function ErrorNode _
        ( byref p as Tko.ParserState, byval id as Tko.DiagId, _
          byval a0 as string = "" ) as Tko.NodeId
    declare function Expect _
        ( byref p as Tko.ParserState, byval k as Tko.TokenKind, _
          byval what as string ) as boolean
    declare function MakeIdent( byref p as Tko.ParserState, byref t as Tko.Token ) as Tko.NodeId
    '' A token as the node it is: literals stay literals. See the comment on it.
    declare function MakeTokenNode _
        ( byref p as Tko.ParserState, byref t as Tko.Token ) as Tko.NodeId
    declare function MakeList _
        ( byref p as Tko.ParserState, byval kind as Tko.NodeKind, byval loc as Tko.SourceLoc, _
          byval target as Tko.NodeId, byref items as Tko.NodeIdVec ) as Tko.NodeId
    declare sub MarkCallTarget_( byref p as Tko.ParserState, byval n as Tko.NodeId )
    declare function MakeStmt _
        ( byref p as Tko.ParserState, byval kind as Tko.NodeKind, byval loc as Tko.SourceLoc, _
          byref sp as Tko.StmtPayload ) as Tko.NodeId
    declare function MakeAddrOfName _
        ( byref p as Tko.ParserState, byval nm as Tko.InternId, _
          byval loc as Tko.SourceLoc, byval spellOff as long, _
          byval spellLen as long ) as Tko.NodeId

    declare function NewNodeAt _
        ( byref p as Tko.ParserState, byval kind as Tko.NodeKind, byval loc as Tko.SourceLoc, _
          byval payload as ulong ) as Tko.NodeId

    declare function Dump _
        ( byref ast as Tko.AstArena, byref src as Tko.SourceManager, _
          byref names as Tko.Interner, byval root as Tko.NodeId ) as string

end namespace

#endif
