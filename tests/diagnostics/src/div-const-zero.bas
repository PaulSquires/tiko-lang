'' INTEGER DIVISION BY A CONSTANT ZERO is refused at constant-evaluation time -- fbc error
'' 100. FLOAT division is not this, and a variable divisor is not constant.
dim as integer z = 0
const K = 0

print 1 / 0
print 1 \ z
print 1 mod z

print 1 \ 0
print 1 mod 0
print 1 \ K
