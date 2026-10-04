dim as long buf(11), back(11)
for i as integer = 0 to 11 : buf(i) = i * 3 + 1 : next
open "file-getput-amount.dat" for binary as #1
put #1, , buf(0), 10
print "lof"; lof(1)
close #1
open "file-getput-amount.dat" for binary as #1
get #1, 1, back(0), 10
close #1
for i as integer = 0 to 11 : print back(i); : next : print
dim as ubyte bytes(63)
open "file-getput-amount.dat" for binary as #2
dim as uinteger nread
dim as ubyte ptr q = @bytes(0)
get #2, 33, *q, 8, nread
print "nread"; nread; bytes(0); bytes(4)
dim as integer dyn()
redim dyn(4)
get #2, 1, dyn()
print dyn(0); dyn(1); dyn(4)
dim as integer dput(2) = {7, 8, 9}
put #2, 100, dput()
dim as integer dget()
redim dget(2)
get #2, 100, dget()
print dget(0); dget(1); dget(2)
close #2
kill "file-getput-amount.dat"
