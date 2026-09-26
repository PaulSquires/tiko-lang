'' Shared by vtable-two-a.bas and vtable-two-b.bas: two types with a virtual method,
'' so both modules need B's and D's vtables and RTTI records.
type B extends object
    declare virtual function f( ) as long
end type

type D extends B
    declare function f( ) as long override
end type

declare sub other( byref o as B )
declare function makeD( ) as B ptr
