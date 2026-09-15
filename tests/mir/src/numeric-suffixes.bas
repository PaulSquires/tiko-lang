'' A NUMERIC LITERAL'S SUFFIX TYPES IT, on every form fbc accepts. Measured with
'' '#print typeof':
''
''     3d        DOUBLE      QB's exponent marker with no digits
''     3.f       SINGLE      a point with nothing after it, then a suffix
''     3d+1      DOUBLE      30 -- the sign and digits are the exponent
''     &h3d!     SINGLE      61: 'd' is a hex digit, '!' the suffix
''     &o7d      DOUBLE      7: on octal and binary 'd' IS a suffix
''     &b1f      SINGLE
''     3ul       ULONG
''
'' tiko refused the first three and printed the three radix ones as INTEGERs.
print 3d
print 3.f
print 3d+1
print &h3d!
print &o7d
print &b1f
print 3ul
