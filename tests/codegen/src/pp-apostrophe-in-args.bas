'' a "'" inside a macro's arguments is text, not a comment -- fbc's arg reader takes it
#define S(a) #a
#define J(a, b) a b
#define CHECK_TRUE(e, failtext)  if (e) then else print "F:" & #failtext
print S(don't stop)
print J("x", S(can't))
print "[" & S(x ' y z) & "]"
print "[" & S(a'b c'd e) & "]"
dim as integer a = 10
CHECK_TRUE( a = a, should be true)
CHECK_TRUE( 0, shouldn't be 0 for a=10)
print S(one) ' a real comment
print 1 ' another
