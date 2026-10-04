scope
dim as integer darr(0 to 3) = { 2, 3, 4, 5 }
dim as integer ptr dpp = @darr(0)
dim as double dy = 7
dy = *dpp ^ 2
print "y="; dy
dim as double dz = *dpp ^ 3
print "z="; dz
dim as long ptr dlp = cast( long ptr, @darr(1) )
print "w="; *dlp ^ 2 + 1
print "end"
end scope
dim as long xa = 0, xb = -1, xc = -1
print "imp-xor"; xa imp xb xor xc
'' precedence differential probe
dim as long a = 0, b = -1, c = -1
print "imp-xor"; (a imp b xor c)
print "imp-xor L"; ((a imp b) xor c)
print "imp-xor R"; (a imp (b xor c))
dim as long d = 5, e = 3, f = 6
print "xor-imp"; (d xor e imp f)
print "eqv-xor"; (d eqv e xor f)
print "imp-eqv"; (d imp e eqv f)
print "eqv-imp"; (d eqv e imp f)
print "imp-or"; (d imp e or f)
dim as integer arr(0 to 3) = { 2, 3, 4, 5 }
dim as integer ptr pp = @arr(0)
print "deref-pow"; *pp ^ 2
print "deref-pow2"; (*pp) ^ 2
print "neg-pow"; -2 ^ 2
print "pow-neg"; 2 ^ -2
print "pow-chain"; 2 ^ 3 ^ 2
print "neg-pow-chain"; -2 ^ 2 ^ 3
print "pow-not"; 2 ^ not 1 = 1
print "not-rel"; not 1 = 0
print "not-and"; not 0 and 3
print "shl-plus"; 1 shl 2 + 1
print "plus-shl"; 1 + 2 shl 1
print "mod-idiv"; 7 mod 4 \ 2
print "idiv-mul"; 8 \ 4 * 2
print "cat-plus"; "a" & 1 + 2
print "cat-eq"; "a" & "b" = "ab"
print "ao"; 0 andalso 1 orelse 1
print "oa"; 1 orelse 0 andalso 0
print "minus-mod"; -7 mod 3
print "plus-not"; 1 + not 0 * 2
print "rel-chain"; 1 < 2 = -1
print "iif"; iif( 1 > 0, 10, 20 ) + 1
print "neg-neg"; - - 3
print "neg-deref"; -*pp ^ 2
print "and-or"; 1 or 2 and 0
print "shr-neg"; -16 shr 2
print "pow-pp"; 2 ^ *pp
print "mul-neg-pow"; 3 * -2 ^ 2
print "idx-pow"; pp[1] ^ 2
print "at-plus"; (@arr(1) - @arr(0))
