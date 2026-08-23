'' A VAR-LENGTH STRING SUBSCRIPTED IS ITS CHARACTER, and its base is the DATA POINTER
'' LOADED OUT OF THE DESCRIPTOR rather than the descriptor's own address -- a descriptor
'' is not a character array. Measured:
''
''     s[1]   over 'string'    *(uint8*) ((uint8*)*(char**)&S$0   + 1ll)
''     u[1]   over 'ustring'   *(uint16*)((uint8*)*(uint16**)&U$0 + 2ll)
''
'' NEITHER FLAVOUR HAD A CASE, in the type system or in lowering. The character-size
'' helper answers 0 for both descriptors, so they fell through to the POINTER path,
'' whose type test then refused them -- and Check typed only the ARRAY spelling, so
'' 's[i]' was UNTYPED, which is what makes an assignment decline rather than store
'' somewhere wrong. A read declined and a write stored nowhere.
''
'' 's[i]' is ordinary FreeBASIC, and fb/tuiwidth.bi builds every surrogate pair by
'' writing two units into a ustring this way.
dim as string s = "ab"
dim as ustring u = "ab"
dim as ulong cp = 65

'' AS AN LVALUE.
s[0] = 65
u[0] = cast( ushort, cp )
u[1] = cast( ushort, &hDC00 + ( cp and &h3FF ) )

'' AND AS AN RVALUE. UNSIGNED, for the same reason the fixed flavours are: a sign
'' extension would turn a wide character above 0x7FFF negative.
dim as long a = s[1]
dim as long b = u[1]

'' The FIXED spellings beside them, which already worked and must keep working.
dim as zstring * 8 z = "cd"
dim as wstring * 8 w = wstr( "cd" )
dim as ustring * 8 f = "cd"
z[0] = 65
w[0] = 66
f[0] = 67
dim as long zc = z[1]
dim as long wc = w[1]
dim as long fc = f[1]
print a, b, zc, wc, fc
