'' A COMPARISON OF TWO UDTS THAT CAST ONLY TO WSTRING. Check took each side's NUMERIC cast
'' and found none, so '( a = b )' had no type and 'print "eqA "; ( a = b )' was dropped
'' whole -- the prefix with it. Measured, fbc-modern compares with fb_WstrCompare, prints
'' the INTEGER result, and outputs 'eqA -1', 'eqB  0 next', 'r true' and 'done'.
type WS
    as wstring * 16 w
    declare operator cast( ) byref as wstring
end type
operator WS.cast( ) byref as wstring
    return this.w
end operator
dim as WS a, b, d
a.w = "1.00" : b.w = "1.00" : d.w = "2.00"
print "eqA "; ( a = b )
print "eqB "; ( a = d ); " next"
dim as boolean r = ( a = b )
print "r "; r
print "done"
