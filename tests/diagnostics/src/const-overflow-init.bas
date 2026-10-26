'' A constant that does not fit its integer target: fbc's warning 25 at lines 4, 6, 8, 10, 12,
'' 16, 19 and 20 (fbc-modern 1.20, 2026-10-25). fbc measures the WIDTH, signed or unsigned, so
'' lines 5, 7, 9, 11, 13, 14 and 17 are silent (by-example BUG-primitives-2).
dim as ubyte a = 256
dim as ubyte b = -1
dim as ubyte c = &h1FF
dim as byte d = 128
dim as byte e = -129
dim as short f = 40000
dim as ushort g = 65536
dim as long h = 3000000000
dim as ulong i = 4294967296
dim as ulong j = -1
dim as ubyte l = 255
dim as byte m = -128
const C1 as ubyte = 300
const C2 as long = 3000000000
dim as ubyte n
n = 256
n = 300 + 1
print a, b, c, d, e, f, g, h, i, j, l, m, C1, C2, n
