'' or vs xor: (12 or 10) xor 6 = 14 xor 6 = 8 ; 12 or (10 xor 6) = 12 or 12 = 12
print "or_xor   "; 12 or 10 xor 6
'' xor vs eqv: (12 xor 10) eqv 6 = 6 eqv 6 = -1 ; 12 xor (10 eqv 6) = 12 xor -13 = -1 ... use others
print "xor_eqv  "; 12 xor 10 eqv 6
'' eqv vs imp
print "eqv_imp  "; 12 eqv 10 imp 6
'' and vs or
print "and_or   "; 1 or 2 and 0
'' andalso vs orelse
print "aa_oo    "; 0 andalso 1 orelse 1
print "oo_aa    "; 1 orelse 0 andalso 0
'' shl vs & (concat) -- both operands strings would fail; use numeric then concat
print "amp_shl  "; "" & 1 shl 2
