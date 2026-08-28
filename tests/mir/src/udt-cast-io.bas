'' A UDT ITEM IS ITS 'operator cast', not its bytes -- the rule PRINT already followed
'' and WRITE and PRINT USING did not, so both declined the whole statement. And the two
'' take DIFFERENT overloads. Measured, over a type declaring a STRING cast and a DOUBLE
'' one:
''
''   print l                 vr$2 = _ZN1Tcv8FBSTRINGEv( &L ); fb_PrintString
''   write l                 vr$4 = _ZN1Tcv8FBSTRINGEv( &L ); fb_WriteString
''   print using "#.##"; l   vr$7 = _ZN1TcvdEv( &L );         fb_PrintUsingDouble
type T
	as long v
	declare operator cast( ) as string
	declare operator cast( ) as double
end type
operator T.cast( ) as string
	return "S" & str( this.v )
end operator
operator T.cast( ) as double
	return this.v + 0.5
end operator
dim as T l
l.v = 3
print l
write l
print using "#.##"; l
