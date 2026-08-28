'' AN ENUM IS NOT ITS UNDERLYING INTEGER FOR OVERLOAD PURPOSES, and the cost is not
'' symmetric. Measured by RUNNING fbc over every pair below.
enum E
	e0, e1
end enum

function p2 overload ( byval a as integer ) as integer
	function = 1
end function
function p2 overload ( byval a as E ) as integer
	function = 2
end function

'' An INTEGER argument takes the integer overload, an ENUM argument its own: 1 and 2.
dim as integer i
dim as E ev = e1
print p2( i ), p2( ev )

'' A NUMERIC argument reaching an ENUM parameter is the dearest conversion short of a
'' user-defined one -- offered { longint, E } an integer takes longint (1), and even
'' { boolean, E } takes boolean (1).
function q2 overload ( byval a as longint ) as integer
	function = 1
end function
function q2 overload ( byval a as E ) as integer
	function = 2
end function
function r2 overload ( byval a as boolean ) as integer
	function = 1
end function
function r2 overload ( byval a as E ) as integer
	function = 2
end function
print q2( i ), r2( i )

'' ...but it IS viable: with only the enum candidate offered, the call is accepted.
function only_( byval a as E ) as integer
	function = 7
end function
print only_( i )

'' An ENUM argument reaching a numeric parameter behaves as an INTEGER does: offered
'' { integer, byte } it takes integer (1), and { single, integer } integer again (2).
function s2 overload ( byval a as integer ) as integer
	function = 1
end function
function s2 overload ( byval a as byte ) as integer
	function = 2
end function
function t2 overload ( byval a as single ) as integer
	function = 1
end function
function t2 overload ( byval a as integer ) as integer
	function = 2
end function
print s2( ev ), t2( ev )
