'' A module with target-specific bodies (RFC-0003 §1) -- what std/path's sep.bas was, before
'' std/path was folded into std/fs (RFC-0009 M30).
#module "sep"

public function Separator( ) as string
#ifdef __FB_WIN32__
    return chr( 92 )
#else
    return "/"
#endif
end function

public function IsAbsolute( byref p as string ) as boolean
    if len( p ) = 0 then return false
#ifdef __FB_WIN32__
    if (p[0] = asc( "/" )) orelse (p[0] = 92) then return true
    return (len( p ) >= 2) andalso (p[1] = asc( ":" ))
#else
    return p[0] = asc( "/" )
#endif
end function
