'' WHAT A PROCEDURE DEFINITION CANNOT DO, and WHAT A BYREF RESULT CANNOT RETURN.
'' Measured against fbc: errors 24 ('as any'), 59 (unnamed parameter), 184 (result type
'' without a default constructor), 272 (a byval parameter by reference), 24 (iif) and
'' 318 (a string literal into 'byref as string'); the accepted lines compile.
'' fbc reports 184 on the 'end function' line and this compiler on the definition's; fbc's
'' follow-on 316 after the iif line (the result 'not set' because the assignment failed)
'' is a cascade and is not modelled.
type UDT
    as integer a
    declare constructor( byval i as integer )
end type
constructor UDT( byval i as integer )
end constructor
type Defaulted
    as integer a
    declare constructor( byval i as integer = 0 )
end type
constructor Defaulted( byval i as integer )
end constructor
declare sub okDecl( ( ) as integer )
function f1( ) as any
end function
sub f2( ( ) as integer )
end sub
function f3( ) as UDT
    function = type( 1 )
end function
function f4( ) as Defaulted
    function = type( 1 )
end function
function f5( ) byref as UDT
    static u as UDT = UDT( 1 )
    function = u
end function
declare function f6( ) as UDT
function f7( byval i as integer ) byref as integer
    function = i
end function
function f8( byref i as integer ) byref as integer
    function = i
end function
dim shared as integer ga, gb, gc
function f9( ) byref as integer
    function = iif( ga, gb, gc )
end function
function f10( ) byref as string
    function = "abc"
end function
function f11( ) byref as zstring
    function = "abc"
end function
