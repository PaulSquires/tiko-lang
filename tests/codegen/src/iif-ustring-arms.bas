'' A USTRING iif: fb_UStrInit into the temporary in each arm, fb_UStrDelete after.
function MkU( byval s as ustring ) as ustring
    return s & "!"
end function
sub ShowU( byval s as ustring )
    print "arg[" & s & "]"
end sub
dim as ustring r = "C:", q = "xyz"
dim as boolean f = false, t = true
dim as ustring a
a = iif( f, left( r, 1 ), r ) : print "1[" & a & "]"; len( a )
a = iif( t, left( r, 1 ), r ) : print "2[" & a & "]"; len( a )
a = iif( f, r, left( q, 2 ) ) : print "3[" & a & "]"; len( a )
a = iif( t, r, left( q, 2 ) ) : print "4[" & a & "]"; len( a )
a = iif( f, r, q ) : print "5[" & a & "]"
a = iif( t, r, q ) : print "6[" & a & "]"
a = iif( f, ucase( q ), right( r, 1 ) ) : print "7[" & a & "]"
a = iif( t, ucase( q ), right( r, 1 ) ) : print "8[" & a & "]"
a = iif( f, MkU( r ), MkU( q ) ) : print "9[" & a & "]"
a = iif( t, MkU( r ), MkU( q ) ) : print "10[" & a & "]"
dim as ustring d1 = iif( f, mid( q, 2 ), r ) : print "11[" & d1 & "]"
print "12[" & iif( f, left( r, 1 ), r ) & "]"
print iif( f, left( r, 1 ), r )
print len( iif( f, left( r, 1 ), r ) ), len( iif( t, left( r, 1 ), r ) )
a = iif( f, iif( t, left( q, 1 ), q ), iif( f, r, left( r, 1 ) ) ) : print "13[" & a & "]"
a = iif( t, iif( f, left( q, 1 ), q ), r ) : print "14[" & a & "]"
ShowU( iif( f, left( r, 1 ), r ) )
ShowU( iif( t, left( r, 1 ), r ) )
dim as string s1 = iif( f, left( r, 1 ), r ) : print "15[" & s1 & "]"
if iif( f, left( r, 1 ), r ) = "C:" then print "16 eq" else print "16 ne"
dim as string n1 = "n1", n2 = "n22"
dim as string ns = iif( f, left( n1, 1 ), n2 ) : print "17[" & ns & "]"
'' Arms that are ustring CHAINS: Check types '&' STRING, fbc types them USTRING.
for i as integer = 1 to 3
    a = iif( (i and 1) <> 0, left( r, 1 ), r & str( i ) ) : print "18[" & a & "]";
next
print
a = "pre"
a = iif( f, a & "1", a ) : print "19[" & a & "]"
a = iif( t, a & "1", a ) : print "20[" & a & "]"
a = iif( f, q & "x", q & "y" ) : print "21[" & a & "]"
print "22[" & iif( t, q & "x", q & "y" ) & "]"
print iif( f, q & "x", q & "y" ), len( iif( t, q & "x", q & "yy" ) )
dim as ustring d2 = iif( f, "a" & q, 1 & q ) : print "23[" & d2 & "]"
'' A subscript reads a UTF-16 unit of the temporary.
print iif( f, r, q )[1], iif( not f, left( r, 1 ), q )[0]
