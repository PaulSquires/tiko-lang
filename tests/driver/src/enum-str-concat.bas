'' str( ) and its numeric-argument siblings over an ENUM, as the LEFT term of a string
'' concatenation. See tests/driver/enum-str-concat.test.
''
'' fbc-modern 1.20 compiles this clean and prints:
''
''      2 z
''      2 w
''      1 y
''      2 ev
''      1 cv
''      2 hx
''      2 oc
''      10 bn
''      2 sp
''      1 sg
''      0.9092974268256817 sn
''      1.414213562373095 sq
''      0.7853981633974483 at
''      4 mk
''      65 ch
''      -1 bt
''      6 bs
''      2!

enum V2
    c = 1
    d
end enum

namespace N
    enum Verb
        a
        b
    end enum
end namespace

dim as V2 ev = V2.d
dim as const V2 cv = V2.c

'' a member, '&' and '+', and a namespace-qualified one
print str( V2.d ) & " z"
print str( V2.d ) + " w"
print str( N.Verb.b ) & " y"
'' a variable, and a const one
print str( ev ) & " ev"
print str( cv ) & " cv"
'' the rest of the numeric-argument rows
print hex( ev ) & " hx"
print oct( V2.d ) & " oc"
print bin( ev ) & " bn"
print len( space( ev ) ) & " sp"
print sgn( ev ) & " sg"
print sin( ev ) & " sn"
print sqr( ev ) & " sq"
print atan2( ev, ev ) & " at"
print len( mkl( ev ) ) & " mk"
print asc( chr( ev + 63 ) ) & " ch"
print bit( ev, 1 ) & " bt"
print bitset( ev, 2 ) & " bs"
'' typed by its destination, which always lowered
dim as string s = str( ev ) & "!"
print s
