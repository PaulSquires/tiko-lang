'' std/path's target-specific half: the separator, and what an absolute path looks like.
#module "path"

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
