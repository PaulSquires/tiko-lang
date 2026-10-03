'' Read a price list from DATA until a sentinel, and total it.
dim as string item
dim as double price, total
dim as long count

do
    read item
    if item = "END" then exit do
    read price
    print left( item & space( 12 ), 12 ); using "###.##"; price
    total += price
    count += 1
loop
print count; " items, total "; using "###.##"; total

data "apples", 3.25, "bread", 2.80, "cheese", 6.95, "coffee", 11.50
data "END"
