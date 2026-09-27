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

#ifndef __TKO_PP_BI__
#define __TKO_PP_BI__

#include once "tko.bi"
#include once "lexer/lexer.bi"
#include once "source/manager.bi"
#include once "diag/engine.bi"
#include once "support/intern.bi"

namespace Tko

    const PP_MAX_FRAMES     as long = 256    '' expansion + include depth
    const PP_MAX_CONDS      as long = 128    '' #if nesting

    '' Builtin macros that are more than a value: they manipulate their argument
    '' tokens and cannot be expressed as a #define.
    enum PpBuiltin
        PPB_NONE = 0
        PPB_QUOTE            '' __FB_QUOTE__( toks )    -> "toks"
        PPB_UNQUOTE          '' __FB_UNQUOTE__( "s" )   -> s
        PPB_ARG_COUNT        '' __FB_ARG_COUNT__( ... ) -> n
        PPB_ARG_EXTRACT      '' __FB_ARG_EXTRACT__( i, ... )    -> argument i
        '' __FB_ARG_LEFTOF__( text, tok [, else] ) -> the tokens before the FIRST
        '' 'tok' in 'text', and __FB_ARG_RIGHTOF__ the ones after it. See macro.bas
        '' for the measured rules; the ones that are not guessable are that the
        '' needle must be exactly ONE token and that an EMPTY RESULT -- not just a
        '' missing needle -- is what reaches for the third argument.
        '' __FB_IIF__( cond, a, b ) -- a PREPROCESSOR conditional. 'cond' is a
        '' constant expression evaluated here, exactly as '#if' evaluates one, and
        '' only the arm it selects reaches the output.
        PPB_IIF
        PPB_ARG_LEFTOF
        PPB_ARG_RIGHTOF
        PPB_ARG_LISTEXPAND   '' __FB_ARG_LISTEXPAND__( M, n, ... ) -> M( chunk ) ...
        PPB_JOIN             '' __FB_JOIN__( a, b )     -> ab
        '' __FB_EVAL__( expr ) -- FOLD THE ARGUMENT AND RE-EMIT IT AS A CANONICAL
        '' LITERAL. Measured: expression position only (there is no '#__FB_EVAL__'
        '' directive -- fbc error 17), exactly one argument, and the argument is
        '' MACRO-EXPANDED first. See macro.bas for what each result renders as.
        PPB_EVAL
        PPB_UNIQUEID         '' __FB_UNIQUEID__( id )      -> the name's current id
        PPB_UNIQUEID_PUSH    '' __FB_UNIQUEID_PUSH__( id ) -> nothing; makes a new one
        PPB_UNIQUEID_POP     '' __FB_UNIQUEID_POP__( id )  -> nothing; restores the last
        PPB_FILE             '' __FILE__ / __FILE_NQ__ / __PATH__
        PPB_FILE_NQ
        PPB_PATH
        PPB_LINE             '' __LINE__
        PPB_DATE
        PPB_DATE_ISO        '' __DATE_ISO__ -- YYYY-MM-DD, where __DATE__ is MM-DD-YYYY
        PPB_TIME
        PPB_FUNCTION         '' __FUNCTION__ -- parser territory; passed through
        '' DEFINED, AND NEVER EXPANDING -- how TRUE and FALSE are modelled.
        ''
        '' fbc has no macro for either: symb-keyword.bas's symbKeywordConstsInit adds
        '' them as boolean CONSTS (-1 and 0) marked CanRedef, and fbc's '#ifdef' asks
        '' the whole symbol table rather than the define table. Measured on fbc 1.10
        '' and fbc-modern with one probe, identical output from both:
        ''
        ''   #ifdef TRUE / #ifdef FALSE      both DEFINED
        ''   #ifndef TRUE                    not taken
        ''   defined( TRUE )                 yes
        ''   #if TRUE / #if FALSE            taken / not taken
        ''   #print TRUE                     prints TRUE
        ''
        '' tiko-lang answered "not defined" to all of them, and the damage was not the
        '' '#ifdef' but what it let through: win/ntdef.bi guards 'const TRUE = 1' with
        '' '#ifndef TRUE', so every file including any win/ header got an INTEGER 1
        '' shadowing the boolean literal. Measured over win/objbase.bi --
        '' 'dim as boolean b = true : print (b = TRUE)' printed fbc's 'true' and
        '' tiko-lang's ' 0', the integer comparison of -1 against 1.
        ''
        '' A macro whose BODY is its own name cannot express this: fbc rejects one
        '' (error 89, Recursive DEFINE not allowed) and tiko-lang has no hide set --
        '' see IsHidden in pp.bas, which is measured and deliberate -- so it would
        '' expand until PP_MAX_FRAMES. PpExpand therefore refuses the name outright and
        '' the identifier reaches the parser untouched, where the symbol table resolves
        '' it as the BOOLEAN it is. '#if TRUE' is answered in ppexpr.bas, where fbc
        '' answers it from the const's value.
        PPB_SELF
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
        '' THE BLOCK NESTING IT WAS DEFINED AT. fbc's macros are symbols in its
        '' scoped table, so a '#define' inside a SUB dies with the SUB -- measured:
        '' the same name defined in two subs is two macros, and one defined in a sub
        '' is 'Variable not declared' at module level afterwards.
        as long      blockDepth
        as ubyte     builtin         '' PpBuiltin; 0 for an ordinary macro
        as IdVec     params
        as TokenVec  body
        as SourceLoc loc
    end type

    type MacroVec as FB.Array( of PpMacro )

    '' ONE '#import' LINE, as the preprocessor read it (ADR 0017; RFC-0001). The form is
    '' checked here -- quoting, '/' separators, segments, 'as', 'public'. Where the path
    '' leads is the driver's question (src/driver/modresolve.bas), because it needs the
    '' package search roots and the preprocessor has no business knowing them.
    type PpImport
        as string    path        '' as written: '/'-separated, maybe './' or '../'
        as string    alias_      '' the name it binds: 'as NAME', else the last segment
        as boolean   isPublic    '' '#import ... public': re-exported (module files only)
        as SourceLoc loc         '' the '#', for diagnostics that point at the import
    end type
    type PpImportVec as FB.Array( of PpImport )

    type PpConfig
        as StrVec ptr includePaths   '' -i, searched after the including file's dir
        '' SHARED ACROSS EVERY UNIT OF ONE INVOCATION, or 0 for a private one.
        ''
        '' A header included by 92 modules was LEXED 92 TIMES: the token cache lived on
        '' the engine, and the engine is per translation unit. Measured on tiko-lang's
        '' own 92 modules -- 34.8 MB lexed, of which 29.4 MB was a file already lexed in
        '' an earlier unit of the same process.
        ''
        '' The two travel TOGETHER and cannot be separated. MergeLiterals rewrites each
        '' literal token's index to point into the unit's pool, in place, in the cached
        '' vector -- so a cached file's tokens are bound to whichever pool was current
        '' when it was first lexed. Sharing the cache without sharing the pool would
        '' hand unit two indices into unit one's literals.
        as LiteralVec ptr             sharedLits
        as FB.Array( of any ptr ) ptr sharedLexed
        as StrVec ptr defines        '' -d name[=value]
        as boolean    reportUnsupported
        '' '#cmdline' IS ONLY HONOURED IN THE FIRST SOURCE FILE, and this says which
        '' module this is. fbc's rule, measured 2026-09-16: 'fbc a.bas b.bas' with the
        '' directive in a.bas restarts and never compiles b.bas on the first pass,
        '' while the same directive in b.bas is 'warning 46(1): #cmdline ignored' and
        '' no restart at all. Default false, so a single-file compile and every
        '' caller that does not care honours it.
        as boolean    cmdlineIgnored
        '' READ THE FILE'S HEADER AND STOP -- the build graph's scan (ADR 0017). The
        '' engine stops at the first token, or the first directive, that ends the part
        '' of a file in which '#import' may stand, having recorded '#module' and every
        '' '#import' on the result. Nothing after that point is read, so nothing after
        '' it is reported, and neither is TKO0992: a scan is not a compile.
        as boolean    scanHeader
        '' ...AND SAY NOTHING. A build scans every file's header for its imports and then
        '' compiles it, and the compile reports what the header got wrong; reporting it from
        '' the scan too would say everything twice. --print-graph scans aloud.
        as boolean    scanQuiet
        '' THE DRIVER BUILDS THIS UNIT'S IMPORTS (ADR 0017, P3): '#import' is not TKO0992.
        as boolean    importsBuilt
        '' A MODULE UNIT (ADR 0017; RFC-0003): the module's files, in order, preprocessed
        '' one after another by this engine as ONE translation unit -- the root is the
        '' first, and each next one starts where the one before ends. Every macro a file
        '' defined itself is undone at its end (headers' are kept). 0 for a classic unit.
        as IdVec ptr  moduleFiles
        '' The module's chain, 'acme.net.http': the value of __TKO_MODULE__.
        as string     moduleChain
        '' The target, as the two FACTS the preprocessor needs rather than as a target
        '' id: it has no business knowing the type model, and handing it one invites it
        '' to grow more target knowledge than seeding predefines requires.
        ''
        '' Getting these wrong does not fail -- it silently selects the other half of
        '' every header. The corpus branches on __FB_64BIT__ alone 214 times.
        as boolean    targetIsWindows
        as boolean    targetIs64
        '' WHETHER THE TARGET USES THE MSVC ABI, which is the same kind of fact and
        '' the same kind of silent failure. fbc-modern's crt/win32/stdio.bi branches
        '' on __FB_MSVC__ and hard-codes MinGW's spellings otherwise: __iob_func,
        '' which the UCRT does not have and no shim can supply -- MinGW hands out a
        '' FILE ARRAY and the macros index it, while the UCRT hands out one stream
        '' per call from __acrt_iob_func.
        as boolean    targetIsMsvc
        '' '-mt'. Seeds __FB_MT__, which is the same kind of fact as the two above:
        '' a header that branches on it selects a different half of itself, and
        '' getting it wrong compiles quietly.
        as boolean    threadSafe
        '' -e / -ex / -exx as a level, for __FB_ERR__.
        as long       errLevel
        '' '-g', for __FB_DEBUG__: fbc's '#print' gives -1 with the flag and 0 without,
        '' and 'assert' is compiled in exactly when it is -1.
        as boolean    debugInfo
        '' WHAT THIS BUILD PRODUCES, for __FB_OUT_EXE__, _DLL__, _LIB__ and _OBJ__: 0 an
        '' executable, 1 a DLL, 2 a static library, 3 an object ('-c'). Measured with
        '' fbc's '#print', exactly one of the four is -1 per build; they were fixed at the
        '' EXE values, so a header that branches on building a DLL took the wrong half.
        as long       outKind
        as any ptr    queryCtx       '' passed back to queryFn
        as any ptr    queryFn        '' PpQueryFn; NULL until Phase 5
        '' '#cinclude': the driver's C importer (D16), as a PpCImportFn. The preprocessor
        '' never includes the importer -- it is handed a function that returns the
        '' binding's FileId, and treats that file as '#include' treats one. NULL: the
        '' directive is TKO0310, as it always was.
        as any ptr    cimportCtx
        as any ptr    cimportFn
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
        '' '#inclib' AND '#libpath', IN SOURCE ORDER. They are the source's half of
        '' the link line -- a program says what it needs to link against, rather than
        '' every caller repeating it on the command line -- and until this they were
        '' recognised, skipped, and lost.
        ''
        '' They live on the RESULT and not in the engine because they outlive it: the
        '' engine is per translation unit and closes when the parse does, while the
        '' link happens once, after every module has been through.
        as StrVec   incLibs
        as StrVec   libPaths
        '' '#foreignlib' (fbc-modern RFC-0005): libraries resolved to an EXACT file
        '' rather than a name, so the linker does no lib-prefix guessing of its own.
        '' fbc hands these to ld as ':<filename>'; tiko names the path, which is
        '' what it already does for the runtime archives and works under lld-link
        '' too -- ':' is GNU ld syntax and the MSVC driver has no equivalent.
        as StrVec   foreignLibFiles
        '' '#cmdline' -- the ARGUMENTS A SOURCE INJECTS INTO ITS OWN COMPILATION,
        '' already split into argv words, in source order. Here for the same reason
        '' incLibs is: the engine closes with the preprocess and the thing that acts
        '' on these is the DRIVER, which restarts the compile once the whole pass has
        '' been read. See driver.bas, 'the restart'.
        as StrVec   cmdlineArgs
        '' '#pragma reserve NAME' -- the names a translation unit has taken out of
        '' circulation. On the RESULT for the same reason incLibs is: the engine closes
        '' with the preprocess and this outlives it, because the thing that has to see a
        '' reserved name is COLLECT, which runs afterwards. Recorded in the engine as
        '' well, where the duplicate-reserve check needs them while directives are still
        '' being read.
        as IdVec    reservedNames
        '' A '#lang' this unit asked for and tiko-lang refused (TKO0317). The unit fails
        '' either way; in 'qb' or 'fblite' an undeclared name is an implicit variable,
        '' so the undeclared-name report is not made over one -- it would be noise.
        as boolean  langRefused
        '' The bound names, so 'declare ... lib IDENT' can be checked against them.
        '' Stored as 'ID' & tab & 'signature': the same name twice with a DIFFERENT
        '' set is an error, and with the same set is not.
        as StrVec   foreignLibNames
        '' THE FILE'S MODULE HEADER (ADR 0017). isModuleFile: it began '#module "name"'.
        '' imports: its '#import' lines, in source order, form-checked but unresolved.
        as boolean     isModuleFile
        as string      moduleName
        as SourceLoc   moduleLoc
        as PpImportVec imports
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

    '' '#cinclude "h"': import the C header as written and return the binding's FileId,
    '' or FILE_NONE having reported why at 'at'. 'unicode' is whether UNICODE is defined
    '' where the directive stands -- it selects the W half of windows.h -- and 'root' is
    '' the translation unit's own file: two #cinclude lines in one unit share headers,
    '' and the second is imported as a delta over the first.
    type PpCImportFn as function _
        ( byval ctx as any ptr, byref header as string, byval unicode as boolean, _
          byval root as FileId, byval at as SourceLoc ) as FileId

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

    '' WHAT THE PARSER HAS DECLARED, told to the preprocessor as it goes, so that
    '' 'defined( X )' can answer for a declared name and not only for a macro. The
    '' parser calls the first as it reads each module-level declaration's name; the
    '' preprocessor asks the second from '#ifdef', '#ifndef' and 'defined'.
    declare sub PpNoteDeclared( byref st as PpStream, byval nm as InternId )
    '' A CONST'S VALUE, for '#if' to read -- see PpEngine.constMark.
    declare sub PpNoteConst _
        ( byref st as PpStream, byval nm as InternId, byval v as longint )
    declare function PpNotedConst _
        ( byref st as PpStream, byval nm as InternId, byref outv as longint ) as boolean
    declare function PpHasDeclared( byref st as PpStream, byval nm as InternId ) as boolean

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

    '' A TOKEN SPELLED BACK as the source wrote it -- case, suffix and string prefix kept --
    '' or, for one the preprocessor synthesised, as the canonical text. What stringising
    '' and pasting read, and what a module's interface is written from (ADR 0017).
    declare function PpSpell _
        ( byref src as SourceManager, byref names as Interner, _
          byref lits as LiteralVec, byref t as Token ) as string

end namespace

#endif
