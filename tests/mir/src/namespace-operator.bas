'' A BINARY OPERATOR MAY BE A FREE FUNCTION, and fbc allows a global one inside a
'' namespace -- namespace/outside says so in its own comment before writing exactly
'' this. Held to be a member by construction, 'operator op.+' took a receiver every
'' call site correctly did not pass, so both operands arrived one place late.
''
'' Measured against fbc, which prints '12 -6'.
namespace op
    type UDT
        as integer a
    end type

    declare operator +( a as UDT, b as UDT ) as integer

    '' Defined INSIDE the namespace, unqualified -- this one always worked: nothing
    '' declares a 'this' for an unqualified definition in the first place.
    operator -( a as UDT, b as UDT ) as integer
        operator = a.a - b.a - 2
    end operator
end namespace

'' ...and OUTSIDE it, qualified, which is the shape that was wrong.
operator op.+( a as op.UDT, b as op.UDT ) as integer
    operator = a.a + b.a + 2
end operator

'' A MEMBER OPERATOR MUST STILL KEEP ITS RECEIVER. The question is now the one an
'' ordinary qualified procedure asks -- is a TYPE scope around it -- and this is the
'' case that would have been broken by answering it wrongly.
type V
    as integer a
    declare operator +=( byref rhs as V )
end type

operator V.+=( byref rhs as V )
    this.a += rhs.a
end operator

dim as op.UDT a, b
a.a = 3 : b.a = 7

dim as V x, y
x.a = 5 : y.a = 7
x += y

print a + b, a - b, x.a
