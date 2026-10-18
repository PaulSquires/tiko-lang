'' Older code that tiko still compiles: a .bas file, the legacy
'' string type, long and integer, while ... wend, + to join strings.
dim as string names(1 to 3)
names(1) = "ada" : names(2) = "grace" : names(3) = "alan"

dim as long i = 1
dim as integer total = 0
while i <= 3
    print ucase(left(names(i), 1)) + mid(names(i), 2)
    total = total + len(names(i))
    i = i + 1
wend
print "letters:"; total
