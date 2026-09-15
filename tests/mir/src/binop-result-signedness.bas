'' A BINARY OPERATOR'S SIGNEDNESS IS ITS RESULT TYPE'S. FreeBASIC promotes both operands
'' before it divides, and the promoted type -- the expression's own type -- decides signed
'' or unsigned. tiko took the LEFT operand's, so a ULONG divided by a negative INTEGER was
'' an unsigned division by 2^64-1:
''
''     dim as ulong ul = 10 : print ul \ -1      fbc -10, tiko 0
''
'' Measured, fbc's C and '#print typeof':
''
''     (int64)UL$0 / -1ll              ul \ -1       INTEGER
''     (int64)UB$0 % -3ll              ub mod -3     INTEGER
''     (int64)U3$0 / (int64)L$0        u3 \ l        INTEGER     ulong \ long
''     (uint64)I$0 / UI$0              i \ ui        UINTEGER    the other direction
''     (uint64)I$0 >> (UI$0 & 63ll)    i shr ui      UINTEGER    a logical shift
''     (uint64)LI$0 / ULI$0            li \ uli      UINTEGER
''     (int64)UL$0 >> (1ll & 63ll)     ul shr 1      INTEGER
''
'' A comparison is not covered: its result is an INTEGER whatever it compared, and fbc
'' takes its signedness from the promoted OPERANDS -- '(uint64)I$0 < UI$0' -- which is a
'' different rule.
dim as ulong ul, u3
dim as ubyte ub
dim as long l
dim as integer i, r
dim as uinteger ui
dim as longint li
dim as ulongint uli

r = ul \ -1
r = ub mod -3
r = u3 \ l
ui = i \ ui
ui = i shr ui
uli = li \ uli
r = ul shr 1
