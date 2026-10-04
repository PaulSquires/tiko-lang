const K1 = cast(byte,37) + cast(byte,-51)
dim shared as byte G1 = cast(byte,37) + cast(byte,-51)
sub S1()
    static as byte st = cast(byte,37) + cast(byte,-51)
    dim as byte va = 37, vb = -51
    print "1 byte +: "; K1; G1; st; cast(byte, va + vb)
end sub
const K2 = cast(byte,74) + cast(byte,-104)
dim shared as byte G2 = cast(byte,74) + cast(byte,-104)
sub S2()
    static as byte st = cast(byte,74) + cast(byte,-104)
    dim as byte va = 74, vb = -104
    print "2 byte +: "; K2; G2; st; cast(byte, va + vb)
end sub
const K3 = cast(byte,-91) - cast(byte,-80)
dim shared as byte G3 = cast(byte,-91) - cast(byte,-80)
sub S3()
    static as byte st = cast(byte,-91) - cast(byte,-80)
    dim as byte va = -91, vb = -80
    print "3 byte -: "; K3; G3; st; cast(byte, va - vb)
end sub
const K4 = cast(byte,59) - cast(byte,-99)
dim shared as byte G4 = cast(byte,59) - cast(byte,-99)
sub S4()
    static as byte st = cast(byte,59) - cast(byte,-99)
    dim as byte va = 59, vb = -99
    print "4 byte -: "; K4; G4; st; cast(byte, va - vb)
end sub
const K5 = cast(byte,-19) * cast(byte,-109)
dim shared as byte G5 = cast(byte,-19) * cast(byte,-109)
sub S5()
    static as byte st = cast(byte,-19) * cast(byte,-109)
    dim as byte va = -19, vb = -109
    print "5 byte *: "; K5; G5; st; cast(byte, va * vb)
end sub
const K6 = cast(byte,-84) * cast(byte,94)
dim shared as byte G6 = cast(byte,-84) * cast(byte,94)
sub S6()
    static as byte st = cast(byte,-84) * cast(byte,94)
    dim as byte va = -84, vb = 94
    print "6 byte *: "; K6; G6; st; cast(byte, va * vb)
end sub
const K7 = cast(byte,86) \ cast(byte,7)
dim shared as byte G7 = cast(byte,86) \ cast(byte,7)
sub S7()
    static as byte st = cast(byte,86) \ cast(byte,7)
    dim as byte va = 86, vb = 7
    print "7 byte \: "; K7; G7; st; cast(byte, va \ vb)
end sub
const K8 = cast(byte,-82) \ cast(byte,3)
dim shared as byte G8 = cast(byte,-82) \ cast(byte,3)
sub S8()
    static as byte st = cast(byte,-82) \ cast(byte,3)
    dim as byte va = -82, vb = 3
    print "8 byte \: "; K8; G8; st; cast(byte, va \ vb)
end sub
const K9 = cast(byte,-65) mod cast(byte,3)
dim shared as byte G9 = cast(byte,-65) mod cast(byte,3)
sub S9()
    static as byte st = cast(byte,-65) mod cast(byte,3)
    dim as byte va = -65, vb = 3
    print "9 byte mod: "; K9; G9; st; cast(byte, va mod vb)
end sub
const K10 = cast(byte,75) mod cast(byte,7)
dim shared as byte G10 = cast(byte,75) mod cast(byte,7)
sub S10()
    static as byte st = cast(byte,75) mod cast(byte,7)
    dim as byte va = 75, vb = 7
    print "10 byte mod: "; K10; G10; st; cast(byte, va mod vb)
end sub
const K11 = cast(byte,-105) and cast(byte,-60)
dim shared as byte G11 = cast(byte,-105) and cast(byte,-60)
sub S11()
    static as byte st = cast(byte,-105) and cast(byte,-60)
    dim as byte va = -105, vb = -60
    print "11 byte and: "; K11; G11; st; cast(byte, va and vb)
end sub
const K12 = cast(byte,20) and cast(byte,86)
dim shared as byte G12 = cast(byte,20) and cast(byte,86)
sub S12()
    static as byte st = cast(byte,20) and cast(byte,86)
    dim as byte va = 20, vb = 86
    print "12 byte and: "; K12; G12; st; cast(byte, va and vb)
end sub
const K13 = cast(byte,-55) or cast(byte,-68)
dim shared as byte G13 = cast(byte,-55) or cast(byte,-68)
sub S13()
    static as byte st = cast(byte,-55) or cast(byte,-68)
    dim as byte va = -55, vb = -68
    print "13 byte or: "; K13; G13; st; cast(byte, va or vb)
end sub
const K14 = cast(byte,29) or cast(byte,-36)
dim shared as byte G14 = cast(byte,29) or cast(byte,-36)
sub S14()
    static as byte st = cast(byte,29) or cast(byte,-36)
    dim as byte va = 29, vb = -36
    print "14 byte or: "; K14; G14; st; cast(byte, va or vb)
end sub
const K15 = cast(byte,-76) xor cast(byte,-32)
dim shared as byte G15 = cast(byte,-76) xor cast(byte,-32)
sub S15()
    static as byte st = cast(byte,-76) xor cast(byte,-32)
    dim as byte va = -76, vb = -32
    print "15 byte xor: "; K15; G15; st; cast(byte, va xor vb)
end sub
const K16 = cast(byte,62) xor cast(byte,-79)
dim shared as byte G16 = cast(byte,62) xor cast(byte,-79)
sub S16()
    static as byte st = cast(byte,62) xor cast(byte,-79)
    dim as byte va = 62, vb = -79
    print "16 byte xor: "; K16; G16; st; cast(byte, va xor vb)
end sub
const K17 = cast(byte,-96) shl cast(byte,3)
dim shared as byte G17 = cast(byte,-96) shl cast(byte,3)
sub S17()
    static as byte st = cast(byte,-96) shl cast(byte,3)
    dim as byte va = -96, vb = 3
    print "17 byte shl: "; K17; G17; st; cast(byte, va shl vb)
end sub
const K18 = cast(byte,126) shl cast(byte,5)
dim shared as byte G18 = cast(byte,126) shl cast(byte,5)
sub S18()
    static as byte st = cast(byte,126) shl cast(byte,5)
    dim as byte va = 126, vb = 5
    print "18 byte shl: "; K18; G18; st; cast(byte, va shl vb)
end sub
const K19 = cast(byte,110) shr cast(byte,5)
dim shared as byte G19 = cast(byte,110) shr cast(byte,5)
sub S19()
    static as byte st = cast(byte,110) shr cast(byte,5)
    dim as byte va = 110, vb = 5
    print "19 byte shr: "; K19; G19; st; cast(byte, va shr vb)
end sub
const K20 = cast(byte,25) shr cast(byte,2)
dim shared as byte G20 = cast(byte,25) shr cast(byte,2)
sub S20()
    static as byte st = cast(byte,25) shr cast(byte,2)
    dim as byte va = 25, vb = 2
    print "20 byte shr: "; K20; G20; st; cast(byte, va shr vb)
end sub
const K21 = cast(ubyte,124) + cast(ubyte,41)
dim shared as ubyte G21 = cast(ubyte,124) + cast(ubyte,41)
sub S21()
    static as ubyte st = cast(ubyte,124) + cast(ubyte,41)
    dim as ubyte va = 124, vb = 41
    print "21 ubyte +: "; K21; G21; st; cast(ubyte, va + vb)
end sub
const K22 = cast(ubyte,153) + cast(ubyte,253)
dim shared as ubyte G22 = cast(ubyte,153) + cast(ubyte,253)
sub S22()
    static as ubyte st = cast(ubyte,153) + cast(ubyte,253)
    dim as ubyte va = 153, vb = 253
    print "22 ubyte +: "; K22; G22; st; cast(ubyte, va + vb)
end sub
const K23 = cast(ubyte,175) - cast(ubyte,229)
dim shared as ubyte G23 = cast(ubyte,175) - cast(ubyte,229)
sub S23()
    static as ubyte st = cast(ubyte,175) - cast(ubyte,229)
    dim as ubyte va = 175, vb = 229
    print "23 ubyte -: "; K23; G23; st; cast(ubyte, va - vb)
