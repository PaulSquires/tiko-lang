type U : a as integer : declare operator cast() as integer : end type
operator U.cast() as integer : return a : end operator
function f() as integer
    dim uu as U : uu.a = 7
    return uu
end function
print f()
function f2() as integer
    dim uu as U : uu.a = 7
    function = uu
end function
print f2()
