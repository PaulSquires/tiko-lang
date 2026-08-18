dim as long f, n
dim as string s
print #1, using "##.##"; 3.14159;
print "a"; "b", "c"
open "x.txt" for input access read as #1 len = 128
line input #1, s
input "name"; s
'' A LEADING ';' suppresses the newline the runtime echoes after return. It comes before
'' the prompt, so it cannot be folded into the prompt handling, and without it the ';' is
'' read as the start of an expression and the statement does not parse at all.
input ; s
input ; "name"; s
line input ; s
get #1, , n
put (10, 20)-(30, 40), s
close #1, #2
seek #1, 100
data 1, "two", three
on error goto handler
on n goto a, b, c
swap f, n
name "old" as "new"
defint a-z
color 15, 0
pset (1, 2), 4
write #1, s
erase s
