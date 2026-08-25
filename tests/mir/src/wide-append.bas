'' APPENDING TO A FIXED WIDE STRING, in every source flavour there is.
dim s as wstring * 80
dim w as wstring * 8
dim as string n = "x"
dim as long i = 5
dim as double d = 1.5
dim b as boolean

w = wstr( "w" )
s = wstr( "a" )

'' a wide RVALUE -- a call, which has no address
s += wstr( "2" )
s &= trim( w )

'' a wide VARIABLE
s &= w

'' a NARROW source: through the mixed entry point and back
s &= "lit"
s &= n

'' a NUMBER and a BOOLEAN: rendered wide into a temporary first
s &= i
s &= d
s &= b

print s
