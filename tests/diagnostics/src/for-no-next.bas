'' A FOR EACH with no NEXT at end of file -- fbc's error 13, "Expected 'NEXT'", on line
'' 8 (fbc-modern 1.20). Line 5's loop is closed by its NEXT and is not reported.
dim as long a(2) = {1, 2, 3}

for i as long = 1 to 2 : print i : next
for each x as long in a
    print x