end sub
const K24 = cast(ubyte,147) - cast(ubyte,37)
dim shared as ubyte G24 = cast(ubyte,147) - cast(ubyte,37)
sub S24()
    static as ubyte st = cast(ubyte,147) - cast(ubyte,37)
    dim as ubyte va = 147, vb = 37
    print "24 ubyte -: "; K24; G24; st; cast(ubyte, va - vb)
end sub
const K25 = cast(ubyte,60) * cast(ubyte,214)
dim shared as ubyte G25 = cast(ubyte,60) * cast(ubyte,214)
sub S25()
    static as ubyte st = cast(ubyte,60) * cast(ubyte,214)
    dim as ubyte va = 60, vb = 214
    print "25 ubyte *: "; K25; G25; st; cast(ubyte, va * vb)
end sub
const K26 = cast(ubyte,84) * cast(ubyte,175)
dim shared as ubyte G26 = cast(ubyte,84) * cast(ubyte,175)
sub S26()
    static as ubyte st = cast(ubyte,84) * cast(ubyte,175)
    dim as ubyte va = 84, vb = 175
    print "26 ubyte *: "; K26; G26; st; cast(ubyte, va * vb)
end sub
const K27 = cast(ubyte,77) \ cast(ubyte,7)
dim shared as ubyte G27 = cast(ubyte,77) \ cast(ubyte,7)
sub S27()
    static as ubyte st = cast(ubyte,77) \ cast(ubyte,7)
    dim as ubyte va = 77, vb = 7
    print "27 ubyte \: "; K27; G27; st; cast(ubyte, va \ vb)
end sub
const K28 = cast(ubyte,20) \ cast(ubyte,7)
dim shared as ubyte G28 = cast(ubyte,20) \ cast(ubyte,7)
sub S28()
    static as ubyte st = cast(ubyte,20) \ cast(ubyte,7)
    dim as ubyte va = 20, vb = 7
    print "28 ubyte \: "; K28; G28; st; cast(ubyte, va \ vb)
end sub
const K29 = cast(ubyte,174) mod cast(ubyte,7)
dim shared as ubyte G29 = cast(ubyte,174) mod cast(ubyte,7)
sub S29()
    static as ubyte st = cast(ubyte,174) mod cast(ubyte,7)
    dim as ubyte va = 174, vb = 7
    print "29 ubyte mod: "; K29; G29; st; cast(ubyte, va mod vb)
end sub
const K30 = cast(ubyte,233) mod cast(ubyte,3)
dim shared as ubyte G30 = cast(ubyte,233) mod cast(ubyte,3)
sub S30()
    static as ubyte st = cast(ubyte,233) mod cast(ubyte,3)
    dim as ubyte va = 233, vb = 3
    print "30 ubyte mod: "; K30; G30; st; cast(ubyte, va mod vb)
end sub
const K31 = cast(ubyte,138) and cast(ubyte,242)
dim shared as ubyte G31 = cast(ubyte,138) and cast(ubyte,242)
sub S31()
    static as ubyte st = cast(ubyte,138) and cast(ubyte,242)
    dim as ubyte va = 138, vb = 242
    print "31 ubyte and: "; K31; G31; st; cast(ubyte, va and vb)
end sub
const K32 = cast(ubyte,33) and cast(ubyte,31)
dim shared as ubyte G32 = cast(ubyte,33) and cast(ubyte,31)
sub S32()
    static as ubyte st = cast(ubyte,33) and cast(ubyte,31)
    dim as ubyte va = 33, vb = 31
    print "32 ubyte and: "; K32; G32; st; cast(ubyte, va and vb)
end sub
const K33 = cast(ubyte,158) or cast(ubyte,228)
dim shared as ubyte G33 = cast(ubyte,158) or cast(ubyte,228)
sub S33()
    static as ubyte st = cast(ubyte,158) or cast(ubyte,228)
    dim as ubyte va = 158, vb = 228
    print "33 ubyte or: "; K33; G33; st; cast(ubyte, va or vb)
end sub
const K34 = cast(ubyte,145) or cast(ubyte,197)
dim shared as ubyte G34 = cast(ubyte,145) or cast(ubyte,197)
sub S34()
    static as ubyte st = cast(ubyte,145) or cast(ubyte,197)
    dim as ubyte va = 145, vb = 197
    print "34 ubyte or: "; K34; G34; st; cast(ubyte, va or vb)
end sub
const K35 = cast(ubyte,177) xor cast(ubyte,11)
dim shared as ubyte G35 = cast(ubyte,177) xor cast(ubyte,11)
sub S35()
    static as ubyte st = cast(ubyte,177) xor cast(ubyte,11)
    dim as ubyte va = 177, vb = 11
    print "35 ubyte xor: "; K35; G35; st; cast(ubyte, va xor vb)
end sub
const K36 = cast(ubyte,236) xor cast(ubyte,181)
dim shared as ubyte G36 = cast(ubyte,236) xor cast(ubyte,181)
sub S36()
    static as ubyte st = cast(ubyte,236) xor cast(ubyte,181)
    dim as ubyte va = 236, vb = 181
    print "36 ubyte xor: "; K36; G36; st; cast(ubyte, va xor vb)
end sub
const K37 = cast(ubyte,86) shl cast(ubyte,7)
dim shared as ubyte G37 = cast(ubyte,86) shl cast(ubyte,7)
sub S37()
    static as ubyte st = cast(ubyte,86) shl cast(ubyte,7)
    dim as ubyte va = 86, vb = 7
    print "37 ubyte shl: "; K37; G37; st; cast(ubyte, va shl vb)
end sub
const K38 = cast(ubyte,30) shl cast(ubyte,4)
dim shared as ubyte G38 = cast(ubyte,30) shl cast(ubyte,4)
sub S38()
    static as ubyte st = cast(ubyte,30) shl cast(ubyte,4)
    dim as ubyte va = 30, vb = 4
    print "38 ubyte shl: "; K38; G38; st; cast(ubyte, va shl vb)
end sub
const K39 = cast(ubyte,66) shr cast(ubyte,6)
dim shared as ubyte G39 = cast(ubyte,66) shr cast(ubyte,6)
sub S39()
    static as ubyte st = cast(ubyte,66) shr cast(ubyte,6)
    dim as ubyte va = 66, vb = 6
    print "39 ubyte shr: "; K39; G39; st; cast(ubyte, va shr vb)
end sub
const K40 = cast(ubyte,200) shr cast(ubyte,1)
dim shared as ubyte G40 = cast(ubyte,200) shr cast(ubyte,1)
sub S40()
    static as ubyte st = cast(ubyte,200) shr cast(ubyte,1)
    dim as ubyte va = 200, vb = 1
    print "40 ubyte shr: "; K40; G40; st; cast(ubyte, va shr vb)
end sub
const K41 = cast(short,-10963) + cast(short,26107)
dim shared as short G41 = cast(short,-10963) + cast(short,26107)
sub S41()
    static as short st = cast(short,-10963) + cast(short,26107)
    dim as short va = -10963, vb = 26107
    print "41 short +: "; K41; G41; st; cast(short, va + vb)
end sub
const K42 = cast(short,19876) + cast(short,3648)
dim shared as short G42 = cast(short,19876) + cast(short,3648)
sub S42()
    static as short st = cast(short,19876) + cast(short,3648)
    dim as short va = 19876, vb = 3648
    print "42 short +: "; K42; G42; st; cast(short, va + vb)
end sub
const K43 = cast(short,-14821) - cast(short,23661)
dim shared as short G43 = cast(short,-14821) - cast(short,23661)
sub S43()
    static as short st = cast(short,-14821) - cast(short,23661)
    dim as short va = -14821, vb = 23661
    print "43 short -: "; K43; G43; st; cast(short, va - vb)
end sub
const K44 = cast(short,3725) - cast(short,21665)
dim shared as short G44 = cast(short,3725) - cast(short,21665)
sub S44()
    static as short st = cast(short,3725) - cast(short,21665)
    dim as short va = 3725, vb = 21665
    print "44 short -: "; K44; G44; st; cast(short, va - vb)
end sub
const K45 = cast(short,14256) * cast(short,17097)
dim shared as short G45 = cast(short,14256) * cast(short,17097)
sub S45()
    static as short st = cast(short,14256) * cast(short,17097)
    dim as short va = 14256, vb = 17097
    print "45 short *: "; K45; G45; st; cast(short, va * vb)
