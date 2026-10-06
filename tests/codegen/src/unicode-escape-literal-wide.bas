const LIT_W2 = !"bcd\u0065\u0066\u0067"
const LIT_W3 = !"\u0063\u0064\u0065\u0065\u0067\u0068"
dim s as wstring * 32
print len( !"bcd\u0065\u0066\u0067" ), len(LIT_W2), len(LIT_W3)
s = LIT_W2 : print len(s), s
s = LIT_W3 : print len(s), s
s = !"bcd\u0065\u0066\u0067" : print len(s), s
