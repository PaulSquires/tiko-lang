'' collect.bi -- declaration collection.
''
'' Walks the AST and creates a symbol for every declaration, wiring up scopes.
'' See collect.bas for the contract.

#ifndef __TKO_COLLECT_BI__
#define __TKO_COLLECT_BI__

#include once "tko.bi"
#include once "ast/nodes.bi"
#include once "symbols/symbol.bi"
#include once "types/type.bi"
#include once "diag/engine.bi"
#include once "symbols/resolve.bi"

namespace Tko.Collect

    '' Returns the number of duplicate declarations reported.
    '' 'src' IS OPTIONAL AND ONLY THE DRIVER PASSES IT. It is needed for ONE
    '' question -- did this symbol come from the PRELUDE? -- and a generic
    '' instantiation, which is what One serves, never asks it.
    declare function Run _
        ( byref ast as Tko.AstArena, byval root as Tko.NodeId, _
          byref syms as Tko.SymbolTable, byref names as Tko.Interner, _
          byref types as Tko.TypeContext, byref diags as Tko.DiagnosticEngine, _
          byref info as Tko.SemanticInfo, _
          byval src as Tko.SourceManager ptr = 0 ) as long

    '' COLLECT ONE NODE into an existing scope, for a declaration that did not exist
    '' when Run walked the unit: an instantiated generic member. Run itself cannot be
    '' reused -- it opens a fresh module scope and redeclares the builtins.
    declare function One _
        ( byref ast as Tko.AstArena, byval id as Tko.NodeId, byval scope_ as Tko.ScopeId, _
          byref syms as Tko.SymbolTable, byref names as Tko.Interner, _
          byref types as Tko.TypeContext, byref diags as Tko.DiagnosticEngine, _
          byref info as Tko.SemanticInfo ) as long

    '' --dump-symbols. Byte-stable; lists each scope in declaration order.
    declare function Dump _
        ( byref syms as Tko.SymbolTable, byref names as Tko.Interner, _
          byref types as Tko.TypeContext, byref src as Tko.SourceManager ) as string

end namespace

#endif
