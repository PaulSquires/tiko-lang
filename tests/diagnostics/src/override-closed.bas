'' T47: 'override' on a method whose slot was closed by a non-virtual override, or by an
'' implicit one, overrides nothing -- fbc's error 223, TKO0621 here.
type A extends Object
    declare virtual function F( ) as long
    declare abstract function G( ) as long
end type
function A.F( ) as long : return 1 : end function

type B extends A
    declare function F( ) as long override
    declare function G( ) as long override
end type
function B.F( ) as long : return 2 : end function
function B.G( ) as long : return 2 : end function

type C extends B
    declare function F( ) as long override
    declare function G( ) as long override
end type
function C.F( ) as long : return 3 : end function
function C.G( ) as long : return 3 : end function

type B2 extends A
    declare function F( ) as long
    declare function G( ) as long
end type
function B2.F( ) as long : return 4 : end function
function B2.G( ) as long : return 4 : end function

type C2 extends B2
    declare function F( ) as long override
end type
function C2.F( ) as long : return 5 : end function
