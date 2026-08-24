'' TUPLE EQUALITY IS A SHORT-CIRCUIT CHAIN over the elements, not a comparison of two
'' objects. Measured from what fbc emits:
''
''     TMP2 = &A ; TMP3 = &B                 each side's address ONCE, so a call on
''                                           either side is evaluated once and not
''                                           once per element
''     if TMP2->_1 != TMP3->_1 goto FALSE
''     TMP4 = -(TMP2->_2 == TMP3->_2)
''     goto JOIN
''     FALSE: TMP4 = 0
''     JOIN:
''
'' -- exactly the ANDALSO chain of the element comparisons, short-circuit constant 0.
'' The inequality is the ORELSE chain of the INVERTED comparisons, short-circuit
'' constant -1, which is what makes it the negation of the whole thing rather than of
'' each element. A three-element tuple folds LEFT, testing the accumulator and
'' repeating, and the result is always materialised and negated even in a condition.
''
'' A STRING ELEMENT IS A RUNTIME CALL: 'fb_StrCompare( &A + 8, -1, &B + 8, -1 )' and
'' then that result against 0. The descriptor is an aggregate, so comparing it as one
'' would compare the pointer and the length rather than the text.
''
'' A NESTED TUPLE IS FLATTENED into its own leaves, at their offsets from the outer one:
'' '((long, long), long)' is THREE element comparisons in one chain.
''
'' ...and a STRING ELEMENT IN A LITERAL is written by fb_StrInit rather than by a store,
'' so the flatten carries a leaf's FRONTEND type beside its MIR one. Refusing it declined
'' every tuple and every UDT literal holding a string.
dim as (long, long) a = (1, 2)
dim as (long, long) b = (1, 2)
dim as (long, long) c = (1, 3)

if a = b then print "eq"
if a <> c then print "ne"
dim as long r = (a = b)
dim as long q = (a <> b)
print r, q

'' Three elements, folded left.
dim as (long, long, long) p3 = (1, 2, 3)
dim as (long, long, long) q3 = (1, 2, 4)
if p3 = q3 then print "never"
if p3 <> q3 then print "ne3"

'' A string element, in the literal and in the comparison.
dim as (long, string) s1 = (1, "hello")
dim as (long, string) s2 = (1, "hello")
dim as (long, string) s3 = (1, "world")
if s1 = s2 then print "seq"
if s1 <> s3 then print "sne"

'' A nested tuple, flattened.
dim as ((long, long), long) n1 = ((1, 2), 3)
dim as ((long, long), long) n2 = ((1, 2), 3)
dim as ((long, long), long) n3 = ((1, 9), 3)
if n1 = n2 then print "neq"
if n1 <> n3 then print "nne"
