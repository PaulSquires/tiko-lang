'' VAL OVER A UDT THAT CASTS TO WSTRING -- AfxNova's DWSTRING is the case that matters.
'' The VAL family took its wide entry point only when the operand's TYPE was a wide
'' string, and a UDT's type is the UDT's, so it asked for a narrow descriptor, had none,
'' and the statement was dropped from the build without a diagnostic -- leaving each
'' function to fall off its end, which clang refused as 'ret void' in a function
'' returning a value. Measured, fbc-modern: the cast operator is called and what it
'' returns is handed to fb_WstrVal, and this program prints 2026 and 12.5.
type WS
    as wstring * 16 text
    declare operator cast( ) byref as wstring
end type

operator WS.cast( ) byref as wstring
    return this.text
end operator

function mk( ) as WS
    dim as WS r
    r.text = "12.5"
    return r
end function

function fromVar( byref w as WS ) as long
    return val( w )
end function

function fromTemp( ) as double
    return val( mk( ) )
end function

dim as WS w
w.text = "2026"
print fromVar( w ), fromTemp( )
