'' A quiz whose questions live in DATA statements.
dim as string question, answer
dim as long count

'' The first DATA item is how many questions follow.
read count
for i as long = 1 to count
    read question, answer
    print "Q"; i; ": "; question; " -- "; answer
next

'' RESTORE to a label starts reading from that label's DATA.
restore bonus
read question, answer
print "Bonus: "; question; " -- "; answer

'' RESTORE with no label goes back to the first DATA in the file.
restore
read count
print "questions in the main set:"; count

data 3
data "Capital of France?", "Paris"
data "Largest planet?", "Jupiter"
data "Square root of 81?", "9"

bonus:
data "Year the first BASIC ran?", "1964"
