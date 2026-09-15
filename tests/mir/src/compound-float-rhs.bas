'' A COMPOUND ASSIGNMENT COMPUTES IN THE BINARY OPERATOR'S RESULT TYPE. 'x op= y' is
'' 'x = x op y', and the type the operation runs in is what 'x op y' would be -- not the
'' target's. tiko used the target's, so a floating right-hand side was rounded and
'' converted BEFORE the operation:
''
''     i += 0.5    over an INTEGER     load @i; nearbyint 0.5; fptosi; add i64
''
'' and 'dim as integer i = 1 : i += 0.5' printed 1 where fbc prints 2. Measured, fbc:
''
''     I$0 = fb_D2L( (double)I$0 + 0x1.p-1 );                  integer += double
''     L$0 = fb_D2I( (double)(int64)L$0 + -0x1.p-1 );          long -= double
''     UL$0 = (uint32)fb_F2L( (float)(int64)UL$0 + SBIG$0 );   ulong += single
''     ULI$0 = fb_D2UL( (double)ULI$0 + 0x1.p-1 );             ulongint += double
''     SF$0 = (float)((double)SF$0 + 0x1.999999999999Ap-3);    single += double
''     I$0 = fb_D2L( (double)I$0 / 0x1.p+1 );                  integer /= single
''
'' The RESULT is what is rounded, and an unsigned target takes the unsigned conversion:
'' 'ul += <single 3e9>' is 3000000000, where a signed 32-bit conversion gave 2147483655.
''
'' The integer operators stay integer, with the float operand converted first --
''
''     I$0 = I$0 & 4ll;                                        integer and= 3.5
''     I$0 = I$0 << (2ll & 63ll);                              integer shl= 2.5
''
'' -- but in the PROMOTED integer type, which a narrower target can see:
''
''     L$0 = (int32)((int64)L$0 / 4294967298ll);               long \= longint
''     UB$0 = (uint8)((int64)UB$0 % -3ll);                     ubyte mod= integer
dim as integer i
dim as long l
dim as ulong ul
dim as ulongint uli
dim as ubyte ub
dim as single sf, sbig
dim as double d

i += 0.5
l -= 0.5
ul += sbig
uli += 0.5
sf += d
i /= 2.0f
i and= 3.5
i shl= 2.5
l \= 4294967298LL
ub mod= -3
