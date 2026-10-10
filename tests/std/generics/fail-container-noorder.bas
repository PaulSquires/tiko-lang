' TEST_MODE : COMPILE_ONLY_FAIL

'' A key type with no '<' cannot be an OrderedMap key.
''
'' Unlike Array's Sort -- where the requirement is pushed onto a free procedure
'' so that an Array of an unorderable T still works -- an ORDERED map has no
'' meaning without an ordering, so the requirement belongs on the type itself.
'' The diagnostic therefore lands at the DECLARATION, exactly as containers.Map's
'' HashOf requirement does.
''
'' The type below has '=' and a hash-shaped surface and would be a perfectly
'' good containers.Map key.  It is only the ORDER that is missing.
#import "std/containers"
using containers
type NoLess
	as long a
end type

operator = ( byref x as NoLess, byref y as NoLess ) as boolean
	return x.a = y.a
end operator

dim m as OrderedMap( of NoLess, long )
