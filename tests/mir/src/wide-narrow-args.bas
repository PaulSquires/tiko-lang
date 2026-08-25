function g1( byref s as string, isfixed as integer ) as zstring ptr
    return strptr( s )
end function
function g2( byref z as zstring, isfixed as integer ) as zstring ptr
    return @z
end function
function g3( byval pz as zstring ptr, isfixed as integer ) as zstring ptr
    return pz
end function
function f1( byref w as wstring, isfixed as integer ) as wstring ptr
    return @w
end function
function f2( byval pw as wstring ptr, isfixed as integer ) as wstring ptr
    return pw
end function
dim s as string = "a"
dim as zstring * 4 z = "a"
dim as wstring * 4 w = "a"
print *g1( w, 0 ) = "a"
print *g1( whex( 1 ), 0 ) = "1"
print *g2( w, 0 ) = "a"
print *g2( whex( 1 ), 0 ) = "1"
print *g3( w, 0 ) = "a"
print *g3( whex( 1 ), 0 ) = "1"
print *f1( s, 0 ) = "a"
print *f1( z, 0 ) = "a"
print *f1( hex( 1 ), 0 ) = "1"
print *f2( s, 0 ) = "a"
print *f2( z, 0 ) = "a"
print *f2( hex( 1 ), 0 ) = "1"
