'' SWAP of ustrings: fbc-modern calls fb_UStrSwap( p, size, p, size ), size -1 or a ustring*N's tagged N-1.
dim as ustring a = "alpha", b = "beta"
swap a, b
print a; " "; b
dim as ustring * 8 fa = "fixA", fb = "fixedB"
swap fa, fb
print "["; fa; "] ["; fb; "]"
dim as ustring * 4 sh = "abcd"
dim as ustring * 8 lg = "12345678"
swap sh, lg
print "["; sh; "] ["; lg; "]"
dim as ustring u = "uu"
dim as ustring * 6 f6 = "f6f6f6"
swap u, f6
print "["; u; "] ["; f6; "]"
