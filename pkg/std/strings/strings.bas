'' std/strings -- string helpers, as a module (ADR 0017; RFC-0007 §6).
#module "strings"

'' Does s begin with prefix? An empty prefix begins every string.
public function StartsWith( byref s as string, byref prefix as string ) as boolean
    return left( s, len( prefix ) ) = prefix
end function

'' Does s end with suffix?
public function EndsWith( byref s as string, byref suffix as string ) as boolean
    if len( suffix ) > len( s ) then return false
    return right( s, len( suffix ) ) = suffix
end function

'' Does s contain part anywhere?
public function Contains( byref s as string, byref part as string ) as boolean
    if len( part ) = 0 then return true
    return instr( s, part ) > 0
end function

'' s with every occurrence of what replaced by with_, left to right, not re-scanned.
public function Replace( byref s as string, byref what as string, byref with_ as string ) as string
    if len( what ) = 0 then return s
    dim as string outp = ""
    dim as long p = 1
    do
        dim as long at = instr( p, s, what )
        if at = 0 then exit do
        outp &= mid( s, p, at - p ) & with_
        p = at + len( what )
    loop
    return outp & mid( s, p )
end function

'' s, n times over. Nothing for n <= 0.
public function Repeat( byref s as string, byval n as long ) as string
    dim as string outp = ""
    for i as long = 1 to n
        outp &= s
    next
    return outp
end function

'' s cut at every sep into parts(), which is resized to hold them; the count. An empty sep
'' gives s whole.
public function Split( byref s as string, byref sep as string, parts( ) as string ) as long
    dim as long n = 0
    redim parts( 0 to 0 )
    if len( sep ) = 0 then
        parts( 0 ) = s
        return 1
    end if
    dim as long p = 1
    do
        dim as long at = instr( p, s, sep )
        redim preserve parts( 0 to n )
        if at = 0 then
            parts( n ) = mid( s, p )
            return n + 1
        end if
        parts( n ) = mid( s, p, at - p )
        n += 1
        p = at + len( sep )
    loop
end function

'' Module-private: what Surround's body calls -- in the importer, where it is instantiated.
function Around_( byref inner as string, byref l as string, byref r as string ) as string
    return l & inner & r
end function

'' x, as text, between l and r: 'Surround( 42, "[", "]" )' is "[42]". Generic, so its body
'' travels in the interface and is instantiated by each importer.
public function Surround( of T )( byval x as T, byref l as string, byref r as string ) as string
    return Around_( str( x ), l, r )
end function
