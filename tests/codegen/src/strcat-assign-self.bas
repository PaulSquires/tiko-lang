'' A STRING APPENDED TO ITSELF ('s &= s') held bytes from a freed block: the append reallocated
'' the target and then copied from the pointer it had read before. Six doublings of 23 bytes
'' were 272 bytes wrong on Windows and 992 on Linux. Each row builds the same string twice --
'' through the self-append, and through a copy ('u = t : t = u & u') -- and prints how many
'' bytes differ. fbc 1.10.1 prints 0 on every row (the ustring rows are tiko's twin of them).

type T
	as string s
	as ustring u
end type

sub Check( byref tag as string, byref a as string, byref b as string )
	dim as integer bad = 0
	if len( a ) <> len( b ) then bad = -1
	if bad = 0 then
		for i as integer = 0 to len( a ) - 1
			if a[i] <> b[i] then bad += 1
		next
	end if
	print tag; len( a ); bad
end sub

sub SelfRef( byref r as string )
	r &= r
end sub

dim as string seed0 = "Sent over FTP by tiko." & chr( 10 )
dim as string s, t, u

s = seed0 : t = seed0
for i as integer = 1 to 6 : s &= s : u = t : t = u & u : next
Check( "s &= s", s, t )

s = seed0 : t = seed0
for i as integer = 1 to 6 : s += s : u = t : t = u & u : next
Check( "s += s", s, t )

s = seed0 : t = seed0
for i as integer = 1 to 6 : s &= s & "x" : u = t : t = u & u & "x" : next
Check( "s &= s & x", s, t )

dim as T x
x.s = seed0 : t = seed0
for i as integer = 1 to 6 : x.s &= x.s : u = t : t = u & u : next
Check( "x.s &= x.s", x.s, t )

s = seed0 : t = seed0
for i as integer = 1 to 6 : SelfRef( s ) : u = t : t = u & u : next
Check( "r &= r", s, t )

dim as string ptr p = @s
s = seed0 : t = seed0
for i as integer = 1 to 6 : *p &= *p : u = t : t = u & u : next
Check( "*p &= *p", s, t )

dim as ustring us = seed0, ut = seed0, uu
for i as integer = 1 to 6 : us &= us : uu = ut : ut = uu & uu : next
Check( "u &= u", str( us ), str( ut ) )

x.u = seed0 : ut = seed0
for i as integer = 1 to 6 : x.u &= x.u : uu = ut : ut = uu & uu : next
Check( "x.u &= x.u", str( x.u ), str( ut ) )
