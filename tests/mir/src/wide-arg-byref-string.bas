'' A WIDE ARGUMENT FOR A 'byref as string' LET OR CONSTRUCTOR IS CONVERTED, not passed.
'' Measured on fbc, 'd = w' over 'operator let( byref s as string )' and
'' 'dim as DWS2 f = w' over 'constructor( byref s as string )' are both
''
''     fb_WstrAssignToA( (void*)&TMP$7$0, -1ll, (uint16*)W$0, 0 );
''     _ZN4DWS2C1ER8FBSTRING( &F$0, &TMP$7$0 );
''     fb_StrDelete( (FBSTRING*)&TMP$7$0 );
''
'' fbc prints: xyz / xy / [xyz] / [xyz] / [xy]
'' tiko passed the 'wstring * 8' bytes (clang refused the module), or the wide literal's
'' address (the let printed nothing), or an empty string (the constructors printed '[]').
type DWS
    as wstring * 32 buf
    declare operator let( byref s as string )
end type
operator DWS.let( byref s as string )
    buf = s
end operator
type DWS2
    as wstring * 32 buf
    declare constructor( byref s as string )
end type
constructor DWS2( byref s as string )
    buf = "[" & s & "]"
end constructor
dim as wstring * 8 w = "xyz"
dim as DWS d
d = w
print d.buf
d = wstr( "xy" )
print d.buf
dim as DWS2 e = DWS2( w )
print e.buf
dim as DWS2 f = w
print f.buf
dim as DWS2 g = DWS2( wstr( "xy" ) )
print g.buf
