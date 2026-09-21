'' A NEXT that names more loops than are open is fbc's error 107, "NEXT without FOR,
'' found 'y'". 'next x, y' closes the loop of x and then looks for one around it.
dim as integer x, y
for x = 1 to 2
next x, y
