const as double d1 = 2^63
const as double d2 = 2^63 * 1.5
const as double d3 = 2^64 - 2^(63-52)
const a3 = 2^10
dim as double dv = 1.5
dim as single sv = 1.5
print culngint( d1 )
print culngint( d2 )
print culngint( d3 )
print a3
dim as ulongint u1 = culngint( dv )
dim as ulongint u2 = culngint( sv )
dim as ulong u3 = culng( dv )
dim as longint s1 = clngint( dv )
dim as ushort u4 = cushort( dv )
print u1, u2, u3, s1, u4
