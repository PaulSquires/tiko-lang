'' OVERLOAD BELONGS TO THE NAME, not to the declaration that spelled it: a definition
'' that does not repeat the keyword still mangles as an overload, and is the same
'' procedure as the declaration rather than a second candidate.
declare function pr overload ( byval p as long ) as long
declare function pr overload ( byval p as double ) as double

function pr( byval p as long ) as long
    return 1
end function

function pr( byval p as double ) as double
    return 2
end function

'' ...and the string family has an ORDER, so two string overloads do not tie. A narrow
'' literal takes 'string' over 'ustring'; a wide one takes 'wstring'.
declare function tx overload ( byref p as const string ) as long
declare function tx overload ( byref p as const ustring ) as long
declare function tx overload ( byref p as const wstring ) as long

function tx( byref p as const string ) as long
    return 10
end function

function tx( byref p as const ustring ) as long
    return 11
end function

function tx( byref p as const wstring ) as long
    return 12
end function

print pr( 3 ), pr( 3.5 )
print tx( "abc" ), tx( wstr( "abc" ) )
