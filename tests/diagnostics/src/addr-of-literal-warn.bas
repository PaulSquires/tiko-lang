'' '@"lit"' is a 'zstring ptr', so fbc-modern's warning 4 falls on the STRING PTR target
'' and nowhere else (-w all, measured). tiko typed the literal's address 'string ptr' and
'' warned the other way round.
dim as zstring ptr zp = @"zp"
dim as const zstring ptr czp = @"czp"
dim as any ptr ap = @"ap"
dim as ubyte ptr bp = @"bp"
dim as string ptr sp = @"sp"
dim as zstring ptr zq = iif( zp <> 0, @"a", @"b" )
dim as zstring ptr zr = @(("r"))
