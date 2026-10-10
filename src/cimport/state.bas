'' state.bas -- what one import decided, handed to the next: delta bindings. See import.bi.
''
'' TWO #cinclude LINES SHARE HEADERS. windows.h and sqlite3.h both pull in stddef.h, and two
'' bindings that each declared size_t would be a duplicate definition in the unit that
'' includes both. So the second is imported TOGETHER with the first -- one translation unit,
'' '#include "h1"' then '#include "h2"' -- seeded with everything the first decided, and
'' only what is new is written.
''
'' THE SEED IS THE WHOLE DECISION, not a list of names to leave out: every USR's FreeBASIC
'' name and state, the C name each declaration answered to (for an alias to find), every
'' name claimed in either namespace, and the macros already considered. Pass 1 then names
'' only what the first import never saw, colliding with everything it did -- a function
'' 'foo' in h2 beside a constant FOO in h1 is 'foo_2', not a duplicate definition -- and
'' pass 2 finds everything the first emitted or refused already decided.
''
'' Text, one fact a line, so it goes in the cache beside the binding it describes.

#import "std/containers"
#include once "cimport/import.bi"

namespace Tko.CImport

const STATE_HEADER = "cimport-state 1"

function StateExport( byref x as CImp ) as string
    dim as string t = chr( 9 ), nl = chr( 10 )
    dim as Tko.StrVec parts
    parts.Push( STATE_HEADER & nl )
    for id as long = 0 to x.usrState.Count - 1
        dim as ubyte st = x.usrState[id] and (not US_SEEDED)
        if (st = 0) andalso (x.usrName[id] = 0) then continue for
        parts.Push( "u" & t & st & t & x.strs.Spelling( cast( InternId, id ) ) & t & _
                    UsrFbName( x, id ) & nl )
    next
    for id as long = 0 to x.cDeclUsr.Count - 1
        if x.cDeclUsr[id] = 0 then continue for
        parts.Push( "c" & t & x.strs.Spelling( cast( InternId, id ) ) & t & _
                    x.strs.Spelling( cast( InternId, x.cDeclUsr[id] - 1 ) ) & nl )
    next
    for f as long = 0 to x.claimType.Count - 1
        if x.claimType[f] then parts.Push( "t" & t & x.strs.Spelling( cast( InternId, f ) ) & nl )
    next
    for f as long = 0 to x.claimValue.Count - 1
        if x.claimValue[f] then parts.Push( "v" & t & x.strs.Spelling( cast( InternId, f ) ) & nl )
    next
    '' EVERY MACRO CONSIDERED, seeded ones included -- a third #cinclude must not see
    '' the first one's macros as new.
    for id as long = 0 to x.macroSeen.Count - 1
        if x.macroSeen[id] then parts.Push( "m" & t & x.strs.Spelling( cast( InternId, id ) ) & nl )
    next
    for i as long = 0 to x.aliasNames.Count - 1
        parts.Push( "a" & t & x.aliasNames[i] & nl )
    next
    return JoinParts( parts )
end function

'' The fields of one line, split at tabs.
private sub Fields_( byref ln as string, f() as string, byref n as long )
    n = 0
    dim as long p = 1
    do
        dim as long q = instr( p, ln, chr( 9 ) )
        if n > ubound( f ) then redim preserve f( n + 3 )
        if q = 0 then
            f( n ) = mid( ln, p )
            n += 1
            exit do
        end if
        f( n ) = mid( ln, p, q - p )
        n += 1
        p = q + 1
    loop
end sub

function StateSeed( byref x as CImp, byref state as string ) as boolean
    if left( state, len( STATE_HEADER ) ) <> STATE_HEADER then return false
    dim as string f( 0 to 3 )
    dim as long nf
    dim as long p = len( STATE_HEADER ) + 2
    while p <= len( state )
        dim as long e = instr( p, state, chr( 10 ) )
        if e = 0 then e = len( state ) + 1
        dim as string ln = mid( state, p, e - p )
        p = e + 1
        if len( ln ) = 0 then continue while
        Fields_( ln, f(), nf )
        select case f( 0 )
        case "u"
            if nf < 4 then continue while
            dim as long id = UsrId( x, f( 2 ) )
            dim as ubyte bits = cast( ubyte, valint( f( 1 ) ) )
            if len( f( 3 ) ) then
                UsrSetName( x, id, f( 3 ) )
            end if
            UsrSet( x, id, bits or US_SEEDED )
            '' A RECORD THE FIRST IMPORT NEVER SAW DEFINED is watched: if this one defines
            '' it, the first binding's opaque 'any' and this binding's record would be two
            '' types for one C struct.
            if (bits and US_DEFINED) = 0 then x.seedUndefined.Push( id )
        case "c"
            if nf >= 3 then NoteDecl( x, f( 1 ), UsrId( x, f( 2 ) ) )
        case "t"
            if nf >= 2 then NameSeedClaim( x, NS_TYPE, f( 1 ) )
        case "v"
            if nf >= 2 then NameSeedClaim( x, NS_VALUE, f( 1 ) )
        case "m"
            if nf >= 2 then MacroSeen( x, f( 1 ) )
        case "a"
            if nf >= 2 then
                NameSeedClaim( x, NS_VALUE, f( 1 ) )
                x.aliasNames.Push( f( 1 ) )
            end if
        end select
    wend
    return true
end function

'' A record the seed never saw defined that this unit defines. "" when there is none.
function StateConflict( byref x as CImp ) as string
    for i as long = 0 to x.seedUndefined.Count - 1
        dim as long id = x.seedUndefined[i]
        if (UsrState( x, id ) and US_DEFINED) <> 0 then
            dim as string nm = UsrFbName( x, id )
            if len( nm ) = 0 then nm = x.strs.Spelling( cast( InternId, id ) )
            return nm
        end if
    next
    return ""
end function

end namespace
