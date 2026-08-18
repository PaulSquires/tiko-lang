'' pp.bi -- the preprocessor.
''
'' A token transducer: it consumes the lexed token vectors of a file and everything it
'' includes, and produces ONE flat, fully expanded vector for the parser
'' (docs/plan/03 section 6).
''
'' It sits between lexer and parser and knows nothing of grammar, types or symbols.
'' Its '#if' evaluator is deliberately separate from the semantic constant evaluator:
'' it runs before types exist, and coupling them would create the upward dependency
'' the layering forbids (docs/plan/03 section 6.4).
''
'' Invariants:
''   - The output always ends in exactly one TK_EOF.
''   - Tokens produced by macro expansion carry TF_FROM_MACRO and the loc of the USE
''     site, so a diagnostic points where the user wrote something.
''   - Expansion is bounded: a macro is never expanded inside its own expansion (hide
''     sets), and the frame stack has a hard depth cap. Neither can hang.
''   - A file is lexed at most once per compilation, whatever it costs to include.

#ifndef __FBX_PP_BI__
#define __FBX_PP_BI__

#include once "fbx.bi"
#include once "lexer/lexer.bi"
#include once "source/manager.bi"
#include once "diag/engine.bi"
#include once "support/intern.bi"

namespace Fbx

    const PP_MAX_FRAMES     as long = 256    '' expansion + include depth
    const PP_MAX_CONDS      as long = 128    '' #if nesting

    '' Builtin macros that are more than a value: they manipulate their argument
    '' tokens and cannot be expressed as a #define.
    enum PpBuiltin
        PPB_NONE = 0
        PPB_QUOTE            '' __FB_QUOTE__( toks )    -> "toks"
        PPB_UNQUOTE          '' __FB_UNQUOTE__( "s" )   -> s
        PPB_ARG_COUNT        '' __FB_ARG_COUNT__( ... ) -> n
        PPB_JOIN             '' __FB_JOIN__( a, b )     -> ab
        PPB_UNIQUEID         '' __FB_UNIQUEID__( id )   -> a fresh identifier
        PPB_FILE             '' __FILE__ / __FILE_NQ__ / __PATH__
        PPB_FILE_NQ
        PPB_PATH
        PPB_LINE             '' __LINE__
        PPB_DATE
        PPB_TIME
        PPB_FUNCTION         '' __FUNCTION__ -- parser territory; passed through
    end enum

    type IdVec as FB.Array( of ulong )

    type PpMacro
        as InternId  name
        as boolean   isFunc          '' NAME( a, b ) rather than plain NAME
        as boolean   isVariadic      '' last parameter is '...'
        '' '#macro NAME?( a )' -- callable WITH OR WITHOUT parentheses, so 'NAME x' is an
        '' invocation. Opt-in: a plain '#macro NAME( a )' called as 'NAME x' is not a
        '' macro use at all, and fbc reports NAME as an undeclared variable.
        as boolean   optParens
        as boolean   isDefined       '' cleared by #undef rather than removed
        as ubyte     builtin         '' PpBuiltin; 0 for an ordinary macro
        as IdVec     params
        as TokenVec  body
        as SourceLoc loc
    end type

    type MacroVec as FB.Array( of PpMacro )

    type PpConfig
        as StrVec ptr includePaths   '' -i, searched after the including file's dir
        as StrVec ptr defines        '' -d name[=value]
        as boolean    reportUnsupported
        as any ptr    queryCtx       '' passed back to queryFn
        as any ptr    queryFn        '' PpQueryFn; NULL until Phase 5
    end type

    type PpResult
        as TokenVec tokens
        '' One merged literal pool. Token literal indices are rewritten to point here
        '' as they enter, because the per-file pools the lexer produced do not survive
        '' preprocessing -- and the parser needs the payloads.
        as LiteralVec literals
        as long     includeCount
        as long     expansionCount
        as long     maxDepth
    end type

    '' ---------------------------------------------------------------- the stream
    ''
    '' The preprocessor is PULL-based (docs/plan/03 section 6.1): tokens are produced
    '' on demand rather than all at once. That matters for more than memory. A
    '' directive is evaluated only once the consumer has taken everything before it,
    '' which is the precondition for ever answering '#if typeof( x )' -- fbc can do
    '' that because its preprocessor and parser are interleaved (probe P2).
    ''
    '' The buffer only grows, so an index handed out stays valid: the parser can
    '' backtrack freely.
    ''
    '' PpQueryFn is the hook that closes the semantic half of the gap. The
    '' preprocessor calls it for 'typeof' and 'defined' of a symbol it cannot know
    '' about. It is NULL until Phase 5 provides a symbol table, and while it is NULL
    '' such conditions are reported unevaluable rather than guessed.
    enum PpQueryKind
        PPQ_DEFINED = 0      '' is this name a declared symbol?
        PPQ_TYPEOF           '' an opaque type identity for comparison
    end enum

    type PpQueryFn as function _
        ( byval ctx as any ptr, byval kind as PpQueryKind, byval name as InternId, _
          byref answer as longint ) as boolean

    type PpStream
        as any ptr engine        '' opaque PpEngine, owned
        as PpResult ptr outp     '' the growing token buffer
        as boolean finished
    end type

    declare sub PpOpen _
        ( byref st as PpStream, byref src as SourceManager, byval root as FileId, _
          byref names as Interner, byref kwmap as KeywordMap, _
          byref diags as DiagnosticEngine, byref cfg as PpConfig, _
          byref outp as PpResult )

    '' Produce tokens until buffer index 'want' exists. False when input is exhausted
    '' before that, in which case the buffer ends with its single TK_EOF.
    declare function PpEnsure( byref st as PpStream, byval want as long ) as boolean

    declare sub PpClose( byref st as PpStream )

    '' Convenience: open, pump to exhaustion, close. What the non-parsing modes use.
    declare sub PpRun _
        ( byref src as SourceManager, byval root as FileId, _
          byref names as Interner, byref kwmap as KeywordMap, _
          byref diags as DiagnosticEngine, byref cfg as PpConfig, _
          byref outp as PpResult )

    '' --dump-tokens=pp. Byte-stable for identical input.
    declare function PpDump _
        ( byref src as SourceManager, byref names as Interner, _
          byref r as PpResult ) as string

end namespace

#endif
