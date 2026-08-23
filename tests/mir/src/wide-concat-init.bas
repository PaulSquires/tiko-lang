'' A WIDE SOURCE FOR A NARROW DESTINATION AT ITS DECLARATION.
''
'' The ASSIGNMENT form was already right; the DECLARATION had no route to it at all, so
'' 'dim as string c = w & s' emitted the zeroed descriptor and DROPPED the initialiser
'' -- 119 declines in string/concat.bas, which is the concatenation matrix, every one
'' of them this.
''
'' Measured: fbc builds the WIDE temporary and then transfers it with a DIFFERENT
'' FUNCTION from the assignment's -- fb_WstrAssignToA_Init where a later store takes
'' fb_WstrAssignToA, the same distinction fb_StrInit and fb_StrAssign make. The
'' temporary is deleted afterwards, which a wide temporary always is.
''
''     dim as string c = s + w    fb_WstrConcatAW then fb_WstrAssignToA_Init
''     dim as string c = w + s    fb_WstrConcatWA then fb_WstrAssignToA_Init
''     dim as string c = w + w    fb_WstrConcat   then fb_WstrAssignToA_Init
dim s as string = "S"
dim z as zstring * 10 = "Z"
dim w as wstring * 10 = "W"
dim ps as string ptr = @s
dim pz as zstring ptr = @z
dim pw as wstring ptr = @w

dim as string c1 = s + z
dim as string c2 = z + s
dim as string c3 = s + w
dim as string c4 = w + s
dim as string c5 = w + w
dim as string c6 = *pw + s
dim as string c7 = *ps + *pz
dim as string c8 = w

'' ...and the assignment form beside it, which takes the other entry point.
dim as string r
r = w + s
print c1; c2; c3; c4; c5; c6; c7; c8; r
