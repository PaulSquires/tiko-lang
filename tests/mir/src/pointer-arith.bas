'' POINTER ARITHMETIC AND COMPARISON, both of which had no type at all.
''
'' A pointer is not a builtin, so every one of these fell out at BinaryResult's
'' builtin-only guard -- and an untyped expression cannot be printed, assigned, passed
'' or measured with sizeof. Measured:
''
''     p + n    LONG PTR      the pointer, scaled by the pointee
''     n + p    LONG PTR
''     p - n    LONG PTR
''     p - p    INTEGER       the DIFFERENCE is a count, not an address
''     q - q    INTEGER       an ANY PTR too
''     p * n    error 20      every other operator rejects
''     p <> 0   INTEGER       and every comparison
dim as long a(0 to 3) = { 1, 2, 3, 4 }
dim as long ptr p = @a(0)
dim as long ptr q = @a(2)
dim as any ptr r = @a(0)
dim as any ptr s = @a(3)
dim as long n = 1

print q - p
print s - r
print sizeof( q - p )
print *(p + n)
print *(n + p)
print *(q - n)

dim as long ptr t = p + 2
print *t

dim as long d = q - p
print d

if p <> 0 then print "notnull"
if p < q then print "before"
print p = 0
