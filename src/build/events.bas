'' events.bas -- see events.bi.

#import "std/containers"
#include once "build/events.bi"

namespace Tko.Build

function JsonStr( byref s as string ) as string
    dim as string r = chr( 34 )
    for i as long = 0 to len( s ) - 1
        dim as long ch = s[i]
        select case ch
        case 34 : r &= chr( 92, 34 )
        case 92 : r &= chr( 92, 92 )
        case 10 : r &= chr( 92 ) & "n"
        case 13 : r &= chr( 92 ) & "r"
        case 9  : r &= chr( 92 ) & "t"
        case is < 32
            r &= chr( 92 ) & "u00" & lcase( hex( ch, 2 ) )
        case else
            r &= chr( ch )
        end select
    next
    return r & chr( 34 )
end function

'' ONE LINE, LF, NOTHING ELSE ON IT: an editor reads the stream a line at a time. 'print'
'' ends a line with the host's ending, which on Windows is CRLF, so the LF is written by hand.
sub EmitLine( byref obs as Observer, byref body as string )
    if obs.json = false then return
    print "{" & body & "}" & chr( 10 );
end sub

sub OnUnit _
    ( byval obs as any ptr, byref kind as string, byref unitName as string, byref status as string )

    if obs = 0 then return
    dim as Observer ptr o = obs
    o->units += 1
    EmitLine( *o, """event"":""unit"",""kind"":" & JsonStr( kind ) & ",""unit"":" & _
                  JsonStr( unitName ) & ",""status"":" & JsonStr( status ) )
end sub

sub OnArtifact( byval obs as any ptr, byref kind as string, byref path_ as string )
    if obs = 0 then return
    dim as Observer ptr o = obs
    EmitLine( *o, """event"":""artifact"",""kind"":" & JsonStr( kind ) & ",""path"":" & JsonStr( path_ ) )
end sub

sub OnFinish _
    ( byval obs as any ptr, byval errors as long, byval warnings as long, byval rc as long )

    if obs = 0 then return
    dim as Observer ptr o = obs
    o->finished = true
    o->errors = errors
    o->warnings = warnings
    o->exitCode = rc
end sub

end namespace
