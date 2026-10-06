type UDT
	as integer a
	union
		as integer i
		as double d
	end union
	as integer c
end type
dim as UDT x = ( 1, 2, 3 )
print x.a; x.i; x.c

type U2
	union
		a as integer
		b as integer
	end union
end type
dim as U2 y = ( 5 )
print y.a; y.b

type U3
	union
		a as integer
		type
			b as integer
			c as integer
		end type
	end union
	d as integer
end type
dim as U3 z = ( 1, 2 )
print z.a; z.b; z.c; z.d

union U4
	a as integer
	type
		b as integer
		c as integer
	end type
end union
union UN
	a as integer
	b as integer
end union
type HasUN
	u as UN
	k as integer
end type
sub s()
	dim as integer junk(0 to 7) = { -1, -1, -1, -1, -1, -1, -1, -1 }
end sub
sub t()
	dim as U4 w = ( 1 )
	print w.a; w.b; w.c
	dim as HasUN h = ( 1, 2 )
	print h.u.a; h.u.b; h.k
end sub
s : t

dim shared as UDT sx = ( 7, 8, 9 )
print sx.a; sx.i; sx.c
