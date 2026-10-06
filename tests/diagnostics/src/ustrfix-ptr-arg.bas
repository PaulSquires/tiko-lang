sub ppz( byval x as zstring ptr ) : end sub
sub ppw( byval x as wstring ptr ) : end sub
dim as ustring * 8 uf = "ab"
ppz( uf )
ppw( uf )
dim as ustring u = "ab"
ppz( u )
ppw( u )
