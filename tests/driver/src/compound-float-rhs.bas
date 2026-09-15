'' A COMPOUND ASSIGNMENT RUNS IN THE BINARY OPERATOR'S RESULT TYPE, not the target's.
'' 'i += 0.5' over an INTEGER is 'i = i + 0.5': the target is promoted to double, the
'' add is a double add, and only the RESULT is rounded and converted back. tiko rounded
'' the 0.5 to 0 first and added integers -- it printed ' 1 3 0' for the first three
'' lines where fbc prints ' 2 2 2'. Measured, fbc's C:
''
''     I$0 = fb_D2L( (double)I$0 + 0x1.p-1 );
''     L$0 = fb_D2I( (double)(int64)L$0 + -0x1.p-1 );
''     UL$0 = (uint32)fb_F2L( (float)(int64)UL$0 + SBIG$0 );
''     UB$0 = (uint8)((int64)UB$0 % -3ll);
''
'' The last is the integer half of the same rule: a narrower target is promoted to
'' INTEGER before '\', 'mod' and the bitwise operators, so 'ub mod= -3' is 2 and not
'' the 200 an unsigned byte remainder gives.
''
'' Built to an executable because '--dump-ir' stops before the emitter; build/goldenrun.sh
'' runs it beside fbc. fbc prints, one per line:
''     a 2 / b 2 / c 2 / d3000000000 / e4 / f26 / g-126 / h 2 / i0 / j 2 / k8 / l 4
''     m 8 / n 1 / o 4 / p 16 / q 4 / r 12 / s 12 / t 0 / u4294967286 / v2 / w 7
''     x2147483649 / y 0.3333333 / z 0.3 / A 1.5 / B 2 / C1 / D3000000000
''     E10000000000000000000 / F-128 / G63 / H 25
dim as integer i
dim as long l
dim as ulong ul
dim as ubyte ub
dim as byte b
dim as short sh
dim as ushort us
dim as longint li
dim as ulongint uli
dim as single sbig = 3e9
dim as single sf
dim as double d

'' Floating right-hand sides: the operation happens in single or double.
i = 1 : i += 0.5 : print "a"; i
l = 3 : l -= 0.5 : print "b"; l
i = 10 : i *= 0.25 : print "c"; i
ul = 7 : ul += sbig : print "d"; ul
ub = 200 : ub += 60.4 : print "e"; ub
ub = 10 : ub *= 2.6 : print "f"; ub
b = 100 : b += 30.5 : print "g"; b
sh = 5 : sh /= 2.0 : print "h"; sh
us = 65535 : us += 0.5 : print "i"; us
li = 1 : li += 0.5 : print "j"; li
uli = 7 : uli += 0.5 : print "k"; uli
i = 7 : i /= 2.0f : print "l"; i

'' Integer operators convert a floating operand to an integer and stay integer.
i = 17 : i \= 2.5 : print "m"; i
i = 17 : i mod= 2.5 : print "n"; i
i = 1 : i shl= 2.5 : print "o"; i
i = 64 : i shr= 1.5 : print "p"; i
i = 7 : i and= 3.5 : print "q"; i
i = 8 : i or= 3.5 : print "r"; i
i = 8 : i xor= 3.5 : print "s"; i

'' A narrower integer target is promoted too, which '\' and 'mod' can see.
l = 10 : l \= 4294967298LL : print "t"; l
ul = 10 : ul \= -1 : print "u"; ul
ub = 200 : ub mod= -3 : print "v"; ub
l = 7 : l mod= 4294967299LL : print "w"; l
ul = 4294967295 : ul \= -2 : print "x"; ul

'' A single target with a double right-hand side works in double.
sf = 1 : sf /= 3.0 : print "y"; sf
sf = 0.1f : sf += 0.2 : print "z"; sf
d = 1 : d += 0.5f : print "A"; d
i = 3 : i -= 0.5f : print "B"; i
ub = 3 : ub \= 1.5 : print "C"; ub
ul = 3000000000 : ul -= 0.5 : print "D"; ul
uli = 10000000000000000000ull : uli += 0.5 : print "E"; uli
b = -128 : b \= -1 : print "F"; b
ub = 255 : ub shr= 1.5 : print "G"; ub
i = 5 : i ^= 2 : print "H"; i
