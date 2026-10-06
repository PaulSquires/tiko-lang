const S = wstr(!"A\000B")
print asc(S, 0), asc(S, 1), asc(S, 2), asc(S, 3), asc(S, 4)
const S2 = wstr(!"\u1111\u0000\u2222")
print asc(S2, 1), asc(S2, 2), asc(S2, 3), asc(S2)
dim w as wstring * 5 = "xy"
print asc(w, 2)
