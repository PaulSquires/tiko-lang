'' a constant string keeps its NULs until it lands: len folds the whole text, a target stops at the NUL
const c = "A" + !"\0" + "B"
const d = !"x\0y"
print len(c), sizeof(c), len(d), sizeof(d), sizeof(!"p\0q")
dim as string s1 = c, s2 = d
print len(s1), len(s2)
print len(c & "Z"), len(chr(0)), len("Q" + chr(0) + "R")
dim as zstring * 8 z = "A" + !"\0" + "B"
print len(z)
print len("A" & !"\0" & "B"), len(!"\x41\x00\x42"), len(!"\0")
print ("A" + !"\0" + "B") = !"\x41\x00\x42"
dim as string y = "y"
dim as string r1 = "A" + !"\0" + "B" + y, r2 = y + "A" + !"\0" + "B", r3 = "A" + !"x\0y" + "B" + y
print r1, r2, r3
print (wstr("A") + wstr(!"\0") + wstr("B")) = !"\u0041\u0000\u0042", len(wstr("A") + wstr(!"\0") + wstr("B"))
