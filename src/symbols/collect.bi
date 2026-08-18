'' collect.bi -- declaration collection.
''
'' Walks the AST and creates a symbol for every declaration, wiring up scopes.
'' See collect.bas for the contract.

#ifndef __FBX_COLLECT_BI__
#define __FBX_COLLECT_BI__

#include once "fbx.bi"
#include once "ast/nodes.bi"
#include once "symbols/symbol.bi"
#include once "types/type.bi"
#include once "diag/engine.bi"
#include once "symbols/resolve.bi"

namespace Fbx.Collect

    '' Returns the number of duplicate declarations reported.
    declare function Run _
        ( byref ast as Fbx.AstArena, byval root as Fbx.NodeId, _
          byref syms as Fbx.SymbolTable, byref names as Fbx.Interner, _
          byref diags as Fbx.DiagnosticEngine, byref info as Fbx.SemanticInfo ) as long

    '' --dump-symbols. Byte-stable; lists each scope in declaration order.
    declare function Dump _
        ( byref syms as Fbx.SymbolTable, byref names as Fbx.Interner, _
          byref types as Fbx.TypeContext ) as string

end namespace

#endif
