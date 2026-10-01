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
print a
print "a=" & a
print a & "!"
print a; " "; b
dim as ustring u = a
print u; len( u )
print "b=" & b
dim as string s = "x" & a
print s
s = a
print s; len( s )
dim as ustring u2 = a & a
print u2
print "n=" & a & 5
print a & b
