'' ASC OVER A USTRING IS LONG, over a STRING ULONG. Measured, fbc-modern: fb_UStrAsc is
'' int32, 'typeof( asc( u ) )' and 'typeof( asc( u, 2 ) )' are LONG and 'typeof( asc( s ) )'
'' is ULONG -- so a positive result prints with its leading sign space for the first two
'' only: ' 35 116 35'. Typed ULONG, tiko printed '35 116 35'.
dim as ustring u = "#t"
dim as string s = "#t"
print asc( u ); asc( u, 2 ); asc( s )
