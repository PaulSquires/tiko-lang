dim s as string
dim l as long
dim pl as long ptr
dim shared gv as integer
#macro chk( cond, tag )
	#if cond
		print tag; " ";
	#else
		print "-"; " ";
	#endif
#endmacro
chk( typeof( s ) = string, "t1" )
chk( typeof( s ) <> STRING, "t2" )
chk( string = typeof( s ), "t3" )
chk( typeof( l ) = "LONG", "t4" )
chk( typeof( l ) = long, "t5" )
chk( typeof( l ) = typeof( long ), "t6" )
chk( typeof( integer ) = typeof( longint ), "t7" )
chk( typeof( pl ) = "LONG PTR", "t8" )
print
chk( name = "NAME", "n1" )
chk( name <> name, "n2" )
chk( undeclaredid = name, "n3" )
chk( undeclaredid = undeclaredid, "n4" )
chk( undeclaredid = UNDECLAREDID, "n5" )
chk( undeclaredid1 = undeclaredid2, "n6" )
chk( undeclaredid, "n7" )
chk( undeclaredid = "UNDECLAREDID", "n8" )
chk( undeclaredid = "undeclaredid", "n9" )
chk( name < namf, "n10" )
print
chk( lcase( "ABC", 1 ) = "abc", "c1" )
chk( ucase( "abc", 1 ) <> "ABC", "c2" )
chk( defined( ..undeclaredid ), "d2" )
chk( defined( ..gv ), "d3" )
print
print
