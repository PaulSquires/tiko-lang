'' cmdline.bi -- command-line parsing.
''
'' A separate, independently testable module: it takes an argument vector and a
'' diagnostic engine, and produces a DriverOptions. It touches no files, spawns no
'' processes and reads no environment, so tests/driver/cmdline can drive it directly
'' with synthetic argument vectors.

#ifndef __FBX_CMDLINE_BI__
#define __FBX_CMDLINE_BI__

#include once "fbx.bi"
#include once "driver/options.bi"
#include once "diag/engine.bi"

namespace Fbx.Cmdline

    '' Returns false when the command line was rejected. Diagnostics are reported
    '' through the engine, so the caller only needs the boolean.
    declare function Parse _
        ( byref args as Fbx.StrVec, byref opts as Fbx.DriverOptions, _
          byref diags as Fbx.DiagnosticEngine ) as boolean

    declare function HelpText( byval category as string = "" ) as string
    declare function VersionText( ) as string

end namespace

#endif
