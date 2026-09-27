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
'' A public operator on a public type: an importer finds it with no 'using'.
public operator + ( byref a as Url, byref b as Url ) as Url
    dim as Url r
    r.s = a.s & b.s
    return r
end operator
