'' A FIELD WRITTEN THROUGH A BYREF GETTER, named without parentheses: 'h.only.x = 7' over
'' 'property only( ) byref as V' writes h's own field. tiko wrote a copy of it. fbc 1.10.1
'' prints 7 and 9.
type V
    as double x, y
end type
type H
    as V v_
    declare property only( ) byref as V
    declare function fn( ) byref as V
end type
property H.only( ) byref as V
    return v_
end property
function H.fn( ) byref as V
    return v_
end function
dim as H hh
hh.only.x = 7
print hh.v_.x
hh.fn.y = 9
print hh.v_.y
