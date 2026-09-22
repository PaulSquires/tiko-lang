'' A UTF-16 SOURCE INTO A NARROW DESTINATION TRANSCODES: fb_UStrAssignToA.
dim as ustring u = "UVW"
dim as wstring * 10 w = "q"
dim as ustring * 8 uf = "fx"

'' A ustring chain with a WIDE term, into a var-len string at its declaration.
dim as string s = u & w
dim as string s2 = "a" & w & u & "b"

'' Into fixed narrow strings: a ustring, a chain, a 'ustring * N', an intrinsic.
dim as zstring * 20 z1 = u
dim as string * 8 f1 = u
dim as zstring * 20 z2
z2 = u
dim as zstring * 20 z3 = u & w
dim as zstring * 20 z5 = uf
dim as zstring * 20 z6 = ucase( u )
