'' A GLOBAL 'operator &' OVER A WIDE-STRING UDT WITH A DESTRUCTOR (so its result is hidden-pointer) AND A 'byref as string' -- AfxNova's DWSTRING
'' shape, cut down. Two faults made every such concatenation empty:
''
''   'operator = a + s' is a wide concatenation through the UDT's 'cast( ) byref as const
''   wstring', which Check leaves untyped; no 'let' was chosen for the hidden result and the
''   statement was declined, so the operator returned a default-constructed value.
''
''   the literal and 'str( y )' operands were passed as the literal's BYTES (or a pool
''   descriptor) where the 'byref as string' parameter reads a descriptor.
''
'' fbc-modern prints (each character a UTF-16 unit when redirected):
''
''    [Fevrier 2026]
''    [Fevrier 2026]
''    [Fevrier 2026]
type WS
    buf as wstring * 64
    declare constructor( )
    declare constructor( byref w as wstring )
    declare destructor( )
    declare operator let( byref w as wstring )
    declare operator cast( ) byref as const wstring
end type
constructor WS( )
    buf = ""
end constructor
destructor WS( )
end destructor
constructor WS( byref w as wstring )
    buf = w
end constructor
operator WS.let( byref w as wstring )
    buf = w
end operator
operator WS.cast( ) byref as const wstring
    return buf
end operator
operator & ( byref a as WS, byref s as string ) as WS
    operator = a + s
end operator
function title( byref m as WS, byval y as long ) as WS
    return m & " " & str( y )
end function
dim as WS a
a.buf = "Fevrier"
dim as WS b = a & " 2026"
print "["; b.buf; "]"
dim as long y = 2026
dim as WS c = a & " " & str( y )
print "["; c.buf; "]"
dim as WS t = title( a, y )
print "["; t.buf; "]"
