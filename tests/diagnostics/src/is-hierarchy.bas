'' 'x IS T' is accepted only when T is STRICTLY DERIVED from x's static type. Every
'' line below that fbc-modern refuses carries its error number; the rest it accepts.
'' tests/diagnostics/is-hierarchy.test says how this was measured.
type A extends object
    x as long
end type
type B extends A
    y as long
end type
type C extends object
    z as long
end type
type D extends B
    w as long
end type
type U
    q as long
end type
type H
    m as A
end type
function MakeA( ) as A
    return A( )
end function
sub ByrefA( byref r as A )
    print ( r is B )                  '' accepted: derived, through a byref parameter
    print ( r is A )                  '' 298: the same type
end sub
sub ByrefB( byref r as B )
    print ( r is A )                  '' 298: a base
end sub

dim as A va
dim as B vb
dim as D vd
dim as U vu
dim as H vh
dim as object vo
dim as long n
dim as string s
dim as A ptr pa = new B
dim as B ptr pb = new B

print ( va is B )                     '' accepted: derived
print ( va is D )                     '' accepted: two levels down
print ( vo is A )                     '' accepted: OBJECT to a descendant
print ( *pa is B )                    '' accepted: through a dereference
print ( vh.m is B )                   '' accepted: a field
print ( MakeA( ) is B )               '' accepted: a call result

print ( va is A )                     '' 298: the same type
print ( vb is A )                     '' 298: a base
print ( vd is A )                     '' 298: a grandparent
print ( va is object )                '' 298: OBJECT itself
print ( vo is object )                '' 298: OBJECT over OBJECT
print ( va is C )                     '' 298: unrelated
print ( vb is C )                     '' 298: unrelated, from a derived type
print ( *pa is A )                    '' 298: the same type, through a pointer
print ( *pb is A )                    '' 298: a base, through a pointer

print ( vu is U )                     '' 297: the operand has no RTTI
print ( vu is A )                     '' 297: the operand has no RTTI
print ( va is U )                     '' 297: T has no RTTI
print ( vu is integer )               '' 297: the operand is judged before T

print ( n is A )                      '' 299: a number
print ( pa is A )                     '' 299: a pointer, not an object
print ( s is A )                      '' 299: a STRING
print ( va is integer )               '' 299: T is not a class