end sub
const K46 = cast(short,-2523) * cast(short,-12987)
dim shared as short G46 = cast(short,-2523) * cast(short,-12987)
sub S46()
    static as short st = cast(short,-2523) * cast(short,-12987)
    dim as short va = -2523, vb = -12987
    print "46 short *: "; K46; G46; st; cast(short, va * vb)
end sub
const K47 = cast(short,-21892) \ cast(short,7)
dim shared as short G47 = cast(short,-21892) \ cast(short,7)
sub S47()
    static as short st = cast(short,-21892) \ cast(short,7)
    dim as short va = -21892, vb = 7
    print "47 short \: "; K47; G47; st; cast(short, va \ vb)
end sub
const K48 = cast(short,-2365) \ cast(short,3)
dim shared as short G48 = cast(short,-2365) \ cast(short,3)
sub S48()
    static as short st = cast(short,-2365) \ cast(short,3)
    dim as short va = -2365, vb = 3
    print "48 short \: "; K48; G48; st; cast(short, va \ vb)
end sub
const K49 = cast(short,30797) mod cast(short,-3)
dim shared as short G49 = cast(short,30797) mod cast(short,-3)
sub S49()
    static as short st = cast(short,30797) mod cast(short,-3)
    dim as short va = 30797, vb = -3
    print "49 short mod: "; K49; G49; st; cast(short, va mod vb)
end sub
const K50 = cast(short,4185) mod cast(short,7)
dim shared as short G50 = cast(short,4185) mod cast(short,7)
sub S50()
    static as short st = cast(short,4185) mod cast(short,7)
    dim as short va = 4185, vb = 7
    print "50 short mod: "; K50; G50; st; cast(short, va mod vb)
end sub
const K51 = cast(short,22144) and cast(short,15630)
dim shared as short G51 = cast(short,22144) and cast(short,15630)
sub S51()
    static as short st = cast(short,22144) and cast(short,15630)
    dim as short va = 22144, vb = 15630
    print "51 short and: "; K51; G51; st; cast(short, va and vb)
end sub
const K52 = cast(short,8993) and cast(short,-16320)
dim shared as short G52 = cast(short,8993) and cast(short,-16320)
sub S52()
    static as short st = cast(short,8993) and cast(short,-16320)
    dim as short va = 8993, vb = -16320
    print "52 short and: "; K52; G52; st; cast(short, va and vb)
end sub
const K53 = cast(short,-25692) or cast(short,27085)
dim shared as short G53 = cast(short,-25692) or cast(short,27085)
sub S53()
    static as short st = cast(short,-25692) or cast(short,27085)
    dim as short va = -25692, vb = 27085
    print "53 short or: "; K53; G53; st; cast(short, va or vb)
end sub
const K54 = cast(short,18661) or cast(short,19407)
dim shared as short G54 = cast(short,18661) or cast(short,19407)
sub S54()
    static as short st = cast(short,18661) or cast(short,19407)
    dim as short va = 18661, vb = 19407
    print "54 short or: "; K54; G54; st; cast(short, va or vb)
end sub
const K55 = cast(short,19526) xor cast(short,18890)
dim shared as short G55 = cast(short,19526) xor cast(short,18890)
sub S55()
    static as short st = cast(short,19526) xor cast(short,18890)
    dim as short va = 19526, vb = 18890
    print "55 short xor: "; K55; G55; st; cast(short, va xor vb)
end sub
const K56 = cast(short,-19198) xor cast(short,30346)
dim shared as short G56 = cast(short,-19198) xor cast(short,30346)
sub S56()
    static as short st = cast(short,-19198) xor cast(short,30346)
    dim as short va = -19198, vb = 30346
    print "56 short xor: "; K56; G56; st; cast(short, va xor vb)
end sub
const K57 = cast(short,19718) shl cast(short,6)
dim shared as short G57 = cast(short,19718) shl cast(short,6)
sub S57()
    static as short st = cast(short,19718) shl cast(short,6)
    dim as short va = 19718, vb = 6
    print "57 short shl: "; K57; G57; st; cast(short, va shl vb)
end sub
const K58 = cast(short,-23941) shl cast(short,14)
dim shared as short G58 = cast(short,-23941) shl cast(short,14)
sub S58()
    static as short st = cast(short,-23941) shl cast(short,14)
    dim as short va = -23941, vb = 14
    print "58 short shl: "; K58; G58; st; cast(short, va shl vb)
end sub
const K59 = cast(short,-11495) shr cast(short,10)
dim shared as short G59 = cast(short,-11495) shr cast(short,10)
sub S59()
    static as short st = cast(short,-11495) shr cast(short,10)
    dim as short va = -11495, vb = 10
    print "59 short shr: "; K59; G59; st; cast(short, va shr vb)
end sub
const K60 = cast(short,-25877) shr cast(short,0)
dim shared as short G60 = cast(short,-25877) shr cast(short,0)
sub S60()
    static as short st = cast(short,-25877) shr cast(short,0)
    dim as short va = -25877, vb = 0
    print "60 short shr: "; K60; G60; st; cast(short, va shr vb)
end sub
const K61 = cast(ushort,19826) + cast(ushort,13299)
dim shared as ushort G61 = cast(ushort,19826) + cast(ushort,13299)
sub S61()
    static as ushort st = cast(ushort,19826) + cast(ushort,13299)
    dim as ushort va = 19826, vb = 13299
    print "61 ushort +: "; K61; G61; st; cast(ushort, va + vb)
end sub
const K62 = cast(ushort,47659) + cast(ushort,3342)
dim shared as ushort G62 = cast(ushort,47659) + cast(ushort,3342)
sub S62()
    static as ushort st = cast(ushort,47659) + cast(ushort,3342)
    dim as ushort va = 47659, vb = 3342
    print "62 ushort +: "; K62; G62; st; cast(ushort, va + vb)
end sub
const K63 = cast(ushort,9216) - cast(ushort,27256)
dim shared as ushort G63 = cast(ushort,9216) - cast(ushort,27256)
sub S63()
    static as ushort st = cast(ushort,9216) - cast(ushort,27256)
    dim as ushort va = 9216, vb = 27256
    print "63 ushort -: "; K63; G63; st; cast(ushort, va - vb)
end sub
const K64 = cast(ushort,49313) - cast(ushort,19470)
dim shared as ushort G64 = cast(ushort,49313) - cast(ushort,19470)
sub S64()
    static as ushort st = cast(ushort,49313) - cast(ushort,19470)
    dim as ushort va = 49313, vb = 19470
    print "64 ushort -: "; K64; G64; st; cast(ushort, va - vb)
end sub
const K65 = cast(ushort,33063) * cast(ushort,45533)
dim shared as ushort G65 = cast(ushort,33063) * cast(ushort,45533)
sub S65()
    static as ushort st = cast(ushort,33063) * cast(ushort,45533)
    dim as ushort va = 33063, vb = 45533
    print "65 ushort *: "; K65; G65; st; cast(ushort, va * vb)
end sub
const K66 = cast(ushort,47731) * cast(ushort,62147)
dim shared as ushort G66 = cast(ushort,47731) * cast(ushort,62147)
sub S66()
    static as ushort st = cast(ushort,47731) * cast(ushort,62147)
    dim as ushort va = 47731, vb = 62147
    print "66 ushort *: "; K66; G66; st; cast(ushort, va * vb)
end sub
const K67 = cast(ushort,16101) \ cast(ushort,7)
dim shared as ushort G67 = cast(ushort,16101) \ cast(ushort,7)
sub S67()
    static as ushort st = cast(ushort,16101) \ cast(ushort,7)
    dim as ushort va = 16101, vb = 7
    print "67 ushort \: "; K67; G67; st; cast(ushort, va \ vb)
end sub
const K68 = cast(ushort,61078) \ cast(ushort,7)
dim shared as ushort G68 = cast(ushort,61078) \ cast(ushort,7)
sub S68()
    static as ushort st = cast(ushort,61078) \ cast(ushort,7)
    dim as ushort va = 61078, vb = 7
    print "68 ushort \: "; K68; G68; st; cast(ushort, va \ vb)
end sub
const K69 = cast(ushort,40875) mod cast(ushort,3)
dim shared as ushort G69 = cast(ushort,40875) mod cast(ushort,3)
sub S69()
    static as ushort st = cast(ushort,40875) mod cast(ushort,3)
    dim as ushort va = 40875, vb = 3
    print "69 ushort mod: "; K69; G69; st; cast(ushort, va mod vb)
