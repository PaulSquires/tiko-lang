type V
    x as long
    y as long
    declare operator cast( ) as ustring
end type
operator V.cast( ) as ustring
    return "(" & x & ", " & y & ")"
end operator
type W
    n as long
    declare operator cast( ) as long
    declare operator cast( ) as ustring
end type
operator W.cast( ) as long
    return n
end operator
operator W.cast( ) as ustring
    return "w" & n
end operator
dim as V a = ( 4, 6 )
dim as W b = ( 3 )
print ucase( a ); " "; lcase( a ); " "; ucase( "q" & a )
print left( a, 2 ); " "; right( a, 2 ); " "; mid( a, 2, 3 ); " "; mid( "z" & a, 3 )
print trim( a ); ltrim( a ); rtrim( a ); trim( "  " & a & "  " )
print str( a ); " "; str( b ); len( str( a ) )
print len( a ); asc( a ); instr( a, "6" ); instrrev( a, "," ); instr( 2, "(4, 6)", a )
write a
write a, 5, b
dim as string t = str( a )
print t
dim as ustring u3 = ucase( a )
print u3
dim as string s3 = left( a, 2 )
print s3
print ucase( a ) & "!"; ucase( b ); left( b, 1 )
