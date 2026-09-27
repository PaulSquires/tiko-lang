'' Re-exported by acme.web: an importer of web reaches this as web.core.
#module "core"
public type Tag
    s as string
end type
public function MakeTag( byref x as string ) as Tag
    dim as Tag t
    t.s = "[" & x & "]"
    return t
end function
function Hidden_( ) as long
    return 1
end function