end sub
const K70 = cast(ushort,13393) mod cast(ushort,1000)
dim shared as ushort G70 = cast(ushort,13393) mod cast(ushort,1000)
sub S70()
    static as ushort st = cast(ushort,13393) mod cast(ushort,1000)
    dim as ushort va = 13393, vb = 1000
    print "70 ushort mod: "; K70; G70; st; cast(ushort, va mod vb)
end sub
const K71 = cast(ushort,34702) and cast(ushort,62733)
dim shared as ushort G71 = cast(ushort,34702) and cast(ushort,62733)
sub S71()
    static as ushort st = cast(ushort,34702) and cast(ushort,62733)
    dim as ushort va = 34702, vb = 62733
    print "71 ushort and: "; K71; G71; st; cast(ushort, va and vb)
end sub
const K72 = cast(ushort,21160) and cast(ushort,3027)
dim shared as ushort G72 = cast(ushort,21160) and cast(ushort,3027)
sub S72()
    static as ushort st = cast(ushort,21160) and cast(ushort,3027)
    dim as ushort va = 21160, vb = 3027
    print "72 ushort and: "; K72; G72; st; cast(ushort, va and vb)
end sub
const K73 = cast(ushort,26897) or cast(ushort,47415)
dim shared as ushort G73 = cast(ushort,26897) or cast(ushort,47415)
sub S73()
    static as ushort st = cast(ushort,26897) or cast(ushort,47415)
    dim as ushort va = 26897, vb = 47415
    print "73 ushort or: "; K73; G73; st; cast(ushort, va or vb)
end sub
const K74 = cast(ushort,19215) or cast(ushort,3544)
dim shared as ushort G74 = cast(ushort,19215) or cast(ushort,3544)
sub S74()
    static as ushort st = cast(ushort,19215) or cast(ushort,3544)
    dim as ushort va = 19215, vb = 3544
    print "74 ushort or: "; K74; G74; st; cast(ushort, va or vb)
end sub
const K75 = cast(ushort,39071) xor cast(ushort,11928)
dim shared as ushort G75 = cast(ushort,39071) xor cast(ushort,11928)
sub S75()
    static as ushort st = cast(ushort,39071) xor cast(ushort,11928)
    dim as ushort va = 39071, vb = 11928
    print "75 ushort xor: "; K75; G75; st; cast(ushort, va xor vb)
end sub
const K76 = cast(ushort,34224) xor cast(ushort,48064)
dim shared as ushort G76 = cast(ushort,34224) xor cast(ushort,48064)
sub S76()
    static as ushort st = cast(ushort,34224) xor cast(ushort,48064)
    dim as ushort va = 34224, vb = 48064
    print "76 ushort xor: "; K76; G76; st; cast(ushort, va xor vb)
end sub
const K77 = cast(ushort,21894) shl cast(ushort,7)
dim shared as ushort G77 = cast(ushort,21894) shl cast(ushort,7)
sub S77()
    static as ushort st = cast(ushort,21894) shl cast(ushort,7)
    dim as ushort va = 21894, vb = 7
    print "77 ushort shl: "; K77; G77; st; cast(ushort, va shl vb)
end sub
const K78 = cast(ushort,43209) shl cast(ushort,6)
dim shared as ushort G78 = cast(ushort,43209) shl cast(ushort,6)
sub S78()
    static as ushort st = cast(ushort,43209) shl cast(ushort,6)
    dim as ushort va = 43209, vb = 6
    print "78 ushort shl: "; K78; G78; st; cast(ushort, va shl vb)
end sub
const K79 = cast(ushort,31377) shr cast(ushort,7)
dim shared as ushort G79 = cast(ushort,31377) shr cast(ushort,7)
sub S79()
    static as ushort st = cast(ushort,31377) shr cast(ushort,7)
    dim as ushort va = 31377, vb = 7
    print "79 ushort shr: "; K79; G79; st; cast(ushort, va shr vb)
end sub
const K80 = cast(ushort,26203) shr cast(ushort,11)
dim shared as ushort G80 = cast(ushort,26203) shr cast(ushort,11)
sub S80()
    static as ushort st = cast(ushort,26203) shr cast(ushort,11)
    dim as ushort va = 26203, vb = 11
    print "80 ushort shr: "; K80; G80; st; cast(ushort, va shr vb)
end sub
const K81 = cast(long,992154613) + cast(long,2102831398)
dim shared as long G81 = cast(long,992154613) + cast(long,2102831398)
sub S81()
    static as long st = cast(long,992154613) + cast(long,2102831398)
    dim as long va = 992154613, vb = 2102831398
    print "81 long +: "; K81; G81; st; cast(long, va + vb)
end sub
const K82 = cast(long,1246030726) + cast(long,-119228019)
dim shared as long G82 = cast(long,1246030726) + cast(long,-119228019)
sub S82()
    static as long st = cast(long,1246030726) + cast(long,-119228019)
    dim as long va = 1246030726, vb = -119228019
    print "82 long +: "; K82; G82; st; cast(long, va + vb)
end sub
const K83 = cast(long,-668808329) - cast(long,2038026314)
dim shared as long G83 = cast(long,-668808329) - cast(long,2038026314)
sub S83()
    static as long st = cast(long,-668808329) - cast(long,2038026314)
    dim as long va = -668808329, vb = 2038026314
    print "83 long -: "; K83; G83; st; cast(long, va - vb)
end sub
const K84 = cast(long,-1801575013) - cast(long,-1708722039)
dim shared as long G84 = cast(long,-1801575013) - cast(long,-1708722039)
sub S84()
    static as long st = cast(long,-1801575013) - cast(long,-1708722039)
    dim as long va = -1801575013, vb = -1708722039
    print "84 long -: "; K84; G84; st; cast(long, va - vb)
end sub
const K85 = cast(long,-128505482) * cast(long,-696912211)
dim shared as long G85 = cast(long,-128505482) * cast(long,-696912211)
sub S85()
    static as long st = cast(long,-128505482) * cast(long,-696912211)
    dim as long va = -128505482, vb = -696912211
    print "85 long *: "; K85; G85; st; cast(long, va * vb)
end sub
const K86 = cast(long,-2139287500) * cast(long,614751999)
dim shared as long G86 = cast(long,-2139287500) * cast(long,614751999)
sub S86()
    static as long st = cast(long,-2139287500) * cast(long,614751999)
    dim as long va = -2139287500, vb = 614751999
    print "86 long *: "; K86; G86; st; cast(long, va * vb)
end sub
const K87 = cast(long,-1291413343) \ cast(long,-7)
dim shared as long G87 = cast(long,-1291413343) \ cast(long,-7)
sub S87()
    static as long st = cast(long,-1291413343) \ cast(long,-7)
    dim as long va = -1291413343, vb = -7
    print "87 long \: "; K87; G87; st; cast(long, va \ vb)
end sub
const K88 = cast(long,-719333127) \ cast(long,-7)
dim shared as long G88 = cast(long,-719333127) \ cast(long,-7)
sub S88()
    static as long st = cast(long,-719333127) \ cast(long,-7)
    dim as long va = -719333127, vb = -7
    print "88 long \: "; K88; G88; st; cast(long, va \ vb)
end sub
const K89 = cast(long,-1465202095) mod cast(long,3)
dim shared as long G89 = cast(long,-1465202095) mod cast(long,3)
sub S89()
    static as long st = cast(long,-1465202095) mod cast(long,3)
    dim as long va = -1465202095, vb = 3
    print "89 long mod: "; K89; G89; st; cast(long, va mod vb)
end sub
const K90 = cast(long,1738826505) mod cast(long,-3)
dim shared as long G90 = cast(long,1738826505) mod cast(long,-3)
sub S90()
    static as long st = cast(long,1738826505) mod cast(long,-3)
    dim as long va = 1738826505, vb = -3
    print "90 long mod: "; K90; G90; st; cast(long, va mod vb)
end sub
const K91 = cast(long,207384927) and cast(long,-2055585614)
dim shared as long G91 = cast(long,207384927) and cast(long,-2055585614)
sub S91()
    static as long st = cast(long,207384927) and cast(long,-2055585614)
    dim as long va = 207384927, vb = -2055585614
    print "91 long and: "; K91; G91; st; cast(long, va and vb)
