'' A COMPARISON USED AS A VALUE IS NEGATED.
''
'' fbc writes '-((int64)A < (int64)B)' in EVERY value position it has, so the answer is
'' -1 and 0 rather than 1 and 0. Measured, one destination at a time:
''
''     r = (a < b)        R = (int32)(int64)-((int64)A < (int64)B)
''     t = (a < b)        T = (boolean)((int64)-((int64)A < (int64)B) != 0)
''     y = (a < b)        Y = (int8)(int64)-(...)
''     d = (a < b)        D = (double)(int64)-(...)
''     print a < b        fb_PrintLongint( 0, (int64)-(...), 1 )
''     print (a<b) + 1    the negation happens FIRST, then the addition
''     return a < b       the same, in both a LONG and a BOOLEAN function
''     r = (s = s2)       R = -(fb_StrCompare( ... ) == 0), strings too
''
'' tiko-lang emitted the bare comparison and every one of these was off by a sign.
''
'' A CONDITION IS NOT NEGATED, and that is not a detail: 'if a < b' is a BRANCH and
'' asks only whether the value is nonzero, so fbc emits no negation there and neither
'' does this. The exact NODE is what carries the distinction rather than a depth,
'' because a condition may CONTAIN a value-position comparison -- 'if (a < b) + 1'.
dim as long a = 1, b = 2
dim as boolean t
dim as long r
dim as byte y
dim as double d

r = (a < b)
t = (a < b)
y = (a < b)
d = (a < b)
print a < b
print (a < b) + 1
if (a < b) then print "y"
if (a < b) + 1 then print "z"

dim as string s = "x", s2 = "y"
r = (s = s2)
t = (s = s2)

dim as any ptr p
r = (p <> 0)
if p = 0 then print "null"

print r, t, y, d
