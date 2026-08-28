'' DRAW STRING IS NOT DRAW: it takes a COORDINATE and a text where DRAW takes a command
'' string and no coordinates at all, and it goes to a different entry point. Measured,
'' four probes:
''
''   draw string (1,2), "a", 7      fb_GfxDrawString( 0, 1.0f, 2.0f, 4, vr, 7u, 0,0,0,0,0 )
''   draw string step(1,2), "a", 7  ...the flag is 5
''   draw string (1,2), "a"         ...it is -2147483644, the NO-COLOUR sign bit over 4
''   draw string img, (0,0), "z", 3 ...the target is the image
''
'' So the flag is exactly the one-point family's: base 4, bit 0 for STEP, the sign bit
'' when the colour is omitted.
''
'' ...and a WIDE PRINT USING ITEM. 'byref s as wstring' gives s a reference over an
'' UNSIZED wstring, which is neither the array the wide test counts nor anything the
'' type table names -- so the statement declined inside the procedure while the same one
'' over a 'wstring * 8' lowered. fbc emits the same call for both:
'' 'fb_PrintUsingWstr( 0, (uint16*)S$1, -2147483647 )'.
screenres 320, 200, 8
dim as any ptr img = imagecreate( 32, 32 )
draw string (1,2), "a", 7
draw string step(1,2), "a", 7
draw string (1,2), "a"
draw string img, (0,0), "z", 3

sub pu( byref s as wstring )
	print using "&"; s
end sub
pu( "x" )