end sub
const K92 = cast(long,-1549406328) and cast(long,1605917709)
dim shared as long G92 = cast(long,-1549406328) and cast(long,1605917709)
sub S92()
    static as long st = cast(long,-1549406328) and cast(long,1605917709)
    dim as long va = -1549406328, vb = 1605917709
    print "92 long and: "; K92; G92; st; cast(long, va and vb)
end sub
const K93 = cast(long,-2027251502) or cast(long,-1233601395)
dim shared as long G93 = cast(long,-2027251502) or cast(long,-1233601395)
sub S93()
    static as long st = cast(long,-2027251502) or cast(long,-1233601395)
    dim as long va = -2027251502, vb = -1233601395
    print "93 long or: "; K93; G93; st; cast(long, va or vb)
end sub
const K94 = cast(long,4990422) or cast(long,-747370238)
dim shared as long G94 = cast(long,4990422) or cast(long,-747370238)
sub S94()
    static as long st = cast(long,4990422) or cast(long,-747370238)
    dim as long va = 4990422, vb = -747370238
    print "94 long or: "; K94; G94; st; cast(long, va or vb)
end sub
const K95 = cast(long,190493678) xor cast(long,1435356596)
dim shared as long G95 = cast(long,190493678) xor cast(long,1435356596)
sub S95()
    static as long st = cast(long,190493678) xor cast(long,1435356596)
    dim as long va = 190493678, vb = 1435356596
    print "95 long xor: "; K95; G95; st; cast(long, va xor vb)
end sub
const K96 = cast(long,1030457370) xor cast(long,1708125690)
dim shared as long G96 = cast(long,1030457370) xor cast(long,1708125690)
sub S96()
    static as long st = cast(long,1030457370) xor cast(long,1708125690)
    dim as long va = 1030457370, vb = 1708125690
    print "96 long xor: "; K96; G96; st; cast(long, va xor vb)
end sub
const K97 = cast(long,71987252) shl cast(long,28)
dim shared as long G97 = cast(long,71987252) shl cast(long,28)
sub S97()
    static as long st = cast(long,71987252) shl cast(long,28)
    dim as long va = 71987252, vb = 28
    print "97 long shl: "; K97; G97; st; cast(long, va shl vb)
end sub
const K98 = cast(long,1187584914) shl cast(long,9)
dim shared as long G98 = cast(long,1187584914) shl cast(long,9)
sub S98()
    static as long st = cast(long,1187584914) shl cast(long,9)
    dim as long va = 1187584914, vb = 9
    print "98 long shl: "; K98; G98; st; cast(long, va shl vb)
end sub
const K99 = cast(long,-1407260129) shr cast(long,3)
dim shared as long G99 = cast(long,-1407260129) shr cast(long,3)
sub S99()
    static as long st = cast(long,-1407260129) shr cast(long,3)
    dim as long va = -1407260129, vb = 3
    print "99 long shr: "; K99; G99; st; cast(long, va shr vb)
end sub
const K100 = cast(long,238121025) shr cast(long,15)
dim shared as long G100 = cast(long,238121025) shr cast(long,15)
sub S100()
    static as long st = cast(long,238121025) shr cast(long,15)
    dim as long va = 238121025, vb = 15
    print "100 long shr: "; K100; G100; st; cast(long, va shr vb)
end sub
const K101 = cast(ulong,821653592) + cast(ulong,272167093)
dim shared as ulong G101 = cast(ulong,821653592) + cast(ulong,272167093)
sub S101()
    static as ulong st = cast(ulong,821653592) + cast(ulong,272167093)
    dim as ulong va = 821653592, vb = 272167093
    print "101 ulong +: "; K101; G101; st; cast(ulong, va + vb)
end sub
const K102 = cast(ulong,1190502836) + cast(ulong,3467594005)
dim shared as ulong G102 = cast(ulong,1190502836) + cast(ulong,3467594005)
sub S102()
    static as ulong st = cast(ulong,1190502836) + cast(ulong,3467594005)
    dim as ulong va = 1190502836, vb = 3467594005
    print "102 ulong +: "; K102; G102; st; cast(ulong, va + vb)
end sub
const K103 = cast(ulong,3984910622) - cast(ulong,1922119101)
dim shared as ulong G103 = cast(ulong,3984910622) - cast(ulong,1922119101)
sub S103()
    static as ulong st = cast(ulong,3984910622) - cast(ulong,1922119101)
    dim as ulong va = 3984910622, vb = 1922119101
    print "103 ulong -: "; K103; G103; st; cast(ulong, va - vb)
end sub
const K104 = cast(ulong,1789442528) - cast(ulong,1685192164)
dim shared as ulong G104 = cast(ulong,1789442528) - cast(ulong,1685192164)
sub S104()
    static as ulong st = cast(ulong,1789442528) - cast(ulong,1685192164)
    dim as ulong va = 1789442528, vb = 1685192164
    print "104 ulong -: "; K104; G104; st; cast(ulong, va - vb)
end sub
const K105 = cast(ulong,1357122900) * cast(ulong,2882590715)
dim shared as ulong G105 = cast(ulong,1357122900) * cast(ulong,2882590715)
sub S105()
    static as ulong st = cast(ulong,1357122900) * cast(ulong,2882590715)
    dim as ulong va = 1357122900, vb = 2882590715
    print "105 ulong *: "; K105; G105; st; cast(ulong, va * vb)
end sub
const K106 = cast(ulong,1839700615) * cast(ulong,3336900082)
dim shared as ulong G106 = cast(ulong,1839700615) * cast(ulong,3336900082)
sub S106()
    static as ulong st = cast(ulong,1839700615) * cast(ulong,3336900082)
    dim as ulong va = 1839700615, vb = 3336900082
    print "106 ulong *: "; K106; G106; st; cast(ulong, va * vb)
end sub
const K107 = cast(ulong,1572745251) \ cast(ulong,1000)
dim shared as ulong G107 = cast(ulong,1572745251) \ cast(ulong,1000)
sub S107()
    static as ulong st = cast(ulong,1572745251) \ cast(ulong,1000)
    dim as ulong va = 1572745251, vb = 1000
    print "107 ulong \: "; K107; G107; st; cast(ulong, va \ vb)
end sub
const K108 = cast(ulong,4090974082) \ cast(ulong,1000)
dim shared as ulong G108 = cast(ulong,4090974082) \ cast(ulong,1000)
sub S108()
    static as ulong st = cast(ulong,4090974082) \ cast(ulong,1000)
    dim as ulong va = 4090974082, vb = 1000
    print "108 ulong \: "; K108; G108; st; cast(ulong, va \ vb)
end sub
const K109 = cast(ulong,3575322645) mod cast(ulong,7)
dim shared as ulong G109 = cast(ulong,3575322645) mod cast(ulong,7)
sub S109()
    static as ulong st = cast(ulong,3575322645) mod cast(ulong,7)
    dim as ulong va = 3575322645, vb = 7
    print "109 ulong mod: "; K109; G109; st; cast(ulong, va mod vb)
end sub
const K110 = cast(ulong,1809368694) mod cast(ulong,3)
dim shared as ulong G110 = cast(ulong,1809368694) mod cast(ulong,3)
sub S110()
    static as ulong st = cast(ulong,1809368694) mod cast(ulong,3)
    dim as ulong va = 1809368694, vb = 3
    print "110 ulong mod: "; K110; G110; st; cast(ulong, va mod vb)
end sub
const K111 = cast(ulong,3101614209) and cast(ulong,83678549)
dim shared as ulong G111 = cast(ulong,3101614209) and cast(ulong,83678549)
sub S111()
    static as ulong st = cast(ulong,3101614209) and cast(ulong,83678549)
    dim as ulong va = 3101614209, vb = 83678549
    print "111 ulong and: "; K111; G111; st; cast(ulong, va and vb)
end sub
const K112 = cast(ulong,2379627705) and cast(ulong,77661511)
dim shared as ulong G112 = cast(ulong,2379627705) and cast(ulong,77661511)
sub S112()
    static as ulong st = cast(ulong,2379627705) and cast(ulong,77661511)
    dim as ulong va = 2379627705, vb = 77661511
    print "112 ulong and: "; K112; G112; st; cast(ulong, va and vb)
