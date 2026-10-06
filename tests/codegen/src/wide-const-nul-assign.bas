'' a wide literal chain holding a NUL ends at it when assigned, as a narrow one does
print (wstr("A") + wstr(!"\0") + wstr("B")) = !"\u0041\u0000\u0042", len(wstr("A") + wstr(!"\0") + wstr("B"))
dim as wstring * 10 w = wstr("A") + wstr(!"\0") + wstr("B")
dim as wstring * 10 w2 = "A" + !"\0" + "B"
print len(w), len(w2)
dim as wstring * 10 wy = "y"
dim as wstring * 20 w3 = wstr("A") + wstr(!"\0") + wstr("B") + wy
print w3
