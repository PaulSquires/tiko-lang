' #if expression precedence / arithmetic vs fbc
#if not 1 = 2
print "A1 not-binds-loose"
#else
print "A1 not-binds-tight"
#endif
#if 1 shl 2 + 1 = 5
print "A2 shl-higher-than-plus"
#else
print "A2 shl-lower"
#endif
#if 7 \ 2 * 2 = 1
print "A3 intdiv-lower-than-mul"
#else
print "A3 intdiv-same-as-mul"
#endif
#if 10 mod 4 * 2 = 2
print "A4 mod-lower-than-mul"
#else
print "A4 mod-same"
#endif
#if 1 xor 2 or 3 = 2
print "A5 or-higher-than-xor"
#else
print "A5 xor-or-same-level"
#endif
#if 7 / 2 = 3
print "A6 slash-is-intdiv"
#else
print "A6 slash-is-float"
#endif
#if 0.4
print "A7 0.4 true"
#else
print "A7 0.4 false"
#endif
#if &hFFFFFFFFFFFFFFFF > 0
print "A8 hex64 unsigned"
#else
print "A8 hex64 signed"
#endif
#if 18446744073709551615 > 0
print "A9 dec64 unsigned"
#else
print "A9 dec64 signed"
#endif
#if 9223372036854775807 + 1 < 0
print "A10 wraps"
#else
print "A10 no-wrap"
#endif
#if 1 = 1 and 2
print "A11 and-lower-than-eq"
#else
print "A11 other"
#endif
#if -1 shr 1 > 0
print "A12 shr logical"
#else
print "A12 shr arith"
#endif
