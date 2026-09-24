'' import.bi -- the C importer: one header in, FreeBASIC declarations out. D16.
''
'' The pipeline, one file per stage:
''
''     import.bas    parse the header with libclang, run the two passes, assemble the text
''     names.bas     what a C name becomes in FreeBASIC, and the rename ledger
''     types.bas     a C type as FreeBASIC type text
''     decls.bas     the declaration walk: typedefs, enums, functions, globals
''     records.bas   structs and unions, which are most of the work
''
'' THE OUTPUT IS TEXT, and tiko computes every layout itself from it. That is the design
'' decision everything else follows from (0016 §2): two independent answers to "how big is
'' this record", clang's and tiko's, which phase C compares. Writing clang's offsets into
'' the symbol table instead would make the binding exactly as right as the importer and
'' check nothing.
''
'' THE FORMAT IS fbc-modern's -cimport-out, deliberately, so the two can be diffed:
'' build/cimportdiff.sh runs both over the same headers and every difference is either a
'' defect or has a recorded reason. Where fbc-modern is wrong tiko does not copy it --
'' each such place says so beside the code.
''
'' DETERMINISTIC: the same headers, options and clang give the same bytes. Nothing iterates
'' a hash table into the output, no absolute path or host name is written, and the text is
'' LF-only.

#pragma once

#include once "tko.bi"
#include once "support/intern.bi"
#include once "cimport/clang.bi"

namespace Tko.CImport

'' ---------------------------------------------------------------- what a caller asks

type CImportOptions
    as Tko.StrVec headers        '' as the user wrote them, in order
    as Tko.StrVec cincludes      '' -cinclude: clang's -I
    as Tko.StrVec cdefines       '' -cdefine: clang's -D
    as string     csysroot       '' -csysroot
    as Tko.StrVec copts          '' -copt: passed to clang verbatim
    as boolean    noMacros       '' -cnomacros
    as string     targetName     '' "win64-msvc", "win64", "linux-x86_64"
    as string     triple         '' TargetFor( t ).triple
    as boolean    isWindows
    as string     clangExe       '' the toolchain's clang; libclang is looked for beside it
    '' Records to refuse, by FreeBASIC name, with the reason for the ledger: the ones whose
    '' layout tiko could not reproduce last time round (driver/cimportverify.bas).
    as Tko.StrVec refuseName
    as Tko.StrVec refuseWhy
    '' A DELTA IMPORT: what an earlier import of the headers before these decided
    '' (state.bas). Empty for an import of its own.
    as string     seedState
    '' WHAT THE MACRO PROBES FOUND, kept for the next round: a refused record changes no
    '' macro's value, and the probes are two more parses of the whole unit. 0 not probed
    '' yet, 1 kept here, -1 the probe failed.
    as long       macroValState
    as Tko.StrVec macroValues
    as long       macroExpState
    as Tko.StrVec macroExps
end type

type CImportResult
    as string     text           '' the binding, LF-only
    as string     manifest       '' "record <name> <size> <align>" / "  field <name> <bit> <width>"
    as long       rc             '' 0 imported, 1 clang could not parse it, 3 no usable libclang
    as string     why            '' the failure in one line
    as Tko.StrVec clangDiags     '' clang's own error lines, at most ten
    as boolean    notFound       '' a header it included was not found: the target's hint
    as boolean    namedNotFound  '' a header the user named was not found: -cinclude
    as Tko.StrVec deps           '' every file clang read -- the cache's dependency list
    as string     state          '' what this import decided, to seed the next (state.bas)
end type

declare function CImportRun( byref api as ClangApi, byref opts as CImportOptions, _
                             byref res as CImportResult ) as boolean

'' ---------------------------------------------------------------- inside one import
''
'' Everything below is shared by the importer's own files and nothing else.

'' The two namespaces a FreeBASIC name lives in, as far as the importer is concerned: a
'' TYPE and a procedure may share a name (INITCOMMONCONTROLSEX beside InitCommonControlsEx,
'' 'struct stat' beside stat()), two types may not, and nor may two values.
enum CImpNs
    NS_TYPE = 0
    NS_VALUE = 1
end enum

'' The kinds a rename is reported under -- fbc-modern's four, in its spelling.
enum CImpRenameKind
    RK_TYPE = 0
    RK_PROC
    RK_VAR
    RK_CONST
end enum

'' Per-USR state bits. A USR is clang's unique name for an entity, and the same entity is
'' seen more than once: a forward declaration and its definition, a redeclaration.
const US_DEFINED   = &h01     '' a definition exists somewhere in the translation unit
const US_EMITTED   = &h02     '' its declaration is in the output
const US_REFUSED   = &h04     '' it was skipped; whatever names it points at nothing
const US_FWD       = &h08     '' a 'Name__ptr' forward alias exists for it
const US_OPAQUE    = &h10     '' declared and never defined: 'type X as any'
const US_NAMED     = &h20     '' pass 1 gave it a FreeBASIC name
const US_TYPEDEFD  = &h40     '' an anonymous record named by a typedef
const US_SEEDED    = &h80     '' decided by an earlier import (state.bas); never exported

