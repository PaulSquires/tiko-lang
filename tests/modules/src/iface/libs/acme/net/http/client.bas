'' A module whose interface names another module's type, through its own alias for it.
#module "http"
#import "acme/text/esc"
function Send_( byref u as esc.Url ) as long
    return len( u.s )
end function
public function Fetch( byref x as string ) as esc.Url
    esc.calls += 1
    dim as esc.Url u = esc.Quote( x )
    Send_( u )
    return u
end function
public type Box( of T )
    v as T
    declare function Twice( ) as T
end type
'' A generic body calling a module-private helper: the importer instantiates it, inside
'' the module's namespace, where the helper is found; the helper links, being hidden and
'' not internal.
function Add_( byval a as long, byval b as long ) as long
    return a + b
end function
function Box( of T ).Twice( ) as T
    return Add_( v, v )
end function
public const HTTP_PORT = 80
public enum Verb
    GET_ = 1
    POST_
end enum
namespace Inner
    public function Ping( ) as long
        return 7
    end function
end namespace
public dim shared hits as long = 3
