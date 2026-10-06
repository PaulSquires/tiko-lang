dim as wstring * 10 w1
dim as wstring * 5 w2
w1 = wstr("foobarbaz")
w2 = wstr("test")
swap w1, w2
print len(w1), len(w2), w1, w2
