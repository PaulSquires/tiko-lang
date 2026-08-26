'' 'mid( dst, start [, len ] ) = value' -- MID AS AN ASSIGNMENT TARGET, which was not
'' lowered at all. The whole statement produced NOTHING and the string was left
'' untouched, with the decline counted but the destination silently unchanged.
'' string/mid_set.bas is eighteen of them.
''
'' Measured, every destination shape, and the DESTINATION is where they differ -- the
'' runtime call always wants a DESCRIPTOR:
''
''   string s            fb_StrAssignMid( &S$0, ... )
''   string ptr *ps      fb_StrAssignMid( PS$0, ... )        -- already a descriptor
''   *strptr( s )        fb_StrAllocTempDescZ( *(char**)&S$0 )   then Mid over that
''   zstring * 8 z       fb_StrAllocTempDescZ( (char*)Z$0 )      then Mid over that
''   zstring ptr *pz     fb_StrAllocTempDescZ( (char*)PZ$0 )     then Mid over that
''   string * 8 f        fb_StrAllocTempDescF( (void*)F$0, <tagged 8> )
''   wstring * 8 w       fb_WstrAssignMid( (uint16*)W$0, 8, start, len, src )
''
'' -- so a char BUFFER is wrapped in a temporary descriptor and a real descriptor is
'' passed as it stands. An OMITTED LENGTH IS -1, not 0 and not the source's length.
''
'' TWO ORDERING FACTS, both of which cost a run. 'mid( s, 1 )' is STRING-TYPED, so the
'' narrow-assignment path claimed it before this one could and then asked an N_CALL for
'' an address -- which is why the WIDE spellings lowered while every narrow one
'' declined. And a VOID RESULT IS STILL A CALL: EmitRtl hands back MV_NONE for one, so
'' reading that as failure declined every MID that had just been emitted.
''
'' SADD IS STRPTR BY ANOTHER NAME -- measured, both emit '*(char**)&S$0' -- and was not
'' implemented, so 'mid( *sadd( s ), 1 )' declined while the strptr line beside it in
'' the same corpus file lowered.
dim as string s = "abcdef", t = "XY"
dim as string ptr ps = @s
dim as zstring * 8 z = "abcdefg"
dim as zstring ptr pz = @z
dim as string * 8 f = "abcdefg"
dim as wstring * 8 w1 = "abcdefg", w2 = "XY"
dim as long n = 2, l = 2

mid( s, 1 ) = "0"
print s
mid( s, n, l ) = t
print s
mid( *@s, 1 ) = "9"
print s
mid( *strptr( s ), 2 ) = "8"
print s
mid( *sadd( s ), 3 ) = "7"
print s
mid( *ps, 4 ) = "6"
print s

mid( z, 1 ) = "0"
print z
mid( *pz, 2 ) = "9"
print z

mid( f, 1 ) = "0"
print f

mid( w1, n ) = w2
print w1
mid( w1, n, l ) = w2
print w1