end sub
const K113 = cast(ulong,2679746384) or cast(ulong,276126871)
dim shared as ulong G113 = cast(ulong,2679746384) or cast(ulong,276126871)
sub S113()
    static as ulong st = cast(ulong,2679746384) or cast(ulong,276126871)
    dim as ulong va = 2679746384, vb = 276126871
    print "113 ulong or: "; K113; G113; st; cast(ulong, va or vb)
end sub
const K114 = cast(ulong,3385993552) or cast(ulong,450024945)
dim shared as ulong G114 = cast(ulong,3385993552) or cast(ulong,450024945)
sub S114()
    static as ulong st = cast(ulong,3385993552) or cast(ulong,450024945)
    dim as ulong va = 3385993552, vb = 450024945
    print "114 ulong or: "; K114; G114; st; cast(ulong, va or vb)
end sub
const K115 = cast(ulong,1140589863) xor cast(ulong,3345768511)
dim shared as ulong G115 = cast(ulong,1140589863) xor cast(ulong,3345768511)
sub S115()
    static as ulong st = cast(ulong,1140589863) xor cast(ulong,3345768511)
    dim as ulong va = 1140589863, vb = 3345768511
    print "115 ulong xor: "; K115; G115; st; cast(ulong, va xor vb)
end sub
const K116 = cast(ulong,1110717268) xor cast(ulong,2450686540)
dim shared as ulong G116 = cast(ulong,1110717268) xor cast(ulong,2450686540)
sub S116()
    static as ulong st = cast(ulong,1110717268) xor cast(ulong,2450686540)
    dim as ulong va = 1110717268, vb = 2450686540
    print "116 ulong xor: "; K116; G116; st; cast(ulong, va xor vb)
end sub
const K117 = cast(ulong,3008270030) shl cast(ulong,3)
dim shared as ulong G117 = cast(ulong,3008270030) shl cast(ulong,3)
sub S117()
    static as ulong st = cast(ulong,3008270030) shl cast(ulong,3)
    dim as ulong va = 3008270030, vb = 3
    print "117 ulong shl: "; K117; G117; st; cast(ulong, va shl vb)
end sub
const K118 = cast(ulong,787456633) shl cast(ulong,17)
dim shared as ulong G118 = cast(ulong,787456633) shl cast(ulong,17)
sub S118()
    static as ulong st = cast(ulong,787456633) shl cast(ulong,17)
    dim as ulong va = 787456633, vb = 17
    print "118 ulong shl: "; K118; G118; st; cast(ulong, va shl vb)
end sub
const K119 = cast(ulong,4030181318) shr cast(ulong,16)
dim shared as ulong G119 = cast(ulong,4030181318) shr cast(ulong,16)
sub S119()
    static as ulong st = cast(ulong,4030181318) shr cast(ulong,16)
    dim as ulong va = 4030181318, vb = 16
    print "119 ulong shr: "; K119; G119; st; cast(ulong, va shr vb)
end sub
const K120 = cast(ulong,3677474002) shr cast(ulong,7)
dim shared as ulong G120 = cast(ulong,3677474002) shr cast(ulong,7)
sub S120()
    static as ulong st = cast(ulong,3677474002) shr cast(ulong,7)
    dim as ulong va = 3677474002, vb = 7
    print "120 ulong shr: "; K120; G120; st; cast(ulong, va shr vb)
end sub
const K121 = cast(longint,-9010379856463363997ll) + cast(longint,978860232560792737ll)
dim shared as longint G121 = cast(longint,-9010379856463363997ll) + cast(longint,978860232560792737ll)
sub S121()
    static as longint st = cast(longint,-9010379856463363997ll) + cast(longint,978860232560792737ll)
    dim as longint va = -9010379856463363997ll, vb = 978860232560792737ll
    print "121 longint +: "; K121; G121; st; cast(longint, va + vb)
end sub
const K122 = cast(longint,7663270156050248360ll) + cast(longint,-6839595194117524180ll)
dim shared as longint G122 = cast(longint,7663270156050248360ll) + cast(longint,-6839595194117524180ll)
sub S122()
    static as longint st = cast(longint,7663270156050248360ll) + cast(longint,-6839595194117524180ll)
    dim as longint va = 7663270156050248360ll, vb = -6839595194117524180ll
    print "122 longint +: "; K122; G122; st; cast(longint, va + vb)
end sub
const K123 = cast(longint,3865270247093430054ll) - cast(longint,-4392256563783091620ll)
dim shared as longint G123 = cast(longint,3865270247093430054ll) - cast(longint,-4392256563783091620ll)
sub S123()
    static as longint st = cast(longint,3865270247093430054ll) - cast(longint,-4392256563783091620ll)
    dim as longint va = 3865270247093430054ll, vb = -4392256563783091620ll
    print "123 longint -: "; K123; G123; st; cast(longint, va - vb)
end sub
const K124 = cast(longint,2373562868011285484ll) - cast(longint,4786897880108842461ll)
dim shared as longint G124 = cast(longint,2373562868011285484ll) - cast(longint,4786897880108842461ll)
sub S124()
    static as longint st = cast(longint,2373562868011285484ll) - cast(longint,4786897880108842461ll)
    dim as longint va = 2373562868011285484ll, vb = 4786897880108842461ll
    print "124 longint -: "; K124; G124; st; cast(longint, va - vb)
end sub
const K125 = cast(longint,-5941698436329734509ll) * cast(longint,5601887805137817371ll)
dim shared as longint G125 = cast(longint,-5941698436329734509ll) * cast(longint,5601887805137817371ll)
sub S125()
    static as longint st = cast(longint,-5941698436329734509ll) * cast(longint,5601887805137817371ll)
    dim as longint va = -5941698436329734509ll, vb = 5601887805137817371ll
    print "125 longint *: "; K125; G125; st; cast(longint, va * vb)
end sub
const K126 = cast(longint,-4603407812585358250ll) * cast(longint,262587742876088457ll)
dim shared as longint G126 = cast(longint,-4603407812585358250ll) * cast(longint,262587742876088457ll)
sub S126()
    static as longint st = cast(longint,-4603407812585358250ll) * cast(longint,262587742876088457ll)
    dim as longint va = -4603407812585358250ll, vb = 262587742876088457ll
    print "126 longint *: "; K126; G126; st; cast(longint, va * vb)
end sub
const K127 = cast(longint,8017745258742078042ll) \ cast(longint,-3ll)
dim shared as longint G127 = cast(longint,8017745258742078042ll) \ cast(longint,-3ll)
sub S127()
    static as longint st = cast(longint,8017745258742078042ll) \ cast(longint,-3ll)
    dim as longint va = 8017745258742078042ll, vb = -3ll
    print "127 longint \: "; K127; G127; st; cast(longint, va \ vb)
end sub
const K128 = cast(longint,8889152758707989994ll) \ cast(longint,3ll)
dim shared as longint G128 = cast(longint,8889152758707989994ll) \ cast(longint,3ll)
sub S128()
    static as longint st = cast(longint,8889152758707989994ll) \ cast(longint,3ll)
    dim as longint va = 8889152758707989994ll, vb = 3ll
    print "128 longint \: "; K128; G128; st; cast(longint, va \ vb)
end sub
const K129 = cast(longint,-1277608368366773840ll) mod cast(longint,-3ll)
dim shared as longint G129 = cast(longint,-1277608368366773840ll) mod cast(longint,-3ll)
sub S129()
    static as longint st = cast(longint,-1277608368366773840ll) mod cast(longint,-3ll)
    dim as longint va = -1277608368366773840ll, vb = -3ll
    print "129 longint mod: "; K129; G129; st; cast(longint, va mod vb)
end sub
const K130 = cast(longint,-747961094045913286ll) mod cast(longint,3ll)
dim shared as longint G130 = cast(longint,-747961094045913286ll) mod cast(longint,3ll)
sub S130()
    static as longint st = cast(longint,-747961094045913286ll) mod cast(longint,3ll)
    dim as longint va = -747961094045913286ll, vb = 3ll
    print "130 longint mod: "; K130; G130; st; cast(longint, va mod vb)
end sub
const K131 = cast(longint,-3255225001996124109ll) and cast(longint,-5204456272052713378ll)
dim shared as longint G131 = cast(longint,-3255225001996124109ll) and cast(longint,-5204456272052713378ll)
sub S131()
    static as longint st = cast(longint,-3255225001996124109ll) and cast(longint,-5204456272052713378ll)
    dim as longint va = -3255225001996124109ll, vb = -5204456272052713378ll
    print "131 longint and: "; K131; G131; st; cast(longint, va and vb)
