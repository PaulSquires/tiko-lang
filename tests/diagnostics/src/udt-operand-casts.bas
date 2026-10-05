'' WHICH CAST A UDT OPERAND NEEDS. Measured on fbc-modern over S1 casting to string, M1 to long and
'' N1 to both: lines 21-28 are error 20 -- '&' needs each UDT side's string cast, two UDTs a numeric
'' cast each, '+' against a string the string cast; lines 29-34 compile.
type S1
    as long q
    declare operator cast( ) as string
end type
operator S1.cast( ) as string : return "ab" : end operator
type M1
    as long q
    declare operator cast( ) as long
end type
operator M1.cast( ) as long : return 3 : end operator
type N1
    as long q
    declare operator cast( ) as long
    declare operator cast( ) as string
end type
operator N1.cast( ) as long : return 4 : end operator
dim as S1 sv : dim as M1 mv : dim as N1 nv
print sv + sv
print sv = sv
print mv + sv
print mv & sv
print mv & "x"
print mv & 5
print nv & mv
print mv + "x"
print sv & sv
print mv + mv
print nv + nv
print sv & 5
print sv + "x"
print nv & sv
