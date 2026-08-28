'' SEVERAL DECLARATORS AFTER ONE 'as', EACH WITH AN INITIALISER. Measured -- fbc
'' accepts the shared-type form and rejects the repeated-type one (error 3 for
'' 'dim p as short = any, q as short = any'), and both types below are four and
'' sixteen bytes.
type S
	dim as short a = any, b = any
end type

type I
	dim as integer i = 5, j = 6
end type

dim s_ as S
dim i_ as I
s_.a = 1 : s_.b = 2
i_.i = 3 : i_.j = 4
print s_.a, s_.b, i_.i, i_.j
print sizeof( S ), sizeof( I )
