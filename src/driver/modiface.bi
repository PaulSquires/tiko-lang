'' modiface.bi -- a module's interface, read into the units that import it (ADR 0017;
'' RFC-0002 §2, RFC-0004 §4-5). See modiface.bas.

#pragma once

#include once "tko.bi"
#include once "driver/driver.bi"
#include once "pp/pp.bi"
#include once "ast/nodes.bi"
#include once "symbols/symbol.bi"
#include once "symbols/resolve.bi"

namespace Tko.Modules

'' WHICH MODULE OF THE BUILD an '#import' leads to: its index in ctx.ifaceChains, or -1.
declare function ImportIndex( byref ctx as Tko.CompilerContext, byref rec as Tko.PpImport ) as long

'' The preprocessor reads each '#import''s interfaces in where it stands.
declare sub InstallImports( byref ctx as Tko.CompilerContext, byref cfg as Tko.PpConfig )

'' AFTER COLLECT: each interface's namespace linked to its chain for the mangler, its
'' public names marked, and each '#import''s alias bound to it (TKO0862, TKO0863).
declare sub BindImports _
    ( byref ctx as Tko.CompilerContext, byref ast as Tko.AstArena, _
      byref syms as Tko.SymbolTable, byref info as Tko.SemanticInfo, _
      byref imports as Tko.PpImportVec )

'' THE MODULE UNIT JUST CHECKED, as the interface its importers will read.
declare sub PublishInterface _
    ( byref ctx as Tko.CompilerContext, byref pr as Tko.PpResult, _
      byref ast as Tko.AstArena, byref syms as Tko.SymbolTable, _
      byref info as Tko.SemanticInfo )

end namespace
