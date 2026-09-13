'' A STRING ARGUMENT FOR A 'byref as [const] wstring' CONSTRUCTOR PARAMETER IS WIDE
'' CHARACTERS, on every constructor path: the implicit 'dim x as T = arg', the explicit
'' 'T( arg )', a temporary 'f( T( arg ) )', and 'base( arg )'. Each took an ADDRESS
'' instead -- of a pointer temporary for 'wstr( "Fevrier" )' (len 3, first character
'' 16408, then a crash), or of the narrow text or descriptor (garbage, a crash, or clang
'' refusing the loaded descriptor) -- and 'WS( n & "!" )' was not lowered at all.
''
'' fbc -r:  _ZN2WSC1ERw( &A$0, (uint16*)L"Fevrier" )
''          _ZN2WUC1ERKw( &B$0, (uint16*)L"Mars" )           a narrow literal, widened
''          vr$31 = fb_StrToWstr( (char*)*(char**)&N$0 ) ... _ZN2WUC1ERKw( &E$0,
''          (uint16*)TMP$28$0 ); fb_WstrDelete( (uint16*)TMP$28$0 )
''          _ZN2WUC1ERKw( (struct $2WU*)THIS$1, (uint16*)L"Sept" )      base( "Sept" )
''
'' fbc prints: len: 7 / chr1:70 / str: Fevrier / b: 4 77 Mars / c: 5 Avril / d: 3 Mai /
''   e: 4 Juin / f: 4 Mars / g: 4 Juin / h: 5 Juin! / i: 7 Juillet / j: 7 Juillet /
''   show: 4 Juin / show: 4 Aout / k: 5 aJuin / p: 7 Octobre / q: 4 Sept /
''   r: 8 Novembre / done
type WS
    buf as wstring * 64
    declare constructor( byref w as wstring )
end type
constructor WS( byref w as wstring )
    buf = w
end constructor
type WU
    buf as wstring * 64
    declare constructor( )
    declare constructor( byref w as const wstring )
end type
constructor WU( )
end constructor
constructor WU( byref w as const wstring )
    buf = w
end constructor
type DW extends WU
    declare constructor( byref s as string )
    declare constructor( )
    declare constructor( byval i as integer )
end type
constructor DW( byref s as string )
    base( s )
end constructor
constructor DW( )
    base( "Sept" )
end constructor
constructor DW( byval i as integer )
    base( wstr( "Novembre" ) )
end constructor
function Show( byref u as WU ) as integer
    print "show:"; len( u.buf ); " "; str( u.buf )
    return 0
end function

'' The implicit spelling.
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

'' The explicit spelling, a zstring, a concatenation, and a temporary.
dim as zstring * 16 z = "Juillet"
dim as WU f = WU( "Mars" )
print "f:"; len( f.buf ); " "; str( f.buf )
dim as WU g = WU( n )
print "g:"; len( g.buf ); " "; str( g.buf )
dim as WS h = WS( n & "!" )
print "h:"; len( h.buf ); " "; str( h.buf )
dim as WU i = z
print "i:"; len( i.buf ); " "; str( i.buf )
dim as WU j = WU( z )
print "j:"; len( j.buf ); " "; str( j.buf )
Show( WU( n ) )
Show( WU( "Aout" ) )
dim as WU k = "a" & n
print "k:"; len( k.buf ); " "; str( k.buf )

'' 'base( arg )'.
dim as string o = "Octobre"
dim as DW p = DW( o )
print "p:"; len( p.buf ); " "; str( p.buf )
dim as DW q
print "q:"; len( q.buf ); " "; str( q.buf )
dim as DW r = DW( 11 )
print "r:"; len( r.buf ); " "; str( r.buf )
print "done"
