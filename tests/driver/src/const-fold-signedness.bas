'' A FOLDED CONSTANT'S WIDTH AND SIGNEDNESS, built to an executable. Every line below is
'' folded at compile time; the same expressions outside a 'const' were right all along,
'' because they are lowered at run time. See tests/mir/src/const-fold-signedness.bas for
'' the rule and the measurements.
''
'' fbc prints, one per line:
''     a9223372036854775807  b1  c6148914691236517202  d 8589934590  e 2147483647
''     f 4294967295  g 4000000000  h-4294967295  i 4294967288  j9223372036854775807
''     k 2  l-536870911  m 2  n-2000000008
''
'' build/goldenrun.sh runs this beside fbc.
const big as ulongint = 18446744073709551615ull
const uli as uinteger = 18446744073709551615
const ula as ulong = 4294967295
const la as long = 2000000000
const ln as long = -8
const one as ubyte = 1

const q1 = big \ 2
const q2 = big mod 7
const q3 = -8 \ 3u
const q4 = ula shl one
const q5 = ula shr one
const q6 = ula \ one
const q7 = la + la
const q8 = -ula
const q9 = ula and ln
const q10 = uli shr one
const q11 = ula \ la
const q12 = ula \ ln
const q13 = ln \ -3
const q14 = ln - la

print "a"; q1
print "b"; q2
print "c"; q3
print "d"; q4
print "e"; q5
print "f"; q6
print "g"; q7
print "h"; q8
print "i"; q9
print "j"; q10
print "k"; q11
print "l"; q12
print "m"; q13
print "n"; q14
