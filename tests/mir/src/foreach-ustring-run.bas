'' T15: three words over a 'string' array, read as ustring, make two distinct keys.
dim words(0 to 2) as string = { "ab", "caf" & chr( 195, 169 ), "ab" }
dim seen(0 to 9) as ustring, nseen as integer
for each w as ustring in words
	print len( w ); asc( w, len( w ) )
	dim found as boolean = false
	for i as integer = 0 to nseen - 1
		if seen(i) = w then found = true
	next
	if not found then seen(nseen) = w : nseen += 1
next
print "distinct"; nseen
