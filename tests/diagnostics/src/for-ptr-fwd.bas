'' A FOR over a pointer to a forward type -- fbc's error 71 at the NEXT.
type foo as bar
for i as foo ptr = 0 to 3
next                                                '' 71
for j as integer ptr = 0 to 3
next                                                '' fine