end sub
const K132 = cast(longint,-9203654043076504559ll) and cast(longint,-7675864351752697844ll)
dim shared as longint G132 = cast(longint,-9203654043076504559ll) and cast(longint,-7675864351752697844ll)
sub S132()
    static as longint st = cast(longint,-9203654043076504559ll) and cast(longint,-7675864351752697844ll)
    dim as longint va = -9203654043076504559ll, vb = -7675864351752697844ll
    print "132 longint and: "; K132; G132; st; cast(longint, va and vb)
end sub
const K133 = cast(longint,-9132050811080701457ll) or cast(longint,5848434733052104454ll)
dim shared as longint G133 = cast(longint,-9132050811080701457ll) or cast(longint,5848434733052104454ll)
sub S133()
    static as longint st = cast(longint,-9132050811080701457ll) or cast(longint,5848434733052104454ll)
    dim as longint va = -9132050811080701457ll, vb = 5848434733052104454ll
    print "133 longint or: "; K133; G133; st; cast(longint, va or vb)
end sub
const K134 = cast(longint,-1955748804419735679ll) or cast(longint,1781204880812938877ll)
dim shared as longint G134 = cast(longint,-1955748804419735679ll) or cast(longint,1781204880812938877ll)
sub S134()
    static as longint st = cast(longint,-1955748804419735679ll) or cast(longint,1781204880812938877ll)
    dim as longint va = -1955748804419735679ll, vb = 1781204880812938877ll
    print "134 longint or: "; K134; G134; st; cast(longint, va or vb)
end sub
const K135 = cast(longint,-107161680368683880ll) xor cast(longint,-6553164941746370636ll)
dim shared as longint G135 = cast(longint,-107161680368683880ll) xor cast(longint,-6553164941746370636ll)
sub S135()
    static as longint st = cast(longint,-107161680368683880ll) xor cast(longint,-6553164941746370636ll)
    dim as longint va = -107161680368683880ll, vb = -6553164941746370636ll
    print "135 longint xor: "; K135; G135; st; cast(longint, va xor vb)
end sub
const K136 = cast(longint,102214117689758779ll) xor cast(longint,5620309939778654540ll)
dim shared as longint G136 = cast(longint,102214117689758779ll) xor cast(longint,5620309939778654540ll)
sub S136()
    static as longint st = cast(longint,102214117689758779ll) xor cast(longint,5620309939778654540ll)
    dim as longint va = 102214117689758779ll, vb = 5620309939778654540ll
    print "136 longint xor: "; K136; G136; st; cast(longint, va xor vb)
end sub
const K137 = cast(longint,-4981714391862579947ll) shl cast(longint,46ll)
dim shared as longint G137 = cast(longint,-4981714391862579947ll) shl cast(longint,46ll)
sub S137()
    static as longint st = cast(longint,-4981714391862579947ll) shl cast(longint,46ll)
    dim as longint va = -4981714391862579947ll, vb = 46ll
    print "137 longint shl: "; K137; G137; st; cast(longint, va shl vb)
end sub
const K138 = cast(longint,-7288004669020645255ll) shl cast(longint,31ll)
dim shared as longint G138 = cast(longint,-7288004669020645255ll) shl cast(longint,31ll)
sub S138()
    static as longint st = cast(longint,-7288004669020645255ll) shl cast(longint,31ll)
    dim as longint va = -7288004669020645255ll, vb = 31ll
    print "138 longint shl: "; K138; G138; st; cast(longint, va shl vb)
end sub
const K139 = cast(longint,-4357251900307774353ll) shr cast(longint,11ll)
dim shared as longint G139 = cast(longint,-4357251900307774353ll) shr cast(longint,11ll)
sub S139()
    static as longint st = cast(longint,-4357251900307774353ll) shr cast(longint,11ll)
    dim as longint va = -4357251900307774353ll, vb = 11ll
    print "139 longint shr: "; K139; G139; st; cast(longint, va shr vb)
end sub
const K140 = cast(longint,479433677232134624ll) shr cast(longint,32ll)
dim shared as longint G140 = cast(longint,479433677232134624ll) shr cast(longint,32ll)
sub S140()
    static as longint st = cast(longint,479433677232134624ll) shr cast(longint,32ll)
    dim as longint va = 479433677232134624ll, vb = 32ll
    print "140 longint shr: "; K140; G140; st; cast(longint, va shr vb)
end sub
const K141 = cast(ulongint,3785595271843816668ull) + cast(ulongint,1415600877144603601ull)
dim shared as ulongint G141 = cast(ulongint,3785595271843816668ull) + cast(ulongint,1415600877144603601ull)
sub S141()
    static as ulongint st = cast(ulongint,3785595271843816668ull) + cast(ulongint,1415600877144603601ull)
    dim as ulongint va = 3785595271843816668ull, vb = 1415600877144603601ull
    print "141 ulongint +: "; K141; G141; st; cast(ulongint, va + vb)
end sub
const K142 = cast(ulongint,12611975579451021275ull) + cast(ulongint,11856884202651694628ull)
dim shared as ulongint G142 = cast(ulongint,12611975579451021275ull) + cast(ulongint,11856884202651694628ull)
sub S142()
    static as ulongint st = cast(ulongint,12611975579451021275ull) + cast(ulongint,11856884202651694628ull)
    dim as ulongint va = 12611975579451021275ull, vb = 11856884202651694628ull
    print "142 ulongint +: "; K142; G142; st; cast(ulongint, va + vb)
end sub
const K143 = cast(ulongint,11062609661924815215ull) - cast(ulongint,12781505952314784891ull)
dim shared as ulongint G143 = cast(ulongint,11062609661924815215ull) - cast(ulongint,12781505952314784891ull)
sub S143()
    static as ulongint st = cast(ulongint,11062609661924815215ull) - cast(ulongint,12781505952314784891ull)
    dim as ulongint va = 11062609661924815215ull, vb = 12781505952314784891ull
    print "143 ulongint -: "; K143; G143; st; cast(ulongint, va - vb)
end sub
const K144 = cast(ulongint,10473354754137504858ull) - cast(ulongint,8899091195627646637ull)
dim shared as ulongint G144 = cast(ulongint,10473354754137504858ull) - cast(ulongint,8899091195627646637ull)
sub S144()
    static as ulongint st = cast(ulongint,10473354754137504858ull) - cast(ulongint,8899091195627646637ull)
    dim as ulongint va = 10473354754137504858ull, vb = 8899091195627646637ull
    print "144 ulongint -: "; K144; G144; st; cast(ulongint, va - vb)
end sub
const K145 = cast(ulongint,12464606276363141683ull) * cast(ulongint,8571516802798543265ull)
dim shared as ulongint G145 = cast(ulongint,12464606276363141683ull) * cast(ulongint,8571516802798543265ull)
sub S145()
    static as ulongint st = cast(ulongint,12464606276363141683ull) * cast(ulongint,8571516802798543265ull)
    dim as ulongint va = 12464606276363141683ull, vb = 8571516802798543265ull
    print "145 ulongint *: "; K145; G145; st; cast(ulongint, va * vb)
end sub
const K146 = cast(ulongint,14151784330264969397ull) * cast(ulongint,17270844210970004325ull)
dim shared as ulongint G146 = cast(ulongint,14151784330264969397ull) * cast(ulongint,17270844210970004325ull)
sub S146()
    static as ulongint st = cast(ulongint,14151784330264969397ull) * cast(ulongint,17270844210970004325ull)
    dim as ulongint va = 14151784330264969397ull, vb = 17270844210970004325ull
    print "146 ulongint *: "; K146; G146; st; cast(ulongint, va * vb)
end sub
const K147 = cast(ulongint,5341971990879874064ull) \ cast(ulongint,7ull)
dim shared as ulongint G147 = cast(ulongint,5341971990879874064ull) \ cast(ulongint,7ull)
sub S147()
    static as ulongint st = cast(ulongint,5341971990879874064ull) \ cast(ulongint,7ull)
    dim as ulongint va = 5341971990879874064ull, vb = 7ull
    print "147 ulongint \: "; K147; G147; st; cast(ulongint, va \ vb)
