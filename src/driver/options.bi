'' options.bi -- THE option table, and the parsed result.
''
'' One table drives the parser, --help and (later) the generated CLI reference, so the
'' three cannot disagree (docs/plan/12 section 2).
''
'' COMPATIBILITY. fbc's spellings are accepted where they exist, because existing
'' makefiles and build scripts use them: -i, -p, -l, -d, -g, -c, -mt, -w, -O, -target,
'' -s. GNU-style long options are added only where fbc has no equivalent. fbx does not
'' copy gcc's option surface wholesale.
''
'' Macro parameters are o_-prefixed: FreeBASIC substitutes a macro parameter name even
'' after a '.', so a parameter called 'kind' would rewrite '.kind' too.

#ifndef __FBX_OPTIONS_BI__
#define __FBX_OPTIONS_BI__

#include once "fbx.bi"
#include once "types/type.bi"
#include once "diag/diagnostic.bi"

namespace Fbx

    enum OptKind
        OPTK_FLAG = 0      '' -c
        OPTK_VALUE         '' -o <v>   or  --opt=<v>
        OPTK_JOINED        '' -Wno-FBX0105, -O2  -- value is glued to the spelling
        OPTK_OPTVALUE      '' --help [category], --dump-tokens[=pp]
    end enum

    enum OptCategory
        OPTCAT_GENERAL = 0
        OPTCAT_INPUT
        OPTCAT_OUTPUT
        OPTCAT_TARGET
        OPTCAT_DIAG
        OPTCAT_DEVEL
    end enum

'' OPT( id, spelling, kind, category, argName, help )
#macro FBX_OPT_LIST( OPT )

    OPT( OPT_HELP,      "--help",     OPTK_OPTVALUE, OPTCAT_GENERAL, "category", "show help; optionally for one category" )
    OPT( OPT_VERSION,   "--version",  OPTK_FLAG,  OPTCAT_GENERAL, "",         "show version and exit" )
    OPT( OPT_VERBOSE,   "-v",         OPTK_FLAG,  OPTCAT_GENERAL, "",         "echo every tool invocation" )

    OPT( OPT_INCLUDE,   "-i",         OPTK_VALUE, OPTCAT_INPUT,   "dir",      "add an include search path" )
    OPT( OPT_DEFINE,    "-d",         OPTK_VALUE, OPTCAT_INPUT,   "name=val", "define a preprocessor symbol" )
    OPT( OPT_LIBPATH,   "-p",         OPTK_VALUE, OPTCAT_INPUT,   "dir",      "add a library search path" )
    OPT( OPT_LIB,       "-l",         OPTK_VALUE, OPTCAT_INPUT,   "name",     "link against a library" )

    OPT( OPT_OUTPUT,    "-o",         OPTK_VALUE, OPTCAT_OUTPUT,  "file",     "output path" )
    OPT( OPT_COMPILE,   "-c",         OPTK_FLAG,  OPTCAT_OUTPUT,  "",         "compile only; do not link" )
    OPT( OPT_DEBUG,     "-g",         OPTK_FLAG,  OPTCAT_OUTPUT,  "",         "emit debug information" )
    OPT( OPT_OPTLEVEL,  "-O",         OPTK_JOINED,OPTCAT_OUTPUT,  "level",    "optimisation level 0-3" )
    OPT( OPT_MT,        "-mt",        OPTK_FLAG,  OPTCAT_OUTPUT,  "",         "link the thread-safe runtime" )

    OPT( OPT_TARGET,    "-target",    OPTK_VALUE, OPTCAT_TARGET,  "name",     "win64 or linux-x86_64" )
    OPT( OPT_M64,       "-m64",       OPTK_FLAG,  OPTCAT_TARGET,  "",         "64-bit target (the only supported width)" )
    OPT( OPT_M32,       "-m32",       OPTK_FLAG,  OPTCAT_TARGET,  "",         "32-bit target; win32 only" )

    OPT( OPT_WERROR,    "-Werror",    OPTK_FLAG,  OPTCAT_DIAG,    "",         "treat warnings as errors" )
    OPT( OPT_WNO,       "-Wno-",      OPTK_JOINED,OPTCAT_DIAG,    "id",       "suppress one diagnostic id" )
    OPT( OPT_MAXERR,    "-fmax-errors", OPTK_VALUE, OPTCAT_DIAG,  "n",        "stop after n errors" )
    OPT( OPT_COLOR,     "--color",    OPTK_VALUE, OPTCAT_DIAG,    "when",     "always, never or auto" )
    OPT( OPT_DIAGFMT,   "--diagnostics-format", OPTK_VALUE, OPTCAT_DIAG, "fmt", "fbc or gnu" )

    OPT( OPT_DUMPSRC,   "--dump-source",  OPTK_FLAG, OPTCAT_DEVEL, "",        "list loaded source files and stop" )
    OPT( OPT_DUMPTOK,   "--dump-tokens",  OPTK_OPTVALUE, OPTCAT_DEVEL, "raw|pp", "dump the token stream, before or after the preprocessor" )
    OPT( OPT_LEXONLY,   "--lex-only",     OPTK_FLAG, OPTCAT_DEVEL, "",        "lex every input and report counts; no dump" )
    OPT( OPT_PPONLY,    "--pp-only",      OPTK_FLAG, OPTCAT_DEVEL, "",        "preprocess every input and report counts; no dump" )
    OPT( OPT_DUMPAST,   "--dump-ast",     OPTK_FLAG, OPTCAT_DEVEL, "",        "dump the syntax tree" )
    OPT( OPT_DUMPTYPES, "--dump-types",   OPTK_FLAG, OPTCAT_DEVEL, "",        "dump the type table and its layout" )
    OPT( OPT_DUMPSYMS,  "--dump-symbols", OPTK_FLAG, OPTCAT_DEVEL, "",        "collect declarations and dump the symbol table" )
    OPT( OPT_RESOLVE,   "--resolve",      OPTK_FLAG, OPTCAT_DEVEL, "",        "collect and resolve; report reference binding" )
    OPT( OPT_MANGLE,    "--dump-mangle",  OPTK_FLAG, OPTCAT_DEVEL, "",        "print the emitted symbol name of each procedure" )
    OPT( OPT_CHECK,     "--check",        OPTK_FLAG, OPTCAT_DEVEL, "",        "type expressions; report the type of each PRINT argument" )
    OPT( OPT_UDT,       "--dump-udt",     OPTK_FLAG, OPTCAT_DEVEL, "",        "print each UDT's size, alignment and field offsets" )
    OPT( OPT_RTL,       "--dump-rtl",     OPTK_FLAG, OPTCAT_DEVEL, "",        "print the runtime inventory and stop" )
    OPT( OPT_PARSEEXPR, "--parse-expr",   OPTK_FLAG, OPTCAT_DEVEL, "",        "parse each line as one expression and dump it" )
    OPT( OPT_PARSEONLY, "--parse-only",   OPTK_FLAG, OPTCAT_DEVEL, "",        "parse every input and report counts; the corpus gate" )
    OPT( OPT_DUMPIR,    "--dump-ir",      OPTK_FLAG, OPTCAT_DEVEL, "",        "dump MIR" )
    OPT( OPT_EMITIR,    "--emit-ir",      OPTK_FLAG, OPTCAT_DEVEL, "",        "write LLVM IR and stop" )
    OPT( OPT_EMITASM,   "--emit-asm",     OPTK_FLAG, OPTCAT_DEVEL, "",        "write assembly and stop" )
    OPT( OPT_KEEPTEMPS, "--keep-temps",   OPTK_FLAG, OPTCAT_DEVEL, "",        "retain intermediate files" )
    OPT( OPT_STATS,     "--stats",        OPTK_FLAG, OPTCAT_DEVEL, "",        "report counts and memory use" )
    OPT( OPT_TIMEPASS,  "--time-passes",  OPTK_FLAG, OPTCAT_DEVEL, "",        "report wall time per phase" )
    OPT( OPT_SUBSET,    "--bootstrap-subset-check", OPTK_FLAG, OPTCAT_DEVEL, "", "reject constructs outside the self-hosting subset" )

