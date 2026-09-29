'' scan.bi -- THE EDITOR SCAN: the front end run for its SYMBOLS, not for code.
''
'' What tikoParser.dll (src/api) and '--dump-scan' share. A scan runs a unit through
'' preprocess, parse, Collect, Resolve and Check -- never MIR -- and harvests the symbol
'' table into flat records an editor can index: kind, name as written, type as text,
'' owner, file and line, the body's line range, a few flags, and how often each symbol is
'' read and written.
''
'' The records are the DLL's contract (src/api/tikoparser.bi): the numbering of the
'' kinds and flags below IS that contract, and was fixed by the editor that came before
'' tiko -- its fbc-based scanner used exactly these values.
''
'' #IMPORT. The modules a root imports are scanned first, front end only, and their
'' module-level PUBLIC symbols are then re-parented under the root's alias for them: a
'' NAMESPACE record at the '#import' line, so 'middle.Twice' finds Twice as a child of
'' 'middle', located in the module's own source. So are the macros a module '#export's --
'' a facade (RFC-0009) is nothing else -- as DEFINE records at their '#define', the body
'' as their type text, and, when the body names a declaration ('FB.PathJoin'), that
'' declaration's file and line as the record's REF.

#pragma once

#include once "tko.bi"

namespace Tko.Scan

    '' KINDS -- TKP_KIND_* in the DLL's header.
    const SK_SUB       = 1
    const SK_FUNCTION  = 2
    const SK_PARAM     = 3
    const SK_TYPE      = 4
    const SK_UNION     = 5
    const SK_FIELD     = 6
    const SK_ENUM      = 7
    const SK_ENUMVAL   = 8
    const SK_VAR       = 9
    const SK_CONST     = 10
    const SK_TYPEDEF   = 11
    const SK_DEFINE    = 12
    const SK_NAMESPACE = 13

    '' FLAGS -- TKP_SYMBFLAG_* in the DLL's header.
    const SF_BYREF      = &h0001    '' BYREF parameter, or a 'dim byref'
    const SF_SHARED     = &h0002
    const SF_STATIC     = &h0004
    const SF_UDTTYPE    = &h0008    '' declared AS a TYPE/UNION, directly or through ptr
    const SF_ENUMTYPE   = &h0010    '' declared AS an ENUM
    const SF_LOCAL      = &h0020    '' declared inside a procedure body
    const SF_INSTANCE   = &h0040    '' the implicit THIS
    const SF_OPTIONAL   = &h0080    '' a parameter with a default value
    const SF_ARRAY      = &h0100    '' an array variable or field, or an array parameter
    const SF_REFTRACKED = &h0200    '' reads/writes are MEANINGFUL; when clear, UNKNOWN
    const SF_EXPORT     = &h0400    '' an EXPORTed procedure

    type ScanSym
        as long   kind
        as long   flags
        as string name          '' UTF-8, the spelling as written
        as string typeText      '' "" = none
        as long   parent        '' index into ScanResult.syms, -1 at top level
        as long   file          '' index into ScanResult.files, -1 if unknown
        as long   line          '' 1-based; 0 = unknown
        as long   col
        as long   bodyLine      '' a procedure with a body: its header line
        as long   bodyEndLine   '' ...and the line its END is on; 0 if declare-only
        as long   reads
        as long   writes
        as long   refFile       '' what an exported macro names: its declaration; -1 if none
        as long   refLine
        '' ---- bookkeeping, never exported ----
        as string  chain        '' the module a record came from; "" for a root's own
        as boolean isPublic     '' a module-level PUBLIC symbol of that module
        as boolean dropped      '' removed by Finish (a module nothing here imports)
    end type
    type ScanSymVec as FB.Array( of ScanSym )

    type ScanDiag
        as long   code          '' the TKO number
        as long   file
        as long   line
        as string text          '' UTF-8
    end type
    type ScanDiagVec as FB.Array( of ScanDiag )

    type ScanResult
        as ScanSymVec  syms
        as StrVec      files    '' absolute paths as tiko spells them
        as ScanDiagVec diags
        '' ---- input: the root's text, when the caller scans an unsaved buffer ----
        as boolean     hasRootText
        as string      rootText
        '' ---- bookkeeping: the root's '#import' aliases, as (record, module chain) ----
        as FB.Array( of long ) aliasRec
        as StrVec      aliasChain
        '' ---- set while the modules a root imports are being scanned ----
        as boolean     importing
        declare function FileIndex( byref absPath as string ) as long
    end type

end namespace

#include once "driver/driver.bi"
#include once "parser/parser.bi"
#include once "pp/pp.bi"
#include once "symbols/resolve.bi"

namespace Tko.Scan

    '' ONE UNIT, after Collect: Resolve, Check, publish a module's interface for what imports
    '' it, and harvest. Called by CompileUnit in place of its build path when ctx.scan is set.
    declare sub RunUnit _
        ( byref ctx as Tko.CompilerContext, byref ast as Tko.AstArena, _
          byval root as Tko.NodeId, byref syms as Tko.SymbolTable, _
          byref info as Tko.SemanticInfo, byref p as Tko.ParserState, _
          byref pr as Tko.PpResult, byref macros as Tko.MacroInfoVec )

    '' AFTER EVERY UNIT: attach each imported module's public symbols to the root's alias
    '' for it, drop what the root cannot see, and collect the diagnostics.
    declare sub Finish( byref ctx as Tko.CompilerContext )

    '' '--dump-scan'. Files are printed by NAME, not path, so a golden holds on any machine.
    declare function Dump( byref r as ScanResult ) as string

end namespace
