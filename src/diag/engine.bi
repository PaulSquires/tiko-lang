'' engine.bi -- the diagnostic engine.
''
'' Every phase reports here and only here (docs/plan/01 section 1). The engine owns
'' counting, -w / -Werror policy, the error cap, deduplication and ORDER.
''
'' Ordering is deterministic by construction: diagnostics are buffered and flushed in
'' the order they were reported for a unit, so a future parallel build cannot shuffle
'' output (docs/plan/01 section 3). This is designed in now because retrofitting
'' deterministic diagnostic order is miserable.
''
'' Invariants:
''   - A Diagnostic reaches output only through Flush( ).
''   - AddNote( ) attaches to the most recently reported diagnostic; calling it with
''     none outstanding is a no-op, never a crash.
''   - Once the error cap is reached, further errors are counted but not stored.

#ifndef __FBX_DIAG_ENGINE_BI__
#define __FBX_DIAG_ENGINE_BI__

#include once "fbx.bi"
#include once "diag/diagnostic.bi"
#include once "source/manager.bi"

namespace Fbx

    const DIAG_DEFAULT_MAX_ERRORS as long = 100

    type SeverityVec as FB.Array( of long )

    type DiagnosticEngine
        as SourceManager ptr sources
        as DiagVec    pending
        as long       errors
        as long       warnings
        as long       suppressedCount
        as long       maxErrors
        as boolean    warningsAsErrors
        as boolean    capReported
        as DiagColorMode  colorMode
        as DiagOutputFormat outputFormat
        as SeverityVec policy        '' per-DiagId override; -1 = default, -2 = ignore

        declare constructor( )
        declare sub Attach( byval src as SourceManager ptr )

        declare sub Report _
            ( byval id as DiagId, byval rng as SourceRange, _
              byval a0 as string = "", byval a1 as string = "", byval a2 as string = "" )

        '' For driver-level messages that have no source location at all.
        declare sub ReportGlobal _
            ( byval id as DiagId, byval a0 as string = "", _
              byval a1 as string = "", byval a2 as string = "" )

        declare sub AddNote _
            ( byval id as DiagId, byval rng as SourceRange, _
              byval a0 as string = "", byval a1 as string = "", byval a2 as string = "" )

        declare sub Flush( )

        declare function ErrorCount( ) as long
        declare function WarningCount( ) as long
        declare function HasErrors( ) as boolean

        declare sub Ignore( byval id as DiagId )
        declare sub Promote( byval id as DiagId, byval s as Severity )
        declare sub SetWarningsAsErrors( byval v as boolean )
        declare sub SetMaxErrors( byval n as long )
        declare sub SetColorMode( byval newMode as DiagColorMode )
        declare sub SetFormat( byval f as DiagOutputFormat )
        declare function UseColor( ) as boolean

        private:
        declare function EffectiveSeverity( byval id as DiagId ) as Severity
        declare sub Push _
            ( byval id as DiagId, byval rng as SourceRange, byval hasLoc as boolean, _
              byval a0 as string, byval a1 as string, byval a2 as string )
    end type

end namespace

#endif
