' folding through CONST declarations (the ConstOf path)
const K1 = 2 ^ 63
print "K1 "; K1
const K2 = 2 ^ -1
print "K2 "; K2
const K3 = 10 ^ 2
print "K3 "; K3
const K4 = clng(&hFFFFFFFF)
print "K4 "; K4
const K5 = clng(3000000000)
print "K5 "; K5
dim as longint v3e9 = 3000000000
print "rt clng(3e9) "; clng(v3e9)
const K6 = (1ull shl 63) > 0
print "K6 "; K6
print "inline (1ull shl 63) > 0 "; (1ull shl 63) > 0
dim as ulongint u1 = 1
print "rt (u1 shl 63) > 0 "; (u1 shl 63) > 0
const K7 = (&hFFFFFFFFFFFFFFFFull and &hFFull) > 0
print "K7 "; K7
const K8 = (&hFFFFFFFFFFFFFFFFull or 0ull) \ 2
print "K8 "; K8
dim as ulongint uall = &hFFFFFFFFFFFFFFFFull, uz = 0
print "rt K8 "; (uall or uz) \ 2
const K9 = -1 < 1u
print "K9 "; K9
const K10 = cbyte(200) + 0
print "K10 "; K10
const as ubyte K11 = 300
print "K11 "; K11
const as byte K12 = 200
print "K12 "; K12
const K13 = abs(-9223372036854775807 - 1)
print "K13 "; K13
const K14 = 7 \ 2 * 2
print "K14 "; K14
const K15 = 2 ^ 3 ^ 2
print "K15 "; K15
const K16 = -2 ^ 2
print "K16 "; K16
const K17 = cint(2.5) + cint(3.5)
print "K17 "; K17
const K18 = 1e10 + 0
print "K18 "; K18
const K19 = 5 mod -3
print "K19 "; K19
const K20 = &h80000000 shr 31
print "K20 "; K20
const K21 = &hFFFFFFFFul shr 4
print "K21 "; K21
const K22 = not 0ul
print "K22 "; K22
const K23 = 1ul - 2ul
print "K23 "; K23
dim as ulong one_ul = 1, two_ul = 2
print "rt 1ul-2ul "; one_ul - two_ul
const K24 = 4000000000ul * 2ul
print "K24 "; K24
const K25 = cushort(-1) * 2
print "K25 "; K25
const K26 = sgn(-5) * 3
print "K26 "; K26
const K27 = len("ab""c")
print "K27 "; K27
const K28 = asc(!"\n")
print "K28 "; K28
print "inline asc(!""\n"") "; asc(!"\n")
const K29 = asc(!"\x41")
print "K29 "; K29
const K30 = cvi("ABCDEFGH")
print "K30 "; K30
const K31 = 1.5 + 1
print "K31 "; K31
const K32 = 7 / 2
print "K32 "; K32
const K33 = int(7 / 2)
print "K33 "; K33
const K34 = 9 \ 2.6
print "K34 "; K34
const K35 = 7 mod 2.6
print "K35 "; K35
const K36 = (3 > 2) + 0
print "K36 "; K36
const as single K37 = 1/3
print "K37 "; K37
const as integer K38 = 2.5
print "K38 "; K38
const as integer K39 = 3.5
print "K39 "; K39
const as long K40 = 4000000000
print "K40 "; K40
const as uinteger K41 = -1
print "K41 "; K41
const as boolean K42 = 5
print "K42 "; K42
const K43 = &hFFFFFFFF + 1
print "K43 "; K43
const K44 = 2 ^ 62 + 1
print "K44 "; K44
const K45 = 3 ^ 40
print "K45 "; K45
