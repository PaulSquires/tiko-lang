'' A CONVERSION OF A 64-BIT INTEGER LITERAL FOLDS EXACTLY. cint, clngint, cuint and
'' culngint folded every literal argument through a double, so a value past 2^53 lost
'' its low bits: 'clngint( 9223372036854775807 )' was 2^63 and
'' 'culngint( 18446744073709551615ull )' 2^64, which wrapped to 0.
const A = clngint( 9223372036854775807 )
const B = culngint( 18446744073709551615ull )
const C = cint( 9223372036854775807ull )
const D = cuint( 9007199254740993ull )
const E = clngint( -9223372036854775807 )
const F = culngint( 9223372036854775809ull )
print A
print B
print C
print D
print E
print F
print clngint( 9007199254740993 ) - clngint( 9007199254740992 )
print cint( 2.5 ), cint( 3.5 ), clngint( -2.5 ), culngint( 7.5 )
