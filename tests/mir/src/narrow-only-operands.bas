'' DRAW STRING, DRAW and WIDTH's device name have only narrow entry points.
dim as ustring u = "ab"
dim as ustring * 8 uf = "cd"
dim as wstring * 8 w = wstr( "ef" )
dim as wstring ptr pw = @w
dim as zstring * 8 z = "lpt1:"
dim as zstring ptr pz = @z
draw string ( 0, 0 ), u
draw string ( 0, 0 ), uf
draw string ( 0, 0 ), w
draw string ( 0, 0 ), *pw
draw u
width u, 80
width *pz, 80
width *pw, 80
width uf, 80
