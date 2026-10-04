'' render.bas -- see render.bi

#include once "diag/render.bi"
#include once "diag/engine.bi"
#include once "support/text.bi"

namespace Tko.Render

function SeverityColor( byval s as Tko.Severity ) as string
    select case s
    case Tko.SEV_ERROR   : return ANSI_RED
    case Tko.SEV_WARNING : return ANSI_YELLOW
    case Tko.SEV_NOTE    : return ANSI_CYAN
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
    ( byref src as Tko.SourceManager, byref rng as Tko.SourceRange, _
      byval useColor as boolean, byval caretColor as string ) as string

    dim as Tko.DecodedLoc a = src.Decode( rng.first )
    if a.file = Tko.FILE_NONE then return ""

    '' The SNIPPET is read by physical line -- a '#line' renumbers what the user is
    '' told, not where the bytes are.
    dim as string lineText = src.LineText( a.file, a.physLine )
    if len( lineText ) = 0 then
        '' An empty line still deserves a caret: it may be exactly where the
        '' problem is (a missing END IF at end of file, say).
        lineText = ""
    end if

    '' The underline runs to the end of the range when it stays on this line,
    '' otherwise to the end of the line.
    dim as Tko.DecodedLoc b = src.Decode( rng.last )
    dim as long lastCol = a.column
    dim as boolean sameLine = (b.file = a.file) andalso (b.physLine = a.physLine)
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
    '' a.column is a DISPLAY column -- a tab advances to the next stop -- so the row is
    '' built by walking the line's CHARACTERS: a tab is echoed as a tab and lands on the
    '' same stop, anything else is as many spaces as it is wide. Indexing the line BY
    '' the display column put the caret three cells right after one leading tab (F-67).
    dim as string caret = ""
    scope
        dim as long col = 1, bi = 0, n = len( lineText )
        dim as const ubyte ptr lp = cast( const ubyte ptr, strptr( lineText ) )
        while (col < a.column) andalso (bi < n)
            if lp[bi] = 9 then
                caret += chr( 9 )
                col = ((col - 1) \ Tko.Text.DEFAULT_TAB_WIDTH + 1) * Tko.Text.DEFAULT_TAB_WIDTH + 1
                bi += 1
            else
                dim as long w = Tko.Text.DisplayWidth( Tko.Text.DecodeUtf8( lp, n, bi ) )
                caret += space( w )
                col += w
            end if
        wend
        if col < a.column then caret += space( a.column - col )
    end scope
    caret += "^"
    for i as long = a.column + 1 to lastCol
        caret += "~"
    next

    outp += Tint( useColor, ANSI_GREY, pad + bar ) + Tint( useColor, caretColor, caret )
    return outp
end function

function Diagnostic_ _
    ( byref d as Tko.Diagnostic, byref src as Tko.SourceManager, _
      byval fmt as Tko.DiagOutputFormat, byval useColor as boolean ) as string

    dim as string sevName = Tko.SeverityName( d.sev )
    dim as string sevTinted = Tint( useColor, SeverityColor( d.sev ), sevName )
    dim as string idName = Tko.DiagIdName( d.id )
    dim as string outp = ""

    if d.hasLocation then
        dim as Tko.DecodedLoc loc = src.Decode( d.range.first )
        dim as string path = src.ShownPathOf( loc )
        if fmt = Tko.DIAGFMT_GNU then
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
        if fmt = Tko.DIAGFMT_GNU then
            outp += "tiko-lang: " & sevTinted & ": " & d.text & " [" & idName & "]" & chr( 10 )
        else
            outp += "tiko-lang: " & sevTinted & " " & idName & ": " & d.text & chr( 10 )
        end if
    end if

    for each n as Tko.DiagNote in d.notes
        dim as string noteTint = Tint( useColor, ANSI_CYAN, "note" )
        dim as boolean noteHasLoc = (n.range.first <> Tko.LOC_NONE)
        if noteHasLoc then
            dim as Tko.DecodedLoc nl = src.Decode( n.range.first )
            dim as string npath = src.ShownPathOf( nl )
            if fmt = Tko.DIAGFMT_GNU then
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
