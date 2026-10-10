'' machine.bas -- see machine.bi

#import "std/containers"
#include once "diag/machine.bi"
#include once "support/text.bi"

namespace Tko.Machine

'' EVERY BYTE BELOW A SPACE BECOMES ONE. A record is one line of TAB-separated fields, and
'' '#print' passes its text through verbatim, so a TAB in it would add a field and a CR or
'' LF would end the record early. Nothing else is escaped: a Windows path has to reach the
'' reader with its backslashes single.
private function Clean_( byref s as string ) as string
    dim as string r = s
    for i as long = 0 to len( r ) - 1
        if r[i] < 32 then r[i] = 32
    next
    return r
end function

'' THE CHARACTER COLUMN of a byte offset: one more than the code points between the line
'' start and it. The buffer is normalised UTF-8, so a code point is a byte that is NOT a
'' continuation byte (10xxxxxx) -- and a tab is one, where DecodedLoc.column expands it.
'' A file that is not valid UTF-8 was kept verbatim (ENC_BYTES) and counts bytes, which is
'' what an editor showing it in a single-byte code page counts too.
private function CharCol_ _
    ( byval f as Tko.SourceFile ptr, byval lineStart as long, byval off as long ) as long

    if off <= lineStart then return 1
    if off > f->text.Count then off = f->text.Count
    if f->encoding = Tko.Text.ENC_BYTES then return off - lineStart + 1
    dim as long n = 1
    for i as long = lineStart to off - 1
        if (f->text[i] and &hC0) <> &h80 then n += 1
    next
    return n
end function

'' id, file, line, col, endLine, endCol, message -- the seven fields after the kind.
private function Fields_ _
    ( byval id as Tko.DiagId, byref rng as Tko.SourceRange, byval hasLoc as boolean, _
      byref text as string, byref src as Tko.SourceManager ) as string

    dim as string T = chr( 9 )
    dim as string path_ = ""
    dim as long l1 = 0, c1 = 0, l2 = 0, c2 = 0

    dim as boolean located = hasLoc andalso (rng.first <> Tko.LOC_NONE)
    if located then
        dim as Tko.DecodedLoc a = src.Decode( rng.first )
        dim as Tko.SourceFile ptr f = src.FileAt( a.file )
        '' A location the manager cannot place is written as none rather than as a
        '' guess -- an editor would open the wrong file, or line 0 of the right one.
        if f <> 0 then
            path_ = src.AbsPathOf( a.file )
            l1 = a.physLine
            c1 = CharCol_( f, src.LineStart( a.file, a.physLine ), a.offset )

            '' THE END IS EXCLUSIVE, just past the character range.last names (which is
            '' itself inclusive -- location.bi). A last in another file, or before the
            '' first, gives the one-character range at the start instead.
            l2 = l1
            c2 = c1 + 1
            if rng.last <> Tko.LOC_NONE then
                dim as Tko.DecodedLoc b = src.Decode( rng.last )
                dim as boolean forward_ = (b.file = a.file) andalso (b.offset >= a.offset)
                if forward_ then
                    l2 = b.physLine
                    c2 = CharCol_( f, src.LineStart( b.file, b.physLine ), b.offset ) + 1
                end if
            end if
        end if
    end if

    return Tko.DiagIdName( id ) & T & Clean_( path_ ) & T & _
           str( l1 ) & T & str( c1 ) & T & str( l2 ) & T & str( c2 ) & T & _
           Clean_( text )
end function

function Header( ) as string
    return "tiko-diagnostics" & chr( 9 ) & str( FORMAT_VERSION ) & chr( 10 )
end function

function Records _
    ( byref d as Tko.Diagnostic, byref src as Tko.SourceManager ) as string

    dim as string outp = Tko.SeverityName( d.sev ) & chr( 9 ) & _
        Fields_( d.id, d.range, d.hasLocation, d.text, src ) & chr( 10 )

    '' A NOTE FOLLOWS ITS DIAGNOSTIC, as 'related', so a reader can hang it off the one
    '' before it. Notes are never counted -- they are part of the diagnostic above.
    for each n as Tko.DiagNote in d.notes
        outp += "related" & chr( 9 ) & _
            Fields_( n.id, n.range, true, n.text, src ) & chr( 10 )
    next
    return outp
end function

function EndRecord _
    ( byval errors as long, byval warnings as long, byval exitCode as long ) as string

    dim as string T = chr( 9 )
    return "end" & T & str( errors ) & T & str( warnings ) & T & str( exitCode ) & chr( 10 )
end function

end namespace
