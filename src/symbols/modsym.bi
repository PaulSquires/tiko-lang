'' modsym.bi -- which symbols are module code, and what a module lets out (ADR 0017). See
'' modsym.bas.

#pragma once

#include once "tko.bi"
#include once "symbols/symbol.bi"
#include once "symbols/resolve.bi"
#include once "ast/nodes.bi"
#include once "source/manager.bi"
#include once "diag/engine.bi"

namespace Tko.ModSym

'' THE UNIT IS A MODULE: these are its files, and its chain is 'acme.net.http'.
declare sub Begin _
    ( byref syms as Tko.SymbolTable, byref files as Tko.FileIdVec, byref chain as string )

'' AFTER COLLECT, BEFORE RESOLVE (generic instances copy their generic's marks as they are
'' made). SYMF_MODSRC on every symbol declared at module or namespace level in a file of
'' the unit; SYMF_PUBLIC / SYMF_PRIVDECL where the declaration said 'public' / 'private'.
declare sub Mark _
    ( byref ast as Tko.AstArena, byref syms as Tko.SymbolTable, _
      byref info as Tko.SemanticInfo, byref src as Tko.SourceManager, _
      byref diags as Tko.DiagnosticEngine )

'' A PROCEDURE'S LINKAGE, as module code (RFC-0002 §4): 'private' is internal, as always;
'' 'public' is an ordinary external symbol; and everything else -- the default -- is
'' external but HIDDEN, and never dllexported: other files of the module and an importer's
'' instantiation of an exported generic can call it, and nothing outside the program can.
declare sub ProcLinkage _
    ( byref syms as Tko.SymbolTable, byval sid as Tko.SymbolId, _
      byref isPrivate as boolean, byref isExported as boolean, byref isHidden as boolean )

'' A SYMBOL MADE AFTER Mark -- a generic instance's re-parsed body -- takes its generic's
'' module marks.
declare sub Inherit( byref syms as Tko.SymbolTable, byval sid as Tko.SymbolId, byval from as Tko.SymbolId )

end namespace
