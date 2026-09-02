'' AN OVERRIDE'S RESULT MUST MATCH THE OVERRIDDEN METHOD'S -- fbc error 225. Measured:
'' 'byref as integer' overridden by 'as integer' is refused and so is the reverse, and
'' the CONSTNESS of a byref result counts -- 'byref as integer' overridden by 'byref as
'' const integer' is 225 -- while a covariant 'byref as B' over 'byref as A' stays legal.
type A extends object
    i as integer
end type
type B extends A
    j as integer
end type
type P extends object
    declare virtual function f( ) byref as integer
    declare virtual function g( ) as integer
    declare virtual function h( ) byref as integer
    declare virtual function cov( ) byref as A
end type
type C extends P
    declare function f( ) as integer override
    declare function g( ) byref as integer override
    declare function h( ) byref as const integer override
    declare function cov( ) byref as B override
end type
