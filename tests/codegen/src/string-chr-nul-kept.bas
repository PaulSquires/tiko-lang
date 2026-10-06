'' a NUL from chr( 0 ) is part of a counted string; only an escaped literal's NUL ends a folded chain
dim as string s = "a" & chr(0) & "b"
print len(s), instrrev("d"+chr(0)+"x", any "x"+chr(0))
dim as string t = "a" & !"\0" & "b"
print len(t)
