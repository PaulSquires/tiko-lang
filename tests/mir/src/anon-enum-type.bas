'' AN ANONYMOUS ENUM'S MEMBERS ARE TYPED. fbc gives the enum a generated name --
'' measured, '#print typeof( AA )' over a member of one prints 'TMP$2' and the next
'' anonymous enum's member 'TMP$3' -- so its members have a type like any others.
enum
	AA = 6
end enum

declare function g( byval a as long ) as long
function g( byval a as long ) as long
	function = a
end function

dim as long p = g( AA )
dim as long q = AA + 1
