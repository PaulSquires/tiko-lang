'' A quiz whose questions live in DATA statements.
dim as string question, answer
dim as long count

'' The first DATA item says how many questions follow.
read count
for i as long = 1 to count
    read question, answer
    print "Q"; i; ": "; question; " -- "; answer
next

'' RESTORE with a label reads again from that label's DATA.
restore bonus
read question, answer
print "Bonus: "; question; " -- "; answer

data 3
data "Capital of France?", "Paris"
data "Largest planet?", "Jupiter"
data "Square root of 81?", "9"

bonus:
data "Year the first BASIC ran?", "1964"
