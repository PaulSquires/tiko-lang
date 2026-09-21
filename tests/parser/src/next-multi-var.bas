'' 'NEXT x, y' IS 'NEXT x : NEXT y' -- it closes the inner loop and the one around it.
'' tiko took one NEXT and skipped the rest of the line, so only the inner FOR closed:
'' inside a DO the LOOP was then rejected (TKO0420), and at module level everything
'' after 'next x, y' became part of the OUTER loop's body -- the 'print' below ran
'' three times where fbc runs it once.
dim as integer x, y, z, n
do
    for z = 1 to 2
        for y = 1 to 3
            for x = 1 to 4
                n += 1
    next x, y, z
loop until n > 0
for y = 1 to 3
    for x = 1 to 2
        n += 1
next x, y
print n
