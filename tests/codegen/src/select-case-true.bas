'' 'select case true' runs the first case whose condition is true (by-example BUG-flow-1).
dim as boolean raining = false, windy = true
select case true
case raining
    print "take an umbrella"
case windy
    print "take a coat"
case else
    print "take nothing"
end select
select case true
case true
    print "lit ok"
case else
    print "lit FAIL"
end select
const KT = true
select case true
case KT
    print "const ok"
case else
    print "const FAIL"
end select
select case true
case is = windy
    print "is ok"
case else
    print "is FAIL"
end select
select case false
case raining
    print "false ok"
case else
    print "false FAIL"
end select
dim as boolean b = true
select case b
case true
    print "var ok"
case else
    print "var FAIL"
end select
