'' Phase 1 of int128 refuses each path that would take only its low 64 bits (TKO1100).
type B
    as int128 f : 3
end type
declare function v cdecl ( byval n as long, ... ) as long
dim as int128 x = 5
print using "###"; x
print hex( x )
input x
read x : data 5
dim as wstring * 50 w = wstr( x )
print v( 1, x )
