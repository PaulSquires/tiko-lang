'' ir-spill.bas -- emitted with TKO_IR_SPILL=1: the module body goes to the spill file
'' after the globals and after every function (codegen/irsink.ti). The intrinsics and the
'' libm declarations are chosen from the WHOLE body, so the calls sit in different chunks.
type Shape extends object
    declare virtual function Area( ) as double
end type
function Shape.Area( ) as double
    return 0
end function
type Sq extends Shape
    as double side
    declare function Area( ) as double override
end type
function Sq.Area( ) as double
    return side * side
end function

dim shared as zstring * 8 greeting = "spilled"

function Root( byval x as double ) as double
    return sqr( x )
end function

function Tangent( byval x as double ) as double
    return tan( x )
end function

function Floored( byval x as double ) as long
    return int( x )
end function

dim as Sq s
s.side = 3
dim as Shape ptr p = @s
print greeting; " "; Root( 16 ); " "; Floored( 2.75 ); " "; p->Area( )
print using "#.###"; Tangent( 0.5 )
