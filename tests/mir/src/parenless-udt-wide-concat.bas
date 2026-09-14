'' A PAREN-LESS CALL TO A FUNCTION RETURNING A UDT THAT CASTS TO WSTRING, in a wide
'' concatenation. AfxNova's 'AfxGetExePathName & "\_debug.txt"' -- the first line of
'' tracks' WinMain -- is this shape, and DWSTRING is the UDT.
''
'' The wide cast took the operand's ADDRESS, and a bare procedure name's address is
'' the procedure's: MIR said 'func.addr ptr GETPATH', the cast operator was handed the
'' function's own code as 'this', and tracks died in wcslen before any window existed.
'' With parentheses the same expression was a call and was right.
''
'' Measured, fbc-modern, all four lines print the path with its suffix:
''
''     [C:\dir\a.txt]   [C:\dir\b.txt]   C:\dir\c.txt   C:\dir\d.txt
type DS
    as wstring * 64 w
    declare operator cast( ) byref as wstring
end type

operator DS.cast( ) byref as wstring
    return this.w
end operator

function GetPath( ) as DS
    dim as DS r
    r.w = "C:\dir"
    return r
end function

sub Show( byref s as wstring )
    print "[" & s & "]"
end sub

Show( GetPath( ) & "\a.txt" )
Show( GetPath & "\b.txt" )
dim as wstring * 80 t = GetPath & "\c.txt"
print t
print GetPath & "\d.txt"
