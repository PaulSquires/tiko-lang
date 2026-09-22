'' TKO0803: 'cast( string, x )' takes a var-len STRING that is not a constant, or a UDT
'' casting to one -- fbc's error 20 for everything else. The controls at the bottom are
'' accepted by fbc and must stay quiet.
type HasCast
    v as long
    declare operator cast( ) as string
end type
operator HasCast.cast( ) as string
    return "hc"
end operator
type NoCast
    v as long
end type

const KS = "ks"
dim as string s = "s"
dim as zstring * 8 z = "z"
dim as string * 8 f8 = "f"
dim as ustring u = "U"
dim as long i = 5
dim as HasCast hc
dim as NoCast nc

print cast( string, "lit" )
print cast( string, KS )
print cast( string, "a" & "b" )
print cast( string, chr( 65 ) )
print cast( string, str( 5 ) )
print cast( string, z )
print cast( string, f8 )
print cast( string, u )
print cast( string, s & u )
print cast( string, i )
print cast( string, nc )

'' Accepted by fbc.
print cast( string, s )
print cast( string, s & "t" )
print cast( string, "a" & i )
print cast( string, z & "x" )
print cast( string, KS & s )
print cast( string, chr( i ) )
print cast( string, hex( 255 ) )
print cast( string, ucase( "lit" ) )
print cast( string, hc )
