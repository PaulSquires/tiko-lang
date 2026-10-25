'' B-iterators-2: under -exx, FOR EACH over a dynamic array the body SHRINKS is checked
'' against the live bounds -- runtime error 6 on the second element, not a read of freed memory.
dim q( ) as long
redim q( 0 to 2 )
dim as long s = 0
for each v in q
    s += v
    redim preserve q( 0 to 0 )
next
