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

        declare constructor( )
    end type

end namespace

namespace Tko.Driver

    '' Returns a process exit code from Tko.ExitCode.
    '' 'restartDepth' IS THE '#cmdline' RESTART and nothing else. Zero is the run the
    '' user asked for; one is the re-run with the arguments the SOURCE asked for
    '' appended. It is a parameter rather than a flag inside Run( ) because the
    '' restart IS a second Run( ) -- main.bas stays one line, and the whole compiler
    '' remains reachable in-process.
    declare function Run _
        ( byref args as Tko.StrVec, byval restartDepth as long = 0 ) as long

end namespace

#endif
