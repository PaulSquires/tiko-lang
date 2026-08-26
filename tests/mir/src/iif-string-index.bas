'' AN iif RESULT SUBSCRIPTED, and a WIDE iif in an ordinary expression -- between them
'' the whole of expressions/iif.bas's fourteen declines.
''
'' A NARROW-STRING iif already built its result in a temporary descriptor and handed
'' back that temporary's ADDRESS as its value. What it had no route to was being ASKED
'' for an address: 'iif( c, sa, sb )[0]' takes a subscript, the subscript wants the
'' base's address, and LowerAddr had no case for an iif -- so the whole statement
'' declined even though the value path beside it worked.
''
'' A WIDE iif is a POINTER temporary rather than a descriptor -- measured:
''
''   int64  vr$1 = fb_WstrLen( (uint16*)L"aaaa" );
''   uint16* vr$2 = fb_WstrAlloc( vr$1 );
''   TMP$6$0 = vr$2;
''   fb_WstrAssign( TMP$6$0, 0ll, (uint16*)L"aaaa" );
''   ...
''   fb_WstrDelete( (uint16*)TMP$6$0 );
''
'' -- and that had been buildable all along, but only a caller ALREADY IN A WIDE
'' CONTEXT reached it. In an ordinary expression -- inside len( ) -- nothing routed
'' there and it declined. It is recognised by SHAPE, because Check computes no type for
'' 'wstr( x )' and an iif over two of them is untyped from end to end.
''
'' For a wide string the pointer IS the base a subscript is taken from: there is no
'' descriptor in between, so the address of a wide iif is its value.
dim as long condtrue = 1, condfalse = 0
dim as string sa = "123", sb = "456"
dim as wstring * 8 wa = "123", wb = "456"

print iif( condtrue , sa, sb )[0]
print iif( condfalse, sa, sb )[2]

print len( iif( condtrue , wstr( "aaaa" ), wstr( "b" ) ) )
print len( iif( condfalse, wstr( "aaaa" ), wstr( "b" ) ) )

print iif( condtrue , wa, wb )[0]
print iif( condfalse, wa, wb )[2]
