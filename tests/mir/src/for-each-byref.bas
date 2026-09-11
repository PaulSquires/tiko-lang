'' 'FOR EACH BYREF v' BINDS THE ELEMENT, not a copy of it.
''
'' The parser records the keyword in the statement's own 'op' and NOTHING READ IT, so
'' the loop variable was an ordinary local: 'v *= 10' multiplied a copy and threw it
'' away. Measured -- fbc leaves the array 10, 50 and tiko-lang left it 1, 5.
''
'' A REFERENCE TYPE is how every other alias in this compiler is spelled -- a byref
'' parameter, 'dim byref r = x' -- so binding it that way needs nothing new anywhere
'' else: the rest already reads and writes through one.
''
'' THREE SHAPES, and each one was a separate fix:
''
''   with an 'as' clause      the wrap goes where the written type is resolved
''   without one              the inferred branch needs it too, and is elsewhere
''   over a COLLECTION        the iterator path binds what Value( ) handed back
''
'' The third is why this matters beyond arrays: fb/array.bi and its siblings all
'' declare 'function Value( ) byref as T' exactly so a caller can write through it.
dim a( 0 to 4 ) as long
for i as long = 0 to 4
	a(i) = i + 1
next

for each byref v as long in a
	v *= 10
next
print a(0); a(4)

redim d(2 to 4) as long
d(2) = 10 : d(3) = 20 : d(4) = 30
for each byref w in d
	w += 1
next
print d(2); d(4)

'' ...and the DEFAULT is still a copy, which is the half that already worked.
'' 'for each byval' is fbc error 14 -- the keyword is not accepted there -- so the
'' plain form is the only way to write it.
for each u as long in a
	u = 0
next
print a(0); a(4)
