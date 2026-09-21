'' LINE INPUT'S PROMPT IS ANY STRING EXPRESSION, not only a literal: 'line input p; s'
'' was TKO0420. And the separator after it decides the "? " -- ';' adds it and ','
'' does not -- which was dropped: every LINE INPUT passed 0. Measured from fbc's C:
''
''   line input p; s          fb_LineInput( &P, &S, -1, 0, -1, -1 )
''   line input p, s          fb_LineInput( &P, &S, -1, 0,  0, -1 )
''   line input; p; s         fb_LineInput( &P, &S, -1, 0, -1,  0 )
dim as string p = "name", s
line input p; s
line input p, s
line input; p; s
