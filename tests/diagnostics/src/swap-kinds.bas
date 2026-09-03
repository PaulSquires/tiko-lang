'' SWAP EXCHANGES STORAGE AND CONVERTS NOTHING, so its two operands must be of the same
'' KIND -- fbc error 20. Measured across the whole grid: NUMBER, STRING, POINTER and each
'' UDT are the four kinds, a fixed string counts as a STRING because it is an array of a
'' character builtin, and two UDTs must be the same type.
''
'' A UDT THAT DECLARES A CONVERSION OPERATOR IS NOT THIS QUESTION -- 'swap str( u ), v'
'' over a type that casts to a zstring is accepted, and which overload runs is not modelled
'' here, so any 'cast' at all declines.
type Parent
    i as integer
end type
type Child extends Parent
    j as integer
end type
type Plain
    a as integer
end type
dim as string s1, s2
dim as integer i1, i2
dim as long lng
dim as double dbl
dim as boolean bool
dim as zstring * 8 z1, z2
dim as integer ptr ip
dim as any ptr ap
dim as Parent par
dim as Child chi
dim as Plain pl1, pl2
dim as integer arr1(0 to 3), arr2(0 to 3)
'' Accepted: the same kind on both sides, however wide the conversion within it.
swap i1, i2
swap i1, lng
swap i1, dbl
swap i1, bool
swap s1, s2
swap z1, z2
swap z1, s1
swap ip, ap
swap pl1, pl2
swap arr1(0), arr2(0)
'' Refused: the kinds differ, or the two UDTs are not the same type.
swap s1, i1
swap par, ap
swap par, chi
swap s1, ap
