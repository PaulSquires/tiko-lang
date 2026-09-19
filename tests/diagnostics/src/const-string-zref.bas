'' A const string offered 'byref as zstring' beside another string overload.
declare sub f1 overload( byval s as string )
declare sub f1( byref s as zstring )
declare sub f2 overload( byval s as zstring ptr )
declare sub f2( byref s as zstring )
declare sub f3 overload( byref s as zstring )
declare sub f3( byval s as wstring ptr )
dim as const string cs = "cs"
f1( cs )
f2( cs )
f3( cs )
f1( "lit" )
