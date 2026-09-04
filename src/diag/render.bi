'' render.bi -- turning a Diagnostic into text a human or an editor can read.
''
'' Two output shapes (docs/plan/12 section 5.2):
''
''   DIAGFMT_FBC   grid.bas(42,17): error TKO0100: unknown option '-q'
''   DIAGFMT_GNU   grid.bas:42:17: error: unknown option '-q' [TKO0100]
''
'' The fbc shape is the default because existing FreeBASIC editors -- including tiko --
'' already parse it.
''
'' A source snippet with a caret is appended when the diagnostic has a location and
'' the line is available. Caret columns are DISPLAY columns: tabs are expanded and
'' wide characters count as two cells, so the caret lands under the right character in
'' a CJK or accented source line.

#ifndef __TKO_DIAG_RENDER_BI__
#define __TKO_DIAG_RENDER_BI__

#include once "tko.bi"
#include once "diag/diagnostic.bi"
#include once "source/manager.bi"

namespace Tko.Render

    '' ANSI SGR sequences. Emitted only when the engine says colour is in use.
    ''
    '' THE ESCAPE IS '\&h1B' AND NOT '\e'. FreeBASIC has no '\e', and an unrecognised
    '' escape keeps the LETTER, so '!"\e[0m"' is SEVEN bytes beginning with 'e' and every
    '' diagnostic printed 'e[1;31merrore[0m' in a console instead of a red word.
    '' Measured rather than reasoned: the string's own bytes were read back.
    ''
    '' AND '\033' IS NOT THE ANSWER EITHER. FreeBASIC's '\nnn' is DECIMAL, not octal, so
    '' that is character 33 -- an exclamation mark. '\027' would work; '\&h1B' says what it
    '' means without anyone having to know that.
    const ANSI_RESET  as string = !"\&h1B[0m"
    const ANSI_BOLD   as string = !"\&h1B[1m"
    const ANSI_RED    as string = !"\&h1B[1;31m"
    const ANSI_YELLOW as string = !"\&h1B[1;33m"
    const ANSI_CYAN   as string = !"\&h1B[1;36m"
    const ANSI_GREEN  as string = !"\&h1B[1;32m"
    const ANSI_GREY   as string = !"\&h1B[0;90m"

    declare function Diagnostic_ _
        ( byref d as Tko.Diagnostic, byref src as Tko.SourceManager, _
          byval fmt as Tko.DiagOutputFormat, byval useColor as boolean ) as string

    declare function Snippet _
        ( byref src as Tko.SourceManager, byref rng as Tko.SourceRange, _
          byval useColor as boolean, byval caretColor as string ) as string

    declare function SeverityColor( byval s as Tko.Severity ) as string

end namespace

#endif