#endmacro

    enum OptId
        OPT_NONE = 0
        #define OPT( o_id, o_spell, o_kind, o_cat, o_arg, o_help ) o_id,
        FBX_OPT_LIST( OPT )
        #undef OPT
        OPT_COUNT
    end enum

    type OptInfo
        as zstring ptr spelling
        as OptKind     kind
        as OptCategory category
        as zstring ptr argName
        as zstring ptr help
    end type

    type DriverOptions
        as StrVec  inputs
        as StrVec  includePaths
        as StrVec  libPaths
        as StrVec  libs
        as StrVec  defines

        as string  outputPath
        as string  targetName
        '' The parsed form of targetName. Everything downstream reads THIS: layout,
        '' the preprocessor's predefines, and eventually the ABI. targetName was
        '' written and read by nothing, which is how '-target linux-x86_64' came to be
        '' accepted and then ignored.
        as Fbx.TargetId target
        '' -m32 / -m64, held until the whole line is read. Applied as it is SEEN, the
        '' answer would depend on the order: '-m32 -target linux-x86_64' would quietly
        '' end up on Linux, while the reverse order errors.
        as long    widthOverride

        as boolean compileOnly
        as boolean debugInfo
        as boolean threadSafe
        as long    optLevel

        as boolean showHelp
        as string  helpCategory
        as boolean showVersion
        as boolean verbose

        as boolean warningsAsErrors
        as long    maxErrors
        as DiagColorMode     colorMode
        as DiagOutputFormat  diagFormat
        as StrVec  ignoredDiags

        as boolean dumpSource
        as boolean dumpTokens
        as boolean lexOnly
        as boolean ppOnly
        as boolean dumpPp
        as boolean dumpAst
        as boolean parseExpr
        as boolean parseOnly
        as boolean dumpTypes
        as boolean dumpSymbols
        as boolean resolveOnly
        as boolean dumpMangle
        as boolean checkOnly
        as boolean dumpUdt
        as boolean dumpRtl
        as boolean dumpIr
        as boolean emitIr
        as boolean emitAsm
        as boolean keepTemps
        as boolean stats
        as boolean timePasses
        as boolean bootstrapCheck

        declare constructor( )
    end type

    declare function OptInfoOf( byval id as OptId ) as OptInfo ptr
    declare sub InitOptTable( )
    declare function CategoryName( byval c as OptCategory ) as string

end namespace

#endif
