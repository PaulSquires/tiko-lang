	union bar
		f0 as integer
		type
    		f1 as byte
    		f2 as short
    		f3 as integer
    		f4 as double
		end type
		f5 as longint
		declare constructor
	end union

	constructor bar
		'' do nothing, field should be cleared automatically
	end constructor
sub t
	dim junk(0 to 7) as longint = { -1, -1, -1, -1, -1, -1, -1, -1 }
end sub
sub u
	dim b as bar
	print b.f0, b.f4, b.f5
end sub
t : u
