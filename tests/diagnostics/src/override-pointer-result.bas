'' A POINTER RESULT MAY BE COVARIANT. Measured with fbc-modern: the override's pointee
'' may be the base's own type or one derived from it, at the same depth, and may drop a
'' const but not add one; const on the pointer itself is not compared. Everything else
'' is error 225 -- on lines 29 to 32, and nowhere else.
type U extends object
    as long x
end type
type B extends object
    declare virtual function f1( ) as B ptr
    declare virtual function f2( ) as B ptr ptr
    declare virtual function f3( ) as const B ptr
    declare virtual function f4( ) as object ptr
    declare virtual function f5( ) as B ptr
    declare virtual function f6( ) as B ptr
    declare virtual function e1( ) as B ptr
    declare virtual function e2( ) as B ptr
    declare virtual function e3( ) as any ptr
    declare virtual function e4( ) as B ptr
end type
type D extends B
    '' accepted
    declare function f1( ) as D ptr
    declare function f2( ) as D ptr ptr
    declare function f3( ) as D ptr
    declare function f4( ) as D ptr
    declare function f5( ) as D const ptr
    declare function f6( ) as B ptr
    '' error 225
    declare function e1( ) as const D ptr
    declare function e2( ) as U ptr
    declare function e3( ) as D ptr
    declare function e4( ) as any ptr
end type
