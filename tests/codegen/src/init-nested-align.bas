type P
	as long x, y
end type
type Q
	as P p
	as long z
end type
type foo field = 1
	pad as integer
	f1(0 to 2) as ubyte
	f3(0 to 1) as uinteger
end type
dim shared as Q sq = ( ( 1 ), 3 )
dim shared as foo sa = ( 1, { 2 }, { 5, 6 } )
dim shared as P sarr(0 to 2) = { ( 1 ), ( 2, 3 ), ( 4 ) }
static shared as Q sq2 = ( 7, 8, 9 )
print sq.p.x; sq.p.y; sq.z
print sa.pad; sa.f1(0); sa.f1(1); sa.f1(2); sa.f3(0); sa.f3(1)
print sarr(0).x; sarr(0).y; sarr(1).x; sarr(1).y; sarr(2).x; sarr(2).y
print sq2.p.x; sq2.p.y; sq2.z
sub t
	dim as P larr(0 to 2) = { ( 1 ), ( 2, 3 ), ( 4 ) }
	print larr(0).x; larr(0).y; larr(1).x; larr(1).y; larr(2).x; larr(2).y
	static as Q stq = ( ( 5 ), 6 )
	print stq.p.x; stq.p.y; stq.z
end sub
t
