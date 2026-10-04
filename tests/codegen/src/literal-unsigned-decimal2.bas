dim as integer c0 = 0, c1 = 1
print "iif(c0, 2, 3.5) = "; iif(c0, 2, 3.5)
print "iif(c1, 2.5, 3) = "; iif(c1, 2.5, 3)
print "iif(c0, 1ul, -1) = "; iif(c0, 1ul, -1)
dim as double dv = iif(c0, 2, 3.7)
print "dv = "; dv
print "18446744073709551615 = "; 18446744073709551615
dim as double dbig = 18446744073709551615
print "as double "; dbig
dim as ulongint ub = 18446744073709551615
print "as ulongint "; ub
print "9223372036854775808 \ 2 = "; 9223372036854775808 \ 2
print "10000000000000000000 / 3 = "; 10000000000000000000 / 3
print "3000000000 > -1 : "; (3000000000 > -1)
dim as integer m1 = -1
print "m1 < 3000000000 : "; (m1 < 3000000000)
print "m1 < 2147483648 : "; (m1 < 2147483648)
print "sgn(-2.5) \ 2 "; sgn(-2.5) \ 2
print "len(str(sgn(-2.5))) "; len(str(sgn(-2.5)))
print "cdbl(18446744073709551615) "; cdbl(18446744073709551615)
const BIGC = 18446744073709551615
print "const BIGC "; BIGC
print "BIGC > 0 "; (BIGC > 0)
