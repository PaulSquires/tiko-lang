'' 'draw <target>, <string>' -- DRAW WITH A TARGET IMAGE.
''
'' Every graphics statement but this one is followed by a COORDINATE, and the target
'' parse required one: that is what tells 'circle pp, (x,y)' -- a target -- from
'' 'circle (x,y)', where the expression the target parse just read is really the point.
'' DRAW has no coordinates at all, so the comma is the whole signal, and demanding a
'' point after it backtracked EVERY targeted DRAW into a malformed statement.
''
'' Measured from fbc's C -- the same entry point either way, with a null target for the
'' screen:
''
''     fb_GfxDraw( (void*)0ull, (FBSTRING*)vr$1 );   '' draw "..."
''     fb_GfxDraw( PP$0, (FBSTRING*)vr$2 );          '' draw pp, "..."
''
'' NOT RUN: this needs a graphics screen. It is compiled for its IR, and it names
'' no header -- DRAW is a keyword and 'any ptr' needs nothing declared.

dim pp as any ptr
dim s as string = "C15 M0,0 L8,8"

draw "C15 M0,0 L8,8"
draw pp, "C15 M0,0 L8,8"
draw pp, s
