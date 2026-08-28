'' A WIDE SOURCE FOR A USTRING PARAMETER converts through fb_WstrToUStr. Measured, for
'' the concatenation below fbc emits
''
''   uint16*    vr = fb_WstrConcatWA( W, "z", 2 );
''   FBUSTRING* vu = fb_WstrToUStr( vr );
''   fb_UStrAssign( &TMP, -1, vu, -1, 0 );
''   G( &TMP );
''   fb_UStrDelete( &TMP );
declare function G( byref s as const ustring ) as long

function G( byref s as const ustring ) as long
	return len( s )
end function

dim as wstring * 8 w = "q"
dim as long r1 = G( w )
dim as long r2 = G( w & "z" )
print r1, r2
