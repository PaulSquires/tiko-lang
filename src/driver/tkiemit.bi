'' tkiemit.bi -- a module's interface, written as tiko source (ADR 0017; RFC-0004). See
'' tkiemit.bas.

#pragma once

#include once "tko.bi"
#include once "driver/driver.bi"
#include once "ast/nodes.bi"
#include once "symbols/symbol.bi"
#include once "symbols/resolve.bi"

namespace Tko.Modules

'' THE NAMESPACE AN INTERFACE IS WRAPPED IN, for the module 'acme.net.http':
'' '__tko_mod_acme_net_http'. No source spelling of a module reaches it -- an importer names
'' the module through its alias -- and the chain it stands for is the driver's to supply.
declare function InterfaceNamespace( byref chain as string ) as string

'' THE INTERFACE OF THE MODULE UNIT just checked: its declarations, from its own tokens after
'' preprocessing, with procedure bodies dropped and shared variables turned into externs
'' that link by the module's names. Everything declared 'private' stays out. A name the
'' module spells through one of its imports' aliases -- 'esc.Url' -- is written through
'' that import's namespace instead (aliases[k] -> spaces[k]): the alias is the module's
'' file's, and means nothing in an importer.
declare function WriteInterface _
    ( byref ctx as Tko.CompilerContext, byref toks as Tko.TokenVec, _
      byref ast as Tko.AstArena, byref syms as Tko.SymbolTable, _
      byref info as Tko.SemanticInfo, byref aliases as Tko.StrVec, _
      byref spaces as Tko.StrVec ) as string

end namespace
