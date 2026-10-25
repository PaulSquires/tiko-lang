'' A pointer for a BYREF wide or fixed-length string parameter: fbc's 58 for 'byref const
'' wstring' (fbc-modern 1.20, 2026-10-25), and a ustring the same -- TKO0698 at lines 9, 10
'' and 11. A 'string' parameter was already refused (line 12). tiko used to say nothing and
'' stop on TKO0994 (tiko-editor TE-004).
sub PU( byref s as const ustring ) : end sub
sub PW( byref s as const wstring ) : end sub
sub PS( byref s as const string ) : end sub
dim as ustring a = "x" : dim as wstring * 8 w = "y" : dim as string b = "z"
PU( cast( wstring ptr, strptr( a ) ) )
PW( @w )
PU( @w )
PS( cast( zstring ptr, strptr( b ) ) )
