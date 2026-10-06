function f overload( byval p as integer ptr ) as string : return "integer ptr" : end function
function f overload( byval p as ulongint ptr ) as string : return "ulongint ptr" : end function
dim as longint ptr pll : dim as ulongint ptr pull : dim as integer ptr pi : dim as uinteger ptr pui
print f( pll ), f( pull ), f( pi ), f( pui )
function g overload( byval p as uinteger ptr ) as string : return "uinteger ptr" : end function
function g overload( byval p as longint ptr ) as string : return "longint ptr" : end function
print g( pull ), g( pi ), g( pll ), g( pui )
