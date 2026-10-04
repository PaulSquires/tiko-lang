print !"C:\\Users\\x"
print len(!"C:\\Users\\x")
dim as string p = !"C:\\Users"
print p, len(p)
dim as wstring * 10 w = !"\u0041\u0042"
print len(w), w[0], w[1]
dim as string q = !"\u0041"
print len(q), q
print len(!"x\\uy")
