'' driver.bi -- pipeline orchestration.
''
'' The driver owns the CompilerContext chain (docs/plan/01 section 3) and is the only
'' module permitted to spawn processes, read the environment, or touch the filesystem
'' outside SourceManager.
''
'' Phase 2 status: the chain is built, inputs are loaded and diagnosed, and the
'' pipeline stops there. Every later phase adds one step to Run( ) and nothing else
'' about this module changes shape.

#ifndef __FBX_DRIVER_BI__
#define __FBX_DRIVER_BI__

#include once "fbx.bi"
#include once "driver/options.bi"
#include once "diag/engine.bi"
#include once "source/manager.bi"
#include once "support/intern.bi"
#include once "lexer/lexer.bi"
#include once "types/type.bi"

namespace Fbx

    '' One per fbx process invocation. Nothing in the compiler is global; everything
    '' hangs off this, which is what makes parallel compilation possible later and
    '' in-process fuzzing possible now.
    type CompilerContext
        as Interner          names
        as SourceManager     sources
        as DiagnosticEngine  diags
        as DriverOptions     options
        as KeywordMap        keywords
        as TypeContext       types

        declare constructor( )
    end type

end namespace

namespace Fbx.Driver

    '' Returns a process exit code from Fbx.ExitCode.
    declare function Run( byref args as Fbx.StrVec ) as long

end namespace

#endif
