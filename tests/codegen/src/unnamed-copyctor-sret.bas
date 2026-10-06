dim shared as integer dc, cc, lc
type UDT
	declare constructor()
	declare constructor(byref as UDT)
	declare operator let (byref as UDT)
	x as integer
end type
constructor UDT () : dc += 1 : end constructor
constructor UDT (byref x as UDT) : cc += 1 : end constructor
operator UDT.let (byref x as UDT) : lc += 1 : end operator
function proc (byval x as UDT) as UDT
	return x
end function
sub t1
	dim x as UDT
	dim y as UDT = proc(x)
	print dc, cc, lc
	x = proc(y)
	print dc, cc, lc
end sub
sub t2
	dc = 0 : cc = 0 : lc = 0
	static x as UDT
	static y as UDT = proc(x)
	print dc, cc, lc
	x = proc(y)
	print dc, cc, lc
end sub
t1 : t2