type CImp
    as ClangApi ptr api
    as CImportOptions ptr opts
    as any ptr tu

    '' NAMES. Every C name and every USR is interned here; the claim tables and the
    '' per-USR tables are indexed by the interned id, the claim tables by its FOLDED id,
    '' because FreeBASIC is case-insensitive.
    as Tko.Interner strs
    as FB.Array( of ubyte ) claimType       '' folded id -> 1 when a type holds that name
    as FB.Array( of ubyte ) claimValue      '' folded id -> 1 when a value does
    as FB.Array( of long )  usrName         '' USR id -> index into fbNames plus one
    as FB.Array( of ubyte ) usrState        '' USR id -> US_* bits
    as Tko.StrVec           fbNames

    '' THE OUTPUT, in the order it will be written.
    as Tko.StrVec decls                     '' one declaration each, possibly several lines
    as Tko.StrVec fwdLines                  '' 'type X__ptr as X ptr', hoisted
    as Tko.StrVec fwdUsr                    '' the USR each forward alias stands for
    deferred( any ) as CXCursor             '' typedefs waiting for the record they name;
    as long       nDeferred                 '' a cursor lives as long as the translation unit
    as boolean    needsCLong                '' crt/long.bi for clong/culong
    as long       nStatic                   '' static and inline functions: counted, not ledgered

    '' THE LEDGERS.
    as FB.Array( of long ) renKind
    as FB.Array( of long ) renWhy           '' 0 reserved, 1 case-insensitive collision
    as Tko.StrVec renC
    as Tko.StrVec renFb
    as Tko.StrVec skipKind
    as Tko.StrVec skipName
    as Tko.StrVec skipWhy

    '' THE MANIFEST: clang's layout of every record emitted, for phase C's comparison.
    as Tko.StrVec manifest

    '' Scratch for the record currently being emitted: its USR, so a self-reference is
    '' 'Name ptr' rather than a forward alias to itself.
    as string curRecordUsr

    '' MACROS. The object-like candidates in definition order, and what a C name that this
    '' import declared resolves to -- an alias may only name something that arrived.
    as Tko.StrVec macroNames
    as FB.Array( of ubyte ) macroSeen       '' exact name id -> 1 once a candidate
    as Tko.StrVec aliasNames                '' every '#define NAME target' written
    as FB.Array( of long ) seedUndefined    '' seeded USR ids the seed never saw defined
    as FB.Array( of long ) cDeclUsr          '' exact C-name id -> USR id plus one
    '' The parse, kept so macros.bas can parse again with its probes appended.
    as string     unitText
    as Tko.StrVec args
end type

'' ---- names.bas
declare function NameReservedType( byref n as string ) as boolean
declare function NameReservedValue( byref n as string ) as boolean
declare function NameReservedField( byref n as string ) as boolean
declare function NameClaim( byref x as CImp, byval ns as CImpNs, byref cname as string, _
                            byval rk as CImpRenameKind ) as string
declare function NameField( byref cname as string, byval isArray as boolean ) as string
declare function NameParam( byref cname as string ) as string
declare function UsrId( byref x as CImp, byref usr as string ) as long
declare function UsrState( byref x as CImp, byval id as long ) as ubyte
declare sub UsrSet( byref x as CImp, byval id as long, byval bits as ubyte )
declare function UsrFbName( byref x as CImp, byval id as long ) as string
declare sub UsrSetName( byref x as CImp, byval id as long, byref fb as string )
declare function RenameLine( byref x as CImp, byval i as long ) as string
declare function NameTaken( byref x as CImp, byref n as string ) as boolean

'' ---- types.bas
declare function TypeText( byref x as CImp, byval t as CXType, byref why as string ) as string
declare function FnTypeText( byref x as CImp, byval t as CXType, byref why as string ) as string
declare function ParamTypeText( byref x as CImp, byval t as CXType, byref why as string ) as string
declare function CursorUsr( byref x as CImp, byval c as CXCursor ) as string
declare function CursorName( byref x as CImp, byval c as CXCursor ) as string
declare function Unwrap( byref x as CImp, byval t as CXType ) as CXType

'' ---- decls.bas
declare sub DeclPassNames( byref x as CImp )
declare sub DeclPassEmit( byref x as CImp )
declare sub Skip( byref x as CImp, byref kind as string, byref name_ as string, byref why as string )
declare sub NoteDecl( byref x as CImp, byref cname as string, byval uid as long )

'' ---- macros.bas
declare sub MacroCandidate( byref x as CImp, byval c as CXCursor )
declare sub MacroPass( byref x as CImp )
declare sub MacroSeen( byref x as CImp, byref n as string )
declare sub NameSeedClaim( byref x as CImp, byval ns as CImpNs, byref n as string )
declare function StateExport( byref x as CImp ) as string
declare function StateSeed( byref x as CImp, byref state as string ) as boolean
declare function StateConflict( byref x as CImp ) as string
declare function JoinParts( byref parts as Tko.StrVec ) as string

'' ---- records.bas
declare function RecordEmit( byref x as CImp, byval c as CXCursor, byref fbName as string, _
                             byref why as string ) as boolean
declare function RecordIsUnion( byref x as CImp, byval c as CXCursor ) as boolean

end namespace
