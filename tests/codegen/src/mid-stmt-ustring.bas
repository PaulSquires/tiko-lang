function Rep( ) as string
    return "##"
end function
dim as ustring u = "abcdefgh"
mid( u, 2, 3 ) = "XYZ"
print u
mid( u, 7 ) = "QRSTUV"
print u
mid( u, 1, 2 ) = "1"
print u
dim as string s = "abcdefgh"
dim as ustring v = "héllo wörld"
mid( v, 2, 4 ) = "ÉLLÖ"
print v; len( v )
dim as ustring w2 = "abc"
mid( w2, 2 ) = s
print w2
dim as wstring * 8 wsrc = "WW"
dim as ustring t = "abcdefgh"
mid( t, 1, 2 ) = wsrc
mid( t, 3 ) = "x" & "y"
mid( t, 5, 2 ) = Rep( )
mid( t, 20 ) = "zz"
mid( t, 2, 0 ) = "QQ"
print t
mid( t, 8, 5 ) = "LONGER"
print t; len( t )
dim as ustring e = "a😀b"
mid( e, 2, 2 ) = "XY"
print len( e ); asc( e, 2 )
dim as zstring * 8 z = "zz"
dim as ustring u2 = "123456"
mid( u2, 2 ) = z
print u2
dim as ustring us = "ÄÖ"
dim as string s2 = "abcdef"
mid( s2, 2 ) = us
print s2
dim as zstring * 10 z2 = "abcdef"
mid( z2, 3 ) = us
print z2
dim as wstring * 10 w = "abcdef"
mid( w, 2, 1 ) = us
print len( w ); asc( w, 2 ); asc( w, 3 )
dim as ustring * 10 uf = "abcdef"
mid( uf, 2, 2 ) = "ZZ"
print uf
mid( uf, 4 ) = us
print uf
