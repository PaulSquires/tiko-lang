'' 'this' as a user operator's operand: 'this = this + o', 'o + this', '-this', and a byval
'' operand. fbc-modern 1.20 prints 3, 5, -5, 15 (2026-10-25); tiko said TKO0820 for the
'' binary and unary forms (by-example BUG-objects-4).
type P
    x as long
    declare sub AddTo( byref o as P )
    declare sub AddV( byref o as P )
    declare function Neg( ) as P
end type
type Q
    x as long
    declare sub AddV( byref o as Q )
end type
operator + ( byref a as P, byref b as P ) as P
    dim as P r
    r.x = a.x + b.x
    return r
end operator
operator + ( byval a as Q, byval b as Q ) as Q
    dim as Q r
    r.x = a.x + b.x
    return r
end operator
operator - ( byref a as P ) as P
    dim as P r
    r.x = -a.x
    return r
end operator
sub P.AddTo( byref o as P )
    this = this + o
end sub
sub P.AddV( byref o as P )
    this = o + this
end sub
function P.Neg( ) as P
    return -this
end function
sub Q.AddV( byref o as Q )
    this = this + o
end sub
dim as P a, b
a.x = 1 : b.x = 2
a.AddTo( b ) : print a.x
a.AddV( b ) : print a.x
print a.Neg( ).x
dim as Q q1, q2
q1.x = 10 : q2.x = 5
q1.AddV( q2 ) : print q1.x
