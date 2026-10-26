'' A FIELD OF A CONST OBJECT for a non-const byref parameter: fbc-modern 1.20 refuses each
'' of the three calls on line 17 with error 181 (2026-10-25) -- through a 'byref as const T'
'' parameter, a nested field, and a pointer to a const T. Line 19 is fine: a non-const
'' object, a 'byref as const' parameter, and a pointer field of a const object (its
'' pointee is not const). tiko accepted all three and wrote through (tiko-studio TS-001's gap).
type Inner
    v as long
end type
type T
    a as long
    i as Inner
    q as long ptr
end type
sub F( byref x as long ) : x = 5 : end sub
sub FC( byref x as const long ) : end sub
sub G( byref t as const T, byval pc as const T ptr, byref m as T )
    F( t.a ) : F( t.i.v ) : F( pc->a )
    '' accepted
    F( m.a ) : FC( t.a ) : F( *t.q )
end sub
