'' THREE STATEMENTS THAT WERE NEVER DISPATCHED, each with its RTL entry already
'' declared. Measured, one probe each:
''
''   seek #1, 2                fb_FileSeekLarge( 1, 2ll )
''   write #1, wstr( "W" )     fb_WriteWstr( 1, (uint16*)L"W", 1 )
''   color 1, 2                fb_Color( 1, 2, 0u )
''
'' COLOR's third argument is a mask of what was OMITTED, which is the whole of what
'' makes the four spellings differ:
''
''   color 1, 2   ( 1, 2, 0 )      color 3   ( 3, 0, 2 )
''   color , 4    ( 0, 4, 1 )      color     ( 0, 0, 3 )
open "seek-color-write.tmp" for output as #1
write #1, wstr( "W" )
write #1, "a", 1
close #1

open "seek-color-write.tmp" for binary as #1
seek #1, 2
close #1

color 1, 2
color 3
color , 4
color
