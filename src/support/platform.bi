'' platform.bi -- the thin layer of OS-specific behaviour the compiler needs.
''
'' Deliberately tiny. Everything that CAN be done portably (paths, file I/O, time) is
'' done through fb/filesystem.bi and fb/chrono.bi instead. What is left is terminal
'' detection, which no portable library can answer.
''
'' Process spawning lands here in Phase 7, and it will use a structured argument
'' vector -- never a shell command string (docs/plan/14 section 7).

#ifndef __TKO_PLATFORM_BI__
#define __TKO_PLATFORM_BI__

#include once "tko.bi"

namespace Tko.Platform

    enum StdStream
        STREAM_OUT = 1
        STREAM_ERR = 2
    end enum

    '' True when the stream is a character device the user is watching. Colour is
    '' emitted only when this is true, so redirected output stays clean.
    declare function IsTerminal( byval s as StdStream ) as boolean

    '' Ask a Windows console to interpret ANSI escapes. No-op elsewhere, and
    '' harmless if it fails -- the caller has already decided colour is wanted.
    declare sub EnableAnsi( )

end namespace

#endif
