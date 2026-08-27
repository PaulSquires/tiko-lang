'' A generic called with an EXPRESSION, not a name -- inference has to type the
'' expression itself, because this pass runs before Check.
type Opt( of T )
    dim as T v
    dim as boolean has
end type

function Mk( of T )( byref x as T ) as Opt( of T )
    dim as Opt( of T ) r
    r.v = x
    r.has = true
    return r
end function

function G( of T )( byval x as T ) as integer
    return 1
end function

dim as integer a = 2, b = 3
dim as Opt( of integer ) p = Mk( a )
dim as Opt( of integer ) w = Mk( a + b )
dim as integer z = G( a * b )
dim as Opt( of double ) d = Mk( a / b )
print p.has, w.has, z, d.has
