'' TKO0802: 'cast( string, x )' over a WIDE x -- fbc's error 20, "Type mismatch", for every
'' spelling of one. The controls at the bottom are accepted by fbc and must stay quiet.
dim as wstring * 10 w = "q"
dim as wstring ptr pw = @w
dim as string s = "s"

print cast( string, w )
print cast( string, "a" & w )
print cast( string, ( w & "a" ) )
print cast( string, wstr( 5 ) )
print cast( string, *pw )
print cast( string, trim( w ) )

'' Accepted by fbc: a narrow string, a narrow chain, and the two conversions that are.
print cast( string, s )
print cast( string, s & "t" )
print str( w )
print type<string>( w )
