'' A BYREF RESULT IS A POINTER -- the return type, and the RESULT SLOT with it.
type Inner
    as long a
end type
dim shared as Inner g

function fu( ) byref as Inner
    function = g
end function

function fl( ) byref as long
    function = g.a
end function

'' ...and a byref STRING result is a pointer to somebody else's data, not a local
'' descriptor: no fb_StrInit, no fb_StrAllocTempResult and nothing to release.
function fz( byval s as string ) byref as zstring
    function = *strptr( s )
end function

function fz2( byref z as zstring ) byref as zstring
    function = z
end function

dim as string s = "abc"
print fu( ).a, fl( ), fz( s ), fz2( s )

'' A BYVAL VAR-LENGTH STRING PARAMETER is a POINTER to a copy the caller builds and
'' deletes -- the callee owns a descriptor of its own.
sub takeByvalString( byval t as string )
    t = t + "x"
    print t
end sub

dim as string v = "a"
takeByvalString( v )
print v
