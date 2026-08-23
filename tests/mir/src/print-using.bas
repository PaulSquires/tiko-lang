'' PRINT USING. Measured, and the shape is NOT PRINT's:
''
''     vr = fb_StrAllocTempDescZEx( "###.##", 7 )
''     fb_PrintUsingInit( vr )                    <-- NO CHANNEL
''     fb_PrintUsingLongint( 0, n, 0 )
''     fb_PrintUsingStr( 0, &S, -2147483647 )
''     fb_PrintUsingEnd( 0 )
''
'' Init takes only the format descriptor; every item call and End take the channel
'' first. The last item carries 0x80000001 and every earlier one 0 -- a trailing ';'
'' makes the last one 0 as well, because the newline lives in the item's mask.
dim as string f = "###.##"
dim as string s = "ab"
dim as double d = 1.5
dim as long n = 3
dim as ulong u = 4
dim as single g = 2.5
dim as boolean b = true

print using f; d
print using "##_ ##"; n; s
print using f; d;
print using f; u; g; b

'' A CONCATENATION IS A STRING WITH NO ADDRESS, in the format and in an item alike.
'' Asking one for an address declined the whole statement; it is built into a
'' temporary descriptor instead, which is what every other string argument with no
'' lvalue already does. One corpus file writes its entire harness this way.
print using ( f & ", " & f ); n; ( s & "!" )

'' A FILE CHANNEL is lowered once and reused -- Init does not take it, the items and
'' End do.
print #1, using f; d
