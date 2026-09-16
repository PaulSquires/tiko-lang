'' A CONSTANT FOLDS AT NO LESS THAN INTEGER WIDTH, AND DIVIDES AS ITS RESULT TYPE SAYS.
'' fbc promotes both operands before it operates -- the result is at least INTEGER wide,
'' and unsigned only when an operand OF THAT WIDTH is unsigned, which is the rule
'' IntResult_ applies in check.bas. The folder worked at the wider OPERAND's width and
'' divided signed whatever the operands were, so every one of these was wrong while the
'' same expression outside a 'const' was right, being lowered at run time.
''
'' Measured, a 400-case matrix over the ten integer types and '\ mod shr shl', plus:
''
''     const big as ulongint = 18446744073709551615ull
''     big \ 2        9223372036854775807     folded to 0
''     big mod 7      1                       folded to 18446744073709551615
''     -8 \ 3u        6148914691236517202     folded to 18446744073709551614
''     u shr one      9223372036854775807     folded to -1, an arithmetic shift
''
'' and, from the width floor alone, with 'a' a LONG and 'one' a UBYTE:
''
''     a + a          4000000000              folded to -294967296, the 32-bit wrap
''     ula shl one    8589934590              folded to -2
''     ula shr one    2147483647              folded to -1
''     ula \ one      4294967295              folded to -1
''     ula and a      4294967288              folded to -8
''     -ula           -4294967295             folded to 1
''
'' 'ulong \ integer' stays SIGNED -- a ULONG is 32 bits and the result is 64, so no
'' operand of the result's width is unsigned -- which is why q11 is 2 and not 4294967295.
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

print q1; q2; q3
print q4; q5; q6
print q7; q8; q9
print q10; q11
