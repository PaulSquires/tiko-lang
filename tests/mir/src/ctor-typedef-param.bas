'' A MEMBER DEFINITION IS PAIRED WITH ITS DECLARATION THROUGH A TYPEDEF. The second
'' constructor is DECLARED over the forward typedef '_TV' and DEFINED over 'TV'; fbc
'' pairs the two. Matched by spelling alone, the definition fell back to the first
'' constructor and took over its scope, so 'TU( )' read '@this' from a second local
'' that nothing stored -- and -O2 deleted the branch (structs/udt-comp-ops-2).
''
'' fbc prints: default not global / from TV / 5
type _TV as TV
type TU
	dim as integer I
	declare constructor()
	declare constructor(byref v as _TV)
end type
type TV
	dim as integer I
end type
dim shared byref_u as TU
constructor TU()
	if( @this <> @byref_u ) then
		print "default not global"
	end if
end constructor
constructor TU(byref v as TV)
	print "from TV"
	I = 5
end constructor
dim as TU u
dim as TV v
dim as TU w = TU( v )
print w.I
