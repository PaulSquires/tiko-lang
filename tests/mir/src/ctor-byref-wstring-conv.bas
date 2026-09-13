'' A STRING INITIALISER FOR A 'byref as [const] wstring' CONVERTING CONSTRUCTOR PASSES
'' WIDE CHARACTERS. 'dim as WS a = wstr( "Fevrier" )' stored the wide literal's pointer in
'' a temporary and passed the TEMPORARY's address (len 3, first character 16408, then a
'' crash); a narrow literal passed its bytes, and a narrow variable its loaded descriptor,
'' which clang refused.
''
'' fbc -r:  _ZN2WSC1ERw( &A$0, (uint16*)L"Fevrier" )
''          _ZN2WUC1ERKw( &B$0, (uint16*)L"Mars" )
''          vr$31 = fb_StrToWstr( (char*)*(char**)&N$0 ) ... fb_WstrDelete( TMP )
''
'' fbc prints: len: 7 / chr1:70 / str: Fevrier / b: 4 77 Mars / c: 5 Avril / d: 3 Mai /
''             e: 4 Juin / done
type WS
    buf as wstring * 64
    declare constructor( byref w as wstring )
end type
constructor WS( byref w as wstring )
    buf = w
end constructor
type WU
    buf as wstring * 64
    declare constructor( byref w as const wstring )
end type
constructor WU( byref w as const wstring )
    buf = w
end constructor
dim as WS a = wstr( "Fevrier" )
print "len:"; len( a.buf )
print "chr1:"; a.buf[0]
print "str: "; str( a.buf )
dim as WU b = "Mars"
print "b:"; len( b.buf ); " "; b.buf[0]; " "; str( b.buf )
dim as WU c = wstr( "Avril" )
print "c:"; len( c.buf ); " "; str( c.buf )
dim as WS d = WS( wstr( "Mai" ) )
print "d:"; len( d.buf ); " "; str( d.buf )
dim as string n = "Juin"
dim as WU e = n
print "e:"; len( e.buf ); " "; str( e.buf )
print "done"
