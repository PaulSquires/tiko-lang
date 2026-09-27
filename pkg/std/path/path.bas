'' std/path -- path helpers, as a module (ADR 0017; RFC-0007 §6). The separator is the
'' target's (sep.bas); a '/' is taken as a separator on every target.
#module "path"

private function IsSep_( byval c as ubyte ) as boolean
    return (c = asc( "/" )) orelse (c = asc( Separator( ) ))
end function

private function LastSep_( byref p as string ) as long
    for i as long = len( p ) to 1 step -1
        if IsSep_( p[i - 1] ) then return i
    next
    return 0
end function

'' a and b joined by one separator.
public function JoinPath( byref a as string, byref b as string ) as string
    if len( a ) = 0 then return b
    if len( b ) = 0 then return a
    if IsSep_( a[len( a ) - 1] ) then return a & b
    return a & Separator( ) & b
end function

'' Everything before the last separator: "" when there is none.
public function DirName( byref p as string ) as string
    dim as long at = LastSep_( p )
    if at <= 1 then return left( p, at )
    return left( p, at - 1 )
end function

'' Everything after the last separator.
public function BaseName( byref p as string ) as string
    return mid( p, LastSep_( p ) + 1 )
end function

'' The extension of the last component, with its dot: "" when it has none.
public function Extension( byref p as string ) as string
    dim as string b = BaseName( p )
    dim as long dt = instrrev( b, "." )
    if dt <= 1 then return ""
    return mid( b, dt )
end function
