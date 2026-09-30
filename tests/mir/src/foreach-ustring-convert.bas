'' FOR EACH CONVERTS each element to the loop variable's string kind (tiko-book T15).
dim words(0 to 2) as string = { "ab", "cd", "ab" }
for each w as ustring in words                  '' narrow -> ustring
	print w
next
dim us(0 to 1) as ustring = { "p", "q" }
for each t as string in us                      '' ustring -> narrow
	print t
next
for each s as string in words                   '' same kind: a copy
	print s
next
