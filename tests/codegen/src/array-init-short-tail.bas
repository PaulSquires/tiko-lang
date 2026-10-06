'' a short brace list zeroes the rest of the array
sub t()
	dim as integer junk(0 to 9)
	for i as integer = 0 to 9 : junk(i) = 77 : next
end sub
sub u()
	dim as integer array(0 to 9) = { 0, 1, 2, 3, 4 }
	for i as integer = 0 to 9 : print array(i); : next : print
end sub
t() : u()
