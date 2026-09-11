#lang "fb"

type T1
    as integer i
end type

namespace nested1
    '' T1 from the ENCLOSING scope: nested1 has none yet.
    declare sub overload1 overload( byval as sub( byref as T1 ) )
    sub overload1 overload( byval p as sub( byref as T1 ) ) : end sub

    '' Overriding T1 with this new one.
    type T1
        as integer i
    end type

    '' A DIFFERENT overload now -- it is a different T1.
    declare sub overload1 overload( byval as sub( byref as T1 ) )
    sub overload1 overload( byval p as sub( byref as T1 ) ) : end sub
end namespace
