'' STR OF A USTRING IS A CONVERSION. fbc's C, and the bytes it prints:
''
''     str( u )          fb_UStrAssignToA( &TMP, -1, U, -1, 0, -1 )     61 62
''     str( u & "c" )    fb_UStrAssignToA( &S1, -1, vr, -1, 0, -1 )     61 62 63
''     str( uf )         fb_UStrAssignToA( &S3, -1, UF, <fixed>, 0, -1 ) 75 66
''
'' tiko printed '61 00', '61 00 62' and nothing: the UTF-16 buffer read as narrow.
sub hexdump( byref label as string, byref s as string )
	print label; " len="; len( s ); ":";
	for i as integer = 0 to len( s ) - 1
		print " "; hex( s[i], 2 );
	next
	print
end sub
function viaParam( byref u as ustring ) as string
	return str( u )
end function
dim as ustring u = "ab"
dim as ustring * 4 uf = "uf"
hexdump( "param", viaParam( u ) )
dim as string s1 = str( u & "c" )
hexdump( "rvalue", s1 )
dim as string s3 = str( uf )
hexdump( "fixed", s3 )
