'' diagnostic.bi -- the diagnostic value type and the id table.
''
'' A Diagnostic is data. It is produced by the engine, held until flush, and rendered
'' by diag/render. Nothing formats a message by hand and nothing writes to the console
'' except the renderer.

#ifndef __FBX_DIAGNOSTIC_BI__
#define __FBX_DIAGNOSTIC_BI__

#include once "fbx.bi"
#include once "source/location.bi"

namespace Fbx

    '' Ordered by increasing seriousness: policy code compares severities.
    enum Severity
        SEV_REMARK = 0
        SEV_NOTE
        SEV_WARNING
        SEV_ERROR
    end enum

    declare function SeverityName( byval s as Severity ) as string

    enum DiagColorMode
        COLOR_AUTO = 0
        COLOR_ALWAYS
        COLOR_NEVER
    end enum

    '' DIAGFMT_FBC is the default: existing FreeBASIC editors already parse it.
    enum DiagOutputFormat
        DIAGFMT_FBC = 0      '' path(line,col): error FBX0001: msg
        DIAGFMT_GNU          '' path:line:col: error: msg [FBX0001]
    end enum

    '' The table needs Severity, so it is included HERE -- inside the namespace and
    '' after the enum above. Including it outside would put DiagId in the global
    '' namespace, where Fbx.DiagId does not resolve.
    #include once "diag/diagids.bi"

    type DiagInfo
        as zstring ptr idName        '' "FBX0100" -- the stable spelling
        as Severity    defaultSev
        as zstring ptr format        '' with %0 %1 %2 placeholders
    end type

    type DiagNote
        as DiagId     id
        as SourceRange range
        as string     text           '' already formatted
    end type

    type NoteVec as FB.Array( of DiagNote )

    type Diagnostic
        as DiagId      id
        as Severity    sev           '' after -Werror / -w policy is applied
        as SourceRange range
        as string      text          '' already formatted
        as NoteVec     notes
        as boolean     hasLocation
    end type

    type DiagVec as FB.Array( of Diagnostic )

    '' Lookup into the generated table. Valid for 1 .. DIAG_COUNT-1.
    declare function DiagInfoOf( byval id as DiagId ) as DiagInfo ptr
    declare function DiagIdName( byval id as DiagId ) as string

    '' Resolve "FBX0100" (case-insensitive) back to its id; DIAG_NONE if unknown.
    declare function DiagIdFromName( byval spelling as string ) as DiagId

    '' Substitute %0..%2 in fmt. A '%' not followed by a digit is literal.
    declare function FormatDiag _
        ( byval fmt as string, byval a0 as string, byval a1 as string, _
          byval a2 as string ) as string

    declare sub InitDiagTable( )

end namespace

#endif
