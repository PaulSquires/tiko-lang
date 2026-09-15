'' A FLOAT INTO A NARROW INTEGER, down every path that stores one. fbc converts a
'' ULONG at 64 bits and truncates -- '(uint32)fb_F2L( s )' -- and a BYTE or SHORT of
'' either signedness at 32 -- '(uint8)fb_F2I( s )'. fbc-modern prints:
''
''     3000000000 -2 3000000000 -2
''     200 60000 0 0 -56 -5536
''     3000000000 3000000000
''     3000000000 200 60000 3000000000
''     3000000000 200 60000 3000000000
''     3000000000 200
''     3000000000 200
''     3000000000 200
''     3000000000 60000
''     3000000000
''     10000000000000000000
''     3000000000
''     3000000000 200
''     3000000000 3000000000
type T
    as ulong f
    as ubyte g
end type
function retul( byval s as single ) as ulong
    return s
end function
function retub( byval d as double ) as ubyte
    function = d
end function
sub takeul( byval v as ulong, byval w as ushort )
    print v; " "; w
end sub

dim as single sbig = 3e9
dim as single sn = -2.5
dim as double dbig = 3e9
dim as double dn = -2.5
dim as single s200 = 200.5
dim as single s60k = 60000.5
dim as double d60k = 60000.5
dim as double dhuge = 1e19

dim as ulong v1 = sbig
dim as long v2 = sn
dim as ulong v3 = dbig
dim as long v4 = dn
dim as ubyte v5 = s200
dim as ushort v6 = s60k
dim as ubyte v7 = dbig
dim as ushort v8 = dbig
dim as byte v9 = s200
dim as short v10 = s60k
dim as uinteger v11 = sbig
dim as ulongint v12 = sbig
print v1; " "; v2; " "; v3; " "; v4
print v5; " "; v6; " "; v7; " "; v8; " "; v9; " "; v10
print v11; " "; v12

dim as ulong a1
a1 = sbig
dim as ubyte a2
a2 = s200
dim as ushort a3
a3 = s60k
dim as ulong a4
a4 = dbig
print a1; " "; a2; " "; a3; " "; a4

print culng( sbig ); " "; cubyte( s200 ); " "; cushort( s60k ); " "; culng( dbig )
print cast( ulong, sbig ); " "; cast( ubyte, s200 )

dim as ulong ul = 7
dim as T t
t.f = sbig : t.g = s200
print t.f; " "; t.g
print retul( sbig ); " "; retub( s200 )
takeul( sbig, d60k )
dim as ulong arr(0 to 1)
arr(1) = dbig
print arr(1)
dim as ulongint uq = dhuge
print uq
dim as ulong ptr p = @ul
*p = sbig
print ul
dim as T t2 = ( sbig, s200 )
print t2.f; " "; t2.g
dim as ulong arr2(0 to 1) = { sbig, dbig }
print arr2(0); " "; arr2(1)
