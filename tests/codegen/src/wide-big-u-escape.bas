dim as wstring * 10 s = !"\U0001F0A1"
print hex(s[0]), hex(s[1]), len(s)
dim as wstring * 10 t = !"a\u0041b"
print t, len(t)
