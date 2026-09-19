'' A fixed-length string offered { byref const string, byref string }: the same conversion.
declare sub g overload( byref s as const string )
declare sub g( byref s as string )
dim as zstring * 8 zv = "zz"
dim as wstring * 8 wv = "ww"
dim as string sv = "sv"
g( zv )
g( wv )
g( sv )
