'' A project's own package called std, under -i: never what '#import "std/..."' finds.
#module "strings"
public function Repeat( byref s as string, byval n as long ) as string
    return "SHADOWED"
end function
