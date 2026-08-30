'' THE WIDE RADIX FAMILY RETURNS AN ALLOCATION THE CALLER OWNS, and it was being dropped.
'' Measured: 's = whex( 42 )' into a narrow string is
''
''     uint16* vr = fb_WstrHex_l( 42 );
''     fb_WstrAssignToA( (void*)&S, -1ll, (uint16*)vr, 0 );
''     fb_WstrDelete( (uint16*)vr );
''
'' -- and LowerRadixCall_ left through a bare EmitRtl, so every whex, woct and wbin
'' leaked one temporary. Nothing declined: the statement lowered, verified, and counted.
'' The runtime-call differential over functions/ is what found it, as an fb_WstrDelete
'' fbc emits and tiko-lang did not.
''
'' The NARROW half hands back a temporary DESCRIPTOR and is released by the string
'' temporary machinery, so only the wide one is routed through WideConcatStep_ -- the
'' same helper the wide substring family and 'wspace' already use.
dim s as string
dim as wstring * 64 w

s = whex( 42 )
print s

s = woct( 42 )
print s

s = wbin( 42 )
print s

w = whex( 255 )
print w
