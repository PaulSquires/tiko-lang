'' A WIDE CHAIN INITIALISING A FIXED NARROW STRING. Check types '&' STRING.
dim as wstring * 10 w = "q"

dim as zstring * 20 z1 = w & "d"
dim as string * 8 f1 = w & "d"
dim as zstring * 20 zp = ( w & "d" )
dim as zstring * 10 a( 1 ) = { w & "d", "e" & w }

type TT
    z as zstring * 10 = wstr( "a" ) & "b"
end type
dim as TT tv
