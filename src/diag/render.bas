'' render.bas -- see render.bi

#include once "diag/render.bi"
#include once "diag/engine.bi"
#include once "support/text.bi"

namespace Fbx.Render

function SeverityColor( byval s as Fbx.Severity ) as string
    select case s
    case Fbx.SEV_ERROR   : return ANSI_RED
    case Fbx.SEV_WARNING : return ANSI_YELLOW
    case Fbx.SEV_NOTE    : return ANSI_CYAN
    case else            : return ANSI_GREY
    end select
end function

private function Tint _
    ( byval useColor as boolean, byval colour as string, byval s as string ) as string
    if useColor = false then return s
    return colour + s + ANSI_RESET
end function

'' Right-align a line number in a gutter wide enough for the largest one shown.
private function Gutter( byval n as long, byval gutterWidth as long ) as string
    dim as string s = str( n )
    while len( s ) < gutterWidth
        s = " " + s
    wend
    return s
end function

function Snippet _
    ( byref src as Fbx.SourceManager, byref rng as Fbx.SourceRange, _
      byval useColor as boolean, byval caretColor as string ) as string

    dim as Fbx.DecodedLoc a = src.Decode( rng.first )
    if a.file = Fbx.FILE_NONE then return ""

    dim as string lineText = src.LineText( a.file, a.lineNo )
    if len( lineText ) = 0 then
        '' An empty line still deserves a caret: it may be exactly where the
        '' problem is (a missing END IF at end of file, say).
        lineText = ""
    end if

    '' The underline runs to the end of the range when it stays on this line,
    '' otherwise to the end of the line.
    dim as Fbx.DecodedLoc b = src.Decode( rng.last )
    dim as long lastCol = a.column
    dim as boolean sameLine = (b.file = a.file) andalso (b.lineNo = a.lineNo)
    if sameLine andalso (b.column >= a.column) then lastCol = b.column

    dim as long gutterWidth = len( str( a.lineNo ) )
    if gutterWidth < 4 then gutterWidth = 4

    dim as string pad = space( gutterWidth )
    dim as string bar = " | "

    dim as string outp = ""
    outp += Tint( useColor, ANSI_GREY, pad + " |" ) + chr( 10 )
    outp += Tint( useColor, ANSI_GREY, Gutter( a.lineNo, gutterWidth ) + bar ) + lineText + chr( 10 )

    '' Build the caret row in DISPLAY columns, expanding tabs the same way the
    '' source line will render them.
    dim as string caret = ""
    for i as long = 1 to a.column - 1
        dim as boolean isTab = false
        if i <= len( lineText ) then isTab = (lineText[i - 1] = 9)
        if isTab then
            caret += chr( 9 )
        else
            caret += " "
        end if
    next
    caret += "^"
    for i as long = a.column + 1 to lastCol
        caret += "~"
    next

    outp += Tint( useColor, ANSI_GREY, pad + bar ) + Tint( useColor, caretColor, caret )
    return outp
end function

function Diagnostic_ _
    ( byref d as Fbx.Diagnostic, byref src as Fbx.SourceManager, _
      byval fmt as Fbx.DiagOutputFormat, byval useColor as boolean ) as string

    dim as string sevName = Fbx.SeverityName( d.sev )
    dim as string sevTinted = Tint( useColor, SeverityColor( d.sev ), sevName )
    dim as string idName = Fbx.DiagIdName( d.id )
    dim as string outp = ""

    if d.hasLocation then
        dim as Fbx.DecodedLoc loc = src.Decode( d.range.first )
        dim as string path = src.PathOf( loc.file )
        if fmt = Fbx.DIAGFMT_GNU then
            outp += path & ":" & loc.lineNo & ":" & loc.column & ": " & _
                    sevTinted & ": " & Tint( useColor, ANSI_BOLD, d.text ) & _
                    " [" & idName & "]"
        else
            outp += path & "(" & loc.lineNo & "," & loc.column & "): " & _
                    sevTinted & " " & idName & ": " & Tint( useColor, ANSI_BOLD, d.text )
        end if
        outp += chr( 10 )
        dim as string snip = Snippet( src, d.range, useColor, SeverityColor( d.sev ) )
        if len( snip ) > 0 then outp += snip + chr( 10 )
    else
        '' No location: driver-level messages. Prefix with the tool name so the line
        '' is still self-identifying in a build log.
        if fmt = Fbx.DIAGFMT_GNU then
            outp += "fbx: " & sevTinted & ": " & d.text & " [" & idName & "]" & chr( 10 )
        else
            outp += "fbx: " & sevTinted & " " & idName & ": " & d.text & chr( 10 )
        end if
    end if

    for each n as Fbx.DiagNote in d.notes
        dim as string noteTint = Tint( useColor, ANSI_CYAN, "note" )
        dim as boolean noteHasLoc = (n.range.first <> Fbx.LOC_NONE)
        if noteHasLoc then
            dim as Fbx.DecodedLoc nl = src.Decode( n.range.first )
            dim as string npath = src.PathOf( nl.file )
            if fmt = Fbx.DIAGFMT_GNU then
                outp += npath & ":" & nl.lineNo & ":" & nl.column & ": " & _
                        noteTint & ": " & n.text & chr( 10 )
            else
                outp += npath & "(" & nl.lineNo & "," & nl.column & "): " & _
                        noteTint & ": " & n.text & chr( 10 )
            end if
            dim as string nsnip = Snippet( src, n.range, useColor, ANSI_CYAN )
            if len( nsnip ) > 0 then outp += nsnip + chr( 10 )
        else
            outp += "  " & noteTint & ": " & n.text & chr( 10 )
        end if
    next

    return outp
end function

end namespace
