'' 'chr' and 'wchr' FOLD AS CONSTANTS, both variadic. Measured, one probe:
''
''   const a = chr( 65, 66 )    fb_StrInit( &S, -1, "AB", 3, 0 )
''   const b = wchr( 65, 66 )   fb_UStrInit( &U, -1,
''                                  (uint16[]){0x0041,0x0042,0x0000}, ... )
''   const c = wchr( &hE9 )     (uint16[]){0x00E9,0x0000}
const a = chr( 65, 66 )
const b = wchr( 65, 66 )
const c = wchr( &hE9 )
dim as string s = a
dim as ustring u = b
dim as ustring v = c
print s, u, v
