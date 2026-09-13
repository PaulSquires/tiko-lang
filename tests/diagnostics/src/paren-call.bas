'' ONLY A PROCEDURE POINTER IS CALLED THROUGH PARENTHESES OR THROUGH A CALL'S RESULT.
'' fbc ends the expression at the '(' for anything else -- errors 3, 7, 24, 73 and 1 by
'' context -- so every line in 'refused' is one TKO0772, and nothing in 'accepted' is.
function g( byval i as integer ) as integer
    return i
end function
type FP as function( byval as integer ) as integer
function h( byval i as integer ) as FP
    return @g
end function
type P
    v as integer
    declare constructor( byval i as integer )
end type
constructor P( byval i as integer )
    v = i
end constructor
type T
    f as FP
end type

'' -- refused ------------------------------------------------------------------
sub refused( )
    dim as integer x, a(3)
    dim as integer ptr pi = @x
    dim as FP fp = @g
    print (1)(2)
    print (x)(1)
    print (pi)(1)
    print (*pi)(1)
    print (a)(1)
    print (g)(1)
    print (fp)(1)(2)
    print P(3)(1)
    x = g((x + 1)(2))
    (x)(1)
end sub

'' -- accepted -----------------------------------------------------------------
sub accepted( )
    dim as integer x
    dim as FP fp = @g
    dim as FP ptr pfp = @fp
    dim as FP fa(2)
    dim as T t1
    t1.f = @g
    fa(0) = @g
    x = (fp)(1)
    x = ((fp))(1)
    x = (*pfp)(1)
    x = (@g)(1)
    x = (t1.f)(1)
    x = (pfp[0])(1)
    x = h(1)(2)
    x = (h(1))(2)
    x = fa(0)(1)
    x = (fa(0))(1)
    (fp)(1)
end sub
