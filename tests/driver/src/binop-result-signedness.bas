'' A BINARY OPERATOR'S SIGNEDNESS IS ITS RESULT TYPE'S, built to an executable. fbc
'' promotes both operands first and the promoted type decides: 'ulong \ integer' is an
'' INTEGER and divides signed, 'integer \ uinteger' is a UINTEGER and divides unsigned.
'' tiko took the LEFT operand's signedness, and printed 0 for the first line and 200 for
'' the second. See tests/mir/src/binop-result-signedness.bas for fbc's C.
''
'' fbc prints, one per line:
''     a-10  b 2  c-3  d 0  e6148914691236517202  f2  g9223372036854775804
''     h2305843009213693951  i 5  j-4  k0  o-5  p-33  q184467440737095516  r0  s 0
''     t-10  u-10  v 2  w0  x0  y 2  z-10  A-5  B-2000000000  C 1  D6148914691236517202
''
'' Comparisons are not here: they take their signedness from the promoted operands,
'' which is a different rule. build/goldenrun.sh runs this beside fbc.
dim as ulong ul = 10
dim as ubyte ub = 200
dim as integer i = -8
dim as uinteger ui = 3
dim as ulongint uli = 100
dim as long l = -10
dim as ushort us = 30
dim as ulong u3 = 30
dim as longint li = -9

print "a"; ul \ -1
print "b"; ub mod -3
print "c"; u3 \ l
print "d"; u3 mod l
print "e"; i \ ui
print "f"; i mod ui
print "g"; i shr 1u
print "h"; i shr ui
print "i"; ul shr 1
print "j"; us \ -7
print "k"; uli \ -1
print "o"; ul \ -1 \ 2
print "p"; ub \ -3 * 2
print "q"; li \ uli
print "r"; ui \ l
print "s"; u3 shr l
print "t"; ul * -1

'' A constant or a cast operand, a bitfield, and the operator inside a longer chain.
const cu as ulong = 10
const cl as ulong = 4000000000
type T
    as ulong b : 8
end type
dim t as T
print "u"; cu \ -1
print "v"; cast( ubyte, 200 ) mod -3
t.b = 200 : t.b \= -1 : print "w"; t.b
t.b = 200 : print "x"; t.b \ -1
print "y"; ub mod -3 mod 5
print "z"; ul \ -1 + 0
print "A"; 5 + ul \ -1
print "B"; cl \ -2
print "C"; cl mod -3
print "D"; -8 \ 3u
