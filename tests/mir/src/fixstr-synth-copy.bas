'' A FIXED-LENGTH STRING FIELD IS COPIED by a synthesised 'operator let' and copy
'' constructor.
''
'' Col has a constructor, so Cell needs a synthesised let and copy constructor -- and
'' those copied every field EXCEPT the four fixed-length strings, which are character
'' arrays underneath with no bounds to count. Measured: fbc prints '2 5' twice, tiko
'' printed '0 5'. fb/tuibuffer.bi's TuiCell ('ustring * 4 text' beside a TuiStyle) is
'' the shape, and every blank cell the tui library made came out empty.
''
'' In the golden, each synthesised body loads and stores field 0 -- the zstring -- where
'' it used to compute both addresses and then copy nothing.

type Col
	as ubyte kind
	declare constructor( )
end type
constructor Col( )
	kind = 1
end constructor

type Cell
	as zstring * 4 z
	as wstring * 4 w
	as ustring * 4 u
	as string * 4 s
	as Col fg
	as long n
end type

dim as Cell a
a.z = "xy" : a.w = "xy" : a.u = "xy" : a.s = "xy" : a.n = 5
dim as Cell b = a
print len( b.z ); b.n
dim as Cell c
c = a
print len( c.u ); c.n
