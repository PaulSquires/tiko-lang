'' lexer.bi -- one file of normalised UTF-8 becomes one token vector.
''
'' The lexer knows nothing about grammar, symbols or directives. It does not process
'' string escapes either: OPTION ESCAPE changes what a plain "..." means and is a
'' statement the parser sees, so literal payloads are recorded as raw spans and
'' decoded later (docs/plan/03 section 5.1). That also keeps the hot loop free of it.
''
'' Performance shape (docs/plan/03 section 5.2): one pass, no backtracking, no regex,
'' a dispatch on the first byte, and interning as the only allocation per token.
''
'' Invariants:
''   - Always returns a vector ending in exactly one TK_EOF.
''   - Never aborts. A bad byte produces TK_INVALID and scanning continues.
''   - Every token's [loc, loc+length) lies inside the file.

#ifndef __FBX_LEXER_BI__
#define __FBX_LEXER_BI__

#include once "fbx.bi"
#include once "lexer/token.bi"
#include once "source/manager.bi"
#include once "diag/engine.bi"

namespace Fbx.Lex

    '' Interns every keyword spelling, in table order, into a freshly built interner.
    '' MUST be called before anything else is interned, or the contiguous-id property
    '' the keyword map depends on is lost.
    declare sub InitKeywords _
        ( byref names as Fbx.Interner, byref map as Fbx.KeywordMap )

    type Result
        as Fbx.TokenVec   tokens
        as Fbx.LiteralVec literals
        as long           invalidCount
    end type

    declare sub Run _
        ( byref src as Fbx.SourceManager, byval file as Fbx.FileId, _
          byref names as Fbx.Interner, byref kwmap as Fbx.KeywordMap, _
          byref diags as Fbx.DiagnosticEngine, byref outp as Result )

    '' --dump-tokens. Byte-stable for identical input: it is a golden artefact.
    declare function Dump _
        ( byref src as Fbx.SourceManager, byval file as Fbx.FileId, _
          byref names as Fbx.Interner, byref r as Result ) as string

end namespace

#endif
