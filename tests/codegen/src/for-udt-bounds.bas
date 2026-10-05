type M1
    as long q
    declare operator cast( ) as long
    declare operator cast( ) as double
end type
operator M1.cast( ) as long : print "[l]"; : return q : end operator
operator M1.cast( ) as double : print "[d]"; : return q + 0.5 : end operator
dim as M1 a : a.q = 3
for i as integer = a to a + 1 : print i; : next : print
for d as double = a to a + 1 : print d; : next : print
for i as integer = 1 to 7 step a : print i; : next : print
