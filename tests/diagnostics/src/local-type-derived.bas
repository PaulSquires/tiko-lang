'' Inside a procedure, a type may extend one that brings no constructor or destructor.
type Plain
	a as integer
end type
type WithMethod
	a as integer
	declare sub m()
end type
sub WithMethod.m()
end sub
type WithString
	a as string
end type
sub s()
	type L1 extends Plain                       '' fine
		c as integer
	end type
	type L2 extends WithMethod                  '' fine: its methods stay its own
		c as integer
	end type
	type L3 extends WithString                  '' refused: an implicit destructor
		c as integer
	end type
end sub
