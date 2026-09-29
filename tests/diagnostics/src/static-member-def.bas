'' A static member defined with another type, or byref where it was declared not -- fbc's
'' error 20 (131 for the explicit type) on the refused lines.
type UDT
    dummy as integer
    static i as integer
    static j as integer
    static k as integer
    static ri as integer
end type
dim shared x as integer
var UDT.i = cshort( 0 )                        '' 20
dim UDT.j as short                             '' 131
dim shared byref UDT.ri as integer = x         '' 20
var UDT.k = 0                                  '' fine
