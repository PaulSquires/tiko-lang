'' 'sizeof' AND 'len' OVER A NAME THAT IS BOTH A TYPE AND A PROCEDURE measure the TYPE.
'' windows.bi's 'type PRINTDLGW as tagPDW' beside 'function PrintDlgW( ... )' is the case:
'' 'sizeof( PRINTDLGW )' was refused as a call missing its argument (TKO0776). Measured,
'' fbc-modern prints 2 2 and 12 12 12 12 -- the SHORT, not foo's double, even though
'' 'foo( )' would be a well-formed call.
type FOO as short
declare function foo( ) as double
function foo( ) as double : return 1 : end function
print sizeof( foo ), len( foo )
type BAR as tagX
type tagX
    a as long
    b as long
    c as long
end type
declare function bar( byval p as BAR ptr ) as long
function bar( byval p as BAR ptr ) as long : return 0 : end function
print sizeof( BAR ), len( BAR ), sizeof( bar ), sizeof( tagX )
