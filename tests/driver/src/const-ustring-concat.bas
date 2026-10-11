'' See tests/driver/const-ustring-concat.test.
const G as ustring = "hi"
const G2 as string = "s"
dim as long n = 3
dim as string s = "S"
dim as ustring u = "U"
print n & G
print G & n
print 3 & " " & G
print s & G; "|"; G & s
print u & G; "|"; "x" & G
print n & G2
dim as ustring a = n & G
dim as string b = n & G
print a; "|"; b; "|"; len( a ); len( b )
print str( n ) & G
