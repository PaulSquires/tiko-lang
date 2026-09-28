'' std/strings' own code, beside the facade over fb/string.bi that build/genfacades.py writes
'' in strings.bas (RFC-0009 M31). Surround is generic, so its body travels in the interface
'' and each importer instantiates it; Around_, which it calls, stays module-private.
#module "strings"

'' Module-private: what Surround's body calls -- in the importer, where it is instantiated.
function Around_( byref inner as string, byref l as string, byref r as string ) as string
    return l & inner & r
end function

'' x, as text, between l and r: 'Surround( 42, "[", "]" )' is "[42]".
public function Surround( of T )( byval x as T, byref l as string, byref r as string ) as string
    return Around_( str( x ), l, r )
end function
