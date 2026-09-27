'' wstr( ) of an ENUM, on its own and inside the shapes that take a wide operand. See
'' tests/driver/wstr-enum.test.
''
'' fbc-modern 1.20 compiles this clean and prints the first four lines as UTF-16 when
'' redirected (plain on a console), then:
''
''      2 s1
''      2 s2
''      2q s3
''      2 wz s4
''      1|4000000000|-5|1 s5
''      a2b s6
''      4 ln

enum V2
    c = 1
    d
end enum

enum Big
    bx = 4000000000
end enum

enum Neg
    nx = -5
end enum

namespace N
    enum Verb
        a
        b
    end enum
end namespace

dim as V2 ev = V2.d
dim as const V2 cv = V2.c
dim as Big bv = Big.bx
dim as Neg nv = Neg.nx

'' printed wide: a variable, a member, a concatenation, and a fixed wstring
print wstr( ev )
print wstr( V2.d )
print wstr( ev ) & " wz"
dim as wstring * 20 w = wstr( ev ) & "q" : print w

'' the same values narrowed, so the run can be checked line by line
dim as string s1 = wstr( ev ) : print s1 & " s1"
dim as string s2 = wstr( V2.d ) : print s2 & " s2"
print str( w ) & " s3"
print str( wstr( ev ) & " wz" ) & " s4"
'' a const, one wider than 32 bits, a negative one, and a namespace-qualified member
dim as string s5 = wstr( cv ) & "|" & wstr( bv ) & "|" & wstr( nv ) & "|" & wstr( N.Verb.b )
print s5 & " s5"
dim as string s6 = "a" & wstr( ev ) & "b" : print s6 & " s6"
print len( wstr( ev ) & "xyz" ) & " ln"
