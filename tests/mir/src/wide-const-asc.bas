'' A WIDE STRING CONSTANT IS ITS TEXT, and ASC over a wide operand has its own entry
'' point.
const WS = wstr( "ab" )
const NS = "AB"

dim as wstring * 8 w
dim as string s = "AB"
dim as long r

w = WS
r = asc( w, 1 )
r = asc( WS, 1 )
r = asc( NS, 1 )
r = asc( s, 1 )
r = asc( s )

print w, r
