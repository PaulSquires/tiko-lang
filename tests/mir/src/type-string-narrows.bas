'' 'type<string>( e )' OVER A WIDE OR UTF-16 e IS A NARROW CONVERSION; over a narrow e
'' it is still the identity.
dim as wstring * 10 w = "q"
dim as ustring u = "U"
dim as string t = "T"

print type<string>( "a" & w )
print type<string>( w ) & "b"
dim as string s1 = type<string>( "a" & w ) & "b"
print type<string>( "a" & u ) & "b"
print str( "a" & w ) & "b"

'' The narrow control: no conversion at all.
dim as string s2 = type<string>( t )
