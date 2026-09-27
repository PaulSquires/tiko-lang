'' A dependency of acme.net.http, whose interface names this module's type.
#module "esc"
public type Url
    s as string
end type
public function Quote( byref x as string ) as Url
    dim as Url u
    u.s = "<" & x & ">"
    return u
end function
public dim shared calls as long
