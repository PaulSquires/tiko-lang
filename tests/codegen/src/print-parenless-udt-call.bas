' PRINT of a UDT-returning method called without parentheses, the UDT printing through
' its string cast.
type Complex
    as double re, im
    declare function conj() as Complex
    declare operator cast() as string
end type
function Complex.conj() as Complex
    return type<Complex>(re, -im)
end function
operator Complex.cast() as string
    return re & "," & im
end operator
dim as Complex x = (1, 3)
dim as string s = x.conj
print x.conj; "|"; x.conj(); "|"; s
