'' relational vs AND:  tighter-relational => -1 and 4 = 4 ; tighter-and => 2=(2 and 4) => 0
print "rel_vs_and   "; 2 = 2 and 4
'' relationals among themselves: same level, left assoc => (1<2)=-1 => -1
print "rel_chain    "; 1 < 2 = -1
'' NOT vs relational: not(1=0) => -1 ; (not 1)=0 => -2=0 => 0
print "not_vs_rel   "; not 1 = 0
'' NOT vs AND
print "not_vs_and   "; not 0 and 3
'' concat vs +   "a" & 1 + 2  => "a3" if + tighter
print "concat_plus  "; "a" & 1 + 2
'' concat vs relational:  "a" & "b" = "ab"  => -1 if & tighter
print "concat_rel   "; "a" & "b" = "ab"
'' unary minus vs *
print "neg_vs_mul   "; -2 * 3
'' shl vs +      1 shl 2 + 1  => 8 if + tighter, 5 if shl tighter
print "shl_vs_plus  "; 1 shl 2 + 1
'' mod vs *      2 * 3 mod 4  => 6 mod 4 = 2 if * tighter ; 2*(3 mod 4)=6 if mod tighter
print "mod_vs_mul   "; 2 * 3 mod 4
'' \ vs *
print "idiv_vs_mul  "; 8 \ 4 * 2
