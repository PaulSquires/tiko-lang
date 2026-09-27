'' options.bi -- THE option table, and the parsed result.
''
'' One table drives the parser, --help and (later) the generated CLI reference, so the
'' three cannot disagree (docs/plan/12 section 2).
''
'' COMPATIBILITY. fbc's spellings are accepted where they exist, because existing
'' makefiles and build scripts use them: -i, -p, -l, -d, -g, -c, -mt, -w, -O, -target,
'' -s. GNU-style long options are added only where fbc has no equivalent. tiko-lang does not
'' copy gcc's option surface wholesale.
''
'' Macro parameters are o_-prefixed: FreeBASIC substitutes a macro parameter name even
'' after a '.', so a parameter called 'kind' would rewrite '.kind' too.

#ifndef __TKO_OPTIONS_BI__
#define __TKO_OPTIONS_BI__

#include once "tko.bi"
#include once "types/type.bi"
#include once "diag/diagnostic.bi"

namespace Tko

    enum OptKind
        OPTK_FLAG = 0      '' -c
        OPTK_VALUE         '' -o <v>   or  --opt=<v>
        OPTK_JOINED        '' -Wno-TKO0105, -O2  -- value is glued to the spelling
        OPTK_OPTVALUE      '' --help [category], --dump-tokens[=pp]
    end enum

    enum OptCategory
        OPTCAT_GENERAL = 0
        OPTCAT_INPUT
        OPTCAT_OUTPUT
        OPTCAT_TARGET
        OPTCAT_DIAG
        OPTCAT_CIMPORT      '' before DEVEL: HelpText walks GENERAL..DEVEL
        OPTCAT_DEVEL
    end enum

