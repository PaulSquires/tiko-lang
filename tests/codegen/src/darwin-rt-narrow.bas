'' Narrow integers handed to the RUNTIME -- see darwin-rt-narrow-*.test.
dim as ubyte ub = 200
dim as byte sb = -3
dim as ushort us = 60000
dim as short ss = -4
print cast( ubyte, 300 ); ub; sb; us; ss
print hex( ub ); bin( us )
print cvshort( mkshort( ss ) )
