'' BSAVE AND BLOAD TAKE A STRING DESCRIPTOR, not a char pointer. Measured:
''
''     bsave( "foo.bmp", 0 )
''     vr = fb_StrAllocTempDescZEx( (char*)"foo.bmp", 7ll );
''     fb_GfxBsave( (FBSTRING*)vr, (void*)0ull, 0u, (void*)0ull );
''
'' tiko-lang handed the LITERAL's own address straight to a parameter declared FBSTRING*,
'' so the runtime read a descriptor out of the string's bytes. Nothing declined -- the
'' statement lowered and verified. gfx/bsave-nullptr-fb.bas and -qb.bas are both this, and
'' the runtime-call differential over gfx/ is what found it, as an fb_StrAllocTempDescZEx
'' fbc emits and tiko-lang did not.
''
'' A string VARIABLE was already right, because its address IS its descriptor -- which is
'' what hid this, since the corpus writes the variable form far more often. KILL and the
'' rest of the file family go through the prelude's declared procedures, where the
'' ordinary call path wraps a literal already.
''
'' The RTL signature cannot express the difference: every one of these parameters is 'p'.
dim f as string = "foo.bmp"

bsave( f, 0 )
bsave( "lit.bmp", 0 )

bload( f, 0 )
bload( "lit.bmp", 0 )

'' The same argument through a path that always got it right, for contrast.
kill "x.txt"
kill f