end sub
const K148 = cast(ulongint,17165360466412831204ull) \ cast(ulongint,3ull)
dim shared as ulongint G148 = cast(ulongint,17165360466412831204ull) \ cast(ulongint,3ull)
sub S148()
    static as ulongint st = cast(ulongint,17165360466412831204ull) \ cast(ulongint,3ull)
    dim as ulongint va = 17165360466412831204ull, vb = 3ull
    print "148 ulongint \: "; K148; G148; st; cast(ulongint, va \ vb)
end sub
const K149 = cast(ulongint,9667306134726983963ull) mod cast(ulongint,1000ull)
dim shared as ulongint G149 = cast(ulongint,9667306134726983963ull) mod cast(ulongint,1000ull)
sub S149()
    static as ulongint st = cast(ulongint,9667306134726983963ull) mod cast(ulongint,1000ull)
    dim as ulongint va = 9667306134726983963ull, vb = 1000ull
    print "149 ulongint mod: "; K149; G149; st; cast(ulongint, va mod vb)
end sub
const K150 = cast(ulongint,16359719380160987881ull) mod cast(ulongint,7ull)
dim shared as ulongint G150 = cast(ulongint,16359719380160987881ull) mod cast(ulongint,7ull)
sub S150()
    static as ulongint st = cast(ulongint,16359719380160987881ull) mod cast(ulongint,7ull)
    dim as ulongint va = 16359719380160987881ull, vb = 7ull
    print "150 ulongint mod: "; K150; G150; st; cast(ulongint, va mod vb)
end sub
const K151 = cast(ulongint,16162026870019197517ull) and cast(ulongint,458113948061955586ull)
dim shared as ulongint G151 = cast(ulongint,16162026870019197517ull) and cast(ulongint,458113948061955586ull)
sub S151()
    static as ulongint st = cast(ulongint,16162026870019197517ull) and cast(ulongint,458113948061955586ull)
    dim as ulongint va = 16162026870019197517ull, vb = 458113948061955586ull
    print "151 ulongint and: "; K151; G151; st; cast(ulongint, va and vb)
end sub
const K152 = cast(ulongint,17523661065289420305ull) and cast(ulongint,8315059900618936073ull)
dim shared as ulongint G152 = cast(ulongint,17523661065289420305ull) and cast(ulongint,8315059900618936073ull)
sub S152()
    static as ulongint st = cast(ulongint,17523661065289420305ull) and cast(ulongint,8315059900618936073ull)
    dim as ulongint va = 17523661065289420305ull, vb = 8315059900618936073ull
    print "152 ulongint and: "; K152; G152; st; cast(ulongint, va and vb)
end sub
const K153 = cast(ulongint,13414154530041145799ull) or cast(ulongint,6344944790052461003ull)
dim shared as ulongint G153 = cast(ulongint,13414154530041145799ull) or cast(ulongint,6344944790052461003ull)
sub S153()
    static as ulongint st = cast(ulongint,13414154530041145799ull) or cast(ulongint,6344944790052461003ull)
    dim as ulongint va = 13414154530041145799ull, vb = 6344944790052461003ull
    print "153 ulongint or: "; K153; G153; st; cast(ulongint, va or vb)
end sub
const K154 = cast(ulongint,32122800564186219ull) or cast(ulongint,4670940926086118957ull)
dim shared as ulongint G154 = cast(ulongint,32122800564186219ull) or cast(ulongint,4670940926086118957ull)
sub S154()
    static as ulongint st = cast(ulongint,32122800564186219ull) or cast(ulongint,4670940926086118957ull)
    dim as ulongint va = 32122800564186219ull, vb = 4670940926086118957ull
    print "154 ulongint or: "; K154; G154; st; cast(ulongint, va or vb)
end sub
const K155 = cast(ulongint,7247714302476573465ull) xor cast(ulongint,13939400164408352109ull)
dim shared as ulongint G155 = cast(ulongint,7247714302476573465ull) xor cast(ulongint,13939400164408352109ull)
sub S155()
    static as ulongint st = cast(ulongint,7247714302476573465ull) xor cast(ulongint,13939400164408352109ull)
    dim as ulongint va = 7247714302476573465ull, vb = 13939400164408352109ull
    print "155 ulongint xor: "; K155; G155; st; cast(ulongint, va xor vb)
end sub
const K156 = cast(ulongint,890389300140603689ull) xor cast(ulongint,2746985628259504547ull)
dim shared as ulongint G156 = cast(ulongint,890389300140603689ull) xor cast(ulongint,2746985628259504547ull)
sub S156()
    static as ulongint st = cast(ulongint,890389300140603689ull) xor cast(ulongint,2746985628259504547ull)
    dim as ulongint va = 890389300140603689ull, vb = 2746985628259504547ull
    print "156 ulongint xor: "; K156; G156; st; cast(ulongint, va xor vb)
end sub
const K157 = cast(ulongint,4901816711324761173ull) shl cast(ulongint,47ull)
dim shared as ulongint G157 = cast(ulongint,4901816711324761173ull) shl cast(ulongint,47ull)
sub S157()
    static as ulongint st = cast(ulongint,4901816711324761173ull) shl cast(ulongint,47ull)
    dim as ulongint va = 4901816711324761173ull, vb = 47ull
    print "157 ulongint shl: "; K157; G157; st; cast(ulongint, va shl vb)
end sub
const K158 = cast(ulongint,17638135922908142648ull) shl cast(ulongint,26ull)
dim shared as ulongint G158 = cast(ulongint,17638135922908142648ull) shl cast(ulongint,26ull)
sub S158()
    static as ulongint st = cast(ulongint,17638135922908142648ull) shl cast(ulongint,26ull)
    dim as ulongint va = 17638135922908142648ull, vb = 26ull
    print "158 ulongint shl: "; K158; G158; st; cast(ulongint, va shl vb)
end sub
const K159 = cast(ulongint,1486381441413933221ull) shr cast(ulongint,57ull)
dim shared as ulongint G159 = cast(ulongint,1486381441413933221ull) shr cast(ulongint,57ull)
sub S159()
    static as ulongint st = cast(ulongint,1486381441413933221ull) shr cast(ulongint,57ull)
    dim as ulongint va = 1486381441413933221ull, vb = 57ull
    print "159 ulongint shr: "; K159; G159; st; cast(ulongint, va shr vb)
end sub
const K160 = cast(ulongint,13884274144002638399ull) shr cast(ulongint,62ull)
dim shared as ulongint G160 = cast(ulongint,13884274144002638399ull) shr cast(ulongint,62ull)
sub S160()
    static as ulongint st = cast(ulongint,13884274144002638399ull) shr cast(ulongint,62ull)
    dim as ulongint va = 13884274144002638399ull, vb = 62ull
    print "160 ulongint shr: "; K160; G160; st; cast(ulongint, va shr vb)
end sub
S1()
S2()
S3()
S4()
S5()
S6()
S7()
S8()
S9()
S10()
S11()
S12()
S13()
S14()
S15()
S16()
S17()
S18()
S19()
S20()
S21()
S22()
S23()
S24()
S25()
S26()
S27()
S28()
S29()
S30()
S31()
S32()
S33()
S34()
S35()
S36()
S37()
S38()
S39()
S40()
S41()
S42()
S43()
S44()
S45()
S46()
S47()
S48()
S49()
S50()
S51()
S52()
S53()
S54()
S55()
S56()
S57()
S58()
S59()
S60()
S61()
S62()
S63()
S64()
S65()
S66()
S67()
S68()
S69()
S70()
S71()
S72()
S73()
S74()
S75()
S76()
S77()
S78()
S79()
S80()
S81()
S82()
S83()
S84()
S85()
S86()
S87()
S88()
S89()
S90()
S91()
S92()
S93()
S94()
S95()
S96()
S97()
S98()
S99()
S100()
S101()
S102()
S103()
S104()
S105()
S106()
S107()
S108()
S109()
S110()
S111()
S112()
S113()
S114()
S115()
S116()
S117()
S118()
S119()
S120()
S121()
S122()
S123()
S124()
S125()
S126()
S127()
S128()
S129()
S130()
S131()
S132()
S133()
S134()
S135()
S136()
S137()
S138()
S139()
S140()
S141()
S142()
S143()
S144()
S145()
S146()
S147()
S148()
S149()
S150()
S151()
S152()
S153()
S154()
S155()
S156()
S157()
S158()
S159()
S160()
