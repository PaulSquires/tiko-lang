'' A COMMA AFTER INPUT'S PROMPT SUPPRESSES THE "? ". The parser did not record which
'' separator it saw, so the lowering always asked for the question mark. fbc:
''
''   input "age", a     fb_ConsoleInput( prompt, 0, -1 )
''   input "age"; a     fb_ConsoleInput( prompt, -1, -1 )
dim as long a
input "age", a
