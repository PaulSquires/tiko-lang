'' render.bi -- turning a Diagnostic into text a human or an editor can read.
''
'' Two output shapes (docs/plan/12 section 5.2):
''
''   DIAGFMT_FBC   grid.bas(42,17): error FBX0100: unknown option '-q'
''   DIAGFMT_GNU   grid.bas:42:17: error: unknown option '-q' [FBX0100]
''
'' The fbc shape is the default because existing FreeBASIC editors -- including tiko --
'' already parse it.
''
'' A source snippet with a caret is appended when the diagnostic has a location and
'' the line is available. Caret columns are DISPLAY columns: tabs are expanded and
'' wide characters count as two cells, so the caret lands under the right character in
'' a CJK or accented source line.

#ifndef __FBX_DIAG_RENDER_BI__
#define __FBX_DIAG_RENDER_BI__

#include once "fbx.bi"
#include once "diag/diagnostic.bi"
#include once "source/manager.bi"

namespace Fbx.Render

    '' ANSI SGR sequences. Emitted only when the engine says colour is in use.
    const ANSI_RESET  as string = !"\e[0m"
    const ANSI_BOLD   as string = !"\e[1m"
    const ANSI_RED    as string = !"\e[1;31m"
    const ANSI_YELLOW as string = !"\e[1;33m"
    const ANSI_CYAN   as string = !"\e[1;36m"
    const ANSI_GREEN  as string = !"\e[1;32m"
    const ANSI_GREY   as string = !"\e[0;90m"

    declare function Diagnostic_ _
        ( byref d as Fbx.Diagnostic, byref src as Fbx.SourceManager, _
          byval fmt as Fbx.DiagOutputFormat, byval useColor as boolean ) as string

    declare function Snippet _
        ( byref src as Fbx.SourceManager, byref rng as Fbx.SourceRange, _
          byval useColor as boolean, byval caretColor as string ) as string

    declare function SeverityColor( byval s as Fbx.Severity ) as string

end namespace

#endif
