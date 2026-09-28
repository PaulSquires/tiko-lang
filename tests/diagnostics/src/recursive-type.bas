'' A TYPE THAT HOLDS ITSELF BY VALUE -- fbc's error 88 on lines 10, 14, 18, 22 and 26, and 24
'' on 38 and 39, a nested type holding the type around it (fbc-modern 1.20). tiko laid each
'' out. Line 31 holds UU through an ANONYMOUS type, which fbc takes. From line 42, a pointer,
'' a procedure type, a method's parameter and result, a static member and a type used after
'' its 'end' are all fbc's, and are accepted.
type S1
    a as long
    b as long
    c as long
    s as S1
end type
type S2
    a as long
    as S2 s
end type
type R1
    a as long
    arr( 0 to 1 ) as R1
end type
type D1
    a as long
    d( any ) as D1
end type
type D2
    a as long
    redim e( any ) as D2
end type
union UU
    a as long
    type
        u as UU
        v as long
    end type
end union
type T1
    a as long
    type T2
        m1 as T1
        as T1 m2
    end type
end type
type OK1
    a as long
    p as OK1 ptr
    f as function( byval as OK1 ) as OK1
    declare function M( byval o as OK1 ) as OK1
    static as OK1 shared_
end type
function OK1.M( byval o as OK1 ) as OK1 : return o : end function
dim as OK1 OK1.shared_
type OK2
    o as OK1
    q as OK2 ptr
end type
print "end"
