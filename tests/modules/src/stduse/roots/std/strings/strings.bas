'' A project's own package called std, under -i: never what '#import "std/..."' finds.
#module "strings"
public function Repeat( byval count as integer, byref s as string ) as string
    return "SHADOWED"
end function
