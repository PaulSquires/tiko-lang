type P16d : a as double : b as double : end type
type P16i : a as longint : b as longint : end type
type P16m : a as double : b as longint : end type

extern "C"
declare function regx( byval a1 as double, byval a2 as double, byval a3 as double, byval a4 as double, _
    byval a5 as double, byval a6 as double, byval a7 as double, byval s as P16d, byval z as double ) as double
declare function regi( byval a1 as longint, byval a2 as longint, byval a3 as longint, byval a4 as longint, _
    byval a5 as longint, byval s as P16i, byval k as longint ) as longint
declare function regm( byval i1 as longint, byval i2 as longint, byval i3 as longint, byval i4 as longint, _
    byval i5 as longint, byval d1 as double, byval d2 as double, byval d3 as double, byval d4 as double, _
    byval d5 as double, byval d6 as double, byval d7 as double, byval d8 as double, _
    byval s as P16m, byval k as longint ) as double
declare function call_regx( byval f as function cdecl ( byval as double, byval as double, byval as double, _
    byval as double, byval as double, byval as double, byval as double, byval as P16d, byval as double ) as double ) as double
end extern

function myregx cdecl ( byval a1 as double, byval a2 as double, byval a3 as double, byval a4 as double, _
    byval a5 as double, byval a6 as double, byval a7 as double, byval s as P16d, byval z as double ) as double
    return a7 + s.a * 100 + s.b * 1000 + z * 10000
end function

dim s as P16d : s.a = 2 : s.b = 3
print "regx"; regx( 0, 0, 0, 0, 0, 0, 1, s, 4 ); "  expect 43201"
dim si as P16i : si.a = 2 : si.b = 3
print "regi"; regi( 0, 0, 0, 0, 1, si, 4 ); "  expect 43201"
dim sm as P16m : sm.a = 2 : sm.b = 3
print "regm"; regm( 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, sm, 4 ); "  expect 43201"
print "cbx"; call_regx( @myregx ); "  expect 43201"
