'' A CONDITION THAT IS NOT A NUMBER OR A POINTER. Measured on fbc-modern: over a string (lines
'' 9-14) and a UDT with no cast (15) these are errors 24, 20 and 99; a double, a pointer and a
'' comparison (16-18) are fine.
type P
    as long x
end type
dim as string q = "a" : dim as zstring * 4 z = "z" : dim as P v
dim as double d : dim as any ptr ap
if q then print 1
if z then print 2
while q : wend
do : loop until q
print iif( q, 1, 2 )
if q andalso d then print 3
if v then print 4
if d then print 5
if ap then print 6
if q = "" then print 7
