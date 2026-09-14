'' A UDT'S 'operator cast( ) as any ptr' STILL REACHES A SINGLE PROCEDURE. fbc refuses it
'' only once the procedure is overloaded (error 99); called on its own, fbc binds it.
'' AfxNova's 'RETURN NOT SetEnvironmentVariable( dwsName, dwsValue )' is this shape, and
'' when the cast was dropped everywhere the call came out untyped, the RETURN had no
'' value, and clang refused the module: "value doesn't match function result type 'i8'".
''
'' fbc prints: true            5
type U
    m as wstring ptr
    declare operator cast( ) byref as const wstring
    declare operator cast( ) as any ptr
end type
operator U.cast( ) byref as const wstring
    return *m
end operator
operator U.cast( ) as any ptr
    return m
end operator
function SetEnv( byval a as wstring ptr, byval b as wstring ptr ) as long
    return len( *a ) + len( *b )
end function
function F( byref x as U, byref y as U ) as boolean
    return not SetEnv( x, y )
end function
dim as wstring * 8 w1 = "ab", w2 = "cde"
dim as U u1, u2
u1.m = @w1 : u2.m = @w2
print F( u1, u2 ), SetEnv( u1, u2 )
