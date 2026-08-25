type T
    as long v
end type
type Opt( of T2 )
    as T2 value
    as boolean has
end type
function Some( of T4 )( byref v as T4 ) as Opt( of T4 )
    dim as Opt( of T4 ) r
    r.value = v
    r.has = true
    return r
end function
function mk( ) as T
    dim as T r
    r.v = 7
    return r
end function
function f( ) as Opt( of T )
    function = Some( mk( ) )
end function
dim as Opt( of T ) o = f( )
