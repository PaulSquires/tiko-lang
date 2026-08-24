'' A WSTRING FORMAT FOR 'print using' IS CONVERTED TO A NARROW TEMPORARY.
''
'' This used to be refused with a note calling fbc's shape a bug. It is not one -- the
'' note had the direction of the assignment backwards. Measured:
''
''     fb_WstrAssignToA( &TMP4, -1, L"###", 0 );
''     fb_PrintUsingInit( &TMP4 );
''     fb_StrDelete( &TMP4 );
''     fb_PrintUsingLongint( 0, N, -2147483647 );
''     fb_PrintUsingEnd( 0 );
''
'' -- the narrow temporary is the DESTINATION, Init copies the format out of it, and the
'' temp is released before the items run. wstring/print_using.bas is written entirely in
'' wide formats.
''
'' A WIDE RVALUE WITH NO ADDRESS -- 'wstr( x )' -- is a bare uint16* like any other wide
'' operand, and it reaches the narrow destination through WideOperand_. That test is
'' asked only of a GENUINELY wide term: WideOperand_ answers for shapes that are not
'' wide at all, and letting it claim a narrow source turned four goldens into wide
'' runtime calls over narrow data.
dim as long n = 5
dim as wstring * 8 w = wstr( "###" )

print using wstr( "###" ); n
print using ( wstr( "###" ) ); n
print using w; n
print using ( w ); n

'' ...and the narrow forms beside them, unchanged.
print using "###"; n
dim as string s = "###"
print using s; n
