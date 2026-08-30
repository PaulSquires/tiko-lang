'' GET AND PUT OVER A FIXED WIDE STRING ARE NOT SYMMETRIC. Measured, over a
'' 'wstring * 8' at position 0:
''
''     get:  fb_FileGetWstrLarge( 1, 0ll, (uint16*)W$0, 8ll );
''     put:  fb_FilePutStrLarge ( 1, 0ll, (void*)W$0,   8ll );
''
'' -- the WIDE entry point on the way in and the NARROW one on the way out, with the
'' same count in both: the DECLARED CHARACTER count, not a byte size.
''
'' Without the wide row a fixed wstring fell through to the byte-count path and was read
'' with fb_FileGetLarge: raw bytes into a UTF-16 buffer, lowered and verified.
dim as wstring * 8 w
dim as string s
dim as long v
open "t.dat" for binary as #1
get #1, , w
put #1, , w
get #1, , s
get #1, , v
close #1
