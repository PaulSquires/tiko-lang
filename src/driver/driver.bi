'' driver.bi -- pipeline orchestration.
''
'' The driver owns the CompilerContext chain (docs/plan/01 section 3) and is the only
'' module permitted to spawn processes, read the environment, or touch the filesystem
'' outside SourceManager.
''
'' Phase 2 status: the chain is built, inputs are loaded and diagnosed, and the
'' pipeline stops there. Every later phase adds one step to Run( ) and nothing else
'' about this module changes shape.

#ifndef __TKO_DRIVER_BI__
#define __TKO_DRIVER_BI__

#include once "tko.bi"
#include once "driver/options.bi"
#include once "diag/engine.bi"
#include once "source/manager.bi"
#include once "support/intern.bi"
#include once "lexer/lexer.bi"
#include once "types/type.bi"
#include once "driver/phasetime.bi"
#include once "driver/objqueue.bi"

namespace Tko

    '' One per tiko-lang process invocation. Nothing in the compiler is global; everything
    '' hangs off this, which is what makes parallel compilation possible later and
    '' in-process fuzzing possible now.
    type CompilerContext
        as Interner          names
        as SourceManager     sources
        as DiagnosticEngine  diags
        as DriverOptions     options
        as KeywordMap        keywords
        as TypeContext       types
        '' How many of diags' errors are TOOLCHAIN failures (driver.bas, ToolFail_). The
        '' exit code tells the two apart -- 1 for the program, 3/4/5 for the machine --
        '' and 'the engine holds an error' no longer can, now that both are diagnostics.
        as long              toolErrors

        '' SHARED BY EVERY COMPILATION UNIT OF THIS INVOCATION: the lexed token vectors,
        '' and the literal pool their tokens index. A header included by all 92 of
        '' tiko-lang's own modules was lexed 92 times when the cache lived on the
        '' preprocessor's engine, which is per unit -- 29.4 MB of 34.8 MB lexed was a
        '' file some earlier unit had already lexed. The pool has to travel with the
        '' cache: MergeLiterals rewrites a token's literal index IN THE CACHED VECTOR,
        '' so the tokens are bound to whichever pool was current when they were lexed.
        '' See PpConfig.sharedLits.
        as LiteralVec             ppLits
        as containers.Array( of any ptr ) ppLexed
        '' '#cinclude's session -- libclang and this run's bindings (cinclude.bas), made
        '' at the first #cinclude and freed with the context.
        as any ptr                cinclude
        '' A MODULE UNIT BEING COMPILED (ADR 0017): its chain ('acme.net.http'), its name
        '' ('http'), and its files in order. modFileCount = 0 for a classic compile.
        as string                 modChain
        as string                 modName
        as long                   modFileCount
        as FileIdVec              modFiles
        '' ...and its PACKAGE: the name, and the root its relative imports stay inside.
        as string                 modPkgName
        as string                 modPkgRoot
        '' THE MODULES OF THE BUILD (src/driver/modiface.bas), by graph node: each one's
        '' chain, its interface once it has been compiled (FILE_NONE until then), and the
        '' import edges between them; and the roots' package root, where a root's import is
        '' resolved from.
        as StrVec                 ifaceChains
        as StrVec                 ifaceDirs
        '' ...each one's interface text, and what its compile read and whether it needs
        '' the thread-safe runtime -- what its cache entry records (modcache.bas).
        as StrVec                 ifaceTexts
        as FileIdVec              unitFilesRead
        as StrVec                 unitProbesMissed   '' include candidates that were absent
        as boolean                unitThreadRtl
        as FileIdVec              ifaceFiles
        '' '-c' OF A PROGRAM THAT IMPORTS (RFC-0005 §6): each module's object, written as
        '' <chain>.o beside the output, absolute -- what the roots' '.fbctinf' records name.
        as StrVec                 modObjPaths
        '' THE PACKAGES OF THE BUILD (src/driver/modresolve.bas; RFC-0007 §1, §4), as they are
        '' found: each name once, with its root; a manifest's dependencies and [defines],
        '' flattened and keyed by the package's index; and the root manifest's say over its
        '' dependencies' defines.
        as StrVec                 pkgNames
        as StrVec                 pkgRoots
        as StrVec                 pkgDepOwner
        as StrVec                 pkgDepName
        as StrVec                 pkgDepPath
        as StrVec                 pkgDefOwner
        as StrVec                 pkgDefText
        as StrVec                 pkgDdDep
        as StrVec                 pkgDdText
        as boolean                pkgRootKnown
        as string                 pkgRootName
        as string                 pkgRootDir
        '' ...and the build order, as indices into ifaceChains: what modules initialise in.
        as FileIdVec              ifaceOrder
        as FileIdVec              ifaceEdgeFrom
        as FileIdVec              ifaceEdgeTo
        as string                 ifaceRootDir
        '' THE MODULES THE ROOTS IMPORT ARE BUILT (src/driver/modbuild.bas), so a root's
        '' '#import' is not TKO0992.
        as boolean                importsBuilt
        '' THE EDITOR SCAN'S RESULT (src/driver/scan.bi, a Tko.Scan.ScanResult), when this
        '' run is one: every unit then stops after Check and is harvested into it. 0 for
        '' every other run. An 'any ptr' so this header need not include the scan's.
        as any ptr                scan
        '' WHERE THE TIME WENT, phase by phase (driver/phasetime.bi); printed by '--time-passes'.
        as PhaseTimes             timing
        '' THE clang -c RUNS STARTED AND NOT YET WAITED FOR (driver/objqueue.bi).
        as ObjQueue               objq

        declare constructor( )
        declare destructor( )
    end type

end namespace

namespace Tko.Driver

    '' Returns a process exit code from Tko.ExitCode.
    '' 'restartDepth' IS THE '#cmdline' RESTART and nothing else. Zero is the run the
    '' user asked for; one is the re-run with the arguments the SOURCE asked for
    '' appended. It is a parameter rather than a flag inside Run( ) because the
    '' restart IS a second Run( ) -- main.bas stays one line, and the whole compiler
    '' remains reachable in-process.
    '' 'scanOut', when given, is a Tko.Scan.ScanResult the run fills instead of printing --
    '' how tikoParser.dll (src/api) drives a scan through the same command line as a CLI run.
    declare function Run _
        ( byref args as Tko.StrVec, byval restartDepth as long = 0, _
          byval scanOut as any ptr = 0 ) as long

end namespace

#endif
