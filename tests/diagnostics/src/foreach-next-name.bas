'' NEXT naming anything when it closes a FOR EACH -- fbc's error 346 on lines 6, 8 and 11
'' (fbc-modern 1.20): the loop variable, another name, and a FOR EACH closed through a
'' name list. A bare NEXT, line 13, and a FOR's named NEXT, line 15, are accepted.
dim a(0 to 1) as long
for each v in a
next v
for each w in a
next x
for i as long = 0 to 1
    for each y in a
    next y, i
for each z in a
next
for j as long = 0 to 1
next j
