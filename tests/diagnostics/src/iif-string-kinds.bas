'' See ../iif-string-kinds.test.
dim as ustring u = "u"
dim as wstring * 8 w = "w"
dim as string s = "s"
dim as zstring * 8 z = "z"
dim as boolean c = true
print iif( c, "lit", u )
print iif( c, u, "lit" )
print iif( c, s, u )
print iif( c, z, u )
print iif( c, "lit", w )
print iif( c, s, w )
print iif( c, u, w )
print iif( c, u, u )
print iif( c, "a", "b" )
print iif( c, s, z )
print iif( c, wstr( "x" ), u )
dim as ustring r = iif( c, "lit", u )
const K = 1
print iif( -1, w, "lit" )
print iif( 0, "lit", u )
print iif( K, u, "x" )
print iif( true, w, s )
