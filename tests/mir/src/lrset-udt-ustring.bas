'' LSET and RSET through a UDT's own 'operator cast', and into a USTRING.
''
'' Measured from fbc's C: there is NO runtime entry point for the UDT at all. The cast
'' operator is an ordinary member call returning a bare char* / uint16*, and from that
'' point the lowering is byte-identical to a plain 'zstring * N' / 'wstring * N' --
''
''     char* vr$0 = _ZN2UZcvcEv( &U2 );
''     fb_StrAllocTempDescZ( (char*)vr$0 );
''     fb_StrAllocTempDescZ( (char*)vr$1 );        '' the DESTINATION too
''     fb_StrLset( vr$2, (FBSTRING*)vr$0 );
''
'' -- so the destination borrows a temporary descriptor over the operator's result
'' exactly as a zstring variable borrows one over its own bytes. Every one of these
'' declined: the destination has an address, but it is the address of a STRUCT.
''
'' A USTRING destination is the one that was WRONG rather than absent. It fell through
'' to fb_StrLset and passed an FBUSTRING where an FBSTRING belongs -- it lowered, it
'' verified, and it was wrong. Measured, it takes four arguments and its source is
'' transcoded first:
''
''     FBUSTRING* vr$0 = fb_WstrToUStr( (uint16*)W2 );
''     fb_UStrLset( (void*)UX, -9223372036854775800ll, (void*)vr$0, -1ll );
''
'' with fb_StrToUStr( Z2, 50ll ) for a narrow source, and a var-length ustring passing
'' -1 where a fixed one passes its tag.
''
'' NOT MODELLED, and stated rather than hidden: fbc accepts an lset destination of this
'' shape only when the UDT EXTENDS zstring or wstring -- the same type without the
'' 'extends' is error 24, "Invalid data types". tiko-lang asks only for the cast
'' operator, so it accepts a program fbc rejects. That is the safe direction of the two
'' and closing it needs the base chain, not the operator.
''
'' A USTRING SOURCE is not legal for lset in any spelling: fbc answers error 24 for
'' every one, so there is nothing to model and this declines it.
''
'' Run under fbc the six prints give, in order:
''
''     [XY      ]  [      XY]  [XY      ]  [X Y             ]  [            X Y ]  [X Y             ]

type UZ extends zstring
	d as zstring * 16
	declare operator cast( ) byref as zstring
end type
operator UZ.cast( ) byref as zstring
	operator = *cast( zstring ptr, @d )
end operator

type UW extends wstring
	d as wstring * 16
	declare operator cast( ) byref as wstring
end type
operator UW.cast( ) byref as wstring
	operator = *cast( wstring ptr, @d )
end operator

dim z1 as zstring * 16 = "abcdefgh"
dim z2 as zstring * 16 = "XY"
dim w1 as wstring * 16 = wstr( "abcdefgh" )
dim w2 as wstring * 16 = wstr( "XY" )
dim u1 as UZ, u2 as UZ
dim v1 as UW, v2 as UW
u1.d = z1 : u2.d = z2
v1.d = w1 : v2.d = w2

lset (u1) = (z2) : print "["; u1; "]"
u1.d = z1
rset (u1) = (z2) : print "["; u1; "]"
u1.d = z1
lset (u1) = (u2) : print "["; u1; "]"

lset (v1) = (w2) : print "["; v1; "]"
v1.d = w1
rset (v1) = (w2) : print "["; v1; "]"
lset (w1) = (v2) : print "["; w1; "]"

'' The ustring destinations. Their runtime rendering is not asserted here -- the
'' golden's calls are what this file is about.
dim uv as ustring
dim ux as ustring * 9
lset uv = z2
lset ux = w2
rset ux = z2
