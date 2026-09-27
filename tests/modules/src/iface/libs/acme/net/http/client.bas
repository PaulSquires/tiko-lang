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
function Box( of T ).Twice( ) as T
    return v + v
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
