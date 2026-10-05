type M1
    as long q
    declare operator cast( ) as long
end type
operator M1.cast( ) as long : print "[l]"; : return q : end operator
dim as M1 a : a.q = 3
print tab( a ); "x"
print spc( a ); "y"
print "ab"; tab( a + 3 ); "z"
color 7, 0
width 80, 25
