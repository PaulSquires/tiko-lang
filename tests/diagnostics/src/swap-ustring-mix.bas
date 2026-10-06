'' fbc's error 20: a ustring swaps only with a ustring (lines 4, 6, 8, 10).
dim as string s = "ss"
dim as ustring u = "uu"
swap s, u
dim as string * 4 f = "ffff"
swap u, f
dim as zstring * 4 z = "zz"
swap z, u
dim as ustring * 4 uf = "uf"
swap s, uf
