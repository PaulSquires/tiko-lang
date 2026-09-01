'' A BYREF RESULT HANDS BACK THE STORAGE ITSELF, so there is nowhere for a conversion to
'' happen: fbc error 318 unless the assigned value has exactly the result's type.
'' MEASURED against 'byref as integer' -- 'long' is refused even though it is the same
'' WIDTH, so this is type identity, not conversion. CONST GOES ONE WAY: a const result
'' takes a non-const value, a non-const result does not take a const one.
''
'' ...and a LOCAL cannot be returned at all (error 272) -- through a field's array too,
'' which reads as a call and used to stop the walk at the field.
type UDT
    a(0 to 1) as integer
end type

function ok1( ) byref as integer
    static i as integer
    function = i
end function

function ok2( ) byref as const integer
    static i as integer
    function = i
end function

function bad1( ) byref as integer
    static d as double
    function = d
end function

function bad2( ) byref as integer
    static l as long
    function = l
end function

function bad3( ) byref as integer
    static ci as const integer = 0
    function = ci
end function

function bad4( ) byref as integer
    dim x as UDT
    function = x.a(0)
end function
