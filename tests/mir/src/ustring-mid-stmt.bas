'' THE MID STATEMENT OVER A USTRING has its own entry point, and it used to decline.
'' Measured:
''
''     mid( a, 2 ) = b        fb_UStrAssignMid( &A, -1, 2, -1, &B, -1 )
''     mid( a, 5, 2 ) = b     fb_UStrAssignMid( &A, -1, 5,  2, &B, -1 )
''
'' -- six arguments, a (pointer, length) pair at each end, -1 meaning 'as declared', and
'' an omitted length -1 rather than 0. Handing a UTF-16 descriptor to the narrow
'' fb_StrAssignMid would write UTF-8 bytes into it, so declining was right until the row
'' existed; what was wrong is that it stayed declined.
''
'' fb/string.bi's own Join writes two of these -- 'mid( res, at, len( delim ) ) = delim'
'' and 'mid( res, at, pl ) = parts[ i ]' -- so all eight string/fbstr_*.bas corpus files
'' declined two statements each on a line in a shipped header.
''
'' A NARROW SOURCE STILL DECLINES: fbc converts it first, and that conversion is not
'' modelled here. Passing the bytes across would be the encoding mistake this file
'' exists to avoid.
dim as ustring a = "abcdefgh"
dim as ustring b = "XY"

mid( a, 2 ) = b
print a

mid( a, 5, 2 ) = b
print a