'' OPT( id, spelling, kind, category, argName, help )
#macro TKO_OPT_LIST( OPT )

    OPT( OPT_HELP,      "--help",     OPTK_OPTVALUE, OPTCAT_GENERAL, "category", "show help; optionally for one category" )
    OPT( OPT_VERSION,   "--version",  OPTK_FLAG,  OPTCAT_GENERAL, "",         "show version and exit" )
    OPT( OPT_VERBOSE,   "-v",         OPTK_FLAG,  OPTCAT_GENERAL, "",         "echo every tool invocation" )
    '' ACCEPTED AND IGNORED, because tiko restarts on its own. fbc needs telling --
    '' its own test suite writes '#cmdline "-restart"' next to the directive that
    '' needs it -- and a source that says so must not become an unknown-option error
    '' here. Undocumented in fbc's --help; it is what fbc passes itself when it
    '' re-invokes, and tiko never re-invokes: it calls Run( ) again.
    OPT( OPT_RESTART,   "-restart",   OPTK_FLAG,  OPTCAT_GENERAL, "",         "accepted and ignored; a '#cmdline' restarts by itself" )
    '' THE BUILD GRAPH OF ADR 0017: every module the inputs import, in build order.
    OPT( OPT_PRINTGRAPH, "--print-graph", OPTK_FLAG, OPTCAT_GENERAL, "",     "print the modules the inputs import, in build order, and stop" )
    '' ...and the interface an importer of a module reads (RFC-0004).
    OPT( OPT_EMITTKI,   "--emit-tki",     OPTK_FLAG, OPTCAT_GENERAL, "",     "print the interface of the module directory given, and stop" )

    '' ACCEPTED AND IGNORED TOO, and for a different reason. fbc-modern's '-z <option>'
    '' turns on an extended behaviour; the only one the corpus asks for is
    '' '-z optabstract', which STRIPS pure-abstract types nothing uses. tiko strips
    '' none, so ignoring the switch is the conservative reading of it and the program
    '' behaves the same -- com/comptr-optabstract.bas writes '#cmdline "-z optabstract"'
    '' and then asserts that an interface reached only through a ComPtr still works,
    '' which is a question about the interface and not about the stripping. Rejecting it
    '' made that file an unknown-option error, which is the one answer fbc never gives.
    OPT( OPT_EXTENDED,  "-z",         OPTK_VALUE, OPTCAT_GENERAL, "option",   "fbc extended option; accepted and ignored" )

    OPT( OPT_INCLUDE,   "-i",         OPTK_VALUE, OPTCAT_INPUT,   "dir",      "add an include search path" )
    OPT( OPT_DEFINE,    "-d",         OPTK_VALUE, OPTCAT_INPUT,   "name=val", "define a preprocessor symbol" )
    OPT( OPT_LIBPATH,   "-p",         OPTK_VALUE, OPTCAT_INPUT,   "dir",      "add a library search path" )
    OPT( OPT_LIB,       "-l",         OPTK_VALUE, OPTCAT_INPUT,   "name",     "link against a library" )

    OPT( OPT_OUTPUT,    "-o",         OPTK_VALUE, OPTCAT_OUTPUT,  "file",     "output path" )
    OPT( OPT_COMPILE,   "-c",         OPTK_FLAG,  OPTCAT_OUTPUT,  "",         "compile only; do not link" )
    OPT( OPT_DLL,       "-dll",       OPTK_FLAG,  OPTCAT_OUTPUT,  "",         "build a DLL rather than an executable" )
    OPT( OPT_DYLIB,     "-dylib",     OPTK_FLAG,  OPTCAT_OUTPUT,  "",         "same as -dll" )
    OPT( OPT_STATICLIB, "-lib",       OPTK_FLAG,  OPTCAT_OUTPUT,  "",         "build a static library" )
    OPT( OPT_ERRCHK,    "-e",         OPTK_FLAG,  OPTCAT_OUTPUT,  "",         "enable runtime error checking" )
    OPT( OPT_ERRCHKX,   "-ex",        OPTK_FLAG,  OPTCAT_OUTPUT,  "",         "as -e: RESUME, which fbc adds here, does not exist in the fb dialect" )
    OPT( OPT_ERRCHKXX,  "-exx",       OPTK_FLAG,  OPTCAT_OUTPUT,  "",         "-ex plus array bounds and null-pointer checking" )
    OPT( OPT_DEBUG,     "-g",         OPTK_FLAG,  OPTCAT_OUTPUT,  "",         "emit debug information" )
    OPT( OPT_OPTLEVEL,  "-O",         OPTK_JOINED,OPTCAT_OUTPUT,  "level",    "optimisation level 0-3" )
    OPT( OPT_MT,        "-mt",        OPTK_FLAG,  OPTCAT_OUTPUT,  "",         "link the thread-safe runtime" )
    OPT( OPT_MAINMOD,   "-m",         OPTK_VALUE, OPTCAT_OUTPUT,  "name",     "which module owns main; the others become module constructors" )

    OPT( OPT_TARGET,    "-target",    OPTK_VALUE, OPTCAT_TARGET,  "name",     "win64-msvc (the Windows default), win64 or linux-x86_64" )
    OPT( OPT_M64,       "-m64",       OPTK_FLAG,  OPTCAT_TARGET,  "",         "64-bit target (the only supported width)" )
    OPT( OPT_M32,       "-m32",       OPTK_FLAG,  OPTCAT_TARGET,  "",         "rejected: 32-bit is not supported (x86-64 only)" )
    OPT( OPT_SUBSYS,    "-s",         OPTK_VALUE, OPTCAT_TARGET,  "console|gui", "Windows subsystem of an executable; console is the default" )

    OPT( OPT_WERROR,    "-Werror",    OPTK_FLAG,  OPTCAT_DIAG,    "",         "treat warnings as errors" )
    OPT( OPT_WNO,       "-Wno-",      OPTK_JOINED,OPTCAT_DIAG,    "id",       "suppress one diagnostic id" )
    OPT( OPT_MAXERR,    "-fmax-errors", OPTK_VALUE, OPTCAT_DIAG,  "n",        "stop after n errors" )
    OPT( OPT_MAXINSTDEPTH, "-maxinstdepth", OPTK_VALUE, OPTCAT_GENERAL, "n",  "how deep one generic instantiation may drive another (default 64)" )
    OPT( OPT_COLOR,     "--color",    OPTK_VALUE, OPTCAT_DIAG,    "when",     "always, never or auto" )
    OPT( OPT_DIAGFMT,   "--diagnostics-format", OPTK_VALUE, OPTCAT_DIAG, "fmt", "fbc or gnu" )
    '' FOR AN EDITOR. The console text is unchanged; this writes the same diagnostics
    '' AGAIN as tab-separated records -- docs/internals/diagnostics-file.md.
    OPT( OPT_DIAGFILE,  "--diagnostics-file", OPTK_VALUE, OPTCAT_DIAG, "path", "also write every diagnostic to <path> as tab-separated records" )

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
    OPT( OPT_CIMPORT_PROBE, "--cimport-probe", OPTK_VALUE, OPTCAT_DEVEL, "header", "load libclang, parse one C header, print what clang saw" )
    OPT( OPT_CINCLUDE,  "-cinclude",      OPTK_VALUE, OPTCAT_CIMPORT, "dir",  "add a C include directory (clang's -I) for #cinclude" )
    OPT( OPT_CIMPORT,   "-cimport",       OPTK_VALUE, OPTCAT_CIMPORT, "header", "import a C header as a FreeBASIC binding; needs -cimport-out" )
    OPT( OPT_CIMPORT_OUT, "-cimport-out", OPTK_VALUE, OPTCAT_CIMPORT, "file", "where -cimport writes the binding; - for standard output" )
    OPT( OPT_CIMPORT_MANIFEST, "-cimport-manifest", OPTK_VALUE, OPTCAT_CIMPORT, "file", "write clang's layout of every imported record" )
    OPT( OPT_CDEFINE,   "-cdefine",       OPTK_VALUE, OPTCAT_CIMPORT, "name[=value]", "define a C macro (clang's -D)" )
    OPT( OPT_CSYSROOT,  "-csysroot",      OPTK_VALUE, OPTCAT_CIMPORT, "dir",  "the C sysroot (clang's --sysroot)" )
    OPT( OPT_COPT,      "-copt",          OPTK_VALUE, OPTCAT_CIMPORT, "arg",  "pass an argument to clang verbatim" )
    OPT( OPT_CNOMACROS, "-cnomacros",     OPTK_FLAG,  OPTCAT_CIMPORT, "",     "do not import object-like macros as constants" )
    OPT( OPT_CNOVERIFY, "-cnoverify",     OPTK_FLAG,  OPTCAT_CIMPORT, "",     "do not check tiko's layout of each imported record against clang's" )
    OPT( OPT_CNOCACHE,  "-cnocache",      OPTK_FLAG,  OPTCAT_CIMPORT, "",     "#cinclude neither reads nor writes the binding cache" )
    OPT( OPT_CCACHEDIR, "-ccachedir",     OPTK_VALUE, OPTCAT_CIMPORT, "dir",  "where #cinclude keeps its bindings (default: the user's cache directory)" )
    OPT( OPT_VTABLE,    "--dump-vtable",  OPTK_FLAG, OPTCAT_DEVEL, "",        "print each UDT's virtual method table" )
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
        TKO_OPT_LIST( OPT )
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

    '' EXE, DLL or static library. fbc spells the last one '-lib' and produces
    '' libNAME.a from it; the DLL case produces NAME.dll AND libNAME.dll.a, the
    '' import library, whose name follows the OUTPUT rather than the source --
    '' measured: '-dll thing.bas -x custom.dll' writes libcustom.dll.a.
    enum OutputKind
        OUT_EXE = 0
        OUT_DLL
        OUT_STATICLIB
    end enum

    type DriverOptions
        as StrVec  inputs
        as StrVec  includePaths
        '' HOW MANY OF includePaths THE USER GAVE with -i; the default include directory
        '' is appended after them. The -i paths are also package search roots (ADR 0017)
        '' and the bundled header directory is not.
        as long    userIncludeCount
        '' --print-graph: resolve the imports, print the build order, stop.
        as boolean printGraph
        '' --emit-tki: check the module directory given, print its interface, stop.
        as boolean emitTki
        '' THE LIBRARY SEARCH IS THREE LISTS, NOT ONE, and they are kept apart
        '' because their ORDER is fbc's and is measured:
        ''
        ''     -L cmdlinedir  -L pragmadir  -L <compiler's own>  -L .
        ''
        '' -p first, '#libpath' second, the bundled directories last. They were one
        '' list, with the defaults appended as the command line was parsed -- which
        '' worked only for as long as nothing could add a path AFTER that, and
        '' '#libpath' is read during the parse. A pragma path would have landed
        '' behind the bundled tree and resolved out of it instead.
        as StrVec  libPaths          '' -p, in the order given
        as StrVec  pragmaLibPaths    '' '#libpath', in source order
        as StrVec  defaultLibPaths   '' <exe-dir>/lib/<target>, or TKO_LIBPATH
        '' The same split, and the same order, for the libraries themselves.
        as StrVec  libs              '' -l
        as StrVec  pragmaLibs        '' '#inclib'
        '' '#foreignlib', already resolved to exact files. Named as FILES on the
        '' link line rather than through '-l', which is the point of the feature:
        '' the binding said which file, so the linker does no searching of its own.
        as StrVec  pragmaLibFiles
        as StrVec  defines

        as string  outputPath
        as string  targetName
        '' The parsed form of targetName. Everything downstream reads THIS: layout,
        '' the preprocessor's predefines, and eventually the ABI. targetName was
        '' written and read by nothing, which is how '-target linux-x86_64' came to be
        '' accepted and then ignored.
        as Tko.TargetId target
        '' -m32 / -m64, held until the whole line is read. Applied as it is SEEN, the
        '' answer would depend on the order: '-m32 -target linux-x86_64' would quietly
        '' end up on Linux, while the reverse order errors.
        as long    widthOverride
        '' WHICH MODULE OWNS main. fbc's -m, and it names a MODULE, not a file:
        '' measured, the name is matched against the OBJECT's basename, so
        '' '-o b.o -m b' makes that module main whatever the source was called.
        '' Empty means "the first source", which is what keeps a one-file
        '' 'tiko hello.bas -o hello.exe' producing a program.
        as string  mainModule

        '' WHAT THE BUILD PRODUCES. fbc's -dll/-dylib and -lib, which decide the
        '' default output name, whether there is a link at all, and what the link
        '' line says. Three states rather than two booleans: they are exclusive, and
        '' 'tiko -dll -lib' has to mean something rather than whichever won.
        '' fbc's -e / -ex / -exx, and they are CUMULATIVE: -exx implies -ex implies
        '' -e. Held as a level rather than three booleans so 'is checking on at all'
        '' and 'is bounds checking on' are each one comparison.
        as long    errLevel      '' 0 none, 1 -e, 2 -ex, 3 -exx
        as Tko.OutputKind outKind
        as boolean compileOnly
        as boolean debugInfo
        as boolean threadSafe
        as boolean guiSubsystem  '' -s gui; console (false) is fbc's default too
        as long    optLevel

        as boolean showHelp
        as string  helpCategory
        as boolean showVersion
        as boolean verbose

        as boolean warningsAsErrors
        as long    maxErrors
        as long    maxInstDepth      '' -maxinstdepth, fbc's; 64 by default
        as DiagColorMode     colorMode
        as DiagOutputFormat  diagFormat
        as string  diagFile          '' --diagnostics-file; "" = none
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
        '' C HEADER IMPORT. The directories are clang's, not FreeBASIC's: '-i' is never
        '' passed to clang, and '-cinclude' never reaches #include.
        as string  cimportProbe
        as StrVec  cIncludes
        as StrVec  cimportHeaders
        as string  cimportOut
        as string  cimportManifest
        as StrVec  cDefines
        as string  cSysroot
        as StrVec  cOpts
        as boolean cNoMacros
        as boolean cNoVerify
        as boolean cNoCache
        as string  cCacheDir
        as boolean dumpVtable
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
