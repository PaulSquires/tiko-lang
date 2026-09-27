'' diskcache.bas -- the pieces of an on-disk cache. Moved out of driver/cicache.bas
'' unchanged when the module cache (ADR 0017, RFC-0005 §4) became their second user.
''
'' A COMMIT IS ATOMIC: every file goes in under a temporary name and is MOVED over its final
'' one -- ReplaceFileW on Windows, rename on POSIX -- so two builds committing one entry at
'' once each leave a whole file, and since the key decides the content, whichever wins is
'' right.

#include once "support/diskcache.bi"
#include once "fb/filesystem.bi"

namespace Tko.DiskCache

function Hash( byref s as string ) as string
    dim as ulongint h = &hCBF29CE484222325ull
    for i as long = 0 to len( s ) - 1
        h xor= s[i]
        h *= &h100000001B3ull
    next
    return lcase( hex( h, 16 ) )
end function

function Stamp( byref path_ as string ) as string
    dim as FB.FsResultInfo r = FB.Stat( path_ )
    if r.IsOk( ) = false then return ""
    dim as FB.FileInfo fi = r.Value( )
    if fi.IsFile( ) = false then return ""
    return str( fi.Size( ) ) & chr( 9 ) & str( fi.ModifiedUtc( ) )
end function

function ReadAll( byref path_ as string, byref text as string ) as boolean
    dim as long f = freefile( )
    if open( path_ for binary access read as #f ) <> 0 then return false
    dim as longint n = lof( f )
    text = space( n )
    if n > 0 then get #f, , text
    close #f
    return true
end function

function Commit( byref path_ as string, byref text as string, byval serial as long ) as boolean
    dim as string tmp = path_ & "." & hex( cast( ulongint, timer * 1000000.0 ), 12 ) & "." & serial & ".tmp"
    dim as long f = freefile( )
    if open( tmp for binary access write as #f ) <> 0 then return false
    if len( text ) then put #f, , text
    close #f
    dim as FB.FsResultBool r = FB.MoveFile( tmp, path_, true )
    if r.IsOk( ) = false then
        FB.RemoveFile( tmp )
        return false
    end if
    return true
end function

end namespace
